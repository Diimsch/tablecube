import 'package:flutter/material.dart';
import 'package:frontend/pages/overview/components/body.dart';

enum UserType {
  WAITER,
  ADMIN,
  NONE,
}

class OverviewScreen extends StatelessWidget {
  final UserType userType;
  const OverviewScreen({Key? key, required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Body(
      userType: userType,
    ));
  }
}
