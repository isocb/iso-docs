# LMSPro R12-A Free Day Owner Notice Authority Implementation

Date: 2026-08-11

Status: **IMPLEMENTED; COMPLETE LOCAL HUMAN PASS; EXACT `39a25d99` ALIGNED THROUGH DEV AND
STAGING; STAGING ACCEPTANCE PENDING**

CR:

[`Free Day Owner notice authority CR-Fix`](../01-cr-inputs/CR-Fix-2026-08-11-lmspro-free-day-owner-notice-authority.md)

Plan:

[`R12-A planning`](../03-slice-planning/2026-08-11-lmspro-r12-a-free-day-owner-notice-authority-planning.md)

## 1. Delivered Correction

The former runtime rule treated 28 as a hard floor even after a League Owner successfully
saved a lower value. R12-A now has one shared rule:

```text
valid configured integer 1-90 -> use exactly that value
missing or invalid value       -> use default 28
```

That rule is consumed by both standard Free Day request calendars, the direct server
request gate and the Team-list derived notice calculation. The exact server boundary is
shared and covered: the configured day is accepted and the preceding day is refused.

Season create/edit controls now default to 28 and accept 1-90. Successful saves invalidate
the current-season query as well as the existing list/detail queries, so calendars receive
the changed policy immediately rather than waiting for cache staleness.

## 2. Data And Migration

Migration `20260811120000_lmspro_free_day_owner_notice_authority`:

- changes the database column default from 7 to 28;
- normalises stored 0 and stored 7 to 28, preserving their former effective 28-day
  behaviour;
- adds a database check constraint for 1-90; and
- changes no Free Day request row.

The migration was applied only to the validated distinct local-development database. The
shared `.env` database was explicitly excluded. Migration status and a dedicated read-only
schema/data verifier pass.

## 3. Files

Application and schema:

```text
prisma/schema.prisma
prisma/migrations/20260811120000_lmspro_free_day_owner_notice_authority/migration.sql
scripts/verify-lmspro-free-day-notice-authority.ts
src/modules/lmspro/lib/free-day-notice-policy.ts
src/modules/lmspro/lib/free-day-notice-policy.test.ts
src/modules/lmspro/components/dashboard/FreeDaysRequest.tsx
src/app/(app)/app/lmspro/club/free-days/page.tsx
src/server/core/routers/lmspro/freeDays.router.ts
src/modules/lmspro/routers/teams.router.ts
src/modules/lmspro/routers/seasons.router.ts
src/app/(app)/app/lmspro/seasons/page.tsx
src/app/(app)/app/lmspro/seasons/[seasonId]/_components/SeasonOverviewTab.tsx
```

## 4. Technical Evidence

| Gate | Result |
| --- | --- |
| Focused policy suite | PASS — 14/14 |
| Complete Vitest suite | PASS — 403 passed, 12 skipped; 62 files passed, 1 skipped |
| TypeScript | PASS |
| Prisma schema validation | PASS |
| Distinct local migration deploy/status | PASS — 151 migrations current |
| R12-A local schema/data verification | PASS |
| Critical-file verification | PASS |
| Changed application-source ESLint errors | PASS — zero errors (`--quiet`) |
| Production build | PASS — 131 pages |
| Diff whitespace check | PASS |

Build output retains the existing local warning that Upstash is not configured; this does
not affect the Free Day policy correction.

## 5. Scope Control

- The originally local-only candidate was subsequently accepted, isolated from Support
  Ticketing, committed as exact `39a25d99` and aligned through `origin/dev` and
  `origin/staging`. `main` remains unchanged.
- Special Free Days, request windows, quotas, Team eligibility, approvals, notifications
  and existing requests are unchanged.
- The closed League-user deactivation incident is not part of R12-A.
- Pre-existing uncommitted Support Ticketing work and the unrelated workspace-file change
  remain present and were not incorporated into this slice's disposition.

Human gate:

[`R12-A local review and smoke`](../05-review-and-test/2026-08-11-lmspro-r12-a-free-day-owner-notice-authority-local-gate.md)
