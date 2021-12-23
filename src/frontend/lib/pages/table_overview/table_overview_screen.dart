import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/pages/overview/overview_screen.dart';

class TableOverviewScreen extends StatelessWidget {
  const TableOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userType != UserType.waiter) {
      // TODO: logout and toast
      // return to WelcomeScreen
    }
    return const Scaffold();
  }
}
