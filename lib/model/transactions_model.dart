class TransactionsModel {
  int? id;
  String? name;
  String? type;
  double? amount;

  TransactionsModel({
    this.id,
    this.name,
    this.type,
    this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'amount': amount,
    };
  }

  factory TransactionsModel.fromMap(Map<String, dynamic> map) {
    return TransactionsModel(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      amount: map['amount'],
    );
  }
}
