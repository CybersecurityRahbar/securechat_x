/// Defaults only; claims are intentionally conservative until their phases land.
final class SecurityPolicy {
  const SecurityPolicy._();
  static const bool permitsCleartextTransport = false;
  static const bool permitsPlaintextDiagnostics = false;
  static const bool hasEstablishedEndToEndEncryption = false;
  static const bool hasVerifiedIdentity = false;
}
