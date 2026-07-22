# LMSPro Remediation Slice R8-A3-F1 - Attachment Job Claim Eligibility And Runtime Evidence Confirmation

Date: 2026-07-22

Implementation status: Technically complete on a dedicated corrective branch; not pushed,
merged or deployed

Planning source:

`docs/modules/lmspro/03-slice-planning/2026-07-22-lmspro-remediation-slice-r8-a3-f1-attachment-job-claim-eligibility-and-runtime-evidence-planning.md`

Application evidence:

```text
branch: fix/lmspro-r8-a3-f1-attachment-job-claim-evidence
baseline: origin/dev and origin/staging at 6b822e45
implementation commit: d14a652f
```

## 1. Assessment

The failed staging send did not reproduce the corrected Platform request-body defect. Attachment
draft persistence and the accepted payload boundary passed, while the Email remained `SENDING`
and the healthy cron reported zero attachment recipients processed.

Queue creation is atomic in the existing R8-A3 service. The business tester confirms that the
fresh pre-correction send displayed the green `Email queued` response. That response commits the
Email status, job, exact recipient rows and audit record together. The job therefore existed in
the web runtime's database, while the historic cron summary was insufficient to distinguish a
non-due job, other non-claimable state or a web/cron database mismatch.

## 2. Implemented Correction

- New attachment jobs now persist `nextAttemptAt = null`, which the existing claim SQL treats as
  immediately due. Initial claim no longer depends on comparing the web runtime's clock with the
  database clock.
- Web queue success emits job ID, Email ID, bounded counts and a credential-safe database-target
  fingerprint.
- Cron claim success emits job ID, worker ID and the same kind of fingerprint.
- When cron finds no claimable work, it emits queued, running, due-queued and stale-running counts
  with its fingerprint.
- Missing cron R2/Resend configuration evidence now includes only the fingerprint and waiting
  count.
- Fingerprints hash protocol, host, port and database path. Password, username, query parameters
  and the raw URL are never logged.

This makes the next staging result decisive without exposing a credential. Different web/cron
fingerprints require a Render `DATABASE_URL` correction. Matching fingerprints allow the bounded
job counts and job ID to identify claim-state behaviour.

## 3. Explicit Non-Changes

The implementation adds no:

- Prisma schema or migration;
- persisted customer-data mutation outside normal queueing;
- environment variable;
- R2, Resend, file/link or CC/BCC policy change;
- second worker/service;
- no-attachment batch-route change;
- provider rate/retry/recipient-limit change; or
- R8-A4 operator retry/progress UI.

It does not automatically retry or mutate the already stranded staging Email.

## 4. Automated Evidence

```text
Focused attachment contract and worker evidence: 9 PASS
Full Vitest: 161 PASS, 12 intentionally skipped (25 files passed, 1 skipped)
TypeScript type-check: PASS
Critical-file verification: PASS
Next.js request-body backport prebuild verification: PASS
Optimised production build: PASS
Focused Prettier: PASS
Git diff/whitespace check: PASS
Focused production ESLint: 0 errors
```

Focused ESLint retained six pre-existing warnings in `emails.router.ts`; no new warning is
introduced by this correction. Repository script/test lint coverage remains governed by
PLAT-ASSURE-01. The first sandboxed verification attempt was prevented from creating a local tsx
IPC socket (`EPERM`); the accepted rerun outside that sandbox passed and is not an application
failure.

## 5. Stop Boundary

Commit `d14a652f` is local on its dedicated branch. It has not been pushed or promoted. A
separately authorised dev/staging promotion and fresh human retest are required. Live remains
blocked.
