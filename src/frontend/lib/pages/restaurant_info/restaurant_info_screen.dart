import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/pages/overview/overview_screen.dart';

import 'components/body.dart';

class RestaurantInfoScreen extends StatelessWidget {
  const RestaurantInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userType != UserType.admin) {
      // TODO: logout and toast
      // return to WelcomeScreen
    }
    return Scaffold(body: Body());
  }
}
