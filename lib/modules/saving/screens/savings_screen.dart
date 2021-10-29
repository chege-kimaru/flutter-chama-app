import 'dart:async';

import 'package:chama_app/global_widgets/custom_button.dart';
import 'package:chama_app/global_widgets/custom_input.dart';
import 'package:chama_app/models/user.dart';
import 'package:chama_app/modules/home/screens/home_screen.dart';
import 'package:chama_app/providers/auth.dart';
import 'package:chama_app/providers/savings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavingsScreen extends StatefulWidget {
  static const routeName = 'savings';

  const SavingsScreen({Key? key}) : super(key: key);

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  bool _userSavings = true;
  bool _isLoading = false;
  TextEditingController _amountController = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
  }

  Future<void> _refreshSavings() async {
    await Provider.of<Savings>(context, listen: false).getUserGroupSavings();
    await Provider.of<Savings>(context, listen: false)
        .getTotalUserGroupSavings();
    await Provider.of<Savings>(context, listen: false).getAllGroupSavings();
    await Provider.of<Savings>(context, listen: false).getTotalGroupSavings();
  }

  Future<void> _addSaving() async {
    int amount = int.parse(_amountController.text);
    if (amount <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await Provider.of<Savings>(context, listen: false).addSaving(amount);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Successfully initiated payment. Please enter Mpesa pin.')));
      Timer(Duration(seconds: 5), () {
        this._refreshSavings();
      });
      Navigator.of(context).pop();
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
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Okay'))
                ],
              ));
    }
    setState(() => _isLoading = false);
  }

  Future<void> _openAddSavingDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Add Saving'),
              content: Container(
                height: 150,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      CustomInput(
                        hintText: 'Amount',
                        controller: _amountController,
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        label: 'Pay',
                        handler: _addSaving,
                        loading: _isLoading,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Cancel'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    User? _user = Provider.of<Auth>(context, listen: false).user;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          this._openAddSavingDialog(context);
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
                      Icons.credit_card,
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
                    'Save More, Do More...',
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
                            _userSavings = true;
                          });
                        },
                        child: Text(
                          'My Savings',
                          style: TextStyle(
                            color: _userSavings ? Colors.white : Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        style: TextButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                            ),
                            backgroundColor: _userSavings
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
                            _userSavings = false;
                          });
                        },
                        child: Text(
                          'Group Savings',
                          style: TextStyle(
                            color: !_userSavings ? Colors.white : Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        style: TextButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                            ),
                            backgroundColor: !_userSavings
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
          Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 90,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(24),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Balance',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          // fontFamily: 'Mogra',
                          fontSize: 24,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Consumer<Savings>(
                        builder: (ctx, savingsData, _) => Text(
                          'Ksh ${_userSavings ? savingsData.totalUserGroupSavings : savingsData.totalGroupSavings}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'Mogra',
                            fontSize: 32,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: _refreshSavings(),
                builder: (ctx, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: () => _refreshSavings(),
                            child: Consumer<Savings>(
                              builder: (ctx, savingsData, _) => (_userSavings
                                      ? savingsData.userGroupSavings.length == 0
                                      : savingsData.allGroupSavings.length == 0)
                                  ? Container(
                                      // width: double.infinity,
                                      padding: EdgeInsets.all(32),
                                      child: Column(
                                        children: [
                                          Text(
                                            'No savings. Click the button below to add your first saving',
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
                                              if (!_userSavings) ...[
                                                Text(
                                                  '${savingsData.allGroupSavings[i].user?.name}',
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                              Text(
                                                  'Ksh ${_userSavings ? savingsData.userGroupSavings[i].amount : savingsData.allGroupSavings[i].amount}'),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  '${_userSavings ? savingsData.userGroupSavings[i].createdAt.toString() : savingsData.allGroupSavings[i].createdAt.toString()}'),
                                            ],
                                          ),
                                        ));
                                      },
                                      itemCount: _userSavings
                                          ? savingsData.userGroupSavings.length
                                          : savingsData.allGroupSavings.length,
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
