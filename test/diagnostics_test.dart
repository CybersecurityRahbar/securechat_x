import 'package:flutter_test/flutter_test.dart';
import 'package:securechat_x/core/errors/app_failure.dart';
import 'package:securechat_x/core/errors/diagnostics.dart';

void main() {
  test('diagnostics emit typed redacted metadata without error detail', () async {
    final MemoryDiagnosticsReporter reporter = MemoryDiagnosticsReporter();
    final Future<DiagnosticEvent> event = reporter.events.first;
    const ConfigurationFailure failure = ConfigurationFailure(
      safeMessage: 'Invalid configuration.',
      diagnosticCode: 'environment.invalid_name',
      diagnosticDetail: 'The rejected value is confidential.',
    );

    reporter.record(code: diagnosticCodeFor(failure, fallback: 'unexpected'), error: failure);

    final DiagnosticEvent recorded = await event;
    expect(recorded.code, 'failure.configuration');
    expect(recorded.errorType, 'ConfigurationFailure');
    expect(recorded.errorType, isNot(contains('confidential')));
    reporter.dispose();
  });

  test('diagnostics redact unapproved diagnostic codes', () async {
    final MemoryDiagnosticsReporter reporter = MemoryDiagnosticsReporter();
    final Future<DiagnosticEvent> event = reporter.events.first;

    reporter.record(code: 'recovery.phrase', error: StateError('not retained'));

    expect((await event).code, 'diagnostic.redacted');
    reporter.dispose();
  });
}
