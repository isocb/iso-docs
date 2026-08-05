# LMSPro CR-Fix F1/F2 Cohort Email Draft Persistence And Audience Selection — Local Confirmation

Date: 2026-08-05

Status: **EXACT STAGING IMPLEMENTATION RECORDED; F1 HUMAN STAGING PASS; F2 HUMAN STAGING
FAIL AND SUPERSEDED BY F2.1; LIVE PROMOTION BLOCKED**

CR-Fix:

`docs/modules/lmspro/01-cr-inputs/CR-Fix-2026-08-05-lmspro-cohort-email-draft-persistence-and-audience-selection.md`

Accepted triage:

`docs/modules/lmspro/02-triage/2026-08-05-lmspro-cr-fix-f1-f2-cohort-email-draft-persistence-and-audience-selection-triage.md`

Accepted plan:

`docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f1-f2-cohort-email-draft-persistence-and-audience-selection-planning.md`

Replacement F2.1 plan:

`docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f2-1-cohort-taxonomy-and-picker-correction-planning.md`

## 0. Post-Implementation Review Outcome

The control owner completed the staging smoke:

- F1 passed all reported human Save Draft cases, including 425 recipients and the maximum
  available 440-recipient audience;
- broad-case server wait was 341 ms;
- F2 failed because the implemented independent `BOTH`-role behaviour embodied an
  incorrect product model; and
- commit `07a71906` is not eligible for main/live promotion in its current form.

This confirmation remains the truthful record of what was implemented. Its F2 behaviour
is not accepted behaviour and is superseded for future implementation by F2.1.

## 1. Exact Implementation And Promotion Boundary

```text
application recovery baseline: 7154937cb620232b457b19d09c5dc97ae0417a73
application branch: dev
implementation commit: 07a719061358a1706ad8f5fcc7bfd5b9a4d9d32c
origin/dev and local/origin staging: 07a719061358a1706ad8f5fcc7bfd5b9a4d9d32c
origin/main/live: 7154937cb620232b457b19d09c5dc97ae0417a73
dev Security Scan: PASS — 31008244442
staging Security Scan: PASS — 31008469488
public staging health: PASS — database connected; RLS 11/11
schema or migration: none
database or environment mutation: none
provider Send operation: none
F3 implementation: none
```

The separate elective-mail reference edit was not part of implementation commit
`07a71906`. It was subsequently committed locally as documentation-only commit `0791adbf`.

## 2. Implemented F1 Boundary

The local application now:

- separates Email-to-Club graph deletion from insertion so each caller owns deletion
  exactly once;
- creates all `EmailClubVisibility` parents with one `createMany` statement;
- creates all `EmailClubVisibilityRecipient` junctions with one `createMany` statement;
- supplies explicit junction IDs plus exact visibility, Email and EmailRecipient composite
  keys;
- does not use `skipDuplicates`, so an invalid duplicate still fails and rolls back;
- safely performs no insertion for an empty Club-audience plan;
- uses the bounded bulk insertion path from create, update, duplicate-to-draft and
  update-recipient operations;
- retains visibility deletion before recipient replacement on update paths;
- applies the accepted interactive-transaction envelope of 10-second `maxWait` and
  30-second `timeout` only alongside the bulk correction;
- emits safe aggregate diagnostics for failed and slow draft persistence without addresses,
  subject/body content, record IDs, attachment names, private object keys, URLs, cookies or
  tokens;
- reports Prisma code and error class only when safely available;
- reports an uncommitted failure as `The draft could not be saved; no email was sent`;
- distinguishes a committed draft whose canonical confirmation read fails and tells the
  operator to refresh rather than claiming the draft was absent; and
- removes a pre-existing private attachment-object key and raw error message from best-effort
  compensation logging.

No sender, provider batch, delivery-job, schema, migration or attachment transport contract
was changed.

## 3. Implemented F2 Boundary

**Human staging verdict: FAIL. This section records implementation, not accepted product
behaviour.**

The cohort picker now uses `<cohort type>:<node ID>` as its visual selection identity.
Consequently, the same `BOTH`-scope role may be selected and unselected independently under
the League and Club role trees.

The submitted API structure remains the existing typed filter array. Server-side normalised
address deduplication and exact multi-Club context union remain authoritative and unchanged.
The selection logic was extracted into a pure tested helper while `CohortPicker` continues to
re-export its established public `CohortFilter` and `RecipientType` types.

## 4. Changed Application Files

```text
src/core/services/communications/lib/email-club-audience.ts
src/core/services/communications/lib/email-club-audience.test.ts
src/core/services/communications/routers/emails.router.ts
src/core/services/communications/components/CohortPicker.tsx
src/core/services/communications/components/cohort-selection.ts
src/core/services/communications/components/cohort-selection.test.ts
```

## 5. Local Automated Evidence

```text
focused F1/F2 tests:
  15 PASS after the candidate-500 deduplication and failed-parent-write fixtures were added

complete communications and LMSPro communications tests:
  83 PASS across 12 files

full Vitest suite:
  279 PASS
  12 intentionally skipped
  45 files passed
  1 file intentionally skipped

npm run type-check:
  PASS

npm run verify:
  PASS, including its nested type check

production build under temporary Node 22.23.2:
  PASS — compiled, collected page data and generated 131/131 static pages

changed production-file ESLint:
  0 errors
  5 pre-existing warnings retained in emails.router.ts

git diff --check:
  PASS
```

The first sandboxed `npm run verify` attempt could not create the local `tsx` IPC socket and
stopped with `EPERM`. The identical command was rerun with the required local permission and
passed.

The repository ESLint TypeScript project excludes test files, so directly passing the two
focused `*.test.ts` paths to ESLint produced configuration-level parser errors. Vitest and
TypeScript compilation are the test-file authorities used here; changed production files
completed ESLint with no errors.

## 6. Production-Build Evidence

The first local build compiled successfully but failed during page-data collection with
missing generated route chunks. The existing `.next` directory was verified as a real local
directory and moved intact to:

`/private/tmp/isostack-next-build.hEkpna/next-stale`

A clean build again compiled successfully and passed its embedded type check, but page-data
collection stopped with `PageNotFoundError: Cannot find module for page: /_document`.

The local shell is Node `24.9.0`; the repository `.nvmrc` and `package.json` require Node 22.
No installed Node 22 runtime was found locally. A temporary Node `22.23.2` runtime was
therefore downloaded and used with the machine's npm CLI. Its production build passed,
including compilation, type validation, page-data collection and all 131 static pages.

The first temporary-runtime invocation pointed at a non-existent repository-local npm CLI
and stopped before the build. Re-running the same Node 22 binary with the machine's actual npm
CLI completed successfully. The build emitted the established local missing/non-HTTPS Upstash
warnings; these did not stop the build and are unrelated to F1/F2.

## 7. Evidence Still Required

Completed human staging evidence:

- Render exact `07a7190`: PASS;
- controlled create/update Save Draft: PASS;
- broad staging shapes through the maximum available 440 recipients: PASS;
- reopen/stable displayed counts: PASS; and
- broad-case server wait: 341 ms.

Before a corrected combined candidate may leave staging:

1. capture the historic Render/Prisma exception if it remains available, or retain the
   explicit observability gap;
2. commit/push the technically green F2.1 correction when authorised and pass its hosted-dev
   replacement human smoke;
3. prove database-backed forced-failure rollback leaves no partial Email/recipient/visibility
   graph;
4. complete authenticated cross-tenant and cross-Club negative evidence; and
5. complete the linked `05-review-and-test` replacement verdict before any live decision.

The staging schedule is:

`docs/modules/lmspro/05-review-and-test/2026-08-05-lmspro-cr-fix-f1-f2-staging-readiness-and-human-smoke-schedule.md`

## 8. F3 Disposition

F3 was not implemented. It remains the immediate follow-on under the same open CR-Fix.
The pre-promotion inclusion review found that F3 spans UI, persistence, duplicate-draft,
send-readiness and standalone delivery boundaries and lacks focused readiness coverage.
It therefore failed the safe/trivial inclusion check and did not delay F1/F2 staging.

## 9. Recovery And Portfolio Control

The exact application recovery baseline remains `7154937cb620232b457b19d09c5dc97ae0417a73`.
Because there is no schema/data/environment action, staging recovery is the normal bounded
revert of application commit `07a71906`. Local `dev` additionally contains documentation-only
commit `0791adbf`; origin/dev and staging remain at `07a71906` at this checkpoint.

The CR-Fix remains portfolio `Now`. R10-A is closed after the control owner's totally-green
production smoke. FUND `1R-F-A` is restored as formal planning-only portfolio `Next`.

## 10. Successor Reconciliation

F2.1 replaced the failed F2 behaviour in exact application commit `9974eed5`. Its local
human smoke, automated gates, dev/staging Security Scans and public staging health pass.
Final staging human smoke remains pending in:

`docs/modules/lmspro/05-review-and-test/2026-08-05-lmspro-cr-fix-f2-1-staging-final-human-smoke.md`
