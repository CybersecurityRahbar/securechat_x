import '../core/network/transport.dart';
import '../core/storage/flutter_secure_secret_store.dart';
import '../core/storage/storage_boundaries.dart';
import '../data/database/database.dart';
import '../data/database/sqlite_database.dart';
import '../services/background/lifecycle_service.dart';

/// Application composition root for the currently implemented infrastructure.
///
/// Phase 3 now supplies a real relational SQLite boundary and platform-protected
/// secret storage. Preferences, transport and higher-level feature repositories
/// remain deliberately deferred to their roadmap phases.
final class AppDependencies {
  AppDependencies({
    required this.preferences,
    required this.secrets,
    required this.database,
    required this.transport,
    LifecycleService? lifecycle,
  }) : lifecycle = lifecycle ?? LifecycleService();

  final PreferencesStore preferences;
  final SecretStore secrets;
  final Database database;
  final Transport transport;
  final LifecycleService lifecycle;

  factory AppDependencies.foundation() => AppDependencies(
    preferences: const _UnavailablePreferencesStore(),
    secrets: FlutterSecureSecretStore(),
    database: SqliteDatabase(),
    transport: const _UnavailableTransport(),
  );

  void dispose() => lifecycle.dispose();
}

final class _UnavailablePreferencesStore implements PreferencesStore {
  const _UnavailablePreferencesStore();

  @override
  Future<String?> read(String key) => Future<String?>.error(
    StateError('Phase 3 preferences repository is not implemented.'),
  );

  @override
  Future<void> write(String key, String value) => Future<void>.error(
    StateError('Phase 3 preferences repository is not implemented.'),
  );
}

final class _UnavailableTransport implements Transport {
  const _UnavailableTransport();

  @override
  Stream<ConnectionState> get states => const Stream<ConnectionState>.empty();

  @override
  Future<void> connect() => Future<void>.error(
    StateError('Transport is not implemented in the current phase.'),
  );

  @override
  Future<void> disconnect() async {}
}
