import '../core/network/transport.dart';
import '../core/storage/storage_boundaries.dart';
import '../data/database/database.dart';

/// Phase 1 composition object.
///
/// The implementations below are explicit non-implemented boundaries. They
/// prevent widgets from constructing infrastructure while making it impossible
/// to mistake Phase 1 for a working messaging/security stack.
final class AppDependencies {
  const AppDependencies({
    required this.preferences,
    required this.secrets,
    required this.database,
    required this.transport,
  });

  final PreferencesStore preferences;
  final SecretStore secrets;
  final Database database;
  final Transport transport;

  factory AppDependencies.foundation() => AppDependencies(
        preferences: const _UnavailablePreferencesStore(),
        secrets: const _UnavailableSecretStore(),
        database: const _UnavailableDatabase(),
        transport: const _UnavailableTransport(),
      );
}

final class _UnavailablePreferencesStore implements PreferencesStore {
  const _UnavailablePreferencesStore();

  @override
  Future<String?> read(String key) =>
      Future<String?>.error(StateError('Phase 3 preferences are not implemented.'));

  @override
  Future<void> write(String key, String value) =>
      Future<void>.error(StateError('Phase 3 preferences are not implemented.'));
}

final class _UnavailableSecretStore implements SecretStore {
  const _UnavailableSecretStore();

  @override
  Future<void> writeSecret(String key, List<int> secret) =>
      Future<void>.error(StateError('Secure secret storage is not implemented.'));

  @override
  Future<List<int>?> readSecret(String key) =>
      Future<List<int>?>.error(StateError('Secure secret storage is not implemented.'));

  @override
  Future<void> deleteSecret(String key) =>
      Future<void>.error(StateError('Secure secret storage is not implemented.'));
}

final class _UnavailableDatabase implements Database {
  const _UnavailableDatabase();

  @override
  Future<T> transaction<T>(Future<T> Function() action) =>
      Future<T>.error(StateError('Phase 3 database is not implemented.'));

  @override
  Future<void> migrate() =>
      Future<void>.error(StateError('Phase 3 database is not implemented.'));
}

final class _UnavailableTransport implements Transport {
  const _UnavailableTransport();

  @override
  Stream<ConnectionState> get states => const Stream<ConnectionState>.empty();

  @override
  Future<void> connect() =>
      Future<void>.error(StateError('Transport is not implemented in Phase 1.'));

  @override
  Future<void> disconnect() async {}
}
