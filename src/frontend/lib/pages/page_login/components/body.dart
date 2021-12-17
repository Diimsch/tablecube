import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/common_components/login_or_signup.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/rounded_input_field.dart';
import 'package:frontend/common_components/rounded_password_field.dart';
import 'package:frontend/pages/overview/overview_screen.dart';
import 'package:frontend/pages/page_login/components/background.dart';

class Body extends StatelessWidget {
  String email = '';
  String password = '';

  Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "LOGIN",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: size.height * 0.1,
        ),
        RoundedInputField(
            hintText: "E-mail",
            onChanged: (value) {
              email = value;
            }),
        RoundedPasswordField(
          onChanged: (value) {
            password = value;
          },
        ),
        RoundedButton(
            text: "LOGIN",
            click: () {
              logInUser(email, password);
            }),
        LoginOrSignupCheck(click: () {
          Navigator.pushNamed(context, '/signup');
        }),
      ],
    ));
  }
}
