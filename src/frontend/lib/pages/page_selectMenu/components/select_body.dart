import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/api.dart';
import 'package:frontend/bottom_nav_bar/account_bubble.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/rounded_menu_item.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/page_selectMenu/components/background.dart';
import 'package:frontend/pages/page_selectMenu/select_menu.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
    var args = ModalRoute.of(context)!.settings.arguments == null
        ? OverviewArguments('null', 'null', 'null')
        : ModalRoute.of(context)!.settings.arguments as OverviewArguments;

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
            appBar: AppBar(
              actions: [
                AccountBubble(click: () {
                  logOutUser();
                })
              ],
              title: const Text("Menu items"),
              centerTitle: true,
              elevation: 0,
              backgroundColor: primaryColor,
            ),
            body: Background(
                body: Column(children: [
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
                          text: "Show selected orders",
                          click: () {
                            Navigator.pushNamed(context, "/cart");
                          }))
                ],
              ))
            ])));
      },
    );
  }
}
