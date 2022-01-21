import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/api.dart';
import 'package:frontend/bottom_nav_bar/account_bubble.dart';
import 'package:frontend/constants.dart';

showErrorMessage(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: warningColor,
      webBgColor: warningColorWebToast);
}

showFeedback(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: okColor,
      webBgColor: okColorWebToast);
}

AppBar getAppBar(String title) {
  return AppBar(
    actions: [
      AccountBubble(click: () {
        logOutUser();
      })
    ],
    title: Text(title),
    centerTitle: true,
    elevation: 0,
    backgroundColor: primaryColor,
  );
}

OverviewArguments getOverviewArguments(BuildContext context) {
  return ModalRoute.of(context)!.settings.arguments == null
      ? OverviewArguments('null', 'null', 'null')
      : ModalRoute.of(context)!.settings.arguments as OverviewArguments;
}
