import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/bottom_nav_bar/account_bubble.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/common_components/background.dart';
import 'package:frontend/pages/table_overview/table_overview_screen.dart';
import 'package:frontend/utils.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String updateBookingStatus = r"""
mutation ChangeBookingStatus($data: ChangeBookingStatusInput!) {
  changeBookingStatus(data: $data) {
    id
  }
}
""";

class Body extends StatelessWidget {
  final UserType userType;
  final OverviewArguments args;
  const Body({Key? key, required this.userType, required this.args})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // total height and width of screen

    // User screen
    if (userType == UserType.NONE) {
      return Scaffold(
        appBar: getAppBar("Table Options"),
        body: Background(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RoundedButton(
                  text: "Menu",
                  click: () {
                    Navigator.pushNamed(context, '/menu', arguments: args);
                  }),
              RoundedButton(
                  text: "Confirm order",
                  click: () {
                    Navigator.pushNamed(context, '/cart', arguments: args);
                  }),
              RoundedButton(
                  text: "Bill & Payment",
                  click: () {
                    Navigator.pushNamed(context, '/bill', arguments: args);
                  }),
              SizedBox(
                height: size.height * 0.05,
              ),
              Mutation(
                  options: MutationOptions(
                    document: gql(updateBookingStatus),
                    onCompleted: (data) {
                      showFeedback("Waiter was called.");
                    },
                    onError: (error) =>
                        handleError(error as OperationException),
                  ),
                  builder: (RunMutation runMutation, QueryResult? result) {
                    return RoundedButton(
                        text: "Call waiter",
                        click: () {
                          runMutation({
                            "data": {
                              "tableId": args.tableId,
                              "status": "NEEDS_SERVICE"
                            }
                          });
                        });
                  })
            ],
          ),
        )),
      );
      // waiter screen
    } else if (userType == UserType.WAITER) {
      return Background(
          child: TableOverviewScreen(restaurantId: args.restaurantId));
      // admin screen
    } else if (userType == UserType.ADMIN) {
      return Scaffold(
          appBar: AppBar(
            actions: [
              AccountBubble(click: () {
                logOutUser();
              })
            ],
            title: const Text("Admin actions"),
            centerTitle: true,
            elevation: 0,
            backgroundColor: primaryColor,
          ),
          body: Background(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RoundedButton(
                    text: "Edit restaurant information",
                    click: () {
                      Navigator.pushNamed(context, '/admin/info',
                          arguments: args);
                    }),
                RoundedButton(
                    text: "Edit menu",
                    click: () {
                      Navigator.pushNamed(context, '/admin/menu',
                          arguments: args);
                    }),
                RoundedButton(
                    text: "Edit table placement",
                    click: () {
                      Navigator.pushNamed(context, '/admin/tables',
                          arguments: args);
                    }),
              ],
            ),
          )));
    } else {
      showErrorMessage('Something went wrong. Please try again later.');
      logOutUser();
      Navigator.pushNamed(context, '/');
      return Container();
    }
  }
}
