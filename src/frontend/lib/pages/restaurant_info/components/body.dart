import 'package:flutter/material.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/rounded_input_field.dart';
import 'package:frontend/common_components/rounded_multiline_input_field.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/restaurant_info/components/background.dart';

class Body extends StatelessWidget {
  String restaurantName = '';
  String restaurantStreetNr = '';
  String restaurantZipCode = '';
  String restaurantCity = '';
  String restaurantDescription = '';

  Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // total height and width of screen

    return Background(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ListView(
          children: [
            const Text(
              "Restaurant information",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            RoundedInputField(
                hintText: "Restaurant name",
                icon: Icons.store_mall_directory,
                onChanged: (value) {
                  restaurantName = value;
                }),
            RoundedInputField(
              hintText: "Street and number",
              icon: Icons.store_mall_directory,
              onChanged: (value) {
                restaurantStreetNr = value;
              },
            ),
            RoundedInputField(
              hintText: "Zip code",
              icon: Icons.store_mall_directory,
              onChanged: (value) {
                restaurantZipCode = value;
              },
            ),
            RoundedInputField(
              hintText: "City",
              icon: Icons.store_mall_directory,
              onChanged: (value) {
                restaurantCity = value;
              },
            ),
            RoundedMultilineInputField(
              hintText: "Description",
              icon: Icons.info_outlined,
              onChanged: (value) {
                restaurantDescription = value;
              },
            ),
          ],
        ),
        RoundedButton(
            text: "Save",
            click: () {
              if (restaurantName.isEmpty ||
                  restaurantDescription.isEmpty ||
                  restaurantStreetNr.isEmpty ||
                  restaurantZipCode.isEmpty ||
                  restaurantCity.isEmpty) {
                showErrorMessage('Please fill out all required values');
              } else {
                // TODO: save restaurant information
                // sucessfull --> back to overview
                // unlucky --> toast, all fields must be set
              }
            })
      ],
    ));
  }
}
