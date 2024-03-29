import 'package:flutter/material.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/common_components/background.dart';
import 'package:flutter_svg/svg.dart';

/// Welcome page when starting the application
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          SizedBox(height: size.height * 0.05),
          SvgPicture.asset("assets/icons/logo4.svg", height: size.height * 0.3),
          RoundedButton(
              text: "LOGIN",
              click: () {
                Navigator.pushNamed(context, '/login');
              }),
          RoundedButton(
            text: "SIGNUP",
            click: () {
              Navigator.pushNamed(context, '/signup');
            },
            color: primaryLightColor,
            textColor: Colors.black,
          )
        ],
      ),
    ));
  }
}
