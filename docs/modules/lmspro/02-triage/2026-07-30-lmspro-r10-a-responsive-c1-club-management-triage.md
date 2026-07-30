# LMSPro R10-A Responsive C1 Club Management Triage

Date: 2026-07-30

Module: LMSPro / SeasonPro

Status: ACCEPTED; SELECTED FOR IMMEDIATE CODE-ONLY PLANNING AND DELIVERY

Source:

`docs/modules/lmspro/01-cr-inputs/2026-07-30-lmspro-responsive-c1-club-management-cr-input.md`

Roadmap source:

`LMS-W-UX-03`

## 1. Decision

Accept the wishlist item as:

```text
R10-A - Responsive C1 Club Management Presentation
```

R10-A is a small, independently testable code-only UI slice. It follows completed R9 and does
not reopen R9-A Club business logic or R9-C Team presentation.

## 2. Priority And Proportionality

Priority is medium. The existing desktop view is operational, but its wide table is not a
deliberate small-screen presentation and the tested Team card/table approach now provides a
low-risk precedent.

Risk is low to moderate:

- accidental omission of a retained action on compact cards;
- inconsistent card/table status or count presentation;
- filter or sort divergence; and
- keyboard or zoom regression.

No database, tenant-isolation, notification, migration or data-recovery risk is introduced
when the slice remains within its accepted boundary.

## 3. Confirmed Source Position

At exact baseline `fbab1862`:

- C1 Club Management is implemented in one client page;
- one filtered and sorted Club collection already drives the desktop table;
- friendly statuses already come from `getClubStatusPresentation`;
- direct approval eligibility already comes from `canUseDirectClubApproval`;
- the table exposes Club detail, notes, edit, eligible approval and eligible deletion;
- the current result area is a wide table without a compact mobile equivalent; and
- completed R9-C proves Mantine `hiddenFrom="md"` cards and `visibleFrom="md"` tables as the
  accepted responsive boundary.

These findings leave no unresolved business question.

## 4. Selected Boundary

R10-A may:

- add one reusable presentational Club card;
- render the existing sorted results as cards below `md` and as the retained table from `md`;
- make the page heading/filter controls wrap safely;
- expose a matching-results count;
- add focused presentation tests; and
- progress through dev gates and exact staging deployment.

R10-A may not:

- change Club list query authority or result scope;
- change status derivation, business labels or action eligibility;
- change create/edit/delete/approve/notes mutation behaviour;
- add schema, migration, database, environment or notification work; or
- change production.

## 5. Recovery And Control

The recovery baseline is exact `fbab1862fa8124ae5f1d64df1b2741fdb19761fc`.
Because the change is code-only, recovery is a Git revert or branch reset to that known tree
before promotion. No database snapshot, rollback or reconciliation is required.

The control owner's 2026-07-30 instruction authorises planning, implementation, automated dev
validation and staging promotion if all gates pass. Human staging smoke remains the next
control gate before any production promotion.

