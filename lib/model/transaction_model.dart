class TransactionModel {
  String? day;
  List<TransactionListItem>? transactionList;

  TransactionModel({this.day, this.transactionList});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    if (json['transaction_list'] != null) {
      transactionList = <TransactionListItem>[];
      json['transaction_list'].forEach((v) {
        transactionList!.add(TransactionListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    if (transactionList != null) {
      data['transaction_list'] =
          transactionList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransactionListItem {
  int? id;
  String? amount;
  int? transactionTypeId;
  String? transactionTypeName;
  int? categoryId;
  String? categoryName;
  int? expenseAccountId;
  String? expenseAccountName;
  int? incomeAccountId;
  String? incomeAccountName;
  int? transferAccountIdFrom;
  String? transferAccountNameFrom;
  int? transferAccountIdTo;
  String? transferAccountNameTo;
  int? debtAccountIdFrom;
  String? debtAccountNameFrom;
  int? debtAccountIdTo;
  String? debtAccountNameTo;
  String? date;
  String? time;
  String? note;

  TransactionListItem({
    this.id,
    this.amount,
    this.transactionTypeId,
    this.transactionTypeName,
    this.categoryId,
    this.categoryName,
    this.expenseAccountId,
    this.expenseAccountName,
    this.incomeAccountId,
    this.incomeAccountName,
    this.transferAccountIdFrom,
    this.transferAccountNameFrom,
    this.transferAccountIdTo,
    this.transferAccountNameTo,
    this.debtAccountIdFrom,
    this.debtAccountNameFrom,
    this.debtAccountIdTo,
    this.debtAccountNameTo,
    this.date,
    this.time,
    this.note,
  });

  TransactionListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    transactionTypeId = json['transaction_type_id'];
    transactionTypeName = json['transaction_type_name'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    expenseAccountId = json['expense_account_id'];
    expenseAccountName = json['expense_account_name'];
    incomeAccountId = json['income_account_id'];
    incomeAccountName = json['income_account_name'];
    transferAccountIdFrom = json['transfer_account_id_from'];
    transferAccountNameFrom = json['transfer_account_name_from'];
    transferAccountIdTo = json['transfer_account_id_to'];
    transferAccountNameTo = json['transfer_account_name_to'];
    debtAccountIdFrom = json['debt_account_id_from'];
    debtAccountNameFrom = json['debt_account_name_from'];
    debtAccountIdTo = json['debt_account_id_to'];
    debtAccountNameTo = json['debt_account_name_to'];
    date = json['date'];
    time = json['time'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['transaction_type_id'] = transactionTypeId;
    data['transaction_type_name'] = transactionTypeName;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['expense_account_id'] = expenseAccountId;
    data['expense_account_name'] = expenseAccountName;
    data['income_account_id'] = incomeAccountId;
    data['income_account_name'] = incomeAccountName;
    data['transfer_account_id_from'] = transferAccountIdFrom;
    data['transfer_account_name_from'] = transferAccountNameFrom;
    data['transfer_account_id_to'] = transferAccountIdTo;
    data['transfer_account_name_to'] = transferAccountNameTo;
    data['debt_account_id_from'] = debtAccountIdFrom;
    data['debt_account_name_from'] = debtAccountNameFrom;
    data['debt_account_id_to'] = debtAccountIdTo;
    data['debt_account_name_to'] = debtAccountNameTo;
    data['date'] = date;
    data['time'] = time;
    data['note'] = note;
    return data;
  }
}
