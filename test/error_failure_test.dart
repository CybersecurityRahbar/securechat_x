import 'package:flutter_test/flutter_test.dart';
import 'package:securechat_x/core/errors/app_failure.dart';

void main() {
  test('failure keeps the safe user-facing message separate from diagnostics',
      () {
    const NetworkFailure failure = NetworkFailure(
      safeMessage: 'Connection unavailable.',
      diagnosticCode: 'network.unavailable',
      diagnosticDetail: 'No active transport.',
    );
    expect(failure.safeMessage, 'Connection unavailable.');
    expect(failure.diagnosticCode, 'network.unavailable');
  });
}
