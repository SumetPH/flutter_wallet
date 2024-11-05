class TransactionModel {
  int? id;
  String? amount;
  int? transactionTypeId;
  String? transactionTypeName;
  int? categoryId;
  String? categoryName;
  int? accountExpenseId;
  String? accountExpenseName;
  int? accountIncomeId;
  String? accountIncomeName;
  int? accountTransferFromId;
  String? accountTransferFromName;
  int? accountTransferToId;
  String? accountTransferToName;
  String? date;
  String? time;

  TransactionModel({
    this.id,
    this.amount,
    this.transactionTypeId,
    this.transactionTypeName,
    this.categoryId,
    this.categoryName,
    this.accountExpenseId,
    this.accountExpenseName,
    this.accountIncomeId,
    this.accountIncomeName,
    this.accountTransferFromId,
    this.accountTransferFromName,
    this.accountTransferToId,
    this.accountTransferToName,
    this.date,
    this.time,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    transactionTypeId = json['transaction_type_id'];
    transactionTypeName = json['transaction_type_name'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    accountExpenseId = json['account_expense_id'];
    accountExpenseName = json['account_expense_name'];
    accountIncomeId = json['account_income_id'];
    accountIncomeName = json['account_income_name'];
    accountTransferFromId = json['account_transfer_from_id'];
    accountTransferFromName = json['account_transfer_from_name'];
    accountTransferToId = json['account_transfer_to_id'];
    accountTransferToName = json['account_transfer_to_name'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['transaction_type_id'] = transactionTypeId;
    data['transaction_type_name'] = transactionTypeName;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['account_expense_id'] = accountExpenseId;
    data['account_expense_name'] = accountExpenseName;
    data['account_income_id'] = accountIncomeId;
    data['account_income_name'] = accountIncomeName;
    data['account_transfer_from_id'] = accountTransferFromId;
    data['account_transfer_from_name'] = accountTransferFromName;
    data['account_transfer_to_id'] = accountTransferToId;
    data['account_transfer_to_name'] = accountTransferToName;
    data['date'] = date;
    data['time'] = time;
    return data;
  }
}
