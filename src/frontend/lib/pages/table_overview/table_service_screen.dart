import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/main.dart';
import 'package:frontend/pages/bill_view/components/background.dart';
import 'package:frontend/pages/overview/components/body.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../constants.dart';

const String getRestaurantsQuery = r"""
query Restaurant {
  restaurant {
    id
    name
    tables {
      name
      occupyingBooking {
        id
        status
      }
    }
  }
}
""";

class TableServiceScreen extends StatelessWidget {
  const TableServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments == null
        ? OverviewArguments('null', 'null')
        : ModalRoute.of(context)!.settings.arguments as OverviewArguments;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Table Options"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      body: Background(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Select an option for Customer",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            RoundedButton(
                text: "Select menu items",
                click: () {
                  Navigator.pushNamed(context, '/menu', arguments: args);
                }),
            RoundedButton(
                text: "Order",
                click: () {
                  Navigator.pushNamed(context, '/cart', arguments: args);
                }),
            RoundedButton(
                text: "Pay",
                click: () {
                  Navigator.pushNamed(context, '/bill', arguments: args);
                }),
            SizedBox(
              height: size.height * 0.05,
            ),
            Mutation(
                options: MutationOptions(
                  document: gql(updateBookingStatus),
                  onCompleted: (data) {
                    Fluttertoast.showToast(
                      msg: 'Service has been finished.',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: okColor,
                      webBgColor: okColorWebToast,
                    );
                  },
                ),
                builder: (RunMutation runMutation, QueryResult? result) {
                  return RoundedButton(
                      text: "Service Finished",
                      click: () {
                        // TODO: replace hardcoded tableID
                        runMutation({
                          "data": {
                            "tableId": 'c823d232-8700-42e8-ad5c-e0813cf807e9',
                            "status": "CHECKED_IN"
                          }
                        });
                      });
                }),
          ],
        ),
      )),
    );
  }
}
