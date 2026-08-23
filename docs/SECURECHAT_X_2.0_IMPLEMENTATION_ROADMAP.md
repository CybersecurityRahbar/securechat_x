# SecureChat X 2.0 — Implementation Roadmap

This roadmap converts the master specification into executable phases. The current server is intentionally out of scope until the client protocol is frozen.

## Phase 0 — Audit, specification and threat model

Goal: understand the current repository without making destructive changes.

Tasks:
- inventory all files, packages and Android configuration
- inspect current `main.dart` and all source files
- inspect tests and build configuration
- map current features to the master specification
- classify code as reusable, refactorable, obsolete or security-critical
- identify all crypto, database, WebSocket, WebRTC and recovery defects
- document dependencies and migration risks
- produce target architecture and migration plan

Exit criteria:
- complete repository audit
- threat model
- dependency assessment
- target folder map
- migration sequence
- no unexplained architectural blockers

## Phase 1 — Repository restructuring

Goal: establish clean boundaries without attempting to finish features.

Tasks:
- create app/core/data/domain/features/services structure
- establish routing and dependency boundaries
- establish error model
- establish configuration model
- create test structure
- isolate legacy code
- reduce `main.dart` to an application entry point when safe

Exit criteria:
- clean architecture skeleton
- analyzer passes
- application can start
- legacy behavior remains isolated

## Phase 2 — Design system and navigation

Goal: build the visual foundation before rebuilding feature screens.

Tasks:
- typography
- colors/theme
- spacing
- surfaces/cards
- buttons
- status indicators
- navigation
- dialogs/sheets
- message components
- security components
- motion system
- accessibility

Exit criteria:
- reusable design system
- responsive navigation
- light/dark strategy if retained
- reduced-motion support
- no feature-specific random styling

## Phase 3 — Secure storage and database

Goal: replace fragile local persistence with a structured, testable database layer.

Tasks:
- database schema
- migrations
- indexes
- repositories
- encrypted sensitive state
- secure storage integration
- attachment metadata
- drafts
- settings

Exit criteria:
- migrations tested
- pagination tested
- repository tests pass
- no unbounded routine scans

## Phase 4 — Identity and devices

Goal: establish the real identity foundation.

Tasks:
- identity generation
- device identity
- secure key storage
- signed prekey lifecycle
- one-time prekey lifecycle
- recovery design
- device registration state
- linked devices UI

Exit criteria:
- identity lifecycle documented and tested
- recovery does not create a false identity
- private keys never enter ordinary storage/logs

## Phase 5 — Cryptographic protocol

Goal: implement the selected established protocol architecture.

Tasks:
- cryptographic abstraction layer
- key agreement
- identity authentication
- prekey bundle
- session establishment
- AEAD envelope
- protocol versioning
- replay/downgrade protections

Exit criteria:
- documented protocol
- test vectors/fixtures
- malformed/replay tests
- key lifecycle tests

## Phase 6 — Session manager

Goal: robust multi-session ratcheting state.

Tasks:
- session persistence
- sending/receiving chains
- ratchet state
- skipped messages
- out-of-order delivery
- reset
- key rotation
- post-compromise recovery where supported

Exit criteria:
- deterministic state transitions
- persistence/restart tests
- out-of-order/replay tests

## Phase 7 — Messaging engine

Goal: reliable encrypted text messaging independent of final server implementation.

Tasks:
- message domain model
- local queue
- encrypted envelope
- status lifecycle
- replies/reactions
- pagination
- drafts
- deletion/expiration policies

Exit criteria:
- local message lifecycle works
- offline queue works
- UI reflects all states

## Phase 8 — Offline synchronization

Goal: make the app resilient to connectivity loss.

Tasks:
- reconnect manager
- retry/backoff
- deduplication
- idempotency
- reconciliation
- event ordering
- synchronization protocol models

Exit criteria:
- airplane-mode tests
- reconnect tests
- duplicate/reordered event tests

## Phase 9 — Contacts and verification

Goal: secure trust relationships.

Tasks:
- contact identity
- fingerprints
- QR verification
- verified state
- identity change warnings
- device verification
- block/revoke/reset

Exit criteria:
- verified identity changes are never silently trusted
- verification flows tested

## Phase 10 — Private groups

Goal: real group architecture.

Tasks:
- group lifecycle
- roles
- membership
- invites
- cryptographic group-key strategy
- rekey on membership change
- disappearing messages
- permissions

Exit criteria:
- documented group protocol
- membership-change tests

## Phase 11 — Public community

Goal: optional built-in community experience.

Tasks:
- first-run invitation
- join/leave
- hide/remind controls
- one-month maximum temporary suppression
- moderation/reporting UX
- notification controls

Exit criteria:
- community clearly separated from private E2EE chats
- reminder behavior tested

## Phase 12 — Media and files

Goal: secure attachment pipeline.

Tasks:
- attachment encryption
- thumbnails
- chunking
- resumable transfer
- integrity verification
- cache lifecycle
- cleanup

Exit criteria:
- image/video/document/arbitrary file flows work locally
- interrupted transfer recovery tested

## Phase 13 — Voice messages

Tasks:
- recorder
- waveform
- playback
- encrypted attachment pipeline
- background/permission handling

## Phase 14 — Voice and video calls

Tasks:
- WebRTC integration
- call state machine
- signalling abstraction
- incoming/outgoing calls
- reconnect
- audio/video controls
- call history

Exit criteria:
- client call state machine works independently of server implementation
- signalling contract documented

## Phase 15 — Security Center

Tasks:
- security dashboard
- audit engine
- device/session health
- identity state
- prekey health
- database state
- recovery state
- actionable warnings
- security event history

## Phase 16 — Advanced settings

Tasks:
- privacy
- security
- notifications
- network
- storage
- calls
- messaging
- accessibility
- appearance

Every setting must have real behavior.

## Phase 17 — Hardening and testing

Tasks:
- threat-model review
- dependency review
- static analysis
- crypto tests
- integration tests
- UI/accessibility tests
- performance profiling
- crash/failure handling
- release build

## Phase 18 — Client/server protocol freeze

Only after the client architecture is stable:
- freeze WebSocket event schema
- freeze authentication contract
- freeze synchronization contract
- freeze attachment protocol
- freeze call signalling contract
- freeze error codes
- document server requirements

## Phase 19 — New server

Build a new server against the frozen client protocol. Do not retrofit the client to the old server.

## Phase 20 — End-to-end integration

Tasks:
- real authentication
- message relay
- delivery/read events
- synchronization
- attachments
- calls/signalling
- community
- multi-device
- failure recovery

## Phase 21 — Release security review

Final review:
- threat model
- cryptographic design
- key lifecycle
- privacy/data retention
- logging
- permissions
- Android hardening
- backup behavior
- dependency audit
- penetration/security testing where available
- release build validation

No production release before this phase is complete.
