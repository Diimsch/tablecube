import 'package:flutter/material.dart';
import 'package:frontend/common_components/rounded_menu_item.dart';
import 'package:frontend/pages/order_view/components/body.dart';
import 'package:frontend/pages/page_selectMenu/components/background.dart';

/* TODO:
  -test listview for backend input
 */

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
        body: ListView(
      children: [
        const SizedBox(
          height: 30,
        ),
        RoundedMenuItem(
          item: MenuItem(
              "Hacksteak mit wüzigen Kartoffeln",
              "Hacksteak mit wüzigen Kartoffeln",
              "Hacksteak mit wüzigen Kartoffeln",
              2.2,
              true,
              "",
              ""),
          click: () {},
          editable: false,
        ),
        RoundedMenuItem(
          item: MenuItem("", "", "", 2.2, true, "", ""),
          click: () {},
          editable: false,
        ),
        RoundedMenuItem(
          item: MenuItem("", "", "", 2.2, true, "", ""),
          click: () {},
          editable: false,
        ),
        RoundedMenuItem(
          item: MenuItem("", "", "", 2.2, true, "", ""),
          click: () {},
          editable: false,
        ),
      ],
    ));
  }
}
