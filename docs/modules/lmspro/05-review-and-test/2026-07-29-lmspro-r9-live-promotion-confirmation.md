# LMSPro R9 Live Promotion Confirmation

Date: 2026-07-29

Record status: COMPLETE — EXACT LIVE COMMIT, MACHINE GATES AND FOCUSED HUMAN SMOKE PASS

Scope: promotion of the STAGING-tested R9-A1 application tree and its two additive migrations
to production. This record does not authorise or execute the R9-A2 production reconciliation.

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

## 6. Final Disposition

The exact live commit, source alignment, Security Scan, migration ledger, no-reconciliation check,
public health and focused human live smoke all pass. The R9-A1 production promotion is complete.

Production R9-A2 reconciliation remains a separately controlled future decision.
