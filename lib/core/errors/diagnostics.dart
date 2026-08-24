import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'app_failure.dart';

/// A redacted diagnostic event. It deliberately excludes exception text and
/// application values because those values can contain sensitive user data.
final class DiagnosticEvent {
  const DiagnosticEvent({
    required this.code,
    required this.errorType,
    required this.stackTrace,
    required this.occurredAt,
  });

  final String code;
  final String errorType;
  final StackTrace? stackTrace;
  final DateTime occurredAt;
}

abstract interface class DiagnosticsReporter {
  void record({
    required String code,
    required Object error,
    StackTrace? stackTrace,
  });
  Stream<DiagnosticEvent> get events;
  void dispose();
}

/// In-process diagnostics boundary, not a telemetry implementation.
///
/// The buffer is intentionally bounded and stores only redacted metadata.
class MemoryDiagnosticsReporter implements DiagnosticsReporter {
  MemoryDiagnosticsReporter({this.capacity = 50}) : assert(capacity > 0);

  final int capacity;
  final List<DiagnosticEvent> _events = <DiagnosticEvent>[];
  final StreamController<DiagnosticEvent> _controller =
      StreamController<DiagnosticEvent>.broadcast();

  @override
  Stream<DiagnosticEvent> get events => _controller.stream;

  @override
  void record({
    required String code,
    required Object error,
    StackTrace? stackTrace,
  }) {
    final String redactedCode = _redactedCode(code);
    if (_events.length == capacity) _events.removeAt(0);
    _events.add(
      DiagnosticEvent(
        code: redactedCode,
        errorType: error.runtimeType.toString(),
        stackTrace: stackTrace,
        occurredAt: DateTime.now().toUtc(),
      ),
    );
    _controller.add(_events.last);
  }

  @override
  void dispose() {
    unawaited(_controller.close());
  }
}

/// Development-only reporter that exposes redacted error type, code and stack.
final class DevelopmentDiagnosticsReporter extends MemoryDiagnosticsReporter {
  @override
  void record({
    required String code,
    required Object error,
    StackTrace? stackTrace,
  }) {
    super.record(code: code, error: error, stackTrace: stackTrace);
    debugPrint(
      'SecureChat diagnostic [${_redactedCode(code)}] (${error.runtimeType})',
    );
    if (stackTrace != null) {
      debugPrintStack(
        stackTrace: stackTrace,
        label: 'SecureChat redacted stack',
      );
    }
  }
}

const Set<String> _allowedCodes = <String>{
  'bootstrap.configuration',
  'framework.unhandled',
  'zone.unhandled',
  'failure.network',
  'failure.crypto',
  'failure.database',
  'failure.protocol',
  'failure.authentication',
  'failure.permission',
  'failure.storage',
  'failure.configuration',
  'failure.validation',
  'failure.session',
  'failure.media',
  'failure.call',
  'failure.unknown',
};

String _redactedCode(String code) =>
    _allowedCodes.contains(code) ? code : 'diagnostic.redacted';

String diagnosticCodeFor(Object error, {required String fallback}) =>
    switch (error) {
      NetworkFailure() => 'failure.network',
      CryptoFailure() => 'failure.crypto',
      DatabaseFailure() => 'failure.database',
      ProtocolFailure() => 'failure.protocol',
      AuthenticationFailure() => 'failure.authentication',
      PermissionFailure() => 'failure.permission',
      StorageFailure() => 'failure.storage',
      ConfigurationFailure() => 'failure.configuration',
      ValidationFailure() => 'failure.validation',
      SessionFailure() => 'failure.session',
      MediaFailure() => 'failure.media',
      CallFailure() => 'failure.call',
      UnknownFailure() => 'failure.unknown',
      _ => fallback,
    };
