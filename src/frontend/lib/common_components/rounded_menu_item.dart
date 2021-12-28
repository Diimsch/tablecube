import 'package:flutter/material.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/pages/order_view/components/body.dart';

class RoundedMenuItem extends StatefulWidget {
  final VoidCallback click;
  final MenuItem item;
  final bool addButtonVisible;
  final bool editable;

  const RoundedMenuItem({
    Key? key,
    required this.item,
    required this.click,
    required this.editable,
    this.addButtonVisible = true,
  }) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState(
      item: item,
      onAddClicked: click,
      addButtonVisible: addButtonVisible,
      editable: editable);
}

class _ButtonState extends State<RoundedMenuItem> {
  final MenuItem item;
  final VoidCallback onAddClicked;
  final bool addButtonVisible;
  final bool editable;
  bool _hasBeenPressed = false;

  _ButtonState(
      {required this.onAddClicked,
      required this.item,
      required this.addButtonVisible,
      required this.editable});

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
                      flex: 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(_hasBeenPressed
                              ? Icons.arrow_drop_up_sharp
                              : Icons.arrow_drop_down_sharp),
                          editable
                              ? Expanded(
                                  child: TextField(
                                  controller:
                                      TextEditingController(text: item.name),
                                  maxLines: 1,
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    item.name = value;
                                  },
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                  decoration: const InputDecoration(
                                      hintText: "Title",
                                      border: InputBorder.none),
                                ))
                              : Expanded(
                                  child: Text(
                                  item.name,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ))
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      // padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: editable
                          ? TextField(
                              maxLines: 1,
                              controller: TextEditingController(
                                  text: item.price.toStringAsFixed(2)),
                              onChanged: (value) {
                                item.price = double.parse(value);
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: false, decimal: true),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.grey),
                              decoration: const InputDecoration(
                                  hintText: "Price", border: InputBorder.none),
                            )
                          : Container(
                              child: Text(
                              "${item.price.toStringAsFixed(2)}€",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ))),
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
