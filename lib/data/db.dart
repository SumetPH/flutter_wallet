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
    print(path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {},
      onOpen: (db) async {
        // drop all table
        // await db.execute("DROP TABLE IF EXISTS transactions");
        // await db.execute("DROP TABLE IF EXISTS category");
        // await db.execute("DROP TABLE IF EXISTS account");
        // await db.execute("DROP TABLE IF EXISTS transfer");
        // await db.execute("DROP TABLE IF EXISTS debt");

        // create table
        await db.execute(
          """
            CREATE TABLE IF NOT EXISTS account(
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              name TEXT, 
              amount REAL,
              type INTEGER,
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
          """,
        );

        await db.execute(
          """
            CREATE TABLE IF NOT EXISTS category(
              id INTEGER PRIMARY KEY AUTOINCREMENT,  
              name Text,
              type INTEGER,
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
          """,
        );

        // await db.insert('category', {
        //   'id': 1,
        //   'name': 'อาหาร',
        //   'type': 1,
        // });
        // await db.insert('category', {
        //   'id': 2,
        //   'name': 'ใช้จ่าย',
        //   'type': 1,
        // });
        // await db.insert('category', {
        //   'id': 3,
        //   'name': 'เงินเดือน',
        //   'type': 2,
        // });
        // await db.insert('category', {
        //   'id': 4,
        //   'name': 'ใช้คืน',
        //   'type': 2,
        // });

        await db.execute(
          """
            CREATE TABLE IF NOT EXISTS transactions(
              id INTEGER PRIMARY KEY AUTOINCREMENT,  
              amount REAL,
              note TEXT,
              transaction_type_id INTEGER,
              category_id INTEGER,
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
          """,
        );

        await db.execute(
          """
            CREATE TABLE IF NOT EXISTS expense(
              id INTEGER PRIMARY KEY AUTOINCREMENT,  
              transactions_id INTEGER DEFAULT 1,
              account_id INTEGER,
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
          """,
        );

        await db.execute(
          """
            CREATE TABLE IF NOT EXISTS income(
              id INTEGER PRIMARY KEY AUTOINCREMENT,  
              transactions_id INTEGER DEFAULT 2,
              account_id INTEGER,
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
          """,
        );

        await db.execute(
          """
            CREATE TABLE IF NOT EXISTS transfer(
              id INTEGER PRIMARY KEY AUTOINCREMENT,  
              transactions_id INTEGER DEFAULT 3,
              account_id_from INTEGER,
              account_id_to INTEGER,
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
          """,
        );

        await db.execute(
          """
            CREATE TABLE IF NOT EXISTS debt(
              id INTEGER PRIMARY KEY AUTOINCREMENT,  
              transactions_id INTEGER DEFAULT 4,
              account_id_from INTEGER,
              account_id_to INTEGER,
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
          """,
        );
      },
    );
  }
}
