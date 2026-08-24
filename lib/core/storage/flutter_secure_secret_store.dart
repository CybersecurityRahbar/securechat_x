import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage_boundaries.dart';

abstract interface class SecretStorageBackend {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
}

final class FlutterSecureStorageBackend implements SecretStorageBackend {
  FlutterSecureStorageBackend({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// Platform-protected implementation for sensitive byte material.
///
/// Values are base64-encoded only for transport through the string-oriented
/// plugin API; the plugin is responsible for protected-at-rest storage.
final class FlutterSecureSecretStore implements SecretStore {
  FlutterSecureSecretStore({SecretStorageBackend? backend})
    : _backend = backend ?? FlutterSecureStorageBackend();

  final SecretStorageBackend _backend;

  @override
  Future<void> writeSecret(String key, List<int> secret) async {
    _validateKey(key);
    await _backend.write(key, base64Encode(secret));
  }

  @override
  Future<List<int>?> readSecret(String key) async {
    _validateKey(key);
    final String? encoded = await _backend.read(key);
    if (encoded == null) {
      return null;
    }

    try {
      final Uint8List decoded = base64Decode(encoded);
      final String canonical = base64Encode(decoded);
      if (canonical != encoded) {
        throw const FormatException('Non-canonical Base64 encoding.');
      }
      return decoded;
    } on FormatException {
      throw StateError('Secure storage contains an invalid encoded value.');
    }
  }

  @override
  Future<void> deleteSecret(String key) async {
    _validateKey(key);
    await _backend.delete(key);
  }

  static void _validateKey(String key) {
    if (key.isEmpty) {
      throw ArgumentError.value(key, 'key', 'must not be empty');
    }
    if (key.length > 200) {
      throw ArgumentError.value(key, 'key', 'must be 200 characters or fewer');
    }
  }
}
