import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:securechat_x/data/database/database.dart';
import 'package:securechat_x/data/database/sqlite_database.dart';
import 'package:securechat_x/data/repositories/identity_state_repository.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  test(
    'user and device repositories persist only metadata/public keys',
    () async {
      final SqliteDatabase database = SqliteDatabase(
        databaseName: inMemoryDatabasePath,
        databaseFactory: databaseFactoryFfi,
      );
      addTearDown(database.close);
      await database.migrate();

      final userRepository = LocalUserRepository(database);
      final deviceRepository = LocalDeviceRepository(database);

      const UserRecord user = UserRecord(
        id: 'user-1',
        displayName: 'Alice',
        identityPublicKey: <int>[1, 2, 3],
        createdAt: 10,
        updatedAt: 10,
      );
      await userRepository.upsert(user);

      const DeviceRecord first = DeviceRecord(
        id: 'device-1',
        userId: 'user-1',
        label: 'Phone',
        devicePublicKey: <int>[4, 5],
        status: 'active',
        createdAt: 20,
        updatedAt: 20,
        lastSeenAt: 20,
      );
      const DeviceRecord second = DeviceRecord(
        id: 'device-2',
        userId: 'user-1',
        label: 'Tablet',
        devicePublicKey: <int>[6, 7],
        status: 'active',
        createdAt: 30,
        updatedAt: 30,
        lastSeenAt: 30,
      );
      await deviceRepository.upsert(first);
      await deviceRepository.upsert(second);

      expect((await userRepository.findById('user-1'))?.displayName, 'Alice');
      expect(
        (await deviceRepository.findById('device-1'))?.devicePublicKey,
        <int>[4, 5],
      );

      final Page<DeviceRecord> firstPage = await deviceRepository.listForUser(
        'user-1',
        const PageRequest(limit: 1),
      );
      expect(firstPage.items.single.id, 'device-2');
      expect(firstPage.nextCursor, isNotNull);

      final Page<DeviceRecord> secondPage = await deviceRepository.listForUser(
        'user-1',
        PageRequest(limit: 1, cursor: firstPage.nextCursor),
      );
      expect(secondPage.items.single.id, 'device-1');
      expect(secondPage.nextCursor, isNull);

      await deviceRepository.revoke('device-2', 40);
      expect((await deviceRepository.findById('device-2'))?.status, 'revoked');

      final rows = await database.query(
        'devices',
        columns: <String>['device_public_key'],
        where: 'id = ?',
        whereArgs: <Object?>['device-2'],
        limit: 1,
      );
      expect(rows.single['device_public_key'], <int>[6, 7]);
      expect(rows.single, isNot(contains('private_key')));
    },
  );
}
