import 'package:flutter_test/flutter_test.dart';
import 'package:securechat_x/core/security/security_policy.dart';

void main() {
  test(
      'Phase 1 security policy has conservative defaults and no false E2EE claim',
      () {
    expect(SecurityPolicy.permitsCleartextTransport, isFalse);
    expect(SecurityPolicy.permitsPlaintextDiagnostics, isFalse);
    expect(SecurityPolicy.hasEstablishedEndToEndEncryption, isFalse);
    expect(SecurityPolicy.hasVerifiedIdentity, isFalse);
  });
}
