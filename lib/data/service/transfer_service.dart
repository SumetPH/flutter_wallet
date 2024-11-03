import 'package:flutter_wallet/data/db.dart';
import 'package:flutter_wallet/utils/time_utils.dart';
import 'package:postgres/postgres.dart';

class TransferDb {
  final _db = DBHelper();

  Future<int> createTransfer({
    required double amount,
    String? note,
    required int accountIdFrom,
    required int accountIdTo,
  }) async {
    try {
      final conn = await _db.connection();

      final result = await conn.execute(
          Sql.named(
            """
              INSERT INTO transaction(
                amount,
                note,
                transaction_type_id,
                created_at,
                updated_at
              )
              VALUES(@amount, @note, @transactionTypeId, @createdAt, @updatedAt)
              RETURNING id
            """,
          ),
          parameters: {
            'amount': amount,
            'note': note,
            'transactionTypeId': 3,
            'createdAt': TimeUtils.nowString(),
            'updatedAt': TimeUtils.nowString(),
          });

      await conn.execute(
          Sql.named(
            """
              INSERT INTO transfer(
                transaction_id,
                account_id_from,
                account_id_to,
                created_at,
                updated_at
              )
              VALUES(@transactionsId, @accountIdFrom, @accountIdTo, @createdAt, @updatedAt)
          """,
          ),
          parameters: {
            'transactionsId': result.first[0],
            'accountIdFrom': accountIdFrom,
            'accountIdTo': accountIdTo,
            'createdAt': TimeUtils.nowString(),
            'updatedAt': TimeUtils.nowString(),
          });
      return result.affectedRows;
    } catch (e) {
      throw Exception(e);
    } finally {
      await _db.close();
    }
  }
}
