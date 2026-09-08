# FUND B1-R1 — Catalogue Availability And Workflow Authority Review And Test

Date: 2026-09-08

Status: **Source review and automated application checks PASS; connected High-control proof, independent review and human acceptance pending.**

Candidate: application `cd72dd780c6fec5b784a00c03a5ebb38133b71ce`, branch `work/fund-b1-r1-catalogue-workflow`, based on B1 `57e1454b530ae19dc586768fd996ff230d84421c`.

## Review Result

The source candidate implements the accepted separation: Catalogues control Product availability and Event/Project type controls workflow. Repository searches found no live FUND Product Workflow Class, Product suitability or default-standalone dependency. The only retained `workflowClassCodeSnapshot` and `workflowClassNameSnapshot` fields are immutable FUND Order-line evidence, now populated from Project authority.

The reviewed transaction order takes the tenant availability lock before Project/Store locks for default selection, explicit selection, finalisation, checkout and Intake provisioning. Source-changing Catalogue and Product status operations take the exclusive form. Current eligibility is re-evaluated at Store refresh, finalisation and checkout, so last-source withdrawal does not depend on a stale UI cache.

No blocking source defect remains from this review. This is not yet the independent or connected database review required by High control.

## Automated Evidence

| Check | Result | Evidence limit |
| --- | --- | --- |
| TypeScript | PASS | Full `npm run type-check` |
| Production application build | PASS | `npm run build:skip-types`; all 131 static pages generated |
| FUND unit tests | PASS | 7 files, 26 tests; workflow exhaustiveness and first-initialisation selection included |
| Prisma schema validation | PASS | Non-connecting placeholder URL; no database mutation |
| Critical-file verification | PASS | Repository verifier and nested type check |
| Focused FUND lint | PASS with warnings | No errors in implementation files; configured test-file parser exclusions remain |
| Repository lint | Baseline FAIL | Existing errors outside FUND; does not supply a repository lint PASS |
| Whitespace and credential scan | PASS | No staged environment/credential/private-key/token match |
| Connected migration/integration/concurrency | PENDING | No database was changed in this implementation pass |

## Required Connected Proof

On an authorised disposable or local test database, record the exact endpoint fingerprint and migration ledger before work. Prove a fresh migration and a 154-to-155 upgrade with zero FUND Events/immutable evidence, then separately prove that Event rows, `NOT_SURE` Projects and immutable offer/Order evidence stop the contraction without partial application. Verify deferred Event/Project mismatch rejection, cross-tenant refusal, advisory-lock ordering and retry/idempotency behavior. Confirm unrelated module counts before and after and remove test residue.

Do not apply this migration to the user's current DevData without its own preflight: the user has created FUND test Events, and the fail-closed migration is expected to refuse unclassified existing Events. Decide whether to recreate that disposable FUND data or explicitly classify it through a reviewed migration transition; do not infer workflow from legacy Product rows.

## Human Smoke Schedule

1. Create one Ceramic Mug without a Product workflow field and add it to two Catalogues.
2. Create Events for each of the four workflows, assign Catalogues, and confirm linked Projects inherit the Event workflow with no editable conflict.
3. Create four standalone Projects and confirm all active standalone-capable Catalogues form the offered range without a default Catalogue flag.
4. Let C2 retain a subset. Add a Product to a source Catalogue and confirm it appears available but remains unselected.
5. Remove one of two sources and confirm continued eligibility. Remove the last source and confirm the selection remains visible as unavailable while finalisation/trading refuses.
6. Restore availability and confirm eligibility returns without reactivating a prior C2 exclusion.
7. Confirm Event workflow changes refuse after a linked Project; confirm a draft standalone workflow change succeeds only before publication, finalised offer and Orders.
8. Finalise the existing Individual offer and confirm its document, Product, price and workflow evidence remain unchanged across later Catalogue withdrawal.

Record role/tenant identity, exact candidate, database fingerprint, time and PASS/FAIL for each result. Human acceptance, staging migration, controlled promotion and live proof remain separate gates.
