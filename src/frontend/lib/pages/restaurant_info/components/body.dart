import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/api.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/rounded_input_field.dart';
import 'package:frontend/common_components/rounded_multiline_input_field.dart';
import 'package:frontend/common_components/background.dart';
import 'package:frontend/pages/restaurant_info/restaurant_info_screen.dart';
import 'package:frontend/utils.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Query to fetch the information of a Restaurant
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

/// Mutation to update the Restaurant information
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
    var args = getOverviewArguments(context);

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

          /// must be done with controllers to preset TextField values.
          /// dataLoaded is mandatory because of GraphQL polling, that will reset the controller values and your edited texts
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
              appBar: getAppBar("Edit Restaurant Information"),
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
