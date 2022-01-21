import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/page_signup/components/body.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sign up"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: primaryColor,
        ),
        body: Body(
          child: Column(),
        ));
  }
}
