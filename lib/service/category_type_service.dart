import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_wallet/model/category_type_model.dart';
import 'package:http/http.dart' as http;

class CategoryTypeService {
  final apiUrl = dotenv.env['API_URL'];

  Future<List<CategoryTypeModel>> getCategoryTypeList() async {
    try {
      final res = await http.get(
        Uri.parse(
          '$apiUrl/category-type/category-type-list',
        ),
      );

      if (res.statusCode == 200) {
        List<dynamic> decode = jsonDecode(utf8.decode(res.bodyBytes));
        final list = decode.map((e) => CategoryTypeModel.fromJson(e)).toList();
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
