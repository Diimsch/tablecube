import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/main.dart';
import 'package:frontend/utils.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../constants.dart';

const String getRestaurantsQuery = r"""
query Restaurants {
  restaurants {
    id
    name
    tables {
      id
      name
      occupyingBooking {
        id
        status
      }
    }
  }
}
""";

class TableOverviewScreen extends StatelessWidget {
  final String restaurantId;
  const TableOverviewScreen({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (userType != UserType.waiter) {
      // TODO: logout and toast
      // return to WelcomeScreen
    }
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
        List restaurants = result.data!['restaurants'];

        List selectedRestaurant =
            restaurants.where((r) => r['id'] == restaurantId).toList();

        List serviceNeededTables = selectedRestaurant[0]['tables']
                .where((t) =>
                    t['occupyingBooking']?['status'] == 'NEEDS_SERVICE' ||
                    t['occupyingBooking']?['status'] == 'READY_TO_ORDER')
                .toList() ??
            [];

        List availableTables = selectedRestaurant[0]['tables']
                .where((t) =>
                    t['occupyingBooking']?['status'] != 'NEEDS_SERVICE' &&
                    t['occupyingBooking']?['status'] != 'READY_TO_ORDER')
                .toList() ??
            [];

        return Scaffold(
            appBar: getAppBar("Table Options"),
            body: ListView(
              children: [
                Card(
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                        hasIcon: true,
                        expandIcon: Icons.alarm,
                        iconColor: warningColor),
                    header: const Center(
                        child: Text(
                      'Service Required',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
                    )),
                    collapsed: const Text(''),
                    expanded: SizedBox(
                      height: size.height / 2.5,
                      child: tableList(
                          selectedRestaurant, restaurants, serviceNeededTables),
                    ),
                  ),
                ),
                Card(
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                        hasIcon: true,
                        expandIcon: Icons.alarm,
                        iconColor: okColor),
                    header: const Center(
                        child: Text(
                      'Available Tables',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
                    )),
                    collapsed: const Text(''),
                    expanded: SizedBox(
                      height: size.height / 2.5,
                      child: tableList(
                          selectedRestaurant, restaurants, availableTables),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  ListView tableList(List<dynamic> selectedRestaurant,
      List<dynamic> restaurants, List<dynamic> tables) {
    return ListView.builder(
        itemCount: tables.length,
        itemBuilder: (context, index) {
          return Center(
              child: Card(
                  child: InkWell(
            splashColor: primaryLightColor,
            onTap: () {
              selectedItems.clear();
              Navigator.pushNamed(context, '/service',
                  arguments: OverviewArguments(restaurantId, tables[index]['id'],
                      tables[index]['occupyingBooking']['id'].toString()));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.wine_bar),
                  title: Text(tables[index]['name']),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: mapStatusToColor(tables[index]
                                  ['occupyingBooking']?['status'] ??
                              '')),
                      child: Text(mapStatusToString(
                          tables[index]['occupyingBooking']?['status'] ?? '')),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 9),
                  ],
                ),
              ],
            ),
          )));
        });
  }

  String mapStatusToString(String status) {
    switch (status) {
      case 'NEEDS_SERVICE':
        return 'Needs service';
      case 'CHECKED_IN':
        return 'Checked in';
      case 'READY_TO_ORDER':
        return 'Ready to order';
      default:
        return 'Available';
    }
  }

  Color mapStatusToColor(String status) {
    switch (status) {
      case 'NEEDS_SERVICE':
        return warningColor;
      case 'CHECKED_IN':
        return okColor;
      case 'READY_TO_ORDER':
        return warningColorOrange;
      default:
        return primaryColor;
    }
  }
}
