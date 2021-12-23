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
      overview.MenuItem("1", "Große Cola 0.33l", "", 2.40, true, "", ""),
      overview.MenuItem("2", "Große Fanta 0.33l", "", 2.40, true, "", ""),
      overview.MenuItem("3", "Großes Wasser 0.33l", "", 1.80, true, "", ""),
      overview.MenuItem("4", "200g Rumsteak", "", 16.70, true, "", ""),
      overview.MenuItem("5", "Salamipizza", "", 8.90, true, "", ""),
      overview.MenuItem("6", "Schinkenpizza", "", 9.60, true, "", ""),
      overview.MenuItem("7", "Jägerschnitzel", "", 10.33, true, "", "")
    ];

    return Body(items: items);
  }
}
