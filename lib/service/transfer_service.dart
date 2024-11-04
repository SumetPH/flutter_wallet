import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TransferService {
  final apiUrl = dotenv.env['API_URL'];

  Future<bool> createTransfer({
    required double amount,
    required int accountIdFrom,
    required int accountIdTo,
    String? note,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$apiUrl/transfer/transfer-create'),
        body: jsonEncode({
          'amount': amount,
          'note': note,
          'accountIdFrom': accountIdFrom,
          'accountIdTo': accountIdTo,
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
