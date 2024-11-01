class TransactionsTypeModel {
  int id;
  String name;

  TransactionsTypeModel({
    required this.id,
    required this.name,
  });

  factory TransactionsTypeModel.fromMap(Map<String, dynamic> map) {
    return TransactionsTypeModel(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
