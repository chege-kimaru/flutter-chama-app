import 'package:chama_app/modules/home/widgets/home_item.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
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
                Text(
                  'Hello, Lizzy!',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Mogra',
                    fontSize: 32,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Text(
                  'Making dreams come true',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'ModernAntiqua',
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 60.0,
            width: double.infinity,
            child: Stack(
              overflow: Overflow.visible,
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: -60,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100,
                  childAspectRatio: 3 / 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              padding: const EdgeInsets.all(25),
              children: [
                HomeItem(
                    label: 'Savings', icon: Icons.credit_card, handler: () {}),
                HomeItem(
                    label: 'Projects', icon: Icons.bar_chart, handler: () {}),
                HomeItem(
                    label: 'Table Banking',
                    icon: Icons.table_chart,
                    handler: () {}),
                HomeItem(
                    label: 'Wallet',
                    icon: Icons.account_balance_wallet,
                    handler: () {}),
                HomeItem(label: 'Loans', icon: Icons.storage, handler: () {}),
                HomeItem(
                    label: 'Reports', icon: Icons.text_snippet, handler: () {}),
                HomeItem(
                    label: 'Join Group', icon: Icons.group_add, handler: () {}),
                HomeItem(label: 'New Group', icon: Icons.group, handler: () {}),
                HomeItem(
                    label: 'Settings', icon: Icons.settings, handler: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
