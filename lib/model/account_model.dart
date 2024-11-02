class AccountModel {
  int? id;
  String? name;
  double? amount;
  int? type;
  double? balance;

  AccountModel({
    this.id,
    this.name,
    this.amount,
    this.type,
    this.balance,
  });

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      type: map['type'],
      balance: map['balance'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'type': type,
      'balance': balance,
    };
  }
}
