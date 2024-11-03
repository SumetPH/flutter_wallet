import 'package:flutter_wallet/data/db.dart';
import 'package:flutter_wallet/model/account_type_model.dart';
import 'package:postgres/postgres.dart';

class AccountTypeService {
  final _db = DBHelper();

  Future<List<AccountTypeModel>> getAccountTypeList() async {
    try {
      final conn = await _db.connection();
      final result = await conn.execute(
        Sql.named('SELECT * FROM account_type'),
      );
      // List<AccountTypeModel> accountTypeList = result
      //     .map((row) => AccountTypeModel.fromMap(row.toColumnMap()))
      //     .toList();

      // return accountTypeList;
      return [];
    } catch (e) {
      throw Exception(e);
    } finally {
      await _db.close();
    }
  }
}
