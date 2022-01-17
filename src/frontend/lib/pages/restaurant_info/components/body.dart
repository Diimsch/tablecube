import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/api.dart';
import 'package:frontend/common_components/rounded_button.dart';
import 'package:frontend/common_components/rounded_input_field.dart';
import 'package:frontend/common_components/rounded_multiline_input_field.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/restaurant_info/components/background.dart';
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

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

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
          pollInterval: const Duration(seconds: 30),
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
          Map restaurant = result.data!['restaurant'];

          return Background(
              child: ListView(
            children: <Widget>[
              RoundedInputField(
                  text: restaurant["name"],
                  hintText: "Restaurant name",
                  icon: Icons.store_mall_directory,
                  onChanged: (value) {
                    restaurant["name"] = value;
                  }),
              RoundedInputField(
                text: restaurant["address"],
                hintText: "Street and number",
                icon: Icons.store_mall_directory,
                onChanged: (value) {
                  restaurant["address"] = value;
                },
              ),
              RoundedInputField(
                text: restaurant["zipCode"],
                hintText: "Zip code",
                icon: Icons.store_mall_directory,
                onChanged: (value) {
                  restaurant["zipCode"] = value;
                },
              ),
              RoundedInputField(
                text: restaurant["city"],
                hintText: "City",
                icon: Icons.store_mall_directory,
                onChanged: (value) {
                  restaurant["city"] = value;
                },
              ),
              RoundedMultilineInputField(
                text: restaurant["description"],
                hintText: "Description",
                icon: Icons.info_outlined,
                onChanged: (value) {
                  restaurant["description"] = value;
                },
              ),
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
                          if (restaurant["name"].isEmpty ||
                              restaurant["description"].isEmpty ||
                              restaurant["address"].isEmpty ||
                              restaurant["zipCode"].isEmpty ||
                              restaurant["city"].isEmpty) {
                            showErrorMessage(
                                'Please fill out all required values');
                          } else {
                            runMutation({
                              "data": {
                                "restaurantId": args.restaurantId,
                                "name": restaurant["name"],
                                "description": restaurant["description"],
                                "address": restaurant["address"],
                                "zipCode": restaurant["zipCode"],
                                "city": restaurant["city"]
                              }
                            });
                          }
                        });
                  })
            ],
          ));
        });
  }
}
