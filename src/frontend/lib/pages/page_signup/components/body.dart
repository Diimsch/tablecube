import 'package:flutter/material.dart';
import 'package:frontend/common_components/login_or_signup.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/rounded_input_field.dart';
import 'package:frontend/common_components/rounded_password_field.dart';
import 'package:frontend/pages/page_login/login_screen.dart';
import 'package:frontend/pages/page_signup/components/background.dart';

class Body extends StatelessWidget {
  final Widget child;

  const Body({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "SIGNUP",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: size.height * 0.1,
        ),
        RoundedInputField(
          hintText: "E-mail",
          onChanged: (value) {},
        ),
        RoundedPasswordField(onChanged: (value) {}),
        RoundedButton(text: "SIGNUP", click: () {}),
        LoginOrSignupCheck(
          click: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const LoginScreen();
                },
              ),
            );
          },
          login: false,
        ),
      ],
    ));
  }
}
