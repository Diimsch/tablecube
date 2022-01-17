import 'package:flutter/material.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/constants.dart';

class RoundedMultilineInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  String text;
  RoundedMultilineInputField(
      {Key? key,
      required this.hintText,
      this.icon = Icons.person,
      required this.onChanged,
      this.text = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
          controller: TextEditingController(text: text),
          maxLines: 10,
          onChanged: onChanged,
          decoration: InputDecoration(
              hintText: hintText,
              icon: Icon(icon, color: primaryColor),
              border: InputBorder.none)),
    );
  }
}
