# LMSPro Remediation Slice R2-A - Import Club User Membership Strengthening Confirmation

Date: 2026-07-01
Module: LMSPro / SeasonPro
Local work branch: `fix/lmspro-import-club-user-remediation`
Baseline: `7a7354a feat(fund): add project product eligibility services`
Status: Implemented, committed, consolidated to `dev`, promoted to staging

## Slice Goal

Strengthen the LMSPro club import/user-linking path and the affected C2 team save checks so imported Club users are linked through the authoritative club membership table and are less likely to fail after season roll-forward.

This slice is prevention and save-path hardening only.

No data remediation was run.

## Commit References

```text
1424a86 fix(lmspro): strengthen imported club user membership
34795cb chore(lmspro): add all-user membership audit mode
21f6ced chore(lmspro): add roll-forward graph audit
```

Promotion state:

```text
dev -> origin/dev -> staging -> origin/staging
```

The local app repo was returned to `dev` after promotion.

## Problem Addressed

Imported C2 Club users could log in and open club/team screens, but team saves could fail with a wrong-club message.

The likely root cause is a combination of:

- imported primary contacts being converted into active users after the original passive club import;
- some users having only the legacy `User.lmsproClubId` pointer;
- missing `LMSProClubOfficial` membership rows;
- roll-forward/season clone creating new current-season club IDs;
- save paths comparing the current team club only against the legacy user club pointer.

## Implementation Summary

Implemented:

- `provisionClubUser` now ensures a `LMSProClubOfficial` row exists when it creates or links a club primary contact user.
- Existing same-organisation users are no longer skipped simply because `User.lmsproClubId` already has a value.
- Cross-organisation email matches are skipped to avoid unsafe user hijacking.
- Legacy `User.lmsproClubId` is repaired only when absent, missing, already matching, or clearly the same club by name.
- A shared permitted-club resolver now combines:
  - legacy `User.lmsproClubId`;
  - `LMSProClubOfficial` rows;
  - same-name cloned-season club records.
- `teams.setContinuation` and `teams.updateByClub` now use the resolver instead of only checking `User.lmsproClubId`.
- Focused regression tests were added for the import helper.
- A read-only staging audit script was added for live-snapshot review.
- The audit script now supports:
  - action-focused output;
  - all-user output via `REPORT_SCOPE=all`;
  - a target email via `TARGET_EMAIL=...`.
- The audit classification label `CODE_FIX_SHOULD_HELP` was replaced with `CODE_FIX_COVERS_THIS_CASE`.
- A second read-only graph audit script was added to check whether the problem is user membership, team roll-forward graph data, or both.

## Files Changed

App files:

- `scripts/lmspro-r2-membership-audit.ts`
- `scripts/lmspro-r2-rollforward-graph-audit.ts`
- `src/modules/lmspro/lib/provision-club-user.ts`
- `src/modules/lmspro/lib/resolveClubId.ts`
- `src/modules/lmspro/routers/teams.router.ts`
- `src/modules/lmspro/lib/__tests__/provision-club-user.test.ts`

Documentation:

- `docs/guides/neon-branch-backup-restore.md`
- `isodocs/docs/modules/lmspro/03-slice-planning/2026-07-01-lmspro-remediation-slice-r2-imported-club-user-membership-and-roll-forward-repair-planning.md`
- `isodocs/docs/modules/lmspro/04-implementation-confirmations/2026-07-01-lmspro-remediation-slice-r2-a-import-club-user-membership-strengthening-confirmation.md`

## Import Provisioning Behaviour

Updated `provisionClubUser` behaviour:

- If no contact email is supplied, skip as before.
- If a matching user exists in another organisation, skip.
- If a matching user exists in the same organisation:
  - ensure `LMSProClubOfficial` membership exists for the imported club;
  - add the default club role ID when available;
  - keep or set the club-secretary role;
  - set status to `ACTIVE`;
  - repair `User.lmsproClubId` when the existing pointer is absent, missing, already the same club, or a same-name club;
  - avoid overwriting the legacy club pointer when the user appears to belong to a different same-organisation club.
- If no matching user exists:
  - create the user;
  - set legacy club fields for compatibility;
  - create the `LMSProClubOfficial` row.

No welcome, invite or password email is sent.

## Club Permission Resolver Behaviour

Added shared resolver:

```text
resolvePermittedClubIdsForUser
```

The resolver returns every club ID the user may act for by combining:

- direct legacy user club pointer;
- official club membership rows;
- clubs with the same name in the same organisation, to tolerate cloned-season club IDs.

This preserves compatibility with existing records while moving the code toward `LMSProClubOfficial` as the authoritative membership source.

## C2 Team Save Behaviour

Updated save checks in:

- `teams.setContinuation`
- `teams.updateByClub`

The mutations now:

- confirm the team belongs to the user's organisation;
- resolve the user's permitted club IDs;
- reject users with no club association;
- allow saves when the team club is in the resolved permitted set;
- continue to reject truly unrelated clubs.

This specifically targets the dashboard/team modal save path that produced the wrong-club error for affected imported C2 users.

## Read-Only Audit Script Behaviour

Added:

```text
scripts/lmspro-r2-membership-audit.ts
```

Default command:

```bash
cd ~/project/src
npx tsx scripts/lmspro-r2-membership-audit.ts
```

All-user command:

```bash
cd ~/project/src
REPORT_SCOPE=all npx tsx scripts/lmspro-r2-membership-audit.ts
```

Targeted all-user command:

```bash
cd ~/project/src
TARGET_EMAIL=sheila.rollinson@dcfcw.co.uk REPORT_SCOPE=all npx tsx scripts/lmspro-r2-membership-audit.ts
```

The script is read-only. It prints user, club, official membership and current-season team context; it does not create, update or delete data.

Audit categories:

- `CODE_FIX_COVERS_THIS_CASE`: the new resolver should cover the stale/rolled-forward club-id case without a data edit.
- `MANUAL_REPAIR_CANDIDATE`: the intended club link is visible, but the proper official membership row needs cleanup.
- `REVIEW_NO_OFFICIAL_ROW`: user has legacy club-like data but no official row signal.
- `REVIEW_MISSING_LEGACY_CLUB`: user points at a missing club record.
- `OK_OR_LOW_SIGNAL`: no repair signal from this report.

Added:

```text
scripts/lmspro-r2-rollforward-graph-audit.ts
```

Staging command used by the operator:

```bash
cd ~/project/src
ORG_QUERY=Derby TARGET_EMAIL=spondondynamosfc.sm@gmail.com REPORT_SCOPE=all npx tsx scripts/lmspro-r2-rollforward-graph-audit.ts
```

The roll-forward graph audit is also read-only. It checks current-season club, team,
division and age-group relationships, then compares the old live-style club permission
check with the new resolver-based check.

## Explicit No-Data-Change Confirmation

This slice did not:

- edit staging data;
- edit live data;
- run a data repair script;
- update Neon branches;
- create or delete real users;
- send emails;
- change roll-forward logic;
- alter FUND module behaviour.

Historical broken users may still need R2-B staging repair and, if confirmed, R2-C live repair.

Updated remediation sequence:

- R2-B: staging live-snapshot audit and data repair rehearsal.
- R2-C: live app implementation and live data repair after staging is accepted.

## Checks Run

```text
npm test -- run src/modules/lmspro/lib/__tests__/provision-club-user.test.ts
npm test -- run src/modules/lmspro/import/handlers/__tests__/club.test.ts
npm run type-check
./node_modules/.bin/eslint src/modules/lmspro/lib/provision-club-user.ts src/modules/lmspro/lib/resolveClubId.ts src/modules/lmspro/routers/teams.router.ts
git diff --check
```

Results:

- Focused import-helper test passed: 3 tests.
- Existing club import handler test passed: 16 tests.
- `npm run type-check` passed.
- Targeted production ESLint reported 0 errors.
- Targeted production ESLint still reported 5 pre-existing warnings in `teams.router.ts`.
- `git diff --check` passed.
- Audit script standalone TypeScript check passed.
- Roll-forward graph audit standalone TypeScript check passed.
- Pre-commit hook type-check passed during both app commits.

Note:

- Vitest and TypeScript initially needed local sandbox escalation because they write temporary/cache files under the app repo.
- The new Vitest test file is intentionally excluded from the repo's typed ESLint project by the current `tsconfig.json` test-file exclusions, but it runs under Vitest.

## UI Smoke Guidance

Once consolidated into `dev` and promoted to an online staging test environment, browser smoke should use a C2 Club user with a valid official membership or recoverable cloned-season/same-name club link.

Smoke path:

1. Log in as the C2 Club user.
2. Open the Club dashboard / Teams area.
3. Open a team edit modal.
4. Change manager name/email/phone.
5. Save.

Expected result:

- valid linked user saves successfully;
- no wrong-club error appears for that user's own club/team;
- truly unrelated teams remain blocked.

Caveat:

If a historic imported user has neither a valid `LMSProClubOfficial` row nor a recoverable legacy/same-name club link, this code cannot infer the missing relationship on its own. That case remains for the data remediation phase.

## Roll-Forward Relationship

Roll-forward did contribute to the issue by creating new season club IDs while some imported users still depended on stale legacy pointers.

The prevention fix reduces future risk because imported/linked users should now carry the authoritative `LMSProClubOfficial` membership used by cloned-season workflows and safer permission resolution.

Historic imported users still need audit and repair where their existing membership rows are missing or stale.

## Remaining Risks / Follow-Ups

- Complete the R2-B staging live-snapshot all-user audit and graph audit.
- Confirm named examples through the graph audit rather than relying only on action-focused output.
- Repair the accepted candidate set on staging first.
- The client has elected to manually remove and re-add live club users through C1 to remove ambiguity; this should be treated as controlled manual data repair, not a user deletion exercise.
- Rehearse and document before/after audit counts on staging before live.
- Kevin/Spondon was proven on staging: C1 remove/re-add changed the user from stale 2025-2026 club pointer to current 2026-27 club pointer.
- Consider consolidating similar permitted-club resolution logic in other LMSPro routers in a later cleanup slice.

## Recommended Next Slice

```text
LMSPro R2-B - Staging Live-Snapshot Membership Repair Rehearsal
```

Scope:

- all-user staging audit on live snapshot;
- exact repair classification;
- staging-only repair after review;
- live implementation planned separately as R2-C.
