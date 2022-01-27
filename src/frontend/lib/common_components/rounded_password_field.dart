import 'package:flutter/material.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/constants.dart';

/// Common Rounded Password Field

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextField(
      onChanged: widget.onChanged,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: "Password",
        icon: const Icon(Icons.lock, color: primaryColor),
        suffixIcon: IconButton(
            onPressed: _toggle,
            icon: _obscureText
                ? const Icon(Icons.visibility, color: primaryColor)
                : const Icon(Icons.visibility_off_rounded,
                    color: primaryColor)),
        border: InputBorder.none,
      ),
    ));
  }
}
