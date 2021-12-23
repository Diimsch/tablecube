import 'package:flutter/material.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/pages/order_view/components/body.dart';

class RoundedMenuItem extends StatefulWidget {
  final VoidCallback click;
  final MenuItem item;
  final bool addButtonVisible;

  const RoundedMenuItem({
    Key? key,
    required this.item,
    required this.click,
    this.addButtonVisible = true,
  }) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState(
      item: item, onAddClicked: click, addButtonVisible: addButtonVisible);
}

class _ButtonState extends State<RoundedMenuItem> {
  final MenuItem item;
  final VoidCallback onAddClicked;
  final bool addButtonVisible;
  bool _hasBeenPressed = false;

  _ButtonState(
      {required this.onAddClicked,
      required this.item,
      required this.addButtonVisible});

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: GestureDetector(
      onTap: () => {
        setState(() {
          _hasBeenPressed = !_hasBeenPressed;
        })
      },
      child: Container(
          // Container and color are important to make the area clickable
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(_hasBeenPressed
                          ? Icons.arrow_drop_up_sharp
                          : Icons.arrow_drop_down_sharp),
                      Text(
                        item.name,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  )),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "${item.price.toStringAsFixed(2)}€",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                  Visibility(
                      visible: addButtonVisible,
                      child: IconButton(
                        icon: const Icon(Icons.add_circle_outline_sharp),
                        color: Colors.black87,
                        iconSize: 40,
                        onPressed: () {
                          onAddClicked();
                        },
                      )),
                ],
              ),
              Visibility(
                child: Expanded(
                    child: Text(
                  item.description,
                  style: const TextStyle(fontSize: 15),
                  textAlign: TextAlign.start,
                )),
                visible: _hasBeenPressed,
              ),
            ],
          )),
    ));
  }
}
