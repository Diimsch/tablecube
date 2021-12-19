import 'package:flutter/material.dart';

import 'components/body.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key);

  final List<MenuItem> items = <MenuItem>[
    MenuItem("1", "Große Cola 0.33l", "", 2.40, true, ""),
    MenuItem("2", "Große Fanta 0.33l", "", 2.40, true, ""),
    MenuItem("3", "Großes Wasser 0.33l", "", 1.80, true, ""),
    MenuItem("4", "200g Rumsteak", "", 16.70, true, ""),
    MenuItem("5", "Salamipizza", "", 8.90, true, ""),
    MenuItem("6", "Schinkenpizza", "", 9.60, true, ""),
    MenuItem("7", "Jägerschnitzel", "", 10.33, true, "")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Body(items: items));
  }
}
