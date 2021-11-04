import 'package:chama_app/models/group.dart';
import 'package:chama_app/models/loan_product.dart';
import 'package:chama_app/models/user.dart';

class Loan {
  final String? id;
  final String? groupId;
  final Group? group;
  final String? userId;
  final User? user;
  final int? loanProductId;
  final LoanProduct? loanProduct;
  final double? amount;
  final double? interestRate;
  final double? amountPaid;
  final double? amountToBePaid;
  final bool? paymentComplete;
  final DateTime? deadline;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Loan({
    this.id,
    this.amount,
    this.groupId,
    this.userId,
    this.user,
    this.group,
    this.loanProductId,
    this.loanProduct,
    this.interestRate,
    this.amountPaid,
    this.amountToBePaid,
    this.paymentComplete,
    this.deadline,
    this.createdAt,
    this.updatedAt,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    print('converting loan to json');
    return Loan(
      id: json['id'],
      user: json['user'] == null ? null : User.fromJson(json['user']),
      userId: json['userId'],
      groupId: json['groupId'],
      group: json['group'] == null ? null : Group.fromJson(json['group']),
      loanProductId: json['loanProductId'],
      loanProduct: json['loanProduct'] == null
          ? null
          : LoanProduct.fromJson(json['loanProduct']),
      amount: double.parse(json['amount']),
      interestRate: double.parse(json['interestRate']),
      amountPaid: double.parse(json['amountPaid']),
      amountToBePaid: double.parse(json['amountToBePaid']),
      paymentComplete: json['paymentComplete'],
      deadline: DateTime.parse(json['deadline']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
