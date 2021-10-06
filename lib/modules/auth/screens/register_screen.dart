import 'package:chama_app/models/user.dart';
import 'package:chama_app/modules/auth/screens/login_screen.dart';
import 'package:chama_app/modules/auth/screens/verify_phone_screen.dart';
import 'package:chama_app/providers/auth.dart';
import 'package:chama_app/global_widgets/custom_button.dart';
import 'package:chama_app/global_widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();

  final _nameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _registerFocusNode = FocusNode();
  final _passwordController = TextEditingController();

  User _user = User(name: '', email: '', phone: '', password: '');

  bool _isLoading = false;

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _registerFocusNode.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || _isLoading) return;
    _form.currentState!.save();
    setState(() => _isLoading = true);
    try {
      User registeredUser =
          await Provider.of<Auth>(context, listen: false).register(_user);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text(
                    "Welcome ${registeredUser.name}. Registration was successful"),
                content: Text(
                    'Please enter the code sent via sms to verify your account.'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        // close the alert dialog
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Okay'))
                ],
              ));
      Navigator.of(context).pushNamed(VerifyPhoneScreen.routeName);
    } catch (error) {
      print(error);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occurred'),
                content: Text(error.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        // close the alert dialog
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Okay'))
                ],
              ));
    }
    setState(() => _isLoading = false);
    // Navigator.of(context).pop();
  }

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
                    child: Form(
                      key: _form,
                      child: Column(
                        children: [
                          CustomInput(
                            hintText: 'Full Name',
                            obscureText: false,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_phoneFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            focusNode: _nameFocusNode,
                            onSaved: (newValue) {
                              _user = User(
                                name: newValue,
                                email: _user.email,
                                phone: _user.phone,
                                password: _user.password,
                              );
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CustomInput(
                            hintText: 'Phone Number',
                            obscureText: false,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_emailFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                            focusNode: _phoneFocusNode,
                            onSaved: (newValue) {
                              _user = User(
                                name: _user.name,
                                email: _user.email,
                                phone: newValue,
                                password: _user.password,
                              );
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CustomInput(
                            hintText: 'Email Address',
                            obscureText: false,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            focusNode: _emailFocusNode,
                            onSaved: (newValue) {
                              _user = User(
                                name: _user.name,
                                email: newValue,
                                phone: _user.phone,
                                password: _user.password,
                              );
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CustomInput(
                            hintText: 'Password',
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_confirmPasswordFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                            focusNode: _passwordFocusNode,
                            controller: _passwordController,
                            onSaved: (newValue) {
                              _user = User(
                                name: _user.name,
                                email: _user.email,
                                phone: _user.phone,
                                password: newValue,
                              );
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CustomInput(
                            hintText: 'Confirm Password',
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_registerFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            focusNode: _confirmPasswordFocusNode,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          CustomButton(
                            label: 'Register',
                            handler: _register,
                            focusNode: this._registerFocusNode,
                            loading: _isLoading,
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
                          SizedBox(
                            height: 16,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(VerifyPhoneScreen.routeName);
                            },
                            child: Text(
                              'Verify Phone?',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
