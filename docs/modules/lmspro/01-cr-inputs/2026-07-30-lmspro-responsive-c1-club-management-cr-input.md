# LMSPro CR Input - Responsive C1 Club Management

Date: 2026-07-30

Module: LMSPro / SeasonPro

Source wishlist item: `LMS-W-UX-03`

Status: ACCEPTED FOR TRIAGE AND BOUNDED DELIVERY

Exact application baseline:

```text
fbab1862fa8124ae5f1d64df1b2741fdb19761fc
```

## 1. User Need

The responsive compact-card/mobile and full-table/desktop treatment delivered for C1 and C2
Team views has passed human smoke testing and materially improves clarity on small screens.
The control owner requested the same approach for C1 Club Management.

This is a presentation improvement. It must not change what a Club status means or what a C1
user may do.

## 2. Requested Outcome

C1 Club Management should:

- retain the complete desktop table at desktop widths;
- use clear compact Club cards below the desktop boundary;
- keep the Club's full and short identity, friendly status, season and Team count visible;
- retain the existing name search, season and status filters, Club-name sorting and result
  totals;
- retain access to Club detail, notes, edit, eligible approval and eligible deletion actions;
- expose the Club detail action as a clearly named native button;
- remain usable with pointer, keyboard and at 200% browser zoom; and
- avoid page-wide horizontal scrolling caused by the Club results presentation.

Friendly Club status presentation remains the existing shared contract:

```text
Current
Club Waiting List
Awaiting Verification
Ready for Review
Legacy Pending / Review
Suspended
Withdrawn
```

## 3. Explicit Non-Goals

This change does not:

- redefine admission, Current or Club Waiting List;
- change Club or Team status values;
- change Team allocation or participation convergence;
- change filtering cohorts, sorting meaning, permissions or C1/C2 access;
- add, remove or change a Club-management action;
- change a router, schema, migration, environment value or database record; or
- reopen completed R9 implementation or reconciliation.

## 4. Acceptance

The CR is complete when:

1. the desktop Club table retains its existing information and actions;
2. the compact presentation is used below the desktop boundary;
3. Club identity, status, season and Team count remain visible without clipping;
4. the existing actions remain available under their existing conditions;
5. `More details` has a Club-specific accessible name and is keyboard operable;
6. search, filters, sorting and result counts remain consistent between both presentations;
7. focused automated checks and the normal technical gates pass;
8. exact-commit dev and staging Security Scans pass; and
9. the exact staging candidate is ready for focused C1 human smoke testing.

The control owner's instruction on 2026-07-30 authorises the bounded lifecycle to progress
through local implementation, automated dev validation and staging promotion without another
administrative approval. Work must stop if a business decision is discovered.

## 5. Accepted Design Clarification

Pre-smoke review clarified the retained-action requirement:

- the compact card must not repeat generic Edit or Delete icons;
- Notes remains the useful non-destructive evidence shortcut and sits above `More details`;
- the desktop table must not retain an Actions column or small Edit/Delete/Approve targets;
- the complete desktop row is the large pointer target for Club detail;
- the Club-name control remains the explicit keyboard-operable route; and
- detailed edit/destructive workflows belong on the opened child page or protected modal, not
  as generic list-row shortcuts.

This clarification supersedes references above to retaining inline list actions. It changes
presentation and action placement only; it does not change any mutation authority.
