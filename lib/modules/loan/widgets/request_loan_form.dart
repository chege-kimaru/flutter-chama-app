import 'package:chama_app/global_widgets/custom_button.dart';
import 'package:chama_app/providers/loans.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestLoanForm extends StatefulWidget {
  final BuildContext parentContext;

  RequestLoanForm({required this.parentContext});

  @override
  _RequestLoanFormState createState() => _RequestLoanFormState();
}

class _RequestLoanFormState extends State<RequestLoanForm> {
  int _loanProductId = 1;
  bool _isLoading = false;

  Future<void> _requestLoan() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<Loans>(context, listen: false)
          .requestLoan(_loanProductId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Your loan request is being processed. You will be notified once its complete.')));
      // Timer(Duration(seconds: 5), () {
      //   this._refreshLoans();
      // });
      Navigator.of(widget.parentContext).pop();
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        title: const Text('Test Loan Product 1'),
        leading: Radio(
            value: 1,
            groupValue: _loanProductId,
            onChanged: (int? value) {
              setState(() {
                _loanProductId = value!;
              });
            }),
      ),
      ListTile(
        title: const Text('Test Loan Product 2'),
        leading: Radio(
            value: 2,
            groupValue: _loanProductId,
            onChanged: (int? value) {
              setState(() {
                _loanProductId = value!;
              });
            }),
      ),
      CustomButton(
        label: 'Request Loan',
        handler: _requestLoan,
        loading: _isLoading,
      )
    ]);
  }
}
