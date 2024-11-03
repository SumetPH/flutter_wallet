import 'package:flutter_wallet/data/db.dart';
import 'package:flutter_wallet/utils/time_utils.dart';
import 'package:postgres/postgres.dart';

class IncomeService {
  final _db = DBHelper();

  Future<int> createIncome({
    required double amount,
    String? note,
    required int accountId,
    required int categoryId,
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
                category_id,
                created_at,
                updated_at
              )
              VALUES(
                @amount, 
                @note, 
                @transactionTypeId, 
                @categoryId,
                @createdAt, 
                @updatedAt
              )
              RETURNING id
            """,
          ),
          parameters: {
            'amount': amount,
            'note': note,
            'transactionTypeId': 2,
            'categoryId': categoryId,
            'createdAt': TimeUtils.nowString(),
            'updatedAt': TimeUtils.nowString(),
          });

      await conn.execute(
          Sql.named(
            """
            INSERT INTO income(
              transaction_id,
              account_id,
              created_at,
              updated_at
            )
            VALUES(@transactionsId, @accountId, @createdAt, @updatedAt)
          """,
          ),
          parameters: {
            'transactionsId': result.first[0],
            'accountId': accountId,
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
