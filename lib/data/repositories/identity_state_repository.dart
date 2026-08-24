import 'dart:convert';
import 'dart:typed_data';

import '../database/database.dart';

/// Non-secret local identity metadata. Private key material never crosses this repository.
final class UserRecord {
  const UserRecord({
    required this.id,
    required this.displayName,
    required this.identityPublicKey,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String displayName;
  final List<int>? identityPublicKey;
  final int createdAt;
  final int updatedAt;

  factory UserRecord.fromRow(Map<String, Object?> row) => UserRecord(
    id: row['id']! as String,
    displayName: row['display_name']! as String,
    identityPublicKey: _bytes(row['identity_public_key']),
    createdAt: row['created_at']! as int,
    updatedAt: row['updated_at']! as int,
  );

  Map<String, Object?> toValues() => <String, Object?>{
    'id': id,
    'display_name': displayName,
    'identity_public_key': _blob(identityPublicKey),
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

final class DeviceRecord {
  const DeviceRecord({
    required this.id,
    required this.userId,
    required this.label,
    required this.devicePublicKey,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.lastSeenAt,
  });

  final String id;
  final String userId;
  final String label;
  final List<int>? devicePublicKey;
  final String status;
  final int createdAt;
  final int updatedAt;
  final int? lastSeenAt;

  factory DeviceRecord.fromRow(Map<String, Object?> row) => DeviceRecord(
    id: row['id']! as String,
    userId: row['user_id']! as String,
    label: row['label']! as String,
    devicePublicKey: _bytes(row['device_public_key']),
    status: row['status']! as String,
    createdAt: row['created_at']! as int,
    updatedAt: row['updated_at']! as int,
    lastSeenAt: row['last_seen_at'] as int?,
  );

  Map<String, Object?> toValues() => <String, Object?>{
    'id': id,
    'user_id': userId,
    'label': label,
    'device_public_key': _blob(devicePublicKey),
    'status': status,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'last_seen_at': lastSeenAt,
  };
}

final class LocalUserRepository {
  const LocalUserRepository(this._database);

  final Database _database;

  Future<UserRecord?> findById(String id) async {
    final rows = await _database.query(
      'users',
      where: 'id = ?',
      whereArgs: <Object?>[id],
      limit: 1,
    );
    return rows.isEmpty ? null : UserRecord.fromRow(rows.single);
  }

  Future<void> upsert(UserRecord record) async {
    await _database.transaction<void>((tx) async {
      final updated = await tx.update(
        'users',
        record.toValues(),
        where: 'id = ?',
        whereArgs: <Object?>[record.id],
      );
      if (updated == 0) {
        await tx.insert('users', record.toValues());
      }
    });
  }
}

final class LocalDeviceRepository {
  const LocalDeviceRepository(this._database);

  final Database _database;

  Future<DeviceRecord?> findById(String id) async {
    final rows = await _database.query(
      'devices',
      where: 'id = ?',
      whereArgs: <Object?>[id],
      limit: 1,
    );
    return rows.isEmpty ? null : DeviceRecord.fromRow(rows.single);
  }

  Future<Page<DeviceRecord>> listForUser(
    String userId,
    PageRequest request,
  ) async {
    final cursor = _decodeCursor(request.cursor);
    final where = cursor == null
        ? 'user_id = ?'
        : 'user_id = ? AND (created_at < ? OR (created_at = ? AND id < ?))';
    final whereArgs = cursor == null
        ? <Object?>[userId]
        : <Object?>[userId, cursor.createdAt, cursor.createdAt, cursor.id];

    final rows = await _database.query(
      'devices',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'created_at DESC, id DESC',
      limit: request.limit + 1,
    );
    final hasMore = rows.length > request.limit;
    final visible = hasMore ? rows.take(request.limit).toList() : rows;
    final nextCursor = hasMore && visible.isNotEmpty
        ? _encodeCursor(
            visible.last['created_at']! as int,
            visible.last['id']! as String,
          )
        : null;

    return Page<DeviceRecord>(
      items: visible.map(DeviceRecord.fromRow).toList(growable: false),
      nextCursor: nextCursor,
    );
  }

  Future<void> upsert(DeviceRecord record) async {
    await _database.transaction<void>((tx) async {
      final updated = await tx.update(
        'devices',
        record.toValues(),
        where: 'id = ?',
        whereArgs: <Object?>[record.id],
      );
      if (updated == 0) {
        await tx.insert('devices', record.toValues());
      }
    });
  }

  Future<void> revoke(String deviceId, int updatedAt) async {
    await _database.update(
      'devices',
      <String, Object?>{'status': 'revoked', 'updated_at': updatedAt},
      where: 'id = ?',
      whereArgs: <Object?>[deviceId],
    );
  }
}

final class _DeviceCursor {
  const _DeviceCursor(this.createdAt, this.id);

  final int createdAt;
  final String id;
}

String _encodeCursor(int createdAt, String id) =>
    base64UrlEncode(utf8.encode('$createdAt|$id'));

_DeviceCursor? _decodeCursor(String? cursor) {
  if (cursor == null || cursor.isEmpty) {
    return null;
  }
  try {
    final decoded = utf8.decode(base64Url.decode(base64Url.normalize(cursor)));
    final separator = decoded.indexOf('|');
    if (separator <= 0 || separator == decoded.length - 1) {
      throw const FormatException();
    }
    final createdAt = int.parse(decoded.substring(0, separator));
    final id = decoded.substring(separator + 1);
    return _DeviceCursor(createdAt, id);
  } on FormatException {
    throw ArgumentError.value(cursor, 'cursor', 'is not a valid device cursor');
  }
}

Uint8List? _blob(List<int>? value) =>
    value == null ? null : Uint8List.fromList(value);

List<int>? _bytes(Object? value) => switch (value) {
  null => null,
  Uint8List bytes => List<int>.unmodifiable(bytes),
  List<int> bytes => List<int>.unmodifiable(bytes),
  _ => throw StateError('Database blob column has an invalid type.'),
};
