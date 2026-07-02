# LMSPro R2 - Complex Data Issue Review And Promotion Method

Date: 2026-07-02
Module: LMSPro / SeasonPro
Status: Working method captured from R2 membership remediation
Type: Review, testing and promotion method

## Purpose

Record the working method used when a UI symptom is caused by complex historical data:

- import history;
- season roll-forward;
- user membership drift;
- app permission checks;
- limited ability to log in as affected C2 users because magic links go to client mailboxes.

## Method

1. Reproduce or identify the named live symptom.
2. Clone/snapshot live data into staging.
3. Confirm staging is connected to the intended snapshot.
4. Promote only the diagnostic/code-hardening change to staging.
5. Run read-only shell reports first.
6. Separate app code risk from data repair risk.
7. Use C1 UI actions on staging for the smallest meaningful repair rehearsal.
8. Rerun the same read-only report after the UI action.
9. Confirm the expected row-level movement.
10. Only then plan the live promotion and live data repair.

## Commands

Render shell working directory:

```bash
cd ~/project/src
```

App repo source scripts:

```text
/Volumes/isostack/Git/isostack-bedrock/scripts/lmspro-r2-membership-audit.ts
/Volumes/isostack/Git/isostack-bedrock/scripts/lmspro-r2-rollforward-graph-audit.ts
```

Render shell deployed scripts:

```text
~/project/src/scripts/lmspro-r2-membership-audit.ts
~/project/src/scripts/lmspro-r2-rollforward-graph-audit.ts
```

Membership audit:

```bash
REPORT_SCOPE=all npx tsx scripts/lmspro-r2-membership-audit.ts
```

Roll-forward graph audit:

```bash
ORG_QUERY=Derby TARGET_EMAIL=spondondynamosfc.sm@gmail.com REPORT_SCOPE=all npx tsx scripts/lmspro-r2-rollforward-graph-audit.ts
```

## What The Reports Proved

For Derby staging live-snapshot data:

```text
Team graph issue counts: {}
```

This means the immediate evidence did not point to corrupt rolled-forward teams,
divisions or age groups.

Kevin/Spondon proved the user membership repair path:

- name-only edit did not fix the stale club pointer;
- club membership remove/re-add did fix the stale club pointer;
- old live-style team count moved from `0` to `17`;
- new resolver team count remained `17`;
- graph issues remained `0`.

## Safest Promotion Route

1. Finish staging manual checks.
2. Rerun staging audit and preserve output.
3. Confirm exact app commits:

```text
1424a86 fix(lmspro): strengthen imported club user membership
34795cb chore(lmspro): add all-user membership audit mode
21f6ced chore(lmspro): add roll-forward graph audit
```

4. Confirm `dev`, `origin/dev`, `staging` and `origin/staging` contain the intended code.
5. Promote the same tested commit to live.
6. Confirm live deploy health.
7. Take or confirm a live database restore point before manual data repair.
8. Run live audit before changes.
9. Complete manual C1 membership remove/re-add using the CSV reference.
10. Rerun live audit after changes.
11. Smoke test C1, and C2 where mailbox access is available.
12. Record before/after counts and any exceptions.

## CSV Reference

The working CSV for the live manual pass is:

```text
artifacts/2026-07-02-lmspro-r2-staging-user-membership-manual-live-reference.csv
```

Use it as a checklist. Do not treat deactivated, test, league-admin or ambiguous rows as
automatic repair rows.

## User Delete Semantics

The C1 LMSPro Users modal currently exposes a `Delete User` action, but the reviewed
implementation sends `hardDelete: false`. Operationally, that means:

```text
Delete User button today = deactivate the User record
```

It sets the user status to `DEACTIVATED`. It does not remove the `User` row, and it does
not necessarily free the email address for a clean re-create through the normal user create
flow.

For data repair work, treat user removal as three different actions:

- `Deactivate`: remove access while preserving history and references.
- `Relink/repair`: keep the same user and repair the authoritative club membership.
- `Permanent delete`: remove the user row only when the user is genuinely erroneous,
  test-only, duplicated beyond repair, or subject to an approved erasure request.

Do not use the current `Delete User` button as a repair shortcut for broken C2 club links.
For the R2 issue, the preferred repair remains C1 club membership remove/re-add against
the intended current-season club, followed by the read-only audit.

If the product later adds true hard delete for C1, it should be explicit and separate from
deactivation:

- label the controls `Deactivate` and `Permanently Delete`;
- require a stronger confirmation, ideally typing the email address;
- show or run a pre-delete impact check where practical;
- keep audit evidence of who performed the action and why;
- rehearse the behaviour in staging before live use;
- use it for GDPR/test/irrecoverable-broken-user cases, not as the default membership repair.

## Repo Cleanup And Staging Promotion Chain

For SeasonPro app code, keep the mental model simple:

```text
local repair branch -> dev -> origin/dev -> staging -> origin/staging -> live
```

Safe local cleanup and promotion steps:

1. Confirm the repo and branch:

```bash
cd /Volumes/isostack/Git/isostack-bedrock
git status --short --branch
```

2. If on a repair branch, confirm only intended files changed:

```bash
git diff --name-status
git diff --check
```

3. Run the relevant tests/checks before committing:

```bash
npm test -- run <targeted-test-file>
npm run type-check
```

4. Commit the repair branch with a clear LMSPro message.
5. Move the committed change into `dev`.
6. Confirm `dev` is clean and aligned with `origin/dev`.
7. Push `dev` to `origin/dev`.
8. Promote the same commit to `staging`.
9. Push `staging` to `origin/staging`.
10. In Render, wait for staging deploy to finish before running staging shell audits.
11. Record the commit hash used for staging evidence.

Use precise words during this process:

- `staged in Git` means files are queued in the Git index before commit.
- `staging environment` means the online test deployment.
- To avoid confusion, prefer `queued`, `committed`, `promoted to staging` and
  `deployed to staging` in notes and chat.

For `isodocs`, remember that this repo currently uses `main`, not the app `dev/staging`
chain. Documentation containing live-like email addresses or client data should either
remain local, be redacted before push, or be pushed only after explicit approval.

## General Rule For Future Issues

When a data issue crosses import history, cloned records, permissions and UI symptoms:

- do not start with a bulk write;
- do not rely only on browser symptoms;
- do not assume the first suspicious table is the only fault;
- produce a read-only report;
- prove one manual repair on staging;
- record the before/after evidence;
- then repeat the accepted method on live.

## R2 Live Outcome

The live R2 membership repair reused this method successfully.

Final live graph audit showed:

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

- ordinary active C2 Club users were repaired;
- remaining active `CODE_FIX_COVERS_ROLLED_CLUB` rows were explainable as C1/league,
  role-play or hat-switching access;
- deactivated/history rows moved into R3 archived-user/access-lifecycle planning;
- the Derby current-season Team graph remained clean.

R2-C confirmation:

```text
../04-implementation-confirmations/2026-07-02-lmspro-remediation-slice-r2-c-live-club-user-membership-repair-confirmation.md
```

## Required Future Roll-Forward Control

Before the next live season roll-forward, run a dummy roll-forward in staging against a
fresh live-snapshot Neon branch, then rerun the read-only graph audit. This is now a
standing control after R2.

Dedicated plan:

```text
2026-07-02-lmspro-next-season-roll-forward-staging-dummy-rehearsal-plan.md
```
