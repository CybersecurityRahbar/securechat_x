import 'dart:typed_data';

import '../database/database.dart';

/// Repository for encrypted-at-rest drafts.
///
/// The repository deliberately accepts ciphertext rather than plaintext. The
/// encryption owner will be introduced by the security/identity phases.
final class DraftRepository {
  const DraftRepository(this._database);

  final Database _database;

  Future<DraftRecord?> findByConversation(String conversationId) async {
    final List<Map<String, Object?>> rows = await _database.query(
      'drafts',
      where: 'conversation_id = ?',
      whereArgs: <Object?>[conversationId],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return DraftRecord.fromRow(rows.single);
  }

  Future<void> save(DraftRecord draft) async {
    await _database.transaction<void>((DatabaseTransaction tx) async {
      final int updated = await tx.update(
        'drafts',
        draft.toValues(),
        where: 'id = ?',
        whereArgs: <Object?>[draft.id],
      );
      if (updated == 0) {
        await tx.insert('drafts', draft.toValues());
      }
    });
  }

  Future<void> delete(String draftId) async {
    await _database.delete(
      'drafts',
      where: 'id = ?',
      whereArgs: <Object?>[draftId],
    );
  }
}

final class DraftRecord {
  const DraftRecord({
    required this.id,
    required this.conversationId,
    required this.textCiphertext,
    required this.updatedAt,
  });

  final String id;
  final String conversationId;
  final List<int>? textCiphertext;
  final int updatedAt;

  factory DraftRecord.fromRow(Map<String, Object?> row) => DraftRecord(
    id: row['id']! as String,
    conversationId: row['conversation_id']! as String,
    textCiphertext: _bytesFromRow(row['text_ciphertext']),
    updatedAt: row['updated_at']! as int,
  );

  Map<String, Object?> toValues() => <String, Object?>{
    'id': id,
    'conversation_id': conversationId,
    'text_ciphertext': _blobValue(textCiphertext),
    'updated_at': updatedAt,
  };
}

/// Repository for settings whose values have already been encrypted by the
/// security layer. No plaintext setting value crosses this repository.
final class EncryptedSettingsRepository {
  const EncryptedSettingsRepository(this._database);

  final Database _database;

  Future<List<int>?> read(String key) async {
    final List<Map<String, Object?>> rows = await _database.query(
      'app_settings',
      columns: <String>['value_ciphertext'],
      where: 'key = ?',
      whereArgs: <Object?>[key],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return _bytesFromRow(rows.single['value_ciphertext']);
  }

  Future<void> write(String key, List<int> ciphertext, int updatedAt) async {
    await _database.transaction<void>((DatabaseTransaction tx) async {
      final Map<String, Object?> values = <String, Object?>{
        'key': key,
        'value_ciphertext': _blobValue(ciphertext),
        'updated_at': updatedAt,
      };
      final int updated = await tx.update(
        'app_settings',
        values,
        where: 'key = ?',
        whereArgs: <Object?>[key],
      );
      if (updated == 0) {
        await tx.insert('app_settings', values);
      }
    });
  }

  Future<void> delete(String key) => _database.delete(
    'app_settings',
    where: 'key = ?',
    whereArgs: <Object?>[key],
  );
}

Uint8List? _blobValue(List<int>? value) =>
    value == null ? null : Uint8List.fromList(value);

List<int>? _bytesFromRow(Object? value) => switch (value) {
  null => null,
  Uint8List bytes => List<int>.unmodifiable(bytes),
  List<int> bytes => List<int>.unmodifiable(bytes),
  _ => throw StateError('Database blob column has an invalid type.'),
};
