# FUND Phase 1 Slice 1P-G-C2 - Project Intake Email Confirmation Schema Addendum Planning

Date: 2026-06-29

Status: Planning only

## 1. Slice Goal

Decide the smallest safe schema addendum needed before implementing public/email-confirmed Project Intake submission services.

This planning slice follows the accepted Project Intake initiation pattern:

```text
multi-step form
-> email confirmation midpoint
-> confirmed submission
-> C1 moderation
-> create/link Client, Client user/member and Project
```

This slice does not implement schema, services, routers, Zod schemas, UI, public endpoints, email sending or token generation.

## 2. Problem Statement

1P-G-C created the Project Intake schema foundation:

- `FundProjectIntakeForm`;
- `FundProjectIntakeSubmission`;
- intake form status enum;
- intake submission status/source/moderation enums;
- tenant-scoped same-tenant relations;
- migration and schema-only confirmation.

That schema is suitable for storing moderated intake records, but it does not cleanly support a multi-step public initiation form with an email confirmation midpoint.

Current gap:

- submission status starts at `SUBMITTED`;
- there is no explicit unconfirmed/pending status;
- there is no confirmation token hash;
- there is no confirmation expiry;
- there is no confirmation email sent timestamp;
- there is no confirmed timestamp;
- there is no explicit submitted timestamp separate from `createdAt`;
- there is no idempotency key or submission fingerprint for retry/deduplication support.

Without a small addendum, public submission services would either need to treat unconfirmed records as `SUBMITTED` or rely on ad hoc metadata fields. Both would make moderation queue behaviour and security harder to reason about.

## 3. Current Schema Limitation

Current `FundProjectIntakeSubmissionStatus` values:

```text
SUBMITTED
IN_REVIEW
NEEDS_INFO
APPROVED
REJECTED
CANCELLED
SPAM
ARCHIVED
```

Current `FundProjectIntakeSubmission` has:

- respondent fields;
- proposed Client fields;
- proposed Project fields;
- requested Event/date fields;
- matched/approved Client, Project and Event references;
- moderation fields;
- `createdAt`;
- `updatedAt`.

It does not have a reliable way to distinguish:

```text
form started / email captured / confirmation pending
```

from:

```text
confirmed submission ready for C1 moderation
```

## 4. Recommended Status Change

Use status-based confirmation.

Recommended enum addition:

```text
CONFIRMATION_PENDING
```

Preferred transition:

```text
CONFIRMATION_PENDING
-> SUBMITTED
-> IN_REVIEW
-> APPROVED / REJECTED / CANCELLED / SPAM / ARCHIVED
```

Rationale:

- `CONFIRMATION_PENDING` is explicit and operationally readable.
- `SUBMITTED` remains the first actionable moderation status.
- C1 moderation queues can simply exclude `CONFIRMATION_PENDING`.
- Public form services can create a record before email confirmation without prematurely making it actionable.

Alternative considered:

```text
UNCONFIRMED
```

`UNCONFIRMED` is shorter, but less descriptive of the email-confirmation workflow. `CONFIRMATION_PENDING` is preferred unless existing naming conventions strongly favour shorter state names.

## 5. Recommended Fields

Add nullable fields to `FundProjectIntakeSubmission`:

```prisma
confirmationTokenHash      String?   @map("confirmation_token_hash")
confirmationTokenExpiresAt DateTime? @map("confirmation_token_expires_at")
confirmationEmailSentAt    DateTime? @map("confirmation_email_sent_at")
confirmedAt                DateTime? @map("confirmed_at")
submittedAt                DateTime? @map("submitted_at")
idempotencyKey             String?   @map("idempotency_key")
submissionFingerprint      String?   @map("submission_fingerprint")
```

Field intent:

- `confirmationTokenHash`: hashed token for email confirmation lookup.
- `confirmationTokenExpiresAt`: expiry boundary for public confirmation.
- `confirmationEmailSentAt`: operational record that the confirmation email was queued/sent.
- `confirmedAt`: timestamp when respondent confirms email.
- `submittedAt`: timestamp when the record becomes a confirmed submission for C1 moderation.
- `idempotencyKey`: future request-level retry key where the public or API client can provide one.
- `submissionFingerprint`: server-calculated duplicate/matching aid for repeated public submissions.

All database field names should use mapped snake_case names.

## 6. Index And Constraint Recommendations

Recommended indexes:

```prisma
@@index([organizationId, status, createdAt])
@@index([organizationId, confirmationTokenHash])
@@index([organizationId, confirmationTokenExpiresAt])
@@index([organizationId, submittedAt])
@@index([organizationId, idempotencyKey])
@@index([organizationId, submissionFingerprint])
```

Constraint recommendations:

- Avoid a global unique constraint on `submissionFingerprint`; repeated similar submissions may be valid evidence.
- Consider `@@unique([organizationId, idempotencyKey])` only if the implementation can guarantee idempotency keys are generated per tenant/request and are not reused across unrelated forms.
- If uniqueness for `idempotencyKey` is deferred, services can still use it as a matching signal first.
- `confirmationTokenHash` should be unique enough operationally, but a normal index may be safer than a unique constraint if token rotation/reissue behaviour is not settled.

Recommended first implementation:

```text
Add indexes, but avoid new uniqueness constraints for idempotency/fingerprint until service semantics are accepted.
```

## 7. Migration Considerations

Existing submissions were created under the 1P-G-C schema and should remain valid.

Migration approach:

- add `CONFIRMATION_PENDING` enum value;
- add nullable confirmation/idempotency fields;
- add indexes;
- do not backfill existing submissions;
- leave existing rows in their current status;
- do not reinterpret existing `SUBMITTED` rows as unconfirmed.

Backward compatibility:

- Existing C1 moderation records remain actionable according to their current status.
- New public form services can create `CONFIRMATION_PENDING` rows after the addendum is deployed.
- C1 moderation services should treat `SUBMITTED` and later statuses as confirmed/actionable.

## 8. Moderation Queue Behaviour

C1 moderation queues should only show confirmed/actionable submissions.

Default queue inclusion:

```text
SUBMITTED
IN_REVIEW
NEEDS_INFO
APPROVED
REJECTED
CANCELLED
SPAM
ARCHIVED
```

Default queue exclusion:

```text
CONFIRMATION_PENDING
```

Operational rule:

```text
Unconfirmed submissions are not actionable moderation items.
```

If C1 needs visibility of unconfirmed records later, it should be a separate diagnostic/admin view with clear wording, not the main moderation queue.

## 9. First Visible Initiation Form Field Set

The first public/client-facing Project initiation form should feel like a real FUND request form, not a technical intake record.

Use the proven multi-step pattern:

```text
multi-step form
-> email confirmation midpoint
-> confirmed submission
-> C1 moderation
-> create/link Client, Client user/member and Project
```

### Project Basics

Fields:

- Project name.
- Type of fundraising project.
- Preferred project dates / target date.
- Notes / project description.

Client-facing Project Type label:

```text
What kind of fundraising project would you like to run?
```

Initial options:

- Artwork fundraising project.
- Group personalised product project.
- Bulk order / club-funded project.
- Not sure yet.

Do not use internal wording such as:

- workflow class;
- Store requirement;
- Commerce option;
- product workflow.

The selected Project Type is a C1 moderation signal. It helps C1 understand the likely route, but it must not trigger Store, Orders, Commerce, payment, production or fulfilment behaviour.

### Organisation Details

Fields:

- Organisation name.
- Organisation type.
- Organisation address.

Initial organisation type options:

- School.
- Club.
- PTA / Friends group.
- Charity / community group.
- Other.

### Main Organiser Details

Client-facing section label:

```text
Main organiser details
```

Do not call this "primary user" on the public form.

Fields:

- First name.
- Last name.
- Email address.
- Phone number.
- Role in organisation.

Internal note:

The main organiser may become the future primary Client user/member after C1 approval, but no Client user/member is created until approval and the relevant user/member model exists.

### Store/Commerce Boundary

Do not ask:

```text
Do you require a Store?
```

Store, Orders, Commerce, payment, production and fulfilment remain deferred. The Project Type answer should help C1 judge the likely route during moderation without exposing internal implementation choices to the respondent.

### Data Handling

The current schema has dedicated fields for:

- respondent name/email/phone/role label;
- proposed Client name/type/contact fields;
- proposed Project name/description;
- requested Event/date/standalone fields;
- `rawPayload`;
- `sourceContext`.

It does not have dedicated fields for every first-form input, especially structured organisation address and Project Type.

Early public submission services may store additional form values in:

- `rawPayload` as submitted moderation evidence;
- `sourceContext` for channel/source-specific context where appropriate.

Do not add new schema fields for these form inputs in this documentation pass unless a later schema addendum explicitly accepts them.

## 10. Security And Privacy Rules

Confirmation token rules:

- store token hashes only;
- never store raw confirmation tokens;
- tokens must expire;
- confirmation endpoints must use safe, generic responses;
- token lookup must not reveal whether an email belongs to an existing Client;
- expired tokens must not confirm submissions;
- token reissue/rotation must be planned before implementation.

Client ownership rules:

- respondent email may assist matching but does not prove Client ownership;
- proposed Client contact fields do not prove Client ownership;
- hidden public fields do not establish Client scope;
- confirmed submissions still require C1 approval before Client/user/Project records are created or linked.

Moderation rules:

- `CONFIRMATION_PENDING` records must not appear as actionable C1 moderation items;
- confirmed submissions still remain moderation-first;
- C1 approval is required before creating/linking Client, Client user/member or Project records.

## 11. Implementation Boundary

1P-G-C2 planning does not implement:

- Prisma schema changes;
- migrations;
- services;
- routers;
- Zod schemas;
- UI;
- public endpoints;
- email sending;
- token generation;
- Client users/members;
- invitations;
- notifications;
- Store;
- Orders;
- Commerce;
- SeasonPro integration.

Do not run:

- `db:push`;
- seed commands;
- reset commands.

## 12. Recommended Next Slice

Recommended next slice:

```text
1P-G-C2-A - Project Intake Email Confirmation Schema Addendum
```

Scope:

- add `CONFIRMATION_PENDING` to `FundProjectIntakeSubmissionStatus`;
- add nullable confirmation/idempotency fields to `FundProjectIntakeSubmission`;
- add safe indexes;
- create migration;
- update generated Prisma client;
- document that no public endpoints, email sending, token generation, moderation services, Client users, Project creation, Store, Orders, Commerce or SeasonPro integration were implemented.

After 1P-G-C2-A, return to the Project Intake API/services sequence:

```text
1P-G-D1 - C1 Project Intake Form API/Services
1P-G-D2 - C1 Project Intake Submission Review API/Services
1P-G-F - Public Project Initiation Form And Email Confirmation Services Planning
```
