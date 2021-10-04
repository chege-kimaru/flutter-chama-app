import 'package:chama_app/modules/auth/screens/login_screen.dart';
import 'package:chama_app/services/auth.dart';
import 'package:chama_app/global_widgets/custom_button.dart';
import 'package:chama_app/global_widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyPhoneScreen extends StatefulWidget {
  static const routeName = '/verify-phone';

  @override
  VerifyPhoneScreenState createState() => VerifyPhoneScreenState();
}

class VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final _form = GlobalKey<FormState>();

  final _phoneFocusNode = FocusNode();
  final _codeFocusNode = FocusNode();
  final _verifyFocusNode = FocusNode();
  final _phoneController = TextEditingController();

  PhoneCodeDto _verifyPhoneDto = PhoneCodeDto(phone: '', code: 0);

  bool _isLoading = false;

  bool _isResendLoading = false;

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    _codeFocusNode.dispose();
    _verifyFocusNode.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || _isLoading) return;
    _form.currentState!.save();
    setState(() => _isLoading = true);
    try {
      await Provider.of<Auth>(context, listen: false)
          .verifyPhone(_verifyPhoneDto);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Verification was successful. Please login to continue.'),
      ));
      Navigator.of(context).pushNamed(LoginScreen.routeName);
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
      setState(() => _isLoading = false);
    }
    // Navigator.of(context).pop();
  }

  Future<void> _resendVerification() async {
    _form.currentState!.validate();
    if (_phoneController.text.isEmpty || _isResendLoading) {
      // show snackbar
      return;
    }
    ;
    _form.currentState!.save();
    setState(() => _isResendLoading = true);
    try {
      await Provider.of<Auth>(context, listen: false)
          .resendVerificationCode(_phoneController.text);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'An SMS with a verification code has been sent. Please enter the code.'),
      ));
    } catch (error) {
      print(error);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Failed to send verification failed.'),
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
    setState(() => _isResendLoading = false);
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    String phoneToVerify = Provider.of<Auth>(context).phoneToVerify ?? '';
    _verifyPhoneDto = PhoneCodeDto(phone: phoneToVerify, code: 0);
    _phoneController.text = phoneToVerify;

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
                    'Verify',
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
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_codeFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the code you have received.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _verifyPhoneDto = PhoneCodeDto(
                                phone: newValue!,
                                code: _verifyPhoneDto.code,
                              );
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CustomInput(
                            hintText: 'Code',
                            obscureText: false,
                            focusNode: _codeFocusNode,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_verifyFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the code you have received.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _verifyPhoneDto = PhoneCodeDto(
                                phone: _verifyPhoneDto.phone,
                                code: int.parse(newValue!),
                              );
                            },
                            keyboardType: TextInputType.number,
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
                                  onTap: _resendVerification,
                                  child: Text(
                                    'Resend Code',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: 24,
                          ),
                          CustomButton(
                            label: 'Verify',
                            handler: _verify,
                            focusNode: this._verifyFocusNode,
                            loading: _isLoading,
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
                              'Back to Sign in',
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
