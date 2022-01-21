import 'package:flutter/material.dart';
import 'package:frontend/utils.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar("Table Options"),
        body: const Center(child: Text('Home')));
  }
}
