import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/pages/cart_view/cart_screen.dart';
import 'package:frontend/pages/cart_view/components/list-item.dart';
import 'package:frontend/pages/overview/components/background.dart';

class MenuItem {
  MenuItem(this.id, this.name, this.description, this.price, this.available,
      this.type, this.comment);
  final String id;
  final String name;
  String description;
  final double price;
  String type;
  bool available;
  String comment;
}

class Body extends State<CartScreen> {
  final List<MenuItem> items;
  Body({required this.items});

  @override
  Widget build(BuildContext context) {
    return Background(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            flex: 5,
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) => Text("A"))),
        Expanded(
            flex: 1,
            child: TextFieldContainer(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Current balance:"),
                    Text(calculateCurrentBalance().toStringAsFixed(2) + "€")
                  ],
                ),
                RoundedButton(
                    text: "Add to bill",
                    click: () {
                      addToBill();
                    })
              ],
            )))
      ],
    ));
  }

  void addToBill() {
    while (items.isNotEmpty) {
      addItemToBooking(items.first.id, "TODO", items.first.comment);
      items.removeAt(0);
    }
  }

  void deleteItem(int index) {
    items.removeAt(index);
  }

  double calculateCurrentBalance() {
    double balance = 0;
    for (var item in items) {
      balance = balance + item.price;
    }
    return balance;
  }
}
