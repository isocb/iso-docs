# PLAT-SUPPORT-03A — P1 Workbench Entry, Editing And Queue Planning

Date: 2026-08-11

Status: **IMPLEMENTED IN EXACT `cde4eaff`; COMBINED LOCAL HUMAN SMOKE PASS; DEV/STAGING
ALIGNED AND EXACT SECURITY SCANS PASS; STAGING HUMAN ACCEPTANCE PENDING**

CR:

[`P1 workbench editing and case tracking CR-Fix`](../01-cr-inputs/CR-Fix-2026-08-11-isostack-platform-support-p1-workbench-editing-and-case-tracking.md)

## 1. Objective

Make the existing P1 Support workbench discoverable and genuinely editable, then present
the cross-tenant queue as a scannable expandable management table without weakening the
responsive/mobile experience.

## 2. Implementation

1. Change only the non-impersonating P1 `Support Tickets` navigation target to
   `/platform?tab=support&subtab=tickets`; retain client `/support`.
2. Separate ticket-draft initialisation from the idempotent first-review effect so local
   Select changes are not reset on rerender.
3. Track triage dirty state, disable Save when unchanged, and provide Reset/Cancel feedback.
4. On successful mutation, refresh detail/list/stats and display persisted values.
5. Allow P1 creation to set Severity and Impact as optional initial classification.
6. Replace desktop queue cards with semantic table rows and expandable summary/detail.
7. Retain a stacked expandable card at narrow widths.
8. Add pagination using the existing server page/pageSize contract; filters remain stable.

## 3. Automated Acceptance

- pure draft initialisation/dirty comparison tests prove Select edits survive unrelated
  rerenders;
- create/update schema permits P1 classification and refuses unauthorised clients;
- P1 navigation target is exact and impersonated/client navigation remains unchanged;
- queue expansion does not mark a different ticket reviewed or reset filters; and
- existing Support router/privacy/notification tests remain green.

## 4. Human Acceptance

Using the canonical P1 route, change and persist every triage field independently and in
combination; verify Reset, reopen stability, filter retention, pagination, expandable row,
desktop/narrow layout and P1 navigation. Direct C1 mutation remains refused.

Evidence: [`combined local gate`](../05-review-and-test/2026-08-11-isostack-platform-plat-support-03a-03b-combined-local-review-and-smoke-gate.md).
