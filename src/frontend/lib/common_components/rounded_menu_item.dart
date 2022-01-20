import 'package:flutter/material.dart';
import 'package:frontend/common_components/text_field_container.dart';

class RoundedMenuItem extends StatefulWidget {
  final VoidCallback click;
  final Map<String, dynamic> item;
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
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<RoundedMenuItem> {
  bool _hasBeenPressed = false;

  _ButtonState();

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          widget.editable
                              ? Expanded(
                                  child: TextField(
                                  controller: TextEditingController(
                                      text: widget.item["name"]),
                                  maxLines: 1,
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    widget.item["name"] = value;
                                  },
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                  decoration: const InputDecoration(
                                      hintText: "Title",
                                      border: InputBorder.none),
                                ))
                              : Expanded(
                                  child: Text(
                                  widget.item["name"],
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ))
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      // padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: widget.editable
                          ? TextField(
                              maxLines: 1,
                              controller: TextEditingController(
                                  text:
                                      widget.item["price"].toStringAsFixed(2)),
                              onChanged: (value) {
                                widget.item["price"] = double.parse(value);
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: false, decimal: true),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.grey),
                              decoration: const InputDecoration(
                                  hintText: "Price", border: InputBorder.none),
                            )
                          : Text(
                              "${widget.item["price"].toStringAsFixed(2)}€",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )),
                  Visibility(
                      visible: widget.addButtonVisible,
                      child: IconButton(
                        icon: const Icon(Icons.add_circle_outline_sharp),
                        color: Colors.black87,
                        iconSize: 40,
                        onPressed: () {
                          widget.click();
                        },
                      )),
                ],
              ),
              Row(
                children: [
                  Visibility(
                    child: Expanded(
                        child: widget.editable
                            ? TextField(
                                maxLines: 1,
                                controller: TextEditingController(
                                    text: widget.item["description"]),
                                onChanged: (value) {
                                  widget.item["description"] = value;
                                },
                                keyboardType: TextInputType.text,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.grey),
                                decoration: const InputDecoration(
                                    hintText: "Description",
                                    contentPadding: EdgeInsets.only(left: 25),
                                    border: InputBorder.none),
                                textAlign: TextAlign.left,
                              )
                            : Container(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text(
                                  widget.item["description"],
                                  style: const TextStyle(fontSize: 15),
                                  textAlign: TextAlign.left,
                                ))),
                    visible: _hasBeenPressed,
                  ),
                ],
              )
            ],
          )),
    ));
  }
}
