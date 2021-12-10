import 'package:flutter/material.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/page_login/login_screen.dart';
import 'package:frontend/pages/page_signup/signup_screen.dart';
import 'package:frontend/pages/page_welcome/components/background.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // total height and width of screen
    return Background(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Welcome to Tablecube",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: size.height * 0.05),
          SvgPicture.asset("assets/icons/logo4.svg", height: size.height * 0.3),
          RoundedButton(
              text: "LOGIN",
              click: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen();
                    },
                  ),
                );
              }),
          RoundedButton(
            text: "SIGNUP",
            click: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
            color: primaryLightColor,
            textColor: Colors.black,
          )
        ],
      ),
    ));
  }
}
