class DebtDetailModel {
  int? id;
  String? amount;
  String? note;
  int? transactionTypeId;
  int? categoryId;
  String? date;
  String? time;
  int? accountIdFrom;
  String? accountNameFrom;
  int? accountIdTo;
  String? accountNameTo;

  DebtDetailModel(
      {this.id,
      this.amount,
      this.note,
      this.transactionTypeId,
      this.categoryId,
      this.date,
      this.time,
      this.accountIdFrom,
      this.accountNameFrom,
      this.accountIdTo,
      this.accountNameTo});

  DebtDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    note = json['note'];
    transactionTypeId = json['transaction_type_id'];
    categoryId = json['category_id'];
    date = json['date'];
    time = json['time'];
    accountIdFrom = json['account_id_from'];
    accountNameFrom = json['account_name_from'];
    accountIdTo = json['account_id_to'];
    accountNameTo = json['account_name_to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['note'] = note;
    data['transaction_type_id'] = transactionTypeId;
    data['category_id'] = categoryId;
    data['date'] = date;
    data['time'] = time;
    data['account_id_from'] = accountIdFrom;
    data['account_name_from'] = accountNameFrom;
    data['account_id_to'] = accountIdTo;
    data['account_name_to'] = accountNameTo;
    return data;
  }
}
