import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/overview/components/body.dart';

class OverviewScreen extends StatelessWidget {
  UserType userType;
  OverviewScreen({Key? key, this.userType = UserType.NONE}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments == null
        ? "NULL"
        : ModalRoute.of(context)!.settings.arguments as OverviewArguments;

    if (userType == UserType.NONE) {
      // TODO: logout and toast information
      // return to WelcomeScreen
    }
    return Scaffold(
        body: Body(
      userType: userType,
    ));
  }
}
