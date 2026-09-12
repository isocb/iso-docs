# FUND B1-R1 — Catalogue Availability And Workflow Authority Review And Test

Date: 2026-09-08

Status: **Local human smoke PASS reported by Chris on 2026-09-10 after B1-R2; independent review and remaining connected/promotion proof remain open.**

Candidate: application `51618485` on branch `work/fund-b1-r1-catalogue-workflow`; parent implementation `cd72dd780c6fec5b784a00c03a5ebb38133b71ce`, based on B1 `57e1454b530ae19dc586768fd996ff230d84421c`.

Retest candidate: local application `29104b55` with DevData migration 156. Chris marked all
13 steps below PASS on 10 September and confirmed in conversation: “Fund testing all green”.
This is owner-reported local evidence; the earlier `51618485` source/automated results and
initial failures remain historical evidence, not proof of a combined security/FUND candidate.

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
| Production application build | PASS | Exact `51618485` source: `npm run build`; full type check and all 131 static pages generated |
| FUND unit tests | PASS | 7 files, 26 tests; workflow exhaustiveness and first-initialisation selection included |
| Prisma schema validation | PASS | Non-connecting placeholder URL; no database mutation |
| Critical-file verification | PASS | Repository verifier and nested type check |
| Focused correction lint | PASS | Five changed C2 service/component files, zero warnings |
| Repository lint | Baseline FAIL | Existing errors outside FUND; does not supply a repository lint PASS |
| Whitespace and credential scan | PASS | No staged environment/credential/private-key/token match |
| Connected DevData migration | PASS | Guarded 154-to-155 upgrade after authorised FUND-only test-data recreation; ledger and contracted schema read back |
| Connected integration/concurrency | PARTIAL PASS | Combined B1 service/recovery/authority suite and B1-R2 Event race pass; remaining R1 contraction guards and availability races are identified below |
| Local runtime | PASS | `/api/health` HTTP 200; C2 Projects route expected HTTP 307 authentication redirect on localhost:3000 |

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

The following C2 Project test at `8bda74f4` was blocked before Product selection. The create
modal allowed Event and workflow to appear independently editable, despite Event being the
authority for a linked Project, and Product selection was obscured inside the Store surface.
Corrected commit `2cfc89fa` puts Event first, displays its workflow read-only when selected,
retains a required four-choice workflow input only for standalone Projects, and redirects a
successful create to Project detail. Project detail now opens on a dedicated Products tab,
where an authorised C2 user can select or remove the eligible Catalogue-derived subset and
see Products that have lost their final Catalogue source. The Store tab retains Store
visibility and Order controls.

Exact-candidate `npm run build`, full TypeScript, focused zero-warning ESLint, all 7 FUND test
files/26 tests, `git diff --check`, critical-file verification and credential-pattern checks
pass. Local health and authentication-boundary checks pass on port 3000. Human proof of the
correct Event-linked and standalone paths remains pending.

The next screen appeared to show an active Event Catalogue with no way to select its Product
or activate the Project. Redacted connected DevData readback proved the exact state: Event
`wf1`, Catalogue `Cat1`, assignment and membership were active; Product `MugTest` was `DRAFT`;
the Project was `DRAFT` with no Product membership; and its organiser was an active C2
`PROJECT_MANAGER` with dashboard access. Project Manager already has the same Project/Product
mutation authority as C2 Admin. C2 self-elevation is correctly absent; C1 manages Client users
on Client detail's Users tab.

The eligibility implementation had collapsed an active Catalogue with zero active Products
into the same warning as no active Catalogue source. Candidate `51618485` retains that empty
source Catalogue and reports the correct no-active-Products condition. The Products tab shows
source Catalogue codes and tells C2 that C1 must activate the Product. It also shows the current
C2 access level. Project activation/pause/resume now appears at the top of Project detail and
has been removed from the unrelated Store-controls card.

After Chris activated the Product, connected readback returned source `Cat1`, eligible Product
`MugTest`, no selected Product and no warning, which is the correct pre-selection state. Exact
source passes the full build, TypeScript, focused zero-warning ESLint, 7 FUND files/26 tests,
critical-file verification, whitespace and credential-pattern checks. Human button selection
and activation remain pending.

On 10 September Chris passed Intake creation, Catalogue assignment/Save, Product creation,
Event-linked C2 Project creation and standalone C2 Project creation. The four-workflow exercise
then exposed that Catalogue `availabilityScope` distinguishes Event/standalone channels but does
not distinguish the four workflows. Current standalone eligibility therefore offers every
active standalone-capable Catalogue to every standalone workflow. This is consistent with the
B1-R1 plan, but does not meet the clarified requirement that C1 should curate workflow-compatible
Catalogues. The Event workflow should filter the assignable Catalogue candidates; a standalone
Project workflow should filter its automatic Catalogue source union.

The same walkthrough showed that Event-to-Catalogue assignment is available only through the
Product/Catalogue Availability screen. Chris requires the same assignment to be manageable from
an Event Products tab, while retaining the current Product/Catalogue surface. The Event tab is a
selector and read-only contributed-Product view; it does not manage Catalogue scope or Product
membership. This pulls the already-recorded `2R-EVENT-05` intent into the blocking correction.

Catalogue Product management also obscures two separate states. Draft Products are intentionally
eligible for Catalogue preparation and remain correctly excluded from Project eligibility, but
the table labels active membership as `Status` and does not show Product status. This made a draft
Product appear active. The correction must show `Product status` and `Membership` separately,
include draft state in the add selector and explain that C1 Product activation is still required.

Finally, Event smoke proved that the current service permits DRAFT or ACTIVE Events to archive,
and permits an ACTIVE Event to close while linked Projects remain ACTIVE. Chris rejects all three
paths: Event archive is only valid after close, and close must refuse until active linked Projects
are resolved. Because these are server authority and concurrency rules, UI button changes alone
are insufficient.

These findings are captured in the [B1-R2 CR-Fix](../01-cr-inputs/CR-Fix-2026-09-10-fund-event-catalogue-workflow-scope-and-lifecycle-integrity.md),
[triage](../02-triage/2026-09-10-fund-b1-r2-event-catalogue-workflow-scope-and-lifecycle-integrity-triage.md)
and [bounded plan](../03-slice-planning/2026-09-10-fund-b1-r2-event-catalogue-workflow-scope-and-lifecycle-integrity-planning.md).
Testing initially paused against the old contract. Chris subsequently recorded the corrected
B1-R2 retest and resumed B1-R1 schedule as PASS on 2026-09-10; the findings above are retained
as the reason for the correction.

## Connected Proof Update — 2026-09-10

The combined security/FUND candidate has now passed a fresh 154-migration baseline replay,
the guarded 154-to-156 upgrade and unrelated-organisation sentinel preservation on dedicated
temporary test databases. A separate fresh 156-migration replay also passed; both created
databases were dropped and their absence verified. An existing Event refused migration 155 and left its schema
unchanged. The B1 service suite passed at migration 156 after its stale test-only ledger
expectation was corrected from 154. It proves Event hierarchy, tenant/scope constraints,
exact-organiser finalisation, concurrent replay, immutable legacy paths, private document
access, failed-cleanup and timeout/retry/lost-file recovery, and production emulation refusal.

This does not claim the remaining `NOT_SURE` Project and immutable offer/Order contraction
guards, or every Catalogue availability advisory-lock race, were exercised. Those remain
open unless separately evidenced; B1-R2 already records its narrower Event close/activation
race PASS. See [B1-R2 promotion evidence](2026-09-10-fund-b1-r2-event-catalogue-workflow-scope-and-lifecycle-integrity-review-and-test.md)
for cleanup, final exact commit and staging results. Chris authorised dev/staging promotion;
separate review and later FUND live approval remain distinct. Human schedule PASS below is
retained and does not silently complete all High-control proof.

## Human Smoke Schedule

1. Retry Intake creation and Catalogue assignment/Save, confirming the two earlier interaction corrections. **Chris 10/09/26: PASS.**
2. Create one Ceramic Mug without a Product workflow field and add it to two Catalogues. **Chris 10/09/26: PASS.**
3. From C2, create an Event-linked Project: select Event first, confirm its workflow is inherited and read-only, then confirm creation opens Project detail on Products and displays the current C2 access level. **Chris 10/09/26: PASS.**
4. From C2, create a standalone Project and choose one of the four workflows; confirm creation opens the same Products surface. **Chris 10/09/26: PASS.**
5. Create Events for each of the four workflows, assign Catalogues, and confirm linked Projects inherit the Event workflow with no editable conflict. Initially BLOCKED by Catalogue workflow scope; captured as B1-R2. **Chris 10/09/26: retest PASS.**
6. Create four standalone Projects and confirm active, workflow-compatible, standalone-capable Catalogues form the offered range without a default Catalogue flag. The original all-workflows rule is superseded by B1-R2. **Chris 10/09/26: PASS.**
7. On the Products tab, confirm an active Catalogue containing only draft Products gives a C1 Product-activation message; activate the Product as C1, then let C2 select the now-eligible subset. Initially FAIL on Catalogue-editor state clarity; B1-R2 separates Product status from membership and explains draft preparation. **Chris 10/09/26: retest PASS.**
8. Use the top-level Project action to activate the Project and confirm the server reports any remaining readiness gate clearly. Initially PAUSED for B1-R2 and clarification of B1/Store readiness gates. **Chris 10/09/26: retest PASS.**
9. Add a Product to a source Catalogue and confirm it appears available but remains unselected after initial selection. **Chris 10/09/26: PASS.**
10. Remove one of two sources and confirm continued eligibility. Remove the last source and confirm the selection remains visible as unavailable while finalisation/trading refuses. **Chris 10/09/26: PASS.**
11. Restore availability and confirm eligibility returns without reactivating a prior C2 exclusion. **Chris 10/09/26: PASS.**
12. Confirm Event workflow changes refuse after a linked Project; confirm a draft standalone workflow change succeeds only before publication, finalised offer and Orders. **Chris 10/09/26: PASS.**
13. Finalise the existing Individual offer and confirm its document, Product, price and workflow evidence remain unchanged across later Catalogue withdrawal. **Chris 10/09/26: PASS.**

Chris has now reported the resumed local schedule green. The [B1-R2 record](2026-09-10-fund-b1-r2-event-catalogue-workflow-scope-and-lifecycle-integrity-review-and-test.md)
records the aggregate human result and its evidence limits. Independent review remains open.

The report supplies the date and checklist results; no additional per-step timestamps or
role/tenant evidence are invented. Staging migration, controlled promotion and live proof
remain separate gates.


## Remaining Technical Proof — 2026-09-12

Chris authorised the outstanding technical review and corrections. On local base `133a4638`
plus uncommitted changes, the repaired disposable runner now passes the Event, `NOT_SURE`,
finalised-offer and Order migration-refusal cases. Each fixture satisfied database constraints
before full migration execution; refusal preserved the schema, exact ledger and unrelated
sentinel. The 154→156 upgrade and separate fresh 156 replay/checksums pass. Both temporary
databases were removed and their absence independently verified; runner exit 0.

The ten-case finalisation race matrix covers Catalogue workflow, channel and archive,
Product archive, membership inactivation/removal, Event assignment inactivation/removal and
future/expired availability windows. It proves lock waiting, refusal of new selection after
withdrawal, and preservation of confirmed evidence through withdrawal/restoration. Membership
writers may time out safely (`P2028`); fresh retry succeeds. Selection, Store refresh,
development checkout and Project context saves also participate in the lock. Explicit
selection timeout/retry and stale-save refusal pass. No Order/provider side effects occurred.
This closes the previously unproved listed contraction guards and records this exact race
matrix; it does not claim every possible interleaving or independent reviewer sign-off.

Review found Project workflow/Event saves needed an availability lock and in-transaction
revalidation. That correction, the C2 finalisation responsibility label and the repaired proof
runner remain local and uncommitted. Build, 533 unit tests, application/supplemental TypeScript
and changed application-source lint pass. See the [B1 technical review](2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-review-and-test.md)
for exact manifest, failed-attempt history, cleanup and focused follow-up checks.

Staging/DevData are unchanged. Chris's subsequent C2 report confirms assigned template text
but a disabled finalisation button despite acknowledgement; its readiness diagnosis remains
open. This qualification is recorded in B1/B1-R2 and does not erase the earlier human results.


The subsequent corrected candidate `3379c4e9` re-passes this connected matrix with the C1
image-assignment boundary included and verified cleanup. It is promoted and verified on
staging; the new setup-control smoke is in B1-R2 05. Original R1 human results remain history.
