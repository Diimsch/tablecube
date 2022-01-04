import 'package:flutter/material.dart';
import 'package:frontend/common_components/rounded_menu_item.dart';
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
          'restaurantId': '0bc67384-f77d-4f8b-a28f-9225f71b909d',
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
  }
}
