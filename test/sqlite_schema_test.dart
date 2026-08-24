import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:securechat_x/data/database/database.dart';
import 'package:securechat_x/data/database/sqlite_schema.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  test('phase 3 schema creates all required relational tables and indexes', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    addTearDown(db.close);

    await db.execute('PRAGMA foreign_keys = ON');
    await SecureChatSqliteSchema.create(_TestExecutor(db));

    final List<Map<String, Object?>> tables = await db.rawQuery('''
      SELECT name
      FROM sqlite_master
      WHERE type = 'table' AND name NOT LIKE 'sqlite_%'
      ORDER BY name
    ''');

    final Set<String> tableNames = tables
        .map((Map<String, Object?> row) => row['name']! as String)
        .toSet();

    expect(
      tableNames,
      containsAll(<String>[
        'users',
        'devices',
        'contacts',
        'conversations',
        'conversation_members',
        'messages',
        'message_recipients',
        'attachments',
        'attachment_chunks',
        'sessions',
        'prekeys',
        'groups',
        'group_members',
        'community_state',
        'calls',
        'call_events',
        'delivery_receipts',
        'read_receipts',
        'drafts',
        'app_settings',
        'security_events',
      ]),
    );

    final List<Map<String, Object?>> indexes = await db.rawQuery('''
      SELECT name
      FROM sqlite_master
      WHERE type = 'index' AND name LIKE 'idx_%'
    ''');

    expect(indexes.length, SecureChatSqliteSchema.createIndexes.length);
  });

  test('foreign keys prevent orphaned members and cascade dependent rows', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    addTearDown(db.close);

    await db.execute('PRAGMA foreign_keys = ON');
    await SecureChatSqliteSchema.create(_TestExecutor(db));

    await db.insert('users', <String, Object?>{
      'id': 'user-1',
      'display_name': 'Test User',
      'created_at': 1,
      'updated_at': 1,
    });
    await db.insert('devices', <String, Object?>{
      'id': 'device-1',
      'user_id': 'user-1',
      'label': 'Test Device',
      'status': 'active',
      'created_at': 1,
      'updated_at': 1,
    });

    await db.delete('users', where: 'id = ?', whereArgs: <Object?>['user-1']);

    expect(await db.query('devices'), isEmpty);
  });

  test('transaction rollback preserves atomicity', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    addTearDown(db.close);

    await db.execute('PRAGMA foreign_keys = ON');
    await SecureChatSqliteSchema.create(_TestExecutor(db));

    await expectLater(
      db.transaction<void>((txn) async {
        await txn.insert('users', <String, Object?>{
          'id': 'rollback-user',
          'display_name': 'Rollback',
          'created_at': 1,
          'updated_at': 1,
        });
        throw StateError('force rollback');
      }),
      throwsStateError,
    );

    expect(await db.query('users'), isEmpty);
  });

  test('pagination contract rejects unbounded limits', () {
    expect(() => PageRequest(limit: 0), throwsAssertionError);
    expect(() => PageRequest(limit: 201), throwsAssertionError);
    expect(PageRequest(limit: 200).limit, 200);
  });
}

final class _TestExecutor implements DatabaseExecutorLike {
  const _TestExecutor(this.database);

  final dynamic database;

  @override
  Future<void> execute(String sql, [List<Object?>? arguments]) =>
      database.execute(sql, arguments);
}
