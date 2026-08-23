# ADR 0001: Phase 1 uses Flutter core and explicit architecture boundaries

**Status:** Accepted (2026-08-23)

## Context

The legacy prototype used many packages and placed persistence, cryptography, network protocol and presentation code in one file. The protocol, database technology, identity lifecycle, and final state needs have not yet been approved.

## Decision

Phase 1 uses Flutter's built-in navigation and `InheritedWidget` composition, typed contracts, a bounded redacted diagnostics boundary, and a small reusable visual foundation. It deliberately does not add a state-management, database, cryptography, transport, secure-storage, or telemetry implementation. Interfaces define the future boundaries, and phase-owned implementations will be selected through subsequent ADRs.

## Consequences

The shell is runnable and navigable but has no messaging, identity, encryption, persistence, server, or call behavior. This prevents false security claims and avoids carrying insecure legacy state into the new product.
