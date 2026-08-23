# SecureChat X 2.0 threat model

**Status:** Phase 1 foundation. This document records security posture, not completed protocol guarantees.

| Threat | Current mitigation status | Notes and residual risk |
| --- | --- | --- |
| Malicious server / compromised server database | PLANNED | The client/server protocol and E2EE are deferred to Phases 5 and 18; a server can currently not be trusted with content or identity assertions. |
| Network observer or MITM | IMPLEMENTED (baseline) | Android cleartext traffic is disabled. Authentication, certificate policy, and E2EE are NOT IMPLEMENTED. |
| Identity substitution | NOT IMPLEMENTED | Identity lifecycle and explicit verification are Phase 4 and Phase 9 work. |
| Replay and downgrade | NOT IMPLEMENTED | Versioning boundary exists; authenticated envelopes and replay defenses await Phase 5. |
| Stolen device / rooted device | PLANNED | Secure storage, device integrity posture, lock policy, and recovery are not implemented. |
| Compromised contact | NOT IMPLEMENTED | No contact or verification implementation exists. |
| Backup compromise | NOT IMPLEMENTED | Backup and recovery are deferred; no recovery material is created or stored. |
| Notification and clipboard leakage | PLANNED | No notification or clipboard feature is active. Privacy defaults will be implemented with those features. |
| Attachment threats | NOT IMPLEMENTED | Attachments are not implemented. |
| Group membership threats | NOT IMPLEMENTED | Groups are not implemented. |
| Call signalling threats | NOT IMPLEMENTED | Calling/signalling are not implemented. |
| Metadata leakage | PLANNED | No transport runs in the Phase 1 shell. Metadata minimization requires the future protocol. |

## Current security controls

- **IMPLEMENTED:** no endpoints, credentials, or security claims are embedded in UI; cleartext Android traffic is disabled; the error model separates user-safe text from developer diagnostics. Bootstrap errors enter a bounded, in-process redacted diagnostics boundary; development emits only a fixed code, runtime type, and stack trace.
- **PLANNED:** platform-secure secret storage, encrypted database, identity, authenticated key establishment, ratcheting, transport authentication, notification privacy, and screen protection.
- **NOT IMPLEMENTED:** end-to-end encryption, identity verification, local encrypted database, recovery, messaging, calls, group security, and server protocol.
