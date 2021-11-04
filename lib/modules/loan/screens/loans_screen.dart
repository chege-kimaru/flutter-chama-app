import 'dart:async';

import 'package:chama_app/global_widgets/custom_button.dart';
import 'package:chama_app/global_widgets/custom_input.dart';
import 'package:chama_app/models/loan.dart';
import 'package:chama_app/models/user.dart';
import 'package:chama_app/modules/home/screens/home_screen.dart';
import 'package:chama_app/modules/loan/widgets/pay_loan_form.dart';
import 'package:chama_app/modules/loan/widgets/request_loan_form.dart';
import 'package:chama_app/providers/auth.dart';
import 'package:chama_app/providers/loans.dart';
import 'package:chama_app/providers/savings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LoansScreen extends StatefulWidget {
  static const routeName = 'loans';

  const LoansScreen({Key? key}) : super(key: key);

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  bool _userLoans = true;
  bool _isLoading = false;
  // TextEditingController _amountController = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    // _amountController.dispose();
  }

  Future<void> _refreshLoans() async {
    await Provider.of<Loans>(context, listen: false).getUserGroupLoans();
    await Provider.of<Loans>(context, listen: false).getAllGroupLoans();
  }

  Future<void> _openRequestLoanBottomSheet(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => RequestLoanForm(
              parentContext: context,
            ));
  }

  Future<void> _openPayLoanBottomSheet(Loan loan) async {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => PayLoanForm(parentContext: context, loan: loan));
  }

  double _calculateBalance(Loan loan) {
    return (loan.amountToBePaid ?? 0) - (loan.amountPaid ?? 0);
  }

  String _formatLoanDate(Loan loan) {
    return DateFormat('yyyy-MM-dd – kk:mm').format(loan.createdAt!);
  }

  String _loanPaymentStatus(Loan loan) {
    return loan.paymentComplete! ? 'Complete' : 'Pending';
  }

  @override
  Widget build(BuildContext context) {
    User? _user = Provider.of<Auth>(context, listen: false).user;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          this._openRequestLoanBottomSheet(context);
        },
        child: const Icon(
          Icons.add,
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            padding: EdgeInsets.only(top: 40, left: 12, right: 12),
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Home',
                      onPressed: () {
                        Navigator.of(context).pushNamed(HomeScreen.routeName);
                      },
                    ),
                    CircleAvatar(
                      radius: 28,
                      backgroundImage:
                          AssetImage('assets/images/user_avatar.jpg'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Hello, ${_user?.name ?? ''}!',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Mogra',
                          fontSize: 24,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.storage,
                      size: 48,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    'Borrow, Pay, Grow...',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'ModernAntiqua',
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _userLoans = true;
                          });
                        },
                        child: Text(
                          'My Loans',
                          style: TextStyle(
                            color: _userLoans ? Colors.white : Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        style: TextButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                            ),
                            backgroundColor: _userLoans
                                ? Theme.of(context).primaryColor
                                : Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _userLoans = false;
                          });
                        },
                        child: Text(
                          'Group Loans',
                          style: TextStyle(
                            color: !_userLoans ? Colors.white : Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        style: TextButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                            ),
                            backgroundColor: !_userLoans
                                ? Theme.of(context).primaryColor
                                : Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 24),
          // Container(
          //     margin: EdgeInsets.symmetric(horizontal: 16),
          //     width: double.infinity,
          //     height: 90,
          //     decoration: BoxDecoration(
          //       color: Theme.of(context).accentColor,
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(24),
          //       ),
          //     ),
          //     child: Padding(
          //       padding:
          //           const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Expanded(
          //             child: Text(
          //               'Balance',
          //               style: TextStyle(
          //                 color: Theme.of(context).primaryColor,
          //                 // fontFamily: 'Mogra',
          //                 fontSize: 24,
          //                 // fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //           ),
          //           Expanded(
          //             child: Consumer<Savings>(
          //               builder: (ctx, savingsData, _) => Text(
          //                 'Ksh ${_userLoans ? savingsData.totalUserGroupSavings : savingsData.totalGroupSavings}',
          //                 style: TextStyle(
          //                   color: Theme.of(context).primaryColor,
          //                   fontFamily: 'Mogra',
          //                   fontSize: 32,
          //                   // fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: _refreshLoans(),
                builder: (ctx, snapshot) => snapshot.connectionState ==
                        ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: () => _refreshLoans(),
                        child: Consumer<Loans>(
                          builder: (ctx, loansData, _) => (_userLoans
                                  ? loansData.userGroupLoans.length == 0
                                  : loansData.allGroupLoans.length == 0)
                              ? Container(
                                  // width: double.infinity,
                                  padding: EdgeInsets.all(32),
                                  child: Column(
                                    children: [
                                      Text(
                                        'No loans. Click the button below to request a loan',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  itemBuilder: (_, i) {
                                    return Card(
                                        child: ListTile(
                                      leading: Icon(
                                        Icons.credit_card,
                                        color: Colors.black,
                                      ),
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (!_userLoans) ...[
                                            Text(
                                              '${loansData.allGroupLoans[i].user?.name}',
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              'Date: ${_userLoans ? _formatLoanDate(loansData.userGroupLoans[i]) : _formatLoanDate(loansData.allGroupLoans[i])}'),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              'Amount: Ksh ${_userLoans ? loansData.userGroupLoans[i].amount : loansData.allGroupLoans[i].amount}'),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              'Balance: Ksh ${_userLoans ? _calculateBalance(loansData.userGroupLoans[i]) : _calculateBalance(loansData.allGroupLoans[i])}'),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              'Payment Status: ${_userLoans ? _loanPaymentStatus(loansData.userGroupLoans[i]) : _loanPaymentStatus(loansData.allGroupLoans[i])}'),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          if (_userLoans &&
                                              !loansData.userGroupLoans[i]
                                                  .paymentComplete!) ...[
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Theme.of(context)
                                                      .primaryColor),
                                              onPressed: () =>
                                                  _openPayLoanBottomSheet(
                                                      loansData
                                                          .userGroupLoans[i]),
                                              child: Text(
                                                'Add Payment',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ));
                                  },
                                  itemCount: _userLoans
                                      ? loansData.userGroupLoans.length
                                      : loansData.allGroupLoans.length,
                                ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
