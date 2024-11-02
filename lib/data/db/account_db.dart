import 'package:flutter_wallet/data/db.dart';
import 'package:flutter_wallet/model/account_model.dart';
import 'package:sqflite/sqflite.dart';

class AccountDB {
  DBHelper dbHelper = DBHelper();

  Future<List<AccountModel>> getAccountList({String? type}) async {
    Database db = await dbHelper.db;
    final list = await db.rawQuery(
      """
        SELECT 
          a.id,
          a.name,
          a.amount,
          a.type,
          printf("%.2f",
            (
              a.amount -- initial
              -
              COALESCE (
                (
                  SELECT SUM(t.amount) 
                  FROM transactions t 
                  WHERE t.transaction_type_id = 1 AND t.account_id = a.id 
                ),0
              ) -- expense
              +
              COALESCE (
                (
                  SELECT SUM(t.amount) 
                  FROM transactions t 
                  WHERE t.transaction_type_id = 2 AND t.account_id = a.id 
                ),0
              ) -- income
              -
              COALESCE (
                (
                  SELECT SUM(t.amount) 
                  FROM transactions t 
                  LEFT JOIN transfer tf
                  ON tf.transactions_id = t.id
                  WHERE t.transaction_type_id = 3 AND tf.account_id_from = a.id 
                ),0
              ) -- transfer out
              +
              COALESCE (
                (
                  SELECT SUM(t.amount) 
                  FROM transactions t 
                  LEFT JOIN transfer tf
                  ON tf.transactions_id = t.id
                  WHERE t.transaction_type_id = 3 AND tf.account_id_to = a.id 
                ),0
              ) -- transfer in
              -
              COALESCE (
                (
                  SELECT SUM(t.amount) 
                  FROM transactions t 
                  LEFT JOIN debt d
                  ON d.transactions_id = t.id
                  WHERE t.transaction_type_id = 4 AND d.account_id_from = a.id 
                ),0
              ) -- debt out
              +
              COALESCE (
                (
                  SELECT SUM(t.amount) 
                  FROM transactions t 
                  LEFT JOIN debt d
                  ON d.transactions_id = t.id
                  WHERE t.transaction_type_id = 4 AND d.account_id_to = a.id 
                ),0
              ) -- debt in
            )
          ) AS balance
        FROM account a 
        ${type != null ? 'WHERE type IN ($type)' : ''}
        ORDER BY a.name
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

  Future<int> createAccount({
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

  Future<int> deleteAccount({required id}) async {
    Database db = await dbHelper.db;
    int count = await db.rawDelete("DELETE FROM account WHERE id = ?", [id]);
    return count;
  }
}
