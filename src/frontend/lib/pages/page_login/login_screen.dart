import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/page_login/components/body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sign In"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: primaryColor,
        ),
        body: Body());
  }
}
