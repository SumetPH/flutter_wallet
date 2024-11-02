import 'package:flutter_wallet/data/db.dart';
import 'package:flutter_wallet/model/account_model.dart';
import 'package:flutter_wallet/utils/time_utils.dart';
import 'package:sqflite/sqflite.dart';

class AccountDb {
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
          (
            a.amount -- initial
            -
            COALESCE (
              (
                SELECT SUM(t.amount) 
                FROM transactions t 
                LEFT JOIN expense e 
                ON e.transactions_id = t.id
                WHERE t.transaction_type_id = 1 AND e.account_id = a.id
              ),0
            ) -- expense
            +
            COALESCE (
              (
                SELECT SUM(t.amount) 
                FROM transactions t 
                  LEFT JOIN income i 
                ON i.transactions_id = t.id
                WHERE t.transaction_type_id = 2	AND i.account_id = a.id		
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
            ) -- transfer IN
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
    final list = await db.rawQuery(
      "SELECT * FROM account WHERE id = ? limit 1",
      [id],
    );
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
      "INSERT INTO account(name, amount, type, created_at, updated_at) VALUES(?, ?, ?, ?, ?)",
      [name, amount, type, TimeUtils.nowString(), TimeUtils.nowString()],
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
      "UPDATE account SET name = ?, amount = ?, type = ?, updated_at = ? WHERE id = ?",
      [name, amount, type, TimeUtils.nowString(), id],
    );
    return count;
  }

  Future<int> deleteAccount({required accountId}) async {
    Database db = await dbHelper.db;

    await db.rawDelete(
      "DELETE FROM transactions WHERE id IN (SELECT transactions_id FROM expense WHERE account_id = ?)",
      [accountId],
    );
    await db.rawDelete(
      "DELETE FROM transactions WHERE id IN (SELECT transactions_id FROM income WHERE account_id = ?)",
      [accountId],
    );
    await db.rawDelete(
      "DELETE FROM transactions WHERE id IN (SELECT transactions_id FROM transfer WHERE account_id_from = ? OR account_id_to = ?)",
      [accountId, accountId],
    );
    await db.rawDelete(
      "DELETE FROM transactions WHERE id IN (SELECT transactions_id FROM debt WHERE account_id_from = ? OR account_id_to = ?)",
      [accountId, accountId],
    );

    await db.rawDelete(
      "DELETE FROM expense WHERE account_id = ?",
      [accountId],
    );
    await db.rawDelete(
      "DELETE FROM income WHERE account_id = ?",
      [accountId],
    );
    await db.rawDelete(
      "DELETE FROM transfer WHERE account_id_from = ? OR account_id_to = ?",
      [accountId, accountId],
    );
    await db.rawDelete(
      "DELETE FROM debt WHERE account_id_from = ? OR account_id_to = ?",
      [accountId, accountId],
    );

    int count = await db.rawDelete(
      "DELETE FROM account WHERE id = ?",
      [accountId],
    );

    return count;
  }
}
