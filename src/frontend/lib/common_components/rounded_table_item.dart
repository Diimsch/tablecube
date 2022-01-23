import 'package:flutter/material.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/constants.dart';

class RoundedTableItem extends StatelessWidget {
  final Map<String, dynamic> table;
  final bool editable;
  final ValueChanged<String> onChanged;
  const RoundedTableItem(
      {Key? key,
      required this.table,
      required this.editable,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: editable
                ? TextField(
                    controller: TextEditingController(text: table['name']),
                    onChanged: onChanged,
                    decoration: const InputDecoration(
                        hintText: 'Name', border: InputBorder.none))
                : Text(
                    table["name"],
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  )),
      ],
    ));
  }
}
