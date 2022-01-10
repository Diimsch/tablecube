import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../constants.dart';
import 'components/body.dart';

class RestaurantMenuEditScreen extends StatefulWidget {
  const RestaurantMenuEditScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    if (userType != UserType.ADMIN) {
      // TODO: logout and toast
      // return to WelcomeScreen
    }

    // TODO: get menu list
    Map<String, dynamic>? item;
    Map<String, bool> editable = {};

    return Body(item: item, editable: editable);
  }
}
