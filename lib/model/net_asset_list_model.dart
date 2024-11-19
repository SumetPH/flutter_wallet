class NetAssetListModel {
  List<PropertyList>? propertyList;
  List<DebtList>? debtList;

  NetAssetListModel({this.propertyList, this.debtList});

  NetAssetListModel.fromJson(Map<String, dynamic> json) {
    if (json['property_list'] != null) {
      propertyList = <PropertyList>[];
      json['property_list'].forEach((v) {
        propertyList!.add(PropertyList.fromJson(v));
      });
    }
    if (json['debt_list'] != null) {
      debtList = <DebtList>[];
      json['debt_list'].forEach((v) {
        debtList!.add(DebtList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (propertyList != null) {
      data['property_list'] = propertyList!.map((v) => v.toJson()).toList();
    }
    if (debtList != null) {
      data['debt_list'] = debtList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PropertyList {
  int? accountId;
  String? accountName;
  bool? status;

  PropertyList({this.accountId, this.accountName, this.status});

  PropertyList.fromJson(Map<String, dynamic> json) {
    accountId = json['account_id'];
    accountName = json['account_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account_id'] = accountId;
    data['account_name'] = accountName;
    data['status'] = status;
    return data;
  }
}

class DebtList {
  int? accountId;
  String? accountName;
  bool? status;

  DebtList({this.accountId, this.accountName, this.status});

  DebtList.fromJson(Map<String, dynamic> json) {
    accountId = json['account_id'];
    accountName = json['account_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account_id'] = accountId;
    data['account_name'] = accountName;
    data['status'] = status;
    return data;
  }
}
