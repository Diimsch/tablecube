import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/overview/overview_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getRestaurantsQuery = r"""
query Query {
  restaurant {
    id
    name
    description
    city
    zipCode
    address
    tables {
      id
      name
    }
    occupyingBookings {
      table {
        occupyingBooking {
          id
        }
      }
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
          return const SpinKitRotatingCircle(color: Colors.white, size: 50.0);
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
                      subtitle: Text((restaurants[index]['tables'].length -
                                  restaurants[index]['occupyingBookings']
                                      .length)
                              .toString() +
                          ' out of ' +
                          restaurants[index]['tables'].length.toString() +
                          ' Table(s) available'),
                    ),
                    Row(children: [
                      const SizedBox(width: 70),
                      Text(restaurants[index]['zipCode'] ?? '',
                          textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(width: 5),
                      Text(restaurants[index]['city'] ?? '',
                          textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.grey)),
                    ]),
                    Row(children: [
                      const SizedBox(width: 70),
                      Text(restaurants[index]['address'] ?? '',
                          textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.grey)),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Query(
                            options: QueryOptions(
                              document: gql(getRoleInRestaurant),
                              variables: {
                                'restaurantId': restaurants[index]['id'],
                              },
                              pollInterval: const Duration(seconds: 120),
                            ),
                            builder: (QueryResult result,
                                {VoidCallback? refetch, FetchMore? fetchMore}) {
                              if (result.hasException) {
                                return Text(result.exception.toString());
                              }

                              if (result.isLoading) {
                                return const SpinKitRotatingCircle(
                                    color: Colors.white, size: 50.0);
                              }
                              // it can be either Map or List
                              String userTypeFetch =
                                  result.data!['roleInRestaurant']['role'];
                              UserType f = UserType.values.firstWhere(
                                  (e) =>
                                      e.toString() ==
                                      'UserType.' + userTypeFetch,
                                  orElse: () => UserType.NONE);

                              return TextButton(
                                style: TextButton.styleFrom(
                                    primary: primaryColor,
                                    backgroundColor: primaryLightColor),
                                child: const Text('Go To Restauarant'),
                                onPressed: () {
                                  if (f == UserType.NONE) {
                                    Navigator.pushNamed(context, '/scanner',
                                        arguments: OverviewArguments(
                                            restaurants[index]['id'],
                                            "null",
                                            "null"));
                                  } else {
                                    Navigator.pushNamed(context, '/overview',
                                        arguments: OverviewArguments(
                                            restaurants[index]['id'],
                                            "null",
                                            "null"));
                                  }
                                },
                              );
                            }),
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
