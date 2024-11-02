import 'package:flutter_wallet/data/db.dart';
import 'package:flutter_wallet/utils/time_utils.dart';
import 'package:sqflite/sqflite.dart';

class IncomeDb {
  DBHelper dbHelper = DBHelper();

  Future<int> createIncome({
    required double amount,
    String? note,
    required int accountId,
  }) async {
    Database db = await dbHelper.db;

    final transactionId = await db.rawInsert(
      """
        INSERT INTO transactions(
          amount, 
          note, 
          transaction_type_id, 
          created_at, 
          updated_at
        ) 
        VALUES(?, ?, ?, ?, ?)
      """,
      [
        amount,
        note,
        2,
        TimeUtils.nowString(),
        TimeUtils.nowString(),
      ],
    );

    await db.rawInsert(
      """
        INSERT INTO income(
          transactions_id, 
          account_id, 
          created_at, 
          updated_at
        ) 
        VALUES(?, ?, ?, ?)
      """,
      [
        transactionId,
        accountId,
        TimeUtils.nowString(),
        TimeUtils.nowString(),
      ],
    );
    return transactionId;
  }
}
