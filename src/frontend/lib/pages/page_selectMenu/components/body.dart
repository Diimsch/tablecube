import 'package:flutter/material.dart';
import 'package:frontend/common_components/rounded_menu_item.dart';
import 'package:frontend/pages/page_welcome/components/background.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Select Menu",
                  style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              RoundedMenuItem(click: () {}),
            ],
          ),
        )
    );
  }
}
