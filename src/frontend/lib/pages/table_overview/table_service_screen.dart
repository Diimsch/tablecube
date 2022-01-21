import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/background.dart';
import 'package:frontend/pages/overview/components/body.dart';
import 'package:frontend/utils.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getRestaurantsQuery = r"""
query Restaurants {
  restaurants {
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
    var args = getOverviewArguments(context);
    Size size = MediaQuery.of(context).size;
    return Background(
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
                    showFeedback('Service has been finished.');
                  },
                  onError: (error) => handleError(error as OperationException),
                ),
                builder: (RunMutation runMutation, QueryResult? result) {
                  return RoundedButton(
                      text: "Service Finished",
                      click: () {
                        runMutation({
                          "data": {
                            "tableId": args.tableId,
                            "status": "CHECKED_IN"
                          }
                        });
                      });
                }),
          ],
        ),
      ),
    );
  }
}
