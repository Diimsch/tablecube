import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AccountBubble extends StatelessWidget {
  const AccountBubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // total height and width of screen
    return SvgPicture.asset("assets/icons/logo4.svg",
        height: size.height * 0.3);
  }
}
