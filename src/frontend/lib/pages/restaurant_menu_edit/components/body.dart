import 'package:flutter/material.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/rounded_menu_item.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/pages/order_view/components/body.dart';
import 'package:frontend/pages/restaurant_info/components/background.dart';
import 'package:frontend/pages/restaurant_menu_edit/restaurant_menu_edit_screen.dart';

class Body extends State<RestaurantMenuEditScreen> {
  final List<Map<String, dynamic>> items;
  final List<bool> editables;
  Body({required this.items, required this.editables});

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
                        editables.removeAt(index);
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
                          editable: editables[index],
                          click: () {},
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (editables[index]) {
                                          if (isValid(items[index])) {
                                            editables[index] = false;
                                          }
                                        } else {
                                          editables[index] = !editables[index];
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      editables[index]
                                          ? Icons.check_outlined
                                          : Icons.edit_rounded,
                                      color: editables[index]
                                          ? Colors.green[800]
                                          : Colors.black87,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        items.removeAt(index);
                                        editables.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Color.fromARGB(255, 255, 0, 0),
                                    ))
                              ],
                            ),
                            // TODO: Darg and Drop
                            // IconButton(
                            //     onPressed: () {},
                            //     icon: const Icon(
                            //       Icons.menu,
                            //       color: Colors.black87,
                            //     )),
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
                      editables.add(true);
                      items.add({
                        "name": "",
                        "description": "",
                        "price": 0.00,
                        "available": true,
                        "type": "FOOD"
                      });
                    });
                  },
                ),
                RoundedButton(
                    text: "Save",
                    click: () {
                      for (var i = 0; i < items.length; i++) {
                        if (!isValid(items[i])) {
                          return;
                        }
                        editables[i] = false;
                      }
                      // TODO: Save current list of items
                      // -> return to admin overview
                    }),
              ],
            )))
      ],
    )));
  }

  bool isValid(Map<String, dynamic> item) {
    return item["name"] != null &&
        item["name"] != "" &&
        item["description"] != null &&
        item["description"] != "" &&
        item["price"] != null &&
        item["price"] > 0.0;
  }
}
