import 'package:flutter_test/flutter_test.dart';
import 'package:securechat_x/app/environment.dart';
import 'package:securechat_x/core/errors/app_failure.dart';

void main() {
  test('accepts supported environment and positive protocol version', () {
    final AppEnvironment environment = AppEnvironment.fromDartDefines(name: 'staging', protocolVersion: '2');
    expect(environment.kind, Environment.staging);
    expect(environment.protocolVersion, 2);
  });

  test('rejects unsupported environment without exposing configuration values', () {
    expect(
      () => AppEnvironment.fromDartDefines(name: 'unsafe', protocolVersion: '1'),
      throwsA(isA<ConfigurationFailure>()),
    );
  });

  test('rejects an invalid protocol version', () {
    expect(() => AppEnvironment.fromDartDefines(protocolVersion: '0'), throwsA(isA<ConfigurationFailure>()));
  });
}
