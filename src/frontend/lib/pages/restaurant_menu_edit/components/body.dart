import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/rounded_menu_item.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/restaurant_info/components/background.dart';
import 'package:frontend/pages/restaurant_menu_edit/restaurant_menu_edit_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getMenuQuery = r"""
query($restaurantId: ID!) {
  menu(restaurantId: $restaurantId) {
    id
    name
    description
    price
    available
    type
  }
}
""";

const String addMenuItemMutation = r"""
mutation AddMenuItem($restaurantId: ID!, $menuItem: CreateMenuItemInput!) {
  addMenuItem(restaurantId: $restaurantId, menuItem: $menuItem) {
    id
    name
    description
    price
    type
    available
  }
}
""";

const String delMenuItemMutation = r"""
mutation DelMenuItem($menuItemId: ID!) {
  delMenuItem(menuItemId: $menuItemId) {
    id
    name
    description
    price
    type
    available
  }
}
""";

const String updateMenuItemMutation = r"""
mutation UpdateMenuItem($menuItemId: ID!, $menuItem: CreateMenuItemInput!) {
  updateMenuItem(menuItemId: $menuItemId, menuItem: $menuItem) {
    id
    name
    description
    price
    type
    available
  }
}
""";

class Body extends State<RestaurantMenuEditScreen> {
  Map<String, dynamic>? item;
  Map<String, bool> editable;
  Body({required this.item, required this.editable});

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments == null
        ? OverviewArguments('null', 'null', 'null')
        : ModalRoute.of(context)!.settings.arguments as OverviewArguments;

    return Query(
        options: QueryOptions(
          document: gql(getMenuQuery),
          variables: {
            'restaurantId': "65a2929f-66aa-465b-88c0-be6ef3a10504",
          },
          pollInterval: const Duration(seconds: 60),
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const SpinKitRotatingCircle(color: Colors.white, size: 50.0);
          }

          // it can be either Map or List
          List menuItems = result.data!['menu'];

          //List editables = List.generate(menuItems.length, (index) => false);

          return Scaffold(
              body: Background(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 5,
                  child: ListView.builder(
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      final item = menuItems[index];
                      // Display the list item
                      return Dismissible(
                          key: Key(item['id']),
                          direction: DismissDirection.none,
                          onDismissed: (_) {
                            setState(() {
                              editable.remove(item["id"]);
                            });
                          },

                          // Display item's title, price...
                          child: TextFieldContainer(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: RoundedMenuItem(
                                item: item,
                                addButtonVisible: false,
                                editable: editable.containsKey(item["id"]),
                                click: () {},
                              )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Mutation(
                                          options: MutationOptions(
                                            document:
                                                gql(updateMenuItemMutation),
                                            onCompleted: (data) => {
                                              if (refetch != null) {refetch()}
                                            },
                                          ),
                                          builder: (RunMutation runMutation,
                                              QueryResult? result) {
                                            return IconButton(
                                                onPressed: () {
                                                  runMutation({
                                                    "menuItemId": item["id"],
                                                    "menuItem": {
                                                      "name": item["name"],
                                                      "price": item["price"],
                                                      "description":
                                                          item["description"],
                                                      "type": item["type"]
                                                    }
                                                  });
                                                  setState(() {
                                                    if (editable.containsKey(
                                                        item["id"])) {
                                                      editable
                                                          .remove(item["id"]);
                                                    } else {
                                                      editable[item["id"]] =
                                                          true;
                                                    }
                                                  });
                                                },
                                                icon: Icon(
                                                  editable.containsKey(
                                                          item["id"])
                                                      ? Icons.check_outlined
                                                      : Icons.edit_rounded,
                                                  color: editable.containsKey(
                                                          item["id"])
                                                      ? Colors.green[800]
                                                      : Colors.black87,
                                                ));
                                          }),
                                      Mutation(
                                          options: MutationOptions(
                                            document: gql(delMenuItemMutation),
                                            onCompleted: (data) => {
                                              if (refetch != null) {refetch()}
                                            },
                                          ),
                                          builder: (RunMutation runMutation,
                                              QueryResult? result) {
                                            return IconButton(
                                                onPressed: () {
                                                  runMutation({
                                                    'menuItemId': item['id']
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.delete_outline_rounded,
                                                  color: Color.fromARGB(
                                                      255, 255, 0, 0),
                                                ));
                                          }),
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
              if (item != null)
                Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.none,
                    onDismissed: (_) {
                      /*
                            setState(() {
                              menuItems.removeAt(index);
                              editables.removeAt(index);
                            });
                            */
                    },

                    // Display item's title, price...
                    child: TextFieldContainer(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: RoundedMenuItem(
                          item: item!,
                          addButtonVisible: false,
                          editable: true,
                          click: () {},
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Mutation(
                                    options: MutationOptions(
                                      document: gql(addMenuItemMutation),
                                      onCompleted: (data) {
                                        showFeedback("Item added.");
                                        if (refetch != null) {
                                          refetch();
                                        }

                                        setState(() {
                                          item = null;
                                        });
                                      },
                                    ),
                                    builder: (RunMutation runMutation,
                                        QueryResult? result) {
                                      return IconButton(
                                          onPressed: () {
                                            runMutation({
                                              'restaurantId':
                                                  '15727139-d6b4-4aac-b8e2-033ecad4935f',
                                              'menuItem': {
                                                'name': item!['name'],
                                                'description': item!['name'],
                                                'price': item!['price'],
                                                'type': "FOOD",
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.check_outlined,
                                              color: Colors.green[800]));
                                    }),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        item = null;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Color.fromARGB(255, 255, 0, 0),
                                    ))
                                /*
                                    Mutation(
                                        options: MutationOptions(
                                          document: gql(delMenuItemMutation),
                                          onCompleted: (data) => {
                                            if (refetch != null) {refetch()}
                                          },
                                        ),
                                        builder: (RunMutation runMutation,
                                            QueryResult? result) {
                                          return IconButton(
                                              onPressed: () {
                                                runMutation(
                                                    {'menuItemId': item['id']});
                                              },
                                              icon: const Icon(
                                                Icons.delete_outline_rounded,
                                                color: Color.fromARGB(
                                                    255, 255, 0, 0),
                                              ));
                                        }),*/
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
                    ))),
              TextFieldContainer(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    onPressed: () {
                      setState(() {
                        item = {
                          "name": "",
                          "description": "",
                          "price": 0.00,
                          "available": true,
                          "type": "FOOD"
                        };
                      });
                    },
                  ),
                ],
              ))
            ],
          )));
        });
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
