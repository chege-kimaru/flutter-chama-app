import 'package:chama_app/models/group.dart';
import 'package:chama_app/models/user.dart';
import 'package:chama_app/modules/group/widgets/group_member_item.dart';
import 'package:chama_app/providers/auth.dart';
import 'package:chama_app/providers/groups.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupMembersScreen extends StatelessWidget {
  GroupMembersScreen({Key? key}) : super(key: key);

  static const routeName = '/group-members';

  Future<void> _refreshVerifiedGroupMemberships(context) async {
    await Provider.of<Groups>(context, listen: false).getVerifiedGroupMembers();
  }

  Future<void> _refreshUnverifiedGroupMemberships(context) async {
    await Provider.of<Groups>(context, listen: false)
        .getUnVerifiedGroupMembers();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<Auth>(context, listen: false).user;
    Group? group = Provider.of<Groups>(context, listen: false).currentGroup;

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
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 48),
                    Text(
                      'Group Members',
                      style: TextStyle(
                          fontFamily: 'ModernAntiqua',
                          fontSize: 24,
                          color: Theme.of(context).accentColor),
                    ),
                  ],
                ),
                if (user?.id! == group?.adminId!) ...[
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Members Awaiting Verification',
                    style: TextStyle(
                      fontFamily: 'ModernAntiqua',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  FutureBuilder(
                    future: _refreshUnverifiedGroupMemberships(context),
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? Center(child: CircularProgressIndicator())
                            : RefreshIndicator(
                                onRefresh: () =>
                                    _refreshUnverifiedGroupMemberships(context),
                                child: Consumer<Groups>(
                                  builder: (ctx, groupsData, _) => groupsData
                                              .verifiedGroupMemberships
                                              .length ==
                                          0
                                      ? Container(
                                          // width: double.infinity,
                                          padding: EdgeInsets.all(32),
                                          child: Column(
                                            children: [
                                              Text(
                                                'There are no members awaiting verification',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemBuilder: (_, i) {
                                            return GroupMemberItem(
                                              groupsData
                                                  .unverifiedGroupMemberships[i],
                                            );
                                          },
                                          itemCount: groupsData
                                              .unverifiedGroupMemberships
                                              .length,
                                        ),
                                ),
                              ),
                  )
                ],
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Members',
                  style: TextStyle(
                    fontFamily: 'ModernAntiqua',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                FutureBuilder(
                  future: _refreshVerifiedGroupMemberships(context),
                  builder: (ctx, snapshot) => snapshot.connectionState ==
                          ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : RefreshIndicator(
                          onRefresh: () =>
                              _refreshVerifiedGroupMemberships(context),
                          child: Consumer<Groups>(
                            builder: (ctx, groupsData, _) =>
                                groupsData.verifiedGroupMemberships.length == 0
                                    ? Container(
                                        // width: double.infinity,
                                        padding: EdgeInsets.all(32),
                                        child: Column(
                                          children: [
                                            Text(
                                              'This group currently has no members',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemBuilder: (_, i) {
                                          return GroupMemberItem(groupsData
                                              .verifiedGroupMemberships[i]);
                                        },
                                        itemCount: groupsData
                                            .verifiedGroupMemberships.length,
                                      ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
