import 'package:flutter_wallet/db/db.dart';
import 'package:flutter_wallet/model/account_model.dart';
import 'package:sqflite/sqflite.dart';

class AccountDb {
  DBHelper dbHelper = DBHelper();

  Future<List<AccountModel>> getAccount() async {
    Database db = await dbHelper.db;
    final list = await db.rawQuery(
      """
        SELECT
          a.id,
          a.name,
          a.amount,
          a.type,
          (
            a.amount
            +
            COALESCE(
              SUM(
                CASE WHEN t.transaction_type_id = 1
                THEN t.amount ELSE 0
                END
              ),0
            ) -- income
            -
            COALESCE(
              SUM(
                CASE WHEN t.transaction_type_id = 2
                THEN t.amount ELSE 0
                END
              ),0
            ) -- expense
          ) AS balance
        FROM 
          account a
        LEFT JOIN 
          transactions t 
        ON t.account_id = a.id
        GROUP by a.id
      """,
    );
    List<AccountModel> accountList =
        list.map((c) => AccountModel.fromMap(c)).toList();
    return accountList;
  }

  Future<AccountModel> getAccountDetail({required id}) async {
    Database db = await dbHelper.db;
    final list =
        await db.rawQuery("SELECT * FROM account WHERE id = ? limit 1", [id]);
    List<AccountModel> accountList =
        list.map((c) => AccountModel.fromMap(c)).toList();
    return accountList.first;
  }

  Future<int> addAccount({
    required name,
    required amount,
    required type,
  }) async {
    Database db = await dbHelper.db;
    int id = await db.rawInsert(
      "INSERT INTO account(name, amount, type) VALUES(?, ?, ?)",
      [name, amount, type],
    );
    return id;
  }

  Future<int> updateAccount({
    required id,
    required name,
    required amount,
    required type,
  }) async {
    Database db = await dbHelper.db;
    int count = await db.rawUpdate(
      "UPDATE account SET name = ?, amount = ?, type = ? WHERE id = ?",
      [name, amount, type, id],
    );
    return count;
  }

  Future<int> removeAccount({required id}) async {
    Database db = await dbHelper.db;
    int count = await db.rawDelete("DELETE FROM account WHERE id = ?", [id]);
    return count;
  }
}
