import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/api.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/constants.dart';
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
                  Navigator.pushNamed(context, '/menu');
                }),
            RoundedButton(
                text: "Order",
                click: () {
                  Navigator.pushNamed(context, '/orders');
                }),
            RoundedButton(
                text: "Pay",
                click: () {
                  Navigator.pushNamed(context, '/bill');
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
                  Navigator.pushNamed(context, '/admin/info');
                }),
            RoundedButton(
                text: "Edit menu",
                click: () {
                  Navigator.pushNamed(context, '/admin/menu');
                }),
            RoundedButton(
                text: "Edit table placement",
                click: () {
                  Navigator.pushNamed(context, '/admin/tables');
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

  void callWaiter() {
    // TODO: call waiter -> update table status
    // unlucky -> toast, with try again later or try it with your own voice
  }
}
