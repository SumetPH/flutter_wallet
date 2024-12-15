class ScheduleTransactionModel {
  final int id;
  final String? amount;
  final String? date;
  final String? status;
  final int? transactionId;
  final int? transactionTypeId;
  final int? expenseAccountId;
  final String? expenseAccountName;
  final int? debtAccountIdFrom;
  final String? debtAccountNameFrom;
  final int? debtAccountIdTo;
  final String? debtAccountNameTo;

  ScheduleTransactionModel({
    required this.id,
    this.amount,
    this.date,
    this.status,
    this.transactionId,
    this.transactionTypeId,
    this.expenseAccountId,
    this.expenseAccountName,
    this.debtAccountIdFrom,
    this.debtAccountNameFrom,
    this.debtAccountIdTo,
    this.debtAccountNameTo,
  });

  factory ScheduleTransactionModel.fromJson(Map<String, dynamic> json) {
    return ScheduleTransactionModel(
      id: json['id'],
      amount: json['amount'],
      date: json['date'],
      status: json['status'],
      transactionId: json['transaction_id'],
      transactionTypeId: json['transaction_type_id'],
      expenseAccountId: json['expense_account_id'],
      expenseAccountName: json['expense_account_name'],
      debtAccountIdFrom: json['debt_account_id_from'],
      debtAccountNameFrom: json['debt_account_name_from'],
      debtAccountIdTo: json['debt_account_id_to'],
      debtAccountNameTo: json['debt_account_name_to'],
    );
  }
}
