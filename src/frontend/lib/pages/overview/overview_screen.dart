import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/api.dart';
import 'package:frontend/common_components/rounded_menu_item.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/overview/components/body.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getRoleInRestaurant = r"""
query RoleInRestaurant($restaurantId: ID!) {
  roleInRestaurant(restaurantId: $restaurantId) {
    role
  }
}
""";

class OverviewScreen extends StatelessWidget {
  UserType userType;
  OverviewScreen({Key? key, this.userType = UserType.NONE}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments == null
        ? OverviewArguments('null', 'null')
        : ModalRoute.of(context)!.settings.arguments as OverviewArguments;

    debugPrint('helo: $args.restaurantId');
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
        UserType f = UserType.values.firstWhere(
            (e) => e.toString() == 'UserType.' + userTypeFetch,
            orElse: () => UserType.NONE);
        return Scaffold(body: Body(userType: f, args: args));
      },
    );
  }
}
