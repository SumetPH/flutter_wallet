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
      print(accountId);
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
}
