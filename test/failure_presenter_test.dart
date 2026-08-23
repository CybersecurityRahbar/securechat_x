import 'package:flutter_test/flutter_test.dart';
import 'package:securechat_x/core/errors/app_failure.dart';
import 'package:securechat_x/core/errors/failure_presenter.dart';

void main() {
  test('maps known failures to their safe user-facing message', () {
    const ValidationFailure failure = ValidationFailure(
      safeMessage: 'Check the supplied values.',
      diagnosticCode: 'validation.invalid',
      diagnosticDetail: 'A field was invalid.',
    );
    expect(FailurePresenter.messageFor(failure), 'Check the supplied values.');
  });

  test('maps unknown errors to a redacted generic message', () {
    expect(FailurePresenter.messageFor(StateError('private detail')), 'Something unexpected occurred. Please try again.');
  });
}
