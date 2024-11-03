class CategoryModel {
  int id;
  String? name;
  int? categoryTypeId;

  CategoryModel({
    required this.id,
    this.name,
    this.categoryTypeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category_type_id': categoryTypeId,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      categoryTypeId: map['category_type_id'],
    );
  }
}
