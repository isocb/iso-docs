# FUND Phase 1 Slice 1P-A - C2 Project Access Model Proposal

Date: 2026-06-24

Last updated: 2026-06-25

Status: Planning complete / ready for review

Target app branch:

```text
feature/fund-phase-1-c2-project-access
```

## 1. Slice Goal

Define the minimal safe access model for C2 Project organisers before any C2 dashboard implementation.

The C1 admin foundation is already implemented through the staged C1 FUND admin surface. C2 dashboard work must not start until Project visibility and organiser access are modelled explicitly.

This slice is planning only. It does not edit application code, Prisma schema, migrations, routers, services, Zod schemas or tRPC endpoints.

## 1.1 Current Runway / Outstanding Issue Note

Current release and remediation state:

```text
main/dev released baseline: 62b727e chore(release): promote FUND C1 admin foundation
staging remediation baseline: 90325c1 fix(fund): close c1 admin remediation review fixes
```

The 1P-R1/1P-R1A C1 admin remediation batch has passed static/code review and automated checks, and has been pushed to staging. An authenticated browser spot-check remains outstanding before promoting that remediation to main/dev.

Outstanding spot-check areas:

- #46 Project/Event close-date constraint.
- #50 Issue Manager module filtering and server render stability.
- #47 Project Product activation gate visibility.
- #44 breadcrumbs on FUND C1 admin pages.
- #45 sidebar/navigation icon specificity.
- 1P-R1A dashboard card, colour semantics, table sorting and Issue Manager module-field consistency.

This does not block C2 access-model planning. It should block C2 schema/API/UI implementation promotion until the staged remediation has been accepted or deliberately carried forward as known low-risk.

## 2. Recommended Model

Recommended future model:

```text
IsoStack User for authentication
+ FundProjectParticipant for Project access
+ optional future FundOrganiserProfile for reusable organiser identity/contact history
```

This gives FUND safe Project-level visibility without confusing:

- contact details;
- invitation targets;
- authentication;
- reusable organiser identity;
- Project access permissions.

The key decision is that C2 access must not be derived from `FundProject.organiserEmail` or any other free-text snapshot field.

## 3. Is A C2 Organiser A User, Organiser Profile, Participant Or Hybrid?

### IsoStack User

A C2 organiser should be an IsoStack `User` when they authenticate.

Authentication, sessions, password/magic-link/WebAuthn support and account status should remain platform concerns.

Limit:

- current `User` has one `organizationId`;
- `User` alone cannot model Project-specific access;
- `User` alone does not support multiple organisers on a Project cleanly.

### FUND Organiser Profile

A future `FundOrganiserProfile` may be useful for reusable organiser identity and contact history.

Potential use cases:

- one organiser starts multiple Projects over time;
- organiser details need history independent of a single Project;
- Project Request/onboarding begins before account creation;
- C1 wants a directory of organisers.

Recommendation:

- defer `FundOrganiserProfile` until after Project participant access is implemented and C2 dashboard requirements are better proven.

### Project Participant / Access Record

A Project participant/access record is required for safe C2 visibility.

Recommended model name:

```text
FundProjectParticipant
```

This should be the Phase 1 access model for C2 dashboard work.

### Hybrid Verdict

Use the hybrid approach:

- `User` authenticates;
- `FundProjectParticipant` authorises access to one Project;
- optional future `FundOrganiserProfile` can connect multiple Projects, invitations and contact history later.

## 4. Recommended `FundProjectParticipant` Model

Future schema planning should consider a model shaped like:

```prisma
model FundProjectParticipant {
  id             String @id @default(uuid())
  organizationId String @map("organization_id")

  projectId String      @map("project_id")
  project   FundProject @relation(fields: [organizationId, projectId], references: [organizationId, id], onDelete: Cascade)

  userId String? @map("user_id")
  user   User?   @relation(fields: [userId], references: [id], onDelete: SetNull)

  email String
  name  String?
  phone String?

  role   FundProjectParticipantRole   @default(PRIMARY_ORGANISER)
  status FundProjectParticipantStatus @default(INVITED)

  isPrimary Boolean @default(false) @map("is_primary")

  invitedAt  DateTime? @map("invited_at")
  acceptedAt DateTime? @map("accepted_at")
  disabledAt DateTime? @map("disabled_at")
  removedAt  DateTime? @map("removed_at")

  createdById String? @map("created_by_id")
  updatedById String? @map("updated_by_id")
  createdAt   DateTime @default(now()) @map("created_at")
  updatedAt   DateTime @updatedAt @map("updated_at")

  organization Organization @relation(fields: [organizationId], references: [id], onDelete: Cascade)

  @@unique([organizationId, projectId, userId])
  @@index([organizationId, projectId, status])
  @@index([organizationId, userId, status])
  @@index([organizationId, email, status])
  @@map("fund_project_participants")
  @@schema("fund")
}
```

This is illustrative, not approved schema. It should be reviewed in the next schema-only slice.

## 5. Tenant Scoping And Same-Tenant Constraints

All participant records must include required `organizationId`.

Required rules:

- participant `organizationId` must match Project `organizationId`;
- user access must be evaluated in the same C1 tenant context;
- Project queries for C2 must filter by both `organizationId` and participant membership;
- cross-tenant Project ids must not leak details;
- C1 admin users may manage participant records for their tenant only;
- C2 users must not be able to grant themselves access to Projects.

Important current constraint:

- `User.organizationId` is single-tenant today.
- If C2 organisers must use one account across multiple C1 tenants, IsoStack will need a broader user membership model later.

Phase 1 recommendation:

- assume C2 user account belongs to one C1 tenant;
- record multi-C1 organiser support as deferred.

## 6. Nullable `userId` For Pending Invites

Recommendation:

```text
Allow userId to be nullable.
```

Reason:

- C1 may know organiser email before the organiser has an account;
- future Project Request/onboarding may create a Project participant before user provisioning;
- invitation lifecycle can link `userId` when accepted.

However, first C2 dashboard implementation should only grant access where:

```text
participant.userId = currentUser.id
participant.status = ACTIVE
participant.organizationId = current tenant
```

Pending email-only participants should not grant dashboard access until linked to an authenticated user.

For least-privilege schema defaults, `FundProjectParticipant.status` should default to `INVITED`. Later services must explicitly set or transition a participant to `ACTIVE` before it grants C2 dashboard access.

## 7. Role And Status Enum Strategy

### Participant Roles

Recommended initial enum:

```text
PRIMARY_ORGANISER
COLLABORATOR
VIEWER
```

Suggested meaning:

- `PRIMARY_ORGANISER`: main responsible organiser for the Project.
- `COLLABORATOR`: can help operate the Project later.
- `VIEWER`: read-only access.

Do not over-model permissions before the dashboard exists.

### Participant Statuses

Recommended initial enum:

```text
INVITED
ACTIVE
DISABLED
REMOVED
```

Suggested meaning:

- `INVITED`: pending invite/onboarding, no dashboard access unless explicitly approved later.
- `ACTIVE`: dashboard access allowed.
- `DISABLED`: temporarily blocked.
- `REMOVED`: historical record retained, no access.

For the first read-only dashboard, only `ACTIVE` should grant access.

## 8. One User Managing Multiple Projects

Yes, the model should support one C2 user managing multiple Projects.

Example:

- a school business manager runs Christmas and Leavers Projects;
- an organiser repeats annually;
- one PTA contact manages several fundraiser Projects.

`FundProjectParticipant` supports this through multiple participant rows with the same `userId` and different `projectId`.

## 9. One Project With Multiple Users

Yes, the model should support multiple C2 users per Project.

Example:

- primary school contact;
- deputy organiser;
- finance/contact viewer;
- PTA helper.

`isPrimary` plus role/status is enough for Phase 1 planning.

Open decision:

- whether to enforce only one primary active organiser per Project at DB level or service level.

Recommendation:

- enforce one active primary organiser per Project at service level first;
- use database uniqueness later only if partial unique indexes are acceptable in the migration style.

## 10. Can One User Belong To Multiple C1 Tenants?

Under the current schema, probably not cleanly.

Current `User` has one `organizationId`.

Implications:

- one login belongs to one tenant context;
- multi-C1 organiser access would require a future user-membership/account-scope model;
- a short-term workaround is separate user accounts per C1 tenant.

Recommendation for Phase 1:

- keep C2 access within one C1 tenant per user account;
- document multi-C1 organiser access as future IsoStack identity architecture, not FUND Phase 1.

## 11. Relationship To Existing Organiser Snapshot Fields

Current `FundProject` fields:

- `organiserName`;
- `organiserEmail`;
- `organiserPhone`.

These should remain Project contact snapshots.

They may be used for:

- display in C1 admin screens;
- defaulting participant invite fields;
- printing/exporting contact details;
- historical preservation if participant/user details change.

They must not be used for:

- authentication;
- Project visibility;
- C2 route access;
- permission decisions.

Future service behaviour may optionally sync from primary participant to Project snapshot, but that should be explicit and auditable.

## 12. C1 Assignment Flow

Recommended future C1 assignment flow:

1. C1 admin opens Project child page.
2. C1 admin adds organiser email/name/role to Project participants.
3. System creates `FundProjectParticipant` with `INVITED` or `ACTIVE` depending whether a linked user already exists and chosen flow.
4. If user exists in the same tenant, C1 may activate/link access.
5. If user does not exist, future invitation/onboarding flow sends invite and links user on acceptance.

For the first schema slice, do not implement invitations.

For the first C2 read-only dashboard, access should require an already linked `ACTIVE` participant with `userId`.

## 13. Future Invitation / Onboarding Compatibility

The participant model should support future flows without implementing them now.

Future flows:

- C1 creates participant and sends invitation;
- unknown organiser starts Project Request/onboarding;
- onboarding creates or links User;
- onboarding associates User with C1 tenant;
- accepted invitation activates participant access;
- organiser lands on C2 dashboard.

Fields that preserve compatibility:

- nullable `userId`;
- email snapshot;
- status enum;
- invited/accepted timestamps;
- createdBy/updatedBy audit fields.

Do not implement invitation sending or Project Request in this access-model slice.

## 14. C2 Read-Only Dashboard Implications

The first C2 dashboard should use participant-scoped read endpoints.

Potential future endpoint shape:

```text
fund.organiser.projects.listAssigned
fund.organiser.projects.getAssigned
```

or:

```text
fund.c2.projects.list
fund.c2.projects.get
```

Recommendation:

- use `organiser` in route/UI language;
- use explicit server-side participant scoping;
- keep C2 endpoints separate from C1 admin Project endpoints.

First C2 dashboard should be read-only:

- list assigned Projects;
- view Project details;
- view selected Products;
- view Event/date context;
- view status/lifecycle;
- view next-step placeholders.

Do not add C2 mutations until the participant model and dashboard are reviewed.

## 15. Audit Events

Future participant schema/services should plan audit events:

```text
FUND_PROJECT_PARTICIPANT_ADDED
FUND_PROJECT_PARTICIPANT_UPDATED
FUND_PROJECT_PARTICIPANT_ACTIVATED
FUND_PROJECT_PARTICIPANT_DISABLED
FUND_PROJECT_PARTICIPANT_REMOVED
FUND_PROJECT_PARTICIPANT_PRIMARY_CHANGED
FUND_PROJECT_PARTICIPANT_USER_LINKED
FUND_PROJECT_PARTICIPANT_INVITED
FUND_PROJECT_PARTICIPANT_INVITE_ACCEPTED
```

First schema-only slice may only document these. Service/API slice should implement them.

Audit metadata should include:

- projectId;
- participantId;
- userId where present;
- email snapshot;
- role;
- status;
- previous/new values for role/status/primary changes.

## 16. Required Indexes And Uniqueness Constraints

Recommended indexes:

- `[organizationId, projectId, status]` for Project participant lists;
- `[organizationId, userId, status]` for assigned Project lookup;
- `[organizationId, email, status]` for invite/lookup;
- `[organizationId, projectId, userId]` unique where feasible;
- `[organizationId, projectId, email]` possibly unique for pending invite dedupe.

Open constraint question:

- Prisma/Postgres partial unique index for one active primary participant per Project may require hand-written SQL.

Recommendation:

- avoid partial unique index in the first schema slice unless clearly required;
- enforce primary participant uniqueness in service logic initially.

## 17. Migration Risks

Risks:

- adding relation from `User` to fund schema may require careful Prisma relation naming;
- nullable `userId` plus uniqueness can behave differently across databases because multiple nulls are allowed;
- partial unique indexes may require raw SQL and careful rollback planning;
- multi-tenant organiser requirements may later exceed current `User.organizationId` model;
- overloading participant with invitation logic too early could make future Project Request harder.

Mitigations:

- keep schema minimal;
- avoid invitation implementation in schema slice;
- document nullable `userId` clearly;
- use service-layer validation for complex uniqueness;
- add confirmation docs and migration review before API/UI work.

## 18. Open Decisions Before Schema Implementation

Before implementing `FundProjectParticipant`, decide:

1. Exact model name: `FundProjectParticipant` recommended.
2. Exact enum names and values.
3. Whether `email` is required when `userId` is null.
4. Whether `name` and `phone` are snapshots on participant.
5. Whether participant role should start with only `PRIMARY_ORGANISER` and `VIEWER`, or include `COLLABORATOR` now.
6. Whether `INVITED` exists before invitation implementation.
7. Whether one active primary organiser should be DB-enforced or service-enforced.
8. Whether participant rows are soft-removed (`REMOVED`) rather than hard deleted.
9. Whether C1 admin can add participants before Project is ACTIVE.
10. Whether C2 can see DRAFT Projects assigned to them.
11. Whether C2 can see CLOSED/COMPLETED/ARCHIVED Projects historically.
12. Whether future `FundOrganiserProfile` needs to be planned now or explicitly deferred.

## 19. Recommended Schema-Only Implementation Prompt

```text
Proceed with FUND Phase 1 Slice 1P-B planning/implementation for C2 Project Participant Schema only.

Work on:
feature/fund-phase-1-c2-project-access

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-24-fund-phase-1-slice-1p-a-c2-project-access-model-proposal.md
- isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md
- active FUND docs in isodocs/docs/modules/fund/
- current Prisma schema conventions
- current FundProject schema
- current User and Organization relation patterns

Scope:
- add FundProjectParticipantRole enum;
- add FundProjectParticipantStatus enum;
- add FundProjectParticipant model;
- add required Organization relation;
- add FundProject relation using organizationId/projectId same-tenant constraint;
- add optional User relation only if it follows existing Prisma relation conventions cleanly;
- add indexes and uniqueness constraints;
- create migration;
- create implementation confirmation document.

Do not create routers, services, Zod schemas, tRPC endpoints or UI.
Do not implement C2 dashboard.
Do not implement invitations.
Do not implement Project Request/onboarding.
Do not implement Store, Order, Commerce Core, payments, commissions, production batching, lifecycle engine or AI workflows.
Do not run db:push.
Do not run seed/reset commands.

Important:
- FundProjectParticipant grants access only when linked to userId and status ACTIVE in later services.
- Do not implement any runtime access checks in this schema-only slice.
- Document that later C2 access must require:
  - participant.organizationId = current tenant;
  - participant.userId = currentUser.id;
  - participant.status = ACTIVE.
- Existing FundProject organiserName/email/phone remain snapshots and must not grant access.
- Keep multi-C1 organiser access deferred unless explicitly approved.
- If optional User relation naming becomes ambiguous, stop and report the required relation-name options rather than improvising.

Run:
- npx prisma validate
- npm run db:generate
- npm run type-check
- npm run verify

Create confirmation document:
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-b-c2-project-participant-schema-confirmation.md

Planning/schema only. Do not implement C2 dashboard.
```

## 20. Recommendation

Proceed to a schema-only planning/implementation slice for `FundProjectParticipant`, not directly to C2 dashboard UI.

The safe order is:

```text
1P-B - C2 Project Participant Schema
1P-C - C2 read-only API/services
1P-D - C2 read-only organiser dashboard UI
1P-E - C2 dashboard review/manual testing
1Q - Event/Catalogue/Product availability and workflow suitability planning
```

This preserves the C1/C2 boundary and prevents organiser snapshot fields from becoming accidental permissions.
