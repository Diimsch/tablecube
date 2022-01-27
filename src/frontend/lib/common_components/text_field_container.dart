import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

// Common Text field container 

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: size.width * 0.7,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
            color: primaryLightColor,
            borderRadius: BorderRadius.circular(borderRadius)),
        child: child);
  }
}
