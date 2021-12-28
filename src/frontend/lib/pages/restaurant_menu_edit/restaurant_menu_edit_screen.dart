import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/pages/order_view/components/body.dart' as overview;
import 'package:frontend/pages/overview/overview_screen.dart';

import 'components/body.dart';

class RestaurantMenuEditScreen extends StatefulWidget {
  const RestaurantMenuEditScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    if (userType != UserType.admin) {
      // TODO: logout and toast
      // return to WelcomeScreen
    }

    // TODO: get menu list
    final List<overview.MenuItem> items = <overview.MenuItem>[
      overview.MenuItem("1", "Große Cola 0.33l", "abc", 2.40, true, "", ""),
      overview.MenuItem("2", "Große Fanta 0.33l", "wer", 2.40, true, "", ""),
      overview.MenuItem("3", "Großes Wasser 0.33l", "fgh", 1.80, true, "", ""),
    ];
    List<bool> editables = List.generate(items.length, (index) => false);

    return Body(items: items, editables: editables);
  }
}
