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
  double? amount;
  String? note;
  String? updatedAt;
  String? createdAt;
  int? transactionTypeId;
  String? transactionTypeName;
  int? categoryId;
  String? categoryName;
  int? categoryTypeId;
  String? categoryTypeName;
  int? accountIdFrom;
  String? accountIdFromName;
  int? accountIdTo;
  String? accountIdToName;
  String? date;
  String? time;

  TransactionListItem({
    this.id,
    this.amount,
    this.note,
    this.updatedAt,
    this.createdAt,
    this.transactionTypeId,
    this.transactionTypeName,
    this.categoryId,
    this.categoryName,
    this.categoryTypeId,
    this.categoryTypeName,
    this.accountIdFrom,
    this.accountIdFromName,
    this.accountIdTo,
    this.accountIdToName,
    this.date,
    this.time,
  });

  TransactionListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // amount = json['amount'];
    amount = (json['amount'] is int)
        ? (json['amount'] as int).toDouble()
        : json['amount'];
    note = json['note'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    transactionTypeId = json['transaction_type_id'];
    transactionTypeName = json['transaction_type_name'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryTypeId = json['category_type_id'];
    categoryTypeName = json['category_type_name'];
    accountIdFrom = json['account_id_from'];
    accountIdFromName = json['account_id_from_name'];
    accountIdTo = json['account_id_to'];
    accountIdToName = json['account_id_to_name'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['note'] = note;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['transaction_type_id'] = transactionTypeId;
    data['transaction_type_name'] = transactionTypeName;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['category_type_id'] = categoryTypeId;
    data['category_type_name'] = categoryTypeName;
    data['account_id_from'] = accountIdFrom;
    data['account_id_from_name'] = accountIdFromName;
    data['account_id_to'] = accountIdTo;
    data['account_id_to_name'] = accountIdToName;
    data['date'] = date;
    data['time'] = time;
    return data;
  }
}
