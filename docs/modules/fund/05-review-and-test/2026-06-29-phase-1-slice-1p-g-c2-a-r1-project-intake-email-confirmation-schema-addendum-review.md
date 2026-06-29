# FUND Phase 1 Slice 1P-G-C2-A-R1 - Project Intake Email Confirmation Schema Addendum Review

Date: 2026-06-29

## 1. Review Verdict

Proceed.

1P-G-C2-A is safe to commit as a schema-only addendum.

The implementation is consistent with the planning decision to support email-confirmed multi-step Project Intake submissions before public submission services are built.

## 2. Files Reviewed

App repo:

- `prisma/schema.prisma`
- `prisma/migrations/20260629133000_add_project_intake_confirmation/migration.sql`

Docs repo:

- `03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-c2-project-intake-email-confirmation-schema-addendum-planning.md`
- `04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-c2-a-project-intake-email-confirmation-schema-addendum-confirmation.md`
- `00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 3. Schema Assessment

The Prisma schema adds:

- `CONFIRMATION_PENDING` to `FundProjectIntakeSubmissionStatus`;
- `confirmationTokenHash`;
- `confirmationTokenExpiresAt`;
- `confirmationEmailSentAt`;
- `confirmedAt`;
- `submittedAt`;
- `idempotencyKey`;
- `submissionFingerprint`;
- tenant-scoped indexes for confirmation and idempotency lookup patterns.

Assessment:

- Prisma schema remains valid.
- New fields are nullable and therefore safe for existing submissions.
- Existing `SUBMITTED` records remain valid and actionable.
- `SUBMITTED` remains the first confirmed/actionable C1 moderation state.
- `CONFIRMATION_PENDING` now clearly represents unconfirmed public/multi-step submissions.
- Confirmation token storage is represented as hash-only.
- Expiry and lifecycle timestamps are nullable and do not backfill or reinterpret existing data.
- Idempotency key and submission fingerprint are nullable and indexed, but not made unique before service semantics are accepted.

## 4. Migration Assessment

Migration reviewed:

```text
prisma/migrations/20260629133000_add_project_intake_confirmation/migration.sql
```

Assessment:

- The enum is extended by adding `CONFIRMATION_PENDING` before `SUBMITTED`.
- Nullable columns are added to `fund.fund_project_intake_submissions`.
- Tenant-scoped indexes are added for:
  - status/date moderation filtering;
  - confirmation token lookup;
  - confirmation expiry cleanup;
  - submitted date filtering;
  - idempotency key matching;
  - submission fingerprint matching.
- No existing rows are updated.
- No default is changed.
- No public behaviour is introduced.

No migration blocker was found.

## 5. Moderation Queue Boundary

Future C1 moderation services should exclude `CONFIRMATION_PENDING` by default.

Expected future queue behaviour:

```text
Exclude:
CONFIRMATION_PENDING

Include:
SUBMITTED
IN_REVIEW
NEEDS_INFO
APPROVED
REJECTED
CANCELLED
SPAM
ARCHIVED
```

This preserves the rule that unconfirmed public submissions are not actionable C1 moderation items.

## 6. Out-of-Scope Confirmation

The review confirms that 1P-G-C2-A does not implement:

- public endpoints;
- email sending;
- token generation;
- services;
- routers;
- Zod schemas;
- UI;
- public forms;
- Client users/members;
- invitations;
- notifications;
- Store;
- Orders;
- Commerce;
- Client dashboard Project creation;
- SeasonPro integration.

No new application behaviour was implemented during this review.

## 7. Checks Run Or Confirmed

Confirmed from the implementation pass:

```text
npx prisma validate
npm run db:generate
npm run type-check
npm run verify
git diff --check
docs git diff --check
```

Results:

- `npx prisma validate` passed.
- `npm run db:generate` passed.
- `npm run type-check` passed.
- `npm run verify` initially hit the known sandbox IPC restriction from `tsx`; rerun outside the sandbox passed.
- App `git diff --check` passed.
- Docs `git diff --check` passed.

## 8. Blockers

None.

## 9. Non-Blocking Caveats

Token rotation and reissue policy remains a future service-layer decision.

`idempotencyKey` and `submissionFingerprint` are intentionally not unique yet. This is acceptable for schema foundation work because uniqueness depends on request semantics, retry policy and whether multiple similar submissions should be preserved as moderation evidence.

Future public confirmation services must ensure raw tokens are never stored and that public responses do not reveal whether an email belongs to an existing Client.

## 10. Recommendation

Commit 1P-G-C2-A.

Recommended next implementation slice after commit/review:

```text
1P-G-D1 - C1 Project Intake Form API/Services
```

Keep the following deferred:

- public form endpoints;
- email sending;
- token generation;
- submission approval automation;
- Client users/members;
- Project creation from submissions;
- Store, Orders, Commerce and SeasonPro integration.
