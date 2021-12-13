// import 'package:flutter/material.dart';
// import 'package:frontend/bottom_nav_bar/nav.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(title: 'Habitus', home: Nav());
//   }
// }

import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/page_welcome/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tablecube',
        home: const WelcomeScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primaryColor,
          scaffoldBackgroundColor: Colors.white,
        ));
  }
}
