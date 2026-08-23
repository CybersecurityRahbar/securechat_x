import '../core/network/transport.dart';
import '../core/storage/storage_boundaries.dart';
import '../data/database/database.dart';

/// Explicit composition root. Concrete services are introduced in their owning phases.
final class AppDependencies {
  const AppDependencies({
    required this.preferences,
    required this.secrets,
    required this.database,
    required this.transport,
  });

  final PreferencesStore preferences;
  final SecretStore secrets;
  final Database database;
  final Transport transport;
}
