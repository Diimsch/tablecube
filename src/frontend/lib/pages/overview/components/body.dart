import 'package:flutter/material.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/pages/overview/overview_screen.dart';
import 'package:frontend/pages/page_welcome/components/background.dart';
import 'package:frontend/pages/table_overview/table_overview_screen.dart';

class Body extends StatelessWidget {
  final UserType userType;
  const Body({Key? key, required this.userType}) : super(key: key);

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
                  navigateTo(context, Container());
                }),
            RoundedButton(
                text: "Order",
                click: () {
                  navigateTo(context, Container());
                }),
            RoundedButton(
                text: "Pay",
                click: () {
                  navigateTo(context, Container());
                }),
            SizedBox(
              height: size.height * 0.05,
            ),
            RoundedButton(
                text: "Call for help",
                click: () {
                  callWaiter();
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
                  navigateTo(context, Container());
                }),
            RoundedButton(
                text: "Edit menu",
                click: () {
                  navigateTo(context, Container());
                }),
            RoundedButton(
                text: "Edit table placement",
                click: () {
                  navigateTo(context, Container());
                }),
          ],
        ),
      ));
    } else {
      // error
      return const Background(child: Text("Error"));
    }
  }

  void navigateTo(BuildContext context, StatelessWidget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return widget;
        },
      ),
    );
  }

  void callWaiter() {}
}
