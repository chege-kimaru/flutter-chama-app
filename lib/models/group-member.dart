import 'package:chama_app/models/group.dart';
import 'package:chama_app/models/user.dart';

class GroupMember {
  final String? id;
  final bool? verified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Group? group;
  final User? user;

  GroupMember(
      {this.group,
      this.user,
      this.id,
      this.verified,
      this.createdAt,
      this.updatedAt});

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      id: json['id'],
      verified: json['verified'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      group: json['group'] == null ? null : Group.fromJson(json['group']),
      // group: Group.fromJson(json['group']),
      user: json['user'] == null ? null : User.fromJson(json['user']),
    );
  }
}
