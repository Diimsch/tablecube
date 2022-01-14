import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/api.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/page_welcome/components/background.dart';
import 'package:frontend/pages/table_overview/table_overview_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String updateBookingStatus = r"""
mutation ChangeBookingStatus($data: ChangeBookingStatusInput!) {
  changeBookingStatus(data: $data) {
    id
  }
}
""";

class Body extends StatelessWidget {
  final UserType userType;
  final OverviewArguments args;
  const Body({Key? key, required this.userType, required this.args})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // total height and width of screen

    if (userType == UserType.NONE) {
      return Background(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Select an option",
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
                      msg: 'Waiter was called.',
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
                      text: "Call waiter",
                      click: () {
                        runMutation({
                          "data": {
                            "bookingId": args.bookingId,
                            "status": "NEEDS_SERVICE"
                          }
                        });
                      });
                }),
          ],
        ),
      ));
    } else if (userType == UserType.WAITER) {
      return const Background(child: TableOverviewScreen());
    } else if (userType == UserType.ADMIN) {
      return Background(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Select an option",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            RoundedButton(
                text: "Edit restaurant information",
                click: () {
                  Navigator.pushNamed(context, '/admin/info', arguments: args);
                }),
            RoundedButton(
                text: "Edit menu",
                click: () {
                  Navigator.pushNamed(context, '/admin/menu', arguments: args);
                }),
            RoundedButton(
                text: "Edit table placement",
                click: () {
                  Navigator.pushNamed(context, '/admin/tables',
                      arguments: args);
                }),
          ],
        ),
      ));
    } else {
      Fluttertoast.showToast(
        msg: 'Something went wrong. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: warningColor,
        webBgColor: warningColorWebToast,
      );
      logOutUser();
      Navigator.pushNamed(context, '/');
      return Container();
    }
  }
}
