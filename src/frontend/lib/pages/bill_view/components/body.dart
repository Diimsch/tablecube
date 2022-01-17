import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/api.dart';
import 'package:frontend/bottom_nav_bar/account_bubble.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/rounded_menu_item.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/bill_view/bill_view.dart';
import 'package:frontend/pages/restaurant_info/components/background.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getBillQuery = r"""
query Query($bookingId: ID!) {
  booking(bookingId: $bookingId) {
    items {
      id
      item {
        id
        name
        description
        price
        type
        available
      }
      paid
    }
  }
}
""";

const String payItems = r"""
mutation Mutation($bookingItemId: [ID!]!) {
  payItems(bookingItemId: $bookingItemId) {
    id
  }
}
""";

class Body extends State<BillScreen> {
  List<bool> selected;
  bool allSelected;
  double balance;
  Body(
      {required this.selected,
      required this.balance,
      required this.allSelected});

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments == null
        ? OverviewArguments('null', 'null', 'null')
        : ModalRoute.of(context)!.settings.arguments as OverviewArguments;

    return Query(
        options: QueryOptions(
          document: gql(getBillQuery),
          variables: {
            'bookingId': args.bookingId,
          },
          pollInterval: const Duration(seconds: 30),
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const SpinKitRotatingCircle(color: Colors.white, size: 50.0);
          }

          // it can be either Map or List
          List items = result.data!['booking']?["items"] ?? List.empty();

          items = items.where((i) => i["paid"] == false).toList();
          calculateBalance(items);

          return Scaffold(
              appBar: AppBar(
                actions: [
                  AccountBubble(click: () {
                    logOutUser();
                  })
                ],
                title: const Text("Pay"),
                centerTitle: true,
                elevation: 0,
                backgroundColor: primaryColor,
              ),
              body: Background(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      allSelected
                          ? IconButton(
                              tooltip: "Deselect all",
                              icon: const Icon(
                                  Icons.indeterminate_check_box_rounded),
                              iconSize: 30,
                              color: primaryColor,
                              padding: const EdgeInsets.all(10),
                              onPressed: () {
                                setAllValues(false);
                              })
                          : IconButton(
                              tooltip: "Deselect all",
                              icon: const Icon(Icons.library_add_check_rounded),
                              iconSize: 30,
                              color: primaryColor,
                              padding: const EdgeInsets.all(10),
                              onPressed: () {
                                setAllValues(true);
                              })
                    ],
                  ),
                  Expanded(
                      flex: 5,
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          // Display the list item
                          if (items.isNotEmpty) {
                            return TextFieldContainer(
                                child: Row(
                              children: [
                                Checkbox(
                                    value: selected[index],
                                    onChanged: (value) {
                                      setState(() {
                                        selected[index] = value!;
                                        calculateBalance(items);
                                      });
                                    }),
                                Expanded(
                                    child: RoundedMenuItem(
                                  item: items[index]["item"],
                                  addButtonVisible: false,
                                  editable: false,
                                  click: () {},
                                ))
                              ],
                            ));
                          } else {
                            return Container();
                          }
                        },
                      )),
                  TextFieldContainer(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Selected balance: ",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(balance.toStringAsFixed(2) + "€",
                                      style: const TextStyle(fontSize: 18))
                                ])),
                        Mutation(
                            options: MutationOptions(
                              document: gql(payItems),
                              onCompleted: (data) {
                                showFeedback("Items payed.");
                                if (refetch != null) {
                                  refetch();
                                  setState(() {
                                    selected = List.generate(
                                        items.length, (index) => true);
                                  });
                                }
                              },
                            ),
                            builder:
                                (RunMutation runMutation, QueryResult? result) {
                              return RoundedButton(
                                  text: "Pay current bill",
                                  click: () {
                                    if (balance == 0.0) {
                                      showErrorMessage(
                                          "You can not pay a bill with zweo balance.");
                                    } else {
                                      List ids = [];
                                      for (var i = 0; i < items.length; i++) {
                                        if (!selected[i]) continue;
                                        ids.add(items[i]["id"]);
                                      }
                                      runMutation({
                                        "bookingItemId": ids,
                                        // Zahlungsinformationen
                                      });
                                    }
                                  });
                            }),
                      ]))
                ],
              )));
        });
  }

  void calculateBalance(List items) {
    balance = 0.0;
    for (var i = 0; i < (items.length); i++) {
      if (selected[i]) {
        balance = balance + items[i]["item"]["price"];
      }
    }
  }

  void setAllValues(bool value) {
    setState(() {
      for (var i = 0; i < selected.length; i++) {
        selected[i] = value;
      }
      allSelected = value;
    });
  }
}
