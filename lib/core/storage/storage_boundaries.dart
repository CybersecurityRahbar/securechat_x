abstract interface class PreferencesStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
}

/// Future secret stores must be backed by platform-protected secure storage.
abstract interface class SecretStore {
  Future<void> writeSecret(String key, List<int> secret);
  Future<List<int>?> readSecret(String key);
  Future<void> deleteSecret(String key);
}

abstract interface class IdentityKeyStore extends SecretStore {}

abstract interface class SessionStateStore extends SecretStore {}

abstract interface class RecoveryMaterialStore extends SecretStore {}
