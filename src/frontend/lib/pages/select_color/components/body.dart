import 'package:flutter/material.dart';
import 'package:frontend/common_components/background.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/select_color/color_screen.dart';
import 'package:frontend/utils.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String checkIn = r'''
mutation ChangeBookingStatus($tableId: ID!, $code: [ValidationColors!]!) {
  checkIn(tableId: $tableId, code: $code) {
    id
  }
}
''';

class Body extends State<ColorScreen> {
  var colors = <String>['RED', 'GREEN', 'BLUE', 'YELLOW'];
  String color1 = "RED";
  String color2 = "RED";
  String color3 = "RED";
  String color4 = "RED";

  @override
  Widget build(BuildContext context) {
    var args = getOverviewArguments(context);

    return Scaffold(
        appBar: getAppBar("Verification"),
        body: Background(
            child: Column(children: [
          // Display hint
          Container(
            padding: const EdgeInsets.all(20),
            child: const Text(
              "Look at the device on the reserved table and pick the colors, that will light up, in the correct order. If you want to see the colors again. Press the button on the device.",
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
          // Main content
          Expanded(
            flex: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getWigetColor1(),
                getWigetColor2(),
                getWigetColor3(),
                getWigetColor4(),
              ],
            ),
          ),
          Expanded(
              child: TextFieldContainer(
                  // Mutatation check in on table with selected color code
                  child: Mutation(
                      options: MutationOptions(
                          document: gql(checkIn),
                          onCompleted: (data) {
                            if (data != null) {
                              showFeedback("Check in on table was successful.");
                              Navigator.pushNamed(context, '/overview',
                                  arguments: OverviewArguments(
                                      args.restaurantId,
                                      args.tableId,
                                      data["checkIn"]["id"]));
                            }
                          },
                          onError: (error) =>
                              {showErrorMessage("Farbauswahl ist falsch.")}),
                      builder: (RunMutation runMutation, QueryResult? result) {
                        return RoundedButton(
                          text: "Continue",
                          click: () {
                            runMutation({
                              "tableId": args.tableId,
                              "code": [color1, color2, color3, color4]
                            });
                          },
                        );
                      })))
        ])));
  }

  Widget getWigetColor1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.only(right: 20, top: 40, bottom: 40),
            child: const Text(
              "Color 1: ",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            )),
        DropdownButton<String>(
          value: color1,
          icon: const Icon(Icons.arrow_drop_down_outlined),
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          underline: Container(
            height: 2,
            color: Colors.black,
          ),
          onChanged: (String? newValue) {
            setState(() {
              color1 = newValue!;
            });
          },
          items: colors.map<DropdownMenuItem<String>>((String value) {
            return getDropdownMenuItem(value);
          }).toList(),
        )
      ],
    );
  }

  Widget getWigetColor2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.only(right: 20, top: 40, bottom: 40),
            child: const Text(
              "Color 2: ",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            )),
        DropdownButton<String>(
          value: color2,
          icon: const Icon(Icons.arrow_drop_down_outlined),
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          underline: Container(
            height: 2,
            color: Colors.black,
          ),
          onChanged: (String? newValue) {
            setState(() {
              color2 = newValue!;
            });
          },
          items: colors.map<DropdownMenuItem<String>>((String value) {
            return getDropdownMenuItem(value);
          }).toList(),
        )
      ],
    );
  }

  Widget getWigetColor3() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.only(right: 20, top: 40, bottom: 40),
            child: const Text(
              "Color 3: ",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            )),
        DropdownButton<String>(
          value: color3,
          icon: const Icon(Icons.arrow_drop_down_outlined),
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          underline: Container(
            height: 2,
            color: Colors.black,
          ),
          onChanged: (String? newValue) {
            setState(() {
              color3 = newValue!;
            });
          },
          items: colors.map<DropdownMenuItem<String>>((String value) {
            return getDropdownMenuItem(value);
          }).toList(),
        )
      ],
    );
  }

  Widget getWigetColor4() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.only(right: 20, top: 40, bottom: 40),
            child: const Text(
              "Color 4: ",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            )),
        DropdownButton<String>(
          value: color4,
          icon: const Icon(Icons.arrow_drop_down_outlined),
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          underline: Container(
            height: 2,
            color: Colors.black,
          ),
          onChanged: (String? newValue) {
            setState(() {
              color4 = newValue!;
            });
          },
          items: colors.map<DropdownMenuItem<String>>((String value) {
            return getDropdownMenuItem(value);
          }).toList(),
        )
      ],
    );
  }

  DropdownMenuItem<String> getDropdownMenuItem(String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Row(children: [
        SizedBox(
            width: 20,
            height: 20,
            child: ColoredBox(
                color: value == "RED"
                    ? Colors.red
                    : value == "GREEN"
                        ? Colors.green
                        : value == "BLUE"
                            ? Colors.blue
                            : Colors.yellow)),
        Container(
          padding: const EdgeInsets.only(left: 10),
          child: Text(value),
        )
      ]),
    );
  }
}
