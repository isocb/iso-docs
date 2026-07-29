# LMSPro R9-B To R9-D Combined Technical Review And STAGING Human Smoke Test

Date: 2026-07-29

Status: AUTOMATED LOCAL REVIEW PASS; DEV ALIGNED AND EXACT SECURITY SCAN PASS; STAGING
RECOVERY SNAPSHOT AND DEPLOYMENT PENDING

Application under review:

`58ef44fd7c91e2c5932f0634bfa803bbfa13dd55`

Recovery baseline:

`15559f1275d7f8ae3990cc6a9dcda5f35748e570`

Migration:

`prisma/migrations/20260729170000_lmspro_r9_b_email_club_visibility/migration.sql`

## 1. Review Disposition

| Outcome | Automated/local technical result | Human result |
| --- | --- | --- |
| R9-B prospective Club Email history | PASS | PENDING |
| R9-C shared responsive Team status | PASS | PENDING |
| R9-D pointer/keyboard attachment browse | PASS at bounded source/selection level | PENDING — authoritative browser proof |
| Migration on authorised local development DB | PASS | N/A |
| Historic reconciliation | NOT EXECUTED | NOT AUTHORISED |

The control owner accepted that historic Emails are intentionally excluded and authorised the
exact candidate to progress through `dev` to STAGING. STAGING is the authoritative human browser
smoke environment; repeating the complete schedule locally is not a promotion precondition.
Production remains outside this record.

Release evidence:

```text
local dev:              58ef44fd7c91e2c5932f0634bfa803bbfa13dd55
origin/dev:             58ef44fd7c91e2c5932f0634bfa803bbfa13dd55
dev Security Scan:      PASS — run 30466540339
local staging:          15559f1275d7f8ae3990cc6a9dcda5f35748e570
origin/staging:         15559f1275d7f8ae3990cc6a9dcda5f35748e570
main/origin-main:       15559f1275d7f8ae3990cc6a9dcda5f35748e570
STAGING snapshot:       PENDING
STAGING deploy/smoke:   NOT STARTED
```

## 2. Preconditions For STAGING Human Smoke

- run exact commit `58ef44fd7c91e2c5932f0634bfa803bbfa13dd55`;
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
58ef44fd7c91e2c5932f0634bfa803bbfa13dd55

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
- verify migration ancestry and absence of failed/rolled-back migrations;
- verify the two new audience tables are absent before migration;
- record aggregate Email/recipient/table counts only; and
- do not retrieve names, addresses, bodies, UUIDs or provider evidence.

If preflight passes, apply only the additive migration, independently verify the ledger and
unchanged existing Email/recipient/resource aggregates, then deploy exact commit 58ef44fd.
Do not insert historic audience rows and do not execute reconciliation.

After the exact STAGING Security Scan, Render deployment and migration-ledger verification pass,
stop for the control owner to run the focused R9-B, R9-C and R9-D human schedule from:
isodocs/docs/modules/lmspro/05-review-and-test/2026-07-29-lmspro-remediation-slices-r9-b-to-r9-d-combined-local-review-and-smoke-test.md

Use controlled STAGING mailboxes and Clubs only. Do not send an uncontrolled Email.

Stop after STAGING technical and human evidence is recorded. Do not query or change production,
promote to main, execute historic reconciliation or alter environment values.
```
