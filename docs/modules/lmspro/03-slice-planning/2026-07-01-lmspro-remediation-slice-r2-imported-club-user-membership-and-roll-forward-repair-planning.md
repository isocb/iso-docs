# LMSPro Remediation Slice R2 - Imported Club User Membership And Roll-Forward Repair Planning

Date: 2026-07-01
Module: LMSPro / SeasonPro
Status: Completed for ordinary active C2 Club users; next-season roll-forward rehearsal planned
Type: Remedial import, membership and data-repair planning

## Goal

Plan a safe remediation path for imported C2 Club users who can log in and see their club dashboard, but receive a wrong-club error when saving team changes.

The remediation must separate:

- prevention code, so the import path does not create more broken links;
- safer C2 save-path permission checks, so roll-forward/cloned-season links are tolerated where the membership can be resolved;
- data audit and repair, so historic imported users are corrected only after a staging snapshot review.
- live implementation, so the live app is changed only after the staging repair has been rehearsed and accepted.

## Human Problem

Some imported C2 Club users can:

- log in;
- see the dashboard;
- open team edit modals;
- attempt to save manager/team details.

At save time, the UI reports that the team does not belong to their club.

Client-provided live example:

```text
spondondynamosfc.sm@gmail.com
```

The user is understood to be a valid Member / Standard Access C2 user linked to Spondon Dynamos in the live app.

Additional client-provided example identified during staging snapshot review:

```text
sheila.rollinson@dcfcw.co.uk
```

This user exists in the staging snapshot but did not appear in the first action-focused audit output, so the audit report now supports an all-user mode.

## Background

The likely history is:

1. Club primary contacts were imported first as passive fields on the Club record.
2. A later import/backfill step created active C2 users from those passive primary contact fields.
3. Some users were linked only by the legacy `User.lmsproClubId` field.
4. Some users were not given the current authoritative `LMSProClubOfficial` membership row.
5. Roll-forward/season clone then created new club records with new IDs.
6. Team save paths compared the current team club ID against the stale or missing user club pointer.

This means import created the underlying gap, and roll-forward made the gap visible by changing the active season club IDs.

## Membership Policy

The remediation should treat these records as follows:

- `LMSProClubOfficial` is the authoritative club membership table.
- `User.lmsproClubId` is a legacy/direct compatibility pointer and may be stale after season clone.
- C2 save paths must resolve club access from all valid membership sources, not only `User.lmsproClubId`.
- Imports must create or repair the `LMSProClubOfficial` row whenever they create or link a primary contact user.

## Operational Sequence

The remediation was handled in four operational steps, with one future seasonal control.

### R2-A - Prevention And Save-Path Strengthening

Implement code-level prevention without changing existing data.

Scope:

- strengthen `provisionClubUser`;
- ensure imported primary contacts get a `LMSProClubOfficial` row;
- avoid cross-organisation user hijacking;
- avoid blindly overwriting a user's legacy club pointer when they already belong to a different same-organisation club;
- add a shared resolver for all permitted club IDs;
- update affected C2 team save paths to use the resolver.

No data remediation.

Status:

- implemented and committed in `isostack-bedrock`;
- promoted through local `dev`, `origin/dev`, `staging`, `origin/staging`, `main` and `origin/main`;
- no data repair run.

Commit references:

```text
1424a86 fix(lmspro): strengthen imported club user membership
34795cb chore(lmspro): add all-user membership audit mode
21f6ced chore(lmspro): add roll-forward graph audit
f09000b fix(lmspro): align club application user provisioning
```

### R2-B - Staging Live-Snapshot Audit And Data Repair Rehearsal

Run a read-only report against staging after staging is pointed at a Neon branch snapshot of live, then repair staging data only after reviewing the report.

Staging state:

- Staging is pointed at a Neon branch snapshot of live data.
- Staging uses the same encryption key as live for this controlled review.
- The promoted R2-A code and audit script are available in staging.

Read-only audit command:

```bash
cd ~/project/src
npx tsx scripts/lmspro-r2-membership-audit.ts
```

All-user audit command:

```bash
cd ~/project/src
REPORT_SCOPE=all npx tsx scripts/lmspro-r2-membership-audit.ts
```

The report identifies:

- users with `User.lmsproClubId` pointing at missing clubs;
- users with current official membership rows;
- users whose club can be inferred by same-name/current-season club records;
- users whose email matches club primary contact fields;
- users requiring manual review;
- candidate SQL/script actions, but no writes.

Roll-forward graph audit command:

```bash
cd ~/project/src
ORG_QUERY=Derby TARGET_EMAIL=spondondynamosfc.sm@gmail.com REPORT_SCOPE=all npx tsx scripts/lmspro-r2-rollforward-graph-audit.ts
```

The graph audit adds:

- current-season club, team, division and age-group relationship checks;
- stale user club pointer checks;
- old live-style team count versus new resolver team count;
- named target output for affected users.

First staging audit result:

```text
Derby JFL:
OK_OR_LOW_SIGNAL: 46
CODE_FIX_COVERS_THIS_CASE: 70
MANUAL_REPAIR_CANDIDATE: 4
REVIEW_NO_OFFICIAL_ROW: 1
REVIEW_MISSING_LEGACY_CLUB: 1
```

Staging roll-forward graph audit after Kevin/Spondon manual repair:

```text
Team graph issue counts: {}

User access classification counts:
NO_AUDIT_SIGNAL: 35
CODE_FIX_COVERS_ROLLED_CLUB: 75
NO_CURRENT_SEASON_CLUB_ACCESS: 14
```

Kevin/Spondon proof point:

```text
Before C1 membership remove/re-add:
legacyClub: Spondon Dynamos / 2025-2026
oldCheckTeamCount: 0
newCheckTeamCount: 17
classification: CODE_FIX_COVERS_ROLLED_CLUB

After C1 membership remove/re-add:
legacyClub: Spondon Dynamos / 2026-27 Season [CURRENT]
officialClubSeasons: 2026-27 Season [CURRENT]
oldCheckTeamCount: 17
newCheckTeamCount: 17
classification: NO_AUDIT_SIGNAL
graphIssueTeamCount: 0
```

Conclusion:

- a name-only edit did not refresh the stale club pointer;
- removing and re-adding the user through the C1 club membership/user access area did refresh the current-season club link;
- the team/division/age-group roll-forward graph did not show structural issues for Derby;
- the code fix still remains necessary because it protects stale-but-resolvable records and future imports.

Note:

- `CODE_FIX_COVERS_THIS_CASE` replaced the earlier softer label `CODE_FIX_SHOULD_HELP`.
- The 70 code-covered cases are expected to be resolved by the new permission resolver without data edits.
- The 4 manual repair candidates need explicit club-official membership cleanup.
- The two review rows seen in the first audit are deactivated/test-looking accounts and should not drive live repair without further review.
- Because Sheila Rollinson exists in the snapshot but was absent from the first action-focused output, the all-user report must be used before finalising the repair list.

Staging repair rehearsal should:

- run on staging only;
- use the live snapshot branch only, never live;
- prefer targeted/manual repair for the small candidate set;
- if the client elects a wider manual cleanup, use active club users only and avoid deactivated/test/admin records unless deliberately included;
- create or repair `LMSProClubOfficial` rows only where the intended club is unambiguous;
- preserve deliberate multi-club users;
- rerun the audit after each repair batch;
- confirm the affected users move out of `MANUAL_REPAIR_CANDIDATE`;
- confirm C1-visible club/user relationships and, where possible, C2 browser paths.

CSV reference for the manual live pass:

```text
05-review-and-test/artifacts/2026-07-02-lmspro-r2-staging-user-membership-manual-live-reference.csv
```

The CSV was generated from the post-Kevin staging graph audit. It is a checklist/reference,
not an instruction to edit every row blindly. Deactivated users, test users and league/admin
accounts need explicit review before any live remove/re-add action.

### R2-C - Live App Implementation And Live Data Repair

Live repair was completed after staging data was rehearsed and accepted.

Final live audit evidence:

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

Interpretation:

- ordinary active C2 Club users were repaired through the C1 membership remove/re-add pattern;
- no active user remained in `NO_CURRENT_SEASON_CLUB_ACCESS`;
- the current Derby Team/Club/Division/AGG graph remained clean;
- the remaining active `CODE_FIX_COVERS_ROLLED_CLUB` rows were reviewed as C1/league,
  role-play or hat-switching access accounts.

Dedicated live planning document:

```text
03-slice-planning/2026-07-02-lmspro-remediation-slice-r2-c-live-club-user-membership-repair-planning.md
```

Dedicated live confirmation document:

```text
04-implementation-confirmations/2026-07-02-lmspro-remediation-slice-r2-c-live-club-user-membership-repair-confirmation.md
```

### R2-D - Club Application Primary Contact Provisioning Hardening

Review found a separate hidden-risk path in the public Club application approval workflow.
`clubApplications.approve` and `clubApplications.waitlist` had their own local primary-contact
user helper. That helper set `User.lmsproClubId` but did not guarantee an
`LMSProClubOfficial` row.

R2-D aligns approval/waitlist with import by reusing:

```text
provisionClubUser
```

Dedicated planning document:

```text
03-slice-planning/2026-07-02-lmspro-remediation-slice-r2-d-club-application-primary-contact-provisioning-planning.md
```

Dedicated confirmation document:

```text
04-implementation-confirmations/2026-07-02-lmspro-remediation-slice-r2-d-club-application-primary-contact-provisioning-confirmation.md
```

### Future Control - Next Season Dummy Roll-Forward

Before the next real live season roll-forward, staging must be pointed at a fresh live
snapshot and a dummy roll-forward must be performed. The R2 graph audit script should be
run before and after that staging roll-forward to prove that C2 Club users, C1 hat-switching
users, Teams, Clubs and Division/AGG links survive the seasonal transition.

Dedicated review/test plan:

```text
05-review-and-test/2026-07-02-lmspro-next-season-roll-forward-staging-dummy-rehearsal-plan.md
```

Reusable app audit script locations:

```text
/Volumes/isostack/Git/isostack-bedrock/scripts/lmspro-r2-membership-audit.ts
/Volumes/isostack/Git/isostack-bedrock/scripts/lmspro-r2-rollforward-graph-audit.ts
```

## Implementation Boundary For R2-A

Expected app files:

- `src/modules/lmspro/lib/provision-club-user.ts`
- `src/modules/lmspro/lib/resolveClubId.ts`
- `src/modules/lmspro/routers/teams.router.ts`
- `src/modules/lmspro/lib/__tests__/provision-club-user.test.ts`

Do not touch:

- live data;
- staging data;
- Neon branches;
- production users directly;
- FUND module files;
- roll-forward behaviour, except through membership-resolution compatibility;
- invite email sending;
- broad club/team UI redesign.

## Data Repair Boundary

Data repair must not be bundled into the prevention code slice.

Historic records may need one or more of:

- creating missing `LMSProClubOfficial` rows;
- repairing stale `User.lmsproClubId` values where the target club is unambiguous;
- preserving deliberate multi-club users;
- flagging ambiguous users for manual client review.

No destructive updates should be used.

## UI Smoke Test Direction

After R2-A is deployed to a testable environment, UI smoke should focus on:

- C2 Club user opens Dashboard / Teams;
- user opens the team edit modal;
- user changes manager name/email/phone;
- save succeeds where the user has a valid official membership or same-name cloned-season club link;
- wrong-club protection still blocks truly unrelated clubs.

Important caveat:

If a historic user has neither a valid `LMSProClubOfficial` row nor a recoverable legacy/same-name club link, R2-A cannot infer the membership on its own. That user needs the R2-B staging repair and, if confirmed, the R2-C live repair path.

## Checks For R2-A

Run:

```text
npm test -- run src/modules/lmspro/lib/__tests__/provision-club-user.test.ts
npm test -- run src/modules/lmspro/import/handlers/__tests__/club.test.ts
npm run type-check
targeted ESLint on changed production files
git diff --check
```

Record any pre-existing warnings separately from new errors.

## Implementation Confirmation

R2-A confirmation:

```text
04-implementation-confirmations/2026-07-01-lmspro-remediation-slice-r2-a-import-club-user-membership-strengthening-confirmation.md
```

The confirmation should include:

- branch and baseline;
- files changed;
- prevention behaviour;
- save-path behaviour;
- tests run;
- explicit no-data-change confirmation;
- UI smoke guidance;
- remaining data remediation plan.

## Current Next Slice

```text
LMSPro R2-B - Staging Live-Snapshot Membership Repair Rehearsal
```

Purpose:

- use the all-user audit to confirm the full user population;
- identify the exact staging data repair list;
- repair only the accepted small candidate set on staging;
- rerun audit and confirm before/after;
- prepare the live R2-C implementation checklist.
