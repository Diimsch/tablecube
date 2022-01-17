import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/constants.dart';

class AccountBubble extends StatelessWidget {
  final VoidCallback click;
  const AccountBubble({Key? key, required this.click}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // total height and width of screen

    return IconButton(
      tooltip: "Logout",
      iconSize: iconSize,
      splashRadius: splashRadius,
      onPressed: click,
      icon: SvgPicture.asset("assets/icons/logo4.svg"),
    );
  }
}
