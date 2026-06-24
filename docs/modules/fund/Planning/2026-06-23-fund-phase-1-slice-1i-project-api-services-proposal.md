# FUND Phase 1 Slice 1I - Project API And Services Proposal

Date: 2026-06-23

Status: Planning only

Target branch:

```text
feature/fund-phase-1-products-catalogues
```

## Source Context

This proposal uses:

- `implementation/2026-06-23-phase-1-slice-1h-project-schema-confirmation.md`
- active FUND docs in `isodocs/docs/modules/fund/`
- Slice 1C, 1D, 1E, 1F-A and 1F-B confirmation documents
- current IsoStack tRPC, Zod, Prisma, audit logging and feature-gating patterns

Existing schema from Slice 1H:

- `FundProjectStatus`
- `FundProject`
- `FundProjectProduct`

## 1. Slice Goal

Slice 1I should plan the Project API and service layer.

The goal is to make Projects usable through tenant-safe tRPC procedures while preserving the core FUND architecture:

```text
Project is the mandatory operational entity.
Products and Catalogues support Projects.
Stores, Orders and commerce remain later layers.
```

This slice should plan service behaviour only. UI remains out of scope.

## 2. Implementation Boundary

Allowed in Slice 1I implementation:

- Project Zod validation schemas;
- Project service functions;
- Project Product selection service functions;
- Project tRPC router;
- router registration under `fund.projects`;
- audit logging for meaningful Project mutations;
- Decimal serialization for Project Product snapshot fields;
- tenant-scoped reads and writes;
- status transition methods.

Not allowed:

- Prisma schema edits;
- migrations;
- `db:push`;
- seed/reset commands;
- UI;
- Events;
- Stores;
- Orders;
- commerce;
- payments;
- commissions;
- dashboards;
- production batching;
- SeasonPro integration;
- marketplace exposure;
- media or asset workflows;
- AI workflows;
- lifecycle tables;
- lifecycle transition engine.

## 3. Project Router Design

Recommended router file:

```text
src/modules/fund/routers/projects.router.ts
```

Register in:

```text
src/modules/fund/routers/index.ts
```

Router namespace:

```text
fund.projects
```

Recommended procedures:

- `fund.projects.list`
- `fund.projects.get`
- `fund.projects.create`
- `fund.projects.update`
- `fund.projects.activate`
- `fund.projects.pause`
- `fund.projects.close`
- `fund.projects.complete`
- `fund.projects.archive`
- `fund.projects.restore`
- `fund.projects.addProduct`
- `fund.projects.removeProduct`
- `fund.projects.setProductActive`
- `fund.projects.reorderProducts`

All procedures should use:

```ts
withFeature('fund')
```

Mutation procedures should require the same management role strategy currently used by Products/Catalogues:

- `OWNER`; or
- `ADMIN`.

## 4. Project Service Design

Recommended service file:

```text
src/modules/fund/services/projects.service.ts
```

Recommended responsibilities:

- resolve Project records by tenant;
- build Project list filters;
- create Projects in `DRAFT`;
- update Project descriptive/contact/date fields;
- enforce status transitions;
- add/remove/reactivate/reorder Project Products;
- populate Project Product snapshots;
- serialize Decimal snapshot fields;
- write audit logs;
- map Prisma uniqueness races to `CONFLICT`;
- reject cross-tenant Product selection.

Follow the Product/Catalogue service pattern:

- actor object with `userId`, `organizationId`, `role`;
- service functions accept `prisma`, `actor`, and validated input;
- never accept client-provided `organizationId`.

## 5. Zod Validation Schemas

Recommended validation file:

```text
src/modules/fund/lib/validation/projects.ts
```

Alternatively, if keeping the slice small:

```text
src/modules/fund/lib/validation/products-catalogues.ts
```

Recommendation: create `projects.ts` to avoid overloading the Products/Catalogues validation file.

Recommended shared validators:

- project number: required, trimmed, max 64;
- name: reuse `fundNameSchema`;
- slug: reuse `fundSlugSchema`;
- optional text: max 5000 for descriptions/internal notes;
- organiser email: optional email, max 320;
- organiser phone: optional string, max 80;
- date fields: `z.coerce.date().nullable().optional()` or ISO string validation matching repo conventions;
- archive reason: reuse existing archive schema;
- Product/Project membership ids: UUID strings;
- reorder membership ids: non-empty UUID array.

Recommended schemas:

- `projectListInputSchema`
- `projectGetInputSchema`
- `projectCreateInputSchema`
- `projectUpdateInputSchema`
- `projectStatusInputSchema`
- `projectArchiveInputSchema`
- `addProjectProductInputSchema`
- `projectProductInputSchema`
- `reorderProjectProductsInputSchema`
- `setProjectProductActiveInputSchema`

## 6. Tenant Scoping Strategy

Rules:

- never accept `organizationId` from client input;
- derive actor organization from session/effective context;
- all Project reads must filter by `organizationId`;
- all Project writes must filter by `organizationId`;
- all Project Product membership writes must validate Project belongs to actor tenant;
- Product selection must validate Product belongs to actor tenant;
- Project Product reorder must validate every membership belongs to the current Project and tenant.

Database support from Slice 1H:

- `FundProject.organizationId` required;
- `FundProjectProduct.organizationId` required;
- composite same-tenant Project/Product foreign keys.

Application-level checks remain required even with database constraints.

## 7. Access Control And FUND Feature Gating

All procedures:

- require authentication;
- require active FUND feature access with `withFeature('fund')`.

Reads:

- permitted for authenticated users with FUND access, following Product/Catalogue list/get precedent.

Mutations:

- require `OWNER` or `ADMIN` using the current `assertFundAdmin` helper, or a renamed shared helper such as `assertFundManager`.

Future:

- FUND-specific module roles can replace or refine this later.

Do not introduce module-role schema or assignment changes in Slice 1I.

## 8. Project List / Get / Create / Update Procedures

### `list`

Input filters:

- `status?`
- `search?`
- `includeArchived?`
- `lifecycleState?`
- optional date windows later.

Default:

- exclude archived Projects unless `status = ARCHIVED` or `includeArchived = true`.

Include:

- `_count.projectProducts` filtered to active rows;
- consider including no heavy child data in list.

Sort:

- `projectNumber` or `createdAt` depending on service convention;
- recommend `projectNumber asc` for operational scanning.

### `get`

Input:

- `id`.

Include:

- Project Products ordered by `sortOrder`, then `addedAt`;
- Product reference;
- Workflow Class reference;
- snapshots.

Return:

- API-safe Project detail object;
- Decimal snapshots serialized to numbers/null.

### `create`

Input:

- `projectNumber`;
- `name`;
- `slug`;
- optional description;
- optional organiser contact fields;
- optional opensAt;
- nullable/optional closesAt;
- optional productionDeadline;
- optional internalNotes;
- optional metadata.

Rules:

- server sets `organizationId`;
- server sets `status = DRAFT`;
- server sets `lifecycleState = SETUP` unless a future explicit setup state is allowed;
- validate tenant-unique project number and slug;
- catch Prisma `P2002` race and return `CONFLICT`.

### `update`

Input:

- `id`;
- same editable descriptive/contact/date fields as create;
- no status field.

Rules:

- General update must not directly mutate status.
- General update may update `lifecycleState` only if approved. Recommendation: do not allow direct lifecycleState update in Slice 1I; keep it controlled by future lifecycle transitions.
- Validate uniqueness for project number and slug excluding current Project.
- Audit organiser/date changes separately where useful.

## 9. Status Procedures

Dedicated procedures:

- `activate`
- `pause`
- `close`
- `complete`
- `archive`
- `restore`

General rules:

- status transitions must not be performed by `update`;
- transitions write audit logs;
- transitions clear/set archive metadata where appropriate;
- archived Projects should reject Product membership mutation.

### `activate`

Requirements:

- Project exists in actor tenant;
- Project is not archived;
- `name`, `projectNumber` and `slug` present;
- `closesAt` present;
- at least one active Project Product exists;
- all active Project Products reference non-archived Products;
- workflow class references remain active where possible.

Sets:

- `status = ACTIVE`;
- `lifecycleState` remains existing value or becomes an agreed value such as `ACTIVE`. Recommendation: keep `lifecycleState` unchanged in Slice 1I unless explicitly required.

### `pause`

Allowed from:

- `ACTIVE`.

Sets:

- `status = PAUSED`.

### `close`

Allowed from:

- `ACTIVE`;
- `PAUSED`.

Sets:

- `status = CLOSED`.

### `complete`

Allowed from:

- `CLOSED`.

Sets:

- `status = COMPLETED`.

Implementation note:

- this procedure must use the Slice 1H enum value `COMPLETED`; do not mark completion by leaving the Project in `CLOSED` or by only changing lifecycle metadata.

### `archive`

Allowed from:

- any non-archived status.

Sets:

- `status = ARCHIVED`;
- archive metadata.

Does not hard delete.

### `restore`

Recommended behaviour:

- restore to `DRAFT`;
- clear archive metadata;
- require explicit activation again.

Alternative:

- restore previous status. Not recommended in Slice 1I because previous status is not currently captured.

## 10. Project Product Selection Procedures

Recommended procedures:

- `addProduct`
- `removeProduct`
- `setProductActive`
- `reorderProducts`

### `addProduct`

Input:

- `projectId`;
- `productId`;
- optional `sortOrder`.

Rules:

- Project belongs to current tenant;
- Project Product membership changes are allowed only while the Project is `DRAFT`, `ACTIVE` or `PAUSED`;
- Project Product membership changes are rejected after the Project is `CLOSED`, `COMPLETED` or `ARCHIVED`;
- Product belongs to current tenant;
- Product is not archived;
- Product has active Workflow Class;
- if active membership already exists, return `CONFLICT`;
- if inactive membership exists, reactivate or return `CONFLICT` depending on desired UX.

Recommendation:

- mirror Catalogue behaviour and reactivate inactive existing membership.
- when reactivating an inactive Project Product membership, refresh snapshot fields from the current Product and Workflow Class so the Project reflects current selection-time product data.

### `removeProduct`

Input:

- `projectId`;
- `productId`.

Rules:

- Project belongs to tenant;
- Project Product membership changes are allowed only while the Project is `DRAFT`, `ACTIVE` or `PAUSED`;
- Product belongs to tenant;
- membership exists;
- set `isActive = false`;
- do not hard delete.

### `setProductActive`

Input:

- membership `id`;
- `isActive`.

Rules:

- membership belongs to current tenant;
- Project Product membership changes are allowed only while the Project is `DRAFT`, `ACTIVE` or `PAUSED`;
- if reactivating, Product must not be archived;
- if reactivating, Workflow Class should still be active.
- if reactivating, refresh Product and Workflow Class snapshot fields from the current Product.

### `reorderProducts`

Input:

- `projectId`;
- `membershipIds`.

Rules:

- Project belongs to current tenant;
- Project Product membership changes are allowed only while the Project is `DRAFT`, `ACTIVE` or `PAUSED`;
- membership ids must belong to current Project and tenant;
- reorder must include all current Project Product membership ids unless a partial reorder rule is explicitly approved;
- write audit log with previous/new sort order.

## 11. Product Snapshot Population Strategy

On `addProduct`, load Product with Workflow Class:

- Product code;
- Product name;
- Product short description;
- Product unit price net;
- Product VAT rate;
- Product currency;
- Workflow Class id;
- Workflow Class code;
- Workflow Class name.

Populate:

- `workflowClassId`;
- `productCodeSnapshot`;
- `productNameSnapshot`;
- `productShortDescriptionSnapshot`;
- `workflowClassCodeSnapshot`;
- `workflowClassNameSnapshot`;
- `unitPriceNetSnapshot`;
- `vatRateSnapshot`;
- `currencySnapshot`.

Decimal handling:

- store Decimal fields using `new Decimal(value)` where needed;
- serialize `unitPriceNetSnapshot` and `vatRateSnapshot` to number/null for API consumers.

Snapshot update rule:

- do not automatically change snapshots if Product is later edited;
- Project Product snapshots represent selection-time context.

## 12. Workflow Class Validation Strategy

Project Product add must validate:

- Product has `workflowClassId`;
- Workflow Class exists;
- Workflow Class is active.

Project activation should validate:

- every active Project Product has a Workflow Class;
- referenced Workflow Class still exists;
- optionally require Workflow Class active. Recommendation: require active in Slice 1I.

Do not allow clients to provide `workflowClassId` directly when adding a Product. It should be derived from the Product.

## 13. Project Number And Slug Uniqueness Handling

Pre-check:

- query by `organizationId + projectNumber`;
- query by `organizationId + slug`;
- exclude current Project on update.

Race handling:

- catch Prisma `P2002`;
- return `TRPCError` with code `CONFLICT`;
- use clear messages:
  - `A Project with this project number already exists for this tenant`;
  - `A Project with this slug already exists for this tenant`.

Do not expose raw Prisma errors.

## 14. Prisma P2002 Conflict Handling

Handle `P2002` for:

- Project create project number/slug uniqueness;
- Project update project number/slug uniqueness;
- Project Product duplicate membership.

Follow existing `isPrismaUniqueConstraintError` helper or move it into a shared FUND Prisma utility if duplication grows.

## 15. Date / Deadline Validation

Rules:

- `closesAt` may be nullable in `DRAFT`;
- activation requires `closesAt`;
- `opensAt`, if present, should be before `closesAt`;
- `productionDeadline`, if present, should not be before `closesAt`;
- future Event constraints are out of scope until Events exist.

Recommended errors:

- `BAD_REQUEST` for invalid date ordering;
- `BAD_REQUEST` for activation without `closesAt`.

Open decision:

- whether `productionDeadline` should be required before activation for A1/A2/B projects. Defer until lifecycle/workflow rules are implemented.

## 16. Status Transition Rules

Recommended transition matrix:

| Current | Allowed Next |
| --- | --- |
| DRAFT | ACTIVE, ARCHIVED |
| ACTIVE | PAUSED, CLOSED, ARCHIVED |
| PAUSED | ACTIVE, CLOSED, ARCHIVED |
| CLOSED | COMPLETED, ARCHIVED |
| COMPLETED | ARCHIVED |
| ARCHIVED | DRAFT via restore |

Invalid transitions:

- return `BAD_REQUEST`;
- do not silently no-op unless current status already equals target and idempotency is explicitly desired.

Recommendation:

- keep transitions strict and visible in Slice 1I.

## 17. Lifecycle State Handling

Schema state:

- `FundProject.lifecycleState` string default `SETUP`.

Slice 1I service recommendation:

- create with `SETUP`;
- do not expose arbitrary lifecycleState update in general `update`;
- status transitions do not need to modify lifecycleState unless a specific rule is approved;
- leave lifecycle transition engine to a future slice.

Future:

- `FundLifecycleState`;
- `FundProjectLifecycleEvent`;
- workflow-class-specific lifecycle extensions.

## 18. Organiser Contact Field Handling

Fields:

- `organiserName`;
- `organiserEmail`;
- `organiserPhone`.

Rules:

- optional;
- trim strings;
- validate email shape if supplied;
- max length limits;
- treat as snapshot/contact details, not authoritative identity;
- changes should write `FUND_PROJECT_ORGANISER_CHANGED` when values differ.

Do not implement organiser account linking in Slice 1I.

## 19. Audit Logging Requirements

Audit events:

- `FUND_PROJECT_CREATED`
- `FUND_PROJECT_UPDATED`
- `FUND_PROJECT_ACTIVATED`
- `FUND_PROJECT_PAUSED`
- `FUND_PROJECT_CLOSED`
- `FUND_PROJECT_COMPLETED`
- `FUND_PROJECT_ARCHIVED`
- `FUND_PROJECT_RESTORED`
- `FUND_PROJECT_PRODUCT_ADDED`
- `FUND_PROJECT_PRODUCT_REMOVED`
- `FUND_PROJECT_PRODUCT_REACTIVATED`
- `FUND_PROJECT_PRODUCT_REORDERED`
- `FUND_PROJECT_ORGANISER_CHANGED`
- `FUND_PROJECT_DATES_CHANGED`
- `FUND_PROJECT_STATUS_CHANGED`

Metadata should include:

- project id;
- project number;
- slug;
- name;
- previous/new status where relevant;
- lifecycle state where relevant;
- Project Product membership ids;
- Product ids;
- Workflow Class ids/codes where relevant;
- previous/new date values for date changes;
- previous/new organiser contact values for organiser changes.

Reorder event:

- log against `FundProject`;
- entity id should be Project id;
- include membership ids, count and previous/new sort order.

## 20. Error Handling And tRPC Error Codes

Recommended codes:

- `UNAUTHORIZED`: no authenticated/effective user;
- `FORBIDDEN`: role/feature access failure;
- `NOT_FOUND`: Project, Product or Project Product membership missing for current tenant;
- `BAD_REQUEST`: invalid status transition, invalid date ordering, activation readiness failure, archived Project mutation attempt, archived Product selection;
- `CONFLICT`: tenant-unique Project number/slug conflict, duplicate active Project Product membership.

Keep messages user-readable and operationally specific.

Examples:

- `Project requires a close date before activation`;
- `Project requires at least one active Product before activation`;
- `Cannot add archived Products to a Project`;
- `Cannot change Products for an archived Project`;
- `Reorder must include every Product membership for the current Project`.

## 21. Manual Test Checklist

### Project CRUD

- Create draft Project with project number, name and slug.
- Create draft Project without `closesAt`.
- Confirm Project defaults to `DRAFT`.
- Confirm Project lifecycle state defaults to `SETUP`.
- Update Project descriptive fields.
- Confirm general update does not mutate status.
- Confirm duplicate project number returns `CONFLICT`.
- Confirm duplicate slug returns `CONFLICT`.

### Status Transitions

- Attempt activation without `closesAt`; expect `BAD_REQUEST`.
- Attempt activation without active Project Product; expect `BAD_REQUEST`.
- Add active Product and `closesAt`; activate Project.
- Pause active Project.
- Reactivate paused Project.
- Close active/paused Project.
- Complete closed Project.
- Archive Project.
- Restore archived Project to draft.
- Confirm invalid transitions return `BAD_REQUEST`.

### Project Product Selection

- Add Product to Project.
- Confirm snapshots are populated.
- Confirm archived Product cannot be added.
- Confirm duplicate active Product returns `CONFLICT` or is prevented.
- Deactivate Product membership.
- Confirm inactive membership remains visible.
- Reactivate membership.
- Reorder memberships with full id list.
- Attempt partial reorder; expect `BAD_REQUEST`.
- Archive Project and confirm membership mutations are rejected.

### Tenant Safety

- Tenant A cannot list Tenant B Projects.
- Tenant A cannot get Tenant B Project.
- Tenant A cannot add Tenant B Product to Tenant A Project.
- Tenant A cannot mutate Tenant B Project Product membership.

### Audit

- Confirm each meaningful mutation writes an `AuditLog`.
- Confirm status transition metadata includes previous/new status.
- Confirm Product add metadata includes snapshots or Product/Workflow Class identifiers.

## 22. Deliberately Out Of Scope

Do not implement in Slice 1I:

- Project UI;
- Event schema;
- Store schema;
- Order schema;
- commerce;
- payments;
- commissions;
- dashboards;
- production batching;
- SeasonPro integration;
- AMOW marketplace exposure;
- media or asset workflows;
- AI workflows;
- lifecycle tables;
- lifecycle transition engine;
- organiser identity model;
- Event date constraints.

## 23. Recommended Implementation Prompt

```text
Proceed with FUND Phase 1 Slice 1I implementation: Project API and Services only.

Work on:
feature/fund-phase-1-products-catalogues

Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not create UI.
Do not create Events, Stores, Orders, commerce, payments, commissions, dashboards, production batching, SeasonPro integration, marketplace exposure, media/asset workflows or AI workflows.

Use:
- isodocs/docs/modules/fund/Planning/2026-06-23-fund-phase-1-slice-1i-project-api-services-proposal.md
- isodocs/docs/modules/fund/implementation/2026-06-23-phase-1-slice-1h-project-schema-confirmation.md
- active FUND docs
- current Product/Catalogue service/router/validation patterns

Implement only:
- Project Zod validation schemas;
- Project service functions;
- Project Product selection service functions;
- Project tRPC router;
- router registration under fund.projects;
- audit logging;
- API-safe Decimal snapshot serialization;
- tenant scoping and role checks;
- status transition procedures.

Run:
- npm run type-check
- npm run verify

Create confirmation document:
isodocs/docs/modules/fund/implementation/2026-06-23-phase-1-slice-1i-project-api-services-confirmation.md

Report files changed, procedures created, checks run and confirmation that no out-of-scope work was added.
```
