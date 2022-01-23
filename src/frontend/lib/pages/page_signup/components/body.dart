import 'package:flutter/material.dart';
import 'package:frontend/common_components/login_or_signup.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/rounded_input_field.dart';
import 'package:frontend/common_components/rounded_password_field.dart';
import 'package:frontend/common_components/background.dart';
import 'package:frontend/api.dart';
import 'package:frontend/utils.dart';

// ignore: must_be_immutable
class Body extends StatelessWidget {
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';

  Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RoundedInputField(
            controller: TextEditingController(text: ""),
            hintText: "First Name",
            onChanged: (value) {
              firstName = value;
            }),
        RoundedInputField(
          controller: TextEditingController(text: ""),
          hintText: "Last Name",
          onChanged: (value) {
            lastName = value;
          },
        ),
        RoundedInputField(
          controller: TextEditingController(text: ""),
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
