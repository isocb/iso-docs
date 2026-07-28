# LMSPro Remediation Slice R9-A1 - Admission Evidence And Derived Participation Compatibility Review And STAGING Smoke Test

Date: 2026-07-28

Record status: SCHEDULED — no human UI check has yet been executed

Automated technical disposition: PASS LOCALLY; exact-commit Security Scan pending

STAGING deployment disposition: NOT DEPLOYED

Human STAGING disposition: NOT RUN

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
```

## 1. Exact STAGING Scope

```text
environment: STAGING only
tenant/organisation: 862d7c5b-72c4-42ab-9c89-ab216197f596
season: d398ca2d-3c68-4538-ac8c-53eea68ee369
expected pre-R9-A1 migration:
  20260722120000_lmspro_r8_a3_email_delivery_jobs
expected database target fingerprint: d18b9abe1450
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
| Exact application commit | Published commit is exactly `654ec47c…` with parent `df40f45c…` | PENDING |
| Exact Security Scan | Repository Security Scan passes against `654ec47c…` | PENDING |
| Database identity | Credential-safe fingerprint is exactly `d18b9abe1450` | PENDING |
| Tenant/season scope | Season belongs to the authorised tenant | PENDING |
| Session boundary | Administrative preflight is read-only until the migration step | PENDING |
| Migration ancestry | Last expected applied migration matches and no failed/rolled-back migration exists | PENDING |
| Recovery point | A new STAGING child snapshot is created and independently verified | PENDING |
| Additive SQL | Migration contains no existing-row rewrite, reconciliation or legacy evidence insertion | PASS — static review |
| Notification default | Both new events are absent or OFF for the scoped tenant before deployment | PENDING |
| Environment scope | No production target, credential or deployment reference is selected | PENDING |

Stop on any mismatch. Never display, copy or commit the database URL.

## 4. Snapshot, Migration And Deployment Record

To be completed with credential-safe evidence only:

```text
snapshot/child identifier:
snapshot created at:
snapshot source fingerprint:
snapshot verification:
pre-migration applied head:
migration command/workflow:
migration started/completed:
post-migration applied head:
existing-row mutation check:
STAGING deployment reference before:
STAGING deployment reference after:
deployed commit independently verified:
STAGING health evidence:
both events OFF after deployment:
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

Technical verdict: PENDING exact Security Scan, migration and deployed evidence.

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

Result: NOT RUN

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

R9-A1 STAGING implementation/smoke verdict: PENDING

Recovery position: PENDING verified child snapshot

Items requiring a later R9-A2 execution decision: PENDING dry-run evidence

This record cannot become a production, `main`, promotion or reconciliation verdict. It ends at
the exact R9-A1 STAGING outcome and the R9-A2 dry-run stop gate.
