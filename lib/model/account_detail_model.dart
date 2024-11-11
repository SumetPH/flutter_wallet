class AccountDetailModel {
  int? id;
  String? name;
  String? amount;
  int? accountTypeId;
  String? createdAt;
  String? updatedAt;
  int? order;
  String? iconPath;

  AccountDetailModel({
    this.id,
    this.name,
    this.amount,
    this.accountTypeId,
    this.createdAt,
    this.updatedAt,
    this.order,
    this.iconPath,
  });

  AccountDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
    accountTypeId = json['account_type_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    order = json['order'];
    iconPath = json['icon_path'];
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
    data['icon_path'] = iconPath;
    return data;
  }
}
