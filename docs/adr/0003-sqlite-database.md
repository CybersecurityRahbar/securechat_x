# ADR 0003: SQLite database foundation for Phase 3

**Status:** Accepted (2026-08-24)

## Context

Phase 3 replaces the legacy monolithic local persistence approach with a structured, indexed, testable relational database layer. The master specification explicitly prefers SQLite/Drift or another well-supported indexed solution after dependency review.

The client currently exposes a small database contract but intentionally has no real persistence implementation. We must introduce a production-capable relational foundation without coupling feature widgets to a database plugin or storing plaintext cryptographic secrets.

## Decision

Use SQLite through `sqflite` as the first concrete database adapter.

Selected versions for the current Flutter CI baseline:

- `sqflite: ^2.4.1` for the application runtime.
- `sqflite_common_ffi: ^2.3.7+1` as a development dependency for deterministic in-memory SQLite tests on the CI host.

The selected versions are compatible with the project's Flutter 3.47.1 CI baseline while avoiding the newer releases that require Dart 3.10/3.12.

The database layer will be split into:

1. a platform-independent application database contract;
2. a SQLite adapter;
3. a versioned schema/migration definition;
4. repository contracts and implementations above the adapter.

SQLite configuration will enable foreign-key enforcement and secure-delete behavior. WAL/performance decisions remain explicit and must not be treated as a cryptographic protection mechanism.

Sensitive cryptographic state is never stored as plaintext database columns. When a later phase needs persistent sensitive state, the value must be encrypted before entering the database and its encryption/key ownership must be documented by that phase.

## Initial schema scope

The first schema version establishes the relational ownership needed by later phases:

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

The schema is intentionally broader than the currently implemented feature set so later phases can add repositories without repeatedly redesigning ownership and foreign-key relationships. No later feature is considered implemented merely because its table exists.

## Migration policy

- Schema versions are monotonic.
- Every version has an explicit migration function.
- Migrations are tested from an empty database and, when a later version exists, from the immediately previous version.
- Foreign keys remain enabled during normal operation.
- Destructive migrations require a separate ADR and data-preservation analysis.
- No automatic destructive reset is permitted for a migration failure.

## Query and performance policy

Routine queries must use indexed predicates and bounded result sets. Repositories own pagination semantics. Large message/attachment collections must not be loaded without an explicit limit.

## Consequences

Positive:

- Real relational constraints and indexes are available before identity/messaging implementation.
- Database migrations can be tested without an Android emulator.
- Feature code can remain independent of the SQLite plugin.
- The schema provides a stable foundation for later repositories.

Trade-offs:

- SQLite persistence is not itself encryption.
- The project gains a runtime database dependency and its transitive platform packages.
- Database encryption remains a later security decision and must not be implied by this ADR.

## Rejected alternatives

### Drift as the first adapter

Drift is a strong option and remains viable for a later refactor if generated typed queries become valuable. It was not selected for this first implementation because introducing code generation, generated sources and additional build tooling at the same time as the initial schema would increase the surface for unrelated CI failures. The current priority is a small, explicit, testable database boundary.

### Hive / key-value persistence

Rejected because the master specification requires relational entities, foreign keys, indexes, pagination and transactions.

### Custom SQLite wrapper without a maintained Flutter plugin

Rejected because it would increase native maintenance and security surface without a clear benefit.
