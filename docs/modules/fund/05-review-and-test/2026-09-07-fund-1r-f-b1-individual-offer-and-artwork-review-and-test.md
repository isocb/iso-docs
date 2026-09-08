# FUND 1R-F-B1 — Individual Offer And Artwork Review And Test

Date: 2026-09-07

```text
Exact commit: 57e1454b530ae19dc586768fd996ff230d84421c
Files/change boundary: B1 four-model additive migration, offer/template/document services, C1/C2 routers and UI, existing-write guards, readiness blockers and tests; example/legacy credential sanitation only outside that runtime boundary
Automated checks: PASS; detailed checks and qualifications in the review/test record
Human evidence: authenticated C1/C2 smoke pending; synthetic component checks do not replace it
Environment proven: prior disposable tests plus user-authorised existing Neon DevData migration and localhost:3000 login/health checks; no staging/live promotion
Known residual risk: independent review and human acceptance pending; emulated PDF/private temporary storage do not prove production or physical-print suitability
Next authorised action: independent review of the exact candidate, then authenticated local C1/C2 smoke and recorded disposition before promotion
```

Control depth: **High**.

Disposition: **Automated validation PASS; independent review and human local acceptance pending; HOLD promotion**.
Exact application commit: `57e1454b530ae19dc586768fd996ff230d84421c` on `work/fund-b1-individual-offer` (published to the approved work branch).
Review scope: the [accepted B1 plan](../03-slice-planning/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-journey-development-plan.md)
and its [implementation confirmation](../04-implementation-confirmations/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-implementation-confirmation.md).
This is the implementing agent's separate source/evidence review, not a claim of independent
human acceptance or an independent agent review.

## Evidence

| Check | Result |
| --- | --- |
| Fixed template contract, 1/10/12 limits, duplicate/order refusal | PASS — focused unit tests |
| Deterministic PDF, unsupported text refusal, private file/path handling | PASS — focused unit tests |
| Disabled/default/production-target guards | PASS — focused unit tests |
| Connected B1 service journey | PASS on dedicated disposable databases, including extended rollback and both failed/available-document cleanup recovery cases |
| Existing E-D default Project/Store suite | PASS, including exclusions, eligibility, replay, rollback and zero fixture residue |
| Existing E-A Store authority suite | PASS when run alone, including intervention, idempotency, Client authority, Event dates and rollback |
| Existing E-C Client Store suite | PASS, including Client isolation, Store operations, commission and zero fixture residue |
| Existing 1R-D Store configuration/readiness suite | PASS when run alone, including immutable versions, tenant isolation, rollback and zero fixture residue |
| Existing Commerce A7 suite | PASS — atomic aggregate, idempotency/replay and zero fixture residue |
| Repository Vitest run | 81 suites passed, one skipped; local renderer suite initially failed Chromium sandbox launch, then its three tests passed with launch permission |
| TypeScript / repository verification | PASS on final committed candidate; required pre-commit type check also passed |
| Changed application lint | No errors; nine pre-existing warnings in the two existing Project components. New code clean |
| Production build | PASS on final committed candidate (131 pages) |
| Component browser checks | PASS — actual C1, over-capacity, confirmed and 390px mobile component, synthetic tRPC responses; no page errors/overflow |
| Independent review of exact candidate | **Pending** — implementing-agent checks do not close this gate |
| Authenticated C1/C2 human smoke | **Pending** |
| Staging/live/provider/physical print | **Not run** |

The retained legacy database suites now compare their ledgers with the current migration
inventory instead of hard-coding 141. Generic Store trading scenarios use the existing
Standard/bulk branch; B1 separately asserts the new Individual trading refusal. Historical
closed lifecycle evidence is not rewritten. Concurrent runs of separate suites against one
test database caused serialization conflicts; the affected suites passed when run alone,
without changing application transaction behaviour to conceal test contention.

## Negative And Recovery Boundaries

The B1 service proof covers wrong tenant, inactive access, non-organiser manager/viewer,
stale preview, duplicate/concurrent finalisation, existing C1/C2 write paths, immutable price
rows, upstream Product changes, render failure/timeout, lost/changed file, wrong regenerated
hash and canonical refusal of real trading. Expanded tests cover Event hierarchy, incomplete
aggregate rollback, scope/tenant constraints and retained-orphan cleanup recovery.

Source review corrections include explicit complete-aggregate checking before commit success,
private download cache headers, resetting confirmation when the preview changes, and retrying
orphan deletion even while the matching document remains available.

## Database And Cleanup Evidence

The original automated proof used no ordinary application database URL. The later owner-authorised local DevData preparation is recorded below. Parsed identities confirmed the configured
test endpoint differs from the application endpoint; new uniquely named databases were
created there for this task. The 153-migration baseline and additive B1 migration replayed,
reaching 154; a synthetic baseline record survived the upgrade.

Reproducible orchestration: `node scripts/run-fund-b1-disposable-tests.mjs`. It creates its
own databases, copies the baseline migrations, proves the upgrade and service cases, performs
fresh replay, then drops its databases and removes its temporary credential workspace.
Fresh 154-migration replay: **PASS**. All dedicated databases were removed; independent
TEST endpoint inventory readback found **zero** `fund_b1_disposable_%` databases. No existing
test database was reset. Temporary credential workspace, baseline and component files were
removed; the component server is stopped and its port independently verified closed.

## Publication And Credential Review

Chris explicitly approved both GitHub destinations, conditional on credential review.
The unpublished application commit was sanitized before publication: a credential-bearing
comment was removed from `.env.example`, four inherited database URLs in the legacy
application deployment guide were replaced with placeholders, and example Turnstile values
were cleared. Non-secret setting names and disabled/production defaults remain documented.
No actual environment file is included. Redacted pattern scans of candidate file contents
and comparison against local sensitive configuration values found no remaining credentials
in the changed files; broader connection-string matches were reviewed as placeholders.

Application commit `57e1454b530ae19dc586768fd996ff230d84421c` is independently verified on
`origin/work/fund-b1-individual-offer`. Runtime source and migration contents are unchanged
from the fully tested candidate; the sanitation changes only examples/legacy documentation.
The amended candidate passed the required pre-commit TypeScript check. No force push,
shared-history rewrite, deployment or credential rotation was performed. The removed
credentials remain in older Git history. Chris confirmed on 2026-09-07 that they had
already been rotated some time ago. This records owner confirmation; no live credential
validity test was performed and no further rotation is requested by this record.

## Local DevData Preparation — 2026-09-07

Chris requested use of the existing Neon database assigned to local development. Both local
configuration files and the effective Next development configuration identify DevData,
endpoint fingerprint `0970d1fe7a73`, distinct from configured staging and production.
Preflight found 153 completed matching-checksum migrations, no failed migration and only
B1 pending. Applied the existing committed migration through Prisma deploy, without reset,
seed or new migration generation. Independent readback: 154 completed migrations, all four
B1 tables and nine enabled triggers. Existing Project/Product/Store row counts and content
fingerprints were unchanged. Prisma client was regenerated.

B1 emulation is enabled with target local in ignored `.env.local` (mode 0600); credentials
were not changed. The app runs on loopback port 3000. HTTP checks: `/api/health` 200 with
database connected; `/auth/bedrock/login` 200; both protected FUND entry points redirect
unauthenticated requests to sign-in. The health endpoint also reports core-table RLS 0/11;
this local result is not an RLS PASS or staging security evidence. No RLS setting was altered.

Aggregate data check found zero active Individual Artwork Projects. No Client/organiser was
invented and no existing Project was reclassified. Choose the intended tenant/Client/organiser
and create a smoke Project through the UI, or provide that choice for assistant setup.
The old disposable databases remain removed; DevData is the retained user-designated local
test database. Local runtime remains running for the human test. No app branch promotion or
staging/live migration was performed.

## Human Local Smoke Schedule — Pending

Open `http://localhost:3000/app/fund/projects` and sign in normally as C1. If the server has
stopped, run `npm run dev` from `isostack-bedrock` on the B1 work branch; `.env.local` retains
the verified local configuration. Use **Create Project → Individual Artwork Project**,
select the intended Client and organiser, and supply the required dates. Use a dedicated
smoke Project because finalisation deliberately locks its confirmed offer.

For the C2 steps, sign in as that organiser through their own session and open
`http://localhost:3000/app/fund/client/projects`. Impersonation cannot finalise. On this
identified local development target with emulation enabled:

1. C1 assigns portrait, then compact, and checks Event versus standalone scope.
2. C2 confirms over-capacity feedback, resolves selection/configuration blockers and reviews
   the exact Products, prices and content. A non-organiser must not be able to finalise.
3. The organiser confirms the lock and finalises. Verify pending/available/failed states
   and that old selection/copy controls refuse changes to the confirmed offer.
4. Download and inspect the labelled PDF against the confirmed Store preview. Remove only
   the disposable emulator file and verify same-offer regeneration and understandable feedback.
5. Confirm public trading remains blocked and record the exact candidate and human result.

Record tester, date, exact commit, non-sensitive environment/role identifiers and PASS/FAIL
for each step, with defects linked here. No step above has an authenticated human PASS yet.

Until independent review and this human gate pass, the candidate remains on its work branch. No dev/staging/main
alignment of the new code, deployment or live service operation is claimed.


## Local Workflow Reference Repair — 2026-09-08

[CR-Fix](../01-cr-inputs/CR-Fix-2026-09-08-fund-local-workflow-class-reference-data.md):
Create Product had no choices for its mandatory Production Workflow Class. DevData had zero
reference rows despite the original migration being complete; this is missing reference
data, not a missing enum. Under accepted local smoke preparation, restored only the four
canonical INSERT rows from committed migration `20260623130000_add_fund_product_workflow_classes`.
Target fingerprint `0970d1fe7a73` was checked distinct from staging/production. The transaction
rechecked table emptiness under lock; no schema/ledger change, full seed, user-row update,
reset or application edit was performed. Application remains `57e1454b`.

Database repair/readback: PASS — A1, A2, B and C are active, system-default and read-only;
independent readback confirms the original migration marker remains complete. Cause/timing
of prior removal remains unknown. The modal's active-class query can now return these rows.
Authenticated UI Product creation: pending Chris's retry after refresh/reopening the modal.
For B1 Individual Artwork Products choose A1; Product Suitability remains separately required.


## Business-Model Finding — Captured 2026-09-08

Chris's local test/discussion identified a structural issue beyond the repaired empty dropdown.
The [refined Catalogue/workflow CR-Fix](../01-cr-inputs/CR-Fix-2026-09-08-fund-workflow-authority-and-product-suitability-separation.md) requires one reusable Product,
Catalogue-led availability, Event/Project workflow authority and no separate Product Suitability
veto. Manufacturing changes should require Catalogue changes only, not another Product edit.
This is an unresolved business acceptance issue; original automated PASS results are retained
without asserting the new requirement is implemented. CR disposition: captured, awaiting triage;
no corrective code/migration has run. Chris confirms no FUND users or existing data requiring
remedial conversion; staging schema migration is still required when implementation is selected.


### B1-R1 Triage Disposition — 2026-09-08

[Triage](../02-triage/2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-triage.md) and [detailed planning](../03-slice-planning/2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-planning.md)
are complete as documentation, with implementation acceptance pending. Correction is required
before B1 business closure. Existing automated results remain historical evidence for their
exact candidate; no corrected-code PASS is claimed. The owner confirmed four workflows,
Standard as unmodified Product, and Catalogue availability for standalone Projects. Proposed
selection/edit transition rules remain reviewable in the plan. No new 04/05 correction
completion records are created before implementation and testing occur.
