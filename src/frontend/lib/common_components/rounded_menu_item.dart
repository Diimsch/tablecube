import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

class RoundedMenuItem extends StatefulWidget {
  final VoidCallback click;
  final Color color, textColor;

  const RoundedMenuItem({
    Key? key,
    required this.click,
    this.color = primaryColor,
    this.textColor = Colors.white,
    required Null Function() onPressed,
  }) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State {
  bool _hasBeenPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: primaryColor,
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: 50.5,
        direction: Axis.horizontal,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: TextButton.icon(
              icon: Icon(_hasBeenPressed
                  ? Icons.arrow_drop_up_sharp
                  : Icons.arrow_drop_down_sharp),
              label: const Text(
                "Platzhalter",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () => {
                setState(() {
                  _hasBeenPressed = !_hasBeenPressed;
                })
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: primaryColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              ),
            ),
          ),
          const Text(
            "\n5,50",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            softWrap: true,
          ),
          IconButton(
            icon: const Icon(Icons.add_box_rounded),
            color: Colors.white,
            iconSize: 50,
            onPressed: () {},
          ),
          _hasBeenPressed
              ? buildText("Steak in herzhafter Pilzsauce und kleinem Salat.")
              : buildText(""),
        ],
      ),
    );
  }

  Widget buildText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 25, color: Colors.white),
      textAlign: TextAlign.center,
    );
  }
}
