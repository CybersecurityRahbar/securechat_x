# SecureChat X 2.0 — Current Implementation State

This file is the operational checkpoint for the current repository state. It prevents phase drift and must be read together with the Master Specification and Implementation Roadmap before substantial changes.

## Authoritative references

1. `AGENTS.md`
2. `docs/SECURECHAT_X_2.0_MASTER_SPECIFICATION.md`
3. `docs/SECURECHAT_X_2.0_IMPLEMENTATION_ROADMAP.md`
4. `المحادثه الثانيه مفهرسه لمانعمله .txt`
5. `فهرسة المحادثه والاخطاء .txt`

## Current phase

**Phase 3 — Secure storage and database.**

Phase 0 and Phase 1 are complete. Phase 2 has passed its responsive/navigation milestone and is treated as the completed visual foundation. Phase 3 is now in progress. Do not jump to identity, cryptography, sessions, messaging engine, synchronization, or server implementation until the roadmap says the prerequisite phase is complete.

## Phase 0 — completed

- Repository audit and legacy classification.
- Threat model and migration risk register.
- Master specification and implementation roadmap.
- Decision to rebuild the client architecture inside the existing repository.

## Phase 1 — completed and CI validated

- Small `lib/main.dart` bootstrap entry point.
- App scope and dependency composition boundaries.
- Environment/configuration parsing.
- Typed failure hierarchy and redacted diagnostics boundary.
- Storage, database, crypto and transport contracts.
- Lifecycle/connectivity foundations.
- Android namespace/application identity and secure baseline.
- Flutter/Dart analyzer and test infrastructure.
- Android debug APK build validation in GitHub Actions.

Phase 1 contained interfaces/placeholders where later phases were deliberately not implemented. Those placeholders must not be converted into fake security or fake functionality.

## Phase 2 — completed milestone

### Design system

- Semantic colors, typography, spacing, radii, motion and icon tokens.
- Dark-first Material 3 theme foundation.
- Reusable surfaces, cards, buttons, icon buttons, text fields, section headers, metrics, status pills, dialogs, bottom sheets and state widgets.
- Security-status indicator with truthful states.
- Reduced-motion helper and animated switcher that respect the platform `disableAnimations` setting.
- Accessibility-oriented semantics for avatars, message bubbles and informational banners.

### Responsive/navigation foundation

- Compact/medium/expanded breakpoints.
- Responsive page insets and bounded content widths.
- Compact navigation with `NavigationBar` and a `More` destination when the full navigation set would overflow.
- `Devices` is a first-class foundation destination and appears in `More` on compact phones.
- Larger layouts use `NavigationRail` and expose foundation destinations.
- Compact navigation is tested at a real phone-sized viewport.
- Command palette presentation can navigate to foundation areas; content search remains deferred until database/messaging phases.

### Feature presentation

- Home / Secure Command Center foundation.
- Chats and Conversation presentation foundation.
- Contacts presentation shell with identity, fingerprint, verification and trust-state information architecture.
- Devices presentation shell with current-device, linked-device and device-security information architecture.
- Security Center presentation shell with identity, device, session, local-data, prekey and recovery checks plus future security-event history.
- Settings presentation shell with grouped privacy, security, network, notifications, storage, accessibility and appearance information architecture.
- Phase 2 screens continue to state clearly which functionality is not implemented yet.

### Phase 2 validation

- Responsive navigation and compact `More` destination tests were repaired until the milestone test suite passed.
- Analyzer and widget tests were brought back to a clean state before the milestone was closed.
- The expensive Android-emulator integration test remains separate from the fast CI path to avoid slowing every development commit.

## Phase 3 — currently implemented

### Database decision

- ADR 0003 selects SQLite through `sqflite` as the first concrete database adapter.
- `sqflite_common_ffi` is a development-only dependency for real SQLite schema and repository tests without an Android emulator.
- The selected versions intentionally remain compatible with the repository's Flutter 3.47.1 CI baseline rather than blindly selecting the newest Dart-SDK-constrained release.
- The Dart SDK floor is now aligned with the selected SQLite test dependency baseline.

### Database boundary

- `lib/data/database/database.dart` now exposes a platform-independent transactional database contract.
- Repository-facing queries, inserts, updates and deletes are bounded and independent of sqflite.
- Transactions receive a transaction-scoped executor so repository operations remain atomic.
- Pagination limits are explicitly bounded to 1..200.

### Schema and migrations

- `lib/data/database/sqlite_schema.dart` defines schema version 1.
- Relational tables exist for users, devices, contacts, conversations, members, messages, recipients, attachments/chunks, sessions, prekeys, groups, community state, calls/events, receipts, drafts, app settings and security events.
- Foreign keys and meaningful status constraints are part of the schema.
- Indexed predicates cover conversation/message timelines, queues, attachments, sessions, prekeys, calls and security events.
- Sensitive future state is represented by ciphertext/blob fields rather than plaintext secret columns.

### Concrete adapter

- `lib/data/database/sqlite_database.dart` implements the database boundary with sqflite.
- The adapter accepts an injectable `DatabaseFactory`, allowing the same production adapter to be exercised against real in-memory SQLite in CI tests.
- Database configuration enables foreign-key enforcement, secure-delete and a bounded busy timeout.
- Versioned create/upgrade hooks are explicit.
- The application bootstrap now initializes the database before showing the main application and presents a truthful failure state if initialization fails.

### Initial repositories

- `lib/data/repositories/local_state_repository.dart` contains bounded repositories for encrypted drafts and encrypted application settings.
- Repositories accept ciphertext rather than plaintext so the future encryption/key-storage phases remain responsible for cryptographic ownership.

### Phase 3 tests

- `test/sqlite_schema_test.dart` executes the schema against real SQLite through the FFI adapter.
- Tests cover table/index creation, foreign-key cascading, transaction rollback and pagination bounds.
- `test/local_state_repository_test.dart` exercises the real SQLite adapter plus draft/settings repositories for insert/update/read/delete behavior.
- Android integration startup now explicitly runs database migration before exercising the foundation UI.

## Explicitly NOT implemented yet

- Platform secure key storage / Android Keystore integration.
- Identity and device cryptographic lifecycle.
- Final cryptographic protocol.
- X3DH/Double Ratchet or a successor protocol.
- Session manager implementation.
- Real messaging engine and encrypted message queue.
- Offline synchronization.
- Contacts verification logic.
- Group encryption.
- Community backend/service.
- Media encryption/transfer.
- Voice messages.
- WebRTC calling and signalling.
- Production Security Center audit engine.
- Full actionable settings behavior.
- New server.

## Current execution rule

For every Phase 3 batch:

1. Read the authoritative documents and current files before changing architecture.
2. Review dependency compatibility before adding packages.
3. Define schema ownership and security boundaries before repository code.
4. Keep feature/UI code independent from SQLite APIs.
5. Never persist plaintext private keys, recovery material, session secrets or E2EE message plaintext.
6. Use foreign keys, indexes, bounded queries and explicit transactions.
7. Test migrations/constraints against real SQLite before depending on them.
8. Review imports, null-safety, API signatures and all call sites after interface changes.
9. Run format, analyzer, unit/widget tests and Android debug build in fast CI.
10. Fix all CI failures before adding a dependent feature slice.
11. Update this checkpoint after each coherent batch so the next session cannot lose the project position.

## Next planned sequence

1. Complete Phase 3 repository coverage for the remaining local-state entities required before identity.
2. Add migration upgrade tests when a second schema version is introduced.
3. Add secure-storage integration only after its platform/key-lifecycle design is reviewed.
4. Add database integrity/repair handling and bounded cleanup jobs.
5. Close Phase 3 only after migration, repository, pagination and sensitive-state tests satisfy the roadmap exit criteria.
6. Only then begin Phase 4 identity and devices.

This checkpoint does not replace the authoritative Master Specification or Roadmap. It records the repository's current implementation state only.
