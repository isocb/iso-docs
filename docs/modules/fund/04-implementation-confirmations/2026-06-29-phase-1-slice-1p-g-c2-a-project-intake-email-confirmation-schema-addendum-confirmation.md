# FUND Phase 1 Slice 1P-G-C2-A - Project Intake Email Confirmation Schema Addendum Confirmation

Date: 2026-06-29

## 1. Slice Name

FUND Phase 1 Slice 1P-G-C2-A - Project Intake Email Confirmation Schema Addendum

## 2. Implementation Summary

Implemented the schema-only addendum required before public/email-confirmed Project Intake submission services.

The implementation adds:

- `CONFIRMATION_PENDING` to `FundProjectIntakeSubmissionStatus`;
- nullable confirmation token hash and expiry fields;
- nullable confirmation email sent, confirmed and submitted timestamps;
- nullable idempotency and submission fingerprint fields;
- tenant-scoped indexes for confirmation lookup, expiry cleanup, submitted-date filtering, idempotency and fingerprint matching;
- migration SQL for the enum, columns and indexes.

No services, routers, Zod schemas, UI, public endpoints, email sending, token generation, Client users/members, approval automation, Store, Orders, Commerce or SeasonPro integration were implemented.

## 3. Files Changed

App repo:

- `prisma/schema.prisma`
- `prisma/migrations/20260629133000_add_project_intake_confirmation/migration.sql`

Docs repo:

- `isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-c2-a-project-intake-email-confirmation-schema-addendum-confirmation.md`
- `isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 4. Prisma Schema Changes

Enum changed:

```text
FundProjectIntakeSubmissionStatus
```

New value:

```text
CONFIRMATION_PENDING
```

New nullable `FundProjectIntakeSubmission` fields:

```text
confirmationTokenHash
confirmationTokenExpiresAt
confirmationEmailSentAt
confirmedAt
submittedAt
idempotencyKey
submissionFingerprint
```

All fields use snake_case database mappings.

Indexes added:

```text
fund_intake_submissions_org_status_created_idx
fund_intake_submissions_org_confirm_token_idx
fund_intake_submissions_org_confirm_expires_idx
fund_intake_submissions_org_submitted_at_idx
fund_intake_submissions_org_idempotency_idx
fund_intake_submissions_org_fingerprint_idx
```

No uniqueness constraints were added for `idempotencyKey` or `submissionFingerprint`; those remain matching/idempotency aids until service semantics are accepted.

## 5. Migration Summary

Migration:

```text
prisma/migrations/20260629133000_add_project_intake_confirmation/migration.sql
```

SQL summary:

- adds `CONFIRMATION_PENDING` before `SUBMITTED` in the `fund.FundProjectIntakeSubmissionStatus` enum;
- adds nullable confirmation/idempotency columns to `fund.fund_project_intake_submissions`;
- adds tenant-scoped lookup and cleanup indexes;
- does not backfill existing submissions;
- does not reinterpret existing `SUBMITTED` submissions.

Existing submissions remain valid and actionable according to their current status.

## 6. Moderation Queue Boundary

The schema now supports the intended public initiation flow:

```text
CONFIRMATION_PENDING
-> SUBMITTED
-> C1 moderation
```

Future C1 moderation queues should exclude `CONFIRMATION_PENDING` by default.

`SUBMITTED` remains the first confirmed/actionable moderation status.

## 7. Security / Privacy Strategy

The schema supports storing confirmation token hashes only. Raw tokens must not be stored.

Future services must ensure:

- confirmation tokens expire;
- public confirmation responses do not reveal whether an email belongs to an existing Client;
- respondent email remains a matching hint only;
- confirmed submissions still require C1 approval before Client/user/Project records are created or linked.

## 8. Explicit Out Of Scope Confirmation

Not implemented:

- routers;
- services;
- Zod schemas;
- UI;
- public endpoints;
- public forms;
- email sending;
- token generation;
- Client users/members;
- invitations;
- notifications;
- approval automation;
- Project creation from submissions;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- Communications;
- SeasonPro integration;
- Event/Catalogue/Product availability schema.

## 9. db:push / Seed / Reset Confirmation

Not run:

- `db:push`;
- seed commands;
- reset commands.

## 10. Commands Run

App repo:

```text
npx prisma validate
npm run db:generate
npm run type-check
npm run verify
```

Results:

- `npx prisma validate` passed.
- `npm run db:generate` passed.
- `npm run type-check` passed.
- `npm run verify` initially hit the sandbox IPC restriction from `tsx`; rerun outside the sandbox passed with all verifications.
- `git diff --check` passed in the app repo.
- Docs `git diff --check` passed after the roadmap/confirmation updates.

## 11. Risks / Follow-Ups

Follow-ups:

- Review 1P-G-C2-A before promoting beyond the feature branch.
- Implement `1P-G-D1 - C1 Project Intake Form API/Services`.
- Implement `1P-G-D2 - C1 Project Intake Submission Review API/Services`.
- Plan public confirmation endpoint/token generation/email sending before public form implementation.
- Keep Client users/members and Project creation from approved submissions deferred until explicitly planned.

Residual risks:

- Final token rotation/reissue behaviour still needs service planning.
- Idempotency-key uniqueness remains intentionally deferred until request semantics are accepted.
- Public submission endpoints must be designed carefully so `CONFIRMATION_PENDING` records cannot become actionable moderation items without confirmation.

## 12. Recommended Next Slice

Recommended next slice:

```text
1P-G-D1 - C1 Project Intake Form API/Services
```

This should remain C1 admin API/services only and should not implement public form endpoints, email sending, submission approval automation, Client users/members or Project creation from submissions.
