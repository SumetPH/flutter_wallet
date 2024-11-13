class AccountModel {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? total;
  List<AccountList>? accountList;

  AccountModel({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.total,
    this.accountList,
  });

  AccountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    total = json['total'];
    if (json['accountList'] != null) {
      accountList = <AccountList>[];
      json['accountList'].forEach((v) {
        accountList!.add(AccountList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['total'] = total;
    if (accountList != null) {
      data['accountList'] = accountList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AccountList {
  int? id;
  String? name;
  String? amount;
  int? accountTypeId;
  String? balance;
  String? iconPath;
  int? creditStartDate;

  AccountList({
    this.id,
    this.name,
    this.amount,
    this.accountTypeId,
    this.balance,
    this.iconPath,
    this.creditStartDate,
  });

  AccountList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
    accountTypeId = json['account_type_id'];
    balance = json['balance'];
    iconPath = json['icon_path'];
    creditStartDate = json['credit_start_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['amount'] = amount;
    data['account_type_id'] = accountTypeId;
    data['balance'] = balance;
    data['icon_path'] = iconPath;
    data['credit_start_date'] = creditStartDate;
    return data;
  }
}
