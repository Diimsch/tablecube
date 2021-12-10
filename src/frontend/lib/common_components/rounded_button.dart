import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback click;
  final Color color, textColor;
  const RoundedButton(
      {Key? key,
      required this.text,
      required this.click,
      this.color = primaryColor,
      this.textColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.7,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(29),
          child: TextButton(
              onPressed: click,
              child: Text(text, style: TextStyle(color: textColor)),
              style: TextButton.styleFrom(
                  backgroundColor: color,
                  padding:
                      EdgeInsets.symmetric(vertical: 20, horizontal: 40)))),
    );
  }
}
