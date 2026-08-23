import '../entities/foundation_destination.dart';

abstract interface class AppStatusRepository {
  Stream<bool> watchConnectivity();
  Future<FoundationDestination> initialDestination();
}
