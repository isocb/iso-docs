# LMSPro R9-B To R9-D Combined Technical Review And STAGING Human Smoke Test

Date: 2026-07-29

Status: AUTOMATED LOCAL REVIEW PASS; INITIAL STAGING DEPLOYMENT, MIGRATION, SECURITY SCAN,
WEB HEALTH AND CRON TICK PASS; HUMAN SMOKE STOPPED ON CORRECTABLE APPLICATION DEFECTS;
CORRECTIVE DEPLOYMENT AND COMPLETE STAGING HUMAN SMOKE PASS; PRODUCTION READ-ONLY PREFLIGHT
PASS; FRESH PRODUCTION SNAPSHOT PENDING

Application under review:

`fbab1862fa8124ae5f1d64df1b2741fdb19761fc`

Initial STAGING smoke candidate:

`f321eb07936ec546e8738c22709809b2704be5ed`

Recovery baseline:

`15559f1275d7f8ae3990cc6a9dcda5f35748e570`

Migration:

`prisma/migrations/20260729170000_lmspro_r9_b_email_club_visibility/migration.sql`

## 1. Review Disposition

| Outcome | Automated/local technical result | Human result |
| --- | --- | --- |
| R9-B prospective Club Email history | PASS after corrective transaction test | PASS |
| R9-C shared responsive Team status | PASS after corrective selector/label tests | PASS |
| R9-D pointer/keyboard attachment browse | PASS at bounded source/selection level | PASS — Chrome and Safari |
| Migration on authorised local development DB | PASS | N/A |
| Historic reconciliation | NOT EXECUTED | NOT AUTHORISED |

The control owner accepted that historic Emails are intentionally excluded and authorised the
exact candidate to progress through `dev` to STAGING. STAGING is the authoritative human browser
smoke environment; repeating the complete schedule locally is not a promotion precondition.
Production remains outside this record.

Release evidence:

```text
local dev:              fbab1862fa8124ae5f1d64df1b2741fdb19761fc
origin/dev:             fbab1862fa8124ae5f1d64df1b2741fdb19761fc
dev Security Scan:      PASS — run 30516436459
local staging:          fbab1862fa8124ae5f1d64df1b2741fdb19761fc
origin/staging:         fbab1862fa8124ae5f1d64df1b2741fdb19761fc
main/origin-main:       15559f1275d7f8ae3990cc6a9dcda5f35748e570
STAGING snapshot:       PASS — recovery-only branch br-long-glade-abv9jrk0
STAGING preflight:      PASS — explicitly read-only; rolled back
STAGING Security Scan:  PASS — run 30516573670
STAGING Render web:     PASS — control-owner confirmation Live at fbab1862; health HTTP 200
STAGING migration:      PASS — 148 applied; candidate finished
STAGING cron tick:      PASS — build/run exact f321eb0
STAGING human smoke:    PASS — R9-B, R9-C and R9-D
```

The control owner confirmed the immediately pre-deployment recovery point:

```text
snapshot branch ID: br-long-glade-abv9jrk0
snapshot branch name: Staging Snaphot before cronjob fix 2026-07-30
snapshot created: 2026-07-30 05:34:51 +01:00
disposition: dormant recovery copy only
```

The active STAGING database remains the migration/deployment target. Its URL must not be replaced
with the snapshot URL.

The pre-snapshot read-only STAGING preflight recorded:

```text
configured target fingerprint:              016aba10adf6
database/session:                           neondb; transaction_read_only=on
authorised tenant/season match:             1
successfully applied migrations:            147
unfinished migrations:                      0
historic rolled-back attempts:              8
historic names without later successful row: 0
last successful migration:                  20260729123000_lmspro_team_approved_unallocated
candidate migration rows:                   0
candidate tables present:                   0
Emails / recipients / attachments / links: 28 / 556 / 20 / 8
transaction terminator:                     ROLLBACK
```

The eight rolled-back rows are the previously reviewed resolved retry history, not unresolved
ledger failures. No names, addresses, bodies, row identifiers or provider evidence were
retrieved. The initially recorded `d315b1dd8b98` value used an ad-hoc local hash shape and has
been corrected to the application's credential-safe fingerprint algorithm; it was not evidence
of a different database.

## 2A. STAGING Technical Deployment Evidence

Local and remote STAGING fast-forwarded without merge commit from `15559f12` to exact
`f321eb07936ec546e8738c22709809b2704be5ed`. Exact staging Security Scan run
`30514385014` passed.

The public login page's compiled layout bundle changed from displayed build `15559f1` to
`f321eb0`. The post-switch `/api/health` result is HTTP 200, database connected and RLS enabled
on 11/11 expected tables.

Independent aggregate-only database verification ran in an explicitly read-only transaction:

```text
candidate migration:     1 finished; 0 unfinished; 0 rolled back
successful migrations:   148
candidate tables:        2
Club visibility rows:    0
visibility-recipient rows: 0
Emails / recipients / attachments / links: 28 / 556 / 20 / 8
transaction terminator:  ROLLBACK
```

The unchanged existing aggregates and zero candidate-table rows prove that the additive
migration did not reconcile or rewrite historic Email evidence. The workspace has no Render API
credential and therefore does not invent a cron-log result. The actual STAGING Cron Job
`isostack-bedrock-1` subsequently supplied that evidence.

The control owner confirmed Render Cron Job `crn-d6t7bpf5gffc738vlcn0`, build
`bld-d9lda6142hec73civ1tg`, succeeded for exact displayed `f321eb0`. Its invocation reported
database fingerprint `016aba10adf6`, matching the active STAGING target under the application's
credential-safe fingerprint function. All five processors ran; one active key-date sequence was
observed but none fired; no attachment job was claimable; total processing was zero with zero
errors; and the tick finished successfully. No `server-only` failure or provider send occurred.

## 2B. Initial Human Smoke Stop And Bounded Correction

Human smoke began on exact `f321eb07`. Historic Emails being absent from C2 history was
accepted as expected. The smoke stopped before controlled delivery because:

- Club-recipient and Team Club selectors used the older Current-only Club query and excluded
  registered Clubs on the Club Waiting List;
- the C1 Club Teams table and status filters bypassed the shared friendly Team-status
  presentation, so `APPROVED` appeared as `Approved` rather than
  `Approved & Unallocated`;
- editing a Team linked to a Waiting List Club could display no selected Club because that Club
  was absent from the mandatory selector;
- a no-attachment Email failed before save with a misleading attachment-preparation message;
  and
- an Email with a resource left Send disabled until the existing R8-A responsibility
  acknowledgement was selected, but the disabled control did not explain that requirement.

The Email failure was reproduced against the normal local development database in a transaction
that was forced to roll back. The new nested Club-visibility recipient writer incorrectly
supplied the parent `emailId` a second time; Prisma rejected that nested field before the Email
could be saved. Removing the duplicate field let the full Email, recipient and Club-audience
transaction reach the deliberate rollback. No diagnostic Email or data change remains.

Corrective commit `fbab1862fa8124ae5f1d64df1b2741fdb19761fc`:

- includes Current and Club Waiting List Clubs for the exact active season, with Waiting List
  options labelled `(Club Waiting List)` and Club-name sorting retained;
- uses shared friendly Team-status labels and exposes `Approved & Unallocated` in filters and
  edit workflow;
- preserves the selected Waiting List Club while a Team is edited or allocated;
- removes the invalid duplicate nested Email ID;
- replaces the misleading catch-all attachment error with a neutral Email-operation failure;
  and
- keeps the R8-A acknowledgement mandatory while allowing Send to be activated so the existing
  explanatory validation notice is shown.

This correction changes no schema, migration, database record, Email history, Team or Club
state. Local evidence is 264 passing tests with 12 intentional skips, TypeScript pass,
production build pass, focused changed-source lint with no errors, and a successful real
database transaction ending in forced rollback. Exact dev Security Scan run `30516436459`
passed. Local/remote `dev` and local/remote `staging` fast-forwarded to exact `fbab1862`; Render
exact-commit confirmation and the focused corrective re-smoke subsequently passed as recorded
below.

## 2D. Corrective STAGING Re-Smoke Result

The control owner confirmed Render STAGING **Live at `fbab1862`**. Exact staging Security Scan
run `30516573670` passed, and the public health endpoint remained HTTP 200 with the database
connected and RLS enabled on 11/11 expected tables.

Focused C1 correction checks passed:

- the Club filter included Current and Club Waiting List Clubs;
- Waiting List Clubs displayed with the `(Club Waiting List)` suffix in Club-name order;
- Team status filtering included `Approved & Unallocated`;
- a Team linked to a Waiting List Club retained its mandatory Club in the edit modal; and
- the Club detail Teams table displayed `APPROVED` as `Approved & Unallocated`.

Focused prospective Email checks passed:

- a Waiting List Club was selectable;
- separate provider-recipient and Club-history audience counts appeared;
- a new no-attachment Email sent successfully and appeared once in C1 Sent;
- the same new Email appeared once in the intended Club A C2 history;
- historic Email absence remained the accepted expected result;
- a valid attachment could be selected;
- attempting Send before acknowledgement produced the explanatory acknowledgement notice;
- accepting the existing R8-A responsibility statement permitted Send;
- a controlled attachment Email sent to Club B appeared in Club B history with an earlier
  controlled Club B Email; and
- Club A could see only Club A Emails and not Club B Emails.

The list-level cross-Club privacy boundary and separate provider-recipient/Club-history audience
counts are evidenced as PASS. The control owner then confirmed:

- Club B could not open Club A's copied Email-detail URL or see its content;
- Club B could download and open its own authorised attachment; and
- Club A could not use Club B's copied attachment URL.

R9-B focused STAGING human smoke is therefore PASS. No addresses, content, private URLs or
identifiers are recorded.

## 2E. R9-D Chrome Browser Result

The complete R9-D schedule passed in current Chrome against exact STAGING `fbab1862`:

- pointer activation opened exactly one native file chooser;
- keyboard focus reached the Dropzone and Enter/Space each opened exactly one chooser;
- one valid file produced one selected row without duplication;
- drag/drop used the same selected-file presentation;
- removing a file did not reopen the chooser;
- an invalid type was unavailable in the native chooser and was not accepted;
- a fourth file and a cumulative selection over 10 MB were refused;
- save/reopen retained working pointer and keyboard activation; and
- duplicate-draft pointer and keyboard activation passed.

The already completed R9-B smoke supplies attachment and no-attachment delivery regression
evidence. It need not be repeated for R9-D. The control owner subsequently confirmed the reduced
activation check passed in Safari. Chrome and Safari evidence therefore closes R9-D human smoke
as PASS.

## 2F. R9-C Responsive And Accessibility Result

The control owner completed the focused C1 and C2 Team presentation schedule against exact
STAGING `fbab1862`. All checks passed:

- mobile, tablet, desktop and 200% zoom presentations remained usable;
- Team identity, age group, complete friendly status and division/`Unallocated` remained
  visible;
- status text did not clip and no page-wide horizontal scrolling appeared;
- available Waiting List positions displayed correctly; and
- keyboard Enter/Space opened the existing `More details` interaction.

R9-C human smoke is PASS. Together with the completed R9-B and R9-D results, the combined
R9-B-to-R9-D STAGING human boundary is PASS and exact `fbab1862` is ready for a separately
controlled production-promotion decision.

## 2G. Production Promotion Preflight

The control owner authorised promotion of exact `fbab1862`. Before changing `main`, deployment
or data, the repository and configured production database were checked.

Repository evidence:

```text
candidate/feature:  fbab1862fa8124ae5f1d64df1b2741fdb19761fc
dev/origin-dev:     fbab1862fa8124ae5f1d64df1b2741fdb19761fc
staging/origin:     fbab1862fa8124ae5f1d64df1b2741fdb19761fc
main/origin-main:   15559f1275d7f8ae3990cc6a9dcda5f35748e570
fast-forward proof: PASS
worktrees:          clean
dev Security Scan:  PASS — 30516436459
staging scan:       PASS — 30516573670
```

The configured `PRODUCTION_DATABASE_URL` resolved to active endpoint
`ep-autumn-silence-abep1qat-pooler.eu-west-2.aws.neon.tech`, fingerprint `fc6d0a8f1bc7`.
An explicitly read-only transaction recorded:

```text
database:                    neondb
transaction_read_only:       on
successful migrations:       147
unfinished migrations:       0
R9-B candidate ledger rows:  0
R9-B candidate tables:       0
terminator:                   ROLLBACK
```

This is the expected pre-promotion state. No production row, schema, environment or deployment
changed. Promotion is paused until the control owner confirms a fresh dormant snapshot of this
active production branch.

The recovery gate is satisfied. The control owner confirmed:

```text
snapshot name: Main - snaphot before fbab1862fa8124ae5f1d64df1b2741fdb19761fc
snapshot branch ID: br-mute-paper-abuiyyj1
created: 2026-07-30 07:13:14 +01:00
time to live: 7 days
disposition: dormant recovery copy only
```

The active production database and URL remain unchanged.

## 2C. Retained Preconditions For STAGING Human Smoke

These were the initial `f321eb07` deployment preconditions and remain as evidence. The
corrective re-smoke must instead confirm exact `fbab1862fa8124ae5f1d64df1b2741fdb19761fc`;
it requires no new migration or database change.

- initial smoke ran exact commit `f321eb07936ec546e8738c22709809b2704be5ed`;
- first fast-forward `dev` and `origin/dev`, and require the exact dev Security Scan to pass;
- create and record a fresh dormant snapshot of the current STAGING database immediately before
  migration; keep the current STAGING database as the target and do not change its URL;
- use controlled non-personal STAGING mailboxes and disposable current-season Clubs;
- confirm Render is Live at the exact candidate and the migration ledger contains
  `20260729170000_lmspro_r9_b_email_club_visibility`;
- treat historic Email absence from C2 history as expected; test only Emails created after the
  migration and candidate deployment;
- do not execute reconciliation; and
- stop if the displayed commit, database or tenant differs.

Before human Email smoke, confirm one STAGING cron invocation:

- loads every registered processor without a `server-only` error;
- completes with its normal processor summary;
- uses the unchanged active STAGING database target; and
- does not send a notification merely as a consequence of this verification.

## 3. R9-B Focused Schedule

Use one authorised C1 and two controlled C2 Clubs.

1. In compose, select one Club cohort. Confirm separate provider-recipient and Club-history
   counts appear before save/send.
2. Add an unlinked manual address. Confirm the warning states that it will not appear in a Club
   dashboard.
3. Select an exact Club link for that manual address. Confirm the warning clears and the Club
   audience count changes correctly.
4. Send one controlled no-attachment Email to one Club. Confirm one C1 Sent row and one C2
   history row.
5. Confirm C2 list shows subject, date, delivery state and resource counts but no recipient
   name/address.
6. Open detail. Confirm resolved content loads only after the detail request.
7. As the other C2 Club, confirm the Email cannot be listed or opened by a copied Email UUID.
8. Use one shared controlled recipient deliberately representing two Clubs. Confirm one provider
   delivery and one authorised history row in each Club.
9. Exercise enough disposable history to expose `Load more`; confirm stable order and no
   duplicate Email.
10. Send one controlled attachment Email. Confirm same-Club detail shows the resource and a
    different Club cannot obtain its download URL.
11. Where a controlled partial/failed provider outcome is available, confirm zero accepted
    primary recipients creates no C2 Sent row and mixed outcome displays `Partially sent`.

Do not record addresses, content, UUIDs, magic links or provider diagnostics in IsoDocs.

## 4. R9-C Responsive And Accessibility Schedule

Repeat C1 League Teams and C2 Club Teams at:

```text
320, 375, 390/430, 768, 1024 and 1280 CSS px
200% browser zoom
```

Cover Current, Approved & Unallocated, Pending Approval, Waiting List with single- and
multi-digit position/total, Suspended, Withdrawn, Declined, No Response and the remaining
available statuses.

Confirm:

- compact cards below the desktop boundary and complete table at desktop;
- Team/Club identity, age group, complete status and division/`Unallocated` remain visible;
- no status text clips, shrinks or ellipsises;
- screen-reader name says `Waiting List, position X of Y`;
- Tab reaches `More details`, Enter/Space opens the correct existing modal;
- lower-priority manager, notes, Free Days and variation evidence remains in the modal/table;
- filters, sorting, allocation and waiting-list order are unchanged; and
- no browser-wide horizontal clipping occurs.

## 5. R9-D Browser Schedule

Use current Chrome and Edge against STAGING; repeat Firefox/Safari where used.

1. Open a new Email draft and focus the Dropzone by keyboard.
2. Press Enter, cancel the picker, then press Space. Confirm exactly one native picker opens per
   activation.
3. Click the Dropzone and select one valid file. Confirm one selected row.
4. Drag/drop another valid file. Confirm the same validation/result presentation.
5. Verify invalid type, empty file, fourth file and over-10-MB cumulative refusal.
6. While processing, confirm click and keyboard do not open another picker.
7. Remove a file and confirm removal does not open the picker.
8. Save/reopen a draft and repeat pointer/keyboard selection.
9. Duplicate a draft and repeat.
10. Send one controlled attachment and one no-attachment Email, confirming the existing R8-A
    delivery routes remain unchanged.

## 6. Result Capture

Record only:

```text
exact commit:
browser/version:
R9-B C1:
R9-B C2 same Club:
R9-B other-Club denial:
R9-B resource authority:
R9-C C1 matrix:
R9-C C2 matrix:
R9-C keyboard/screen-reader:
R9-D pointer:
R9-D Enter/Space:
R9-D drag/drop:
R9-D processing/removal:
R8-A attachment delivery:
R8-A no-attachment delivery:
unexpected behaviour:
```

Any R9-B authority failure, cross-Club disclosure, duplicate provider delivery, migration
mismatch or R8-A regression is a stop condition. A presentation defect may be corrected locally
without expanding the business or data boundary.

## 7. Authorised STAGING Progression

```text
Proceed with controlled LMSPro R9-B to R9-D STAGING validation only.

Use exact application commit:
f321eb07936ec546e8738c22709809b2704be5ed

Use migration:
20260729170000_lmspro_r9_b_email_club_visibility

First confirm the automated local review is complete and accepted, the exact dev Security Scan
is green, the application tree is clean, STAGING is still at the expected accepted parent, and
the configured database is STAGING rather than local or production. A duplicate complete local
human smoke is not required.

Create and record a fresh dormant STAGING database snapshot as recovery. The current STAGING
database remains the deployment target; do not change its URL to the snapshot.

Preflight read-only and stop on any mismatch:
- verify exact STAGING database identity and tenant/current-season scope;
- verify migration ancestry and absence of unfinished or unresolved rolled-back migrations;
- verify the two new audience tables are absent before migration;
- record aggregate Email/recipient/table counts only; and
- do not retrieve names, addresses, bodies, UUIDs or provider evidence.

If preflight passes, apply only the additive migration, independently verify the ledger and
unchanged existing Email/recipient/resource aggregates, then deploy exact commit f321eb07.
Do not insert historic audience rows and do not execute reconciliation.

After the exact STAGING Security Scan, Render deployment, migration-ledger verification and one
successful STAGING cron tick pass, stop for the control owner to run the focused R9-B, R9-C and
R9-D human schedule from:
isodocs/docs/modules/lmspro/05-review-and-test/2026-07-29-lmspro-remediation-slices-r9-b-to-r9-d-combined-local-review-and-smoke-test.md

Use controlled STAGING mailboxes and Clubs only. Do not send an uncontrolled Email.

Stop after STAGING technical and human evidence is recorded. Do not query or change production,
promote to main, execute historic reconciliation or alter environment values.
```
