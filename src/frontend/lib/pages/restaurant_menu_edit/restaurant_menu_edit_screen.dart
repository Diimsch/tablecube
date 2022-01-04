import 'package:flutter/material.dart';
import 'package:frontend/main.dart';

import '../../constants.dart';
import 'components/body.dart';

class RestaurantMenuEditScreen extends StatefulWidget {
  const RestaurantMenuEditScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    if (userType != UserType.ADMIN) {
      // TODO: logout and toast
      // return to WelcomeScreen
    }

    // TODO: get menu list
    final List<Map<String, dynamic>> items = [
      {
        "name": "Fanta",
        "description": "ABC",
        "price": 4.00,
        "available": true,
        "type": "FOOD"
      },
      {
        "name": "Fisch",
        "description": "WER",
        "price": 6.00,
        "available": true,
        "type": "FOOD"
      }
    ];
    List<bool> editables = List.generate(items.length, (index) => false);

    return Body(items: items, editables: editables);
  }
}
