import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_wallet/model/category_model.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  final apiUrl = dotenv.env['API_URL'];

  Future<List<CategoryModel>> getCategoryList({int? categoryTypeId}) async {
    try {
      final res = await http.get(
        Uri.parse(
          '$apiUrl/category/category-list?categoryTypeId=$categoryTypeId',
        ),
      );

      if (res.statusCode == 200) {
        List<dynamic> decode = jsonDecode(utf8.decode(res.bodyBytes));
        final list = decode.map((e) => CategoryModel.fromJson(e)).toList();
        return list;
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<CategoryModel> getCategoryDetail({required int categoryId}) async {
    try {
      final res = await http.get(
        Uri.parse(
          '$apiUrl/category/category-detail?categoryId=$categoryId',
        ),
      );

      if (res.statusCode == 200) {
        final detail =
            CategoryModel.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
        return detail;
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<bool> createCategory({
    required String name,
    required int categoryTypeId,
  }) async {
    try {
      final res = await http.post(
          Uri.parse(
            '$apiUrl/category/category-create',
          ),
          body: jsonEncode({
            'name': name,
            'categoryTypeId': categoryTypeId,
          }));

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

  Future<bool> updateCategory({
    required int categoryId,
    required String name,
    required int categoryTypeId,
  }) async {
    try {
      final res = await http.put(
          Uri.parse(
            '$apiUrl/category/category-update',
          ),
          body: jsonEncode({
            'categoryId': categoryId,
            'name': name,
            'categoryTypeId': categoryTypeId,
          }));

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

  Future<bool> deleteCategory({required int categoryId}) async {
    try {
      final res = await http.delete(
        Uri.parse(
          '$apiUrl/category/category-delete?categoryId=$categoryId',
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

  Future<bool> orderCategory({required List<Map<String, dynamic>> list}) async {
    try {
      final res = await http.put(
          Uri.parse(
            '$apiUrl/category/category-order',
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
