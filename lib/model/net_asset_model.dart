class NetAssetModel {
  String property;
  String debt;
  String total;

  NetAssetModel({
    required this.property,
    required this.debt,
    required this.total,
  });

  factory NetAssetModel.fromJson(Map<String, dynamic> json) {
    return NetAssetModel(
      property: json['property'],
      debt: json['debt'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['property'] = property;
    data['debt'] = debt;
    data['total'] = total;
    return data;
  }
}
