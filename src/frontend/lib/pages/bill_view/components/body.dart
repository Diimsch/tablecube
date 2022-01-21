import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/api.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/rounded_menu_item.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/main.dart';
import 'package:frontend/pages/bill_view/bill_view.dart';
import 'package:frontend/common_components/background.dart';
import 'package:frontend/pages/overview/components/body.dart';
import 'package:frontend/utils.dart';
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
    var args = getOverviewArguments(context);

    return Query(
        options: QueryOptions(
          document: gql(getBillQuery),
          variables: {
            'bookingId': args.bookingId,
          },
          pollInterval: const Duration(seconds: 5),
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const SpinKitRotatingCircle(color: Colors.white, size: 50.0);
          }

          List items = result.data!['booking']?["items"] ?? List.empty();
          List falseItems = items.where((i) => i["paid"] == false).toList();
          List trueItems = items.where((i) => i["paid"] == true).toList();
          items = falseItems + trueItems;

          calculateBalance(items);

          return Scaffold(
              appBar: getAppBar("Bill and Pay"),
              body: Background(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Helper buttons
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
                  // Main Content
                  Expanded(
                      flex: 5,
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          if (items.isNotEmpty) {
                            return TextFieldContainer(
                                child: Row(
                              children: [
                                items[index]["paid"]
                                    ? const Icon(Icons.check,
                                        color: Colors.green)
                                    : Checkbox(
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
                  // bottom buttons
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
                        userType == UserType.WAITER
                            ? Mutation(
                                options: MutationOptions(
                                  document: gql(payItems),
                                  onCompleted: (data) {
                                    showFeedback("Items paid.");
                                    if (refetch != null) {
                                      refetch();
                                      setState(() {
                                        selected = List.generate(
                                            items.length, (index) => true);
                                      });
                                    }
                                  },
                                  onError: (error) =>
                                      handleError(error as OperationException),
                                ),
                                builder: (RunMutation runMutation,
                                    QueryResult? result) {
                                  return Expanded(
                                      child: RoundedButton(
                                          text: "Mark as paid",
                                          click: () {
                                            if (balance == 0.0) {
                                              showErrorMessage(
                                                  "You can not pay a bill with zero balance.");
                                            } else {
                                              List ids = [];
                                              for (var i = 0;
                                                  i < items.length;
                                                  i++) {
                                                if (!selected[i]) continue;
                                                ids.add(items[i]["id"]);
                                              }
                                              runMutation({
                                                "bookingItemId": ids,
                                              });
                                            }
                                          }));
                                })
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                    Mutation(
                                        options: MutationOptions(
                                          document: gql(payItems),
                                          onCompleted: (data) {
                                            showFeedback("Items paid.");
                                            if (refetch != null) {
                                              refetch();
                                              setState(() {
                                                selected = List.generate(
                                                    items.length,
                                                    (index) => true);
                                              });
                                            }
                                          },
                                          onError: (error) => handleError(
                                              error as OperationException),
                                        ),
                                        builder: (RunMutation runMutation,
                                            QueryResult? result) {
                                          return Expanded(
                                              flex: 1,
                                              child: RoundedButton(
                                                  text: "Pay current bill",
                                                  click: () {
                                                    if (balance == 0.0) {
                                                      showErrorMessage(
                                                          "You can not pay a bill with zero balance.");
                                                    } else {
                                                      List ids = [];
                                                      for (var i = 0;
                                                          i < items.length;
                                                          i++) {
                                                        if (items[i]["paid"] ||
                                                            !selected[i]) {
                                                          continue;
                                                        }
                                                        ids.add(items[i]["id"]);
                                                      }
                                                      runMutation({
                                                        "bookingItemId": ids,
                                                      });
                                                    }
                                                  }));
                                        }),
                                    Mutation(
                                        options: MutationOptions(
                                          document: gql(updateBookingStatus),
                                          onCompleted: (data) {
                                            showFeedback("Items paid.");
                                            if (refetch != null) {
                                              refetch();
                                              setState(() {
                                                selected = List.generate(
                                                    items.length,
                                                    (index) => true);
                                              });
                                            }
                                          },
                                          onError: (error) => handleError(
                                              error as OperationException),
                                        ),
                                        builder: (RunMutation runMutation,
                                            QueryResult? result) {
                                          return Expanded(
                                              flex: 1,
                                              child: RoundedButton(
                                                  text: "Pay with cash",
                                                  click: () {
                                                    if (balance == 0.0) {
                                                      showErrorMessage(
                                                          "You can not pay a bill with zero balance.");
                                                    } else {
                                                      List ids = [];
                                                      for (var i = 0;
                                                          i < items.length;
                                                          i++) {
                                                        if (!selected[i]) {
                                                          continue;
                                                        }
                                                        ids.add(items[i]["id"]);
                                                      }
                                                      runMutation({
                                                        "data": {
                                                          "tableId":
                                                              args.tableId,
                                                          "status":
                                                              "NEEDS_SERVICE"
                                                        }
                                                      });
                                                    }
                                                  }));
                                        }),
                                  ]),
                      ]))
                ],
              )));
        });
  }

  void calculateBalance(List items) {
    balance = 0.0;
    for (var i = 0; i < (items.length); i++) {
      if (selected[i] && items[i]["paid"] == false) {
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
