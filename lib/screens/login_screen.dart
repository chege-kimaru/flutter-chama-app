import 'package:chama_app/models/user.dart';
import 'package:chama_app/screens/home_screen.dart';
import 'package:chama_app/screens/register_screen.dart';
import 'package:chama_app/services/auth.dart';
import 'package:chama_app/widgets/custom_button.dart';
import 'package:chama_app/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();

  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _loginFocusNode = FocusNode();

  LoginDto _loginDto = LoginDto(phone: '', password: '');

  bool _isLoading = false;

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _loginFocusNode.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final isValid = _form.currentState.validate();
    if (!isValid || _isLoading) return;
    _form.currentState.save();
    setState(() => _isLoading = true);
    try {
      User user =
          await Provider.of<Auth>(context, listen: false).login(_loginDto);
      // scaffold.showSnackBar(SnackBar(content: Text('Welcome ${user.name}!')));
      // Navigator.of(context).pushNamed(HomeScreen.routeName);
    } catch (error) {
      print(error);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occurred'),
                content: Text(error.toString()),
                actions: [
                  FlatButton(
                      onPressed: () {
                        // close the alert dialog
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Okay'))
                ],
              ));
    }
    setState(() => _isLoading = false);
    Navigator.of(context).pop();
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
                    child: Form(
                      key: _form,
                      child: Column(
                        children: [
                          CustomInput(
                            hintText: 'Phone Number',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                            focusNode: _phoneFocusNode,
                            onSaved: (newValue) {
                              _loginDto = LoginDto(
                                phone: newValue,
                                password: _loginDto.password,
                              );
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CustomInput(
                            hintText: 'Password',
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_loginFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            focusNode: _passwordFocusNode,
                            onSaved: (newValue) {
                              _loginDto = LoginDto(
                                phone: _loginDto.phone,
                                password: newValue,
                              );
                            },
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
                            handler: _login,
                            focusNode: this._loginFocusNode,
                            loading: _isLoading,
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
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
