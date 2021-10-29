import 'package:chama_app/models/group-member.dart';
import 'package:chama_app/modules/home/screens/home_screen.dart';
import 'package:chama_app/providers/groups.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsergroupItem extends StatelessWidget {
  final GroupMember groupMember;

  const UsergroupItem(this.groupMember);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.groupMember.verified!
          ? () {
              Provider.of<CurrentGroupProvider>(context, listen: false)
                  .setCurrentGroup(this.groupMember.group!);

              Navigator.of(context).pushNamed(HomeScreen.routeName);
            }
          : () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Your request to join this group has not been accepted yet!'))),
      child: Card(
        child: ListTile(
            leading: Icon(
              Icons.group,
              color: Colors.black,
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(this.groupMember.group!.name),
                SizedBox(
                  height: 5,
                ),
                Text('${this.groupMember.group?.code!}'),
              ],
            ),
            trailing: this.groupMember.verified!
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                  )
                : null),
      ),
    );
  }
}
