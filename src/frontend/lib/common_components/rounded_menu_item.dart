import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

class RoundedMenuItem extends StatefulWidget {
  final VoidCallback click;
  final Color color, textColor;

  const RoundedMenuItem(
      {Key? key,
      required this.click,
      this.color = primaryColor,
      this.textColor = Colors.white,
      required Null Function() onPressed,
      })
      : super(key: key);
  @override
  _ButtonState createState() => _ButtonState();

}

class _ButtonState extends State{

  bool _hasBeenPressed = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.7,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20),
        ),
        color: primaryColor,
      ),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: TextButton.icon(
              icon: Icon(_hasBeenPressed ? Icons.arrow_drop_up_sharp : Icons.arrow_drop_down_sharp),
              label: const Text("Platzhalter"),
              onPressed: () => {
                setState(() {
                _hasBeenPressed = ! _hasBeenPressed;
                })
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: primaryColor,
                padding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              ),
            ),
          ),
          const SizedBox(
            width:100,
          ),
          IconButton(
            icon: const Icon(Icons.add_box_rounded),
            color: Colors.white,
            iconSize: 50,
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

