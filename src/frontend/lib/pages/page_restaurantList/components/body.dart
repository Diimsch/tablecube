import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getRestaurantsQuery = r"""
query Query {
  restaurant {
    id
    name
    tables {
      id
      name
    }
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
                      subtitle: Text('Tables: ' +
                          restaurants[index]['tables'].length.toString()),
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
                                arguments: OverviewArguments(
                                    restaurants[index]['id'],
                                    "95f099e5-057a-45f0-b14a-0b62df4862d2"));
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
