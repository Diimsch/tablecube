import 'package:flutter/material.dart';
import 'package:frontend/bottom_nav_bar/nav.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/order_view/order_screen.dart';
import 'package:frontend/pages/overview/overview_screen.dart';
import 'package:frontend/pages/page_login/login_screen.dart';
import 'package:frontend/pages/page_selectMenu/select_menu.dart';
import 'package:frontend/pages/page_signup/signup_screen.dart';
import 'package:frontend/pages/page_welcome/welcome_screen.dart';
import 'package:frontend/api.dart';
import 'package:frontend/pages/qr_view/qr_view_screen.dart';
import 'package:frontend/pages/table_overview/table_overview_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
    return GraphQLProvider(
      client: vnClient,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Tablecube',
        initialRoute: initialRoute,
        routes: {
          '/': (context) => const WelcomeScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/login': (context) => const LoginScreen(),
          '/scanner': (context) => const QrViewScreen(),
          '/cart': (context) => OrderScreen(),
          '/home': (context) => const Nav()
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
      ),
    );
  }
}
