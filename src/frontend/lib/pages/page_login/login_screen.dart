import 'package:flutter/material.dart';
import 'package:frontend/pages/page_login/components/body.dart';
import 'package:frontend/utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: getAppBar("Sign in"), body: Body());
  }
}
