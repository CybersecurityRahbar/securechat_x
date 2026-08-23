enum ConnectionState { offline, connecting, connected, unavailable }

abstract interface class Transport {
  Stream<ConnectionState> get states;
  Future<void> connect();
  Future<void> disconnect();
}
