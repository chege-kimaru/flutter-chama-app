import 'package:chama_app/screens/login_screen.dart';
import 'package:chama_app/widgets/custom_button.dart';
import 'package:chama_app/widgets/custom_input.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = '/register';

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
                    'Sign Up',
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
                          hintText: 'Full Name',
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomInput(
                          hintText: 'Phone Number',
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomInput(
                          hintText: 'Email Address',
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
                          height: 16,
                        ),
                        CustomInput(
                          hintText: 'Confirm Password',
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        CustomButton(
                          label: 'Register',
                          handler: () {
                            Navigator.of(context)
                                .pushNamed(LoginScreen.routeName);
                          },
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(LoginScreen.routeName);
                          },
                          child: Text(
                            'Have an account? Login',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
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
