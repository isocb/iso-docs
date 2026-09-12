# FUND 1R-F-B1 — Individual Offer And Artwork Review And Test

Date: 2026-09-07

Current review update — 2026-09-12: the disabled C2 finalisation report was diagnosed as
missing Product image/tax setup and absent Seller profile. Corrected code is committed at
`3379c4e994a225c78238b5aed1d114e94c7dbaf0`; its current evidence and authorised staging
promotion are recorded at the end. The approved synthetic staging Seller is prepared;
corrected C1/C2 human smoke remains pending. Earlier aggregate PASS is retained as history,
not proof of the reported finalisation/download path.
Subsequently the owner authorised a temporary tenant-logo Product image: staging association
and draft refresh/readback PASS, with zero offer reasons. The generic Media-library UX is
not accepted as the final design; media/gallery/options refinement is captured for triage.

### Original September 7 implementation evidence

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
led to B1-R1 implementation `51618485`. Its automated and connected proof PASS, and Chris
recorded human smoke steps 1–4 as PASS on 2026-09-10. Steps 5–7 exposed the B1-R2 Catalogue
scope, Event management and state-clarity findings, so remaining B1 business acceptance now
continues through the [B1-R2 review and test record](2026-09-10-fund-b1-r2-event-catalogue-workflow-scope-and-lifecycle-integrity-review-and-test.md).


## Technical Review And Corrections — 2026-09-12

```text
Exact commit: base 133a4638e2590a8405d3ce52d6d8c8a7c0336b5a plus uncommitted local corrections; no new candidate commit or promotion
Files/change boundary: Individual readiness responsibility, Project update transaction protection, disposable migration/service/race proof and focused readiness tests; no schema or applied migration edit
Automated checks: build PASS; full Vitest 533 PASS/12 skipped; application TypeScript and separate proof-script/test TypeScript PASS; changed application-source lint PASS; connected migration/service/concurrency proof, fresh 156 replay and verified cleanup PASS
Human evidence: staging focused steps 1–4 PASS reported at 133a4638; local corrections not yet human-tested; C2 confirms template assignment text but reports finalisation disabled; readiness diagnosis open
Environment proven: local Node 22 build/tests and isolated TEST_DATABASE_URL migration proof; staging and DevData not modified
Known residual risk: C2 disabled-finalisation smoke finding unresolved; no independent second-reviewer attestation; corrected candidate not promoted or accepted
Next authorised action: diagnose the C2 readiness finding, obtain focused human evidence and complete review before controlled promotion; main/live remains held
```

Control depth remains **High**. This is the requested dedicated source review and correction
pass by the current Codex agent, not an independent-agent or independent-human sign-off.
The review covered the accepted B1 plan, R1 contraction/availability contract, route/session
checks, C1/C2 assignment/finaliser authority, immutable evidence and recovery, authoritative
availability consumers and their transaction boundaries, and the repeatable proof runner.

### Findings and correction

1. **Incorrect action owner in readiness.** `INDIVIDUAL_OFFER_REQUIRED` was labelled C1
   although only the exact C2 organiser can finalise. It now identifies C2. Template setup
   and runtime preparation remain C1; no finalisation permission or trading gate changes.
2. **Stale disposable runner.** It excluded only migration 154 while including later
   migrations in the supposed 153 baseline, and still expected a fresh count of 154. It now
   builds the chronological pre-R1 baseline through B1 (154), verifies migration names and
   SHA-256 checksums, tests the four refusal cases, upgrades through the current source set,
   and tests a separate fresh replay. Original unchanged B1 153→154 additive evidence is
   retained above; today's migration focus is the R1/R2 contraction and upgrade.
3. **Project context save outside the availability boundary.** Workflow/Event edits could
   use preflight decisions without the planned shared availability lock. The update now
   acquires availability, ordered Event and Project locks; re-reads the Project, refuses a
   stale save, and repeats finalised-offer/publication/Order and changed-Event checks before
   updating. It preserves a concurrent edit instead of overwriting it using stale context.

The runner compares its test target with all configured application environments, uses only
randomly named newly created databases, forces fixture constraints before each migration
refusal, reads back unchanged schema/ledger/sentinel state, and drops only those databases
with independent absence checks. Error output excludes connection strings. Synthetic data
and private temporary execution files are test infrastructure, not application seed/reset.

### Proof scope and evidence limits

- Fresh 154 baseline/checksums, Event, `NOT_SURE`, finalised-offer and Order refusal cases,
  and sentinel-preserving 154→156 upgrade: PASS.
- Original B1 service/authority/recovery journey plus added catalogue race matrix and fresh
  156 replay/cleanup: PASS; runner exited 0.
- The race matrix exercises catalogue workflow/channel/archive, Product archive, membership
  inactive/removal, Event assignment inactive/removal and availability windows against
  finalisation; selection, Store refresh, checkout and context lock participation; and
  explicit timeout/retry and stale-save refusal. Contention may refuse with a serialization
  or transaction-timeout error, followed by a fresh retry; unexpected errors fail the test.
- No provider checkout is authorised: the proof uses fail-on-access provider doubles and
  requires development checkout refusal without Order/provider side effects.
- Initial proof attempts were not PASS: one synthetic Order fixture used invalid source
  identifiers; a later run stopped at membership contention with insufficient diagnostics.
  Both disposable databases were removed and their absence checked. The fixture and
  diagnostics/retry assertions were corrected before the successful final rerun.
- Full build passes with existing local Upstash-configuration warnings; this is not a new
  security-runtime readiness claim. The repository lint configuration excludes scripts and
  test files, so application-source lint and a separate TypeScript check of the proof/test
  files are reported accurately rather than calling ignored files linted.

### Focused human checks for the corrected candidate

After controlled promotion, check an unfinalised Individual Project identifies organiser
finalisation as **C2**. Save an allowed draft Project workflow/Event change and confirm the
saved context and eligible Products are correct; confirm a finalised Project remains locked.
No repeat of the complete unchanged staging matrix is requested. Chris confirms the assigned template name/capacity is visible in C2 Project → Store. That
text is assignment confirmation, not a visual artwork preview. B1 provides a Product/price
and content review summary when its readiness checks pass, then finalisation, generation
and download of the labelled development PDF. There is no pre-finalisation visual artwork
preview; the template editor and production-ready artwork remain outside this B1 emulator.

Chris subsequently confirmed the review checkbox is visible and ticked, but finalisation is
disabled. Source inspection establishes that the checkbox is shown only to the authorised
exact organiser; after acknowledgement, unresolved readiness reasons or a missing input
snapshot disable the button. The yellow readiness messages have been requested. This is an
open current-journey finding, not deferred preview work or a confirmed fix. Retain the earlier
aggregate staging PASS as reported evidence while qualifying finalisation/download acceptance
until this specific report is resolved.


### Final connected outcome and local candidate identity

The final runner exited **0**. All ten finalisation/withdrawal cases passed. Membership
inactivation and removal each returned `P2028` under contention; the transaction refused
safely, a fresh retry succeeded, and the locked offer remained unchanged. Selection,
Store refresh, checkout and context updates participated in the availability lock; explicit
selection lock timeout preserved state and allowed retry; a stale context save refused
without overwriting the competing edit. Development checkout created no Order and made no
provider calls. These are the tested cases, not a claim to every possible race permutation.

Fresh replay of all 156 migrations and exact ledger checksums passed. The runner removed
`fund_b1_disposable_c6aae1cd7df93c6f` and `fund_b1_disposable_8c790d14f6008ce7`, independently
read back zero matching databases, and removed its private execution workspace. No application
database, staging test bed, stored offer or real provider resource was changed.

The seven changed source/test files on base `133a4638` have manifest SHA-256
`361dded57cee2ee8b62da8e3d3e45abbff9c6bb2bf1cdfff0fbb11cd43b7b36f`
(sorted repository-relative paths, each followed by NUL, file bytes and NUL). This identifies
an uncommitted local candidate, not a deployable commit. Source/docs whitespace checks pass.
Credential-pattern review found only the deliberate `unused` database placeholder on
`invalid.invalid`; no environment file or credential value is included in the changes.
The runner references existing environment-variable names and supplies synthetic test-only
values; it does not embed application configuration. No commit or push was performed.


## C2 Disabled Finalisation — Diagnosis And Correction, 2026-09-12

Chris authorised resolving the blocker, committing and promoting to staging for his test.
Read-only transactions against configured staging and local databases identified real setup
gates. Staging Individual Project fingerprint `a15cde9b` has exact-organiser permission,
one selected Product and portrait template assignment. Its selected Product has no active
primary image and remains `UNCLASSIFIED` for tax; the organisation also has no Seller profile.
No application data was changed during diagnosis. Earlier aggregate PASS does not establish
successful finalisation/download for this current Project.

The Product editor was missing the image-assignment and existing tax-treatment controls.
Offer feedback collapsed actual Product reason codes into a generic refresh message, and
Store mutations did not invalidate the separate Individual journey query. These are genuine
UI/setup gaps; the server gates are retained.

Corrections add:

- C1 tax-treatment selection through the existing Product update contract; no assumed tax
  classification or new Product workflow gate.
- C1 primary-image assignment from the organisation's existing Media library. The existing
  Media page remains the upload surface. Assignment rejects C2 roles, foreign/unavailable
  Products, foreign files and unsupported MIME types. An availability lock, Product row lock,
  revision increment and audit share one transaction. Previous media rows remain referenced;
  changing the default does not delete evidence or rewrite finalised offers.
- A named **Before you can finalise this offer** panel with specific Product/Seller actions,
  a Store-and-offer refresh button, and an acknowledgement checkbox unavailable until there
  is a valid review snapshot. Store edits also invalidate the Individual journey query.

The new Seller requirement message is shown even while Product setup remains incomplete,
so resolving image/tax does not merely reveal another previously hidden prerequisite.
The existing payments UI only manages Stripe. A staging-only DRAFT synthetic Seller profile
with GBP and explicit test rates was approved by Chris and created as recorded below. No commercial
profile is fabricated or copied from live. A full Seller administration UI is not included.

Five focused image-boundary tests and the full suite pass: **538 passed, 12 skipped**.
Changed application-source lint passes. The first full-suite attempt could not launch Chromium
inside the sandbox; its permitted rerun passed. An initial proof-script inference error was
corrected with an explicit assertion-snapshot type. Build passed; repository verification is
rerun serially because overlapping it with Next generation caused transient missing generated
files. Connected proof now includes real C1 image assignment, revision increment, C2/tenant
refusals and unchanged media after an invalid request; its final outcome follows below.

The previously recorded seven-file manifest describes the earlier correction only. This
expanded candidate needs its own exact commit and deployment evidence before acceptance.


### Approved staging test Seller preparation

Chris explicitly approved one staging-only synthetic Seller profile. Target fingerprint
`2bb31924958a` was checked distinct from local and production targets. Under a transaction,
the operator matched the diagnosed Project, verified no Seller profile and no Commerce
Orders for its organisation, and created one profile plus an audit event. The profile is
labelled `FUND STAGING TEST SELLER - NOT FOR LIVE USE`, remains **DRAFT**, uses GBP and
approved test rates of 2000/500 basis points, and contains visibly synthetic address data.
A separate client/read-only transaction verified the profile and zero Orders. PASS.

No Product image, Product tax choice, Project, payment configuration, schema or live data was
changed. The fixture is intentionally retained for Chris's staging smoke; it is not business
configuration, a real seller verification, or permission to trade. Rollback, if requested,
removes only this labelled fixture after rechecking its identity, DRAFT status and absence of
Orders; never delete a subsequently used or edited profile without renewed review.


### Exact correction candidate checks

Application commit: `3379c4e994a225c78238b5aed1d114e94c7dbaf0` (16 source/test files).
Final production build, 538/12-skipped regression tests, changed-source lint, repository
verification and pre-commit TypeScript pass. Exact work-branch Security Scan `34687362802`
passes, including dependency, schema, TypeScript and secret jobs. No environment file or
credential is included; the only credential-pattern match reviewed locally is the deliberate
`unused` URL placeholder on `invalid.invalid` in the isolated runner.

The updated connected service suite passes with real C1 primary-image assignment, revision
increment, C2/foreign-tenant refusal and unchanged media after an invalid file request. The
existing B1 finalisation/document/recovery and ten-case availability matrix also pass. A
separate fresh 156 replay/checksums and cleanup also PASS; runner exited 0 and verified
absence of `fund_b1_disposable_0b10cf03c9f96d2a` and
`fund_b1_disposable_cb9de3537c8bd618`. Protected-branch/deployment evidence follows.
The dedicated source review here does not claim a separate human or second-agent attestation.


### Controlled promotion — 2026-09-12

The exact reviewed correction `3379c4e994a225c78238b5aed1d114e94c7dbaf0` was fast-forwarded
from the existing work branch into local dev, then pushed to origin/dev. The existing clean
local staging worktree pulled origin/staging, fast-forwarded dev and pushed origin/staging.
No direct remote-ref substitute, cherry-pick or main/live update was used. There are no new
schema/migration files relative to `133a4638`; the existing 156-migration bundle is unchanged.

Render staging deployment `dep-daii93ss728c73aj7tng` completed Live at that exact commit. Exact
protected-branch Security Scans dev `34687637710` and staging `34687647620` both PASS.
Service identity `Staging-IsoStack` / `srv-d4miroogjchc73balrvg`, type `web_service`, branch
`staging`, and expected artwork mode/target were read back before promotion. No provider
settings or shared environment group was changed. Deployment completion/health follows.

Supplemental TypeScript validation of the proof scripts and both new service test files also
passes against the committed candidate.


### Final staging evidence and handoff

```text
Exact commit: 3379c4e994a225c78238b5aed1d114e94c7dbaf0; local/online dev and staging aligned, work branch published
Files/change boundary: 16 FUND source/test files; Product tax/image controls, actionable offer feedback/refresh, readiness ownership, context-save protection and repeatable proof; no schema or runtime-setting change
Automated checks: final build; 538 tests PASS/12 skipped; application and supplemental TypeScript; source lint; repository verification; connected migration/image/offer/race proof; fresh 156 replay/checksums and verified cleanup; work/dev/staging Security Scans 34687362802/34687637710/34687647620 all PASS
Human evidence: corrected C1/C2 Product-setup/finalisation/download smoke pending; prior aggregate PASS retained with the later specific finding
Environment proven: exact Render staging deployment dep-daii93ss728c73aj7tng Live 2026-09-12T10:16:21.50129Z; both staging URLs HTTP 200 healthy, DB connected, RLS 11/11 at approximately 10:16:38 UTC; Product page redirects to sign-in and new image mutation refuses unauthenticated requests with 401
Known residual risk: corrected PDF walkthrough pending; subsequent authorised tenant-logo fixture resolves current image setup but does not complete the Product media UX; emulated PDF/private storage do not prove production artwork; no separate independent reviewer attestation; main/live remains security-only 0397bba9
Next authorised action: Chris performs the corrected staging smoke schedule in B1-R2 05; resolve findings before full B1 closure or any separate live decision
```

The pre-completion probes observed the old serving instance, including 404 for the then-absent
image endpoint; they were not counted as corrected-candidate proof. After Render reported
Live, both `staging.isostack.app` and `sating-isostack.onrender.com` passed health checks,
`/app/fund/products` redirected to `/auth/signin` (307), and the new image-assignment endpoint
returned 401 without a session. No authenticated browser or human visual result is invented.

Online ref readback confirms dev/staging at `3379c4e9` and main at `0397bba9`. No real payment,
public Store activation, main/live promotion, schema reset or Product selection was performed.
If staging rollback is required, the known prior serving code is `133a4638`; no reverse
migration is needed for this correction. Retain the separately approved DRAFT test Seller
unless its safe removal is explicitly selected and its unused status rechecked.

### Tenant-Logo Placeholder Verification — 2026-09-12

Exact application remains `3379c4e9`; no source, schema, deployment or live change.
The B1 04 confirmation records the explicitly authorised staging-only association and
atomic draft refresh.

Independent read-only verification: PASS — exact existing same-tenant light-logo MediaFile,
active PRIMARY role and temporary label; Product revision 3; existing STANDARD tax preserved;
one selected Product; C2 exact organiser can finalise; zero offer reasons; snapshot and input
hash present; no finalised offer or FUND Order. Transaction checks also preserved draft Store
status and null publication timestamp. This service readback used test emulation in the
temporary local process against staging data; it is not an authenticated browser result or
a change to deployed environment variables.

Refusal guards were inspected and passed their positive preconditions; no deliberately
invalid writes or rollback fault were injected into staging. Existing code-suite negative
proof is retained, not represented as new coverage for the one-off fixture. No full build
rerun was needed because application code is unchanged. Human finalisation/PDF smoke remains
pending in B1-R2 05. The current C2 Store panel does not render a Product gallery; image
presentation belongs to the captured refinement. The emulator does not render image artwork or prove
print layout. Keep the placeholder for this smoke; safe replacement must retain frozen
evidence and the underlying tenant logo.
