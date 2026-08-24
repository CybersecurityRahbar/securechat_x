import 'sqlite_database.dart';

/// Health state returned by the local database integrity check.
enum DatabaseHealth { healthy, degraded }

final class DatabaseIntegrityReport {
  const DatabaseIntegrityReport({
    required this.health,
    required this.missingTables,
    required this.missingIndexes,
    required this.foreignKeyViolations,
  });

  final DatabaseHealth health;
  final List<String> missingTables;
  final List<String> missingIndexes;
  final List<Map<String, Object?>> foreignKeyViolations;

  bool get isHealthy => health == DatabaseHealth.healthy;
}

final class CleanupPolicy {
  const CleanupPolicy({
    required this.securityEventRetention,
    this.maxRowsPerRun = 100,
  }) : assert(maxRowsPerRun > 0 && maxRowsPerRun <= 5000);

  final Duration securityEventRetention;
  final int maxRowsPerRun;
}

final class CleanupResult {
  const CleanupResult({required this.securityEventsDeleted});

  final int securityEventsDeleted;
}

/// SQLite-specific maintenance operations kept outside feature repositories.
final class SqliteDatabaseMaintenance {
  const SqliteDatabaseMaintenance(this._database);

  final SqliteDatabase _database;

  Future<DatabaseIntegrityReport> inspect() async {
    final tables = await _database.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%' ORDER BY name",
    );
    final indexes = await _database.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'index' AND name NOT LIKE 'sqlite_%' ORDER BY name",
    );
    final foreignKeys = await _database.rawQuery('PRAGMA foreign_key_check');

    final tableNames = tables.map((row) => row['name'] as String).toSet();
    final indexNames = indexes.map((row) => row['name'] as String).toSet();

    final missingTables = SecureChatExpectedSchema.tables
        .where((name) => !tableNames.contains(name))
        .toList(growable: false);
    final missingIndexes = SecureChatExpectedSchema.indexes
        .where((name) => !indexNames.contains(name))
        .toList(growable: false);

    return DatabaseIntegrityReport(
      health:
          missingTables.isEmpty && missingIndexes.isEmpty && foreignKeys.isEmpty
          ? DatabaseHealth.healthy
          : DatabaseHealth.degraded,
      missingTables: missingTables,
      missingIndexes: missingIndexes,
      foreignKeyViolations: foreignKeys,
    );
  }

  Future<CleanupResult> cleanup(CleanupPolicy policy, {DateTime? now}) async {
    final cutoff = (now ?? DateTime.now().toUtc())
        .subtract(policy.securityEventRetention)
        .millisecondsSinceEpoch;

    var deleted = 0;
    await _database.transaction<void>((tx) async {
      final rows = await tx.query(
        'security_events',
        columns: <String>['id'],
        where: 'created_at < ?',
        whereArgs: <Object?>[cutoff],
        orderBy: 'created_at ASC, id ASC',
        limit: policy.maxRowsPerRun,
      );
      for (final row in rows) {
        deleted += await tx.delete(
          'security_events',
          where: 'id = ?',
          whereArgs: <Object?>[row['id']],
        );
      }
    });

    return CleanupResult(securityEventsDeleted: deleted);
  }
}

final class SecureChatExpectedSchema {
  const SecureChatExpectedSchema._();

  static const List<String> tables = <String>[
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
  ];

  static const List<String> indexes = <String>[
    'idx_devices_user_status',
    'idx_contacts_trust_updated',
    'idx_conversations_last_message',
    'idx_members_member',
    'idx_messages_conversation_created',
    'idx_messages_state_created',
    'idx_messages_expiry',
    'idx_recipients_state_updated',
    'idx_attachments_message',
    'idx_attachments_state_updated',
    'idx_sessions_devices',
    'idx_prekeys_device_kind_consumed',
    'idx_group_members_contact',
    'idx_calls_conversation_created',
    'idx_call_events_call_created',
    'idx_security_events_created',
  ];
}
