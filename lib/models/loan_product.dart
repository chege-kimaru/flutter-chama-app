class LoanProduct {
  final int? id;
  final String? name;
  final double? amount;
  final double? interestRate;
  final int? repaymentPeriod;
  final double? fine;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LoanProduct({
    this.id,
    this.name,
    this.amount,
    this.interestRate,
    this.repaymentPeriod,
    this.fine,
    this.createdAt,
    this.updatedAt,
  });

  factory LoanProduct.fromJson(Map<String, dynamic> json) {
    print('converting loan product to json');
    return LoanProduct(
      id: int.parse(json['id']),
      name: json['name'],
      amount: double.parse(json['amount']),
      interestRate: double.parse(json['interestRate']),
      repaymentPeriod: int.parse(json['repaymentPeriod']),
      fine: double.parse(json['fine']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
