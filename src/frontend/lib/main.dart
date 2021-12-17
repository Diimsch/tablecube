import 'package:flutter/material.dart';
import 'package:frontend/bottom_nav_bar/nav.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/page_login/login_screen.dart';
import 'package:frontend/pages/page_signup/signup_screen.dart';
import 'package:frontend/pages/page_welcome/welcome_screen.dart';
import 'package:frontend/api.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var storedToken = await storage.read(key: 'authToken');
  debugPrint(storedToken);
  final bool isLogged = storedToken != null && storedToken.isNotEmpty;
  final MyApp myApp = MyApp(
    initialRoute: isLogged ? '/home' : '/',
  );
  runApp(myApp);
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({Key? key, this.initialRoute = '/'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Tablecube',
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const Nav()
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
