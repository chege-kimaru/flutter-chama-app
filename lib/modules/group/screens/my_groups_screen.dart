import 'package:chama_app/global_widgets/custom_button.dart';
import 'package:chama_app/modules/group/screens/create_group_screen.dart';
import 'package:chama_app/modules/group/screens/join_group_screen.dart';
import 'package:chama_app/modules/group/widgets/user_group_item.dart';
import 'package:chama_app/modules/home/screens/home_screen.dart';
import 'package:chama_app/providers/groups.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyGroupsScreen extends StatelessWidget {
  const MyGroupsScreen({Key? key}) : super(key: key);

  static const routeName = '/my-groups';

  _joinGroup(context) {
    Navigator.of(context).pushNamed(JoinGroupScreen.routeName);
  }

  _createGroup(context) {
    Navigator.of(context).pushNamed(CreateGroupScreen.routeName);
  }

  Future<void> _refreshUserGroupMemberships(context) async {
    await Provider.of<Groups>(context, listen: false).getUserGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            // margin: EdgeInsets.only(top: 64),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          label: 'Join Group',
                          handler: () => _joinGroup(context),
                          backgroundColor: Theme.of(context).accentColor,
                          labelColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          label: 'Create Group',
                          handler: () => _createGroup(context),
                          backgroundColor: Theme.of(context).accentColor,
                          labelColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'My Groups',
                    style: TextStyle(
                        fontSize: 28, color: Theme.of(context).accentColor),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  FutureBuilder(
                    future: _refreshUserGroupMemberships(context),
                    builder: (ctx, snapshot) => snapshot.connectionState ==
                            ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: () =>
                                _refreshUserGroupMemberships(context),
                            child: Consumer<Groups>(
                              builder: (ctx, groupsData, _) => groupsData
                                          .userGroupMemberships.length ==
                                      0
                                  ? Container(
                                      // width: double.infinity,
                                      padding: EdgeInsets.all(32),
                                      child: Column(
                                        children: [
                                          Text(
                                            'You are currently not in any groups',
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 32,
                                          ),
                                          CustomButton(
                                            label: 'Join Group',
                                            handler: () => _joinGroup(context),
                                            backgroundColor:
                                                Theme.of(context).accentColor,
                                            labelColor:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      height: 400,
                                      child: ListView.builder(
                                        itemBuilder: (_, i) {
                                          return UsergroupItem(groupsData
                                              .userGroupMemberships[i]);
                                        },
                                        itemCount: groupsData
                                            .userGroupMemberships.length,
                                      ),
                                    ),
                            ),
                          ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
