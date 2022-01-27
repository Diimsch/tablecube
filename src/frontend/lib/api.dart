import 'package:flutter/cupertino.dart';
import 'package:frontend/main.dart';
import 'package:frontend/utils.dart';
import 'package:graphql/client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const storage = FlutterSecureStorage();
const url =
    'https://21w-me-teamg.adrianmxb.com/graphql';

final _httpLink = HttpLink(
  url,
);

/// Sets the authentication Link for the GraphQl client
var _authLink = AuthLink(
  getToken: () async {
    String? token = await storage.read(key: "authToken");
    if (token == null) {
      return "";
    }
    return 'Bearer ' + token;
  },
);

Link _link = _authLink.concat(_httpLink);

/// initialize the GraphQL client
final GraphQLClient client = GraphQLClient(
  cache: GraphQLCache(),
  link: _link,
);

final ValueNotifier<GraphQLClient> vnClient =
    ValueNotifier(GraphQLClient(cache: GraphQLCache(), link: _link));

/// Common error Handling function
handleError(OperationException error) {
  if (error.graphqlErrors.isEmpty) {
    showErrorMessage("An Error occured. Please try again later.");
  } else {
    showErrorMessage(error.graphqlErrors[0].message.toString());
  }
}

/// Log in the user and add the Auth token into the secure storage
logInUser(String email, String password) async {
  const String logInUser = r'''
    query Login($email: String!, $password: String!) {
      login(email: $email, password: $password) {
        token
      }
    }
  ''';

  final QueryOptions options = QueryOptions(
    document: gql(logInUser),
    variables: <String, dynamic>{'email': email, 'password': password},
  );

  final QueryResult result = await client.query(options);

  if (!result.hasException) {
    await storage.write(
        key: 'authToken', value: result.data?['login']['token']);

    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil('/home', ModalRoute.withName('/home'));
  } else {
    handleError(result.exception!);
  }
}

/// Logout the user, remove the auth token and navigate to the home page
logOutUser() async {
  await storage.deleteAll();

  navigatorKey.currentState
      ?.pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
}

//// Create a booking
createBooking(String restaurantId, String tableId, bool prompt) async {
  const String createBooking = r'''
    mutation Mutation($booking: CreateBookingInput!) {
      createBooking(booking: $booking) {
        id
      }
  }
  ''';

  final MutationOptions options = MutationOptions(
      document: gql(createBooking),
      variables: <String, dynamic>{
        'booking': {'restaurantId': restaurantId, 'tableId': tableId}
      });

  final QueryResult result = await client.mutate(options);
}

/// Prompt the color validation code on the device
promptValidation(String tableId) async {
  const String promptValidation = r'''
  mutation Mutation($tableId: String!) {
    promptValidation(tableId: $tableId)
  }
  ''';

  final MutationOptions options = MutationOptions(
    document: gql(promptValidation),
    variables: <String, dynamic>{'tableId': tableId},
  );

  final QueryResult result = await client.mutate(options);

  if (result.hasException) {
    handleError(result.exception!);
  }

  return result;
}

/// Create a new user
createUser(
    String firstName, String lastName, String email, String password) async {
  const String createUser = r'''
    mutation CreateUser($email: String!, $firstName: String!, $lastName: String!, $password: String!) {
      createUser(email: $email, firstName: $firstName, lastName: $lastName, password: $password) {
        id
        email
        firstName
        lastName
      }
    }
  ''';

  final MutationOptions options =
      MutationOptions(document: gql(createUser), variables: <String, dynamic>{
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'password': password
  });

  final QueryResult result = await client.mutate(options);

  if (!result.hasException) {
    client.mutate(options).whenComplete(() => logInUser(email, password));
  } else {
    handleError(result.exception!);
  }
}
