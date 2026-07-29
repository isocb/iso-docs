# LMSPro R9 Live Promotion Confirmation

Date: 2026-07-29

Record status: COMPLETE — R9-A1 LIVE PROMOTION AND R9-A2 PRODUCTION RECONCILIATION PASS

Scope: promotion of the STAGING-tested R9-A1 application tree and its two additive migrations
to production, followed by the separately authorised R9-A2 production reconciliation.

Application and control:

```text
previous main/production application commit:
  b9287ffa393f5e67b4a786f4d26549e4ee02397a
tested promotion commit:
  15559f1275d7f8ae3990cc6a9dcda5f35748e570
promotion shape:
  guarded fast-forward only
origin/dev:
  15559f1275d7f8ae3990cc6a9dcda5f35748e570
origin/staging:
  15559f1275d7f8ae3990cc6a9dcda5f35748e570
origin/main:
  15559f1275d7f8ae3990cc6a9dcda5f35748e570
```

## 1. Recovery Point

The control owner confirmed the following production snapshot before promotion:

```text
label:     Snapshot before club waiting list automation update
branch ID: br-noisy-lab-abk9taaf
created:   2026-07-29 14:21:15 +01:00
purpose:   dormant recovery copy of the pre-promotion production database
```

The snapshot is a recovery copy only. The existing production database remained the migration
and runtime target; no production database URL switch was required.

## 2. Pre-Promotion Database And Migration Review

The credential-safe, explicitly read-only production preflight established:

- the configured connection selected the intended production database;
- the transaction was read-only and ended without mutation;
- the migration ledger had no unfinished migration;
- the historic rolled-back attempts all had a later successful application;
- the successful applied migration-name set matched the repository baseline apart from the
  two intended R9 additions; and
- the BST key-date correction migration already existed in production with the exact repository
  checksum.

Although three migration directories had been introduced in the application repository since
the previous `main` commit, only these two additive R9 migrations were pending in production:

```text
20260728120000_lmspro_r9_a1_admission_participation
20260729123000_lmspro_team_approved_unallocated
```

Neither migration rewrites existing Club or Team rows. The first adds admission-evidence,
reconciliation-batch and participation-outbox structures. The second adds the `APPROVED` Team
status used for the Approved & Unallocated workflow.

## 3. Source Promotion And Automated Gates

`main` was fast-forwarded from `b9287ffa…` to the exact STAGING-tested tree at `15559f12…`.
There was no merge commit, rebase, force push or source divergence.

Exact `main` Security Scan run `30455952574` passed:

- dependency vulnerability scan;
- database schema security check;
- secret detection;
- TypeScript type safety; and
- security report generation.

## 4. Post-Deployment Machine Verification

The read-only production ledger verification found:

```text
transaction read-only:                    ON
successful distinct migrations:           147
unfinished migration attempts:            0
R9-A1 admission/participation migration:  finished; not rolled back
Team APPROVED migration:                  finished; not rolled back
admission evidence batch table:           present
TeamStatus APPROVED enum value:           present
```

The deployment did not execute reconciliation:

```text
admission-evidence batches:               0
LEGACY_ATTESTED_IMPORT evidence rows:      0
total admission-evidence rows:             0
participation-transition outbox rows:      0
```

The public production health endpoint returned HTTP 200 with the database connected and RLS
enabled for `11/11` reported tables.

## 5. Human Live Confirmation

The public health endpoint does not expose the running Git commit. The control owner independently
confirmed that Render displays:

```text
Live at 15559f1
```

The focused non-destructive production smoke then produced:

| Check | Result |
| --- | --- |
| Existing authorised C1 login | PASS |
| Club Management and Team Approval load | PASS |
| Pending Team cohort | PASS — no Pending Teams, as expected |
| Approved & Unallocated Team cohort | PASS |
| Existing C2 login and correct Club/Teams | PASS |
| Register a New Team availability | PASS — correctly unavailable because the controlling key date hides the action |
| Unexpected participation notification | NOT APPLICABLE — the smoke made no mutation capable of triggering one |

No production record was created or changed. The smoke did not change a Club or Team status,
allocate a Team, alter access or trigger reconciliation.

## 6. R9-A1 Promotion Disposition

The exact live commit, source alignment, Security Scan, migration ledger, no-reconciliation check,
public health and focused human live smoke all pass. The R9-A1 production promotion is complete.

## 7. R9-A2 Production Dry-Run

The control owner subsequently identified nine production Clubs still stored as `APPROVED`
despite having no qualifying Current/allocated Team. This was expected legacy state rather than
a deployment failure: R9-A1 deliberately added no historic evidence or automatic migration-time
classification.

The separately authorised serializable read-only production dry-run confirmed:

```text
bounded tenant/season:                   Derby JFL current season
scoped Clubs/Teams/Applications:         64 / 400 / 11
legacy pre-1-June cohort:                54
legacy membership fingerprint:           dcf67475260a9bb325025a6383664394
post-cutoff approved Application Clubs:  9
complete durable Application evidence:   9
proposed evidence rows:                  54 legacy + 9 Application
proposed APPROVED -> WAITING_LIST:        9
Team/allocation changes:                 0
notification settings enabled:           0
transaction end:                         ROLLBACK
```

The nine proposed Club changes consisted of two Clubs from the attested legacy-import cohort
and seven Clubs backed by complete email-verified, authorised approved-Application records. A
legacy-only execution would therefore have left seven known contradictions unresolved. The
control owner accepted the combined deterministic scope.

One post-cutoff Withdrawn Club has no approved-Application link or supporting audit signal. It
remains an explicit override and no unsupported admission evidence was fabricated for it.

## 8. Recovery Point, Rehearsal And Execution

The control owner created and confirmed a fresh post-migration, immediately pre-reconciliation
production recovery child:

```text
snapshot endpoint reference: ep-morning-union-ab08ttgc
snapshot branch:             br-bold-meadow-abrzpfkd
snapshot created:            2026-07-29 15:26:16 +01:00
purpose:                     dormant recovery copy; not a runtime target
```

The current production database remained the runtime and reconciliation target. No environment
or database URL was changed.

The complete combined transaction was first executed with hard tenant, season, migration,
cohort, membership-fingerprint, notification, idempotency and protected-domain assertions. Its
in-transaction evidence matched the accepted dry-run and it ended with `ROLLBACK`. Independent
verification found the original 62 Approved, one Waiting List and one Withdrawn Club, with zero
evidence, batch, outbox or rehearsal-audit rows.

After explicit execution approval, the identical transaction was executed once with only the
final transaction terminator changed from `ROLLBACK` to `COMMIT`, recording snapshot branch
`br-bold-meadow-abrzpfkd` in its audit evidence.

Committed result:

```text
admission-evidence batches:               1
LEGACY_ATTESTED_IMPORT evidence:          54
APPROVED_APPLICATION evidence:             9
distinct evidenced Clubs/keys:            63 / 63
Club APPROVED -> WAITING_LIST:             9
suppressed transition-outbox rows:         9
participation audit rows:                  9
combined reconciliation audit rows:        1
Teams changed:                             0
allocations changed:                       0
Club officials changed:                    0
users/access changed:                      0
notifications sent/delivery signals:       0
```

The exact rollback-only rehearsal artifact is:

`docs/modules/lmspro/05-review-and-test/artifacts/2026-07-29-lmspro-r9-a2-production-combined-reconciliation-rehearsal.sql`

## 9. Independent Verification And Repeat Dry-Run

Independent serializable read-only verification established:

```text
Club totals:
  Current / APPROVED:       53
  Club Waiting List:        10
  Withdrawn:                 1
  Total:                    64
Teams:                     400
scoped Club officials:     141
tenant users:              135
enabled notifications:       0
outbox delivery signals:     0
```

All 54 legacy rows are batch-linked, actor-linked and explicitly record unavailable automated
source evidence. All nine Application rows link to their complete approved Application source
and record the supported `LINKED` primary-C2 outcome. Every outbox row is `SUPPRESSED`.

The repeat dry-run found the same 54 legacy and nine Application members, zero missing evidence
rows and zero remaining Club status changes. Production health remained HTTP 200 with the
database connected and RLS `11/11`.

## 10. Post-Reconciliation Human Live Smoke

The control owner completed the focused non-destructive production re-smoke:

| Check | Result |
| --- | --- |
| Refresh C1 Club Management | PASS |
| Current 53 / Club Waiting List 10 / Withdrawn 1 / Total 64 | PASS |
| Nine corrected Clubs visible under Club Waiting List | PASS |
| Reclassified Club officials and Teams remain visible | PASS |
| Team Approval and counts remain normal | PASS |
| Existing C2 login | PASS |
| Correct C2 Club and Teams visible | PASS |
| No access-denied message | PASS |
| Register a New Team | PASS — correctly unavailable under the current key-date rule |
| Reconciliation notification | PASS — none received |

No production record was changed during the human smoke.

## 11. Final Disposition

R9-A1 production promotion and the separately controlled R9-A2 production reconciliation both
pass. Application, migration, evidence, status, access, notification, health and human UI gates
are complete. No further R9-A data action is pending.

The inconsistent editable status choices between the Club-list and Club-detail modals remain a
non-blocking presentation issue. Current and Club Waiting List remain derived server-controlled
states; this inconsistency is registered separately and did not affect reconciliation integrity.
