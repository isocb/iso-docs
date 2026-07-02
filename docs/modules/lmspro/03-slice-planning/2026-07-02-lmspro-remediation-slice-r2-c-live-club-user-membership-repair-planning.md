# LMSPro Remediation Slice R2-C - Live Club User Membership Repair Planning

Date: 2026-07-02
Module: LMSPro / SeasonPro
Status: Live repair completed for ordinary active C2 club users; residual lifecycle work moved to R3
Type: Live implementation and live data repair planning

## Goal

Plan the live implementation of the imported Club user membership repair after the same process has been rehearsed successfully on staging.

This is the third operational step:

```text
R2-A: prevention code and audit tooling -> promoted to staging
R2-B: staging live-snapshot audit and data repair rehearsal
R2-C: live app implementation and live data repair
```

R2-C must not start until R2-B has produced accepted staging before/after evidence.

## Live Outcome Summary

R2-C was completed on live after the R2-A/R2-D application fixes were promoted and the
staging repair method had been rehearsed against a Neon live-snapshot branch.

The live repair method used by the operator was:

1. Open the relevant current-season Club in the C1 interface.
2. Remove the affected club user membership.
3. Add the same user/email back to the intended current-season Club.
4. Save.
5. Rerun the read-only roll-forward graph audit from the Render live shell.

Where the club membership route was not available or returned an official-link error, the
safe fallback was to use the C1 Users modal to set/save the intended current-season Club.
This route ensures the authoritative `LMSProClubOfficial` membership row is present.

Final live audit evidence recorded:

```text
Team graph issue counts: {}

All rows:
NO_AUDIT_SIGNAL: 92
CODE_FIX_COVERS_ROLLED_CLUB: 18
NO_CURRENT_SEASON_CLUB_ACCESS: 14

Active users only:
NO_AUDIT_SIGNAL: 77
CODE_FIX_COVERS_ROLLED_CLUB: 8
NO_CURRENT_SEASON_CLUB_ACCESS: 0
```

The remaining active `CODE_FIX_COVERS_ROLLED_CLUB` rows were reviewed as C1/league,
role-play or hat-switching access accounts rather than ordinary C2 Club users:

- `djfl@isodo.co.uk`
- `djflclub@isodo.co.uk`
- `secretary@derbyjfl.com`
- `steve.nicks@derbyjfl.com`
- `steve.nicks@gmail.com`
- `treasurer@derbyjfl.com`
- `u8fixtures@derbyjfl.com`
- `secretary@sheltonfc.com`, to be checked only if it is not intentional dual access.

The original live problem is therefore treated as resolved for ordinary active C2 Club
users. The remaining `NO_CURRENT_SEASON_CLUB_ACCESS` rows are deactivated/test/history
records and belong to the R3 archived-user/access-lifecycle work, not the R2 stale club
link repair.

Future seasonal control:

```text
docs/modules/lmspro/05-review-and-test/2026-07-02-lmspro-next-season-roll-forward-staging-dummy-rehearsal-plan.md
```

Before the next real season roll-forward, run a dummy roll-forward in staging against a
fresh live-snapshot branch and rerun the same graph audit. This is now a required control
to prove that current-season Club, Team, Division/AGG and C2 membership links survive the
roll-forward process.

## Problem Being Fixed

Some imported C2 Club users can log in and see club/team screens, but team save operations can fail with a wrong-club message.

The root pattern is:

- the original Club primary contact existed as passive imported Club data;
- a later process created active C2 users;
- some users relied on stale or incomplete club links;
- roll-forward created new current-season Club IDs;
- save-time checks compared the Team club against an incomplete user club relationship.

R2-A now improves code tolerance and future import behaviour. R2-C is about safely applying the accepted live fix and cleaning historic live data where needed.

## Preconditions

Do not begin live work until all of these are true:

- Staging is running the promoted R2-A code.
- Staging has been pointed at a Neon branch snapshot of live data.
- The all-user audit has been run on staging.
- The staging manual repair list has been reviewed.
- Staging data repairs have been applied only to accepted records.
- The staging audit has been rerun and shows the expected before/after improvement.
- Named examples have been checked as far as access allows.
- The client has approved the live repair scope.

## Live Implementation Scope

R2-C includes:

- promoting the verified application code to live, if it has not already been promoted;
- taking or confirming a fresh live backup/restore point;
- running the same audit on live before any write;
- comparing live counts with accepted staging counts;
- applying only the accepted repair pattern;
- rerunning the audit after repair;
- recording before/after counts and commit references;
- completing a small smoke test.

R2-C does not include:

- broad user cleanup beyond this membership issue;
- deleting users;
- deleting clubs;
- rewriting season roll-forward behaviour;
- changing magic-link authentication;
- sending invite/welcome emails;
- changing FUND functionality.

## Live Code Reference

R2-A code and audit tooling were promoted to staging with:

```text
1424a86 fix(lmspro): strengthen imported club user membership
34795cb chore(lmspro): add all-user membership audit mode
21f6ced chore(lmspro): add roll-forward graph audit
f09000b fix(lmspro): align club application user provisioning
```

Before live promotion, confirm the exact commit being promoted from staging to live.

R2-D should be included before live promotion. Manual live cleanup repairs current records,
but R2-D prevents newly approved/waitlisted Club applications from creating weak primary-contact
membership links for the next season roll-forward.

## Live Audit Commands

Action-focused audit:

```bash
cd ~/project/src
npx tsx scripts/lmspro-r2-membership-audit.ts
```

All-user audit:

```bash
cd ~/project/src
REPORT_SCOPE=all npx tsx scripts/lmspro-r2-membership-audit.ts
```

Targeted all-user audit:

```bash
cd ~/project/src
TARGET_EMAIL=sheila.rollinson@dcfcw.co.uk REPORT_SCOPE=all npx tsx scripts/lmspro-r2-membership-audit.ts
```

Roll-forward graph audit:

```bash
cd ~/project/src
ORG_QUERY=Derby TARGET_EMAIL=spondondynamosfc.sm@gmail.com REPORT_SCOPE=all npx tsx scripts/lmspro-r2-rollforward-graph-audit.ts
```

These commands are read-only.

## Expected Repair Categories

Use the staging-tested category meanings:

- `CODE_FIX_COVERS_THIS_CASE`: no data edit expected; the new resolver covers the stale rolled-forward club ID.
- `MANUAL_REPAIR_CANDIDATE`: repair the authoritative `LMSProClubOfficial` membership row if the intended club is unambiguous.
- `REVIEW_NO_OFFICIAL_ROW`: review manually before any write.
- `REVIEW_MISSING_LEGACY_CLUB`: review manually before any write.
- `OK_OR_LOW_SIGNAL`: no repair signal from this audit.

Only the accepted `MANUAL_REPAIR_CANDIDATE` records should be considered for live write actions unless a separate approval expands scope.

The client has now elected a wider manual live cleanup: remove and re-add live club users
through the C1 club membership/user access area so current-season club links are refreshed
without relying on inference. This is acceptable as a controlled manual process if:

- it is limited to active club users unless a non-active user is deliberately approved;
- deactivated/test/admin/league accounts are reviewed separately;
- users are not deleted from the system;
- the C1 action is membership remove/re-add against the current-season club;
- a CSV/checklist is marked as the work proceeds;
- the audit is rerun after the pass.

## Live Repair Rule

For each approved manual repair candidate:

1. Confirm the user email and name.
2. Confirm the intended current-season Club.
3. Confirm the Club belongs to the correct organisation.
4. Confirm whether an `LMSProClubOfficial` row already exists.
5. If absent, create the missing row with the approved role and primary flag.
6. Confirm the user still has the required C2 / club-level access.
7. Do not overwrite deliberate multi-club access.
8. Do not repair ambiguous records without client confirmation.

The expected repair is additive and idempotent: create or ensure the missing authoritative membership relationship, not destructive cleanup.

For the wider manual cleanup, the expected C1 pattern is:

1. Open the current-season club.
2. Open the club users/officials/access area.
3. Remove the existing club membership for the named user.
4. Add the same email/user back to that current-season club.
5. Save.
6. Mark the CSV reference row.
7. Rerun the audit after the agreed batch or full pass.

Do not use a name-only edit. Staging proved that a name-only edit did not refresh the stale
club pointer, while membership remove/re-add did.

Do not use the current C1 `Delete User` button as the normal repair path. At the time of
this planning note, that button deactivates the user rather than permanently removing the
user row. It is useful for access removal, not for rebuilding a broken club relationship.
If a true permanent delete is needed for a test, erroneous or GDPR-approved user, handle it
as a separate explicit action with backup, confirmation and before/after audit evidence.

## Safety Controls

Before live write:

- confirm fresh Neon branch backup or restore point;
- confirm Render Live is connected to the intended live database;
- confirm the app commit being used;
- capture live audit output before repair;
- keep the repair list small and explicit;
- if running the wider manual cleanup, work from the CSV and skip ambiguous records;
- prefer small batches where practical, then rerun audit.

After live write:

- rerun action-focused audit;
- rerun all-user audit if needed to verify named examples;
- check affected rows moved out of manual repair status;
- smoke test the live app;
- record exact actions and counts in an implementation confirmation.

## Rollback

Rollback must be possible before any live write.

Rollback options:

- restore/point Live back to the fresh Neon branch backup;
- revert the live application commit if the code promotion causes an app-level issue;
- reverse an individual data repair only if the exact inserted row is known and the rollback is approved.

Do not rely on ad hoc manual deletion as the primary rollback plan.

## Live Smoke Test

Because affected C2 users authenticate by magic link, browser smoke may be limited.

Minimum smoke:

- C1 login still works;
- C1 can view Clubs, Users and Teams;
- known affected Club and Team records are visible;
- sample team edit/save still works for an accessible account;
- named affected users have correct membership data in the audit.

If mailbox access is available for an affected C2 user:

- log in as that C2 user;
- open the club dashboard;
- open a team edit modal;
- update manager/contact details;
- save successfully;
- confirm unrelated clubs remain inaccessible.

If mailbox access is not available, the minimum evidence is:

- C1 can complete the same membership remove/re-add action used successfully on staging;
- the live audit shows stale current-season access has been refreshed;
- old live-style team counts move from `0` to the current club team count where applicable;
- `Team graph issue counts` remains `{}`.

## Implementation Confirmation

```text
docs/modules/lmspro/04-implementation-confirmations/2026-07-02-lmspro-remediation-slice-r2-c-live-club-user-membership-repair-confirmation.md
```

Include:

- live app commit reference;
- backup/restore point reference;
- live audit before counts;
- approved repair list;
- exact data actions taken;
- live audit after counts;
- smoke-test result;
- rollback note;
- any records left for manual follow-up.
