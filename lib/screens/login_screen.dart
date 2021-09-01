import 'package:chama_app/screens/home_screen.dart';
import 'package:chama_app/screens/register_screen.dart';
import 'package:chama_app/widgets/custom_button.dart';
import 'package:chama_app/widgets/custom_input.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 64),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                        fontFamily: 'ModernAntiqua',
                        fontSize: 32,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(30),
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).accentColor),
                    child: Column(
                      children: [
                        CustomInput(
                          hintText: 'Email',
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomInput(
                          hintText: 'Password',
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        CustomButton(
                          label: 'Login',
                          handler: () {
                            Navigator.of(context)
                                .pushNamed(HomeScreen.routeName);
                          },
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Center(
                            child: Text(
                              'OR',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        CustomButton(
                            label: 'Sign Up',
                            handler: () {
                              Navigator.of(context)
                                  .pushNamed(RegisterScreen.routeName);
                            })
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
