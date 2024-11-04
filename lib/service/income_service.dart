import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class IncomeService {
  final apiUrl = dotenv.env['API_URL'];

  Future<bool> createIncome({
    required double amount,
    required int accountId,
    required int categoryId,
    String? note,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$apiUrl/income/income-create'),
        body: jsonEncode({
          'amount': amount,
          'accountId': accountId,
          'categoryId': categoryId,
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
