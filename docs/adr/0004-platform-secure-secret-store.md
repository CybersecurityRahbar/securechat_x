# ADR 0004 — Platform-protected secret storage boundary

## Status
Accepted — Phase 3 implementation.

## Context
SecureChat X must keep private keys, recovery material, session secrets and other sensitive byte material out of SQLite and ordinary preferences. The existing `SecretStore` boundary intentionally predates its concrete implementation so later identity and cryptographic phases can depend on a stable contract.

## Decision
Use `flutter_secure_storage` as the first concrete `SecretStore` adapter. Version 10.3.1 is selected for the current Flutter/Dart baseline because it is a recent stable release with a lower compatibility floor and no need to adopt the breaking changes in the newer 11.x line at this stage.

`FlutterSecureSecretStore` owns only byte-oriented secret persistence. It base64-encodes bytes for the plugin's string API and relies on the platform-protected storage implementation for protected-at-rest handling. It does not generate keys, rotate keys, define identity semantics, or perform application-level encryption.

The adapter is separated from a `SecretStorageBackend` interface so unit tests can verify encoding, validation and fail-closed behavior without invoking platform channels.

## Security boundaries

- Never write plaintext private keys, recovery phrases, session secrets or message plaintext to SQLite.
- Never log secret values or encoded secret values.
- Database repositories continue to accept ciphertext/public metadata only.
- Identity key generation and lifecycle remain Phase 4 responsibilities.
- Cryptographic protocol/session ownership remain later phase responsibilities.
- Normal application preferences remain a separate boundary from secrets.

## Consequences

Positive:
- A real platform-protected secret store now exists before identity implementation.
- Feature/domain code remains independent of plugin APIs.
- Unit tests do not require an Android emulator or platform channel.

Deferred:
- Android Keystore policy details for identity keys.
- Biometric policy and user-presence requirements.
- Recovery-material lifecycle.
- Key rotation and migration semantics.
