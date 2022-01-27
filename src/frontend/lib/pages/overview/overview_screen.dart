import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/api.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/overview/components/body.dart';
import 'package:frontend/utils.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getRoleInRestaurant = r"""
query RoleInRestaurant($restaurantId: ID!) {
  roleInRestaurant(restaurantId: $restaurantId) {
    role
  }
}
""";

// ignore: must_be_immutable
class OverviewScreen extends StatelessWidget {
  final UserType userType;
  late OverviewArguments args;
  OverviewScreen({Key? key, this.userType = UserType.none}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    args = getOverviewArguments(context);

    return Query(
      options: QueryOptions(
        document: gql(getRoleInRestaurant),
        variables: {
          'restaurantId': args.restaurantId,
        },
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return handleError(result.exception!);
        }

        if (result.isLoading) {
          return const SpinKitRotatingCircle(color: Colors.white, size: 50.0);
        }

        // it can be either Map or List
        String userTypeFetch = result.data!['roleInRestaurant']['role'];
        userRole = UserType.values.firstWhere(
            (e) => e.toString() == 'UserType.' + userTypeFetch.toLowerCase(),
            orElse: () => UserType.none);

        return Scaffold(body: Body(userType: userRole, args: args));
      },
    );
  }
}
