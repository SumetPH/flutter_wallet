class AccountDetailModel {
  int? id;
  String? name;
  String? amount;
  int? accountTypeId;
  String? createdAt;
  String? updatedAt;
  int? order;

  AccountDetailModel({
    this.id,
    this.name,
    this.amount,
    this.accountTypeId,
    this.createdAt,
    this.updatedAt,
    this.order,
  });

  AccountDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
    accountTypeId = json['account_type_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['amount'] = amount;
    data['account_type_id'] = accountTypeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['order'] = order;
    return data;
  }
}
