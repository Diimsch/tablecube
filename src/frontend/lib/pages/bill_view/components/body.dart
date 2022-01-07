import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/rounded_menu_item.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/bill_view/bill_view.dart';
import 'package:frontend/pages/restaurant_info/components/background.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getBillQuery = r"""
query($restaurantId: ID!) {
  menu(restaurantId: $restaurantId) {
    id
    name
    description
    price
    available
    type
  }
}
""";

const String payItems = r"""
mutation PayItems($bookingItemId: [ID!]!) {
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

  List<Map<String, dynamic>>? items;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getBillQuery),
          variables: {
            'restaurantId': '0bc67384-f77d-4f8b-a28f-9225f71b909d',
          },
          pollInterval: const Duration(seconds: 30),
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Text('Loading');
          }

          // it can be either Map or List
          List items = result.data!['menu'];
          calculateBalance();

          return Scaffold(
              body: Background(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  allSelected
                      ? IconButton(
                          tooltip: "Deselect all",
                          icon:
                              const Icon(Icons.indeterminate_check_box_rounded),
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
                  flex: 6,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      // Display the list item
                      if (items[index] != null) {
                        return TextFieldContainer(
                            child: Row(
                          children: [
                            Checkbox(
                                value: selected[index],
                                onChanged: (value) {
                                  setState(() {
                                    selected[index] = value!;
                                    calculateBalance();
                                  });
                                }),
                            Expanded(
                                child: RoundedMenuItem(
                              item: items[index],
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
              Expanded(
                  flex: 1,
                  child: TextFieldContainer(
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
                                      Fluttertoast.showToast(
                                        msg:
                                            "You can not pay a bill with zweo balance.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 3,
                                        backgroundColor: warningColor,
                                        webBgColor: warningColorWebToast,
                                      );
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
                      ])))
            ],
          )));
        });
  }

  void calculateBalance() {
    balance = 0.0;
    for (var i = 0; i < (items?.length ?? 0); i++) {
      if (selected[i]) {
        balance = balance + items?[i]["price"];
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
