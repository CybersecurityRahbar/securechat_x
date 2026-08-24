import '../core/network/transport.dart';
import '../core/storage/storage_boundaries.dart';
import '../data/database/database.dart';
import '../data/database/sqlite_database.dart';
import '../services/background/lifecycle_service.dart';

/// Application composition root for the currently implemented infrastructure.
///
/// Phase 3 now supplies a real relational SQLite boundary. Secure secret
/// storage, transport and higher-level repositories remain intentionally
/// unavailable until their roadmap phases are implemented.
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
        secrets: const _UnavailableSecretStore(),
        database: SqliteDatabase(),
        transport: const _UnavailableTransport(),
      );

  void dispose() => lifecycle.dispose();
}

final class _UnavailablePreferencesStore implements PreferencesStore {
  const _UnavailablePreferencesStore();

  @override
  Future<String?> read(String key) => Future<String?>.error(
      StateError('Phase 3 preferences repository is not implemented.'));

  @override
  Future<void> write(String key, String value) => Future<void>.error(
      StateError('Phase 3 preferences repository is not implemented.'));
}

final class _UnavailableSecretStore implements SecretStore {
  const _UnavailableSecretStore();

  @override
  Future<void> writeSecret(String key, List<int> secret) => Future<void>.error(
      StateError('Secure secret storage is not implemented.'));

  @override
  Future<List<int>?> readSecret(String key) => Future<List<int>?>.error(
      StateError('Secure secret storage is not implemented.'));

  @override
  Future<void> deleteSecret(String key) => Future<void>.error(
      StateError('Secure secret storage is not implemented.'));
}

final class _UnavailableTransport implements Transport {
  const _UnavailableTransport();

  @override
  Stream<ConnectionState> get states => const Stream<ConnectionState>.empty();

  @override
  Future<void> connect() => Future<void>.error(
      StateError('Transport is not implemented in the current phase.'));

  @override
  Future<void> disconnect() async {}
}
