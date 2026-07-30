# LMSPro Remediation Slices R9-B To R9-D Combined Implementation Confirmation

Date: 2026-07-29

Status: IMPLEMENTATION COMMITTED; DEV/STAGING ALIGNED; EXACT SECURITY SCANS, ADDITIVE
STAGING MIGRATION, WEB DEPLOYMENT AND CRON TICK PASS; INITIAL HUMAN SMOKE STOPPED;
CORRECTIVE DEPLOYMENT AND COMPLETE STAGING HUMAN SMOKE PASS; PRODUCTION READ-ONLY PREFLIGHT
AND SNAPSHOT PASS; MAIN FAST-FORWARD, SECURITY SCAN, MIGRATION AND HEALTH PASS; LIVE HUMAN
CONFIRMATION PENDING

Planning source:

`docs/modules/lmspro/03-slice-planning/2026-07-29-lmspro-remediation-slices-r9-b-to-r9-d-combined-planning.md`

Control and application:

```text
controlling IsoDocs acceptance commit:
  3254f54
application recovery baseline:
  15559f1275d7f8ae3990cc6a9dcda5f35748e570
branch:
  fix/lmspro-r9-b-d-remediation
implementation commit:
  58ef44fd7c91e2c5932f0634bfa803bbfa13dd55
implementation tree:
  b14e9521687d8e75aa2876b1c13c9531e4519621
standalone cron correction:
  f321eb07936ec546e8738c22709809b2704be5ed
exact release candidate:
  f321eb07936ec546e8738c22709809b2704be5ed
corrective release candidate:
  fbab1862fa8124ae5f1d64df1b2741fdb19761fc
migration:
  20260729170000_lmspro_r9_b_email_club_visibility
```

No staging or production database, environment, deployment or record was queried or changed
during implementation. No Email was sent during automated/local technical validation. No
historic Email evidence was reconciled. The control owner subsequently authorised the exact
candidate to progress through `dev` to STAGING, with STAGING as the authoritative human browser
smoke environment. Local `dev` and `origin/dev` subsequently fast-forwarded to exact
`58ef44fd7c91e2c5932f0634bfa803bbfa13dd55`; exact dev Security Scan run `30466540339`
passed. The subsequently reported standalone cron startup failure was corrected at direct child
`f321eb07936ec546e8738c22709809b2704be5ed`; local `dev` and `origin/dev` now use that exact
release candidate and replacement exact dev Security Scan run `30513826659` passed. STAGING
remains at the recovery baseline pending its fresh dormant database snapshot.
An explicitly read-only STAGING preflight then passed and rolled back: the authorised
tenant/season matched, all 147 repository-baseline migrations were applied, no unfinished or
unresolved rolled-back migration existed, and both candidate tables and the candidate ledger
row were absent.

The control owner subsequently confirmed dormant recovery branch `br-long-glade-abv9jrk0`,
named `Staging Snaphot before cronjob fix 2026-07-30`, created
`2026-07-30 05:34:51 +01:00`. The current STAGING database remains the authorised target; no
database URL change is required.

Local/remote STAGING subsequently fast-forwarded to exact release candidate `f321eb07`. Exact
staging Security Scan run `30514385014` passed. Render's public compiled build changed from
`15559f1` to `f321eb0`; health is HTTP 200 with database connected and RLS 11/11. Independent
read-only ledger verification confirms 148 successful migrations, the candidate finished
without rollback, both additive tables present, zero new visibility rows and unchanged existing
Email/recipient/resource aggregates.

The control owner then confirmed STAGING Cron Job build `bld-d9lda6142hec73civ1tg` succeeded
for exact displayed `f321eb0`. One complete invocation loaded all five processors, matched active
STAGING database fingerprint `016aba10adf6`, processed no queued work, fired no key-date Email,
reported zero errors and finished successfully. The focused human smoke is now the next gate.

## 1. R9-B Implemented Boundary

The additive model is:

```text
Email
-> EmailClubVisibility
-> EmailClubVisibilityRecipient
-> exact EmailRecipient delivery/content evidence
```

It records organisation, season, Email, Club, source and finalisation evidence without changing
the existing Email, recipient, attachment or provider-delivery tables. Composite foreign keys
fail closed across tenant, season, Email and recipient boundaries. The migration contains no
historic insert, update, reclassification or reconciliation.

One audience service now:

- retains exact Club contexts before lowercase-address deduplication;
- permits one provider recipient to represent several exact Club histories;
- resolves direct Club, Team, current Club-official User and explicit manual Club/Team evidence;
- rejects a selected Club or Team that cannot be proved in the organisation;
- leaves a genuinely unlinked manual address outside Club history; and
- materialises or replaces draft audience rows transactionally.

Prospective compose/create/update/recipient replacement, duplicate-to-draft, Announcement,
key-date reminder, ordinary sequence and key-date sequence writers use this boundary.
No-attachment, attachment-job, Announcement, reminder and sequence outcomes now align the
parent, recipient, immutable resolved content and Club-audience finalisation evidence.

C1 composition shows separate deduplicated provider-recipient and Club-history audience counts.
An unlinked manual address carries an explicit warning.

C2 Club history now requires the exact current-season `EmailClubVisibility`, at least one linked
accepted primary recipient and the exact Club/tenant scope. It returns one Email per row, no
recipient identity, stable 50-row cursor pagination, distinct authorised content variants,
attachment/link metadata and a short-lived server-authorised private attachment URL. The shared
C1 Email routes enforce the LMSPro Sent/compose component authorities, removing the former C2
organisation-wide bypass.

Historic current-season Emails remain absent from the new tables until a separately authorised
aggregate dry-run and insert-only reconciliation. This is intentional.

## 2. R9-C Implemented Boundary

C1 and C2 now consume one shared Team-status presentation contract:

- `APPROVED` displays as `Approved & Unallocated`;
- `PENDING` displays as `Pending Approval`;
- `CANCELLED` displays as `Declined`;
- every retained Team enum receives one friendly label and colour;
- valid Waiting List evidence displays `Waiting List 3/12`;
- the complete accessible name is `Waiting List, position 3 of 12`; and
- incomplete position evidence does not invent a position.

Both Team screens show compact stacked cards below the desktop boundary and the complete table
from the desktop boundary. Identity, age group, complete status and division/`Unallocated`
remain in the compact summary. Both card and table presentations expose an explicit
keyboard-operable `More details` control. No Team value, waiting-list calculation, filter,
allocation or workflow meaning changed.

## 3. R9-D Implemented Boundary

The accepted baseline runtime report was click-to-browse failure while drag/drop remained the
retained selection path. Static inspection confirmed that the Mantine Dropzone relied on
implicit defaults and had no explicit activation contract.

The smallest correction explicitly enables Dropzone pointer and keyboard activation while idle,
gives the control an accessible name and disables both activation paths while processing. Drop,
browse and keyboard selection still enter the existing R8-A selection/validation function.
Allowlist, count/size limits, private storage, acknowledgement, draft/duplicate behaviour,
provider routing, retry and no-attachment delivery are unchanged.

The Node test environment cannot open a native operating-system file picker. The focused
Chrome/Edge human smoke on STAGING in the companion review record is therefore the authoritative
runtime activation proof.

## 4. Additive Migration And Local Database

`prisma migrate dev` first stopped without changing data because the non-interactive generator
also previewed unrelated live enum drift. That unrelated change was not bundled.

The migration was instead bounded manually to:

- two composite uniqueness indexes required by the new foreign keys;
- the two new tables;
- tenant/season/Email/Club/recipient constraints; and
- Club-history and recipient lookup indexes.

`prisma migrate deploy` then applied only this migration to the previously verified local
development database. The local ledger reports 148 migrations and `Database schema is up to
date`. No database URL or environment value changed.

## 4A. Standalone Cron Runtime Correction

The Render cron log proved that `npm run jobs:tick` stopped during module loading with the
`server-only` package error. It did not reach the configured database or any processor. A
processor-by-processor standalone import isolated the failure to the LMSPro participation
transition path.

The bounded correction:

- permits standalone workers to pass their own Prisma client through participation delivery,
  Email branding, product-feature resolution and letterhead resolution;
- retains lazy Next.js Prisma resolution for existing web callers;
- changes no notification switch, recipient, content, delivery, retry or idempotency rule;
- adds a child-process regression test that imports every cron processor without the Vitest
  `server-only` shim; and
- leaves schema, migration and data unchanged.

A complete local `jobs:tick` then loaded all five processors and exited successfully with zero
queued work and zero errors. No provider Email was sent.

## 4B. Initial Human-Smoke Correction

Initial STAGING human smoke on exact `f321eb07` exposed two related presentation/selector
defects and one prospective Email writer defect. Waiting List Clubs were missing from
communication and Team selectors; some C1 Team surfaces showed raw or incomplete status
vocabulary; and the nested Email-to-Club recipient writer supplied an `emailId` that Prisma
already derives from its parent visibility.

The bounded correction at `fbab1862fa8124ae5f1d64df1b2741fdb19761fc`:

- includes registered Current and Club Waiting List Clubs in exact-current-season selectors,
  with a visible Waiting List suffix;
- shares friendly Team-status options and badges across the affected C1 surfaces;
- preserves the linked Club when a Waiting List Club's Team is edited;
- removes the duplicate nested Email ID so no-attachment Email creation can persist the
  prospective Club audience;
- retains mandatory R8-A resource acknowledgement while making its existing explanatory
  validation reachable; and
- makes the generic Email-operation error truthful when the failure is not attachment
  preparation.

The Email save was exercised against the normal local development database in a complete
transaction ending in deliberate rollback. No Email or other test data remained. The correction
adds no migration and changes no database, Club, Team, allocation, official, user or access
state. Local full tests report 264 pass and 12 intentional skips; TypeScript and production
build pass. Exact dev Security Scan run `30516436459` passed. Local/remote `dev` and
local/remote `staging` now point to the corrective commit. Render exact-commit confirmation and
focused corrective human re-smoke subsequently passed.

The control owner confirmed Render STAGING Live at exact `fbab1862`. Exact staging Security Scan
run `30516573670` passed. C1 Waiting List Club selectors, friendly Team statuses and preservation
of a Team's linked Waiting List Club all passed. A new no-attachment Club Email saved, sent and
appeared once in the intended C2 Club history, with separate provider-recipient and Club-history
audience counts displayed before send. A controlled attachment Email appeared only in its
intended Club B history, while Club A continued to see only Club A Emails. The existing resource
acknowledgement remained enforced with an explanatory notice. The remaining responsive,
keyboard and browser-activation checks stay in the companion review schedule.

The control owner subsequently confirmed the remaining R9-B authority checks: Club B was denied
Club A's copied Email-detail URL without content disclosure; Club B could download and open its
own authorised attachment; and Club A was denied Club B's copied attachment URL. R9-B focused
STAGING human smoke is PASS.

The control owner then completed the full R9-D schedule in current Chrome. Pointer, Enter and
Space each opened exactly one chooser; valid selection, drag/drop, removal, invalid type,
fourth-file and cumulative-size behaviour passed; and activation remained correct after
save/reopen and duplicate. The existing R9-B delivery evidence avoids duplicate controlled
Emails. The reduced activation check subsequently passed in Safari. R9-D human browser smoke is
PASS.

The control owner then confirmed the complete R9-C responsive Team presentation on C1 and C2:
mobile, tablet, desktop and 200% zoom passed; identity, age group, complete friendly status and
division/`Unallocated` remained visible; no status clipping or page-wide horizontal scroll
occurred; available Waiting List positions were correct; and keyboard Enter/Space opened
`More details`. R9-C human smoke is PASS. R9-B, R9-C and R9-D are now technically green on exact
STAGING `fbab1862`; production promotion remains a separate control action.

The control owner authorised production promotion. Clean repository and fast-forward checks
passed: `dev` and `staging` remain exact `fbab1862`, while `main` remains its direct ancestor at
`15559f12`. A forced-rollback production transaction against configured active endpoint
`ep-autumn-silence-abep1qat` confirmed read-only mode, fingerprint `fc6d0a8f1bc7`, 147
successful migrations, zero unfinished migrations, no R9-B candidate ledger row and neither
candidate table. No production change occurred. The fresh dormant production snapshot is the
remaining recovery gate before moving `main`.

The control owner then confirmed dormant seven-day production snapshot
`br-mute-paper-abuiyyj1`, named
`Main - snaphot before fbab1862fa8124ae5f1d64df1b2741fdb19761fc`, created
`2026-07-30 07:13:14 +01:00`. The active production database remains the target and its URL is
unchanged.

Local/remote `main` then fast-forwarded without merge commit from `15559f12` to the exact tested
candidate `fbab1862`; local/remote `dev` and `staging` already matched. Exact main Security Scan
run `30519008355` passed. Independent read-only production verification confirms 148 successful
migrations, zero unfinished migrations, the R9-B migration finished without rollback, both
additive tables present and zero visibility/visibility-recipient rows. No historic Email was
reconciled. Production health is HTTP 200 with its database connected and RLS 11/11. Render
exact-commit confirmation and non-mutating human live smoke remain pending.

## 5. Automated Evidence

```text
Prisma format/validate: PASS
focused R9-B/R9-C/R9-D plus R8-A regression tests: 22 PASS
complete Vitest run: 261 PASS; 12 intentionally skipped
TypeScript: PASS
critical-file verification: PASS
production build: PASS
npm dependency audit: PASS; zero vulnerabilities
new-migration credential/email-literal inspection: PASS
workflow-pinned Gitleaks 8.24.3, exact one-commit range: PASS; no leaks
git diff/check and pre-commit checks: PASS
local migration ledger: PASS; 148 applied
```

Repository-wide `npm run lint` remains red on pre-existing unescaped-character errors in
unrelated Bedrock, import and LMSPro coming-soon pages plus existing warning debt. Focused ESLint
found no changed production-file error; its one error is the repository parser configuration
excluding an already tracked communications test file. No unrelated lint cleanup was folded
into R9.

The local build also repeats the accepted local-only warning that Upstash is not configured.
This is an environment warning, not a production configuration change or R9 regression.

## 6. Retained Exceptions And Recovery

- Historic Email-to-Club rows are deliberately absent.
- The existing Render cron service and its registered processors are now confirmed. The adjacent
  finding is narrower: no processor for ordinary ad-hoc Emails stored with status `SCHEDULED`
  was found, and this correction does not represent that dispatcher as implemented.
- Native file-picker activation remains a named STAGING human check.
- The additive tables may remain if application rollback returns to `15559f12`; that application
  ignores them.
- R9-C and R9-D remain code-only and independently revertible.

The exact safe application recovery point is
`15559f1275d7f8ae3990cc6a9dcda5f35748e570`. The local database recovery is forward-compatible:
the old application can run with the two unused additive tables.
