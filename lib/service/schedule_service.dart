import 'dart:convert';

import 'package:flutter_wallet/model/schedule_list_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ScheduleService {
  final apiUrl = dotenv.env['API_URL'];

  Future<List<ScheduleListModel>> getScheduleList() async {
    final response =
        await http.get(Uri.parse('$apiUrl/schedule/schedule-list'));
    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));
      return list.map((e) => ScheduleListModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load schedule list');
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
}
