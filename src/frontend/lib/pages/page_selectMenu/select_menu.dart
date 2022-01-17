import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/page_selectMenu/components/order_body.dart';
import 'package:frontend/pages/page_selectMenu/components/select_body.dart';

class SelectMenuScreen extends StatefulWidget {
  String screen;
  SelectMenuScreen({Key? key, required this.screen}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    if (screen == '/menu') {
      return SelectBody(items: selectedItems);
    } else {
      return OrderBody(items: selectedItems);
    }
  }
}
