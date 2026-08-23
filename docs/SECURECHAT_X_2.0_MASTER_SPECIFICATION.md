# SecureChat X 2.0 — Master Product, Security & Architecture Specification

**Status:** Authoritative design specification  
**Version:** 2.0  
**Implementation order:** Flutter/Android client first; compatible server second  
**Rule:** Security, correctness, privacy and maintainability take precedence over feature count.

## 1. Vision

SecureChat X 2.0 is a privacy-first secure communications platform with a premium intelligence-oriented interface. It is not a clone of an existing messenger. The client must be designed first as the authoritative product and protocol reference; the server will later be rebuilt to conform to the frozen client/server contract.

The product must support secure text messaging, voice messages, images, video, documents and arbitrary files; real-time voice/video calls; private groups; an optional built-in public community; multi-device identity; offline-first synchronization; advanced security/privacy controls; and a dedicated Security Center.

Security claims must be precise. The project must never claim absolute security or invent proprietary cryptography. Established, peer-reviewed primitives and mature implementations must be used.

## 2. Core principles

1. Security by design.
2. Zero-trust server model: the server is a relay/service and must not need message plaintext or client private keys.
3. Local-first behavior and encrypted local state.
4. Strict cryptographic key separation and lifecycle management.
5. Established cryptography only; no home-made algorithms or protocols.
6. Explicit identity, device and session verification.
7. Minimal metadata collection and retention.
8. Advanced controls without overwhelming ordinary users.
9. Accessibility, performance and reduced-motion support are mandatory.
10. Every security control must be real, tested and documented; no fake toggles.

## 3. Product areas

- Onboarding and Identity
- Home / Secure Command Center
- Conversations
- Contacts and Identity Verification
- Private Groups
- Public Community
- Calls
- Secure Media and Files
- Security Center
- Settings
- Notifications
- Devices and Sessions
- Backup and Recovery
- Network / Connection Center
- Diagnostics

## 4. Identity and devices

The first-run flow creates a cryptographic identity, registers a device, initializes secure storage, establishes recovery and applies secure defaults. Identity and device keys are separate concepts.

Required concepts:
- stable user identity identifier
- long-term identity key
- device identity key
- signing capability
- signed prekey
- one-time prekey pool
- secure private-key storage
- key rotation
- device revocation
- recovery lifecycle

Recovery must actually restore the intended identity or explicitly documented recovery hierarchy. Generating a new unrelated identity while calling it restoration is prohibited.

Every device gets its own cryptographic material and sessions. Devices can be independently verified and revoked.

## 5. Cryptographic architecture

The exact algorithms and libraries require a dedicated cryptographic review before implementation. The following is the target architecture, not permission to invent a new protocol.

### Identity

Use an established digital-signature identity mechanism. Clearly separate long-term identity, device identity, signing keys, prekeys and session keys.

### Asynchronous key establishment

Use an established authenticated asynchronous design comparable to X3DH, or a mature successor/hybrid construction. Requirements include authenticated identity binding, signed prekey, one-time prekeys, correct private/public pairing, transcript binding, replay resistance, session versioning and downgrade protection.

### Message sessions

Use a mature ratcheting construction comparable to Double Ratchet or a well-reviewed successor. Required behavior includes unique message keys, DH ratchet, symmetric chains, skipped-message handling, out-of-order delivery, replay detection, session reset, recovery and post-compromise recovery where supported.

### Message encryption

Use authenticated encryption with associated data (AEAD) from a mature implementation. The authenticated envelope must bind protocol version, sender/recipient context, conversation/session ID, message ID, relevant ordering information and content type as appropriate.

### Key hierarchy

```text
Root Identity
  └── Device Identity
       ├── Signed Prekey
       ├── One-Time Prekeys
       └── Session State
            ├── Sending Chain
            ├── Receiving Chain
            └── Message Keys
```

Keys must never be reused across unrelated purposes.

### Secure storage

Use platform secure storage and Android hardware-backed keystore capabilities when available. Minimize plaintext key lifetime in memory and never log secrets.

### Post-quantum readiness

The protocol must be versioned and algorithm-agile so a future mature hybrid classical/post-quantum key-establishment mechanism can be added. Do not implement home-made post-quantum cryptography.

## 6. Identity verification

Contacts have explicit security identities. Provide:
- fingerprint
- QR verification
- numeric/manual comparison
- verified/unverified state
- device trust
- identity-change warnings
- session reset
- revoke/block/quarantine

A change to a verified identity must produce a prominent warning and explain possible benign causes without silently trusting the new identity.

## 7. Local database

Replace the current monolithic Hive usage with a properly layered relational database architecture, preferably SQLite/Drift or another well-supported indexed solution after dependency review.

Suggested entities:
- users
- devices
- contacts
- conversations
- conversation_members
- messages
- message_recipients
- attachments
- attachment_chunks
- sessions
- prekeys
- groups
- group_members
- community_state
- calls
- call_events
- delivery_receipts
- read_receipts
- drafts
- app_settings
- security_events
- notification_settings

Requirements: real indexes, pagination, migrations, transactions, integrity checks, bounded queries, background cleanup and encrypted sensitive state.

## 8. Messaging

Supported content:
- text
- replies/quotes
- reactions
- voice messages
- images
- videos
- documents
- arbitrary files
- contact cards where supported
- optional location sharing
- system/security events

Message lifecycle:
`CREATED -> ENCRYPTED -> QUEUED -> SENT -> SERVER_ACK -> DELIVERED -> READ`

The UI must distinguish pending, queued, sent, delivered, read, failed, expired and deleted states. The server must not need plaintext message bodies.

## 9. Voice messages

Provide record/pause/cancel, waveform, playback speed, seek, encrypted local cache, encrypted transfer, download-on-demand, expiration policy, duration limits and permission handling. Recording interaction should support live waveform, elapsed timer, gesture-to-cancel and lock-to-record.

## 10. Media and files

Support photos, video, PDF, office documents, archives, audio and arbitrary files.

Target flow:

```text
Local file
  -> generate attachment key
  -> encrypt content
  -> authenticate metadata
  -> upload ciphertext
  -> recipient downloads ciphertext
  -> recipient obtains attachment key securely
  -> decrypt locally
```

Provide chunking, resumable transfers, integrity verification, encrypted thumbnails, secure cache policy, expiration, storage quotas and Wi-Fi/mobile transfer policy.

## 11. Voice/video calls

Use WebRTC or another mature real-time media stack. Provide one-to-one voice/video, camera switching, mute, audio routing, connection quality, reconnection, timers, incoming-call UI, missed calls and call history.

Call states:
`INVITING -> RINGING -> CONNECTING -> CONNECTED -> RECONNECTING -> ENDED/FAILED`

Signalling is a separate versioned protocol. The UI must be a polished secure communications interface, not a stock WebRTC demo.

## 12. Private groups

Support group creation, name/image/description, member management, roles, permissions, invites, revocation, verification, disappearing messages, media permissions, admin events and membership changes.

Group encryption must not rely on one casually stored static shared secret. Membership changes require a documented cryptographic rekey strategy appropriate to the selected group protocol.

## 13. Public community

The application may present a built-in public community to subscribers after installation. It is optional and separate from private E2EE conversations.

First-run behavior:
- explain the community
- Join Now
- hide/remind later
- reminder choices: tomorrow, 3 days, 1 week, 2 weeks, 1 month
- maximum temporary suppression: one month
- optional permanent dismissal if product policy permits

Community has separate rules, moderation/reporting, mute, leave and notification controls. The UI must clearly distinguish public/community content from private E2EE conversations.

## 14. UI/UX direction

The interface must be premium, modern, professional, intelligence-oriented, visually rich and comfortable. It should not be a generic Messenger clone.

Visual language:
- dark-first premium surfaces
- restrained intelligence aesthetic
- strong typography hierarchy
- controlled accent system
- subtle gradients only where useful
- layered cards and security indicators
- meaningful status colors
- coherent iconography
- high contrast
- responsive layouts
- tablet-ready architecture

Avoid fake terminal/hacker decoration, excessive neon, arbitrary animation, generic stock dialogs and inconsistent components.

The intelligence character should come from information architecture, security visualization, typography, hierarchy and motion—not superficial military graphics.

## 15. Motion and interaction

Animations communicate state rather than decorate everything. Examples:
- message-send transition
- security-state microanimation
- recording waveform
- call connection
- verification transition
- upload/download progress
- session establishment
- online/offline transition

Support reduced-motion settings and target smooth performance on supported devices.

## 16. Home / Secure Command Center

The home screen should expose useful state without clutter:
- system security status
- secure channels
- active sessions
- recent activity
- pending transfers
- calls
- security alerts
- community
- quick actions
- global search/command entry

## 17. Chat interface

Required:
- modern message bubbles
- timestamps and delivery states
- encryption/security indicator
- replies and reactions
- attachments
- voice recorder
- camera/document shortcuts
- message search
- pinned messages where supported
- disappearing-message status
- secure chat header

Composer should have an expandable attachment tray and polished send/record interactions.

## 18. Security Center

This is a flagship product area.

Dashboard should show:
- overall security status
- identity status
- device status
- session health
- database protection
- prekey health
- recovery state
- screen protection
- notification privacy
- network state

Security audit shows passed checks, warnings, actionable remediation and last-audit time.

Security events may include new device, identity change, verification, session reset, failed authentication and security-setting changes. Never log message plaintext or secret material.

## 19. Privacy settings

Include:
- online status
- last seen
- read receipts
- typing indicators
- link previews
- media auto-download
- contact discovery policy
- profile visibility
- message previews
- call privacy
- group invitation policy
- blocked contacts
- disappearing-message defaults
- screenshot protection where platform-supported
- clipboard handling
- sensitive screen protection

Each setting must actually work or be clearly marked unsupported.

## 20. Security settings

Include:
- app lock
- PIN
- biometrics
- lock timeout
- lock on background
- lock on app switch
- hide content in recents where supported
- screen capture protection where supported
- security alerts
- identity verification
- session verification
- device management
- key rotation
- revoke all sessions
- secure local data cleanup
- security audit
- recovery

No fake toggles.

## 21. Network/service settings

Provide a connection center with connection status, configuration, retry policy, Wi-Fi/mobile transfer policy, background sync, transfer concurrency, call network preference and diagnostics.

Production infrastructure must be configuration-driven and never randomly hard-coded inside widgets.

## 22. Notifications

Modes:
- full content
- sender only
- generic notification
- silent
- disabled
- per-conversation
- per-group
- per-call

Sensitive content must not appear on lock screen unless explicitly enabled and supported by the OS.

## 23. Storage and data management

Provide storage center showing database, media cache, encrypted attachments, temporary files, drafts and cleanup opportunities. Explain limitations of secure deletion on flash storage/OS-managed storage; never promise impossible guarantees.

## 24. Backup and recovery

Backups must be encrypted before leaving the device. Recovery material must never be logged, uploaded as plaintext or stored as plaintext. Recovery phrase verification must validate exact positions when that is the selected workflow.

## 25. Search

Provide local search over messages, contacts, conversations, files, attachments, security events and settings. Do not create a remote plaintext search index for E2EE content.

A command-style search may support commands such as `Search messages`, `Open security center`, `Devices` and `Files`.

## 26. Offline-first synchronization

Support local drafts, queued encrypted messages, queued attachments, retry/backoff, deduplication, idempotent message IDs, conflict handling, ordering, reconciliation, persistent sessions and reconnect events.

Synchronization is based on encrypted objects and explicit state transitions.

## 27. WebSocket client protocol

The current protocol is not authoritative. Build a new versioned protocol with:
- authentication
- device registration
- session establishment
- encrypted message relay
- acknowledgements
- delivery/read events
- presence/typing state
- call signalling
- attachment signalling
- synchronization
- errors
- reconnect/heartbeat
- version negotiation

Events need type, protocol version, unique event ID, relevant device context and correlation ID where needed.

The future server will be built against this frozen contract.

## 28. Architecture

The current one-file architecture must be retired.

Target:

```text
lib/
  app/
  core/
    crypto/
    network/
    security/
    storage/
    errors/
    utils/
  data/
    database/
    models/
    repositories/
    datasources/
  domain/
    entities/
    repositories/
    usecases/
  features/
    onboarding/
    identity/
    home/
    messaging/
    contacts/
    groups/
    community/
    calls/
    media/
    security/
    settings/
    devices/
  services/
    websocket/
    notifications/
    background/
    connectivity/
```

`main.dart` must become a small application entry point.

## 29. Testing

Required layers:
- unit tests
- database tests
- serialization tests
- crypto wrapper tests
- protocol fixtures/test vectors
- malformed-input tests
- replay/duplicate tests
- skipped-message/out-of-order tests
- identity-change tests
- session-reset tests
- integration tests
- UI tests
- accessibility checks
- `flutter analyze`
- `flutter test`
- integration tests
- release build

Cryptographic features additionally require a documented protocol, threat model, fixtures/test vectors, key lifecycle and failure/reset tests.

## 30. Threat model

At minimum consider:
- malicious server
- compromised server database
- network observer
- stolen/lost device
- malicious contact
- compromised contact device
- replay attacker
- impersonation
- key substitution
- downgrade
- attachment tampering/malicious files
- notification leakage
- clipboard leakage
- screen capture
- local database extraction
- backup compromise
- multi-device compromise
- metadata leakage

For each threat document assumptions, security goal, mitigation and residual risk.

## 31. Secure defaults

Default posture:
- E2EE enabled
- conservative notification previews
- encrypted local sensitive state
- screen protection where supported
- conservative media auto-download
- security alerts enabled
- identity verification encouraged
- no plaintext diagnostics
- no analytics containing message content

## 32. Error handling and observability

Errors must be typed by network, authentication, crypto, database, permission, media, file, protocol, session, input and platform categories.

User-facing errors are understandable. Developer diagnostics are detailed but redacted.

Never log private keys, recovery phrases, session keys, message plaintext, decrypted attachments or authentication secrets.

## 33. Performance

Use pagination, lazy media loading, background/isolate work for CPU-heavy operations, efficient thumbnails, bounded memory, indexed queries and controlled reconnects. Never block the UI thread with expensive cryptographic or database operations.

## 34. Development phases

1. Specification and threat model.
2. Repository restructuring.
3. Design system and navigation.
4. Secure storage and database.
5. Identity and device management.
6. Cryptographic protocol implementation.
7. Session manager.
8. Messaging engine.
9. Offline synchronization.
10. Contacts and verification.
11. Private groups.
12. Public community.
13. Media/files.
14. Voice messages.
15. Voice/video calls.
16. Security Center.
17. Advanced settings.
18. Hardening and testing.
19. Client/server protocol freeze.
20. New server implementation.
21. End-to-end integration and release security review.

## 35. Definition of Done

A feature is complete only when implementation, UI, loading/error/empty states, accessibility, persistence, offline behavior, security implications, tests, analyzer and relevant integration/release checks are complete.

Security-sensitive features additionally require protocol documentation, threat model, test fixtures, key lifecycle and failure/reset behavior.

## 36. Final rule

SecureChat X 2.0 is a security product first and a messaging application second. Every feature must be coherent, secure, usable, testable, explainable and maintainable. The client is built first. The server is designed afterward from the frozen client protocol and data contracts.
