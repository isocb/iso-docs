# FUND B1-R1 — Catalogue Availability And Workflow Authority Review And Test

Date: 2026-09-08

Status: **Source review, automated checks and guarded DevData migration PASS; two human defects corrected at `8bda74f4`, retest and remaining gates pending.**

Candidate: application `8bda74f4` on branch `work/fund-b1-r1-catalogue-workflow`; parent implementation `cd72dd780c6fec5b784a00c03a5ebb38133b71ce`, based on B1 `57e1454b530ae19dc586768fd996ff230d84421c`.

## Review Result

The source candidate implements the accepted separation: Catalogues control Product availability and Event/Project type controls workflow. Repository searches found no live FUND Product Workflow Class, Product suitability or default-standalone dependency. The only retained `workflowClassCodeSnapshot` and `workflowClassNameSnapshot` fields are immutable FUND Order-line evidence, now populated from Project authority.

The reviewed transaction order takes the tenant availability lock before Project/Store locks for default selection, explicit selection, finalisation, checkout and Intake provisioning. Source-changing Catalogue and Product status operations take the exclusive form. Current eligibility is re-evaluated at Store refresh, finalisation and checkout, so last-source withdrawal does not depend on a stale UI cache.

No blocking source defect remains from this review. The local upgrade path is now proved on
DevData; this is not yet the independent, negative or concurrency review required by High
control.

## Resolved Local Isolation Incident

Candidate validation temporarily linked the isolated worktree to the original checkout's
`node_modules`. Running `prisma generate` for B1-R1 consequently replaced the generated
Prisma Client used by the user's running B1 localhost process. The unchanged B1 source then
failed its Product query because it requested the old `workflowClass` relation from the new
client metadata.

The shared link was removed, Prisma Client was regenerated from the original B1 schema, and
only the original checkout's localhost process was restarted. Client metadata readback again
showed `FundProduct.workflowClass`, and localhost returned an authenticated-route redirect.
No tracked application file or database row changed. Future candidate database-client
generation must use a fully separate dependency output and must not share the active
localhost checkout's generated Prisma Client.

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
| Connected DevData migration | PASS | Guarded 154-to-155 upgrade after authorised FUND-only test-data recreation; ledger and contracted schema read back |
| Connected integration/concurrency | PENDING | Failure cases, advisory-lock races and existing database suites have not been exercised |

## DevData Migration Evidence

The preflight recorded redacted target fingerprint `5a235762acc4`, proved the configured target
was local DevData and differed from staging/production, and found migration count 154. Two
Events, one Project and their supporting Client, Intake, delivery, Store and template-assignment
test rows were present. Products, Catalogues, Project Products, individual offers and Order
contexts were all empty. No table outside FUND referenced a FUND table.

Chris had already authorised recreation of development FUND data and confirmed there are no
FUND users requiring conversion. A single guarded operation cleared only the FUND-schema rows,
deployed `20260908120000_fund_b1_r1_catalogue_workflow_authority`, and read back its successful
ledger row. DevData now has the four exact workflow values, both new required columns, none of
the three retired Product workflow/suitability tables, and zero FUND rows ready for recreation.
Exact counts for every non-FUND application table remained unchanged, with comparison digest
`6635290daabf`. Local `/api/health` then returned HTTP 200 and `/fund/products` returned the
expected authenticated-route redirect on candidate `cd72dd78`.

## Human Findings And Corrections

The first Catalogue-assignment attempt on parent candidate `cd72dd78` failed in
`AvailabilityManager` with `null is not an object` while evaluating
`event.currentTarget.checked`. The checkbox handler passed the React event into a functional
state updater and read the target inside that later callback. Corrected commit `e00db199`
copies the checked boolean synchronously, then uses only that value in the updater.

Full `npm run type-check`, focused ESLint for `AvailabilityManager.tsx`, `git diff --check`
and the commit-time critical-file verification pass. The production build evidence remains
the parent candidate's full build; this one-handler correction has not been rebuilt while the
owner's localhost process is active. Human retry of Catalogue selection and Save remains
pending, so the schedule is not accepted.

The next Intake-form creation attempt at `e00db199` reached server validation with
`alignedScope: null`. Mantine permits selecting the current option again to deselect it by
default, even when the field has a valid initial value and no clear button. The server
correctly refused null rather than inferring Event or standalone authority. Corrected commit
`8bda74f4` prevents deselection of required scope, provisioning mode and fixed Project type
fields in both create and edit forms, marks them required and supplies client-side validation.
Full TypeScript, focused ESLint for both components and commit-time checks pass. Human creation
retry remains pending.

## Remaining Connected Proof

Prove the fresh migration separately, then prove that Event rows, `NOT_SURE` Projects and
immutable offer/Order evidence stop the contraction without partial application. Verify
deferred Event/Project mismatch rejection, cross-tenant refusal, advisory-lock ordering and
retry/idempotency behaviour. Run the relevant connected service suites. These gates and the
human schedule below remain open; the DevData upgrade alone does not complete High control.

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
