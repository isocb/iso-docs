# LMSPro Next Season Roll-Forward - Staging Dummy Rehearsal Plan

Date: 2026-07-02
Module: LMSPro / SeasonPro
Status: Future control required before next live season roll-forward
Type: Staging roll-forward rehearsal and regression test plan

## Purpose

R2 proved that historic import/user-membership data and season roll-forward can interact in
ways that only become visible when C2 Club users save current-season Team data.

Before the next real season roll-forward, run a full dummy roll-forward in staging against a
fresh live-snapshot database branch. The goal is to prove that the next roll-forward will not
recreate the stale Club membership problem.

## Preconditions

Do not run this against live.

Required setup:

- create a fresh Neon branch from the live database;
- point staging at that branch;
- confirm staging uses the correct encryption configuration for the snapshot;
- deploy the intended current app code to staging;
- confirm the Render staging shell can run the LMSPro audit scripts;
- confirm the operator has C1 access to staging;
- record the app commit hash and database branch/restore reference.

## Baseline Before Dummy Roll-Forward

## Audit Script Location

The R2 work produced reusable read-only audit scripts in the SeasonPro app repository.

Source locations:

```text
/Volumes/isostack/Git/isostack-bedrock/scripts/lmspro-r2-membership-audit.ts
/Volumes/isostack/Git/isostack-bedrock/scripts/lmspro-r2-rollforward-graph-audit.ts
```

Deployed Render shell locations:

```text
~/project/src/scripts/lmspro-r2-membership-audit.ts
~/project/src/scripts/lmspro-r2-rollforward-graph-audit.ts
```

The script most useful for next season roll-forward rehearsal is:

```text
scripts/lmspro-r2-rollforward-graph-audit.ts
```

It checks current-season Club, Team, Division/AGG and Age Group relationships, then compares
the old legacy Club permission path with the resolver-based permission path introduced in
R2. It is read-only and can be reused before and after a staging dummy roll-forward.

Run the read-only graph audit before any staging roll-forward action:

```bash
cd ~/project/src
ORG_QUERY=Derby REPORT_SCOPE=all npx tsx scripts/lmspro-r2-rollforward-graph-audit.ts
```

Record:

- `Team graph issue counts`;
- all-user classification counts;
- active-only classification counts;
- any active ordinary C2 Club user outside `NO_AUDIT_SIGNAL`;
- any active C1/league/hat-switching account that legitimately has multi-club access;
- named sample users from clubs with many teams and clubs with one team.

Expected baseline:

- `Team graph issue counts: {}`;
- active ordinary C2 Club users resolve to the intended Club;
- no active ordinary C2 Club user is in `NO_CURRENT_SEASON_CLUB_ACCESS`;
- remaining non-clean rows are either deactivated/history records or intentional C1/special
  access accounts.

## Dummy Roll-Forward Procedure

Use the standard LMSPro season-preparation and roll-forward workflow on staging only.

Suggested reference documents:

```text
docs/modules/lmspro/season-preparation-sequence.md
docs/modules/lmspro/season-rollover-reference.md
docs/modules/lmspro/season-roll-forward-consolidated-requirements.md
```

Staging actions:

1. Confirm the current season and the target next season.
2. Confirm continuation/key-date windows are in the expected rehearsal state.
3. Run the same Club/Team/AGG preparation steps that would be used for live.
4. Perform the roll-forward in staging.
5. Do not repair data immediately after the roll-forward.
6. Run the audit first so the roll-forward result is captured honestly.

## Post Roll-Forward Audit

Run the same read-only graph audit after the dummy roll-forward:

```bash
cd ~/project/src
ORG_QUERY=Derby REPORT_SCOPE=all npx tsx scripts/lmspro-r2-rollforward-graph-audit.ts
```

Record:

- current season shown by the script;
- `Current graph counts`;
- `Team graph issue counts`;
- all-user classification counts;
- active-only classification counts;
- active ordinary C2 users with old/new resolver mismatches;
- active users with no current-season Club access;
- C1/league/hat-switching accounts with expected multi-club access;
- sample Teams visible under the intended new-season Clubs.

## Browser Smoke

Use staging C1 where mailbox access prevents real C2 login.

C1 smoke:

- open Clubs;
- open Users;
- open Teams;
- open several Clubs that had repaired C2 users in R2;
- confirm current-season Teams appear under the correct Clubs;
- edit and save a Team manager/contact detail for a safe test Team;
- confirm no wrong-club error appears on the C1 route.

C2 smoke, if mailbox access is available:

- log in as an ordinary C2 Club user;
- open their Club dashboard;
- open a Team edit modal;
- change a harmless manager/contact field;
- save;
- confirm unrelated Clubs remain inaccessible.

## Acceptance Criteria

The dummy roll-forward is acceptable only if:

- `Team graph issue counts` remains `{}`;
- active ordinary C2 Club users retain access to their intended new-season Club and Teams;
- no active ordinary C2 Club user appears in `NO_CURRENT_SEASON_CLUB_ACCESS`;
- any active `CODE_FIX_COVERS_ROLLED_CLUB` rows are explainable as C1/league/hat-switching
  access, not ordinary Club users;
- old/new resolver differences are understood and do not affect the production UI save path;
- at least one Team save smoke test succeeds after roll-forward;
- any exceptions are documented before live roll-forward approval.

## Fail Conditions

Stop and plan a fix before live roll-forward if:

- current-season Team graph issues appear;
- active ordinary C2 Club users lose their current-season Club access;
- C2 Team saves fail with wrong-club errors;
- new Clubs or Teams appear under the wrong organisation;
- official membership rows are not available for newly current-season Clubs where required;
- the audit output cannot distinguish ordinary C2 users from C1/hat-switching accounts.

## Output To Create

After the rehearsal, create a dated review document in this folder recording:

- staging app commit;
- Neon branch/source date;
- pre-roll-forward audit counts;
- roll-forward actions performed;
- post-roll-forward audit counts;
- browser smoke result;
- defects found;
- fix/no-fix decision;
- recommendation on whether live roll-forward is safe.

## Link Back To R2

This plan exists because R2 showed that a data issue can be invisible during normal C1
review but painful for C2 users after roll-forward. Future season changes should be proven
with read-only scripts and a staging dummy run before live data is touched.
