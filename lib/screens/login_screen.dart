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
                        TextField(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(16),
                              hintText: 'Username',
                              hintStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              )),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(16),
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              )),
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
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: TextButton(
                            // style: ButtonStyle(
                            //   shape:
                            //       MaterialStateProperty.all<RoundedRectangleBorder>(
                            //     RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(18.0),
                            //     ),
                            //   ),
                            //   backgroundColor: MaterialStateProperty.all<Color>(
                            //       Theme.of(context).primaryColor),
                            // ),
                            style: TextButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                ),
                                backgroundColor:
                                    Theme.of(context).primaryColor),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 18,
                              ),
                            ),
                            onPressed: () {},
                          ),
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
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                ),
                                backgroundColor:
                                    Theme.of(context).primaryColor),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 18,
                              ),
                            ),
                            onPressed: () {},
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
