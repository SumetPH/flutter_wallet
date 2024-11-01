class AccountTypeModel {
  int id;
  String name;

  AccountTypeModel({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory AccountTypeModel.fromMap(Map<String, dynamic> map) {
    return AccountTypeModel(
      id: map['id'],
      name: map['name'],
    );
  }
}
