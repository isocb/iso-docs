# LMSPro Remediation Slice R2-B - Staging Live-Snapshot Audit And Manual Repair Rehearsal Confirmation

Date: 2026-07-02
Module: LMSPro / SeasonPro
Status: In progress - staging rehearsal evidence captured
Type: Staging live-snapshot data audit and manual C1 repair rehearsal

## Goal

Confirm, on staging only, whether the imported Club user wrong-club issue is caused by:

- stale or missing user-to-club membership;
- unsafe team/division/age-group roll-forward graph data;
- or both.

This confirmation records the staging evidence gathered before any live repair.

## Environment

Staging was pointed at a Neon branch snapshot of live data.

Staging uses the same encryption key as live for this controlled review, allowing the live
snapshot to be inspected in staging without touching the live database.

## Code Under Test

R2-A code and audit tooling had already been promoted to staging:

```text
1424a86 fix(lmspro): strengthen imported club user membership
34795cb chore(lmspro): add all-user membership audit mode
21f6ced chore(lmspro): add roll-forward graph audit
```

## Operator Testing Method

The operator used:

- the online staging app as C1;
- the Render staging shell;
- read-only audit scripts run with `npx tsx`;
- repeated audit output after manual UI actions.

The shell working directory for staging was:

```bash
cd ~/project/src
```

## Commands Used

All-user membership audit:

```bash
REPORT_SCOPE=all npx tsx scripts/lmspro-r2-membership-audit.ts
```

Roll-forward graph audit:

```bash
ORG_QUERY=Derby TARGET_EMAIL=spondondynamosfc.sm@gmail.com REPORT_SCOPE=all npx tsx scripts/lmspro-r2-rollforward-graph-audit.ts
```

Both scripts are read-only.

## Initial Staging Findings

Membership audit summary:

```text
OK_OR_LOW_SIGNAL: 46
CODE_FIX_COVERS_THIS_CASE: 70
MANUAL_REPAIR_CANDIDATE: 4
REVIEW_NO_OFFICIAL_ROW: 1
REVIEW_MISSING_LEGACY_CLUB: 1
```

Roll-forward graph audit before Kevin/Spondon repair showed:

```text
Team graph issue counts: {}
NO_AUDIT_SIGNAL: 34
CODE_FIX_COVERS_ROLLED_CLUB: 76
NO_CURRENT_SEASON_CLUB_ACCESS: 14
```

This indicated that the Derby team/division/age-group graph was not the immediate fault.
The dominant pattern was stale user club membership after roll-forward.

## Kevin/Spondon Rehearsal

Named live problem user:

```text
spondondynamosfc.sm@gmail.com / Kevin Hoult / Spondon Dynamos
```

First C1 test:

- edited the user name text only;
- saved;
- reran the audit.

Result:

- the stale club pointer did not change;
- the user still showed as covered by the code fix rather than clean data.

Second C1 test:

- removed Kevin from the current Spondon club membership/access area;
- added Kevin back to the same current-season Spondon club;
- saved;
- reran the graph audit.

Result:

```text
legacyClub: Spondon Dynamos / 2026-27 Season [CURRENT]
officialClubSeasons: 2026-27 Season [CURRENT]
oldCheckTeamCount: 17
newCheckTeamCount: 17
classification: NO_AUDIT_SIGNAL
graphIssueTeamCount: 0
```

Conclusion:

- C1 membership remove/re-add repairs the stale club pointer;
- a name-only edit does not;
- the app code fix still matters because it protects stale-but-resolvable records and future imports;
- the data repair path for known live users can be manual and evidence-led.

## Post-Kevin Staging Graph Audit

After Kevin/Spondon was repaired on staging:

```text
Team graph issue counts: {}
NO_AUDIT_SIGNAL: 35
CODE_FIX_COVERS_ROLLED_CLUB: 75
NO_CURRENT_SEASON_CLUB_ACCESS: 14
```

The change from 34/76 to 35/75 is the expected movement for Kevin out of stale-code-covered
status into clean/no-signal status.

## CSV Reference

A CSV reference was generated from the post-Kevin staging graph audit:

```text
docs/modules/lmspro/05-review-and-test/artifacts/2026-07-02-lmspro-r2-staging-user-membership-manual-live-reference.csv
```

The CSV contains:

- source date and environment;
- audit classification;
- status;
- email;
- name;
- user ID;
- old/new resolver team counts where parsed from the shell output;
- recommended manual live action note;
- blank columns for live completion notes;
- raw audit row for traceability.

The CSV is a checklist and reference, not a bulk-edit instruction.

## Decision

The client elected to remove and re-add live club users manually through the C1 UI so there is
no ambiguity about stale current-season club links.

This should be handled as controlled manual data repair:

- active club users first;
- deactivated/test/admin/league accounts reviewed separately;
- no user deletion;
- no direct database write unless separately approved;
- audit rerun after the pass.

## Review Outcome

Staging has provided a safe method:

1. Prove with read-only audit.
2. Perform a small C1 manual repair.
3. Rerun read-only audit.
4. Confirm expected before/after movement.
5. Use the same evidence pattern for live.

This is the preferred method for future complex Isostack data issues where UI symptoms may
be caused by historical import, season roll-forward or relationship drift.

## Remaining Before Live

- Complete any further staging manual cleanup chosen by the client.
- Rerun the staging graph audit after the staging pass.
- Confirm promotion commit and live deployment window.
- Take or confirm a live restore point.
- Run the live audit before manual live changes.
- Use the CSV during the live C1 membership remove/re-add pass.
- Rerun live audit after manual live changes.
