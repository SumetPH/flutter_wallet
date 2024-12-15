import 'dart:convert';

import 'package:flutter_wallet/model/schedule_list_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_wallet/model/schedule_transaction_model.dart';
import 'package:http/http.dart' as http;

class ScheduleService {
  final apiUrl = dotenv.env['API_URL'];

  Future<List<ScheduleListModel>> getScheduleList() async {
    try {
      final response =
          await http.get(Uri.parse('$apiUrl/schedule/schedule-list'));
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));
        return list.map((e) => ScheduleListModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load schedule list');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<ScheduleTransactionModel>> getScheduleTransactionList({
    required int scheduleId,
  }) async {
    try {
      final res = await http.get(Uri.parse(
          '$apiUrl/schedule/schedule-transaction-list?scheduleId=$scheduleId'));
      if (res.statusCode == 200) {
        List<dynamic> data = jsonDecode(utf8.decode(res.bodyBytes));
        List<ScheduleTransactionModel> list =
            data.map((e) => ScheduleTransactionModel.fromJson(e)).toList();
        return list;
      } else {
        throw Exception('Failed to load schedule transaction list');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> createSchedule({
    required String name,
    required double amount,
    required String startDate,
    required String endDate,
    required int transactionTypeId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/schedule/schedule-create'),
        body: jsonEncode({
          'name': name,
          'amount': amount,
          'start_date': startDate,
          'end_date': endDate,
          'transaction_type_id': transactionTypeId,
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to create schedule');
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> scheduleTransactionPaid({
    required int scheduleId,
    required int transactionId,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/schedule/schedule-transaction-paid'),
        body: jsonEncode({
          'scheduleId': scheduleId,
          'transactionId': transactionId,
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update schedule transaction paid');
      }
    } catch (e) {
      return false;
    }
  }
}
