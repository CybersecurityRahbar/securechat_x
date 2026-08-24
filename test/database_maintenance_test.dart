import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:securechat_x/data/database/database_maintenance.dart';
import 'package:securechat_x/data/database/sqlite_database.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  test('integrity inspection reports a healthy fresh schema', () async {
    final SqliteDatabase database = SqliteDatabase(
      databaseName: inMemoryDatabasePath,
      databaseFactory: databaseFactoryFfi,
    );
    addTearDown(database.close);
    await database.migrate();

    final report = await const SqliteDatabaseMaintenance(database).inspect();

    expect(report.isHealthy, isTrue);
    expect(report.missingTables, isEmpty);
    expect(report.missingIndexes, isEmpty);
    expect(report.foreignKeyViolations, isEmpty);
  });

  test('cleanup is bounded and deletes only expired security events', () async {
    final SqliteDatabase database = SqliteDatabase(
      databaseName: inMemoryDatabasePath,
      databaseFactory: databaseFactoryFfi,
    );
    addTearDown(database.close);
    await database.migrate();

    await database.insert('security_events', <String, Object?>{
      'id': 'old-1',
      'event_type': 'test',
      'severity': 'info',
      'created_at': 10,
    });
    await database.insert('security_events', <String, Object?>{
      'id': 'old-2',
      'event_type': 'test',
      'severity': 'warning',
      'created_at': 20,
    });
    await database.insert('security_events', <String, Object?>{
      'id': 'new-1',
      'event_type': 'test',
      'severity': 'info',
      'created_at': 95,
    });

    final result = await const SqliteDatabaseMaintenance(database).cleanup(
      const CleanupPolicy(
        securityEventRetention: Duration(milliseconds: 50),
        maxRowsPerRun: 1,
      ),
      now: DateTime.fromMillisecondsSinceEpoch(100, isUtc: true),
    );

    expect(result.securityEventsDeleted, 1);
    expect(
      (await database.query(
        'security_events',
        orderBy: 'created_at ASC',
      )).map((row) => row['id']),
      <Object?>['old-2', 'new-1'],
    );
  });
}
