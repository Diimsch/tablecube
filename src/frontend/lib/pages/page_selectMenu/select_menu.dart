import 'package:flutter/material.dart';
import 'package:frontend/pages/page_selectMenu/components/body.dart';
import '../../constants.dart';

class SelectMenuScreen extends StatelessWidget {
  const SelectMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select Menu Item"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: primaryColor,
        ),
        body: const Body());
  }
}