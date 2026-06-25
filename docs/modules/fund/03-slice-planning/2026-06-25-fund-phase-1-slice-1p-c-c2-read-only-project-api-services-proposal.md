# FUND Phase 1 Slice 1P-C - C2 Read-Only Project API/Services Proposal

Date: 2026-06-25

Status: Planning only / ready for review

Target app branch:

```text
feature/fund-phase-1-c2-project-access
```

## 1. Slice Goal

Plan the read-only C2 Project API/service layer that will later support the organiser dashboard.

This slice should define how authenticated C2 organisers can safely list and view Projects assigned to them through `FundProjectParticipant` records.

The key access rule is:

```text
participant.organizationId = current tenant
participant.userId = currentUser.id
participant.status = ACTIVE
```

C2 access must not be derived from:

- `FundProject.organiserName`;
- `FundProject.organiserEmail`;
- `FundProject.organiserPhone`;
- `FundProjectParticipant.email` without linked `userId`.

## 2. Implementation Boundary

Slice 1P-C should implement read-only API/services only after this plan is reviewed.

It may create:

- organiser-facing tRPC router/service files;
- organiser-facing Zod input schemas;
- participant-scoped read helpers;
- read-only Project list/detail endpoints;
- implementation confirmation document.

It must not create:

- C2 dashboard UI;
- C1 participant management UI;
- participant invitation flows;
- Project Request/onboarding;
- C2 mutations;
- Store schema;
- Orders;
- Commerce Core;
- payments;
- commissions;
- production batching;
- lifecycle engine;
- Event/Catalogue/Product availability changes;
- workflow suitability changes;
- Prisma schema changes or migrations unless a blocker is discovered and explained first.

## 3. Recommended Naming Convention

Use organiser-facing language rather than generic `c2` naming in public router shape.

Recommended route group:

```text
fund.organiser.projects.list
fund.organiser.projects.get
```

Recommended files:

```text
src/modules/fund/routers/organiser.router.ts
src/modules/fund/routers/organiser-projects.router.ts
src/modules/fund/services/organiser-projects.service.ts
src/modules/fund/lib/validation/organiser-projects.ts
```

Alternative acceptable shape:

```text
fund.organiserProjects.list
fund.organiserProjects.get
```

Recommendation: prefer nested `fund.organiser.projects.*` if it fits current router composition cleanly, because later organiser dashboard endpoints may include tasks, submissions, communications or store summaries.

## 4. Router Design

Add an organiser router under the existing FUND router:

```text
fund.organiser.projects.list
fund.organiser.projects.get
```

Both procedures should use `withFeature('fund')` and authenticated context.

Do not call `assertFundAdmin` for organiser endpoints. C2 organiser access is participant-scoped, not admin-role-scoped.

Router responsibilities:

- get current authenticated user id;
- derive current tenant context using existing `ctx.effectiveOrgId` / user organization convention;
- pass actor to organiser services;
- surface shaped tRPC errors from services.

## 5. Service Design

Create a dedicated organiser Project service rather than reusing C1 `listProjects` / `getProject` directly.

Reason:

- C1 Project services are tenant-admin scoped;
- C2 Project services must be participant scoped;
- safe payloads differ from C1 admin payloads;
- future C2 dashboard changes should not loosen C1 admin assumptions.

Recommended service functions:

```text
listAssignedOrganiserProjects(prisma, actor, input)
getAssignedOrganiserProject(prisma, actor, id)
```

Recommended actor shape:

```ts
type FundOrganiserActor = {
  userId: string;
  organizationId: string;
};
```

This actor should not include role-based admin permissions for this slice.

## 6. Zod Validation Schemas

Recommended schemas:

```text
organiserProjectListInputSchema
organiserProjectGetInputSchema
```

List input should be intentionally narrow:

- optional `status` filter for display;
- optional `includeArchived` only if needed for historical view;
- optional `search` over safe Project fields;
- no organizationId from client;
- no participant status override from client;
- no arbitrary userId from client.

Get input:

- `id: z.string().uuid()` or current project id pattern used locally.

## 7. Participant-Scoped Access Rules

Every C2 read query must require an active participant join:

```text
FundProjectParticipant.organizationId = actor.organizationId
FundProjectParticipant.userId = actor.userId
FundProjectParticipant.status = ACTIVE
FundProjectParticipant.projectId = FundProject.id
```

Rules:

- never accept `organizationId` from the client;
- never accept `userId` from the client;
- never match by participant email alone;
- never match by Project organiser snapshot fields;
- `INVITED`, `DISABLED` and `REMOVED` participants do not grant access;
- `userId = null` participants do not grant access;
- cross-tenant Project ids should return `NOT_FOUND`, not leaked permission detail.

## 8. Project List Endpoint

Recommended endpoint:

```text
fund.organiser.projects.list
```

Purpose:

- return Projects the current C2 organiser can see;
- support the first read-only organiser dashboard landing page;
- keep payload small and safe.

Suggested list payload fields:

- `id`;
- `projectNumber`;
- `name`;
- `slug`;
- `status`;
- `lifecycleState`;
- `opensAt`;
- `closesAt`;
- `effectiveClosesAt`;
- `productionDeadline`;
- `event` summary if linked;
- participant role/status for the current user;
- active Project Product count;
- basic readiness summary if already available cheaply.

Do not expose:

- C1 internal notes;
- audit metadata;
- other participant details;
- full Product admin metadata;
- tenant-wide Project lists;
- C1-only management fields.

## 9. Project Detail Endpoint

Recommended endpoint:

```text
fund.organiser.projects.get
```

Purpose:

- return a safe read-only Project detail payload for one assigned Project;
- provide data needed by the future C2 Project detail page.

Suggested detail payload fields:

- list payload fields;
- `description` if intended for organiser display;
- organiser snapshot fields only if they are useful as contact/reference display, not permissions;
- linked Event context;
- Project Products using snapshot values;
- status/lifecycle display values;
- date/readiness guidance;
- current participant role/status.

Do not expose:

- `internalNotes`;
- all participants;
- C1 audit/user ids beyond safe display requirements;
- hidden product/catalogue/admin internals;
- C1 admin actions or mutation affordances.

## 10. Event Context Payload

If a Project is linked to a FundEvent, C2 Project reads may expose safe Event context:

- `id`;
- `code`;
- `name`;
- `status`;
- `opensAt`;
- `closesAt`;
- `productionDeadline`.

The UI may later explain that Event `closesAt` is the latest permissible effective Project close date.

If `Project.closesAt` is blank and linked Event `closesAt` exists, the API may include:

```text
effectiveClosesAt = event.closesAt
closeDateSource = EVENT
```

If Project `closesAt` is present:

```text
effectiveClosesAt = project.closesAt
closeDateSource = PROJECT
```

If neither exists:

```text
effectiveClosesAt = null
closeDateSource = NONE
```

Do not copy Event dates into Project fields.

## 11. Project Product Payload

C2 detail should expose Project Product snapshot values, not live editable Product records.

Recommended fields:

- membership id;
- product id for reference only if needed;
- sort order;
- isActive;
- product code snapshot;
- product name snapshot;
- product short description snapshot;
- workflow class code snapshot;
- workflow class name snapshot;
- unit price net snapshot;
- VAT rate snapshot;
- currency snapshot.

Do not expose C1 product admin controls or Product edit surfaces.

Inactive Project Product rows may be included for historical visibility only if the future UI needs them. First implementation can prefer active-only display unless the plan for C2 dashboard requires inactive historical context.

## 12. Status And Lifecycle Visibility

C2 read endpoints may expose status/lifecycle fields as display information:

- `status`;
- `lifecycleState`;
- `opensAt`;
- `closesAt`;
- `effectiveClosesAt`;
- `productionDeadline`.

They must not allow C2 status transitions in this slice.

Questions to carry into dashboard planning:

- Should C2 see DRAFT Projects once assigned?
- Should C2 see CLOSED, COMPLETED or ARCHIVED Projects historically?
- Should archived Projects be hidden by default but accessible if directly linked?

Initial API recommendation:

- return assigned non-archived Projects by default;
- allow `includeArchived` only if the UI needs historical records;
- always require active participant access.

## 13. Error Handling And tRPC Codes

Use shaped tRPC errors consistent with current FUND services.

Recommended codes:

- `UNAUTHORIZED`: no authenticated user;
- `FORBIDDEN`: authenticated but no tenant/user context, or feature access denied;
- `NOT_FOUND`: Project missing or not accessible through active participant;
- `BAD_REQUEST`: invalid input/filter combination;
- `INTERNAL_SERVER_ERROR`: unexpected failure.

For cross-tenant or unassigned Project ids, prefer `NOT_FOUND` so existence is not leaked.

## 14. Feature Gating And Product Access

Use existing `withFeature('fund')` gating.

Open point for implementation review:

- confirm whether C2 organiser users will have FUND product/module access directly, or whether participant access plus tenant FUND feature should be enough.

Safe implementation position for 1P-C:

- require authenticated user;
- require FUND feature gate through existing platform mechanism;
- require active Project participant row;
- do not introduce new product/module entitlement semantics in this slice.

## 15. Tenant Scoping Strategy

Tenant scope must be enforced at every layer:

- actor organization from existing auth/context conventions;
- Project `organizationId` equals actor organization;
- participant `organizationId` equals actor organization;
- participant `userId` equals current user;
- participant status is `ACTIVE`.

Do not allow C2 endpoints to list Projects across tenants.

## 16. Audit Logging Requirements

Read-only endpoints usually should not create AuditLog records.

Do not audit ordinary list/get reads in 1P-C unless there is an existing platform requirement for sensitive-read auditing.

Future C2 mutations should create audit events, but they are out of scope here.

## 17. Manual Test Checklist For Implementation Slice

When 1P-C is implemented, test:

- authenticated active participant can list assigned Projects;
- authenticated active participant can get assigned Project detail;
- participant from another tenant cannot access Project;
- participant with `INVITED` status cannot access Project;
- participant with `DISABLED` status cannot access Project;
- participant with `REMOVED` status cannot access Project;
- participant row with matching email but `userId = null` does not grant access;
- Project organiserEmail matching current user does not grant access without participant;
- C1 admin Project endpoints remain unchanged;
- C2 endpoints expose no mutation procedures;
- response omits `internalNotes` and C1-only admin controls;
- Event effective close date is calculated consistently;
- Project Product snapshot values serialize safely;
- no schema/migration/db push/seed/reset work is introduced.

## 18. Deliberately Out Of Scope

Do not implement in 1P-C:

- C2 dashboard UI;
- C1 participant management UI;
- organiser invitation implementation;
- Project Request/onboarding;
- C2 Project mutations;
- C2 artwork/data/template submission;
- C2 communications;
- Store schema;
- Orders;
- Commerce Core;
- payments;
- commissions;
- production batching;
- lifecycle engine;
- Event/Catalogue/Product availability changes;
- workflow suitability changes;
- `FundOrganiserProfile`;
- multi-C1 organiser identity architecture;
- Prisma schema changes or migrations unless a blocker is found and explained first.

## 19. Risks And Open Questions

Risks:

- accidentally reusing C1 admin services may expose too much data;
- accidentally matching organiser snapshot fields may grant access incorrectly;
- C2 users may not yet have a settled product/module entitlement path;
- archived Project visibility needs a clear UI decision;
- first implementation may need fixtures/manual participant creation until C1 participant management exists.

Open questions:

- Should C2 users see DRAFT Projects immediately after assignment?
- Should C2 list show CLOSED/COMPLETED Projects by default?
- Should inactive Project Products be visible to C2 as history?
- How will test participants be created before C1 participant management UI exists?
- Does organiser dashboard access require additional ModuleRole modelling beyond FUND feature access and participant rows?

None of these block planning. They should be answered or explicitly defaulted in the implementation prompt.

## 20. Recommended Implementation Prompt

```text
Proceed with FUND Phase 1 Slice 1P-C implementation: C2 Read-Only Project API/Services.

Work on:
feature/fund-phase-1-c2-project-access

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-c-c2-read-only-project-api-services-proposal.md
- isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-b-c2-project-participant-schema-confirmation.md
- isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md
- current FUND router/service/Zod conventions
- current tenant/auth/feature-gating conventions

Implement read-only C2 organiser Project API/services only.

Create organiser-facing endpoints, preferably:
- fund.organiser.projects.list
- fund.organiser.projects.get

Required access rule:
C2 Project access must require:
- participant.organizationId = current tenant;
- participant.userId = currentUser.id;
- participant.status = ACTIVE.

Do not derive access from:
- organiserName;
- organiserEmail;
- organiserPhone;
- participant.email without linked userId.

Payload rules:
- list returns safe assigned Project summaries only;
- get returns safe assigned Project detail only;
- include linked Event context where present;
- include Project Product snapshot values where appropriate;
- include effective close date and source if straightforward;
- omit internalNotes and C1-only admin/control data.

Do not implement:
- dashboard UI;
- C1 participant management UI;
- invitations;
- Project Request/onboarding;
- C2 mutations;
- Store, Orders or Commerce Core;
- Event/Catalogue/Product availability changes;
- workflow suitability changes;
- Prisma schema changes or migrations unless a genuine blocker is found and explained first.

Run:
- npm run type-check
- npm run verify
- git diff --check

Create implementation confirmation document:
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-c-c2-read-only-project-api-services-confirmation.md

The confirmation should include:
- endpoints created;
- files changed;
- participant access rule implementation;
- payload summary;
- Event/effective close-date handling;
- Project Product snapshot handling;
- explicit non-goals;
- checks run and results;
- manual test checklist;
- recommended next slice.
```

## 21. Recommendation

Review this plan before implementation.

Recommended next controlled sequence:

```text
1P-C - C2 Read-Only Project API/Services
1P-D - C2 Read-Only Organiser Dashboard UI
1P-E - C2 Dashboard Review/Manual Testing
1Q - Event/Catalogue/Product Availability And Workflow Suitability Planning
```

Do not start C2 dashboard UI until the participant-scoped read endpoints are implemented and reviewed.
