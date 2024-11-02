import 'package:flutter_wallet/model/transactions_type_model.dart';

class TransactionsType {
  static int expense = 1;
  static int income = 2;
  static int transfer = 3;
  static int debtPayment = 4;

  static List<TransactionsTypeModel> list = [
    TransactionsTypeModel(id: expense, name: 'รายจ่าย'),
    TransactionsTypeModel(id: income, name: 'รายรับ'),
    TransactionsTypeModel(id: transfer, name: 'โอน'),
    TransactionsTypeModel(id: debtPayment, name: 'ชำระหนี้'),
  ];

  static String getName(int id) {
    try {
      return list.firstWhere((item) => item.id == id).name;
    } catch (e) {
      return '';
    }
  }
}
