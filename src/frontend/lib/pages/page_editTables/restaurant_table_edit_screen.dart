import 'package:flutter/material.dart';

import 'components/body.dart';

// ignore: must_be_immutable
class RestaurantTableEditScreen extends StatefulWidget {
  RestaurantTableEditScreen({Key? key}) : super(key: key);

  late Map<String, dynamic> table = {};
  late Map<String, bool> editable = {};

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    return Body();
  }
}
