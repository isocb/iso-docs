# LMSPro Remediation Slice R9-A1 - Admission Evidence And Derived Participation Compatibility Review And STAGING Smoke Test

Date: 2026-07-28

Record status: REOPENED — `R9-A1-F1` THROUGH `F7` STAGING SMOKE PASS; R9-A2 BOUNDED
STAGING RECONCILIATION EXECUTED AND VERIFIED; POST-RECONCILIATION HUMAN RE-SMOKE PENDING

Automated technical disposition: F6 corrective `12ae773d` and F7 corrective `15559f12`
automation, production builds and exact dev/staging Security Scans PASS

STAGING deployment disposition: Render Live at exact displayed `15559f1`; `origin/staging`
exact `15559f12`; all migrations applied; Security Scan PASS; public health HTTP 200

Human STAGING disposition: F1-F7 PASS; post-reconciliation focused repeat pending

R9-A2 disposition: PASS — dry-run reviewed; fresh snapshot recorded; 54 append-only evidence
rows and three Club participation changes committed; independent verification PASS

Production/promotion disposition: PROHIBITED BY THIS LIFECYCLE

Planning source:

`docs/modules/lmspro/03-slice-planning/2026-07-28-lmspro-remediation-slice-r9-a1-admission-evidence-and-derived-participation-compatibility-planning.md`

Implementation source:

`docs/modules/lmspro/04-implementation-confirmations/2026-07-28-lmspro-remediation-slice-r9-a1-admission-evidence-and-derived-participation-compatibility-confirmation.md`

Control and application:

```text
controlling IsoDocs commit: afa5a5e23989ac8ddf1c37aca3f47aa222b2c3fb
feature branch: feature/lmspro-r9-a1-admission-participation
application baseline/recovery: df40f45cda955ef00e8f790de89a476c2463a629
application under review: 654ec47cb85f710b4fa2055dc8fa28e0a79ed90f
F5 correction: 5713f9ba8f637a6015dc1b4688258725a473ed35
consolidated corrective candidate: 71c596536d1cb7f6258b3c2cfe1d46de2a22d85a
F6 corrective candidate: 12ae773d67ed05cde86f839ddfab32e30d006010
F7 corrective candidate: 15559f1275d7f8ae3990cc6a9dcda5f35748e570
origin/dev: 15559f1275d7f8ae3990cc6a9dcda5f35748e570
origin/staging: 15559f1275d7f8ae3990cc6a9dcda5f35748e570
current Render candidate: 15559f1275d7f8ae3990cc6a9dcda5f35748e570
Render health: HTTP 200 — database connected; RLS 11/11
```

## 1. Exact STAGING Scope

```text
environment: STAGING only
tenant/organisation: 862d7c5b-72c4-42ab-9c89-ab216197f596
season: d398ca2d-3c68-4538-ac8c-53eea68ee369
expected pre-R9-A1 migration:
  20260722120000_lmspro_r8_a3_email_delivery_jobs
current configured target fingerprint: 016aba10adf6
historic R9-A0 inventory target fingerprint: d18b9abe1450
new migration:
  20260728120000_lmspro_r9_a1_admission_participation
```

The validated import route is mandatory automated integration coverage and is explicitly excluded
from the human UI schedule. Historic Derby JFL records must not be used as smoke fixtures.

## 2. Scheduled Actors And Disposable Fixtures

Actors:

- one existing authorised C1 STAGING operator for the scoped tenant;
- one newly created disposable primary C2 produced through the linked Application route; and
- one newly created disposable primary C2 produced through authorised direct C1 Club creation.

Fixtures to be assigned a run timestamp at execution:

```text
R9-A1 Application Smoke <run timestamp>
R9-A1 Direct C1 Smoke <run timestamp>
R9-A1 Application Team <run timestamp>
R9-A1 Direct Team <run timestamp>
```

Use non-personal smoke email aliases controlled by the tester. Do not record those addresses,
magic links, credentials, names or row identifiers in this document.

Each Club starts without a qualifying Team. Use only same-tenant, same-season disposable Team and
allocation data. A safely reusable STAGING division/AGG may be selected through the UI; do not
alter historic Club or Team records to create the fixture.

## 3. Pre-Deployment Technical Gates

All must pass before migration or deployment:

| Gate | Expected evidence | Result |
| --- | --- | --- |
| Exact application commit | Published commit is exactly `654ec47c…` with parent `df40f45c…` | PASS — dedicated feature branch only |
| Exact Security Scan | Repository Security Scan passes against `654ec47c…` on `dev` | PASS — control owner confirmed green |
| Database identity | Current configured target contains the authorised dataset and expected ancestry | PASS |
| Tenant/season scope | Season belongs to the authorised tenant | PASS — one current ACTIVE match |
| Session boundary | Administrative preflight is read-only until the migration step | PASS — transaction read-only and rolled back |
| Migration ancestry | Last expected applied migration matches and no failed/rolled-back migration exists | PASS |
| Recovery point | A new STAGING child snapshot is created and independently verified | PASS — control-owner-confirmed recovery branch `br-gentle-fog-ab8uzsyy` |
| Additive SQL | Migration contains no existing-row rewrite, reconciliation or legacy evidence insertion | PASS — static and applied evidence |
| Notification default | Both new events are absent or OFF for the scoped tenant before deployment | PENDING |
| Environment scope | No production target, credential or deployment reference is selected | PENDING |

Stop on any mismatch. Never display, copy or commit the database URL.

### 3.1 Workflow correction and successful preflight

The implementation was restored to the normal repository sequence on 2026-07-29:

```text
feature 654ec47c -> fast-forward dev to 654ec47c
staging remains df40f45c
Render remains df40f45c
```

The dev push triggers the established Security Scan automatically. This removes the unnecessary
manual feature-branch scan dependency and restores `dev` as the tested integration source.

The earlier fixed `d18b9abe1450` fingerprint belonged to the corrected R9-A0 inventory target.
It is retained as historic evidence, not as a permanent identity for every later STAGING
operation. The current configured target produced `016aba10adf6`. A new explicitly read-only
preflight established that it contains the exact authorised operational dataset:

```text
transaction read-only:       ON
latest applied migration:    20260722120000_lmspro_r8_a3_email_delivery_jobs
unfinished migrations:       0
unresolved rolled back:      0
tenant/season matches:       1
season:                      current and ACTIVE
scoped Clubs:                61
scoped Teams:                400
scoped Applications:         8
R9-A1 tables before migration: absent
new event setting rows:      absent (safe default OFF in R9-A1 code)
transaction end:             ROLLBACK
```

These match the accepted R9-A0 aggregate dataset and migration ancestry. No names, contact
details or row identifiers were retrieved. No migration or mutation occurred.

The control owner confirms that a fresh backup snapshot was created before migration:

```text
label:       Snapshot Before Club status update
branch ID:   br-gentle-fog-ab8uzsyy
created:     2026-07-29 07:27:52 +01:00
purpose:     dormant recovery copy of the current STAGING database
```

This branch is a legacy/recovery backup only. It is not the future STAGING target and must not be
placed in Render or `.env.staging.local`. The current STAGING database remains the migration and
runtime target; no `DATABASE_URL` change is required or authorised.

## 4. Snapshot, Migration And Deployment Record

To be completed with credential-safe evidence only:

```text
snapshot/child identifier: br-gentle-fog-ab8uzsyy
snapshot created at: 2026-07-29 07:27:52 +01:00
snapshot source fingerprint: 016aba10adf6
snapshot verification: control owner confirms child branch br-gentle-fog-ab8uzsyy is a
  recovery-only snapshot of the current STAGING database
pre-migration applied head: 20260722120000_lmspro_r8_a3_email_delivery_jobs
migration command/workflow: npm run db:migrate / prisma migrate deploy
migration started/completed: completed 2026-07-29T09:29:58Z
post-migration applied head: 20260728120000_lmspro_r9_a1_admission_participation
existing-row mutation check: PASS — 61 Clubs, 400 Teams and 8 Applications retained;
  status aggregates exactly match pre-migration; all three new tables contain zero rows
STAGING deployment reference before: df40f45cda955ef00e8f790de89a476c2463a629
STAGING deployment reference after: 654ec47cb85f710b4fa2055dc8fa28e0a79ed90f
deployed commit independently verified: PASS — control owner confirms Render STAGING Live at
  654ec47
STAGING health evidence: HTTP 200 at 2026-07-29T09:43:40Z; database connected; RLS 11/11
both events OFF after deployment: PASS — no setting rows; R9-A1 safe default is OFF
```

Required sequence:

1. verify target, tenant/season and migration ancestry;
2. create and verify the STAGING recovery child;
3. verify both events will be OFF;
4. apply the additive migration;
5. verify schema and absence of existing-data mutation;
6. advance only the established STAGING deployment reference to exact commit `654ec47c`;
7. verify the deployed commit independently; and
8. confirm both events remain OFF before creating smoke fixtures.

The snapshot branch must remain dormant throughout this sequence. Migration and deployment
continue against the existing current STAGING database URL.

### 4.1 Applied migration evidence

The additive migration completed successfully while Render and `origin/staging` remained on
`df40f45c`.

```text
migration:             20260728120000_lmspro_r9_a1_admission_participation
finished:              2026-07-29T09:29:58Z
rolled back:           NO
unfinished migrations: 0
unresolved rollbacks:   0
new tables:             3/3 present
new integrity constraints: 22
admission batches:      0 rows
admission evidence:     0 rows
transition outbox:      0 rows
Club statuses:          59 APPROVED; 1 WAITING_LIST; 1 WITHDRAWN
Team statuses:          355 CURRENT; 40 WAITING_LIST; 5 CANCELLED
Applications:           8
new event settings:     no rows; R9-A1 safe default is OFF
verification:           explicitly read-only transaction; ROLLBACK
```

No legacy attestation, classification, reconciliation, notification or disposable smoke record
was created by the migration.

### 4.2 STAGING source promotion

The clean `staging` worktree fast-forwarded from `df40f45c` to exact tested `dev` commit
`654ec47c` and pushed successfully:

```text
origin/dev:     654ec47cb85f710b4fa2055dc8fa28e0a79ed90f
origin/staging: 654ec47cb85f710b4fa2055dc8fa28e0a79ed90f
merge shape:    fast-forward only
```

The separate staging worktree initially ran its post-merge type-check against a stale generated
Prisma client and reported missing new enums/models. `npx prisma generate` refreshed that
disposable generated client, after which the exact worktree type-check passed with no source
change. Render's build script also performs `npm ci` and `prisma generate` before its type-check.

The public health endpoint remained HTTP 200 with its database connected and RLS 11/11 during the
Render build window. The locally expected new Clubs route asset was not served during the bounded
polling interval, which was correctly treated as non-authoritative because Render environment
values can influence asset hashes. The control owner subsequently confirmed the Render dashboard
status `Live` at exact displayed commit `654ec47`.

Final post-deployment checks at `2026-07-29T09:43:40Z` confirmed:

```text
health:                PASS
database:              connected
RLS:                   11/11
R9-A1 migration:       finished; not rolled back
admission batches:     0
admission evidence:    0
transition outbox:     0
Clubs:                 61
Teams:                 400
Applications:          8
new event settings:    no rows; both safely default OFF
transaction:           read-only; ROLLBACK
```

### 4.3 Consolidated corrective source promotion

On 2026-07-29, fresh remote refs confirmed that exact green `dev` commit `71c59653` was a direct
descendant of `origin/staging` at `654ec47c`. The clean source boundary was promoted without a
force push:

```text
origin/dev:     71c596536d1cb7f6258b3c2cfe1d46de2a22d85a
origin/staging: 71c596536d1cb7f6258b3c2cfe1d46de2a22d85a
merge shape:    fast-forward only
database action: none
environment action: none
notification action: none
```

Exact STAGING Security Scan run `30446501854` passed TypeScript safety, dependency vulnerability,
database schema/migration security, secret detection and report generation. At
`2026-07-29T11:12:42Z`, the public STAGING health endpoint returned HTTP 200 with the database
connected and RLS `11/11`.

The public endpoint does not expose the running commit and the public login page does not show the
optional build banner. The control owner subsequently confirmed Render displays `Live` at
`71c5965`, satisfying the exact-commit gate. This confirmation required no database, migration or
environment change.

## 5. Automated And Technical Review

Current local result:

- focused R9-A1 tests: 58 passed;
- full Vitest: 210 passed and 12 intentionally skipped;
- type-check, repository verification, Prisma format/validate and additive schema diff: passed;
- production and standalone builds: passed;
- Platform request-body contract: passed;
- focused changed-file ESLint: no errors;
- full repository lint: blocked by unrelated pre-existing baseline errors; and
- exact published-commit repository Security Scans: passed for base and corrective commits.

Focused human review of the deployed corrective build must verify:

- admission evidence is append-only and source-specific;
- all tenant/season/Club references fail closed;
- convergence is transactional and no-op safe;
- access and Team requests remain available for Registered Waiting List Clubs;
- Team Waiting List requires deliberate action;
- notification creation cannot roll back the Club transition;
- outbox retry and recipient ambiguity remain auditable; and
- no migration-time Club/Team classification occurred.

Technical verdict: BASE DEV, ADDITIVE MIGRATION, STAGING SOURCE PROMOTION AND EXACT RENDER
DEPLOYMENT PASS. CORRECTIVE SOURCE PROMOTION AND SECURITY SCAN PASS; CORRECTIVE RENDER COMMIT
CONFIRMATION PENDING. Human UI evidence is partial.

## 6. Human UI Smoke Schedule

Record observable UI evidence and privacy-safe aggregate/database confirmation only. Do not mark a
step passed from source inspection or API-only evidence.

### Route A — linked two-stage Application

1. Submit the linked Club registration form for the disposable Application Club and complete
   email validation.
2. Sign in as the authorised C1 operator and approve the Application.
3. Confirm the Club is visible to C1 and its primary C2, and the C2 can sign in.
4. Confirm durable evidence says `APPROVED_APPLICATION` and is scoped to this tenant, season and
   Club.
5. With no qualifying Team, confirm the Club is Registered but shown in Club Waiting List rather
   than Current.
6. Confirm the primary C2 retains Club access and can request/create the permitted Team workflow.

Result: PARTIAL PASS — registration, email validation, authorised C1 approval, C2 login/access
and retained C2 Team-request capability complete. Stop before the participation transition:
`R9-A1-F5` prevents the Application-carried Team from entering the C1 approval/allocation
workflow and makes the dashboard pending count inconsistent.

Observed UI:

```text
registration submitted:             PASS
email validation:                   PASS
unexpected submission behaviour:   NONE
Application visible to C1:          PASS
pre-approval display:               READY FOR REVIEW
normal approval:                    PASS
success message:                    PASS
Club visible in C1 Club Management: PASS
Club display after approval:        WAITING LIST
C2 approval/login email:            RECEIVED
C2 login:                           PASS
C2 access-denied/notice screen:     NONE
correct Club visible to C2:         PASS
friendly Club category displayed:  NOT OBSERVED
original requested Team visible:    PASS
original requested Team display:    NEW CLUB PENDING TEAM
Register a New Team action:         AVAILABLE AND ACTIONABLE
C2 Team submission:                 PASS
C2-submitted Team stored status:     PENDING
unexpected Team control:            REQUEST FREE DAY OFFERED FOR UNAPPROVED/UNALLOCATED TEAM
```

Read-only fixture evidence after approval:

```text
Application:             APPROVED; reviewed; Club-linked
Club:                    WAITING_LIST
admission evidence:      1 APPROVED_APPLICATION / CLUB_APPLICATION / LINKED
primary C2:              1; primary; ACTIVE; same tenant; matching Club; LMSPro role present
Teams:                   1 NEW_CLUB_PENDING_TEAM; unallocated
                         1 PENDING; unallocated
participation outbox:    0
```

The second Team was submitted through the supported C2 `Register a New Team` workflow. A
tenant/season/fixture-scoped read-only transaction then confirmed the two aggregate Team-state
rows, unchanged Club category and zero participation-outbox rows; it ended with `ROLLBACK`. No
contact information or row identifier was retained.

Review finding `R9-A1-F1`: the Application review modal still exposes a separate orange
`Waiting List` button. Static review confirms its `clubApplications.waitlist` mutation marks the
Application `APPROVED`, provisions C2, records the same `APPROVED_APPLICATION` admission evidence,
makes the Club `WAITING_LIST` and advances placeholder Teams. Normal approval now necessarily
produces that same participation category until a Team qualifies. The parallel action therefore
has no remaining distinct accepted business outcome and risks inconsistent audit wording,
review-note handling and approval notification behaviour.

Recommended disposition: remove the Application-level `Waiting List` button and its redundant
mutation before production promotion, retaining normal Approve and Reject. Do not confuse this
with deliberate Team Waiting List, which remains a valid authorised league decision. No code was
changed during this smoke finding.

Review finding `R9-A1-F2`: the same pre-admission case is represented by two authorities and
labels. The Application page maps `PENDING` to `Awaiting Verification` and `EMAIL_VERIFIED` to
`Ready for Review`. Email verification may also create a provisional `ClubStatus.PENDING` shell
for requested Teams, while Club Management maps that shell only to `Pending`. The Club page filter
and badge are internally aligned with each other, but not with the linked Application's actual
business stage.

Static review also confirms a material bypass: Club Management shows a green generic approval
action for every `ClubStatus.PENDING` row. If used on an Application-linked provisional shell,
`clubs.approve` records `AUTHORISED_DIRECT_C1` evidence and moves the Club to Waiting List without
reviewing the linked Application or using its approval notification/review contract.

Recommended disposition before production:

1. retain `EMAIL_VERIFIED` as an Application status; do not add it to `ClubStatus`;
2. expose a derived pre-admission display/filter stage for Application-linked Club shells:
   `Awaiting Verification` or `Ready for Review`;
3. use the same friendly mapping in the Club badge and filter;
4. hide the generic Club approval action for any Application-linked provisional shell and direct
   the operator to Club Applications;
5. make `clubs.approve` reject that linked case server-side; and
6. explicitly label any remaining unlinked legacy `PENDING` Club as a separate legacy/review
   cohort rather than silently treating it as an Application.

No code or fixture state was changed while confirming this finding.

Review finding `R9-A1-F3`: C2 access and Team-request authority are retained, but the C2
dashboard does not make the Club's participation category clear. The tester could see the
correct Club and Team but could not find a Club status. Static review confirms the dashboard
header shows the Club name, season and user role but not the Club category. A lower summary/profile
surface can expose the raw stored value and does not provide a complete friendly mapping for
`WAITING_LIST`.

Recommended disposition before production: display one prominent, English-friendly participation
badge in the C2 dashboard header and use the same mapping on the profile/summary surfaces, including
`Club Waiting List`, `Current` and explicit override labels. This is a presentation correction only;
it must not create another participation authority. No code was changed during this smoke finding.

Review finding `R9-A1-F4`: the C2 Team detail modal offers `Request Free Day` for the
`NEW_CLUB_PENDING_TEAM` fixture Team. Static review confirms that the control is currently hidden
only for `INACTIVE`; therefore every other Team state, including unapproved and unallocated
in-process states, receives the action. The modal also offers general variation/change requests
without a Team-state eligibility boundary. Manager-detail editing is separately useful while a
Team request is pending and need not be removed.

Recommended disposition before production: define and enforce one small Team-action eligibility
matrix in both UI and server mutations. Free Day requests should require a qualifying operational
Team state and valid allocation. Variation types should appear only where that specific request is
meaningful. Retain manager-detail editing for in-process Teams. No request was submitted and no code
was changed during this smoke finding.

Review finding `R9-A1-F5`: the two accepted pending-Team routes currently produce different
statuses and C1 treatment:

- a Team carried through the Club Application is advanced to `NEW_CLUB_PENDING_TEAM`; and
- a new Team submitted by the admitted primary C2 is deliberately created as `PENDING`.

The R9-A0 inventory classified both as compatible in-process, unallocated states. The distinction
is nevertheless operationally material: the current Team Approval consumer treats `PENDING` as an
existing-Club request that is actionable, while `NEW_CLUB_PENDING_TEAM` under a
`ClubStatus.WAITING_LIST` Club is placed in a read-only Waiting List bucket. Under the accepted R9
contract, Club Waiting List now means Registered/admitted with no qualifying Team; it no longer
means that Club acceptance is still pending. The old C1 grouping therefore risks preventing the
original Application Team from being approved and allocated, while a later C2 submission for the
same Club can proceed.

The human C1 follow-up confirmed the failure:

```text
Application-carried NEW_CLUB_PENDING_TEAM:
  Club Teams table:                     visible
  Team Approval / All Pending:          missing
  approval/allocation control:          unavailable

C2-submitted PENDING Team:
  Club Teams table:                     visible
  Team Approval / All Pending:          visible
  approval/allocation control:          Click to Review

C1 dashboard Team Approval & Allocation:
  Pending approval count:               0
```

Static review identifies two directly related consumer contradictions:

1. `listPendingForApproval` places `NEW_CLUB_PENDING_TEAM` under a
   `ClubStatus.WAITING_LIST` Club into a legacy read-only `waitingList` result on the assumption
   that Club acceptance is still pending. The Team Approval page does not render that result in
   any tab; its visible Waiting List tab separately queries only deliberate
   `TeamStatus.WAITING_LIST` Teams.
2. `getPendingCount` excludes all pending-status Teams whose Club is `WAITING_LIST`. It therefore
   reports zero for this Club even while the page correctly exposes the C2-created `PENDING` Team
   as actionable.

Recommended disposition before production: do not change the C2 writer to
`NEW_CLUB_PENDING_TEAM` in isolation and do not rewrite either smoke Team. The smallest
compatibility correction is to treat both in-process statuses as C1-actionable when the same-scope
Club has durable admission evidence and is not under an explicit override. Use that identical
predicate for the Team Approval result and dashboard count; remove the obsolete “club acceptance
pending” interpretation of Club Waiting List; and keep deliberate `TeamStatus.WAITING_LIST`
separate. Add focused automated coverage for the Application-carried and post-admission C2 routes,
then redeploy the exact corrected commit and repeat this bounded C1 observation before mutating a
Team. Prospective status normalisation can be decided separately and is not required to recover
the workflow safely. This review made no code or direct fixture change.

Disposition: PROMOTION BLOCKER. Do not continue the Route A participation mutation against this
deployment because it cannot exercise the original Application Team through the supported C1
workflow.

Correction status: IMPLEMENTED AND AUTOMATED-TESTED ON `origin/dev` at exact
`5713f9ba8f637a6015dc1b4688258725a473ed35`. The shared eligibility boundary now makes both
in-process Team statuses actionable for an admitted, non-overridden Club and supplies the same
predicate to the dashboard count. Focused eligibility tests, the related R9 participation tests,
the full Vitest suite, TypeScript, the critical-file verifier, diff checks and pre-commit checks
passed. Exact GitHub Security Scan run `30444330070` also passed its TypeScript safety,
dependency vulnerability, schema/migration security, secret-detection and report gates. No
schema, migration, database, fixture, environment or notification value changed.

This does not close the finding. Advance only STAGING/Render to that exact commit, then repeat the
bounded observation that both fixture Teams appear in All Pending, both are reviewable and the
dashboard pending count agrees. Do not action either Team until that observation passes.

### Consolidated correction candidate

The remaining findings `R9-A1-F1` through `R9-A1-F4` were corrected together on top of the green
F5 commit so STAGING requires one further build rather than two. Exact candidate
`71c596536d1cb7f6258b3c2cfe1d46de2a22d85a`:

- removes the redundant Application Waiting List approval route;
- aligns linked-Application Club badges and filters and blocks the direct-Club-approval bypass;
- adds the friendly Club participation badge to the C2 dashboard, summary and profile; and
- gates Free Day and operational variation actions consistently in UI and server while retaining
  pending-Team manager editing and Inactive-Team reinstatement.

Focused boundary tests passed 28/28; the full suite passed 238 with 12 intentionally skipped;
TypeScript, critical-file verification, production build, diff and pre-commit checks passed;
focused changed-file lint had zero errors; and exact Security Scan run `30446138948` was green.

No schema, migration, database, fixture, environment, access or notification state changed in the
corrective commits. `origin/staging` and Render are now exact `71c59653`. Keep both participation
notification events OFF.

### Focused pre-mutation correction re-smoke

Do not approve, allocate, wait-list, reject or otherwise change either fixture Team during this
focused check.

1. Confirm Render says `Live` at `71c5965`.
2. As C1, open the dashboard and Team Approval / All Pending. Confirm both the
   Application-carried `NEW CLUB PENDING TEAM` and the later C2-submitted `PENDING` Team are
   present and each offers `Click to Review`. Confirm the dashboard pending count includes both
   and agrees with the actionable pending list.
3. As C1, inspect Club Management filters. Confirm linked Application stages use
   `Awaiting Verification` and `Ready for Review`, while an unlinked legacy pending Club—if one is
   present—is clearly `Legacy Pending / Review`.
4. On any disposable linked Application still ready for review, confirm there is no separate
   Application `Waiting List` action and no generic direct-Club approval bypass. Do not approve or
   reject it for this focused check. If no such fixture exists, record this UI observation as
   `NOT AVAILABLE` rather than creating another fixture.
5. As the existing fixture C2, confirm the dashboard, summary and profile show the friendly
   `Club Waiting List` category.
6. Open each pending Team without submitting a change. Confirm manager details remain editable,
   `Request Free Day` is absent and operational Team-change requests are unavailable or replaced
   by the explanatory pending/unallocated message. Confirm `Register a New Team` remains
   available.

Record PASS, FAIL or NOT AVAILABLE for each observation. Stop and report any failure; do not
continue into participation mutation until this focused set passes.

Focused result supplied by the control owner:

```text
Render Live at displayed 71c5965:                   PASS

C1:
both fixture Teams in All Pending:                 PASS
both offer Click to Review:                        PASS
dashboard pending count agrees:                    PASS
friendly Club filters aligned with badges:         PASS
redundant Application Waiting List action removed: PASS
direct Club approval bypass removed:               PASS

C2:
Club Waiting List on dashboard:                    PASS
Club Waiting List in summary/profile:              PASS
both fixture Teams visible:                        PASS
manager details editable:                          PASS
Request Free Day absent:                           PASS
operational changes unavailable/explained:         PASS
Register a New Team remains available:             PASS

unexpected behaviour:                              NONE
```

Finding disposition:

- `R9-A1-F1`: focused STAGING PASS;
- `R9-A1-F2`: focused STAGING PASS, including aligned friendly filters and badges;
- `R9-A1-F3`: focused STAGING PASS;
- `R9-A1-F4`: focused STAGING PASS; and
- `R9-A1-F5`: focused STAGING PASS.

Neither fixture Team was approved, allocated, rejected, wait-listed or otherwise changed during
this focused re-smoke. The next participation step remains separately controlled.

### Route B — authorised direct C1 creation

1. Use C1 Club Management to deliberately create the disposable direct-C1 Club and its primary C2.
2. Confirm the Club appears in C1 and C2 views and the C2 can sign in.
3. Confirm durable evidence says `AUTHORISED_DIRECT_C1` and is scoped to this tenant, season and
   Club.
4. With no qualifying Team, confirm the Club is Registered but shown in Club Waiting List rather
   than Current.
5. Confirm the primary C2 retains Club access and can request/create the permitted Team workflow.

Result: NOT RUN

### Participation, cohort and override behaviour

For each disposable Club:

1. create/request an unallocated Team and confirm it is not Current and is not automatically Team
   Waiting List;
2. deliberately place a disposable Team on Team Waiting List and confirm this is distinct and
   represented as an authorised league decision;
3. allocate one same-tenant, same-season Team to a valid division/AGG and make it Current;
4. confirm the Club converges once to Current;
5. confirm C1/C2 Club lists, counts and relevant directory/communications views use the Current
   cohort consistently;
6. remove the last qualifying allocation or return the last Team to a non-qualifying state;
7. confirm the Club converges once to Club Waiting List while C2 access and Team-request
   capability remain;
8. repeat/no-op the same operation and confirm no second transition; and
9. if safely isolated to the fixture, exercise suspended and withdrawn overrides and confirm they
   remain explicit rather than being overwritten by automatic convergence.

Result: NOT RUN

### Notification Manager

1. Confirm both new events are OFF before any transition.
2. With both OFF, perform a real disposable transition and confirm it records suppression and
   sends nothing.
3. Enable only one new event for this tenant in STAGING.
4. Exercise one real transition and confirm exactly one authoritative primary-C2 delivery using
   the default content.
5. Repeat/no-op and retry processing; confirm no duplicate delivery.
6. Configure tenant-custom content/routing for that same event and exercise one new real
   transition; confirm exactly one delivery uses the custom configuration.
7. Where safely possible, use a disposable ambiguous/missing-primary fixture to confirm an
   auditable skip without an unsafe recipient fallback or transition rollback.
8. Where safely possible, observe/retry a controlled delivery failure and confirm the Club
   transition remains committed.
9. Restore the event to OFF and confirm both new events are OFF.

Result: NOT RUN

## 7. Fixture Reset And Recovery

Normal reset:

1. restore both new notification events to OFF;
2. retain privacy-safe transition/evidence identifiers only for the duration required to verify
   idempotency;
3. remove or deactivate only the named disposable smoke Teams, allocations, Clubs, Applications,
   memberships and C2 accounts through supported STAGING workflows;
4. do not alter historic Derby JFL or other unrelated STAGING records;
5. verify scoped aggregate counts return to the recorded pre-smoke position except for
   append-only audit/evidence/outbox records that the supported workflow intentionally retains;
6. label retained append-only disposable evidence clearly in this review record; and
7. confirm both events remain OFF.

Failure recovery:

- stop fixture activity and disable both events;
- restore the STAGING deployment reference to exact baseline `df40f45c` before any schema action;
- preserve failure and outbox evidence;
- do not drop additive objects ad hoc after rows exist;
- use the verified database child through the provider's controlled restore/promote workflow only
  if application rollback is insufficient or data integrity is affected; and
- record the exact recovery action and resulting fingerprint/migration head without exposing a
  credential.

Reset result: NOT RUN

## 8. R9-A2 Tenant/Season-Bounded Dry-Run

This section may be executed only after the first R9-A1 smoke pass. It is read-only and must:

- target only the authorised STAGING tenant and season;
- propose, but not insert, one `LEGACY_ATTESTED_IMPORT` row per verified Club;
- link proposals to one proposed bounded attestation/reconciliation batch;
- state that automated historic source evidence is unavailable;
- show exact proposed membership internally and retain only privacy-safe counts here;
- separately show Current/unallocated Teams, Approved/no-qualifying-Team Clubs and integrity
  concerns;
- calculate expected before/after aggregates;
- prove a repeat dry-run is idempotent;
- suppress/no-op all notifications; and
- finish without a database change.

```text
dry-run command/version:
  controlled bounded SQL v1; PostgreSQL serializable read-only transaction
target:
  STAGING only; neondb; configured target fingerprint 016aba10adf6
tenant/season verified:
  862d7c5b-72c4-42ab-9c89-ab216197f596 /
  d398ca2d-3c68-4538-ac8c-53eea68ee369; season is Current
required migration ancestry:
  all three post-main migrations finished; none rolled back
proposed batch:
  one bounded pre-2026-06-01 legacy-import attestation batch
proposed membership:
  54 of 64 scoped Clubs; membership fingerprint dcf67475260a9bb325025a6383664394
proposed legacy evidence count:
  54 LEGACY_ATTESTED_IMPORT / ATTESTATION_BATCH rows
existing prospective evidence:
  2 APPROVED_APPLICATION; 1 AUTHORISED_DIRECT_C1
Current/unallocated Team observations:
  7 scoped Current Teams have no valid matching allocation; 6 belong to the proposed
  legacy-attestation cohort
Approved/no-qualifying-Team proposals:
  3 Clubs currently APPROVED would become WAITING_LIST; one existing WAITING_LIST Club
  remains WAITING_LIST
integrity concerns:
  7 Current/unallocated-or-invalid; 1 Waiting-List-but-allocated;
  0 Approved-but-allocated; 0 Pending-but-allocated
expected before/after aggregates:
  evidence 0 -> 54 legacy rows plus one batch;
  candidate Club status 53 APPROVED / 1 WAITING_LIST ->
  50 APPROVED / 4 WAITING_LIST;
  Team rows and allocations unchanged
repeat/idempotency result:
  repeat membership count and fingerprint identical; 54/54 proposed keys distinct;
  0 evidence-key collisions; 0 batch-key collisions
proposed attestor:
  one active same-tenant direct-C1 recorder identified; identity retained privately
notification result:
  both participation events effectively OFF; no explicit enabling rows
read-only/no-change proof:
  transaction_read_only=on; ROLLBACK completed; post-run verification found
  0 LEGACY_ATTESTED_IMPORT rows and 0 attestation batches
```

Dry-run result: PASS — no database mutation.

The user reviewed the bounded effect—54 append-only evidence rows, one batch and three
APPROVED-to-WAITING_LIST Club changes with no Team, allocation, official, access or contact
rewrite—and explicitly authorised proceeding on STAGING. Execution remained paused until the F7
focused UI check passed and a fresh immediately-pre-execution STAGING snapshot was recorded; both
gates were subsequently satisfied.

### R9-A2 execution

The F7 focused UI check passed and the control owner created the required immediately-pre-execution
STAGING recovery point:

```text
snapshot label: At 15559f1 before club workflow promotion
snapshot branch: br-dawn-heart-abc0rq3b
snapshot time: 2026-07-29 13:54:39 +01:00
application: 15559f1275d7f8ae3990cc6a9dcda5f35748e570
```

The exact execution transaction was first rehearsed with a forced final `ROLLBACK`. Every insert,
foreign key, update, suppression record, audit row and postcondition passed. The identical
serializable transaction was then committed at approximately 2026-07-29 13:59 +01:00.

```text
attestation batches inserted:        1
batch fingerprint:                   a4645619a914a8c4fc61be9763f2c26d
LEGACY_ATTESTED_IMPORT rows inserted: 54
distinct Clubs evidenced:            54
Club APPROVED -> WAITING_LIST:        3
suppressed transition rows:           3
per-Club participation audit rows:    3
batch reconciliation audit rows:      1
Team rows/statuses/allocations changed: 0
notifications enabled or sent:        0
```

Independent read-only verification proved:

- exactly 54 valid batch-linked legacy evidence rows across 54 distinct Clubs;
- 50 pre-cutoff Clubs remain `APPROVED` and four are `WAITING_LIST`;
- both transition events remain effectively off;
- all three transition records are `SUPPRESSED`;
- Team-state observations are unchanged;
- public STAGING health remains HTTP 200 with database connected and RLS 11/11; and
- a repeat dry-run proposes zero remaining legacy evidence rows, proving operational
  idempotency.

R9-A2 execution result: PASS — post-reconciliation human re-smoke pending.

## 9. R9-A1-F6 Regression And Corrective Re-Smoke

After the F1-F5 focused checks passed, the Team approval test exposed a blocking workflow
regression: the approval modal attempted to make a Team `CURRENT`, but R9-A1 now correctly rejects
Current without a valid division/AGG allocation. The normal league workflow requires approval of
the Team name and age group first, followed by a separate allocation decision.

The regression was not worked around and neither smoke Team was actioned. Exact corrective commit
`12ae773d67ed05cde86f839ddfab32e30d006010` adds explicit Approved-and-unallocated status and
restores the two-stage approval/allocation workflow. Its additive migration changes the enum only
and does not rewrite existing Team rows.

Development/test evidence:

```text
development migration ledger: 147 applied; 0 failed; no pending repository migration
development existing APPROVED Team rows after migration: 0
test database pending migrations: applied successfully; 0 failed
focused tests: 49 PASS
full Vitest: 249 PASS; 12 intentionally skipped
type-check, Prisma validation, verifier, build and pre-commit: PASS
exact dev Security Scan run 30449594027: PASS
```

STAGING Git and migration state is aligned:

```text
application / origin-staging: 12ae773d67ed05cde86f839ddfab32e30d006010
applied migrations:            147
failed migrations:             0
pending repository migrations: 0
F6 migration finished:         2026-07-29T11:59:44.773Z
F6 migration rolled back:      no
staging Security Scan:          PASS — run 30449795658
public Render health:           HTTP 500 — cannot reach Neon
```

The configured STAGING endpoint is reachable from the controlled local session and returns the
complete ledger, while Render's running process cannot currently reach the same Neon host. The
next controlled action is therefore a Render restart or redeploy of exact `12ae773d`, not another
migration.

After public health recovers:

1. confirm Render is Live at displayed `12ae773`;
2. confirm `/api/health` returns HTTP 200 with its database connected and RLS healthy;
3. with transition notifications still OFF, approve a disposable pending Team after confirming
   its age group and without selecting a division;
4. confirm it appears in Approved & Unallocated and is not Current or Team Waiting List;
5. allocate it to a valid same-tenant, same-season division and confirm it becomes Current;
6. confirm the Club changes from Club Waiting List to Current only at allocation; and
7. record any notification/outbox result without enabling or sending a notification.

F6 re-smoke result: PASS — user-confirmed on STAGING:

- application-created Team approved without selecting a division;
- Team moved from All Pending to Approved & Unallocated;
- Club remained Club Waiting List and dashboard counts agreed;
- later valid division allocation made the Team Current and the Club Current; and
- C2 access remained correct with notifications off.

## 10. R9-A1-F7 Direct-C1 Team Creation Correction

The direct-C1 Club route passed, but its Club Management Team modal omitted both `PENDING` and
`APPROVED` from the displayed selector even though `PENDING` was the form default. It also did not
refetch the Club after a Team mutation, requiring a forced page refresh to display participation
changes.

Exact corrective commit `15559f1275d7f8ae3990cc6a9dcda5f35748e570`:

- exposes Pending approval and Approved & Unallocated as separate C1 choices;
- labels Current as requiring a division;
- explains the Pending/Approved distinction in the modal;
- refetches Team and Club state after Team create, update and delete; and
- adds focused regression coverage for the exposed workflow choices.

```text
focused tests:              22 PASS
full Vitest:                251 PASS; 12 intentionally skipped
type-check and verifier:    PASS
production build:           PASS
source ESLint:              0 errors; 16 pre-existing warnings
pre-commit:                 PASS
exact dev Security Scan:    PASS — run 30452691002
exact staging Security Scan: PASS — run 30452881890
public STAGING health:      HTTP 200; database connected; RLS 11/11
```

Focused F7 UI gate:

1. confirm Render displays Live at `15559f1`;
2. open the direct-C1 smoke Club and Add Team;
3. confirm Pending approval and Approved & Unallocated are both selectable;
4. create a disposable Team as Pending with no division;
5. confirm it appears in All Pending and the dashboard count agrees;
6. confirm the Club view updates without a forced browser refresh; and
7. do not reconcile until this focused result is PASS.

F7 result: PASS — Render Live at displayed `15559f1`; both missing choices present; a disposable
Pending Team was created without a division, appeared in All Pending, agreed with the dashboard
count and left the Club on Club Waiting List without a forced refresh.

## 11. Verdict

R9-A1 STAGING implementation/smoke verdict: F1-F7 PASS

Recovery position: PASS — immediate pre-reconciliation snapshot `br-dawn-heart-abc0rq3b`;
current STAGING database remains the active target.

R9-A2 position: EXECUTION AND INDEPENDENT DATABASE VERIFICATION PASS; focused human
post-reconciliation re-smoke pending.

This record cannot become a production, `main`, promotion or reconciliation verdict. It ends at
the exact R9-A1 STAGING outcome and the R9-A2 dry-run stop gate.
