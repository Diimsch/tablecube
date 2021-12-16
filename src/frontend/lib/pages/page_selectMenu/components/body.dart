import 'package:flutter/material.dart';
import 'package:frontend/common_components/rounded_menu_item.dart';
import 'package:frontend/pages/page_selectMenu/components/background.dart';
import '../select_menu.dart';

/* TODO:
  -add background
  -fix readmore icon
  -test listview for backend input
 */

class Body extends State<SelectMenuScreen> {
  // @override
  // Widget build(BuildContext context) {
  //   return Background(
  //       child: SingleChildScrollView(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             const Text("Select Menu",
  //                 style: TextStyle(fontWeight: FontWeight.bold),
  //               textAlign: TextAlign.center,
  //             ),
  //             RoundedMenuItem(click: () {}),
  //           ],
  //         ),
  //       )
  //   );
  // }
  bool isReadmore = false;

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
            onPressed: () {
              setState(() {
                isReadmore = !isReadmore;
              });
            },
            click: () {},
            icon: Icon((isReadmore ? Icons.arrow_drop_down_sharp : Icons.arrow_drop_up_sharp))
        ),
        buildText(
          "Steak mit herzhafter Pilzsauce oder so"
        )
      ],
    ));
  }

  Widget buildText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 25),
    );
  }
}
