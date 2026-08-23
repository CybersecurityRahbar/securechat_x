# SecureChat X 2.0 migration risk register

| Risk | Status | Phase 1 decision / owner action |
| --- | --- | --- |
| Legacy monolith mixed UI, crypto, persistence, transport, and media logic | IMPLEMENTED | Retired from the build. Do not import legacy code into the new layers without separate review. |
| Legacy secrets / identities may be insecure or semantically invalid | IMPLEMENTED | No legacy state migration is performed. A future migration must be explicit, opt-in, and independently reviewed. |
| Hive is not an approved Phase 3 database decision | PLANNED | The new `Database` contract is technology-neutral. Evaluate SQLite/Drift and encryption/key lifecycle before implementation. |
| Legacy remote endpoint and certificate assumptions | IMPLEMENTED | Removed from the executable application. Protocol endpoint configuration is intentionally absent until protocol design. |
| Android cleartext and legacy external storage | IMPLEMENTED | Cleartext and legacy storage flags have been removed. |
| Release signed with debug key | IMPLEMENTED | Debug signing was removed from the release type; CI/release owners must supply protected signing credentials. |
| Large dependency set masks obsolete or security-sensitive code | IMPLEMENTED | Removed legacy packages; future additions require ADR review. |
