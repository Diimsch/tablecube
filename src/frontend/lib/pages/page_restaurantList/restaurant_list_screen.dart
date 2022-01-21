import 'package:flutter/material.dart';
import 'package:frontend/pages/page_restaurantList/components/body.dart';
import 'package:frontend/utils.dart';

class RestaurantListScreen extends StatelessWidget {
  const RestaurantListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: getAppBar("Select Restaurant"), body: const Body());
  }
}
