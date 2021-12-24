import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:intl/intl.dart';

final formatCurrency = NumberFormat.simpleCurrency();

class RoundedMenuItem extends StatefulWidget {
  final VoidCallback click;
  final Map<String, dynamic> menu;
  final Color color, textColor;

  const RoundedMenuItem({
    Key? key,
    required this.click,
    required this.menu,
    this.color = primaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

/*
      {
        "id": "220ad992-e97f-4e29-939c-791c9452605f",
        "name": "Falafeltasche",
        "description": "Leckere Falafeltasche mit Salat und Knoblauchsauce",
        "price": 5,
        "type": "FOOD",
        "available": true
      },
*/
class _ButtonState extends State<RoundedMenuItem> {
  bool _hasBeenPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          color: primaryColor,
        ),
        child: Column(children: [
          Row(
            //runAlignment: WrapAlignment.center,
            //crossAxisAlignment: WrapCrossAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: TextButton.icon(
                  icon: Icon(_hasBeenPressed
                      ? Icons.arrow_drop_up_sharp
                      : Icons.arrow_drop_down_sharp),
                  label: Text(
                    widget.menu["name"],
                    style: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () => {
                    setState(() {
                      _hasBeenPressed = !_hasBeenPressed;
                    })
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    formatCurrency.format(widget.menu["price"]),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    //softWrap: true,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_box_rounded),
                    color: Colors.white,
                    iconSize: 50,
                    onPressed: () {
                      widget.click();
                    },
                  ),
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _hasBeenPressed
                  ? buildText(widget.menu["description"])
                  : const SizedBox.shrink()
            ],
          )
        ]));
  }

  Widget buildText(String text) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(text,
                style: const TextStyle(fontSize: 15, color: Colors.white),
                textAlign: TextAlign.center)));
  }
}
