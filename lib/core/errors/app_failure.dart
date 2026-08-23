/// Safe, typed failures. Diagnostics must never contain secrets or plaintext.
sealed class AppFailure implements Exception {
  const AppFailure({required this.safeMessage, required this.diagnosticCode, required this.diagnosticDetail});

  final String safeMessage;
  final String diagnosticCode;
  final String diagnosticDetail;
}

final class NetworkFailure extends AppFailure { const NetworkFailure({required super.safeMessage, required super.diagnosticCode, required super.diagnosticDetail}); }
final class CryptoFailure extends AppFailure { const CryptoFailure({required super.safeMessage, required super.diagnosticCode, required super.diagnosticDetail}); }
final class DatabaseFailure extends AppFailure { const DatabaseFailure({required super.safeMessage, required super.diagnosticCode, required super.diagnosticDetail}); }
final class ProtocolFailure extends AppFailure { const ProtocolFailure({required super.safeMessage, required super.diagnosticCode, required super.diagnosticDetail}); }
final class AuthenticationFailure extends AppFailure { const AuthenticationFailure({required super.safeMessage, required super.diagnosticCode, required super.diagnosticDetail}); }
final class PermissionFailure extends AppFailure { const PermissionFailure({required super.safeMessage, required super.diagnosticCode, required super.diagnosticDetail}); }
final class StorageFailure extends AppFailure { const StorageFailure({required super.safeMessage, required super.diagnosticCode, required super.diagnosticDetail}); }
final class ConfigurationFailure extends AppFailure { const ConfigurationFailure({required super.safeMessage, required super.diagnosticCode, required super.diagnosticDetail}); }
final class ValidationFailure extends AppFailure { const ValidationFailure({required super.safeMessage, required super.diagnosticCode, required super.diagnosticDetail}); }
final class SessionFailure extends AppFailure { const SessionFailure({required super.safeMessage, required super.diagnosticCode, required super.diagnosticDetail}); }
final class MediaFailure extends AppFailure { const MediaFailure({required super.safeMessage, required super.diagnosticCode, required super.diagnosticDetail}); }
final class CallFailure extends AppFailure { const CallFailure({required super.safeMessage, required super.diagnosticCode, required super.diagnosticDetail}); }
final class UnknownFailure extends AppFailure { const UnknownFailure({required super.safeMessage, required super.diagnosticCode, required super.diagnosticDetail}); }
