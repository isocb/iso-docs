# FUND Phase 1 Slice 1P-C - C2 Read-Only Project API/Services Confirmation

Date: 2026-06-25

## 1. Slice Name

Phase 1 Slice 1P-C - C2 Read-Only Project API/Services

## 2. Implementation Summary

Implemented the read-only organiser-facing Project API/service layer for future C2 dashboard work.

The new API shape is:

```text
fund.organiser.projects.list
fund.organiser.projects.get
```

The endpoints are read-only and participant-scoped. They do not grant access from Project organiser snapshot fields or participant email alone.

## 3. Files Changed

App repo:

- `src/modules/fund/lib/validation/organiser-projects.ts`
- `src/modules/fund/services/organiser-projects.service.ts`
- `src/modules/fund/routers/organiser-projects.router.ts`
- `src/modules/fund/routers/organiser.router.ts`
- `src/modules/fund/routers/index.ts`

Docs repo:

- `docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-c-c2-read-only-project-api-services-confirmation.md`

## 4. Router / Service / Zod Structure

Created organiser-specific validation schemas:

- `organiserProjectListInputSchema`
- `organiserProjectGetInputSchema`

Created organiser-specific services:

- `listAssignedOrganiserProjects`
- `getAssignedOrganiserProject`

Created organiser routers:

- `organiserProjectsRouter`
- `organiserRouter`

Wired the organiser router into the existing FUND router under:

```text
fund.organiser.projects
```

## 5. Endpoints Created

```text
fund.organiser.projects.list
fund.organiser.projects.get
```

Both endpoints use the existing FUND feature gate via `withFeature('fund')`.

Neither endpoint calls `assertFundAdmin`, because organiser access is participant-scoped rather than C1 admin-role-scoped.

## 6. Participant Access Rule Implementation

Every C2 organiser Project read requires an active participant row matching the current authenticated user and tenant:

```text
participant.organizationId = current tenant
participant.userId = currentUser.id
participant.status = ACTIVE
participant.projectId = project.id
```

Implementation details:

- `organizationId` is derived from the authenticated/effective tenant context.
- `userId` is derived from the authenticated/effective user context.
- Neither `organizationId` nor `userId` is accepted from client input.
- Project list queries filter through `FundProject.participants.some(...)`.
- Project detail queries return `NOT_FOUND` when the Project is missing, cross-tenant or unassigned.

## 7. Snapshot Fields And Email Access Boundary

Confirmed:

- `FundProject.organiserName` does not grant access.
- `FundProject.organiserEmail` does not grant access.
- `FundProject.organiserPhone` does not grant access.
- `FundProjectParticipant.email` without matching linked `userId` does not grant access.
- `INVITED`, `DISABLED` and `REMOVED` participants do not grant access.
- `userId = null` participants do not grant access.

The detail payload may display organiser snapshot fields as Project contact/context data, but those fields are not used for authorization.

## 8. List Payload Summary

`fund.organiser.projects.list` returns safe assigned Project summaries only.

Included fields:

- Project id, number, name and slug;
- Project status and lifecycle state;
- Project open/close/production dates;
- effective close date and close-date source;
- safe linked Event summary where present;
- current participant role/status/isPrimary;
- active Project Product count.

Omitted fields:

- internal notes;
- all participant lists;
- audit metadata;
- C1 admin controls;
- mutation affordances;
- tenant-wide Project visibility.

## 9. Detail Payload Summary

`fund.organiser.projects.get` returns one assigned Project only.

Included fields:

- safe Project detail fields;
- description;
- organiser snapshot fields for contact/context display only;
- safe linked Event summary;
- current participant role/status/isPrimary;
- active Project Product count;
- active Project Product snapshot rows.

Omitted fields:

- `internalNotes`;
- all participant lists;
- audit metadata;
- C1 admin controls;
- mutation affordances;
- live editable Product admin records.

## 10. Event / Effective Close-Date Handling

The organiser service computes:

```text
effectiveClosesAt
closeDateSource
```

Rules:

- if `FundProject.closesAt` exists, `closeDateSource = PROJECT`;
- if Project `closesAt` is blank and linked Event `closesAt` exists, `closeDateSource = EVENT`;
- if neither exists, `closeDateSource = NONE`.

The implementation does not copy Event dates into Project fields.

## 11. Project Product Snapshot Handling

Project detail exposes active Project Product snapshot rows only.

Included snapshot fields:

- membership id;
- product id reference;
- workflow class id reference;
- sort order;
- active flag;
- product code snapshot;
- product name snapshot;
- product short description snapshot;
- workflow class code snapshot;
- workflow class name snapshot;
- unit price net snapshot;
- VAT rate snapshot;
- currency snapshot.

Decimal snapshot fields are serialised as API-safe numbers or null.

## 12. Feature / Auth Gating Approach

The endpoints require:

- authenticated session via existing protected tRPC/feature middleware;
- existing FUND feature gate through `withFeature('fund')`;
- current tenant context;
- active Project participant matching the current user.

This slice does not introduce new product/module entitlement semantics.

## 13. Explicit Non-Goals

This slice did not implement:

- C2 dashboard UI;
- C1 participant management UI;
- organiser invitations;
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
- `FundOrganiserProfile`;
- multi-C1 organiser identity architecture;
- Prisma schema changes;
- migrations;
- `db:push`;
- seed/reset commands.

## 14. Checks Run

- `npm run type-check` - passed.
- `git diff --check` - passed.
- `npm run verify` - first sandboxed run failed because `tsx` could not create its local IPC pipe; rerun with approved escalation passed.

## 15. Manual Test Checklist

For API/service review:

- ACTIVE participant can list assigned Projects.
- ACTIVE participant can get assigned Project detail.
- INVITED participant cannot access.
- DISABLED participant cannot access.
- REMOVED participant cannot access.
- Participant with `userId = null` cannot access.
- Matching Project `organiserEmail` alone does not grant access.
- Cross-tenant Project id returns `NOT_FOUND`.
- Unassigned Project id returns `NOT_FOUND`.
- C1 admin Project endpoints remain unchanged.
- C2 endpoints expose no mutations.
- `internalNotes` and C1-only admin/control data are omitted.
- Event effective close date is calculated consistently.
- Project Product snapshot values serialise safely.
- No schema/migration/db push/seed/reset work was introduced.

## 16. Risks / Follow-Ups

- Manual API testing needs suitable participant rows in the target environment.
- C1 participant management UI is still needed before non-technical users can assign organisers.
- C2 dashboard UI should remain read-only until participant-scoped reads are reviewed.
- Archived Project visibility should be confirmed in the first C2 dashboard UI plan.
- Future C2 mutations must add audit logging and more granular permission checks.

## 17. Recommended Next Slice

Recommended next slice:

```text
Phase 1 Slice 1P-D - C2 Read-Only Organiser Dashboard UI Planning
```

Before implementing 1P-D, review 1P-C API behaviour with seeded/manual participant rows.
