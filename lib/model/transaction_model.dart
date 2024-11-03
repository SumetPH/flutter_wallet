class TransactionModel {
  int id;
  String amount;
  int transactionTypeId;
  String transactionTypeName;
  int? categoryId;
  String? categoryName;
  String? accountExpenseName;
  String? accountIncomeName;
  String? accountTransferFromName;
  String? accountTransferToName;
  String? date;
  String? time;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.transactionTypeId,
    required this.transactionTypeName,
    this.categoryId,
    this.categoryName,
    this.accountExpenseName,
    this.accountIncomeName,
    this.accountTransferFromName,
    this.accountTransferToName,
    this.date,
    this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'transaction_type_id': transactionTypeId,
      'transaction_type_name': transactionTypeName,
      'category_id': categoryId,
      'category_name': categoryName,
      'account_expense_name': accountExpenseName,
      'account_income_name': accountIncomeName,
      'account_transfer_from_name': accountTransferFromName,
      'account_transfer_to_name': accountTransferToName,
      'date': date,
      'time': time,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      amount: map['amount'],
      transactionTypeId: map['transaction_type_id'],
      transactionTypeName: map['transaction_type_name'],
      categoryId: map['category_id'],
      categoryName: map['category_name'],
      accountExpenseName: map['account_expense_name'],
      accountIncomeName: map['account_income_name'],
      accountTransferFromName: map['account_transfer_from_name'],
      accountTransferToName: map['account_transfer_to_name'],
      date: map['date'],
      time: map['time'],
    );
  }
}
