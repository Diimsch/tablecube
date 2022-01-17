import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/bottom_nav_bar/account_bubble.dart';
import 'package:frontend/main.dart';

import '../../constants.dart';
import 'components/body.dart';

class RestaurantInfoScreen extends StatelessWidget {
  const RestaurantInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userType != UserType.ADMIN) {
      // TODO: logout and toast
      // return to WelcomeScreen
    }
    return Scaffold(
        appBar: AppBar(
          actions: [
            AccountBubble(click: () {
              logOutUser();
            })
          ],
          title: const Text("Edit restaurant information"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: primaryColor,
        ),
        body: Body());
  }
}
