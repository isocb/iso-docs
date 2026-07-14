# FUND Phase 1 Slice 1P-G-R3-B - Project Intake Automated Provisioning And Protection Services Implementation Planning

Date: 2026-07-14

Status: Implemented and reviewed as passed / dormant / application committed at `04da074`

Parent alignment:

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1p-g-r3-project-intake-automated-provisioning-alignment-planning.md`

Completed schema foundation:

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1p-g-r3-a-project-intake-automation-schema-form-policy-foundation-implementation-planning.md`

Parent controls:

`docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`

`docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 1. Goal

Create the internal service and protection engine that can safely turn one confirmed,
explicitly aligned Project Intake submission into one complete operational outcome:

```text
resolved or newly created FundClient
-> login-capable primary/selected FundClientMember and User
-> Client-owned DRAFT FundProject
-> initial FundProjectDeliveryProfile
-> complete version-1 submission provisioning evidence and audit
```

The engine must also classify a bounded, reviewable exception without creating any
operational row when identity, duplicate, form, Event, date or access authority is not safe
and deterministic.

R3-B does not connect this engine to the public confirmation route or C1 screens. It creates
no automatic runtime path merely by being deployed. R3-C will separately align the form,
submission, confirmation and exception-review transports and UI after its own accepted
plan.

This document is planning only. It makes no application, Prisma, migration, API, route,
email, UI or database change.

## 2. Entry Gate And Baseline

R3-B implementation may begin only after separate review accepts this plan and confirms:

- the R3-A schema/migration, implementation confirmation and review/test lifecycle remain
  the exact entry contract;
- the application R3-A implementation and its lifecycle documentation are committed as
  separate, unambiguous baselines before any R3-B application edit; an uncommitted R3-A
  worktree is not an acceptable R3-B implementation baseline;
- the documentation baseline records R3-A as complete and R3-B as separately authorised;
- `TEST_DATABASE_URL` exists and is proven distinct from `DATABASE_URL` before any
  destructive or write-based test;
- no R3-C, Store `1R-D`, `1R-C6`, `COMMERCE-A2` or all-source Project Creation Contract
  Alignment work is mixed into the slice.

R3-B adds no migration. If implementation discovers a missing database invariant, stop and
return to schema planning rather than silently widening R3-B or editing the accepted R3-A
migration.

## 3. Controlling Ownership And Trust Rules

The service must preserve these accepted authorities:

1. The C1-saved `FundProjectIntakeForm` is the only authority for Event versus standalone
   scope and the permitted Project-type offer.
2. Public payload, page/embed context, raw JSON, organisation name, email and hidden IDs are
   evidence only. They never establish existing-Client ownership.
3. Existing-Client straight-through provisioning requires a server-recorded Client/member
   pair derived from an authenticated session at submission and revalidated at
   confirmation.
4. That member must still belong to the same tenant and Client, be active and unarchived,
   have dashboard access, link to an active same-tenant User and have `PROJECT_MANAGER` or
   `ADMIN` access.
5. A new-Client organiser may provision automatically only after email confirmation and
   only when no conflicting User, membership, Client or probable-duplicate signal exists.
6. A standalone Project means a Client-owned Project with no Event. R3-B never creates a
   clientless Project.
7. An automated or reviewed version-1 result is complete only when Client, member, Project
   and delivery-profile identities are recorded together.
8. Unexpected infrastructure or transaction failures are retriable failures. They are not
   silently converted into a business exception.

R3-B may return internal, bounded reason codes. Public account-existence-safe copy remains
R3-C transport work; neither the service nor its future caller may disclose whether a
Client, member or User exists.

## 4. Bounded Scope

R3-B may implement only:

- pure aligned-form policy normalization, validation, authority comparison and revision
  helpers;
- the shared bounded Project-type vocabulary and normalization used by Intake and the
  existing C2 Project service;
- trusted existing-Client membership capture/revalidation helpers;
- new/existing Client and organiser identity assessment;
- deterministic duplicate and conflict signals;
- bounded exception classification;
- transaction-capable safe User/member resolution shared with existing member policy;
- one atomic Project Intake provisioning engine for automated and C1-reviewed outcomes;
- row locking, idempotent result return, concurrency protection and transactional audit;
- guards preventing the legacy approval services from writing an aligned submission through
  a clientless or incomplete legacy outcome;
- focused pure-policy, service, transaction, regression and disposable-database tests.

R3-B must not implement or change:

- public form fields, steps, components, payloads or copy;
- C1 form configuration, submission or exception-review components;
- public or authenticated tRPC procedures and route integration;
- confirmation-token consumption or invocation of provisioning from the confirmation route;
- actual request/IP rate-limit middleware, CAPTCHA/Turnstile or browser-session handling;
- onboarding, approval, invitation, magic-link or any other email;
- notification-template management;
- generic C1 Project creation, K2 direct C2 Project creation outcomes or the separately
  required all-source Project Creation Contract Alignment;
- Store creation/readiness/publication, commission acceptance, Commerce, payment,
  production or fulfilment workflow;
- Prisma models, enums, fields, constraints, indexes or migrations.

Existing routes continue their current behaviour after R3-B except that legacy approval
functions must reject newly aligned submissions and direct callers can exercise the new
internal engine. No form is opted into automation and no confirmation path invokes the
engine until R3-C.

## 5. Canonical Form Policy Contract

Create one pure policy module rather than distributing form authority across validation,
submission and confirmation code.

### 5.1 Version-1 aligned policy

A version-1 policy is eligible only when:

- `formContractVersion = 1` and `formPolicyRevision >= 1`;
- `alignedScope = EVENT` has one same-tenant `defaultEventId` and
  `allowStandaloneProjects = false`;
- `alignedScope = STANDALONE` has no Event and
  `allowStandaloneProjects = true`;
- fixed Project type means selection is disabled and a supported default code exists;
- selectable Project type means the normalized allowed set is non-empty, unique and
  contains only supported codes; any default belongs to it;
- allowed Client types are normalized, unique and bounded to the existing accepted set;
- form window and positive submission-limit rules remain valid.

The shared initial Project-type set remains:

```text
ARTWORK_FUNDRAISING
GROUP_PERSONALISED_PRODUCTS
BULK_ORDER_CLUB_FUNDED
NOT_SURE
```

The aligned service stores canonical codes, not display labels, in
`proposedClientType` and `proposedProjectTypeCode`. Historic label/free-text values remain
untouched and are never inferred into the aligned contract.

### 5.2 Revision authority

Define one canonical provisioning-policy snapshot and equality function. The following are
authority fields whose change requires a revision increment before the form can accept a
new aligned submission:

```text
alignedScope
defaultEventId
allowStandaloneProjects
defaultProjectTypeCode
allowProjectTypeSelection
normalized allowedProjectTypeCodes
normalized allowedClientTypes
allowExistingClientSelection
requiresModeration
startsAt
endsAt
submissionLimit
```

Name, description, instructions, source label, success message, branding and ordinary
metadata are not provisioning authority and do not increment the revision. Status changes
do not change the policy revision, although a non-active form is ineligible at submission
or confirmation.

R3-B implements and tests the canonical comparison and next-revision helper. R3-C is the
first slice allowed to bind that helper into C1 create/update/activation transport and UI.
R3-B therefore cannot accidentally align or activate an existing form.

### 5.3 Submission and confirmation comparison

The policy service must:

- derive the trusted fixed Project type or validate one requested code against the current
  allowed set;
- produce the server-owned contract/revision and type snapshots that R3-C will write at
  submission;
- compare the stored submission contract/revision with the current form at confirmation;
- return `FORM_POLICY_CHANGED` rather than provisioning when they differ;
- require the current form to remain active, in-window and structurally valid, with the
  unchanged submission-limit configuration represented by its policy revision;
- treat a legacy form or an explicitly manual aligned form as review-only, never automatic.

The comparison never reconstructs authority from `rawPayload`.

The submission limit is reserved when R3-C atomically accepts a new submission. At
confirmation, R3-B verifies the unchanged limit configuration through the policy revision
but does not reject an already accepted submission merely because that submission or a
later one has filled the count. Re-counting with `count >= submissionLimit` at confirmation
would incorrectly consume the current submission's own reserved place.

## 6. Protection Evaluation And Outcomes

Use a deterministic internal result type equivalent to:

```text
AUTOMATIC_ELIGIBLE
MANUAL_REVIEW
EXCEPTION_REVIEW(reason)
DENIED_NO_QUEUE
RETRIABLE_FAILURE
ALREADY_COMPLETED(result)
```

Only `AUTOMATIC_ELIGIBLE` may enter automatic provisioning. `MANUAL_REVIEW` leaves the
existing manual submission workflow intact and has no invented exception reason.
`EXCEPTION_REVIEW` writes `IN_REVIEW`, automation version/evaluation time and one accepted
R3-A exception reason, with no operational result. `DENIED_NO_QUEUE` is reserved for
invalid tokens, explicit rate limiting or obvious abuse handled by the future route caller;
it must not amplify abuse by creating review work. `RETRIABLE_FAILURE` rolls back and
surfaces a generic failure without committing exception evidence.

R3-B owns the trusted interface for a future caller to provide route-level rate/abuse
outcomes, but R3-C owns the actual request/IP middleware and confirmation integration.

Map stable conditions to the existing R3-A reasons:

| Condition | Exception reason |
| --- | --- |
| Existing Client claimed without a trusted eligible membership | `EXISTING_CLIENT_AUTH_REQUIRED` |
| Member access is below `PROJECT_MANAGER` or dashboard access is disabled | `INSUFFICIENT_CLIENT_ACCESS` |
| More than one plausible Client/member outcome remains | `AMBIGUOUS_CLIENT_MATCH` |
| Cross-tenant User, email/User/member conflict or incompatible identity | `IDENTITY_CONFLICT` |
| Client, User or member is inactive, archived, suspended or deletion-requested | `INACTIVE_OR_ARCHIVED_ACCOUNT` |
| Exact normalized Client/Project/submission duplicate signal requires a decision | `POSSIBLE_DUPLICATE` |
| Submitted form version/revision differs from current policy | `FORM_POLICY_CHANGED` |
| Event/scope/date/current-form validity fails | `EVENT_OR_DATE_INVALID` |
| A non-obvious bounded rate/abuse outcome is intentionally queued | `RATE_OR_ABUSE_LIMIT` |
| A deterministic policy condition has no more specific reason | `AUTOMATED_POLICY_FAILURE` |

`AUTOMATED_POLICY_FAILURE` is not a catch-all for database outages or programming errors.

## 7. New And Existing Client Identity Rules

### 7.1 New Client path

Normalize email, names, Client name, contact fields and address values once. Successful
confirmation is accepted email-control evidence for this Intake transaction.

Automatic new-Client provisioning may:

- create a new same-tenant `FundClient` with `ACTIVE` status;
- create a new `User`, or reuse an existing active same-tenant User with the exact normalized
  email when there is no conflicting Client membership;
- create one `ACTIVE`, non-archived, primary member with `PROJECT_MANAGER` access and
  dashboard access enabled;
- set a new User to platform `MEMBER`, `ACTIVE` and email-verified at the confirmation time;
- set `emailVerified` on a safe existing same-tenant User only when it is null and the
  confirmed address is exact.

It must not silently reactivate a User/member, overwrite an existing User's name, mobile,
role, status or security state, de-primary another Client's member, or attach a User owned
by another tenant. Existing identity/profile conflicts enter review.

An exact normalized Client name/contact/member signal or another completed/pending Intake
with the same stable fingerprint is a duplicate warning, not ownership authority. It enters
review; no fuzzy match silently links or rejects a Client.

### 7.2 Existing Client path

At submission, R3-C will call the R3-B trusted-membership helper with the authenticated
actor. The helper must derive, never accept from browser input:

```text
organizationId
trustedInitiatingClientId
trustedInitiatingClientMemberId
linked userId
```

At confirmation, the service re-loads the exact recorded member and requires:

- same tenant and exact Client;
- member status `ACTIVE`, no archive timestamp;
- dashboard access enabled;
- access `PROJECT_MANAGER` or `ADMIN`;
- linked User exists in the same tenant, has the exact member email and is `ACTIVE`;
- Client is `ACTIVE` and unarchived;
- the form permits existing-Client selection.

The original browser session is not required at confirmation. If the recorded authority is
no longer valid, create no replacement Client/member and route to the bounded exception.
Straight-through existing-Client provisioning reuses the exact member and does not change
member access, primary status or User fields.

### 7.3 C1-reviewed identity

The internal reviewed path accepts an authenticated C1 actor and an explicit resolution:

- create new Client or select one active same-tenant Client;
- reuse one exact eligible member or create one member/User safely;
- default a new organiser member to `PROJECT_MANAGER`;
- allow only `PROJECT_MANAGER` or `ADMIN` when C1 explicitly chooses the new member's role;
- make a new Client's organiser primary;
- never change an existing Client's primary member unless the reviewed input explicitly
  requests that change and the audit records it.

The reviewed wrapper must itself call the established FUND admin assertion for a trusted
`FundActor` produced by authenticated server context; router-only assertion is insufficient
for an internal service contract. It scopes every read/write to `actor.organizationId`,
accepts no actor or tenant from public input, and preserves the platform's existing
effective-tenant/impersonation policy rather than inventing a second actor model.

Existing User status handling is explicit:

- automatic Intake may reuse only an `ACTIVE` User;
- a reviewed C1 outcome may activate `PENDING`, `PENDING_INVITE` or
  `PENDING_PASSWORD_RESET` only through an explicit reviewed choice;
- `SUSPENDED`, `DEACTIVATED` and `GDPR_DELETE_REQUESTED` Users remain blocked until corrected
  through the owning User-management workflow;
- Intake never overwrites an existing User's name, mobile, role or preferences;
- filling a null `emailVerified` from the exact confirmed email is the only automatic
  existing-User profile mutation.

R3-C will later provide the validated transport and UI for these choices. R3-B exposes no
new C1 procedure.

## 8. Duplicate, Identifier And Project Policy

Extract or share the existing bounded Project-type vocabulary, slug normalization,
Project-number/slug generation and Event/date checks used by K2 rather than creating an
unrelated third rule set.

Generated Client and Project identifiers must use normalized human-readable bases plus a
collision-resistant suffix. Database uniqueness remains authoritative; a bounded retry may
regenerate an identifier, but an identity or business conflict must not be hidden as an
identifier retry.

The probable-duplicate check is advisory and tenant-scoped. At minimum it considers:

- another completed aligned result for the same submission;
- the same non-null normalized submission fingerprint on another relevant submission;
- an existing Project for the resolved Client with the same normalized name, Event/no-Event
  scope and opening/closing instants;
- for a new Client, exact normalized Client/contact/member evidence that requires C1 to
  choose create-new or link-existing.

Project-name similarity alone never selects ownership. Cross-tenant records are neither
returned nor exposed as a match.

## 9. Atomic Provisioning Contract

### 9.1 Transaction boundary and locking

Implement a transaction-capable internal function that R3-C can call from inside the final
confirmation transaction. It must use a PostgreSQL row lock on the exact
tenant/form/submission identity before reading or writing provisioning state. A wrapper may
open its own transaction for reviewed service calls and focused tests.

A submission-row lock alone protects only two attempts for the same submission. Before
duplicate evaluation, automatic Intake must also acquire transaction-scoped PostgreSQL
advisory locks, in one documented order, for:

```text
normalized organiser email
nonblank normalized submission fingerprint
resolved Client + normalized Project/Event/date duplicate key
```

Hash collisions may serialize unrelated work but must not weaken correctness. The advisory
locks are transaction-scoped and require no migration. Automatic provisioning requires a
server-produced nonblank fingerprint; an aligned row without one enters controlled review.
Reviewed C1 provisioning may proceed without a legacy fingerprint after explicit review.

The lock namespaces are explicit: normalized organiser email is global because `User.email`
is globally unique; fingerprint locks include the tenant; Project duplicate locks include
tenant and resolved Client. Email and member lookups are normalized and case-insensitive so
historic case variants cannot evade protection. Multiple case variants are an identity
conflict, not an arbitrary match.

The locked transaction must:

1. load the submission, form and required same-tenant evidence;
2. return the existing complete version-1 result when already approved;
3. reject partial or inconsistent prior evidence for controlled remediation;
4. revalidate policy, Event, dates, Project type, trusted identity and duplicates;
5. commit an exception-only result when a stable business protection fails;
6. otherwise resolve/create Client and User/member safely;
7. create one Client-owned DRAFT/SETUP Project;
8. create its one initial delivery profile;
9. write the complete submission result and decision evidence;
10. write all meaningful audit rows;
11. commit everything together.

R3-C must later consume the confirmation token, set confirmed/submitted evidence and invoke
the transaction-capable function inside this same outer transaction. R3-B does not alter
the current confirmation service.

Use a bounded retry for PostgreSQL serialization/deadlock errors only. Do not retry
validation, identity, duplicate or uniqueness failures as though they were infrastructure
errors.

### 9.2 Created operational shape

An automated new-Client result creates:

- one active Client;
- one safe linked/created User;
- one active primary `PROJECT_MANAGER` Client member with dashboard access;
- one Client-owned `FundProject` in `DRAFT` / `SETUP`;
- one Project delivery profile;
- one complete approved submission result.

An automatic existing-Client result creates only the Project and delivery profile, reusing
the exact Client/member/User.

The Project copies:

```text
clientId                 resolved Client
eventId                  form Event, or null for standalone
organiser snapshots      resolved member name/email/phone
opensAt/closesAt         confirmed typed submission values
metadata.projectType     proposedProjectTypeCode
metadata.source          PROJECT_INTAKE
metadata.intakeFormId    form ID
metadata.intakeSubmissionId submission ID
```

The delivery profile copies once:

```text
recipientName  Client/project-owning-body name
attentionName  organiser display name
address fields confirmed structured Intake evidence
email/phone    organiser contact evidence
```

It remains Project-owned and independently editable after creation.

For automatic writes, nullable `createdById`/`updatedById` actor fields remain null and
audit `userId` is null; audit metadata records the automated path and trusted form/submission
IDs. Reviewed writes use the C1 actor. Do not invent a platform service User.

### 9.3 Completion evidence

Successful automatic completion writes:

```text
status = APPROVED
provisioningContractVersion = 1
provisioningPath = AUTOMATED
provisioningCompletedAt
automationPolicyVersion = 1
automationEvaluatedAt
approved Client/member/Project/Event/delivery identities
no exceptionReason
```

Reviewed completion writes `C1_REVIEW`, the C1 review actor/time and retains any original
exception reason. An intentionally manual aligned form need not invent an exception reason.
Automatic completion leaves `moderationDecision` null. Reviewed completion writes
`CREATE_CLIENT_AND_PROJECT` or `LINK_CLIENT_CREATE_PROJECT` as appropriate. Legacy
moderation-decision values remain readable; new aligned completion must not write
`CREATE_PROJECT_STANDALONE`.

## 10. Shared User/Member Safety Refactor

The current member service mutates an existing User's profile/status while linking. R3-B
must not call that behaviour unchanged for automatic Intake.

Refactor a transaction-capable internal User/member resolver with explicit policy modes so:

- existing C1-managed member operations retain their reviewed behaviour and regress cleanly;
- confirmed automatic Intake uses the stricter no-reactivation/no-profile-overwrite mode;
- reviewed Intake uses explicit, audited C1 choices;
- same-tenant User ownership, global email uniqueness, User status, member uniqueness and
  dashboard/access invariants are checked in one transaction;
- creating/linking a User never sends email.

Do not duplicate password, authentication, role or tenant security rules inside the Intake
service.

## 11. Legacy Approval Protection

The current approval procedures remain available for historic/manual rows until R3-C
replaces their aligned presentation. R3-B must add a service-level guard:

- preserve historic legacy behaviour only when both the submission snapshot and its linked
  form contract are null;
- if either `submittedFormContractVersion` or the linked form's `formContractVersion` is
  version `1`, reject all three legacy create/link/clientless approval functions and require
  the new complete provisioning engine;
- never write `CREATE_PROJECT_STANDALONE` for an aligned submission;
- never allow an aligned approval that lacks Client, member or delivery-profile evidence.

No procedure is removed in R3-B because the current C1 UI and historic workflow remain R3-C
integration concerns.

## 12. Idempotency, Audit And Failure Handling

- Submission locking makes its recorded complete result the retry authority; ordered
  advisory locks protect equivalent work across different submissions.
- A repeated call after success returns the same Client/member/Project/delivery identities.
- Concurrent calls cannot create two outcomes.
- The existing public idempotency key/fingerprint remains submission-level evidence; it is
  not accepted as existing-Client authority.
- Audit rows for evaluation, exception, Client/User/member/Project/delivery creation and
  reviewed primary-member change are written inside the same transaction as their outcome.
- Audit metadata uses IDs and bounded outcomes; avoid duplicating address or unnecessary PII.
- A thrown transaction error leaves no Client, User, member, Project, delivery, completion
  or in-transaction audit residue.
- A stable business exception commits only the submission exception/evaluation evidence and
  its audit row.
- No email, Store, commission or downstream job is emitted.

## 13. Expected Application Files

The implementation review should keep the exact diff as small as practical. Expected areas
are:

```text
src/modules/fund/lib/project-intake-policy.ts                         new pure policy module
src/modules/fund/lib/project-types.ts                                new/extracted shared vocabulary
src/modules/fund/services/project-intake-provisioning.service.ts     new internal engine
src/modules/fund/services/project-intake.service.ts                  aligned legacy guards/shared reads
src/modules/fund/services/client-members.service.ts                  transaction-safe shared resolver
src/modules/fund/services/client-dashboard.service.ts                import shared Project policy/helpers
focused Vitest/service verifier files
focused disposable PostgreSQL transaction runner
```

`src/modules/fund/lib/validation/project-intake.ts` may add internal schemas/types only if
they are not exposed through a new router procedure. `project-intake.router.ts` should not
change unless review proves a compile-only internal type dependency; no new or changed
procedure is authorised.

No Prisma schema or migration file should change.

## 14. Validation Plan

### 14.1 Static and pure-policy evidence

- type-check, focused lint, critical-file checks and `git diff --check`;
- R3-A schema/migration verifier and migration inventory remain exactly 134;
- canonical form-policy validation for Event/standalone and fixed/selectable Project types;
- normalization, allowed-set deduplication and canonical policy equality;
- revision increment only for the authority fields listed in section 5.2;
- current/submitted revision comparison and manual/legacy outcomes;
- reserved submission-limit behavior so a previously accepted submission is not displaced
  by its own or a later count;
- stable exception-reason mapping and generic external error shape;
- static proof that no router, component, email or Prisma migration was added.

### 14.2 Disposable PostgreSQL service/transaction evidence

Use only `TEST_DATABASE_URL` after proving it differs from `DATABASE_URL`. Begin from the
complete 134-migration R3-A baseline and leave zero R3-B fixture/audit residue.

Required cases:

- automatic new Client creates exactly one Client, User, primary active
  `PROJECT_MANAGER` member, Project, delivery profile and complete result;
- safe same-tenant active User reuse does not overwrite name, phone, role, status or
  preferences and only fills missing email verification from confirmation evidence;
- cross-tenant, suspended/deletion-requested User and conflicting membership cases create no
  operational rows and record the correct exception;
- automatic existing Client requires and revalidates the exact active eligible member/User,
  creates only Project/delivery and does not change primary/access/profile state;
- insufficient access, disabled dashboard, inactive/archived member or Client and changed
  identity become bounded exceptions;
- Event and standalone scope, Event status/date and Project-type authority cannot be
  overridden by untrusted values;
- Clientless aligned provisioning is impossible;
- fixed/selectable type and canonical Client-type evidence are copied correctly;
- exact duplicate signals create no operational rows;
- two different concurrent submissions with the same fingerprint or duplicate Project key
  serialize and cannot both create operational outcomes;
- reviewed create/link/member/primary choices are tenant-safe, explicit and audited;
- reviewed service calls reject missing/untrusted or non-OWNER/ADMIN actor context and keep
  every selected outcome inside the actor's effective tenant;
- reviewed activation permits only the explicitly accepted pending User states and blocks
  suspended, deactivated and deletion-requested Users;
- an intentional manual aligned result uses `C1_REVIEW` without inventing an exception;
- a reviewed exception retains its original reason;
- aligned rows are rejected by every legacy approval service while historic null-contract
  rows retain their previous path;
- a completed retry returns the same exact result;
- two concurrent attempts produce one outcome;
- controlled failure after Client/User/member/Project/delivery stages rolls back every
  operational and audit row;
- an unexpected database error remains retriable and does not commit a false exception;
- no email or downstream record is created.

Use deterministic injected identifier/failure collaborators only inside the internal test
harness; do not expose failpoints or caller-selected identifiers through a route or public
service contract.

### 14.3 Regression evidence

- existing Project Intake form/list/review/legacy confirmation behaviour remains unchanged;
- existing C1 member create/update/link/archive behavior passes focused regressions;
- K1-F authentication routing still rejects inactive, archived, `NONE` and
  dashboard-disabled membership;
- K2 C2 Project create/edit retains its Project-type, Event/date, identifier, access and
  idempotency behavior after helper extraction;
- A1/C1/C2/C3/C4/C5/R3-A static/schema verifiers pass;
- historic Intake rows receive no inferred contract or operational result.

R3-B does not require a fresh migration replay because it adds no schema or migration. The
review must nevertheless prove the disposable database is at the complete 134-migration
baseline before transaction tests.

## 15. Rollback And Deployment Safety

Before shared deployment, rollback is code reversion plus disposable fixture cleanup. No
schema rollback exists.

R3-B is intentionally dormant without R3-C integration. Deploying it must not opt in a form,
consume a token, provision a Project or alter a route by itself. If implementation changes
observable existing-route behaviour beyond the aligned legacy guard, stop and return to
review.

After R3-C activates the engine in a shared environment, operational records are business
evidence and must never be deleted as a code rollback. Any later correction requires a
forward, audited remediation plan.

## 16. Lifecycle Deliverables After Future Implementation

Only after this plan is explicitly reviewed and accepted:

- implement the bounded R3-B service/protection diff with no migration;
- create one R3-B implementation-confirmation record;
- create one independent R3-B review/test record;
- update the FUND roadmap first, then the root roadmap and planning README;
- record branch, commit and deployment state exactly;
- stop without beginning R3-C.

## 17. Acceptance Result

Review on 2026-07-14 accepted the bounded R3-B plan after resolving:

- confirmation must honour a submission-limit place reserved at submission rather than
  re-count and displace an already accepted submission;
- the exact tenant/form/submission row is locked, while ordered transaction advisory locks
  cover email, fingerprint and duplicate-Project concurrency across different submissions;
- automatic provisioning requires a server-owned nonblank fingerprint;
- aligned legacy approval guards inspect both submission and current form contract evidence;
- the internal reviewed wrapper independently asserts trusted C1 `OWNER`/`ADMIN` authority
  and tenant-scopes every outcome while preserving existing effective-tenant policy;
- automatic and reviewed existing-User status/mutation rules are explicit;
- automatic and reviewed moderation-decision evidence is unambiguous.

No additional schema or migration is required. R3-A contains the evidence and exact
relations required by the service engine, and the current Prisma schema validates with the
complete 134-migration inventory.

The important boundary is explicit:

```text
R3-B builds and verifies the dormant internal engine.
R3-C captures aligned public/authenticated inputs, consumes confirmation tokens, invokes
the engine, and presents C1 exception review.
```

The entry gate was satisfied by application R3-A commit `4bb7dd9` and IsoDocs baseline
`65fc243`. R3-B subsequently completed its dormant implementation and independent
review/test lifecycle. The bounded implementation prompt below is retained as execution
history and must not be rerun as pending work.

## 18. Single Bounded Implementation Prompt

```text
Continue only accepted FUND Phase 1 Slice 1P-G-R3-B. Do not begin R3-C, Store 1R-D,
1R-C6, COMMERCE-A2 or another slice.

Begin only from separately committed R3-A application and documentation lifecycle
baselines with the complete 134-migration history. If R3-A remains uncommitted, make no
R3-B application edit and tell me that the R3-A baseline must be committed first.

Implement only the dormant internal Project Intake form-policy, protection and atomic
provisioning engine. Add the canonical version-1 policy normalization/revision/comparison
helpers; shared Project-type and K2-compatible Project policy helpers; trusted existing-
Client membership capture/revalidation; strict automatic and explicit reviewed User/member
resolution; bounded identity/duplicate/exception classification; exact tenant/form/
submission row locking; ordered transaction advisory locks for email, fingerprint and
duplicate-Project keys; idempotent automated/C1-reviewed Client/member/Project/delivery
provisioning; transactional audit; and aligned legacy-approval guards exactly as accepted.

Use the existing R3-A schema without modification. Add no Prisma migration, public/C1
procedure or route integration, confirmation trigger/token consumption, request rate-limit
middleware, form or exception-review UI, email, generic C1/K2 Project-creation remediation,
Store, Commerce, production or commission behaviour. R3-B must remain dormant until R3-C.

Use only TEST_DATABASE_URL after proving it differs from DATABASE_URL. Verify the complete
134-migration baseline, pure policy/revision behavior, new/existing Client and User/member
protections, Event/date/type authority, reviewed actor/status rules, legacy guards,
same-submission retries, cross-submission advisory-lock concurrency, injected rollback at
every operational stage, transactional audit, K1-F/K2/Project Intake regressions,
A1/C1/C2/C3/C4/C5/R3-A static regressions and zero test residue.

After successful validation, create separate R3-B implementation-confirmation and
review/test records, update the FUND and root roadmaps and planning README, and stop. Do not
connect the engine or start R3-C.
```
