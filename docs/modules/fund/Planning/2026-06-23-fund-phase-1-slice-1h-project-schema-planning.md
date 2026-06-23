# FUND Phase 1 Slice 1H - Project Schema Planning

Date: 2026-06-23

Status: Planning only

Target branch:

```text
feature/fund-phase-1-products-catalogues
```

## Purpose

Slice 1H plans the Project schema foundation for FUND.

This document does not authorise implementation. It is a schema planning artefact only.

Do not treat this document as permission to:

- edit Prisma schema;
- create migrations;
- run `db:push`;
- run seed/reset commands;
- create routers;
- create services;
- create UI;
- create Projects in data;
- create Events;
- create Stores;
- create Orders;
- create commerce, payments, commissions, dashboards, production batching, SeasonPro integration, marketplace exposure or AI workflows.

## Source Context

Use:

- `01-fund-module-brief.md`
- `02-fund-architecture-principles.md`
- `03-fund-functional-specification.md`
- `04-fund-phase-1-implementation-plan.md`
- `05-fund-open-questions.md`
- `Planning/2026-06-23-fund-phase-1-slice-1b-schema-design-proposal.md`
- `implementation/2026-06-23-phase-1-slice-1g-products-catalogues-review-closeout.md`
- implemented Slice 1C, 1D, 1E, 1F-A and 1F-B confirmations

## 1. Slice Goal

Plan the schema for Projects as the mandatory operational fundraising entity.

The goal is to prove this model:

```text
Tenant
  -> Products and Catalogues
  -> Project
      -> selected Products
      -> lifecycle state
      -> organiser context
      -> operational deadlines
      -> future Store association
```

Project must be the centre of FUND.

Do not let the model drift into:

```text
Store -> Orders -> Production
```

Stores and Orders are later layers around Projects, not the foundation for this slice.

## 2. Recommended Slice 1H Boundary

Plan only:

- `FundProjectStatus` enum;
- `FundProject` model;
- `FundProjectProduct` model;
- initial Project lifecycle state strategy;
- organiser context strategy;
- Product selection snapshot strategy;
- tenant scoping;
- indexes and uniqueness;
- migration risks;
- open decisions before implementation.

Do not plan implementation of:

- Event model creation;
- Store model creation;
- Order model creation;
- payment logic;
- commission logic;
- organiser dashboard;
- operations dashboard;
- production batching;
- asset/media workflows;
- SeasonPro integration;
- AI workflows.

Events may be referenced as a future optional relation, but Slice 1H implementation should not require Events to exist.

## 3. Recommended Entities

### `FundProjectStatus`

Recommended enum values:

- `DRAFT`
- `ACTIVE`
- `PAUSED`
- `CLOSED`
- `COMPLETE`
- `ARCHIVED`

Reasoning:

- `DRAFT` supports internal setup before launch.
- `ACTIVE` supports operational live projects before richer lifecycle automation exists.
- `PAUSED` supports temporary hold without closing.
- `CLOSED` supports sales/order cutoff later.
- `COMPLETE` supports fulfilment/commission completion later.
- `ARCHIVED` preserves historical meaning without hard delete.

Open decision:

- whether `ACTIVE` should later be split into `CREATED`, `STORE_OPEN` and `SELLING` at lifecycle level rather than status level.

### `FundProject`

Recommended core fields:

- `id`
- `organizationId`
- `projectNumber`
- `name`
- `slug`
- `description`
- `status`
- `lifecycleState`
- `organiserName`
- `organiserEmail`
- `organiserPhone`
- `organiserUserId?`
- `organiserOrganizationId?`
- `opensAt?`
- `closesAt`
- `productionDeadline?`
- `internalNotes?`
- `metadata`
- `archivedAt?`
- `archivedById?`
- `archivedReason?`
- `createdById?`
- `updatedById?`
- `createdAt`
- `updatedAt`

Required fields for first implementation:

- `organizationId`
- `projectNumber`
- `name`
- `slug`
- `status`
- `closesAt`

Recommended nullable fields:

- organiser references;
- optional dates other than `closesAt`;
- production deadline;
- notes and description.

### `FundProjectProduct`

Recommended purpose:

- join Project to selected Products;
- preserve Product selection and workflow requirements at the point of Project setup.

Recommended fields:

- `id`
- `organizationId`
- `projectId`
- `productId`
- `workflowClassId`
- `sortOrder`
- `isActive`
- `productCodeSnapshot`
- `productNameSnapshot`
- `workflowClassCodeSnapshot`
- `workflowClassNameSnapshot`
- `unitPriceNetSnapshot?`
- `vatRateSnapshot?`
- `currencySnapshot`
- `metadata`
- `addedById?`
- `addedAt`
- `updatedAt`

Why snapshots matter:

- Products can later be renamed, archived or repriced.
- Projects must preserve historical operational meaning.
- Orders and Stores later need stable Project/Product context.

## 4. Relationships

Recommended early relationship shape:

```text
Organization
  -> FundProject[]

FundProject
  -> Organization
  -> FundProjectProduct[]
  -> optional organiser User
  -> optional organiser Organization

FundProjectProduct
  -> Organization
  -> FundProject
  -> FundProduct
  -> FundProductWorkflowClass
```

Rules:

- Project must not require Store.
- Project must not require Event.
- Project must not require Order.
- Project Product joins must be same-tenant.
- Product Workflow Class must be captured through `workflowClassId` and snapshots.

## 5. Tenant Scoping

Every tenant-owned Project table must include required:

```prisma
organizationId String @map("organization_id")
```

Application/service rules for later implementation:

- never accept `organizationId` from client input;
- derive actor organisation from session/effective context;
- scope all Project reads and writes by `organizationId`;
- validate Product selection belongs to the same tenant;
- validate Project/Product joins are same-tenant;
- reject cross-tenant Product ids;
- reject cross-tenant organiser references unless deliberately supported later.

Database rules:

- `FundProject` should have `@@unique([organizationId, id])`;
- `FundProjectProduct` should use composite same-tenant foreign keys:
  - `(organizationId, projectId)` -> `FundProject(organizationId, id)`;
  - `(organizationId, productId)` -> `FundProduct(organizationId, id)`.

## 6. Project Number Strategy

Recommended first implementation:

- project number is tenant-scoped and required;
- allow manual entry in first schema/API slice, with validation;
- reserve generated sequencing for later if the repo has no established tenant-safe sequence pattern.

Uniqueness:

```text
unique(organizationId, projectNumber)
```

Open decision:

- whether Project number should be human-readable only, or also encode season/event/customer context later.

## 7. Slug Strategy

Recommended:

- Project `slug` is tenant-scoped and required;
- unique per tenant;
- same lower-case URL-safe pattern used for Products and Catalogues.

Rationale:

- future Store or public Project route can reference stable slug;
- project number remains operational; slug remains route/display-friendly.

Uniqueness:

```text
unique(organizationId, slug)
```

## 8. Lifecycle Strategy

Recommended Slice 1H schema choice:

- store `lifecycleState` as a string on `FundProject` initially;
- defer `FundLifecycleState` and `FundProjectLifecycleEvent` tables to the next lifecycle-specific slice.

Reasoning:

- Products/Catalogues foundation is still settling;
- full lifecycle state tables need workflow-class-specific design;
- Project schema can still prove lifecycle-first modelling with an initial string state.

Initial default:

```text
DRAFT
```

Recommended later slice:

- `FundLifecycleState`
- `FundProjectLifecycleEvent`
- workflow-class-specific lifecycle extensions.

Alternative:

- implement lifecycle tables now. This is not recommended for Slice 1H because it broadens the slice and risks premature modelling.

## 9. Product Selection Strategy

Project Product selection should reference tenant-owned Products.

Rules:

- Product must belong to same tenant.
- Product must not be archived when added to a Project.
- Project Product should snapshot Product code/name/workflow class/pricing at time of selection.
- Product archive later should not break Project history.
- Project Product rows should be soft inactive rather than hard deleted if removed after operational use begins.

Recommended uniqueness:

```text
unique(projectId, productId)
```

Consider:

- use `@@unique([organizationId, projectId, productId])` if Prisma relation pattern prefers tenant-scoped uniqueness.

## 10. Organiser Model Strategy

Recommended Phase 1 approach: hybrid organiser fields on `FundProject`.

Fields:

- `organiserName`
- `organiserEmail`
- `organiserPhone`
- `organiserUserId?`
- `organiserOrganizationId?`

Rationale:

- supports AMOW/internal project setup without requiring every organiser to have an account;
- preserves future path to organiser dashboard;
- avoids introducing `FundOrganiser` or `FundProjectParticipant` too early.

Open decisions:

- should organiser email be required in first implementation?
- should organiser user reference be restricted to same tenant?
- how should external organiser accounts be represented later?

## 11. Date And Deadline Strategy

Recommended Project dates:

- `opensAt?`
- `closesAt` required;
- `productionDeadline?`

Rules:

- `closesAt` is required because every fundraising Project needs an operational cutoff.
- `opensAt` may be null while draft.
- `productionDeadline` may be null in first implementation.
- Event date constraints are deferred until Event model exists.

Future Event rule:

```text
Project.closesAt <= Event.latestStoreClosesAt
```

Fallback:

```text
Project.closesAt <= Event.productionDeadline
```

Do not implement Event constraints in Slice 1H.

## 12. Status And Archive Strategy

Project archive:

- use status `ARCHIVED`;
- set archive metadata;
- do not hard delete.

Project restore:

- restore to `DRAFT` unless later lifecycle rules require previous-state restoration.

Project Product removal:

- use `isActive = false`;
- do not hard delete once Projects may have operational history.

## 13. Audit Events To Plan

Recommended future service audit events:

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

Slice 1H schema planning does not implement audit writes. These belong to the Project API/services slice.

## 14. Indexes And Constraints

Recommended `FundProject` indexes:

- `@@unique([organizationId, id])`
- `@@unique([organizationId, projectNumber])`
- `@@unique([organizationId, slug])`
- `@@index([organizationId, status])`
- `@@index([organizationId, closesAt])`
- `@@index([organizationId, lifecycleState])`
- `@@index([archivedAt])`

Recommended `FundProjectProduct` indexes:

- `@@unique([organizationId, projectId, productId])`
- `@@index([organizationId, projectId, sortOrder])`
- `@@index([organizationId, productId])`
- `@@index([organizationId, workflowClassId])`

Foreign keys:

- Project -> Organization: cascade on tenant deletion;
- ProjectProduct -> Project: cascade on Project deletion;
- ProjectProduct -> Product: restrict or no action to preserve history;
- ProjectProduct -> WorkflowClass: restrict.

Open decision:

- whether Product relation should be `Restrict` or `SetNull` with snapshots. Prefer `Restrict` while Products are soft-archived rather than hard-deleted.

## 15. Migration Risks

Low/medium risk if schema-only.

Risks:

- project number sequencing may be under-designed if automated too early;
- lifecycle string may need migration to lifecycle table later;
- organiser references may need broader account model later;
- Project Product snapshots must be complete enough to preserve historical meaning;
- date semantics can become confusing if `closesAt`, `storeClosesAt` and Event deadlines are conflated.

Mitigations:

- keep Store/Order/Event fields out of Slice 1H;
- keep lifecycle minimal but explicit;
- use required tenant scoping throughout;
- document all nullable organiser/date choices;
- make Product selection snapshots explicit.

## 16. Open Decisions Before Implementation

Resolve or explicitly defer:

1. Should `projectNumber` be manually entered in first implementation?
2. Should `projectNumber` be generated in a later service slice?
3. Is `closesAt` required from draft, or only before activation?
4. Should organiser email be required?
5. Should Project Product snapshot include Product description/short description?
6. Should Project Product snapshot include price/VAT/currency, even before Store/Order exists?
7. Should `lifecycleState` be string in Slice 1H, with lifecycle tables deferred?
8. Should Project status include `PAUSED` now?
9. Should Project Product uniqueness allow the same Product twice with different configuration later?
10. Should Project schema include `eventId?` now as a nullable future relation placeholder, or defer until Event model exists?

Recommended defaults:

- manual project number for first implementation;
- `closesAt` required;
- organiser email optional;
- include price/VAT/currency snapshots;
- lifecycle as string for Slice 1H;
- include `PAUSED`;
- one Product once per Project;
- defer `eventId` until Event model exists.

## 17. Recommended Slice 1H Implementation Scope

When implementation is approved, keep it schema-only:

- add `FundProjectStatus`;
- add `FundProject`;
- add `FundProjectProduct`;
- add Organization relations;
- add Product/WorkflowClass relations;
- add indexes and uniqueness constraints;
- add migration;
- create implementation confirmation document.

Do not implement:

- Project router;
- Project service;
- Project UI;
- lifecycle transition engine;
- Event model;
- Store model;
- Order model;
- dashboards;
- commerce;
- payment;
- commission;
- production batching;
- media/assets.

## 18. Manual Verification Checklist For Future Implementation

After schema implementation:

- Prisma schema validates.
- Prisma client generates.
- Migration creates Project enum/table/join table only.
- `db:push` was not used.
- seed/reset commands were not used.
- Project has required `organizationId`.
- Project Product has required `organizationId`.
- Project number is unique per tenant.
- Project slug is unique per tenant.
- Project Product joins are same-tenant.
- Product relation cannot break historical Project meaning.
- No Event/Store/Order/commerce schema was added.

## 19. Recommended Next Prompt

```text
Proceed with FUND Phase 1 Slice 1H implementation: Project schema only.

Do not create routers, services or UI.
Do not create Events, Stores, Orders, commerce, payments, commissions, dashboards, production batching, SeasonPro integration, marketplace exposure, media/asset workflows or AI workflows.
Do not run db:push.
Do not run seed/reset commands.

Implement only:
- FundProjectStatus enum;
- FundProject model;
- FundProjectProduct model;
- Organization relations;
- required tenant scoping;
- required indexes and uniqueness constraints;
- migration;
- implementation confirmation document.

Before editing, read:
- active FUND docs;
- Slice 1G closeout;
- this Slice 1H planning document;
- current Prisma schema conventions.

Run:
- npx prisma validate;
- npm run db:generate;
- npm run type-check;
- npm run verify.
```
