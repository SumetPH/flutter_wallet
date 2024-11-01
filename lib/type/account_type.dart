import 'package:flutter_wallet/model/account_type_model.dart';

class AccountType {
  static int cash = 1;
  static int blank = 2;
  static int credit = 3;
  static int debt = 4;

  static List<AccountTypeModel> list = [
    AccountTypeModel(id: cash, name: 'เงินสด'),
    AccountTypeModel(id: blank, name: 'ธนาคาร'),
    AccountTypeModel(id: credit, name: 'บัตรเครดิต'),
    AccountTypeModel(id: debt, name: 'หนี้สิน'),
  ];

  static String getName(int id) {
    try {
      return list.firstWhere((item) => item.id == id).name;
    } catch (e) {
      return 'บัญชี';
    }
  }
}
