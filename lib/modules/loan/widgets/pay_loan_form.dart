import 'package:chama_app/global_widgets/custom_button.dart';
import 'package:chama_app/global_widgets/custom_input.dart';
import 'package:chama_app/models/loan.dart';
import 'package:chama_app/providers/loans.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PayLoanForm extends StatefulWidget {
  final BuildContext parentContext;
  final Loan loan;

  const PayLoanForm({required this.parentContext, required this.loan});

  @override
  _PayLoanFormState createState() => _PayLoanFormState();
}

class _PayLoanFormState extends State<PayLoanForm> {
  TextEditingController _amountController = TextEditingController();

  bool _isLoading = false;

  Future<void> _payLoan() async {
    double amount = double.parse(_amountController.text);
    if (amount <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await Provider.of<Loans>(context, listen: false)
          .payLoan(amount, widget.loan.id!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Successfully initiated payment. Please enter Mpesa pin when requested.')));
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
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).accentColor,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomInput(
            hintText: 'Amount',
            controller: _amountController,
          ),
          SizedBox(height: 10),
          CustomButton(
            label: 'Pay',
            handler: _payLoan,
            loading: _isLoading,
          ),
        ],
      ),
    );
  }
}
