import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

class LoginOrSignupCheck extends StatelessWidget {
  final bool login;
  final VoidCallback click;

  const LoginOrSignupCheck({Key? key, this.login = true, required this.click})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text(login ? "Don't have an Account? " : "Already have an Account? ",
          style: const TextStyle(color: primaryColor)),
      GestureDetector(
        onTap: click,
        child: Text(login ? "Sign Up" : "Sign In",
            style: const TextStyle(
                color: primaryColor, fontWeight: FontWeight.bold)),
      )
    ]);
  }
}