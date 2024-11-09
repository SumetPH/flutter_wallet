import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_wallet/model/transfer_detail_model.dart';
import 'package:http/http.dart' as http;

class TransferService {
  final apiUrl = dotenv.env['API_URL'];

  Future<TransferDetailModel> getTransferDetail({
    required int transactionId,
  }) async {
    try {
      final res = await http.get(
        Uri.parse(
            '$apiUrl/transfer/transfer-detail?transactionId=$transactionId'),
      );

      if (res.statusCode == 200) {
        final detail = TransferDetailModel.fromJson(
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

  Future<bool> createTransfer({
    required double amount,
    required int accountIdFrom,
    required int accountIdTo,
    required String date,
    required String time,
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

  Future<bool> updateTransfer({
    required int transactionId,
    required double amount,
    required String date,
    required String time,
    required int accountIdFrom,
    required int accountIdTo,
    String? note,
  }) async {
    try {
      final res = await http.put(
        Uri.parse('$apiUrl/transfer/transfer-update'),
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

  Future<bool> deleteTransfer({
    required int transactionId,
  }) async {
    try {
      final res = await http.delete(
        Uri.parse(
          '$apiUrl/transfer/transfer-delete?transactionId=$transactionId',
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
