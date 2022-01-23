import 'package:flutter/material.dart';
import 'components/body.dart';

// ignore: must_be_immutable
class RestaurantInfoScreen extends StatefulWidget {
  RestaurantInfoScreen({Key? key}) : super(key: key);

  late Map restaurant;
  bool dataLoaded = false;

  @override
  State<StatefulWidget> createState() {
    return Body();
  }
}
