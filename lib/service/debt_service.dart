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
      throw Exception(e);
    }
  }

  Future<int?> createDebt({
    required double amount,
    required int accountIdFrom,
    required int accountIdTo,
    required String date,
    required String time,
    int? categoryId,
    String? note,
  }) async {
    try {
      final body = {
        'amount': amount,
        'note': note,
        'accountIdFrom': accountIdFrom,
        'accountIdTo': accountIdTo,
        'date': date,
        'time': time,
      };
      if (categoryId != null) {
        body['categoryId'] = categoryId;
      }

      final res = await http.post(
        Uri.parse('$apiUrl/debt/debt-create'),
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        return data['createTransaction']['id'];
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      return null;
    }
  }

  Future<int?> updateDebt({
    required int transactionId,
    required double amount,
    required String date,
    required String time,
    required int accountIdFrom,
    required int accountIdTo,
    int? categoryId,
    String? note,
  }) async {
    try {
      final body = {
        'transactionId': transactionId,
        'amount': amount,
        'accountIdFrom': accountIdFrom,
        'accountIdTo': accountIdTo,
        'date': date,
        'time': time,
        'note': note,
      };
      if (categoryId != null) {
        body['categoryId'] = categoryId;
      }
      final res = await http.put(
        Uri.parse('$apiUrl/debt/debt-update'),
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        return data['id'];
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      return null;
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
      return false;
    }
  }
}
