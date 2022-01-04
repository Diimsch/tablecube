import 'package:flutter/material.dart';
import 'package:frontend/common_components/rounded_menu_item.dart';
import 'package:frontend/pages/order_view/components/body.dart';
import 'package:frontend/pages/page_selectMenu/components/background.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/* TODO:
  -test listview for backend input
 */

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

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getMenuQuery),
        variables: {
          'restaurantId': '15727139-d6b4-4aac-b8e2-033ecad4935f',
        },
        pollInterval: Duration(seconds: 10),
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return Text('Loading');
        }

        // it can be either Map or List
        List menuItems = result.data!['menu'];

        return ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              return RoundedMenuItem(
                menu: menuItems[index],
                click: () {
                  debugPrint("222");
                },
              );

              /*return Text(counters[index]['name'] +
                  ":" +
                  counters[index]["description"]);*/
            });
      },
    );
    /* Background(
            body: ListView(
      children: [
        const SizedBox(
          height: 30,
        ),
        RoundedMenuItem(
          item: MenuItem(
              "Hacksteak mit wüzigen Kartoffeln",
              "Hacksteak mit wüzigen Kartoffeln",
              "Hacksteak mit wüzigen Kartoffeln",
              2.2,
              true,
              "",
              ""),
          click: () {},
          editable: false,
        ),
        RoundedMenuItem(
          item: MenuItem("", "", "", 2.2, true, "", ""),
          click: () {},
          editable: false,
        ),
        RoundedMenuItem(
          item: MenuItem("", "", "", 2.2, true, "", ""),
          click: () {},
          editable: false,
        ),
        RoundedMenuItem(
          item: MenuItem("", "", "", 2.2, true, "", ""),
          click: () {},
          editable: false,
        ),
      ],
    ));*/
  }
}
