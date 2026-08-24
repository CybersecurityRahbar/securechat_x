import '../core/errors/app_failure.dart';

enum Environment { development, staging, production }

/// Non-secret runtime configuration. Endpoints remain unset until Phase 18.
final class AppEnvironment {
  const AppEnvironment({required this.kind, required this.protocolVersion});

  final Environment kind;
  final int protocolVersion;

  static AppEnvironment fromDartDefines({
    String? name,
    String? protocolVersion,
  }) {
    final Environment kind = switch (name ?? 'development') {
      'development' => Environment.development,
      'staging' => Environment.staging,
      'production' => Environment.production,
      final String invalid => throw ConfigurationFailure(
        safeMessage: 'The application configuration is invalid.',
        diagnosticCode: 'environment.invalid_name',
        diagnosticDetail: 'Unsupported environment name: $invalid',
      ),
    };
    final int? parsedVersion = int.tryParse(protocolVersion ?? '1');
    if (parsedVersion == null || parsedVersion < 1) {
      throw const ConfigurationFailure(
        safeMessage: 'The application configuration is invalid.',
        diagnosticCode: 'protocol.invalid_version',
        diagnosticDetail: 'Protocol version must be a positive integer.',
      );
    }
    return AppEnvironment(kind: kind, protocolVersion: parsedVersion);
  }
}
