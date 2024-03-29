import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/common_components/background.dart';
import 'package:frontend/pages/page_selectMenu/select_menu.dart';
import 'package:frontend/utils.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'list_item.dart';

/// Mutation to add the selected item to a Booking
const String addItemToBooking = r"""
mutation AddItemToBooking($data: AddItemToBookingInput!) {
  addItemToBooking(data: $data) {
    id
  }
}
""";

class OrderBody extends State<SelectMenuScreen> {
  List<Map<String, dynamic>> items;
  List<Map<String, dynamic>> backup = [];
  double balance = 0.0;
  OrderBody({required this.items});

  @override
  Widget build(BuildContext context) {
    var args = getOverviewArguments(context);

    backup = List<Map<String, dynamic>>.from(items);
    calculateCurrentBalance();

    return Scaffold(
        appBar: getAppBar("Selected Orders"),
        body: Background(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// main content
            Expanded(
                flex: 5,
                child: items.isEmpty
                    ? const Center(
                        child: Text(
                        "No items selected.",
                        style: TextStyle(fontSize: 15),
                      ))
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          /// Display the list item
                          return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.none,
                              onDismissed: (_) {
                                setState(() {
                                  items.removeAt(index);
                                });
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OrderListItem(
                                      item: items[index],
                                      onDelete: () {
                                        setState(() {
                                          items.removeAt(index);
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ));
                        },
                      )),
            /// bootom buttons
            TextFieldContainer(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Current balance:"),
                    Text(balance.toStringAsFixed(2) + "€")
                  ],
                ),
                Mutation(
                    options: MutationOptions(
                        document: gql(addItemToBooking),
                        onCompleted: (dynamic data) {
                          if (data == null) {
                            return;
                          }
                          showFeedback(
                            "Items ordered and added to bill.",
                          );
                          setState(() {
                            items.clear();
                            calculateCurrentBalance();
                          });
                        },
                        onError: (error) => {
                              items = backup,
                              handleError(error as OperationException)
                            }),
                    builder: (RunMutation runMutation, QueryResult? result) {
                      return Row(children: [
                        Expanded(
                            child: RoundedButton(
                                text: "Order items",
                                click: () {
                                  if (balance == 0.0) {
                                    showErrorMessage(
                                        "No items in list to order.");
                                  } else {
                                    for (var i = 0; i < items.length; i++) {
                                      runMutation({
                                        "data": {
                                          "itemId": items[i]["id"],
                                          "bookingId": args.bookingId
                                        }
                                      });
                                    }
                                  }
                                }))
                      ]);
                    }),
              ],
            ))
          ],
        )));
  }


  /// Calculates the total price of the selected order
  void calculateCurrentBalance() {
    balance = 0.0;
    for (var item in items) {
      balance = balance + item["price"];
    }
  }
}
