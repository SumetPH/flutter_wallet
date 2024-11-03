class AccountModel {
  int? id;
  String? name;
  String? amount;
  int? accountTypeId;
  String? accountTypeName;
  String? balance;

  AccountModel({
    this.id,
    this.name,
    this.amount,
    this.accountTypeId,
    this.accountTypeName,
    this.balance,
  });

  AccountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
    accountTypeId = json['account_type_id'];
    accountTypeName = json['account_type_name'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['amount'] = amount;
    data['account_type_id'] = accountTypeId;
    data['account_type_name'] = accountTypeName;
    data['balance'] = balance;
    return data;
  }
}
