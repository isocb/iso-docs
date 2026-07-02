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

## General Rule For Future Issues

When a data issue crosses import history, cloned records, permissions and UI symptoms:

- do not start with a bulk write;
- do not rely only on browser symptoms;
- do not assume the first suspicious table is the only fault;
- produce a read-only report;
- prove one manual repair on staging;
- record the before/after evidence;
- then repeat the accepted method on live.
