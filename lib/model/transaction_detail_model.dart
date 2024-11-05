class TransactionDetailModel {
  int? id;
  String? amount;
  String? note;
  int? transactionTypeId;
  int? categoryId;
  String? date;
  String? time;
  int? accountId;
  String? accountName;

  TransactionDetailModel({
    this.id,
    this.amount,
    this.note,
    this.transactionTypeId,
    this.categoryId,
    this.date,
    this.time,
    this.accountId,
    this.accountName,
  });

  TransactionDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    note = json['note'];
    transactionTypeId = json['transaction_type_id'];
    categoryId = json['category_id'];
    date = json['date'];
    time = json['time'];
    accountId = json['account_id'];
    accountName = json['account_name'];
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
    data['account_id'] = accountId;
    data['account_name'] = accountName;
    return data;
  }
}
