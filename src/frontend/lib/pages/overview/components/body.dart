import 'package:flutter/material.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/pages/overview/overview_screen.dart';
import 'package:frontend/pages/page_welcome/components/background.dart';

import '../../../bottom_nav_bar/account_bubble.dart';

class Body extends StatelessWidget {
  final UserType userType;
  const Body({Key? key, required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // total height and width of screen

    if (userType == UserType.user) {
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
                text: "Select item from menu",
                click: () {
                  navigateToMenu(context);
                }),
            RoundedButton(
                text: "Watch cart",
                click: () {
                  navigateToCart(context);
                }),
            RoundedButton(
                text: "Bill and pay",
                click: () {
                  navigateToPayView(context);
                }),
            SizedBox(
              height: size.height * 0.05,
            ),
            RoundedButton(
                text: "Call waiter",
                click: () {
                  callWaiter();
                }),
          ],
        ),
      ));
    } else if (userType == UserType.waiter) {
      return const Background(child: SingleChildScrollView());
    } else if (userType == UserType.admin) {
      return const Background(child: SingleChildScrollView());
    } else {
      // error
      return const Background(child: SingleChildScrollView());
    }
  }

  void navigateToMenu(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Container(); //const MenuScreen();
        },
      ),
    );
  }

  void navigateToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Container(); //const MenuScreen();
        },
      ),
    );
  }

  void navigateToPayView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Container(); //const MenuScreen();
        },
      ),
    );
  }

  void callWaiter() {}
}
