import 'package:flutter/material.dart';
import 'package:frontend/main.dart';

import '../../constants.dart';

class TableOverviewScreen extends StatelessWidget {
  const TableOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userType != UserType.WAITER) {
      // TODO: logout and toast
      // return to WelcomeScreen
    }
    return const Scaffold();
  }
}
