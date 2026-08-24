# SecureChat X 2.0 migration risk register

| Risk | Status | Phase 1 / Phase 3 decision / owner action |
| --- | --- | --- |
| Legacy monolith mixed UI, crypto, persistence, transport, and media logic | IMPLEMENTED | Retired from the build. Do not import legacy code into the new layers without separate review. |
| Legacy secrets / identities may be insecure or semantically invalid | IMPLEMENTED | No legacy state migration is performed. A future migration must be explicit, opt-in, and independently reviewed. |
| Hive is not an approved Phase 3 database decision | RESOLVED | ADR 0003 selects SQLite through sqflite. Hive remains excluded from the new architecture. |
| Database schema drift could corrupt or orphan local state | MITIGATED | Phase 3 uses versioned migrations, foreign-key enforcement, explicit indexes and migration/constraint tests. Destructive migrations require a separate ADR. |
| Plaintext sensitive state could leak through local persistence | MITIGATED | Schema uses encrypted blob fields for sensitive future state. Encryption ownership and key lifecycle remain separate security-phase responsibilities. |
| Unbounded database scans could degrade performance | MITIGATED | Database boundary enforces bounded limits and the roadmap requires indexed predicates and pagination. |
| Test-only database implementation could diverge from Android SQLite | MITIGATED | Schema tests execute against real SQLite through sqflite_common_ffi; Android runtime uses the sqflite adapter. |
| Legacy remote endpoint and certificate assumptions | IMPLEMENTED | Removed from the executable application. Protocol endpoint configuration is intentionally absent until protocol design. |
| Android cleartext and legacy external storage | IMPLEMENTED | Cleartext and legacy storage flags have been removed. |
| Release signed with debug key | IMPLEMENTED | Debug signing was removed from the release type; CI/release owners must supply protected signing credentials. |
| Large dependency set masks obsolete or security-sensitive code | IMPLEMENTED | Removed legacy packages; future additions require ADR review. |
