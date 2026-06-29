# FUND Phase 1 Slice 1P-G-C-R1 - Project Intake Schema Review

Date: 2026-06-29

## 1. Review Verdict

Proceed.

The committed 1P-G-C Project Intake schema foundation is acceptable to remain on `dev` and `staging`.

No blocking defects were found.

## 2. Review Scope

Reviewed app schema commit:

```text
59d3010 feat(fund): add project intake schema foundation
```

Current aligned app head:

```text
aac38c1 fix(fund): polish c1 dashboard cards
```

Reviewed docs commit:

```text
bd19863 feat(fund): add project intake schema foundation
```

Dashboard polish note:

```text
aac38c1 is a separate UI-only dashboard polish commit and is not part of this schema review.
```

## 3. Files Reviewed

App files:

- `prisma/schema.prisma`
- `prisma/migrations/20260629120000_add_fund_project_intake/migration.sql`

Docs files:

- `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`
- `docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-g-a-project-intake-schema-and-moderation-model-planning.md`
- `docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-b-project-intake-schema-options-planning.md`
- `docs/modules/fund/04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-c-project-intake-schema-confirmation.md`

## 4. Schema-Only Boundary Assessment

Confirmed implemented:

- `FundProjectIntakeFormStatus`;
- `FundProjectIntakeSubmissionStatus`;
- `FundProjectIntakeSubmissionSource`;
- `FundProjectIntakeModerationDecision`;
- `FundProjectIntakeForm`;
- `FundProjectIntakeSubmission`;
- Organization relations;
- same-tenant relations;
- indexes and uniqueness constraints;
- migration SQL.

Confirmed not implemented:

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

## 5. Prisma Schema Assessment

Schema consistency review passed.

The new FUND intake models follow the existing FUND schema conventions:

- `@@schema("fund")`;
- snake_case table mapping;
- tenant-scoped `organizationId`;
- `createdAt` / `updatedAt` timestamps;
- JSON metadata/source payload fields;
- explicit relation names where multiple relations target the same model.

No Prisma validation errors were found.

## 6. Migration SQL Assessment

Migration reviewed:

```text
prisma/migrations/20260629120000_add_fund_project_intake/migration.sql
```

Confirmed migration creates:

- four `fund` enum types;
- `fund.fund_project_intake_forms`;
- `fund.fund_project_intake_submissions`;
- tenant-scoped unique indexes;
- moderation/search indexes;
- same-tenant foreign keys.

The migration does not backfill data and does not create operational records.

## 7. Enum Names And Values

Enum names align with the accepted planning documents:

- `FundProjectIntakeFormStatus`
- `FundProjectIntakeSubmissionStatus`
- `FundProjectIntakeSubmissionSource`
- `FundProjectIntakeModerationDecision`

Values include the planned future-facing sources:

- `SEASONPRO_CLUB`
- `CLIENT_DASHBOARD`

These remain schema values only and do not implement integrations or workflows.

## 8. Model And Table Names

Model names:

- `FundProjectIntakeForm`
- `FundProjectIntakeSubmission`

Table names:

- `fund_project_intake_forms`
- `fund_project_intake_submissions`

Names align with the FUND-specific, platform-aware schema direction.

## 9. Tenant Scoping And Same-Tenant Relations

Tenant scoping is explicit through `organizationId`.

Same-tenant compound foreign keys are present for:

- form default Event;
- submission form;
- requested Event;
- matched Client;
- approved Client;
- approved Project;
- approved Event.

This matches the existing FUND same-tenant relation pattern.

## 10. Indexes And Uniqueness

Confirmed:

- `FundProjectIntakeForm` has tenant-scoped `id`, `code` and `slug` uniqueness.
- `FundProjectIntakeSubmission` has tenant-scoped `id` uniqueness.
- Indexes exist for status, source, form, created date and moderation linkage fields.
- `respondentEmail` is indexed for C1/admin moderation search.

## 11. Delete / Moderation Evidence Preservation

The schema and migration use restrictive delete behaviour for forms/submissions and operational approval links.

This preserves moderation evidence and avoids accidental cascade deletion of submitted intake records.

## 12. Approval Output Fields

Approval-output fields are nullable.

They record future moderation outcomes without implementing approval automation:

- `matchedClientId`;
- `approvedClientId`;
- `approvedProjectId`;
- `approvedEventId`;
- `moderationDecision`;
- `moderationNotes`;
- `reviewedById`;
- `reviewedAt`.

No automatic Project, Client, Event or user creation is implied by the schema.

## 13. Public Token And Public Form Readiness

The form model includes:

- `publicTokenHash`;
- `publicTokenIssuedAt`.

This is hash-only schema support. It does not implement:

- token generation;
- public submission endpoints;
- public forms;
- embed scripts;
- direct public Project creation.

## 14. Notification / Invitation / SeasonPro Boundaries

Confirmed no notification or invitation behaviour was implemented.

Confirmed no SeasonPro integration behaviour was implemented.

`SEASONPRO_CLUB` is a future intake source value only.

## 15. Client / Account Clarification

The documentation preserves the required Client/account rules:

- `FundClient` is the Client organisation/account.
- Client users/members are future login-capable people linked to the Client/account.
- Primary contact fields on `FundClient` are operational contact snapshots only.
- Future Client addresses and delivery/fulfilment defaults require separate planning.
- Projects may later default/inherit delivery location from Client.
- Project-level delivery snapshots/overrides require separate planning.
- Client-scoped Project initiation must use trusted route, token or authenticated Client context.
- Client ownership must not be inferred from organiser snapshots, respondent email alone, proposed Client contact fields alone or user-editable hidden fields.
- New Client / first Project intake may create or match Client/account, create/link primary Client user/member and create linked Project only after explicit moderation/approval or a separately planned trusted direct-creation policy.

## 16. Checks Run

Commands run:

```text
npx prisma validate
npm run db:generate
npm run type-check
npm run verify
git diff --check
git -C /Volumes/isostack/Git/isodocs diff --check
```

Results:

- `npx prisma validate` passed.
- `npm run db:generate` passed.
- `npm run type-check` passed.
- `npm run verify` first hit the known sandbox `tsx` IPC restriction, then passed when rerun outside the sandbox.
- app `git diff --check` passed.
- docs `git diff --check` passed.

Not run:

- `db:push`;
- seed commands;
- reset commands.

## 17. Staging / Deployment Note

`dev` and `staging` were already aligned to `aac38c1` before this review, so this is a post-alignment schema review.

Staging deployment was confirmed successful by browser smoke testing after alignment.

Smoke result:

- staging is clean and working as expected;
- pre-existing data loads correctly;
- no remedial work is required at this stage.

This review did not run any local database mutation command. Expected deployment path remains the normal Render deployment path using `prisma migrate deploy`.

## 18. Defects / Blockers

No blockers found.

## 19. Non-Blocking Caveats

- Confirm migration application through the normal Render/Neon deployment logs before treating staging database state as verified.
- Future services must preserve the moderation-first boundary and must not treat source values as implemented workflow permissions.
- Public token fields are schema support only and need separate token lifecycle planning before public forms.

## 20. Recommendation

1P-G-C remains acceptable on `dev` and `staging`.

Recommended next slice:

```text
1P-G-D0 - Client-Scoped Project Initiation And Idempotency Planning
```

or, if the team wants to continue intake implementation first:

```text
1P-G-D - Project Intake Moderation API/Services Planning
```
