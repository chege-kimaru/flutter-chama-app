import 'package:chama_app/modules/auth/screens/login_screen.dart';
import 'package:chama_app/services/auth.dart';
import 'package:chama_app/global_widgets/custom_button.dart';
import 'package:chama_app/global_widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassScreen extends StatefulWidget {
  static const routeName = '/reset-pass';

  @override
  _ResetPassScreenState createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
  final _form = GlobalKey<FormState>();

  final _phoneFocusNode = FocusNode();
  final _codeFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _resetPassFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  ResetPassDto _resetPassDto = ResetPassDto(phone: '', code: 0, password: '');

  bool _isLoading = false;
  bool _isResendLoading = false;

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    _codeFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _resetPassFocusNode.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _resetPass() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || _isLoading) return;
    _form.currentState!.save();
    setState(() => _isLoading = true);
    try {
      await Provider.of<Auth>(context, listen: false).resetPass(_resetPassDto);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have successfully reset your password')));
      Navigator.of(context).pushNamed(LoginScreen.routeName);
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

  Future<void> _resendCode() async {
    // if (_isResendLoading) return;
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter your phone number to resend the code.')));
      return;
    }
    setState(() => _isResendLoading = true);
    try {
      await Provider.of<Auth>(context, listen: false)
          .forgotPass(_phoneController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'A code has been sent. Enter the code above to reset your password.')));
      Navigator.of(context).pushNamed(ResetPassScreen.routeName);
      setState(() => _isLoading = false);
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
      setState(() => _isResendLoading = false);
    }

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
                    'Reset Password',
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
                            obscureText: false,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_codeFocusNode);
                            },
                            controller: _phoneController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                            focusNode: _phoneFocusNode,
                            onSaved: (newValue) {
                              _resetPassDto = ResetPassDto(
                                phone: newValue!,
                                code: _resetPassDto.code,
                                password: _resetPassDto.password,
                              );
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CustomInput(
                            hintText: 'Code',
                            obscureText: false,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the received code';
                              }
                              return null;
                            },
                            focusNode: _codeFocusNode,
                            onSaved: (newValue) {
                              _resetPassDto = ResetPassDto(
                                phone: _resetPassDto.phone,
                                code: int.parse(newValue!),
                                password: _resetPassDto.password,
                              );
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          _isResendLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                )
                              : InkWell(
                                  onTap: _resendCode,
                                  child: Text(
                                    'Resend Code',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
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
                              _resetPassDto = ResetPassDto(
                                phone: _resetPassDto.phone,
                                code: _resetPassDto.code,
                                password: newValue!,
                              );
                            },
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          CustomInput(
                            hintText: 'Confirm Password',
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_resetPassFocusNode);
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
                            label: 'Reset Password',
                            handler: _resetPass,
                            focusNode: this._resetPassFocusNode,
                            loading: _isLoading,
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
                              'Back to sign in',
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
