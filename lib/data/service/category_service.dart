import 'package:flutter_wallet/data/db.dart';
import 'package:flutter_wallet/model/category_model.dart';
import 'package:postgres/postgres.dart';

class CategoryService {
  final _db = DBHelper();

  Future<List<CategoryModel>> getCategoryList({
    required int categoryTypeId,
  }) async {
    try {
      final conn = await _db.connection();
      final result = await conn.execute(
          Sql.named(
            'SELECT * FROM category WHERE category_type_id=@categoryTypeId',
          ),
          parameters: {
            'categoryTypeId': categoryTypeId,
          });
      List<CategoryModel> categoryList = result
          .map((row) => CategoryModel.fromMap(row.toColumnMap()))
          .toList();
      return categoryList;
    } catch (e) {
      throw Exception(e);
    } finally {
      await _db.close();
    }
  }
}
