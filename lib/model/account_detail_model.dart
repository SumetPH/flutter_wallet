class AccountDetailModel {
  int? id;
  String? name;
  String? amount;
  int? accountTypeId;
  String? createdAt;
  String? updatedAt;
  int? orderIndex;
  String? iconPath;
  int? creditStartDate;
  bool? isHidden;

  AccountDetailModel({
    this.id,
    this.name,
    this.amount,
    this.accountTypeId,
    this.createdAt,
    this.updatedAt,
    this.orderIndex,
    this.iconPath,
    this.creditStartDate,
    this.isHidden,
  });

  AccountDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
    accountTypeId = json['account_type_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    orderIndex = json['order_index'];
    iconPath = json['icon_path'];
    creditStartDate = json['credit_start_date'];
    isHidden = json['is_hidden'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['amount'] = amount;
    data['account_type_id'] = accountTypeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['order_index'] = orderIndex;
    data['icon_path'] = iconPath;
    data['credit_start_date'] = creditStartDate;
    data['is_hidden'] = isHidden;
    return data;
  }
}
