# FUND Phase 1 Slice 1P-G-C - Project Intake Schema Confirmation

Date: 2026-06-29

## 1. Slice Name

FUND Phase 1 Slice 1P-G-C - Project Intake Schema

## 2. Implementation Summary

Implemented the schema-only foundation for C1-created Project Intake forms and moderated Project Request submissions.

The implementation adds:

- Project Intake form status enum;
- Project Intake submission status enum;
- Project Intake submission source enum;
- Project Intake moderation decision enum;
- `FundProjectIntakeForm` model;
- `FundProjectIntakeSubmission` model;
- tenant-scoped same-tenant relations to Organization, Event, Client and Project;
- migration SQL for the new enums, tables, indexes and foreign keys.

No services, routers, Zod schemas, UI, public forms, approval automation, notifications, Store, Orders, Commerce or SeasonPro integration were implemented.

## 3. Files Changed

App repo:

- `prisma/schema.prisma`
- `prisma/migrations/20260629120000_add_fund_project_intake/migration.sql`

Docs repo:

- `isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-c-project-intake-schema-confirmation.md`
- `isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 4. Prisma Schema Changes

Enums added:

- `FundProjectIntakeFormStatus`
- `FundProjectIntakeSubmissionStatus`
- `FundProjectIntakeSubmissionSource`
- `FundProjectIntakeModerationDecision`

Models added:

- `FundProjectIntakeForm`
- `FundProjectIntakeSubmission`

Organization relations added:

- `fundProjectIntakeForms`
- `fundProjectIntakeSubmissions`

Inverse relations were added to:

- `FundEvent`
- `FundClient`
- `FundProject`

## 5. Migration Summary

Migration:

```text
prisma/migrations/20260629120000_add_fund_project_intake/migration.sql
```

SQL summary:

- creates four `fund` schema enum types;
- creates `fund.fund_project_intake_forms`;
- creates `fund.fund_project_intake_submissions`;
- adds tenant-scoped uniqueness and search indexes;
- adds same-tenant foreign keys for forms, submissions, Events, Clients and Projects;
- uses restrictive deletes for moderation evidence and operational approval links.

No existing data is backfilled or transformed.

## 6. Tenant Scoping Strategy

Both intake models are C1 tenant-scoped through `organizationId`.

Same-tenant relations use compound foreign keys wherever the linked record is tenant-owned:

```text
(organizationId, linkedId) -> (organizationId, id)
```

This applies to:

- form default Event;
- submission form;
- requested Event;
- matched Client;
- approved Client;
- approved Project;
- approved Event.

## 7. Moderation-First Boundary

The schema supports intake submissions as moderation records only.

Submissions do not automatically create or link:

- Clients;
- Client users/members;
- Projects;
- Event links;
- notifications;
- invitations;
- Store/Order/Commerce records.

Approval-output fields are nullable references for later explicit C1 moderation actions.

## 8. Client Organisation / User / Address Clarification

`FundClient` is the Client organisation/account, such as a school, club, PTA, charity branch or customer account.

Client users/members are future login-capable users linked to the Client/account. Primary contact fields on `FundClient` remain C1 operational contact snapshots only. They are not the Client user model, login identity, invitation state, role membership, notification consent or access control.

Future Client organisation details require structured physical address and delivery/fulfilment support before Store, Orders, Production or Dispatch. Projects should be able to default or inherit delivery address from the linked Client where appropriate, but Project-level delivery snapshots and overrides need separate planning.

Client-scoped Project initiation must use trusted Client route, token or authenticated Client context. Existing Client dashboard Project initiation should auto-scope requests or Projects to the authenticated Client/account. It must not rely on organiser snapshot fields, respondent email alone, proposed Client contact fields alone or user-editable hidden fields as proof of Client ownership.

For a new Client / first Project intake route, a future approval outcome may create or match the Client/account, create or link a primary Client login user/member and create a Project linked through `FundProject.clientId`. This remains subject to future idempotency rules, especially matching the initiator's email address and/or future Client user/member records.

Unknown public respondents should still create moderation submissions first.

1P-G-C does not implement these behaviours. It only provides schema support for moderated intake records.

## 9. Source Handling

`FundProjectIntakeSubmissionSource` includes:

- `PUBLIC_EMBED`
- `PUBLIC_LINK`
- `EMAIL_LINK`
- `CAMPAIGN_PAGE`
- `SEASONPRO_CLUB`
- `CLIENT_DASHBOARD`
- `C1_ADMIN_ENTRY`

`SEASONPRO_CLUB` and `CLIENT_DASHBOARD` are future-facing sources only. No SeasonPro integration or Client dashboard initiation workflow was implemented.

## 10. Public Token Strategy

The form model includes nullable public-token support:

- `publicTokenHash`
- `publicTokenIssuedAt`

The schema stores a hash field only. No public token issuing, public endpoint, embed script or public intake form was implemented.

## 11. Delete / Archive Strategy

The schema supports soft archive fields on forms:

- `archivedAt`
- `archivedById`
- `archivedReason`

The migration does not introduce hard-delete workflows. Form-to-submission linkage uses restrictive delete behaviour to preserve moderation evidence.

## 12. Explicit Out Of Scope Confirmation

Not implemented:

- routers;
- services;
- Zod schemas;
- UI;
- public endpoints;
- embed scripts;
- Client users/members;
- invitations;
- notification sending;
- approval automation;
- Project creation from submissions;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- Communications;
- SeasonPro Club mapping implementation;
- Event/Catalogue/Product availability schema.

## 13. Commands Run

App repo:

```text
npx prisma validate
npm run db:generate
npm run type-check
npm run verify
git diff --check
```

Results:

- `npx prisma validate` passed.
- `npm run db:generate` passed.
- `npm run type-check` passed.
- `npm run verify` initially hit a sandbox IPC restriction from `tsx`; rerun outside the sandbox passed with all verifications.
- `git diff --check` passed in the app repo.
- Docs `git diff --check` passed after the roadmap/confirmation updates.

## 14. db:push / Seed / Reset Confirmation

Not run:

- `db:push`;
- seed commands;
- reset commands.

## 15. Risks / Follow-Ups

- Schema needs a dedicated review slice before dev/staging alignment.
- Future services must preserve moderation-first behaviour.
- Public token storage exists as schema support only; public token issue/validation must be planned separately.
- `SEASONPRO_CLUB` and `CLIENT_DASHBOARD` source values must not be treated as implemented integrations.
- Approval-output links are nullable evidence fields until explicit C1 moderation services are implemented.
- Future Client organisation details, structured addresses, Client users/members, primary Client user/contact, idempotency and onboarding/approval policy require separate planning before implementation.
- Delivery address inheritance/defaulting from Client to Project and Project-level delivery snapshots/overrides require separate planning before Store, Orders, Production or Dispatch.
- Client-scoped Project initiation must be implemented later through trusted route/auth/token context, not user-editable hidden fields or respondent email inference.

## 16. Recommended Next Slice

Recommended next slice:

```text
1P-G-C-R1 - Project Intake Schema Review
```

Review focus:

- Prisma schema consistency;
- migration SQL;
- same-tenant foreign keys;
- moderation-first boundary;
- no accidental service/UI/public/notification/SeasonPro/Commerce implementation.

Recommended follow-up planning slices:

```text
1P-F-F - Client Organisation Details, Users, Roles And Notification Planning
1P-G-D0 - Client-Scoped Project Initiation And Idempotency Planning
1P-G-D - Project Intake Moderation API/Services Planning
1P-I-A - Client/Project Delivery Address And Fulfilment Data Planning
```
