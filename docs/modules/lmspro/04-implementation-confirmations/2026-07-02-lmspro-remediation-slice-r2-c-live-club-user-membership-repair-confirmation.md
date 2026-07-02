# LMSPro Remediation Slice R2-C - Live Club User Membership Repair Confirmation

Date: 2026-07-02
Module: LMSPro / SeasonPro
Status: Completed for ordinary active C2 Club users
Type: Live data repair confirmation

## Goal

Repair live C2 Club user membership records affected by stale season-linked Club IDs after
import and season roll-forward history.

The live goal was not to delete users or bulk-edit the database. It was to use the C1 UI
to refresh ordinary active Club user membership links, then prove the result with the same
read-only audit tooling rehearsed on staging.

## Application Code In Place

The live application was promoted with the R2 prevention and audit tooling:

```text
1424a86 fix(lmspro): strengthen imported club user membership
34795cb chore(lmspro): add all-user membership audit mode
21f6ced chore(lmspro): add roll-forward graph audit
f09000b fix(lmspro): align club application user provisioning
```

The live promotion path used the app repository chain:

```text
dev -> origin/dev -> staging -> origin/staging -> main -> origin/main
```

## Live Repair Method

The operator repaired live records through the C1 interface:

1. Open the current-season Club.
2. Remove the affected Club user membership.
3. Add the same user/email back to the intended current-season Club.
4. Save.
5. Rerun the read-only Render shell audit.

Where the club membership route could not remove a stale relationship because the current
`LMSProClubOfficial` row was missing, the safe fallback was the C1 Users modal:

1. Open Admin / Users.
2. Search for the user email.
3. Edit the user.
4. Set or resave the intended current-season Club.
5. Save.

That route is covered by the R2 code fix and ensures the authoritative
`LMSProClubOfficial` row is present.

## Read-Only Audit Command

Reusable app repo audit scripts:

```text
/Volumes/isostack/Git/isostack-bedrock/scripts/lmspro-r2-membership-audit.ts
/Volumes/isostack/Git/isostack-bedrock/scripts/lmspro-r2-rollforward-graph-audit.ts
```

Render shell deployed paths:

```text
~/project/src/scripts/lmspro-r2-membership-audit.ts
~/project/src/scripts/lmspro-r2-rollforward-graph-audit.ts
```

The live graph audit command was:

```bash
cd ~/project/src
ORG_QUERY=Derby REPORT_SCOPE=all npx tsx scripts/lmspro-r2-rollforward-graph-audit.ts
```

The script is read-only. It does not create, update or delete records.

## Live Result

Final live audit summary:

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

This proves:

- no active user is missing current-season club access in the audit;
- the Derby current-season Team, Club, Division/AGG and Age Group graph is clean;
- ordinary active C2 Club users moved to the clean `NO_AUDIT_SIGNAL` category after the
  manual membership refresh;
- the remaining active `CODE_FIX_COVERS_ROLLED_CLUB` rows are explainable C1/league,
  role-play or hat-switching accounts rather than the original ordinary C2 Club-user fault.

## Remaining Active Audit Noise

The remaining active `CODE_FIX_COVERS_ROLLED_CLUB` rows were reviewed as special access
patterns:

- `djfl@isodo.co.uk`
- `djflclub@isodo.co.uk`
- `secretary@derbyjfl.com`
- `steve.nicks@derbyjfl.com`
- `steve.nicks@gmail.com`
- `treasurer@derbyjfl.com`
- `u8fixtures@derbyjfl.com`
- `secretary@sheltonfc.com`, to be checked only if the dual Club access is not intentional.

These should not be bulk-repaired without confirming the intended league/admin/role-play
access model.

## Residual Work Moved To R3

The remaining `NO_CURRENT_SEASON_CLUB_ACCESS` rows are deactivated/test/history records.
They are not active wrong-club C2 users.

The policy question raised during R2-C is now R3:

```text
docs/modules/lmspro/03-slice-planning/2026-07-02-lmspro-remediation-slice-r3-club-official-removal-and-archived-access-lifecycle-planning.md
```

R3 should define how removed Club officials are archived, deactivated, displayed to C1/C2,
and potentially restored without leaving active users unlinked from any Club.

## Future Roll-Forward Control

R2 showed that import history plus season roll-forward can create subtle membership faults.
Before the next real season roll-forward, a dummy roll-forward must be run in staging
against a fresh live-snapshot branch.

Dedicated test plan:

```text
docs/modules/lmspro/05-review-and-test/2026-07-02-lmspro-next-season-roll-forward-staging-dummy-rehearsal-plan.md
```

The future rehearsal must prove that active ordinary C2 Club users, C1 hat-switching users,
current-season Clubs, Teams, Divisions/AGGs and Age Groups all survive the roll-forward
without recreating the wrong-club save problem.

## Verdict

R2-C is complete for the reported live issue.

The original ordinary C2 Club-user wrong-club fault is treated as resolved by:

- R2-A/R2-D prevention and resolver hardening;
- C1 manual live membership refresh;
- live active-user audit showing no active users without current-season access;
- live graph audit showing no Team graph issues.
