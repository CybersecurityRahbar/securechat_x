import 'package:sqflite/sqflite.dart' as sqlite;

import 'database.dart';
import 'sqlite_schema.dart';

/// Concrete SQLite implementation used by the application database boundary.
final class SqliteDatabase implements Database {
  SqliteDatabase({
    String databaseName = 'securechat_x.db',
    sqlite.DatabaseFactory? databaseFactory,
  }) : _databaseName = databaseName,
       _databaseFactory = databaseFactory;

  final String _databaseName;
  final sqlite.DatabaseFactory? _databaseFactory;
  sqlite.Database? _database;

  @override
  Future<void> migrate() async {
    await _open();
  }

  Future<sqlite.Database> _open() async {
    final sqlite.Database? existing = _database;
    if (existing != null && existing.isOpen) {
      return existing;
    }

    final sqlite.DatabaseFactory factory =
        _databaseFactory ?? sqlite.databaseFactory;
    final sqlite.Database database = await factory.openDatabase(
      _databaseName,
      options: sqlite.OpenDatabaseOptions(
        version: SecureChatSqliteSchema.version,
        onConfigure: (sqlite.Database db) async {
          await db.execute('PRAGMA foreign_keys = ON');
          await db.execute('PRAGMA secure_delete = ON');
          await db.execute('PRAGMA busy_timeout = 5000');
        },
        onCreate: (sqlite.Database db, int version) async {
          await _createSchema(db, version);
        },
        onUpgrade: (sqlite.Database db, int oldVersion, int newVersion) async {
          await _upgradeSchema(db, oldVersion, newVersion);
        },
      ),
    );

    _database = database;
    return database;
  }

  static Future<void> _createSchema(sqlite.Database db, int version) async {
    if (version >= 1) {
      await SecureChatSqliteSchema.create(_Executor(db));
    }
  }

  static Future<void> _upgradeSchema(
    sqlite.Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 1 && newVersion >= 1) {
      await SecureChatSqliteSchema.create(_Executor(db));
    }
  }

  @override
  Future<T> transaction<T>(
    Future<T> Function(DatabaseTransaction tx) action,
  ) async {
    final sqlite.Database db = await _open();
    return db.transaction<T>((sqlite.Transaction txn) async {
      return action(_TransactionExecutor(txn));
    });
  }

  @override
  Future<List<Map<String, Object?>>> query(
    String table, {
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    _validatePageBounds(limit, offset);
    final sqlite.Database db = await _open();
    return db.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<List<Map<String, Object?>>> rawQuery(
    String sql,
    [List<Object?>? arguments]
  ) async {
    final sqlite.Database db = await _open();
    return db.rawQuery(sql, arguments);
  }

  @override
  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
  }) async {
    final sqlite.Database db = await _open();
    return db.insert(table, values, nullColumnHack: nullColumnHack);
  }

  @override
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final sqlite.Database db = await _open();
    return db.update(table, values, where: where, whereArgs: whereArgs);
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final sqlite.Database db = await _open();
    return db.delete(table, where: where, whereArgs: whereArgs);
  }

  static void _validatePageBounds(int? limit, int? offset) {
    if (limit != null && (limit <= 0 || limit > 200)) {
      throw ArgumentError.value(limit, 'limit', 'must be between 1 and 200');
    }
    if (offset != null && offset < 0) {
      throw ArgumentError.value(offset, 'offset', 'must not be negative');
    }
  }

  Future<void> close() async {
    final sqlite.Database? db = _database;
    _database = null;
    if (db != null && db.isOpen) {
      await db.close();
    }
  }
}

final class _Executor implements DatabaseExecutorLike {
  const _Executor(this._executor);

  final sqlite.DatabaseExecutor _executor;

  @override
  Future<void> execute(String sql, [List<Object?>? arguments]) =>
      _executor.execute(sql, arguments);
}

final class _TransactionExecutor implements DatabaseTransaction {
  const _TransactionExecutor(this._transaction);

  final sqlite.Transaction _transaction;

  @override
  Future<List<Map<String, Object?>>> query(
    String table, {
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) {
    _validatePageBounds(limit, offset);
    return _transaction.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
  }) => _transaction.insert(table, values, nullColumnHack: nullColumnHack);

  @override
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  }) => _transaction.update(table, values, where: where, whereArgs: whereArgs);

  @override
  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) =>
      _transaction.delete(table, where: where, whereArgs: whereArgs);

  static void _validatePageBounds(int? limit, int? offset) {
    if (limit != null && (limit <= 0 || limit > 200)) {
      throw ArgumentError.value(limit, 'limit', 'must be between 1 and 200');
    }
    if (offset != null && offset < 0) {
      throw ArgumentError.value(offset, 'offset', 'must not be negative');
    }
  }
}
