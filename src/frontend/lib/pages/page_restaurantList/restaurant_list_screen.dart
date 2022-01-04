import 'package:flutter/material.dart';
import 'package:frontend/pages/page_restaurantList/components/body.dart';
import '../../constants.dart';

class RestaurantListScreen extends StatelessWidget {
  const RestaurantListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select Restaurant"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: primaryColor,
        ),
        body: const Body());
  }
}
