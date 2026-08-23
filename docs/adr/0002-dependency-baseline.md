# ADR 0002: Remove legacy runtime dependencies from the Phase 1 baseline

**Status:** Accepted (2026-08-23)

## Decision

Remove the legacy prototype's direct runtime dependencies: cryptography, Hive, connectivity, WebSocket, WebRTC, media, picker, notification, device, authentication, cache, sharing, HTTP, Riverpod, and GoRouter packages. None is used by the Phase 1 executable foundation, and retaining them would preserve unreviewed platform and security surface.

Keep only Flutter SDK localization support and `flutter_lints`. Future packages require a phase-specific ADR covering need, maintenance, license, Android support, Flutter/Dart compatibility, security relevance, and transitive impact. Cryptography and persistence packages require deeper review.

## Consequences

The application has no implementation of those future capabilities. Interfaces describe their eventual ownership without presenting a fake feature or security claim.
