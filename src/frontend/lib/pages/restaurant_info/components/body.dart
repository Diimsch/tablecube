import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/api.dart';
import 'package:frontend/bottom_nav_bar/account_bubble.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/rounded_input_field.dart';
import 'package:frontend/common_components/rounded_multiline_input_field.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/restaurant_info/components/background.dart';
import 'package:frontend/pages/restaurant_info/restaurant_info_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getRestaurantInfo = r'''
query Query($restaurantId: ID!) {
  restaurant(restaurantId: $restaurantId) {
    name
    description
    address
    zipCode
    city
  }
}
''';

const String updateRestaurantInfo = r'''
mutation Mutation($data: EditRestaurantInfoInput!) {
  editRestaurantInfo(data: $data) {
    id
  }
}
''';

class Body extends State<RestaurantInfoScreen> {
  Body({Key? key});

  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController zipController;
  late TextEditingController cityController;
  late TextEditingController descrController;

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments == null
        ? OverviewArguments('null', 'null', 'null')
        : ModalRoute.of(context)!.settings.arguments as OverviewArguments;

    return Query(
        options: QueryOptions(
          document: gql(getRestaurantInfo),
          variables: {
            'restaurantId': args.restaurantId,
          },
          fetchPolicy: FetchPolicy.noCache,
          pollInterval: const Duration(days: 5),
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
          Map loadetRestaurant = result.data!['restaurant'];
          if (!widget.dataLoaded && result.data != null) {
            widget.restaurant = loadetRestaurant;
            nameController =
                TextEditingController(text: widget.restaurant["name"]);
            addressController =
                TextEditingController(text: widget.restaurant["address"]);
            zipController =
                TextEditingController(text: widget.restaurant["zipCode"]);
            cityController =
                TextEditingController(text: widget.restaurant["city"]);
            descrController =
                TextEditingController(text: widget.restaurant["description"]);
            widget.dataLoaded = true;
          }

          return Scaffold(
              appBar: AppBar(
                actions: [
                  AccountBubble(click: () {
                    logOutUser();
                  })
                ],
                title: const Text("Restaurant information"),
                centerTitle: true,
                elevation: 0,
                backgroundColor: primaryColor,
              ),
              body: Background(
                  child: ListView(
                children: <Widget>[
                  RoundedInputField(
                      controller: nameController,
                      hintText: "Restaurant name",
                      icon: Icons.store_mall_directory,
                      onChanged: (value) {
                        widget.restaurant["name"] = value;
                      }),
                  RoundedInputField(
                      controller: addressController,
                      hintText: "Street and number",
                      icon: Icons.store_mall_directory,
                      onChanged: (value) {
                        widget.restaurant["address"] = value;
                      }),
                  RoundedInputField(
                      controller: zipController,
                      hintText: "Zip Code",
                      icon: Icons.store_mall_directory,
                      onChanged: (value) {
                        widget.restaurant["zipCode"] = value;
                      }),
                  RoundedInputField(
                      controller: cityController,
                      hintText: "City",
                      icon: Icons.store_mall_directory,
                      onChanged: (value) {
                        widget.restaurant["city"] = value;
                      }),
                  RoundedMultilineInputField(
                      controller: descrController,
                      hintText: "Description",
                      icon: Icons.store_mall_directory,
                      onChanged: (value) {
                        widget.restaurant["description"] = value;
                      }),
                  Mutation(
                      options: MutationOptions(
                          document: gql(updateRestaurantInfo),
                          onError: (error) =>
                              handleError(error as OperationException),
                          onCompleted: (data) {
                            showFeedback("Information saved.");
                          }),
                      builder: (RunMutation runMutation, QueryResult? result) {
                        return RoundedButton(
                            text: "Save",
                            click: () {
                              if (widget.restaurant["name"].isEmpty ||
                                  widget.restaurant["description"].isEmpty ||
                                  widget.restaurant["address"].isEmpty ||
                                  widget.restaurant["zipCode"].isEmpty ||
                                  widget.restaurant["city"].isEmpty) {
                                showErrorMessage('Please fill out all fields.');
                              } else {
                                runMutation({
                                  "data": {
                                    "restaurantId": args.restaurantId,
                                    "name": widget.restaurant["name"],
                                    "description":
                                        widget.restaurant["description"],
                                    "address": widget.restaurant["address"],
                                    "zipCode": widget.restaurant["zipCode"],
                                    "city": widget.restaurant["city"]
                                  }
                                });
                              }
                            });
                      })
                ],
              )));
        });
  }
}
