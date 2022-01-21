import 'package:flutter/material.dart';
import 'components/body.dart';

class RestaurantInfoScreen extends StatefulWidget {
  RestaurantInfoScreen({Key? key}) : super(key: key);

  late Map restaurant;
  bool dataLoaded = false;

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    dataLoaded = false;
    return Body();
  }
}
