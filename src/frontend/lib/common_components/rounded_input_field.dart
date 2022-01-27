import 'package:flutter/material.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/constants.dart';

/// Common rounded of input field

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  const RoundedInputField(
      {Key? key,
      required this.hintText,
      this.icon = Icons.person,
      required this.onChanged,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
              hintText: hintText,
              icon: Icon(icon, color: primaryColor),
              border: InputBorder.none)),
    );
  }
}
