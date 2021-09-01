import 'package:chama_app/screens/home_screen.dart';
import 'package:chama_app/screens/login_screen.dart';
import 'package:chama_app/screens/register_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chama',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(71, 33, 153, 1),
          accentColor: Color.fromRGBO(251, 241, 10, 1),
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => LoginScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          RegisterScreen.routeName: (ctx) => RegisterScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
        });
  }
}
