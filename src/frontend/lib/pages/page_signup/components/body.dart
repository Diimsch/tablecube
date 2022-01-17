import 'package:flutter/material.dart';
import 'package:frontend/common_components/login_or_signup.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/rounded_input_field.dart';
import 'package:frontend/common_components/rounded_password_field.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/page_signup/components/background.dart';
import 'package:frontend/api.dart';

class Body extends StatelessWidget {
  final Widget child;
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';

  Body({
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
        const Text(
          "SIGNUP",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: size.height * 0.1,
        ),
        RoundedInputField(
            hintText: "First Name",
            onChanged: (value) {
              firstName = value;
            }),
        RoundedInputField(
          hintText: "Last Name",
          onChanged: (value) {
            lastName = value;
          },
        ),
        RoundedInputField(
          hintText: "E-mail",
          onChanged: (value) {
            email = value;
          },
          icon: Icons.email,
        ),
        RoundedPasswordField(onChanged: (value) {
          password = value;
        }),
        RoundedButton(
            text: "SIGNUP",
            click: () {
              if (firstName.isEmpty ||
                  lastName.isEmpty ||
                  email.isEmpty ||
                  password.isEmpty) {
                showErrorMessage("Please fill out all required values!");
              } else {
                createUser(firstName, lastName, email, password);
              }
            }),
        LoginOrSignupCheck(
          click: () {
            Navigator.pushNamed(context, '/login');
          },
          login: false,
        ),
      ],
    ));
  }
}
