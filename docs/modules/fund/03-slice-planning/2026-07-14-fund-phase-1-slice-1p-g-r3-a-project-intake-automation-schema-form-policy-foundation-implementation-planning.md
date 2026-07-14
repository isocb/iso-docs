# FUND Phase 1 Slice 1P-G-R3-A - Project Intake Automation Schema And Form Policy Foundation Implementation Planning

Date: 2026-07-14

Status: Implemented and independently reviewed as passed / application changes uncommitted / no shared deployment

Parent alignment:

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1p-g-r3-project-intake-automated-provisioning-alignment-planning.md`

Parent controls:

`docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`

`docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 1. Goal

Create only the additive schema and database-constraint foundation needed for a later
Project Intake service to distinguish legacy/manual forms from explicitly aligned forms,
snapshot trusted form policy at submission, record typed organiser/delivery evidence and
record one complete Client/member/Project/delivery provisioning result.

This child does not automate confirmation or provision any operational record. It adds no
service, API, route, form, email or UI behaviour.

Review outcome on 2026-07-14:

- accepted against the committed 133-migration C5 baseline at application commit `8b5f208`;
- retained explicit aligned-form contract/scope/revision opt-in and zero legacy opt-in;
- added a typed `proposedProjectTypeCode` submission snapshot so provisioning never has to
  recover trusted Project type from `rawPayload`;
- added the nullable `FundProject(organizationId, id, clientId)` supporting key so a
  completed approved Project is proven to belong to its approved Client;
- made approved member/Client, approved Project/Client and approved delivery/Project
  identifier pairs explicit despite PostgreSQL `MATCH SIMPLE` nullable foreign-key rules;
- resolved the incomplete-exception status contract rather than deferring it to
  implementation;
- no Prisma, migration, service, API, route, email or UI change was made by this review.

## 2. Entry Gate And Baseline

The parent `1P-G-R3` alignment and this bounded R3-A plan were accepted before
implementation. The entry gate below was satisfied from the committed C5 baseline; the
implementation and review/test lifecycle is now complete locally.

Implementation must not start from an ambiguous working tree. The completed `1R-C5`
schema/migration/review lifecycle is committed as application baseline `8b5f208` and
documentation baseline `8d98d65`. R3-A follows the complete existing migration history and
adds one migration after the current 133-migration C5 baseline.

Before implementation, confirm:

- application `dev` and the intended documentation branch contain the accepted C5 lifecycle;
- `DATABASE_URL` is not used for destructive verification;
- `TEST_DATABASE_URL` exists and is proven distinct from `DATABASE_URL` without printing
  either secret;
- R3-B, R3-C, Store `1R-D`, `1R-C6` and `COMMERCE-A2` remain unstarted.

## 3. Bounded Scope

R3-A may change only:

- bounded Fund-prefixed Project Intake enums;
- additive fields and relations on `FundProjectIntakeForm` and
  `FundProjectIntakeSubmission`;
- the three exact composite identity keys required on `FundClientMember`, `FundProject` and
  `FundProjectDeliveryProfile`;
- reverse Prisma relations needed by those exact keys;
- one bounded PostgreSQL migration;
- schema/migration/constraint verification scripts;
- R3-A implementation-confirmation, review/test and roadmap records after implementation.

It must not add or change:

- confirmation, moderation, provisioning or User/member services;
- public/C1 APIs, routes, forms, components, copy or email;
- Client, User, member, Project or delivery-profile data;
- generic C1 or K2 Project-creation behaviour;
- Store, Commerce, payment, production or commission behaviour;
- iframe embedding, invitations, onboarding email or external integrations.

## 4. Accepted Schema Shape To Implement

### 4.1 Bounded enums

Add:

```text
FundProjectIntakeAlignedScope
  EVENT
  STANDALONE

FundProjectIntakeProvisioningPath
  AUTOMATED
  C1_REVIEW

FundProjectIntakeExceptionReason
  EXISTING_CLIENT_AUTH_REQUIRED
  INSUFFICIENT_CLIENT_ACCESS
  AMBIGUOUS_CLIENT_MATCH
  IDENTITY_CONFLICT
  INACTIVE_OR_ARCHIVED_ACCOUNT
  POSSIBLE_DUPLICATE
  FORM_POLICY_CHANGED
  EVENT_OR_DATE_INVALID
  RATE_OR_ABUSE_LIMIT
  AUTOMATED_POLICY_FAILURE
```

All enums use the existing `Fund` prefix and the `fund` PostgreSQL schema. Historic
`FundProjectIntakeModerationDecision` values remain unchanged for historic evidence.

### 4.2 Form alignment and authority fields

Add nullable/additive fields equivalent to:

```text
alignedScope                 FundProjectIntakeAlignedScope?
formContractVersion          Int?
formPolicyRevision           Int?
defaultProjectTypeCode       String?
allowProjectTypeSelection    Boolean @default(false)
allowedProjectTypeCodes      Json @default("[]")
```

The existing `defaultEventId`, `allowStandaloneProjects`,
`allowExistingClientSelection` and `requiresModeration` columns remain. They are not
rewritten by migration.

Database checks enforce:

- `alignedScope`, `formContractVersion` and `formPolicyRevision` are either all null for a
  legacy form or all present;
- the only initial aligned contract is version `1` and its revision is at least `1`;
- aligned `EVENT` means `defaultEventId` is present and
  `allowStandaloneProjects = false`;
- aligned `STANDALONE` means `defaultEventId` is null and
  `allowStandaloneProjects = true`;
- `defaultProjectTypeCode`, when present, is nonblank;
- `allowedProjectTypeCodes` is a JSON array;
- an aligned fixed-type form has selection disabled and a nonblank default type;
- an aligned selectable-type form has a non-empty allowed-type array; a default, when
  supplied, belongs to that array.

The database does not attempt to validate every JSON array element against application
vocabulary. R3-B/C validation must normalize, deduplicate and restrict codes to the
accepted Project-type set before writing. Saving `requiresModeration = false` without the
aligned contract/scope/revision can never make a legacy form eligible for automation.

### 4.3 Typed submission evidence

Add nullable fields equivalent to:

```text
respondentFirstName
respondentLastName
proposedClientAddressLine1
proposedClientAddressLine2
proposedClientAddressLine3
proposedClientLocality
proposedClientRegion
proposedClientPostalCode
proposedClientCountryCode @db.Char(2)
proposedProjectTypeCode
```

Existing `respondentName`, contact fields and `rawPayload` remain unchanged. The migration
does not parse or split historic text/JSON.

Checks enforce nonblank values when these text fields are present, including Project type,
and an uppercase two-letter country code when country is present. The typed Project type is
server-normalized from a fixed form policy or validated against the selectable form policy;
R3-B must not recover it from `rawPayload`.

The fields remain nullable for historic submissions and for the additive migration. A
completed version-1 provisioning result requires first name, last name, address line 1,
locality, postal code, country code and Project type to be present and valid.

### 4.4 Submitted form-policy snapshot

Add:

```text
submittedFormContractVersion Int?
submittedFormPolicyRevision  Int?
```

Both are null for historic submissions. They must be both null or both present; the initial
contract value is `1` and the revision must be at least `1`. R3-B/C will write them from the
server-loaded form, never from public input.

This evidence lets confirmation compare the submitted offer with the current form policy.
R3-A records the values only; it implements no comparison behaviour.

### 4.5 Provisioning and decision evidence

Add nullable fields equivalent to:

```text
approvedClientMemberId
approvedProjectDeliveryProfileId
trustedInitiatingClientId
trustedInitiatingClientMemberId
provisioningContractVersion
provisioningCompletedAt
provisioningPath FundProjectIntakeProvisioningPath?
automationPolicyVersion
automationEvaluatedAt
exceptionReason FundProjectIntakeExceptionReason?
```

The existing approved Client, Project and Event fields remain. No duplicate approved User
field is added because the approved member's `userId` is the login-capable identity.

Database checks enforce:

- trusted initiating Client/member IDs are both null or both present;
- provisioning contract version is null or `1`;
- a completed version-1 result has `status = APPROVED`, approved Client, approved member,
  approved Project, approved delivery profile, completion time, provisioning path, typed
  required organiser/address/Project-type evidence and submitted form contract/revision;
- a new approved member ID requires an approved Client ID, and a new approved delivery ID
  requires an approved Project ID;
- a version-1 result requires the approved Project/Client pair, while historic legacy
  clientless approvals remain valid when `provisioningContractVersion` is null;
- a version-1 Event result has `requestedEventId` and the same `approvedEventId`, while a
  version-1 standalone result has `requestedStandalone = true` and no requested or approved
  Event;
- `AUTOMATED` completion has an automation policy version and evaluation time and no
  exception reason;
- `C1_REVIEW` completion has C1 review actor/time evidence; it may retain an exception
  reason, while an intentionally manual review need not invent one;
- an exception initially enters `IN_REVIEW`; without completion it may subsequently be
  `IN_REVIEW`, `NEEDS_INFO`, `REJECTED`, `CANCELLED`, `SPAM` or `ARCHIVED`, retains its
  reason, and cannot coexist with any approved Client/member/Project/Event/delivery result;
- `SUBMITTED` remains available for an intentionally manual or legacy form awaiting C1
  review, but is not the status of an automated exception;
- automation versions, form versions and revisions are positive when present.

### 4.6 Exact tenant/owner relations

Add supporting unique keys:

```text
FundClientMember(organizationId, id, clientId)
FundProject(organizationId, id, clientId)
FundProjectDeliveryProfile(organizationId, id, projectId)
```

Add named exact relations so:

- `approvedClientMemberId` belongs to `approvedClientId` in the same tenant;
- `approvedProjectId` belongs to `approvedClientId` in the same tenant;
- `approvedProjectDeliveryProfileId` belongs to `approvedProjectId` in the same tenant;
- `trustedInitiatingClientMemberId` belongs to `trustedInitiatingClientId` in the same
  tenant.

Preserve the existing approved-Project relation and add the exact nullable Project/Client
composite relation alongside it. The original relation continues to protect historic
clientless approval evidence; the new relation proves Client ownership for aligned results.
Use `onDelete: Restrict`/PostgreSQL `NO ACTION` for submission evidence pointing to Client,
member, Project and delivery outcome records. Existing historic deletion contracts are not
weakened. Add only the reverse Prisma relations necessary to validate/generate this schema.

Because PostgreSQL composite foreign keys use `MATCH SIMPLE`, checks must separately reject
a new member without its Client, a new delivery profile without its Project, either half of
the trusted initiating Client/member pair and a version-1 Project without its Client. The
Project/Client pairing check is conditional on the new provisioning contract so historic
clientless approvals remain valid. The foreign keys then prove exact ownership whenever the
pair is present.

R3-A cannot make `FundClientMember.userId` a same-tenant composite foreign key because the
current User relation is platform-owned by ID. R3-B must retain explicit same-tenant User
validation; this limitation is recorded rather than hidden.

## 5. Index And Constraint Contract

Use explicit, bounded PostgreSQL names consistent with existing FUND migrations.

Add indexes supporting:

- aligned form contract/scope/status lookup;
- submitted form contract/revision lookup;
- exception queue lookup by tenant, exception reason and status;
- approved member and delivery-profile evidence;
- trusted initiating Client/member revalidation;
- provisioning completion/path lookup.

Do not add a unique constraint on `approvedProjectId`: historic vocabulary permits linking
existing Projects and the migration must not invent a global one-submission-per-Project
rule. Do not add a global one-primary-member constraint or alter Client-member lifecycle in
this intake-only slice.

## 6. Migration And Existing-Data Policy

Use one additive migration after the accepted C5 baseline:

1. create the three Fund-prefixed enums;
2. add nullable/defaulted form and submission columns;
3. add the three supporting composite unique keys;
4. add named exact foreign keys;
5. add conditional checks and indexes;
6. verify preservation before committing.

Zero-backfill means:

- no form is opted into the aligned contract;
- all existing aligned-form markers/revisions remain null;
- all historic submission snapshots, typed evidence, decision and provisioning fields
  remain null;
- no Client, User, member, Project or delivery profile is created or inferred;
- existing `requiresModeration`, Event/standalone flags, raw payloads, statuses, tokens and
  approval links are byte-for-byte preserved apart from PostgreSQL metadata needed by the
  migration.

Defaults on new form-policy columns must not make an existing row automatic. In particular,
`allowProjectTypeSelection = false` and `allowedProjectTypeCodes = []` are inert while
`formContractVersion` is null.

## 7. Disposable PostgreSQL Validation

Use only `TEST_DATABASE_URL` after proving it differs from `DATABASE_URL`.

Required evidence:

- complete fresh replay through the new migration;
- representative existing-data upgrade from the full 133-migration C5 baseline;
- exact preservation of representative legacy ACTIVE/manual forms, confirmation-pending,
  submitted, reviewed and historically approved submissions, including a historic
  clientless approval;
- zero aligned markers or provisioning inference after migration;
- valid EVENT and STANDALONE aligned form shapes;
- rejection of partial contract/revision/scope shapes, invalid scope/Event combinations,
  invalid fixed/selectable Project-type shapes and non-array type configuration;
- valid typed evidence and rejection of lowercase/invalid country code and present-but-blank
  typed fields, including Project type;
- valid exact same-tenant approved member/Client, approved Project/Client, delivery/Project
  and trusted member/Client relations;
- rejection of new half-present pairs and wrong-tenant, wrong-Client or wrong-Project exact
  relations, while preserving legacy clientless approval evidence outside contract version
  `1`;
- valid incomplete exception evidence, valid AUTOMATED completion and valid C1_REVIEW
  completion;
- rejection of `SUBMITTED` as an automated exception, preservation of the exception reason
  through accepted non-completion review statuses and rejection of partial approved results;
- rejection of incomplete completion, invalid path/evaluation/review evidence and mixed
  trusted identity pairs;
- restrictive deletion tests for referenced outcome rows;
- A1/C1/C2/C3/C4/C5 regression checks;
- zero R3-A test residue.

Also run Prisma format/validate/generate, the focused schema verifier, TypeScript checking
needed to prove generated-client compatibility, focused lint where verifier code is added,
repository checks and `git diff --check` in both repositories.

## 8. Rollback And Failure Handling

Before any shared write, rollback is migration/code reversion only on the disposable test
database. Do not test rollback destructively against shared development, staging or live.

If the representative existing-data migration finds an incompatible legacy form,
submission or duplicate supporting key, stop. Amend the plan or add an explicit safe
preflight/remediation step; do not rewrite historic Intake evidence to make the migration
pass.

After a shared environment contains new R3-A columns or enum values, rollback requires a
separately reviewed forward-remediation plan that preserves evidence.

## 9. Lifecycle Deliverables After Implementation

Only after separate plan acceptance and successful implementation:

- create one R3-A implementation-confirmation record;
- create one independent R3-A review/test record;
- update the FUND roadmap first, then the root roadmap and planning README;
- record commit, migration count, branch and deployment state exactly;
- stop without beginning R3-B.

No parent implementation-confirmation is created because `1P-G-R3` is a planning family,
not an executable implementation unit.

## 10. Acceptance Result

The review confirms:

- explicit aligned contract/scope/revision markers are required instead of inferring
  automation from legacy Boolean fields;
- the form revision snapshot is sufficient for R3-B to reject a changed offer at
  confirmation, while typed requested Event/standalone and Project-type evidence records
  the trusted outcome;
- the two-path provisioning enum plus separate exception reason accurately represents
  automatic, intentional manual and exception-reviewed outcomes;
- JSON Project-type configuration is acceptable as a form policy validated by services,
  with database shape checks but no invented Product/Project-type table;
- current Prisma multi-schema relations can express the accepted exact composite keys,
  supported by explicit pair-shape checks for nullable foreign keys;
- all completion-only checks are conditional on version `1`, so historic approved
  submissions remain valid and receive no inferred aligned evidence;
- one additive zero-backfill migration is safe after the committed C5 baseline.

No business or technical question blocks the bounded R3-A implementation.

## 11. Single Bounded Implementation Prompt

```text
Continue only accepted FUND Phase 1 Slice 1P-G-R3-A. Do not begin R3-B, R3-C, Store 1R-D,
1R-C6, COMMERCE-A2 or another slice.

Starting from committed C5 application baseline 8b5f208 and its complete 133-migration
history, implement only the accepted Project Intake Automation Schema And Form Policy
Foundation in the current Prisma schema and one bounded migration. Add the three bounded
Fund-prefixed enums; explicit aligned-form scope/contract/revision and Project-type policy;
typed organiser/address/Project-type submission evidence; submitted form-policy snapshots;
provisioning/review/exception evidence; the FundClientMember, FundProject and
FundProjectDeliveryProfile exact composite keys; exact approved member/Client, approved
Project/Client, approved delivery/Project and trusted initiating member/Client relations;
and the accepted checks, indexes and deletion actions.

Preserve every existing form, submission, Client, User, member, Project and delivery-profile
value. Opt no form into automation, infer no structured value from free text/rawPayload and
create no operational row. Historic aligned/provisioning fields must remain null. Add no
confirmation, moderation, provisioning, User/member, service, API, route, email or UI
behaviour.

Use only TEST_DATABASE_URL after proving it differs from DATABASE_URL. Complete a
representative 133-to-134 existing-data migration, full fresh replay, every planned
form/snapshot/typed-evidence/provisioning/exception/tenant/owner/deletion constraint,
A1/C1/C2/C3/C4/C5 regressions and zero-residue cleanup. Do not modify shared development,
staging or production databases.

After successful validation, create separate R3-A implementation-confirmation and
review/test records, update the FUND and root roadmaps and planning README, and stop. Do not
start R3-B.
```
