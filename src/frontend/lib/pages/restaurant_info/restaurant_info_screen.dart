import 'package:flutter/material.dart';
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
    return Scaffold(body: Body());
  }
}
