import 'package:flutter_wallet/db/db.dart';
import 'package:sqflite/sqflite.dart';

class TransactionsDb {
  DBHelper dbHelper = DBHelper();

  Future<int> createTransaction({
    required double amount,
    String? note,
    required int transactionTypeId,
    required int accountId,
  }) async {
    Database db = await dbHelper.db;
    final id = await db.rawInsert(
      "INSERT INTO transactions(amount, note, transaction_type_id, account_id) VALUES(?, ?, ?, ?)",
      [amount, note, transactionTypeId, accountId],
    );
    return id;
  }
}
