# LMSPro Remediation Slice R9-A1 - Admission Evidence And Derived Participation Compatibility Review And STAGING Smoke Test

Date: 2026-07-28

Record status: HUMAN STAGING SMOKE PAUSED — Route A access PASS; findings
`R9-A1-F1` through `R9-A1-F5` recorded and corrected on `origin/dev` but not yet deployed or
re-smoked

Automated technical disposition: BASE `654ec47c` PASS; consolidated corrective `71c59653`
automation, production build and exact automatic Security Scan PASS

STAGING deployment disposition: PASS — exact `654ec47c` confirmed Live

Human STAGING disposition: PARTIAL PASS — stop before participation mutation until
`R9-A1-F5` is corrected and redeployed

R9-A2 dry-run disposition: NOT RUN

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
origin/dev: 71c596536d1cb7f6258b3c2cfe1d46de2a22d85a
origin/staging and current Render deployment: 654ec47cb85f710b4fa2055dc8fa28e0a79ed90f
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

## 5. Automated And Technical Review

Current local result:

- focused R9-A1 tests: 58 passed;
- full Vitest: 210 passed and 12 intentionally skipped;
- type-check, repository verification, Prisma format/validate and additive schema diff: passed;
- production and standalone builds: passed;
- Platform request-body contract: passed;
- focused changed-file ESLint: no errors;
- full repository lint: blocked by unrelated pre-existing baseline errors; and
- exact published-commit repository Security Scan: pending.

Technical review must additionally verify in the deployed build:

- admission evidence is append-only and source-specific;
- all tenant/season/Club references fail closed;
- convergence is transactional and no-op safe;
- access and Team requests remain available for Registered Waiting List Clubs;
- Team Waiting List requires deliberate action;
- notification creation cannot roll back the Club transition;
- outbox retry and recipient ambiguity remain auditable; and
- no migration-time Club/Team classification occurred.

Technical verdict: DEV, ADDITIVE MIGRATION, STAGING SOURCE PROMOTION AND EXACT RENDER DEPLOYMENT
PASS. Human UI evidence does not yet exist.

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

No schema, migration, database, fixture, environment, access, notification or deployment state
changed. The findings remain open until STAGING is advanced to exact `71c59653` and the affected
UI observations pass. Keep both participation notification events OFF for that redeployment.

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
target fingerprint:
tenant/season verified:
proposed batch:
proposed legacy evidence count:
Current/unallocated Team proposals:
Approved/no-qualifying-Team proposals:
integrity concerns:
expected before/after aggregates:
repeat/idempotency result:
notification result:
read-only/no-change proof:
```

Dry-run result: NOT RUN

R9-A2 reconciliation execution remains prohibited until the user reviews this evidence and gives
separate explicit approval.

## 9. Verdict

R9-A1 STAGING implementation/smoke verdict: PENDING MIGRATION/DEPLOYMENT/HUMAN SMOKE

Recovery position: PENDING verified child snapshot

Items requiring a later R9-A2 execution decision: PENDING dry-run evidence

This record cannot become a production, `main`, promotion or reconciliation verdict. It ends at
the exact R9-A1 STAGING outcome and the R9-A2 dry-run stop gate.
