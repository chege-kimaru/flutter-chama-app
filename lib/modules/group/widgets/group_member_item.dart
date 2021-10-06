import 'package:chama_app/models/group-member.dart';
import 'package:chama_app/providers/groups.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupMemberItem extends StatelessWidget {
  final GroupMember groupMember;

  const GroupMemberItem(this.groupMember);

  Future<void> _refreshVerifiedGroupMemberships(context) async {
    await Provider.of<Groups>(context, listen: false).getVerifiedGroupMembers();
  }

  Future<void> _refreshUnverifiedGroupMemberships(context) async {
    await Provider.of<Groups>(context, listen: false)
        .getUnVerifiedGroupMembers();
  }

  Future<void> _requestVerify(BuildContext context, String userId) async {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Membership Verification'),
              content:
                  Text('Please accept or reject this membership request below'),
              actions: [
                TextButton(
                    onPressed: () async {
                      await this._verifyGroupMember(context, userId, true);
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Accept')),
                TextButton(
                    onPressed: () async {
                      await this._verifyGroupMember(context, userId, false);
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Reject')),
                TextButton(
                    onPressed: () async {
                      // close the alert dialog
                      await this._verifyGroupMember(context, userId, false);
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Cancel'))
              ],
            ));
  }

  Future<void> _verifyGroupMember(
      BuildContext context, String userId, bool verified) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .verifyGroupMember(userId, verified);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Done successfully')));
      await this._refreshUnverifiedGroupMemberships(context);
      await this._refreshVerifiedGroupMemberships(context);
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: Icon(
        Icons.group,
        color: Colors.black,
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(this.groupMember.user!.name!),
          SizedBox(
            height: 5,
          ),
          Text('${this.groupMember.user?.phone!}'),
        ],
      ),
      trailing: this.groupMember.verified!
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).primaryColor,
            )
          : ElevatedButton(
              onPressed: () =>
                  _requestVerify(context, this.groupMember.user!.id!),
              child: Text('Verify')),
    )
        // : CustomButton(label: 'Verify', handler: () {})),
        );
  }
}
