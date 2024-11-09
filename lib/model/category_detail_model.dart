class CategoryDetailModel {
  int? id;
  String? name;
  int? categoryTypeId;
  String? createdAt;
  String? updatedAt;

  CategoryDetailModel({
    this.id,
    this.name,
    this.categoryTypeId,
    this.createdAt,
    this.updatedAt,
  });

  CategoryDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryTypeId = json['category_type_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category_type_id'] = categoryTypeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
