import 'package:chama_app/modules/auth/screens/forgot_pass_screen.dart';
import 'package:chama_app/modules/home/screens/home_screen.dart';
import 'package:chama_app/modules/auth/screens/login_screen.dart';
import 'package:chama_app/modules/auth/screens/register_screen.dart';
import 'package:chama_app/modules/auth/screens/reset_pass_screen.dart';
import 'package:chama_app/modules/auth/screens/verify_phone_screen.dart';
import 'package:chama_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
      ],
      child: MaterialApp(
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
            VerifyPhoneScreen.routeName: (ctx) => VerifyPhoneScreen(),
            ForgotPassScreen.routeName: (ctx) => ForgotPassScreen(),
            ResetPassScreen.routeName: (ctx) => ResetPassScreen(),
          }),
    );
  }
}
