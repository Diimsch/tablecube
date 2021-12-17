import 'package:flutter/material.dart';
import 'package:frontend/common_components/rounded_menu_item.dart';
import 'package:frontend/pages/page_selectMenu/components/background.dart';

/* TODO:
  -add background
  -test listview for backend input
 */

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        const SizedBox(
          height: 50,
        ),
        const Text(
          'Select Menu Item',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          textScaleFactor: 1.2,
        ),
        const SizedBox(
          height: 30,
        ),
        RoundedMenuItem(
          onPressed: () {},
          click: () {},
        ),
        // buildText("")
      ],
    ));
  }
}
