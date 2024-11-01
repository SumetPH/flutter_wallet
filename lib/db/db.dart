import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDatabase();
    return _db!;
  }

  initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'app.db');
    print('sqlite path: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          """
            CREATE TABLE account(
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              name TEXT, 
              amount REAL,
              type INTEGER
            )
          """,
        );

        await db.execute(
          """
            CREATE TABLE IF NOT EXISTS category(
              id INTEGER PRIMARY KEY AUTOINCREMENT,  
              name Text,
              type INTEGER
            )
          """,
        );

        await db.insert('category', {
          'id': 1,
          'name': 'อาหาร',
          'type': 1,
        });
        await db.insert('category', {
          'id': 2,
          'name': 'ใช้จ่าย',
          'type': 1,
        });
        await db.insert('category', {
          'id': 3,
          'name': 'เงินเดือน',
          'type': 2,
        });
        await db.insert('category', {
          'id': 4,
          'name': 'ใช้คืน',
          'type': 2,
        });

        await db.execute(
          """
            CREATE TABLE IF NOT EXISTS transactions(
              id INTEGER PRIMARY KEY AUTOINCREMENT,  
              amount REAL,
              note TEXT,
              transaction_type_id INTEGER,
              account_id INTEGER,
              category_id INTEGER
            )
          """,
        );
      },
      onOpen: (db) async {},
    );
  }
}
