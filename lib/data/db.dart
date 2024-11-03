import 'package:postgres/postgres.dart';

class DBHelper {
  Connection? _conn;

  Future<Connection> connection() async {
    if (_conn == null) {
      print('connect postgresql');
      return await _connectToPostgresql();
    } else {
      return _conn!;
    }
  }

  Future<void> close() async {
    if (_conn != null) {
      print('close postgresql');
      await _conn!.close();
    }
  }

  Future<Connection> _connectToPostgresql() async {
    final conn = await Connection.open(
      Endpoint(
        // host: '',
        host: '127.0.0.1',
        database: 'flutter_wallet',
        port: 5432,
        username: 'sumetph',
        password: 'sumet',
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );

    await conn.execute(
      """
      CREATE TABLE IF NOT EXISTS account(
        id SERIAL PRIMARY KEY, 
        name TEXT, 
        amount NUMERIC(10, 2),
        account_type_id INTEGER,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
      """,
    );

    await conn.execute(
      """
      CREATE TABLE IF NOT EXISTS account_type(
        id SERIAL PRIMARY KEY, 
        name TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
      """,
    );

    await conn.execute(
      """
        INSERT INTO 
          account_type(id, name) 
        VALUES
          (1, 'เงินสด'),
          (2, 'ธนาคาร'),
          (3, 'บัตรเครดิต'),
          (4, 'หนี้สิน')
        ON CONFLICT DO NOTHING
      """,
    );

    await conn.execute(
      """
        CREATE TABLE IF NOT EXISTS category(
          id SERIAL PRIMARY KEY,  
          name Text,
          category_type_id INTEGER,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      """,
    );

    await conn.execute(
      """
        INSERT INTO 
          category(id, name, category_type_id) 
        VALUES
          (1, 'อาหาร', 1),
          (2, 'ใช้จ่าย', 1),
          (3, 'เงินเดือน', 2),
          (4, 'ใช้คืน', 2)
        ON CONFLICT DO NOTHING
      """,
    );

    await conn.execute(
      """
      CREATE TABLE IF NOT EXISTS category_type(
        id SERIAL PRIMARY KEY, 
        name TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
      """,
    );

    await conn.execute(
      """
        INSERT INTO 
          category_type(id, name) 
        VALUES
          (1, 'รายรับ'),
          (2, 'รายจ่าย')
        ON CONFLICT DO NOTHING
      """,
    );

    await conn.execute(
      """
          CREATE TABLE IF NOT EXISTS transaction(
            id SERIAL PRIMARY KEY,  
            amount NUMERIC(10, 2),
            note TEXT,
            transaction_type_id INTEGER,
            category_id INTEGER,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        """,
    );

    await conn.execute(
      """
          CREATE TABLE IF NOT EXISTS transaction_type(
            id SERIAL PRIMARY KEY,  
            name TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        """,
    );

    await conn.execute(
      """
        INSERT INTO 
          transaction_type(id, name) 
        VALUES
          (1, 'รายจ่าย'),
          (2, 'รายรับ'),
          (3, 'โอน'),
          (4, 'ชำระหนี้')
        ON CONFLICT DO NOTHING
      """,
    );

    await conn.execute(
      """
        CREATE TABLE IF NOT EXISTS expense(
          id SERIAL PRIMARY KEY,  
          transaction_id INTEGER DEFAULT 1,
          account_id INTEGER,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      """,
    );

    await conn.execute(
      """
        CREATE TABLE IF NOT EXISTS income(
          id SERIAL PRIMARY KEY,  
          transaction_id INTEGER DEFAULT 2,
          account_id INTEGER,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      """,
    );

    await conn.execute(
      """
        CREATE TABLE IF NOT EXISTS transfer(
          id SERIAL PRIMARY KEY,  
          transaction_id INTEGER DEFAULT 3,
          account_id_from INTEGER,
          account_id_to INTEGER,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      """,
    );

    await conn.execute(
      """
        CREATE TABLE IF NOT EXISTS debt(
          id SERIAL PRIMARY KEY,  
          transaction_id INTEGER DEFAULT 4,
          account_id_from INTEGER,
          account_id_to INTEGER,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      """,
    );

    return conn;
  }
}
