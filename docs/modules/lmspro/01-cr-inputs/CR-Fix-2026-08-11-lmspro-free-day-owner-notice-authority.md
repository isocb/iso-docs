# CR-Fix — LMSPro Free Day Owner Notice Authority

Date: 2026-08-11

Owning lane: LMSPro / SeasonPro

Status: **R12-A COMPLETE GREEN LOCAL PASS; EXACT `39a25d99` ALIGNED THROUGH DEV/STAGING;
STAGING SCAN AND PUBLIC HEALTH PASS; RENDER IDENTITY/HUMAN STAGING SMOKE PENDING; NO MAIN
AUTHORITY**

## 1. Report And Clarification

A League Owner can persist the season's `freeDayNoticeOffsetDays`, but standard Free Day
request calendars and server validation currently apply:

```text
max(configured value, 28)
```

The prior 28-day default was therefore implemented as an immutable minimum. The accepted
business clarification is:

- the C1 League Owner is authoritative for the current season's standard Free Day advance
  notice;
- every integer from 1 through 90 is valid and must be honoured exactly;
- 28 days is the default when a season has not received a deliberate value, not a policy
  floor; and
- UI eligibility and server acceptance must use the same resolved value.

## 2. Impact And Severity

Classification: small remedial configuration-authority defect, medium operational impact.

The ticket/request data is not lost or exposed. The defect prevents the accepted League
policy from taking effect below 28 days and can leave the calendar apparently unchanged
after a successful save. The server also rejects dates that the owner intended to allow, so
this is not presentation-only.

## 3. Bounded Data Rule

The retained column is non-null and historically defaulted to 7 while runtime imposed 28.
The correction will:

1. change the database/new-season default to 28;
2. normalise stored `0` (newly invalid) and stored `7` (the old unattended default) to 28;
3. retain every other stored value from 1–90, including values below 28; and
4. permit an Owner to set 7 again after release, at which point 7 is authoritative.

Normalising legacy 7 to 28 preserves its pre-correction effective behaviour. It does not
shorten any current notice period during migration. No historic Free Day request is changed.

## 4. Required Outcome

- one named policy resolves an invalid/missing value to default 28 and accepts 1–90 exactly;
- both request calendars use it;
- server mutation validation uses it and remains authoritative against direct calls;
- all season create/edit validation and controls expose 1–90 and default 28;
- the current-season query is invalidated immediately after a successful policy save;
- secondary notice-period consumers use the same rule; and
- focused boundary tests prove 1, 7, 27, 28 and 90, plus invalid fallback.

## 5. Exclusions And Recovery

Excluded:

- Special Free Day application deadlines;
- request-window open/close dates;
- Free Day quota, Team eligibility, approval or notifications;
- existing request dates/statuses;
- the separately investigated League-user visibility incident, which the control owner
  resolved through P1 and explicitly closed with no further work; and
- any staging, live or shared-database change.

Recovery is application rollback while retaining the safe 28 default and normalised legacy
values. Destructive reversal of the data normalisation is neither possible nor required;
an Owner may explicitly set a new value after rollback/re-release.

## 6. Acceptance

The local candidate must pass focused policy tests, complete regression, TypeScript, Prisma
validation, safe distinct-local migration verification, changed lint, repository verification
and production build. Human smoke must prove the lower boundary, a below-28 value, default
28 and upper boundary before any staging proposal.
