// import 'package:flutter_wallet/data/db.dart';
// import 'package:flutter_wallet/model/account_model.dart';
// import 'package:flutter_wallet/utils/time_utils.dart';
// import 'package:postgres/postgres.dart';

// class AccountService {
//   final _db = DBHelper();

//   Future<List<AccountModel>> getAccountList({String? type}) async {
//     try {
//       final conn = await _db.connection();
//       final result = await conn.execute(
//         """
//           SELECT 
//             a.id,
//             a.name,
//             a.amount,
//             a.account_type_id,
//             at.name AS account_type_name,
//             (
//               a.amount -- initial
//               -
//               COALESCE (
//                 (
//                   SELECT SUM(t.amount) 
//                   FROM transaction t 
//                   LEFT JOIN expense e 
//                   ON e.transaction_id = t.id
//                   WHERE t.transaction_type_id = 1 AND e.account_id = a.id
//                 ),0
//               ) -- expense
//               +
//               COALESCE (
//                 (
//                   SELECT SUM(t.amount) 
//                   FROM transaction t 
//                     LEFT JOIN income i 
//                   ON i.transaction_id = t.id
//                   WHERE t.transaction_type_id = 2	AND i.account_id = a.id		
//                 ),0
//               ) -- income
//               -
//               COALESCE (
//                 (
//                   SELECT SUM(t.amount) 
//                   FROM transaction t 
//                   LEFT JOIN transfer tf
//                   ON tf.transaction_id = t.id
//                   WHERE t.transaction_type_id = 3 AND tf.account_id_from = a.id 
//                 ),0
//               ) -- transfer out
//               +
//               COALESCE (
//                 (
//                   SELECT SUM(t.amount) 
//                   FROM transaction t 
//                   LEFT JOIN transfer tf
//                   ON tf.transaction_id = t.id
//                   WHERE t.transaction_type_id = 3 AND tf.account_id_to = a.id 
//                 ),0
//               ) -- transfer IN
//               -
//               COALESCE (
//                 (
//                   SELECT SUM(t.amount) 
//                   FROM transaction t 
//                   LEFT JOIN debt d
//                   ON d.transaction_id = t.id
//                   WHERE t.transaction_type_id = 4 AND d.account_id_from = a.id 
//                 ),0
//               ) -- debt out
//               +
//               COALESCE (
//                 (
//                   SELECT SUM(t.amount) 
//                   FROM transaction t 
//                   LEFT JOIN debt d
//                   ON d.transaction_id = t.id
//                   WHERE t.transaction_type_id = 4 AND d.account_id_to = a.id 
//                 ),0
//               ) -- debt in
//             ) AS balance
//           FROM account a
//           LEFT JOIN account_type at ON at.id = a.account_type_id
//           ${type != null ? 'WHERE account_type_id IN ($type)' : ''}
//           ORDER BY a.name
//         """,
//       );

//       List<AccountModel> accountList = result
//           .map(
//             (row) => AccountModel.fromMap(row.toColumnMap()),
//           )
//           .toList();
//       return accountList;
//     } catch (e) {
//       throw Exception(e);
//     } finally {
//       await _db.close();
//     }
//   }

//   Future<AccountModel> getAccountDetail({required id}) async {
//     try {
//       final conn = await _db.connection();
//       final result = await conn.execute(
//         Sql.named('SELECT * FROM account WHERE id=@id limit 1'),
//         parameters: {'id': id},
//       );

//       List<AccountModel> accountList =
//           result.map((row) => AccountModel.fromMap(row.toColumnMap())).toList();
//       return accountList.first;
//     } catch (e) {
//       throw Exception(e);
//     } finally {
//       await _db.close();
//     }
//   }

//   Future<int> createAccount({
//     required name,
//     required amount,
//     required accountTypeId,
//   }) async {
//     try {
//       final conn = await _db.connection();
//       final result = await conn.execute(
//         Sql.named(
//           """
//             INSERT INTO account(name, amount, account_type_id, created_at, updated_at)
//             VALUES(@name, @amount, @accountTypeId, @createdAt, @updatedAt)
//           """,
//         ),
//         parameters: {
//           'name': name,
//           'amount': amount,
//           'accountTypeId': accountTypeId,
//           'createdAt': TimeUtils.nowString(),
//           'updatedAt': TimeUtils.nowString(),
//         },
//       );
//       return result.affectedRows;
//     } catch (e) {
//       throw Exception(e);
//     } finally {
//       await _db.close();
//     }
//   }

//   Future<int> updateAccount({
//     required id,
//     required name,
//     required amount,
//     required accountTypeId,
//   }) async {
//     try {
//       final conn = await _db.connection();
//       final result = await conn.execute(
//           Sql.named(
//             "UPDATE account SET name=@name, amount=@amount, account_type_id=@accountTypeId, updated_at=@updatedAt WHERE id=@id",
//           ),
//           parameters: {
//             'name': name,
//             'amount': amount,
//             'accountTypeId': accountTypeId,
//             'updatedAt': TimeUtils.nowString(),
//             'id': id
//           });
//       return result.affectedRows;
//     } catch (e) {
//       throw Exception(e);
//     } finally {
//       await _db.close();
//     }
//   }

//   Future<dynamic> deleteAccount({required accountId}) async {
//     try {
//       final conn = await _db.connection();

//       final result = await conn.runTx((s) async {
//         await s.execute(
//           Sql.named(
//             "DELETE FROM transaction WHERE id IN (SELECT transaction_id FROM expense WHERE account_id = @accountId)",
//           ),
//           parameters: {'accountId': accountId},
//         );
//         await s.execute(
//           Sql.named(
//             "DELETE FROM transaction WHERE id IN (SELECT transaction_id FROM income WHERE account_id = @accountId)",
//           ),
//           parameters: {'accountId': accountId},
//         );
//         await s.execute(
//           Sql.named(
//             "DELETE FROM transaction WHERE id IN (SELECT transaction_id FROM transfer WHERE account_id_from = @accountId OR account_id_to = @accountId)",
//           ),
//           parameters: {'accountId': accountId},
//         );
//         await s.execute(
//           Sql.named(
//             "DELETE FROM transaction WHERE id IN (SELECT transaction_id FROM debt WHERE account_id_from = @accountId OR account_id_to = @accountId)",
//           ),
//           parameters: {'accountId': accountId},
//         );

//         await s.execute(
//           Sql.named(
//             "DELETE FROM expense WHERE account_id = @accountId",
//           ),
//           parameters: {'accountId': accountId},
//         );
//         await s.execute(
//           Sql.named(
//             "DELETE FROM income WHERE account_id = @accountId",
//           ),
//           parameters: {'accountId': accountId},
//         );
//         await s.execute(
//           Sql.named(
//             "DELETE FROM transfer WHERE account_id_from = @accountId OR account_id_to = @accountId",
//           ),
//           parameters: {'accountId': accountId},
//         );
//         await s.execute(
//           Sql.named(
//             "DELETE FROM debt WHERE account_id_from = @accountId OR account_id_to = @accountId",
//           ),
//           parameters: {'accountId': accountId},
//         );

//         await s.execute(
//           Sql.named(
//             "DELETE FROM account WHERE id = @accountId",
//           ),
//           parameters: {'accountId': accountId},
//         );
//       });

//       return result;
//     } catch (e) {
//       throw Exception(e);
//     } finally {
//       await _db.close();
//     }
//   }
// }
