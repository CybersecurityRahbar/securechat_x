import 'dart:async';

import 'package:flutter/material.dart';

import 'app_dependencies.dart';
import 'app_scope.dart';
import 'environment.dart';
import '../core/errors/diagnostics.dart';
import '../features/design_system/foundation_widgets.dart';
import 'securechat_app.dart';

Future<void> bootstrapSecureChat({
  AppEnvironment? environment,
  DiagnosticsReporter? diagnostics,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  late final AppEnvironment resolvedEnvironment;
  late final DiagnosticsReporter reporter;
  try {
    resolvedEnvironment =
        environment ??
        AppEnvironment.fromDartDefines(
          name: const String.fromEnvironment(
            'SECURECHAT_ENV',
            defaultValue: 'development',
          ),
          protocolVersion: const String.fromEnvironment(
            'SECURECHAT_PROTOCOL_VERSION',
            defaultValue: '1',
          ),
        );
    reporter = diagnostics ?? _reporterFor(resolvedEnvironment.kind);
  } on Object catch (error, stackTrace) {
    final DiagnosticsReporter fallbackReporter =
        diagnostics ?? _bootstrapReporter();
    fallbackReporter.record(
      code: diagnosticCodeFor(error, fallback: 'bootstrap.configuration'),
      error: error,
      stackTrace: stackTrace,
    );
    runApp(const _BootstrapFailureApp());
    return;
  }

  final AppDependencies dependencies = AppDependencies.foundation();

  try {
    await dependencies.database.migrate();
  } on Object catch (error, stackTrace) {
    reporter.record(
      code: diagnosticCodeFor(error, fallback: 'database.migration'),
      error: error,
      stackTrace: stackTrace,
    );
    runApp(const _DatabaseFailureApp());
    return;
  }

  ErrorWidget.builder = (FlutterErrorDetails details) {
    reporter.record(
      code: diagnosticCodeFor(
        details.exception,
        fallback: 'framework.unhandled',
      ),
      error: details.exception,
      stackTrace: details.stack,
    );
    return const ErrorState(
      message: 'Something unexpected occurred. Please restart the application.',
    );
  };

  FlutterError.onError = (FlutterErrorDetails details) {
    reporter.record(
      code: diagnosticCodeFor(
        details.exception,
        fallback: 'framework.unhandled',
      ),
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  runZonedGuarded(
    () => runApp(
      AppScope(
        environment: resolvedEnvironment,
        dependencies: dependencies,
        diagnostics: reporter,
        child: SecureChatApp(lifecycle: dependencies.lifecycle),
      ),
    ),
    (Object error, StackTrace stackTrace) => reporter.record(
      code: diagnosticCodeFor(error, fallback: 'zone.unhandled'),
      error: error,
      stackTrace: stackTrace,
    ),
  );
}

DiagnosticsReporter _reporterFor(Environment environment) =>
    switch (environment) {
      Environment.development => DevelopmentDiagnosticsReporter(),
      Environment.staging ||
      Environment.production => MemoryDiagnosticsReporter(),
    };

DiagnosticsReporter _bootstrapReporter() {
  const String configuredEnvironment = String.fromEnvironment(
    'SECURECHAT_ENV',
    defaultValue: 'development',
  );
  return configuredEnvironment == 'development'
      ? DevelopmentDiagnosticsReporter()
      : MemoryDiagnosticsReporter();
}

class _BootstrapFailureApp extends StatelessWidget {
  const _BootstrapFailureApp();

  @override
  Widget build(BuildContext context) => const MaterialApp(
    home: Scaffold(
      body: ErrorState(
        message:
            'The application configuration is invalid. Please contact support.',
      ),
    ),
  );
}

class _DatabaseFailureApp extends StatelessWidget {
  const _DatabaseFailureApp();

  @override
  Widget build(BuildContext context) => const MaterialApp(
    home: Scaffold(
      body: ErrorState(
        message:
            'Secure local storage could not be initialized. Your data was not opened.',
      ),
    ),
  );
}
