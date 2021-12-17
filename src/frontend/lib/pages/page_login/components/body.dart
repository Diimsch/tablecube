import 'package:flutter/material.dart';
import 'package:frontend/common_components/login_or_Signup_check.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/rounded_input_field.dart';
import 'package:frontend/common_components/rounded_password_field.dart';
import 'package:frontend/pages/page_login/components/background.dart';
import 'package:frontend/pages/page_selectMenu/select_menu.dart';
import 'package:frontend/pages/page_signup/signup_screen.dart';

class Body extends StatelessWidget {
  const Body({
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
        RoundedInputField(hintText: "E-mail", onChanged: (value) {}),
        RoundedPasswordField(
          onChanged: (value) {},
        ),
        RoundedButton(text: "LOGIN",
            click: () {
              Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const SelectMenuScreen();
                    }
                  )
              );
            }
            ),
        LoginOrSignupCheck(click: (value) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const SignUpScreen();
              },
            ),
          );
        }),
      ],
    ));
  }
}
