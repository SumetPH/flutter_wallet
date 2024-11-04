import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_wallet/model/transaction_model.dart';
import 'package:http/http.dart' as http;

class TransactionService {
  final apiUrl = dotenv.env['API_URL'];

  Future<List<TransactionModel>> getTransactionList({
    int? accountId,
  }) async {
    try {
      final res = await http.get(
        Uri.parse(
            '$apiUrl/transaction/transaction-list?accountId=${accountId ?? ''}'),
      );

      if (res.statusCode == 200) {
        List<dynamic> decode = jsonDecode(utf8.decode(res.bodyBytes));
        final list = decode.map((e) => TransactionModel.fromJson(e)).toList();
        return list;
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<bool> creteTransaction({
    required double amount,
    required int accountId,
    required int categoryId,
    required int transactionTypeId,
    required String date,
    required String time,
    String? note,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$apiUrl/transaction/transaction-create'),
        body: jsonEncode({
          'amount': amount,
          'accountId': accountId,
          'categoryId': categoryId,
          'transactionTypeId': transactionTypeId,
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
}