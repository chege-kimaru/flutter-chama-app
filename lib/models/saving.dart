import 'package:chama_app/models/user.dart';

class Saving {
  final String? id;
  final String? groupId;
  final String? userId;
  final User? user;
  final double? amount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Saving({
    this.id,
    this.amount,
    this.groupId,
    this.userId,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory Saving.fromJson(Map<String, dynamic> json) {
    print('converting json');
    return Saving(
      id: json['id'],
      user: json['user'] == null ? null : User.fromJson(json['user']),
      userId: json['userId'],
      groupId: json['groupId'],
      amount: double.parse(json['amount']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
