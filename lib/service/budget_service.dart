import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_wallet/model/budget_detail_model.dart';
import 'package:flutter_wallet/model/budget_model.dart';
import 'package:http/http.dart' as http;

class BudgetService {
  final apiUrl = dotenv.env['API_URL'];

  Future<List<BudgetModel>> getBudgetList() async {
    try {
      final res = await http.get(
        Uri.parse('$apiUrl/budget/budget-list'),
      );

      if (res.statusCode == 200) {
        List<dynamic> decode = jsonDecode(utf8.decode(res.bodyBytes));
        final list = decode.map((e) => BudgetModel.fromJson(e)).toList();
        return list;
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<BudgetDetailModel> getBudgetDetail({required int budgetId}) async {
    try {
      final res = await http.get(
        Uri.parse('$apiUrl/budget/budget-detail?budgetId=$budgetId'),
      );

      if (res.statusCode == 200) {
        final detail =
            BudgetDetailModel.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
        return detail;
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<bool> createBudget({
    required String name,
    required double amount,
    required int startDate,
    required List<int> categoryId,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$apiUrl/budget/budget-create'),
        body: jsonEncode({
          'name': name,
          'amount': amount,
          'startDate': startDate,
          'categoryId': categoryId
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

  Future<bool> updateBudget({
    required int budgetId,
    required String name,
    required double amount,
    required int startDate,
    required List<int> categoryId,
  }) async {
    try {
      final res = await http.put(
        Uri.parse('$apiUrl/budget/budget-update'),
        body: jsonEncode({
          'budgetId': budgetId,
          'name': name,
          'amount': amount,
          'startDate': startDate,
          'categoryId': categoryId
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

  Future<bool> deleteBudget({
    required int budgetId,
  }) async {
    try {
      final res = await http
          .delete(Uri.parse('$apiUrl/budget/budget-delete?budgetId=$budgetId'));

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

  Future<bool> orderBudget({required List<Map<String, dynamic>> list}) async {
    try {
      final res = await http.put(
          Uri.parse(
            '$apiUrl/budget/budget-order',
          ),
          body: jsonEncode({'list': list}));

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
