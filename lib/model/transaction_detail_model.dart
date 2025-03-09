class TransactionDetailModel {
  int? id;
  String? amount;
  String? note;
  int? transactionTypeId;
  int? categoryId;
  int? accountIdFrom;
  int? accountIdTo;
  String? createdAt;
  String? updatedAt;
  String? transactionTypeName;
  String? categoryName;
  String? accountIdFromName;
  String? accountIdToName;
  String? date;
  String? time;

  TransactionDetailModel(
      {this.id,
      this.amount,
      this.note,
      this.transactionTypeId,
      this.categoryId,
      this.accountIdFrom,
      this.accountIdTo,
      this.createdAt,
      this.updatedAt,
      this.transactionTypeName,
      this.categoryName,
      this.accountIdFromName,
      this.accountIdToName,
      this.date,
      this.time});

  TransactionDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    note = json['note'];
    transactionTypeId = json['transaction_type_id'];
    categoryId = json['category_id'];
    accountIdFrom = json['account_id_from'];
    accountIdTo = json['account_id_to'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    transactionTypeName = json['transaction_type_name'];
    categoryName = json['category_name'];
    accountIdFromName = json['account_id_from_name'];
    accountIdToName = json['account_id_to_name'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['note'] = note;
    data['transaction_type_id'] = transactionTypeId;
    data['category_id'] = categoryId;
    data['account_id_from'] = accountIdFrom;
    data['account_id_to'] = accountIdTo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['transaction_type_name'] = transactionTypeName;
    data['category_name'] = categoryName;
    data['account_id_from_name'] = accountIdFromName;
    data['account_id_to_name'] = accountIdToName;
    data['date'] = date;
    data['time'] = time;
    return data;
  }
}
