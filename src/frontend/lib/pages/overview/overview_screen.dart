import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/pages/overview/components/body.dart';

enum UserType {
  WAITER,
  ADMIN,
  NONE,
}

class OverviewScreen extends StatelessWidget {
  UserType localUserType = UserType.none;
  OverviewScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    localUserType = userType;
    if (userType == UserType.none) {
      // TODO: logout and toast information
      // return to WelcomeScreen
    }
    return Scaffold(
        body: Body(
      userType: userType,
    ));
  }
}
