import 'package:flutter/material.dart';
import 'package:frontend/common_components/rounded_menu_item.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/page_restaurantList/components/background.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getRestaurantsQuery = r"""
query Query {
  restaurant {
    name
  }
}
""";

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getRestaurantsQuery),
        pollInterval: const Duration(seconds: 10),
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return const Text('Loading');
        }

        // it can be either Map or List
        List restaurants = result.data!['restaurant'];

        return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              return Center(
                  child: Card(
                      child: InkWell(
                splashColor: primaryLightColor,
                onTap: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.food_bank),
                      title: Text(restaurants[index]['name']),
                      subtitle: const Text('Description'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                              primary: primaryColor,
                              backgroundColor: primaryLightColor),
                          child: const Text('Go To Restauarant'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/overview',
                                arguments: OverviewArguments('restaurantId'));
                          },
                        ),
                        const SizedBox(width: 9),
                      ],
                    ),
                  ],
                ),
              )));
            });
      },
    );
  }
}
