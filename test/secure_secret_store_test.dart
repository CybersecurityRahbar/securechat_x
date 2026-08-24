import 'package:flutter_test/flutter_test.dart';

import 'package:securechat_x/core/storage/flutter_secure_secret_store.dart';

void main() {
  test('secret store round-trips bytes through the backend', () async {
    final fake = _FakeSecretBackend();
    final store = FlutterSecureSecretStore(backend: fake);

    await store.writeSecret('identity.test', <int>[0, 1, 2, 255]);
    expect(await store.readSecret('identity.test'), <int>[0, 1, 2, 255]);

    await store.deleteSecret('identity.test');
    expect(await store.readSecret('identity.test'), isNull);
  });

  test('secret store rejects invalid keys before touching the backend', () async {
    final fake = _FakeSecretBackend();
    final store = FlutterSecureSecretStore(backend: fake);

    expect(
      () => store.writeSecret('', <int>[1]),
      throwsArgumentError,
    );
    expect(fake.writes, isEmpty);
  });

  test('malformed encoded secret fails closed', () async {
    final fake = _FakeSecretBackend()..values['bad'] = 'not-valid-base64';
    final store = FlutterSecureSecretStore(backend: fake);

    expect(
      () => store.readSecret('bad'),
      throwsStateError,
    );
  });
}

final class _FakeSecretBackend implements SecretStorageBackend {
  final Map<String, String> values = <String, String>{};
  final List<String> writes = <String>[];

  @override
  Future<void> write(String key, String value) async {
    writes.add(key);
    values[key] = value;
  }

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> delete(String key) async {
    values.remove(key);
  }
}
