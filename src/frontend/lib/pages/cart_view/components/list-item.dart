import 'package:flutter/material.dart';
import 'package:frontend/common_components/text_field_container.dart';

import 'body.dart';

class CartListItem extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onDelete;
  const CartListItem({Key? key, required this.item, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 3,
                child: Text(
                  item.name,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Expanded(
                flex: 1,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text(
                    "${item.price.toStringAsFixed(2)}€",
                    textAlign: TextAlign.end,
                  ),
                  IconButton(
                    onPressed: onDelete,
                    splashRadius: 25,
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: Color.fromARGB(255, 255, 0, 0)),
                  ),
                ]))
          ],
        ),
        if (item.comment.isNotEmpty)
          Text(
            item.comment,
            maxLines: 5,
            overflow: TextOverflow.fade,
            softWrap: true,
          )
      ],
    ));
  }
}
