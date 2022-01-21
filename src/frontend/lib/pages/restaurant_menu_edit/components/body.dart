import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/api.dart';
import 'package:frontend/common_components/rounded_menu_item.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/common_components/background.dart';
import 'package:frontend/pages/restaurant_menu_edit/restaurant_menu_edit_screen.dart';
import 'package:frontend/utils.dart';
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
  Body();

  @override
  Widget build(BuildContext context) {
    var args = getOverviewArguments(context);

    return Query(
        options: QueryOptions(
          document: gql(getMenuQuery),
          variables: {
            'restaurantId': args.restaurantId,
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

          return Scaffold(
              appBar: getAppBar("Edit Restaurant Menu"),
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
                                  widget.editable.remove(item["id"]);
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
                                    editable:
                                        widget.editable.containsKey(item["id"]),
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
                                                  if (refetch != null)
                                                    {refetch()}
                                                },
                                              ),
                                              builder: (RunMutation runMutation,
                                                  QueryResult? result) {
                                                return IconButton(
                                                    onPressed: () {
                                                      runMutation({
                                                        "menuItemId":
                                                            item["id"],
                                                        "menuItem": {
                                                          "name": item["name"],
                                                          "price":
                                                              item["price"],
                                                          "description": item[
                                                              "description"],
                                                          "type": item["type"]
                                                        }
                                                      });
                                                      setState(() {
                                                        if (widget.editable
                                                            .containsKey(
                                                                item["id"])) {
                                                          widget.editable
                                                              .remove(
                                                                  item["id"]);
                                                        } else {
                                                          widget.editable[
                                                                  item["id"]] =
                                                              true;
                                                        }
                                                      });
                                                    },
                                                    icon: Icon(
                                                      widget.editable
                                                              .containsKey(
                                                                  item["id"])
                                                          ? Icons.check_outlined
                                                          : Icons.edit_rounded,
                                                      color: widget.editable
                                                              .containsKey(
                                                                  item["id"])
                                                          ? Colors.green[800]
                                                          : Colors.black87,
                                                    ));
                                              }),
                                          Mutation(
                                              options: MutationOptions(
                                                document:
                                                    gql(delMenuItemMutation),
                                                onCompleted: (data) => {
                                                  showFeedback("Item deleted."),
                                                  if (refetch != null)
                                                    {refetch()}
                                                },
                                                onError: (error) => handleError(
                                                    error
                                                        as OperationException),
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
                                                      Icons
                                                          .delete_outline_rounded,
                                                      color: Color.fromARGB(
                                                          255, 255, 0, 0),
                                                    ));
                                              }),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              )));
                        },
                      )),
                  if (widget.item.isNotEmpty)
                    Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.none,
                        onDismissed: (_) {},

                        // Display item's title, price...
                        child: TextFieldContainer(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RoundedMenuItem(
                                item: widget.item,
                                addButtonVisible: false,
                                editable: true,
                                click: () {},
                              ),
                            ),
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
                                              widget.item = {};
                                            });
                                          },
                                          onError: (error) => handleError(
                                              error as OperationException),
                                        ),
                                        builder: (RunMutation runMutation,
                                            QueryResult? result) {
                                          return IconButton(
                                              onPressed: () {
                                                runMutation({
                                                  'restaurantId':
                                                      args.restaurantId,
                                                  'menuItem': {
                                                    'name': widget.item['name'],
                                                    'description':
                                                        widget.item['name'],
                                                    'price':
                                                        widget.item['price'],
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
                                            widget.item = {};
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          color: Color.fromARGB(255, 255, 0, 0),
                                        ))
                                  ],
                                ),
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
                            widget.item = {
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
