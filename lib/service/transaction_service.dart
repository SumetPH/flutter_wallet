import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_wallet/model/transaction_detail_model.dart';
import 'package:flutter_wallet/model/transaction_model.dart';
import 'package:http/http.dart' as http;

class TransactionService {
  final apiUrl = dotenv.env['API_URL'];

  Future<List<TransactionModel>> getTransactionList({
    int? accountId,
    List<int?>? categoryId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final res = await http.get(
        Uri.parse(
          '$apiUrl/transaction/transaction-list?accountId=${accountId ?? ''}&categoryId=${categoryId != null ? categoryId.join(',') : ''}&startDate=${startDate ?? ''}&endDate=${endDate ?? ''}',
        ),
      );

      if (res.statusCode == 200) {
        List<dynamic> decode = jsonDecode(utf8.decode(res.bodyBytes));
        final list = decode.map((e) => TransactionModel.fromJson(e)).toList();
        return list;
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<TransactionDetailModel> getTransactionDetail({
    required int transactionId,
  }) async {
    try {
      final res = await http.get(
        Uri.parse(
            '$apiUrl/transaction/transaction-detail?transactionId=$transactionId'),
      );

      if (res.statusCode == 200) {
        final detail = TransactionDetailModel.fromJson(
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

  Future<int?> creteTransaction({
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
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        return data['createTransaction']['id'];
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      return null;
    }
  }

  Future<int?> updateTransaction({
    required int transactionId,
    required double amount,
    required int accountId,
    required int categoryId,
    required String date,
    required String time,
    String? note,
  }) async {
    try {
      final res = await http.put(
        Uri.parse('$apiUrl/transaction/transaction-update'),
        body: jsonEncode({
          'transactionId': transactionId,
          'amount': amount,
          'accountId': accountId,
          'categoryId': categoryId,
          'date': date,
          'time': time,
          'note': note,
        }),
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

  Future<bool> deleteTransaction({
    required int transactionId,
  }) async {
    try {
      final res = await http.delete(
        Uri.parse(
          '$apiUrl/transaction/transaction-delete?transactionId=$transactionId',
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
