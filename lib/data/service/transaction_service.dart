import 'package:flutter_wallet/data/db.dart';
import 'package:flutter_wallet/model/transaction_model.dart';
import 'package:postgres/postgres.dart';

class TransactionService {
  final _db = DBHelper();

  Future<List<TransactionModel>> getTransactionList({
    int? accountId,
  }) async {
    try {
      final conn = await _db.connection();

      final Map<String, dynamic> parameters = {};
      if (accountId != null) {
        parameters['accountId'] = accountId;
      }

      final result = await conn.execute(
        Sql.named(
          """
            select 
            t.id as id,
            t.amount as amount,
            t.transaction_type_id as transaction_type_id,
            tt.name as transaction_type_name,
            t.category_id as category_id,
            c.name as category_name,
            ae.name as account_expense_name,
            ai.name as account_income_name,
            atff.name as account_transfer_from_name,
            atft.name as account_transfer_to_name,
            to_char(t.updated_at, 'YYYY-MM-DD') as date,
            to_char(t.updated_at, 'HH:mm:ss') as time 
          from 
            "transaction" t
          left join transaction_type tt
            on tt.id = t.transaction_type_id 
          left join category c 
            on c.id = t.category_id 
          left join expense e
            on e.transaction_id = t.id
          left join account ae
            on ae.id = e.account_id 
          left join income i
            on i.transaction_id =t.id 
          left join account ai
            on ai.id = i.account_id 
          left join transfer tf
            on tf.transaction_id = t.id
          left join account atff
            on atff.id = tf.account_id_from
          left join account atft
            on atft.id = tf.account_id_to
          ${accountId != null ? ' where ae.id = @accountId or ai.id = @accountId or atff.id = @accountId or atft.id = @accountId' : ''}
          order by t.updated_at desc
          """,
        ),
        parameters: parameters.isNotEmpty ? parameters : null,
      );

      List<TransactionModel> transactionList = result
          .map((row) => TransactionModel.fromMap(row.toColumnMap()))
          .toList();

      return transactionList;
    } catch (e) {
      throw Exception(e);
    } finally {
      await _db.close();
    }
  }
}
