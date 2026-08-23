# SecureChat X 2.0 — AGENTS.md

This repository is being rebuilt as SecureChat X 2.0. The authoritative product and architecture specification is:

`docs/SECURECHAT_X_2.0_MASTER_SPECIFICATION.md`

Read that document before making architectural or feature changes.

## 1. Mission

Build a production-quality Flutter/Android secure communications client first. The future server will be rebuilt to match the final client protocol. Do not allow the current broken server or current monolithic implementation to dictate the new architecture.

## 2. Non-negotiable rules

1. Do not invent cryptographic algorithms or proprietary security protocols.
2. Do not weaken security merely to make a feature work.
3. Do not claim a security feature exists unless it is actually implemented and tested.
4. Never store private keys, recovery phrases or session secrets in ordinary preferences or plaintext files.
5. Never log plaintext messages, private keys, recovery phrases, session keys, decrypted attachments or authentication secrets.
6. Never put business logic, crypto, database or network protocol logic directly into UI widgets.
7. `main.dart` must remain a small entry point after the migration; the old monolithic file is legacy code to be decomposed.
8. Never create settings toggles that do nothing.
9. Never hard-code production infrastructure into UI components.
10. Do not silently trust changed identities or devices.
11. Do not treat transport encryption as equivalent to end-to-end encryption.
12. Do not use a single static shared secret as a substitute for a documented group-encryption protocol.
13. Do not implement fake post-quantum, zero-knowledge or military-grade claims.
14. Do not add dependencies without reviewing maintenance, platform support and security implications.
15. Prefer established, mature cryptographic libraries and protocol constructions.
16. Every security-sensitive change requires tests.
17. Every feature requires error, loading and empty states where applicable.
18. Preserve protocol versioning and migration paths.
19. Keep UI, domain, data, crypto, network and platform responsibilities separated.
20. Do not delete existing functionality until its replacement and migration path are understood.

## 3. Workflow

Before a large change:

1. Read the master specification.
2. Inspect the relevant existing files and dependencies.
3. Explain the intended architecture/change in the task response.
4. Implement in small, reviewable units.
5. Run formatter/analyzer/tests appropriate to the changed area.
6. Run a release build for major milestones.
7. Report what changed, what was tested and any remaining limitations.

Do not make broad speculative rewrites without a clear phase/task boundary.

## 4. Current project strategy

The existing application is a legacy prototype. It contains useful ideas and code but must not be assumed correct. In particular, crypto, recovery, prekeys, session establishment, database access, WebSocket behavior, WebRTC signalling and settings must be independently validated before reuse.

Do not preserve an existing implementation merely because it already exists. Preserve it only if it satisfies the new architecture and security requirements.

## 5. Cryptography rules

- Treat cryptography as a separate subsystem.
- Use documented primitives and mature implementations.
- Separate identity keys, device keys, signing keys, prekeys, session state and message keys.
- Document key ownership and lifecycle.
- Use authenticated encryption for encrypted message/attachment payloads.
- Bind important protocol context through authenticated data where appropriate.
- Test malformed input, replay, duplicate messages, out-of-order delivery, skipped messages, identity changes and session resets.
- Never print secret material while debugging.
- Do not create custom KDFs, signature schemes, ratchets or encryption modes.
- Future post-quantum support must be versioned and algorithm-agile; do not invent PQ primitives.

## 6. Identity and recovery

Identity recovery must restore the intended identity or use an explicitly documented recovery hierarchy. It must never generate a new unrelated identity and call it recovery.

Signed prekeys must actually be authenticated by the identity/signing mechanism selected by the protocol. One-time prekeys require correct private/public lifecycle management and consumption tracking.

## 7. Database rules

- Use repositories/domain boundaries.
- Prefer indexed relational storage for large message datasets.
- Use migrations rather than destructive schema changes.
- Avoid unbounded scans on routine UI paths.
- Use pagination.
- Keep cryptographic session state protected.
- Never store plaintext recovery secrets.

## 8. Network rules

The future WebSocket protocol will be versioned and designed from the client first.

Separate:
- transport security
- authentication
- message E2EE
- session establishment
- synchronization
- delivery/read events
- presence
- call signalling
- attachment signalling

The server must not be treated as a source of message plaintext or private keys.

## 9. UI/UX rules

The UI must be premium, modern, professional and intelligence-oriented. Avoid generic messenger layouts, fake hacker terminals, excessive neon, arbitrary gradients and superficial military decoration.

Use a coherent design system with tokens for typography, spacing, surfaces, colors, radii, elevation, icons and motion.

Animations must communicate state and remain performant. Support reduced motion and accessibility.

Every screen needs intentional loading, empty and error states where applicable.

## 10. Security Center

Treat Security Center as a first-class feature, not a settings page. It must expose meaningful security state such as identity verification, device trust, session health, prekey health, database protection, recovery state and actionable security warnings.

## 11. Privacy

Minimize metadata and never add analytics that contain message plaintext or sensitive cryptographic material. Clearly document what is local and what requires server support.

## 12. Testing

At minimum, use:
- `flutter analyze`
- `flutter test`
- targeted integration tests
- release builds at milestone points

Security-sensitive modules require additional fixtures/test vectors and failure-mode tests.

Do not declare success because the project compiles. A feature is complete only when behavior, security, persistence, UX states and tests are complete.

## 13. Dependencies

Before adding a package, assess:
- maturity
- maintenance activity
- license
- Android support
- Flutter/Dart compatibility
- security relevance
- transitive dependency impact
- whether the package is actually necessary

For cryptographic dependencies, perform a deeper review and document why the selected library is appropriate.

## 14. Code quality

Prefer clear, explicit code over clever abstractions. Use strong typing, immutable models where practical, deterministic state transitions, dependency injection where useful, and small testable units.

Avoid:
- giant service classes
- global mutable state
- hidden side effects
- UI-driven database access
- UI-driven crypto operations
- duplicated protocol logic
- magic strings for security-critical message types

## 15. Git discipline

Keep changes reviewable. Use focused commits where practical. Do not commit generated build artifacts, secrets, credentials, keystores or local machine configuration.

Before major refactors, preserve the ability to understand or recover the old implementation through Git history rather than copying legacy code into the new architecture.

## 16. Phase discipline

Do not jump ahead casually. Work follows the master specification:

Phase 0 — specification/threat model
Phase 1 — repository restructuring
Phase 2 — design system/navigation
Phase 3 — secure storage/database
Phase 4 — identity/devices
Phase 5 — cryptographic protocol
Phase 6 — session manager
Phase 7 — messaging
Phase 8 — offline synchronization
Phase 9 — contacts/verification
Phase 10 — private groups
Phase 11 — public community
Phase 12 — media/files
Phase 13 — voice messages
Phase 14 — calls
Phase 15 — Security Center
Phase 16 — advanced settings
Phase 17 — hardening/testing
Phase 18 — client/server protocol freeze
Phase 19 — server implementation
Phase 20 — integration
Phase 21 — release security review

When a task belongs to a later phase, do not implement a shortcut that creates architectural debt in an earlier phase.

## 17. Definition of done

A task is complete only when:
- implementation is complete
- architecture boundaries are respected
- relevant UI states exist
- persistence works where required
- offline behavior is defined
- security implications are addressed
- tests exist and pass
- analyzer passes
- relevant integration checks pass
- no secrets are exposed
- documentation is updated where protocol/security behavior changed

For cryptographic work additionally require:
- protocol description
- threat assumptions
- key lifecycle
- test fixtures/vectors
- reset/failure behavior
- replay/out-of-order handling where applicable

## 18. First rebuild instruction

Before changing application behavior, perform a complete repository audit and produce a structured implementation plan. Do not rewrite `main.dart` blindly. Identify reusable code, obsolete code, security-critical defects, dependency issues, Android configuration issues, test gaps and migration risks. Then implement according to the current phase.
