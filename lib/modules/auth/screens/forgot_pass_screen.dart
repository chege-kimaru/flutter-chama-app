import 'package:chama_app/global_widgets/custom_button.dart';
import 'package:chama_app/global_widgets/custom_input.dart';
import 'package:chama_app/modules/auth/screens/login_screen.dart';
import 'package:chama_app/modules/auth/screens/reset_pass_screen.dart';
import 'package:chama_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPassScreen extends StatefulWidget {
  static const routeName = '/forgot-pass';

  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPassScreen> {
  final _form = GlobalKey<FormState>();

  final _phoneFocusNode = FocusNode();
  final _sendCodeFocusNode = FocusNode();

  String _phone = '';

  bool _isLoading = false;

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    _sendCodeFocusNode.dispose();
    super.dispose();
  }

  Future<void> _forgotPass() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || _isLoading) return;
    _form.currentState!.save();
    setState(() => _isLoading = true);
    try {
      await Provider.of<Auth>(context, listen: false).forgotPass(_phone);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'A code has been sent. Enter the code above to reset your password.')));
      Navigator.of(context).pushNamed(ResetPassScreen.routeName);
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
                    'Forgot Password',
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
                        color: Theme.of(context).colorScheme.secondary),
                    child: Form(
                      key: _form,
                      child: Column(
                        children: [
                          CustomInput(
                            hintText: 'Phone Number',
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_sendCodeFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                            focusNode: _phoneFocusNode,
                            onSaved: (newValue) {
                              setState(() {
                                _phone = newValue!;
                              });
                            },
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          CustomButton(
                            label: 'Send Code',
                            handler: _forgotPass,
                            focusNode: this._sendCodeFocusNode,
                            loading: _isLoading,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(ResetPassScreen.routeName);
                            },
                            child: Text(
                              'Reset Password',
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
                                  .pushNamed(LoginScreen.routeName);
                            },
                            child: Text(
                              'Back to Sign In',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
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
