import 'package:flutter/material.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/rounded_menu_item.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/pages/order_view/components/body.dart';
import 'package:frontend/pages/restaurant_info/components/background.dart';
import 'package:frontend/pages/restaurant_menu_edit/restaurant_menu_edit_screen.dart';

class Body extends State<RestaurantMenuEditScreen> {
  final List<MenuItem> items;
  Body({required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Background(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            flex: 6,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                // Display the list item
                return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.none,
                    onDismissed: (_) {
                      setState(() {
                        items.removeAt(index);
                      });
                    },

                    // Display item's title, price...
                    child: TextFieldContainer(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: RoundedMenuItem(
                          item: items[index],
                          addButtonVisible: false,
                          click: () {/* TODO: Open edit*/},
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.edit_rounded,
                                      color: Colors.black87,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        items.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Color.fromARGB(255, 255, 0, 0),
                                    ))
                              ],
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.menu,
                                  color: Colors.black87,
                                )),
                          ],
                        )
                      ],
                    )));
              },
            )),
        Expanded(
            flex: 1,
            child: TextFieldContainer(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline_rounded),
                  onPressed: () {
                    setState(() {
                      items.add(MenuItem("", "", "", 0.00, true, "", ""));
                    });
                  },
                ),
                RoundedButton(
                    text: "Save",
                    click: () {
                      // TODO: Save current list of items
                      // -> return to admin overview
                    }),
              ],
            )))
      ],
    )));
  }
}
