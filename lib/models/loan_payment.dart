import 'package:chama_app/models/loan.dart';

class LoanPayment {
  final String? id;
  final String? loanId;
  final Loan? loan;
  final double? amount;
  final String? paymentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LoanPayment({
    this.id,
    this.loanId,
    this.loan,
    this.amount,
    this.paymentId,
    this.createdAt,
    this.updatedAt,
  });

  factory LoanPayment.fromJson(Map<String, dynamic> json) {
    print('converting loan payment to json');
    return LoanPayment(
      id: json['id'],
      loanId: json['loanId'],
      loan: json['loan'] == null ? null : Loan.fromJson(json['loan']),
      amount: double.parse(json['amount']),
      paymentId: json['paymentId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
