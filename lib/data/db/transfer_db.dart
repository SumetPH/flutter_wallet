import 'package:flutter_wallet/data/db.dart';
import 'package:flutter_wallet/utils/time_utils.dart';
import 'package:sqflite/sqflite.dart';

class TransferDb {
  DBHelper dbHelper = DBHelper();

  Future<int> createTransfer({
    required double amount,
    String? note,
    required int accountIdFrom,
    required int accountIdTo,
  }) async {
    Database db = await dbHelper.db;
    final idTransaction = await db.rawInsert(
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
        3,
        TimeUtils.nowString(),
        TimeUtils.nowString(),
      ],
    );

    final idTransfer = await db.rawInsert(
      """
        INSERT INTO transfer(
          transactions_id,
          account_id_from,
          account_id_to,
          created_at,
          updated_at
        ) 
        VALUES(?, ?, ?, ?, ?)
      """,
      [
        idTransaction,
        accountIdFrom,
        accountIdTo,
        TimeUtils.nowString(),
        TimeUtils.nowString(),
      ],
    );
    return idTransfer;
  }
}
