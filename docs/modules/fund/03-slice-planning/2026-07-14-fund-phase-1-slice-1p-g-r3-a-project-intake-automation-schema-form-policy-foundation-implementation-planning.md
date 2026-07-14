# FUND Phase 1 Slice 1P-G-R3-A - Project Intake Automation Schema And Form Policy Foundation Implementation Planning

Date: 2026-07-14

Status: Planning created / awaiting explicit review and acceptance / no implementation authorised

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

## 2. Entry Gate And Baseline

The parent `1P-G-R3` alignment is accepted. This child remains unaccepted until its own
review completes.

Implementation must not start from an ambiguous working tree. The completed `1R-C5`
schema/migration/review lifecycle must first be committed as the explicit application and
documentation baseline. R3-A then follows the complete existing migration history and adds
one migration after the current 133-migration C5 baseline.

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
- the two exact composite identity keys required on `FundClientMember` and
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
```

Existing `respondentName`, contact fields and `rawPayload` remain unchanged. The migration
does not parse or split historic text/JSON.

Checks enforce nonblank values when these text fields are present and an uppercase
two-letter country code when country is present. Complete-address requirements for new
aligned submissions remain application validation until a provisioning contract completes.

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
  approved Project, approved delivery profile, completion time and provisioning path;
- `AUTOMATED` completion has an automation policy version and evaluation time and no
  exception reason;
- `C1_REVIEW` completion has C1 review actor/time evidence; it may retain an exception
  reason, while an intentionally manual review need not invent one;
- an exception reason without completion cannot coexist with approved member/delivery
  result or a completed provisioning contract;
- automation versions, form versions and revisions are positive when present.

The exact allowed pre-completion exception status is finalized in the migration review
against the existing transition vocabulary. It must support the retained review queue
without rewriting historic statuses and must not claim a completed operational result.

### 4.6 Exact tenant/owner relations

Add supporting unique keys:

```text
FundClientMember(organizationId, id, clientId)
FundProjectDeliveryProfile(organizationId, id, projectId)
```

Add named exact relations so:

- `approvedClientMemberId` belongs to `approvedClientId` in the same tenant;
- `approvedProjectDeliveryProfileId` belongs to `approvedProjectId` in the same tenant;
- `trustedInitiatingClientMemberId` belongs to `trustedInitiatingClientId` in the same
  tenant.

Use `onDelete: Restrict`/PostgreSQL `NO ACTION` for submission evidence pointing to Client,
member, Project and delivery outcome records. Existing historic deletion contracts are not
weakened. Add only the reverse Prisma relations necessary to validate/generate this schema.

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
3. add the two supporting composite unique keys;
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
  submitted, reviewed and historically approved submissions;
- zero aligned markers or provisioning inference after migration;
- valid EVENT and STANDALONE aligned form shapes;
- rejection of partial contract/revision/scope shapes, invalid scope/Event combinations,
  invalid fixed/selectable Project-type shapes and non-array type configuration;
- valid typed evidence and rejection of lowercase/invalid country code and present-but-blank
  typed fields;
- valid exact same-tenant approved member/Client, delivery/Project and trusted member/Client
  relations;
- rejection of wrong-tenant, wrong-Client and wrong-Project exact relations;
- valid incomplete exception evidence, valid AUTOMATED completion and valid C1_REVIEW
  completion;
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

## 10. Acceptance Questions

No business question blocks review. Technical review must confirm:

- explicit aligned contract/scope/revision markers are preferable to inferring automation
  from legacy Boolean fields;
- the form revision snapshot is sufficient for R3-B to reject a changed offer at
  confirmation;
- the two-path provisioning enum plus separate exception reason accurately represents
  automatic, intentional manual and exception-reviewed outcomes;
- JSON Project-type configuration is acceptable as a form policy validated by services,
  with database shape checks but no invented Product/Project-type table;
- the exact composite relations can be expressed by current Prisma multi-schema support;
- no proposed check makes historic approved submissions falsely incomplete;
- one additive zero-backfill migration is safe after C5.

## 11. Single Review Prompt

```text
Review only FUND Phase 1 Slice 1P-G-R3-A Project Intake Automation Schema And Form Policy
Foundation Implementation Planning. Do not implement schema or application code and do not
begin R3-B, R3-C, Store 1R-D, 1R-C6, COMMERCE-A2 or another slice.

Verify the plan against the accepted 1P-G-R3 parent, current Prisma multi-schema model, the
complete 133-migration C5 baseline and existing Project Intake historic data contracts.
Resolve aligned form opt-in, EVENT/STANDALONE shape, Project-type configuration, form-policy
revision snapshots, typed organiser/address evidence, automated/C1-review/exception
evidence, exact member/Client and delivery/Project tenant keys, deletion, zero backfill,
migration order, rollback and disposable-database validation.

Confirm that R3-A adds schema evidence only and creates or modifies no Client, User, member,
Project, delivery profile, form behaviour, confirmation, moderation, service, API, route,
email or UI. If acceptable, mark only R3-A accepted and give its single bounded
implementation prompt. Make no Prisma, migration, service, API, route or UI changes.
```
