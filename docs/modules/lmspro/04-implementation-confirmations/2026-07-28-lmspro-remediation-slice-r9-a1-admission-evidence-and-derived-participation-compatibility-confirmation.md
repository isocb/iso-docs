# LMSPro Remediation Slice R9-A1 - Admission Evidence And Derived Participation Compatibility Confirmation

Date: 2026-07-28

Implementation status: CONSOLIDATED `R9-A1-F1` THROUGH `R9-A1-F5` CORRECTION LIVE ON STAGING
AT EXACT SECURITY-SCAN-GREEN COMMIT; all reported focused human checks PASS, with the friendly
Club-filter observation not recorded

Planning source:

`docs/modules/lmspro/03-slice-planning/2026-07-28-lmspro-remediation-slice-r9-a1-admission-evidence-and-derived-participation-compatibility-planning.md`

Controlling IsoDocs commit:

`afa5a5e23989ac8ddf1c37aca3f47aa222b2c3fb`

Application evidence:

```text
branch: feature/lmspro-r9-a1-admission-participation
starting/recovery baseline: df40f45cda955ef00e8f790de89a476c2463a629
implementation commit: 654ec47cb85f710b4fa2055dc8fa28e0a79ed90f
parents: exactly df40f45cda955ef00e8f790de89a476c2463a629
focused R9-A1-F5 correction: 5713f9ba8f637a6015dc1b4688258725a473ed35
consolidated smoke-follow-up correction: 71c596536d1cb7f6258b3c2cfe1d46de2a22d85a
origin/dev: advanced from 654ec47c through 5713f9ba to 71c59653 on 2026-07-29
origin/staging: fast-forwarded from 654ec47c to 71c59653 on 2026-07-29
Render STAGING: control-owner-confirmed Live at displayed 71c5965 on 2026-07-29
worktree state after commit: clean
```

## 1. Implemented Boundary

Commit `654ec47c` implements the accepted one-branch R9-A1 application-remediation slice:

- an additive, append-only admission-evidence model scoped to tenant, season and Club;
- typed evidence for validated import, approved Application, authorised direct C1 creation,
  control-owner-attested legacy import and season rollover;
- one bounded evidence-batch model for the later per-Club legacy attestation representation;
- source and supersession constraints that fail closed across tenant, season and Club boundaries;
- a side-effect-free participation evaluator and transactional convergence service;
- `ClubStatus.APPROVED` as the compatibility representation of Current;
- Club Waiting List for an admitted Club with no qualifying Team;
- a qualifying Team only where Team, Club, season and allocated age-group/AGG scope agree;
- unallocated Teams remaining distinct from deliberately authorised Team Waiting List;
- retained officials, C2 access and Team-request capability for Registered Waiting List Clubs;
- explicit suspended and withdrawn Club overrides;
- prospective alignment of validated import, approved two-stage Application and authorised
  direct-C1 Club creation;
- alignment of principal access, count, directory, communications, UI and season-rollover
  consumers; and
- two separately controlled Notification Manager events backed by a bounded durable outbox.

No legacy evidence row was inserted and no existing Club, Team, Application, official, access,
role or notification-setting record was reconciled or reclassified.

## 2. Additive Schema And Migration

Migration:

`prisma/migrations/20260728120000_lmspro_r9_a1_admission_participation/migration.sql`

The migration adds:

- `LMSProAdmissionEvidenceBatch`;
- `LMSProClubAdmissionEvidence`;
- `LMSProParticipationTransitionOutbox`;
- evidence-type, source-type, primary-C2-outcome and outbox-status enums;
- tenant/season/source and tenant/season/Club foreign-key constraints;
- typed self-references for season rollover and same-scope supersession;
- uniqueness controls for source retries, legacy batch membership and transition delivery; and
- integrity checks for source-specific evidence and outbox transitions.

The SQL contains no `UPDATE`, backfill, status rewrite or legacy-attestation insertion.
`prisma migrate diff` from the exact `df40f45c` schema produced the same additive object shape;
the committed SQL also retains the accepted fail-closed integrity checks.

## 3. Writer And Consumer Alignment

### Admission writers

- Validated Club import creates the Club initially as Waiting List, provisions the C2 relation
  through the shared path and writes `VALIDATED_IMPORT` evidence.
- C1 approval of a two-stage Application commits the Club, C2 association, Application outcome,
  `APPROVED_APPLICATION` evidence and audit result in one transaction.
- Authorised direct C1 creation commits the Club, shared C2 provisioning and
  `AUTHORISED_DIRECT_C1` evidence in one transaction.
- A generic Club approval action now records admission and returns the Club to the derived
  Waiting List category until a qualifying Team exists.
- Direct generic edits cannot manually force the two derived Club participation categories.

### Participation writers

- Team creation, update, allocation, bulk update, update-by-Club, deletion and batch deletion
  validate allocation scope and converge the associated Club in the same transaction.
- A Team cannot become Current without a valid same-tenant, same-season allocation.
- An unallocated Team remains in-process and is not automatically made Team Waiting List.
- Removing the last qualifying Team returns the Club to Club Waiting List without undoing
  admission, officials, C2 access or Team-request capability.

### Consumers

Club list/detail counts, season counts/statistics, directory eligibility, communication cohorts,
announcement defaults, key-date reminder cohorts and season rollover now use the accepted
qualifying-participation rules. The UI distinguishes derived Club Current/Waiting List from
unallocated and deliberately wait-listed Team states.

Existing records without R9-A1 evidence are retained as compatibility data. Their reconciliation
is deliberately deferred to R9-A2.

## 4. Notification Behaviour

The implementation adds:

```text
lmspro.club_participation.became_current
lmspro.club_participation.returned_to_waiting_list
```

Both events are fail-closed and default OFF when a tenant has no matching Notification Manager
setting. A real committed transition writes one durable outbox result in the same transaction:
`SUPPRESSED` while disabled or `PENDING` while enabled.

Delivery resolves exactly one authoritative active primary C2 through same-tenant Club-official
membership and an active LMSPro Club role, unless an explicit Notification Manager override is
valid. No arbitrary JSON, email or role fallback is used. Missing or ambiguous authority creates
an auditable skipped result and cannot undo the Club transition.

Pending delivery uses stable provider idempotency, bounded claiming, stale-claim recovery,
exponential retry/backoff and terminal failure handling through the existing jobs runtime.
A repeated/no-op convergence does not create another transition or delivery.

## 5. Changed Areas

The commit changes 34 files:

- Prisma schema and one additive migration;
- admission evidence, participation evaluation/convergence and participation notification
  services;
- the existing jobs runner and one bounded participation-transition processor;
- Club, Team, Application, season, announcement, key-date and Notification Manager routers;
- import Club/Team handlers;
- communications cohorts/templates and provider idempotency;
- relevant C1/C2 dashboard, Club, season and Team-approval UI; and
- focused unit/integration tests for the new boundary.

The exact file list is retained by `git show --name-only 654ec47c`.

## 6. Automated Evidence

Executed against the feature worktree:

```text
Focused R9-A1 tests: 58 PASS
npm test -- --run: 210 PASS, 12 intentionally skipped
  (32 files passed, 1 file intentionally skipped)
npm run type-check: PASS
npm run verify: PASS
npx prisma format: PASS
npx prisma validate: PASS
Prisma schema diff from exact df40f45c baseline: PASS; additive only
git diff --check: PASS
Focused changed-file ESLint: PASS with warnings only
npm run build: PASS
NEXT_OUTPUT_STANDALONE=1 npm run build: PASS
npm run test:platform:request-body: PASS
  (small JSON 1, representative PDF-equivalent 20, accepted 10 MB 1)
scripts/security/check-npm-audit-report.test.ts: 6 PASS
bounded credential-pattern inspection: PASS
```

Full-repository `npm run lint` remains red because of pre-existing errors in unrelated baseline
files and existing warning debt. No unrelated lint remediation was folded into R9-A1. Changed
production files completed focused ESLint with no errors.

A direct local registry audit was not executed because the controlled environment did not permit
sending private dependency metadata to the npm registry. Pushing exact commit `654ec47c` to
`origin/dev` triggered the normal repository Security Scan. The control owner confirmed that
exact dev scan green on 2026-07-29.

Local build warnings that Upstash was not configured reflect the isolated local build environment
and did not fail compilation. The request-body contract passed after the required standalone
build.

## 7. Compatibility And Recovery

- The application parent and pre-change recovery baseline is exact commit `df40f45c`.
- The migration is additive and performs no existing-row mutation.
- A verified STAGING database child snapshot is required before migration.
- If deployment fails before R9-A2, first restore the application deployment reference to
  `df40f45c`. Because existing records are not rewritten, the new unused additive tables may
  remain until a controlled decision or the verified child snapshot may be promoted/restored
  through the database provider's established recovery workflow.
- After any R9-A1 evidence or transition rows are created, do not drop the additive objects as an
  ad-hoc rollback. Restore application compatibility first and retain or restore the complete
  snapshot consistently.
- R9-A2 must not execute unless the exact post-R9-A1 access-safe commit and recovery point remain
  recorded and separately approved.

## 8. Known Limitations And Stop Boundary

- Existing legacy Clubs do not yet receive `LEGACY_ATTESTED_IMPORT` evidence.
- Existing incompatible Club/Team states are not repaired by this commit.
- The R9-A2 dry-run and any later reconciliation execution remain separate controls.
- Validated import is covered by automated integration testing and is deliberately excluded from
  the focused human UI smoke.
- Both new notification events are confirmed default-OFF after the exact STAGING deployment.
  A bounded smoke step may explicitly enable one, and that event must be returned to OFF
  immediately afterwards.
- Exact STAGING migration and deployment passed on 2026-07-29 with the new tables empty and
  existing scoped statuses unchanged. Human UI results and R9-A2 dry-run evidence remain pending
  and belong in the review/test record.
- Production query, mutation, deployment, notification enablement and `main` promotion remain
  prohibited.

The clean application commit and dev fast-forward complete implementation and dev validation
only. They are not yet an R9-A1 STAGING smoke, reconciliation, promotion or production verdict.

## 9. Focused R9-A1-F5 Correction

The Route A human smoke found that the Application-carried
`NEW_CLUB_PENDING_TEAM` existed in the Club Teams table but was absent from C1 Team Approval and
the dashboard pending count. The same admitted Club's later C2-submitted `PENDING` Team was
actionable on the Team Approval page while the dashboard still reported zero. Static review
confirmed that both consumers retained the obsolete assumption that
`ClubStatus.WAITING_LIST` meant Club acceptance was pending.

Exact corrective application commit:

`5713f9ba8f637a6015dc1b4688258725a473ed35`

The correction:

- defines one shared pending-Team eligibility boundary;
- treats both `PENDING` and `NEW_CLUB_PENDING_TEAM` as actionable where the same-scope Club has
  durable admission evidence;
- preserves raw `ClubStatus.APPROVED` as the temporary legacy compatibility representation;
- blocks suspended and withdrawn Club overrides;
- keeps deliberate `TeamStatus.WAITING_LIST` separate;
- applies the same Club predicate to the dashboard pending count;
- retains genuinely pre-admission Teams as read-only; and
- replaces obsolete “Waiting List means Club acceptance pending” explanatory copy.

It changes no schema, migration, environment, database record, notification setting or deployment.
Neither existing smoke Team was rewritten.

Corrective automated evidence:

```text
focused eligibility tests:       9 PASS
focused R9 participation tests:  29 PASS
full Vitest suite:               219 PASS; 12 intentionally skipped
npm run type-check:              PASS
npx tsx critical-file verifier: PASS
git diff --check:                PASS
pre-commit checks:               PASS
```

`origin/dev` was advanced from `654ec47c` to exact `5713f9ba` on 2026-07-29. Exact GitHub
Security Scan run `30444330070` passed: TypeScript safety, dependency vulnerability, database
schema/migration security, secret detection and report generation were green. This intermediate
F5-only candidate was then superseded by consolidated correction `71c59653`, which was promoted
to `origin/staging` as recorded below. No R9-A2 dry-run or reconciliation is authorised by this
corrective commit.

## 10. Consolidated R9-A1-F1 Through F4 Correction

Rather than incur two STAGING builds, the remaining confirmed human-smoke findings were corrected
as one application-only batch on top of exact green F5 commit `5713f9ba`.

Exact consolidated candidate:

`71c596536d1cb7f6258b3c2cfe1d46de2a22d85a`

The correction:

- removes the redundant Application-level Waiting List button and server mutation while retaining
  normal Approve and Reject;
- derives friendly linked-Application Club stages (`Awaiting Verification` and
  `Ready for Review`) and aligns the Club Management badges and filters;
- labels an unlinked `PENDING` Club explicitly as `Legacy Pending / Review`;
- hides direct Club approval for a linked Application shell and rejects that bypass server-side;
- displays `Current`, `Club Waiting List` and explicit override labels prominently on the C2
  dashboard, summary and profile;
- retains manager-detail editing for in-process Teams;
- hides Free Day actions for non-Current or unallocated Teams and rejects ordinary or special Free
  Day submissions server-side unless the Team is Current and allocated;
- hides operational variation creation for pending/unallocated Teams and enforces the same server
  rule, while retaining the existing Inactive-Team reinstatement path; and
- centralises the Club-display/direct-approval and Team-action eligibility rules with focused
  automated tests.

The batch changes no schema, migration, record, fixture, environment or notification value.
Existing pending Teams and append-only R9-A1 evidence remain untouched.

Consolidated automated evidence:

```text
focused Club/Team boundary tests: 28 PASS
full Vitest suite:                238 PASS; 12 intentionally skipped
npm run type-check:               PASS
npx tsx critical-file verifier:  PASS
focused changed-file ESLint:      PASS with existing warnings only; zero errors
npm run build:                    PASS
git diff --check:                 PASS
pre-commit checks:                PASS
```

Exact GitHub Security Scan run `30446138948` passed TypeScript safety, dependency vulnerability,
database schema/migration security, secret detection and report generation. `origin/dev` and
`origin/staging` are exact `71c59653` after a non-force fast-forward on 2026-07-29. The
STAGING-triggered exact-commit Security Scan run `30446501854` passed the same gates.

The public STAGING health endpoint subsequently returned HTTP 200 with its database connected and
RLS `11/11`. The control owner confirmed Render `Live at 71c5965`, Render's seven-character
display of the exact promoted commit.

The focused human re-smoke then passed every reported C1 and C2 correction check with no unexpected
behaviour. The friendly Club-filter field was left blank and is retained as `NOT RECORDED`; it is
not inferred as a pass. Neither fixture Team was actioned. This application-only promotion
performed no database, migration, environment or notification action. This implementation record
does not authorise an R9-A2 dry-run, reconciliation or production promotion.
