# LMSPro Remediation Slice R7-A - Small UI And Count Polish Planning

Date: 2026-07-07
Module: LMSPro / SeasonPro
Related CR: `docs/modules/lmspro/01-cr-inputs/2026-07-07-lmspro-cr-small-remedial-ui-and-count-polish-input.md`
Status: Implemented, browser-smoke passed, promoted to staging and live
Priority: Medium / operator polish and smoke-test unblockers

## Purpose

R7-A groups four small remedial improvements found during LMSPro smoke testing:

- compose email template removal;
- Change Request Management Age Group filtering;
- Request Type filter parity with Variation Request options;
- club dashboard Waiting List count accuracy.

The work should be implemented on local app `dev` and should stay tightly scoped.

## Product Principle

Small operator-facing inconsistencies are expensive during live testing because they make
the tester question whether the underlying workflow is correct.

This slice should remove those doubts without broad refactoring.

## Scope

### Included

- inspect existing compose email template storage and template dropdown UI;
- add a delete/remove affordance for removable email templates;
- confirm before deleting a template;
- refresh compose email template data after deletion;
- add Age Group filter to Change Request Management;
- align Request Type dropdown options with the Variation Request submission options;
- fix Club Dashboard Waiting List count source/query;
- add implementation confirmation and 05 review/test document.

### Excluded

- changing R5-B notification routing;
- changing R5-C role catalogue behaviour;
- changing template authoring beyond delete/remove;
- deleting platform/system email templates unless clearly tenant-owned and safe;
- reworking the full Change Request Management page layout;
- changing team waiting-list state transitions.

## R7-A1 - Compose Email Template Delete Control

Investigate:

- where compose email templates are stored;
- whether templates are tenant-scoped, user-scoped or platform/system templates;
- which templates are safe for C1 deletion.

Implement:

- a remove/delete icon in or alongside the compose email template dropdown/list;
- confirmation before deletion;
- server-side guard so only safe/removable templates can be deleted;
- template list refresh after deletion;
- clear error messaging if deletion is not allowed.

Acceptance:

- removable tenant templates can be deleted from compose email;
- protected templates cannot be deleted accidentally;
- sent email history is unaffected.

## R7-A2 - Age Group Filter For Change Request Management

Investigate:

- current Change Request Management page data loading;
- how Variation Requests and Free Day Requests expose team, division and age group context;
- whether Age Group can be filtered directly or must be derived via team/division.

Implement:

- Age Group dropdown filter on Change Request Management;
- filter applies to relevant request rows, especially Variation Requests;
- filter options are current-season and tenant-scoped;
- filter options are loaded from actual `LMSProAgeGroup` records, not from a static enum
  or placeholder list;
- empty/all state remains clear.

Acceptance:

- C1 can filter pending/all variation requests by Age Group;
- applying and clearing the filter updates the table correctly;
- unrelated tenant or old-season age groups are not offered.

## R7-A3 - Request Type Filter Parity

Investigate:

- the Variation Request submission request-type source;
- the Change Request Management request-type filter source;
- any hard-coded management-only option list.

Implement:

- a shared source of request-type options where practical;
- ensure `Change Division` and all other submit-able Variation Request options appear in
  the management filter;
- keep labels consistent between submission and review screens.

Acceptance:

- every Variation Request type that a club can submit is present in the management Request
  Type filter;
- filtering by each type returns the expected matching rows.

## R7-A4 - Club Dashboard Waiting List Count

Investigate:

- current Club Dashboard Season widget data source;
- team statuses used for waiting-list teams;
- current-season and current-club scoping;
- whether the count is wrongly reading applications, teams, stale season data or the wrong
  status value.

Implement:

- correct Waiting List count query/resolver;
- keep count scoped to the logged-in club and current season;
- preserve Active Teams and Officials counts unless a shared query bug is found.

Acceptance:

- Waiting List widget matches the number of current-season teams on the waiting list for
  the club;
- count updates after relevant team state changes;
- Active Teams and Officials widgets still report correctly.

## Review And Test Plan

Browser smoke:

- create or identify a removable compose email template;
- delete it via the new icon/control;
- confirm it disappears from the template dropdown/list;
- confirm protected templates, if present, cannot be accidentally deleted;
- open Change Request Management;
- filter by Age Group and confirm rows update correctly;
- confirm Request Type filter includes `Change Division`;
- filter by each available Variation Request type where sample data exists;
- open a C2 club dashboard with known waiting-list teams;
- confirm Waiting List count matches the underlying team list.

Developer checks:

```text
npm run type-check
git diff --check
```

## Promotion Record

Completed on 2026-07-07.

- app `dev` commit: `af79dec`;
- app `staging` promoted to `af79dec`;
- app live `main` promoted to `af79dec`;
- docs committed to `origin/main`.

Live `main` was behind staging before promotion, so the live fast-forward included the
current staging train:

- `8ed0c36` - Fund catalogue-centric project product picker;
- `b091e48` - LMSPro communications workflow refinements;
- `e282e2f` - LMSPro manager scoped notification routing;
- `f3ca6f8` - LMSPro scoped notifications and role catalogue polish;
- `af79dec` - R7-A small UI and count polish.

## Risks

- deleting a shared/system email template by mistake;
- duplicating request-type definitions instead of sharing them;
- deriving Age Group incorrectly when requests only store team/division references;
- fixing the waiting-list count for one status label while missing another valid waiting
  list state.

## Mitigations

- use server-side deletion guards for templates;
- prefer shared request-type constants or a single mapper;
- derive Age Group from current-season team/division relationships;
- test with known waiting-list data in staging/live-like tenant data.

## Suggested Handoff Prompt

```text
Proceed with LMSPro Remediation Slice R7-A on local app dev. Keep the work limited to
compose email template deletion, Change Request Management Age Group/request-type filters,
and Club Dashboard Waiting List count accuracy. Preserve R5-B notification routing and
R5-C role catalogue behaviour. Create implementation confirmation and 05 review/test docs
after implementation.
```
