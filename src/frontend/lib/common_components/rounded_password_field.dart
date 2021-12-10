import 'package:flutter/material.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/constants.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextField(
      onChanged: onChanged,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: "Password",
        icon: Icon(Icons.lock, color: primaryColor),
        suffixIcon: Icon(
          Icons.visibility,
          color: primaryColor,
        ),
        border: InputBorder.none,
      ),
    ));
  }
}
