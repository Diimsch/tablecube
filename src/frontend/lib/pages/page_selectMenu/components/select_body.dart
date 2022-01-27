import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/common_components/background.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/rounded_menu_item.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/pages/page_selectMenu/select_menu.dart';
import 'package:frontend/utils.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Query to fetch the menu of a restaurant
const String getMenuQuery = r"""
query getMenu($restaurantId: ID!) {
  menu(restaurantId: $restaurantId) {
    id
    name
    description
    price
    type
    available
  }
}
""";

class SelectBody extends State<SelectMenuScreen> {
  final List<Map<String, dynamic>> items;
  SelectBody({required this.items});

  @override
  Widget build(BuildContext context) {
    var args = getOverviewArguments(context);

    return Query(
      options: QueryOptions(
        document: gql(getMenuQuery),
        variables: {
          'restaurantId': args.restaurantId,
        },
        pollInterval: const Duration(seconds: 120),
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return const SpinKitRotatingCircle(color: Colors.white, size: 50.0);
        }

        List menuItems = result.data!['menu'];

        return Scaffold(
            appBar: getAppBar("Select Menu Items"),
            body: Background(
                child: Column(children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        return RoundedMenuItem(
                          item: menuItems[index],
                          click: () {
                            items.add(menuItems[index]);
                            showFeedback("Items added to selection.");
                          },
                          editable: false,
                        );
                      })),
              TextFieldContainer(
                  child: Row(
                children: [
                  Expanded(
                      child: RoundedButton(
                          text: "Confirm order",
                          click: () {
                            Navigator.pushReplacementNamed(
                              context,
                              '/cart',
                              arguments: args,
                            );
                          }))
                ],
              ))
            ])));
      },
    );
  }
}
