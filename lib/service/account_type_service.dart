import 'dart:convert';

import 'package:flutter_wallet/model/account_type_model.dart';
import 'package:http/http.dart' as http;

class AccountTypeService {
  Future<List<AccountTypeModel>> getAccountTypeList() async {
    try {
      final res = await http.get(
        Uri.parse(
            'http://192.168.1.11:3000/api/account-type/account-type-list'),
      );

      if (res.statusCode == 200) {
        List<dynamic> list = jsonDecode(utf8.decode(res.bodyBytes));
        final accountTypeList =
            list.map((e) => AccountTypeModel.fromJson(e)).toList();
        return accountTypeList;
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
