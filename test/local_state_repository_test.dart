import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:securechat_x/data/database/sqlite_database.dart';
import 'package:securechat_x/data/repositories/local_state_repository.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  test('draft repository writes, reads and deletes encrypted blobs', () async {
    final SqliteDatabase database = SqliteDatabase(
      databaseName: inMemoryDatabasePath,
      databaseFactory: databaseFactoryFfi,
    );
    addTearDown(database.close);
    await database.migrate();

    final DraftRepository repository = DraftRepository(database);
    const DraftRecord draft = DraftRecord(
      id: 'draft-1',
      conversationId: 'conversation-1',
      textCiphertext: <int>[1, 2, 3, 4],
      updatedAt: 100,
    );

    await database.insert('conversations', <String, Object?>{
      'id': 'conversation-1',
      'kind': 'direct',
      'created_at': 1,
      'updated_at': 1,
    });

    await repository.save(draft);
    final DraftRecord? stored = await repository.findByConversation(
      'conversation-1',
    );

    expect(stored?.id, 'draft-1');
    expect(stored?.textCiphertext, <int>[1, 2, 3, 4]);

    await repository.delete('draft-1');
    expect(await repository.findByConversation('conversation-1'), isNull);
  });

  test(
    'encrypted settings repository upserts without exposing plaintext',
    () async {
      final SqliteDatabase database = SqliteDatabase(
        databaseName: inMemoryDatabasePath,
        databaseFactory: databaseFactoryFfi,
      );
      addTearDown(database.close);
      await database.migrate();

      final EncryptedSettingsRepository repository =
          EncryptedSettingsRepository(database);

      expect(await repository.read('notifications.preview'), isNull);

      await repository.write('notifications.preview', <int>[9, 8, 7], 10);
      expect(await repository.read('notifications.preview'), <int>[9, 8, 7]);

      await repository.write('notifications.preview', <int>[6, 5], 20);
      expect(await repository.read('notifications.preview'), <int>[6, 5]);

      await repository.delete('notifications.preview');
      expect(await repository.read('notifications.preview'), isNull);
    },
  );
}
