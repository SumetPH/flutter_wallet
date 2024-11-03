import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_wallet/model/account_model.dart';
import 'package:http/http.dart' as http;

class AccountService {
  final apiUrl = dotenv.env['API_URL'];

  Future<List<AccountModel>> getAccountList({List<int>? type}) async {
    try {
      Map<String, dynamic> body = {};
      if (type != null) {
        body['type'] = type;
      }

      final res = await http.post(
        Uri.parse('$apiUrl/account/account-list'),
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        List<dynamic> list = jsonDecode(utf8.decode(res.bodyBytes));
        final accountList = list.map((e) => AccountModel.fromJson(e)).toList();
        return accountList;
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<AccountModel> getAccountDetail({required int accountId}) async {
    try {
      final res = await http.get(
        Uri.parse('$apiUrl/account/account-detail?accountId=$accountId'),
      );

      if (res.statusCode == 200) {
        final account =
            AccountModel.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
        return account;
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<bool> createAccount({
    required String name,
    required double amount,
    required int accountTypeId,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$apiUrl/account/account-create'),
        body: jsonEncode({
          'name': name,
          'amount': amount,
          'accountTypeId': accountTypeId,
        }),
      );

      if (res.statusCode == 200) {
        return true;
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateAccount({
    required int accountId,
    required String name,
    required double amount,
    required int accountTypeId,
  }) async {
    try {
      final res = await http.put(
        Uri.parse('$apiUrl/account/account-update'),
        body: jsonEncode({
          'accountId': accountId,
          'name': name,
          'amount': amount,
          'accountTypeId': accountTypeId,
        }),
      );

      if (res.statusCode == 200) {
        return true;
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteAccount({required int accountId}) async {
    try {
      final res = await http.delete(
        Uri.parse('$apiUrl/account/account-delete?accountId=$accountId'),
      );

      if (res.statusCode == 200) {
        return true;
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
