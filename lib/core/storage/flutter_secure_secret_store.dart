import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage_boundaries.dart';

/// Platform-protected implementation for sensitive byte material.
///
/// Values are base64-encoded only for transport through the string-oriented
/// plugin API; the plugin is responsible for protected-at-rest storage.
final class FlutterSecureSecretStore implements SecretStore {
  FlutterSecureSecretStore({FlutterSecureStorage? storage})
    : _storage = storage ?? FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<void> writeSecret(String key, List<int> secret) async {
    _validateKey(key);
    await _storage.write(key: key, value: base64Encode(secret));
  }

  @override
  Future<List<int>?> readSecret(String key) async {
    _validateKey(key);
    final String? encoded = await _storage.read(key: key);
    if (encoded == null) {
      return null;
    }
    try {
      return Uint8List.fromList(base64Decode(encoded));
    } on FormatException {
      throw StateError('Secure storage contains an invalid encoded value.');
    }
  }

  @override
  Future<void> deleteSecret(String key) async {
    _validateKey(key);
    await _storage.delete(key: key);
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
