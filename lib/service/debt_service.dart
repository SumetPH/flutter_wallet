import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_wallet/model/debt_detail_model.dart';
import 'package:http/http.dart' as http;

class DebtService {
  final apiUrl = dotenv.env['API_URL'];

  Future<DebtDetailModel> getDebtDetail({
    required int transactionId,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('$apiUrl/debt/debt-detail?transactionId=$transactionId'),
      );

      if (res.statusCode == 200) {
        final detail = DebtDetailModel.fromJson(
          jsonDecode(utf8.decode(res.bodyBytes)),
        );
        return detail;
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<bool> createDebt({
    required double amount,
    required int accountIdFrom,
    required int accountIdTo,
    required String date,
    required String time,
    String? note,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$apiUrl/debt/debt-create'),
        body: jsonEncode({
          'amount': amount,
          'note': note,
          'accountIdFrom': accountIdFrom,
          'accountIdTo': accountIdTo,
          'date': date,
          'time': time,
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

  Future<bool> updateDebt({
    required int transactionId,
    required double amount,
    required String date,
    required String time,
    required int accountIdFrom,
    required int accountIdTo,
    String? note,
  }) async {
    try {
      final res = await http.patch(
        Uri.parse('$apiUrl/debt/debt-update'),
        body: jsonEncode({
          'transactionId': transactionId,
          'amount': amount,
          'accountIdFrom': accountIdFrom,
          'accountIdTo': accountIdTo,
          'date': date,
          'time': time,
          'note': note,
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

  Future<bool> deleteDebt({
    required int transactionId,
  }) async {
    try {
      final res = await http.delete(
        Uri.parse(
          '$apiUrl/debt/debt-delete?transactionId=$transactionId',
        ),
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
