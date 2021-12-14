import 'package:flutter/cupertino.dart';
import 'package:frontend/main.dart';
import 'package:graphql/client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

final storage = const FlutterSecureStorage();
const url = 'http://localhost:4000/';

final _httpLink = HttpLink(
  url,
);

var _authLink = AuthLink(
  getToken: () async => '',
);

Link _link = _authLink.concat(_httpLink);

final GraphQLClient client = GraphQLClient(
  cache: GraphQLCache(),
  link: _link,
);

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

    _authLink = AuthLink(
      getToken: () async => 'Bearer ' + result.data?['login']['token'],
    );

    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil('/home', ModalRoute.withName('/home'));
  }
}

logOutUser() async {
  _authLink = AuthLink(
    getToken: () async => '',
  );

  await storage.deleteAll();

  navigatorKey.currentState
      ?.pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
}

createUser(String firstName, String lastName, String email, String password) {
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

  client.mutate(options).whenComplete(() => logInUser(email, password));
}
