import 'package:flutter/material.dart';
import 'package:frontend/main.dart';

import '../../constants.dart';
import 'components/body.dart';

// ignore: must_be_immutable
class RestaurantMenuEditScreen extends StatefulWidget {
  RestaurantMenuEditScreen({Key? key}) : super(key: key);

  late Map<String, dynamic> item = {};
  late Map<String, bool> editable = {};

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {

    return Body();
  }
}
