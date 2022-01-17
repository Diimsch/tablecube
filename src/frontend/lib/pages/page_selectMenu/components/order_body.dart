import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/api.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/overview/components/background.dart';
import 'package:frontend/pages/page_selectMenu/select_menu.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'list-item.dart';

const String addItemToTable = r"""
mutation AddItemToTable($data: AddItemToTableInput!) {
  addItemToTable(data: $data) {
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
    var args = ModalRoute.of(context)!.settings.arguments == null
        ? OverviewArguments('null', 'null', 'null')
        : ModalRoute.of(context)!.settings.arguments as OverviewArguments;

    backup = List<Map<String, dynamic>>.from(items);
    calculateCurrentBalance();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Cart"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: primaryColor,
        ),
        body: Background(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 5,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    // Display the list item
                    return Dismissible(
                        key: UniqueKey(),

                        // only allows the user swipe from right to left
                        direction: DismissDirection.none,

                        // Remove this product from the list
                        // In production enviroment, you may want to send some request to delete it on server side
                        onDismissed: (_) {
                          setState(() {
                            items.removeAt(index);
                          });
                        },

                        // Display item's title, price...
                        child: OrderListItem(
                          item: items[index],
                          onDelete: () {
                            setState(() {
                              items.removeAt(index);
                            });
                          },
                        ));
                  },
                )),
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
                        document: gql(addItemToTable),
                        onCompleted: (dynamic data) {
                          if (data == null) {
                            return;
                          }
                          Fluttertoast.showToast(
                            msg: "Items added to bill",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: okColor,
                            webBgColor: okColorWebToast,
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
                      return RoundedButton(
                          text: "Add items to bill",
                          click: () {
                            if (balance == 0.0) {
                              Fluttertoast.showToast(
                                msg: "No items in list to order.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                backgroundColor: warningColor,
                                webBgColor: warningColorWebToast,
                              );
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
                          });
                    }),
              ],
            ))
          ],
        )));
  }

  void calculateCurrentBalance() {
    balance = 0.0;
    for (var item in items) {
      balance = balance + item["price"];
    }
  }
}
