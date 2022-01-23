import 'package:flutter/cupertino.dart';
import 'package:frontend/main.dart';
import 'package:frontend/utils.dart';
import 'package:graphql/client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const storage = FlutterSecureStorage();
const url =
    'http://d3df-2003-c2-2f42-3c80-a833-3067-6150-546d.ngrok.io/graphql';

final _httpLink = HttpLink(
  url,
);

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

final GraphQLClient client = GraphQLClient(
  cache: GraphQLCache(),
  link: _link,
);

final ValueNotifier<GraphQLClient> vnClient =
    ValueNotifier(GraphQLClient(cache: GraphQLCache(), link: _link));

handleError(OperationException error) {
  if (error.graphqlErrors.isEmpty) {
    showErrorMessage("An Error occured. Please try again later.");
  } else {
    showErrorMessage(error.graphqlErrors[0].message.toString());
  }
}

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

logOutUser() async {
  await storage.deleteAll();

  navigatorKey.currentState
      ?.pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
}

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
