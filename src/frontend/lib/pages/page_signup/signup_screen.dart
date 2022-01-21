import 'package:flutter/material.dart';
import 'package:frontend/pages/page_signup/components/body.dart';
import 'package:frontend/utils.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: getAppBar("SignUp"), body: Body());
  }
}
