# Phase 1 Slice 1H - Project Schema Confirmation

## Date

2026-06-23

## Slice Name

Phase 1 Slice 1H - Project Schema

## Implementation Summary

Implemented the schema-only Project foundation for FUND.

This slice adds Projects as the mandatory operational FUND entity and adds Project/Product selection rows with product and workflow snapshots.

The implementation deliberately does not create Events, Stores, Orders, commerce, payments, commissions, dashboards, routers, services or UI.

## Files Changed

App repository:

- `prisma/schema.prisma`
- `prisma/migrations/20260623170000_add_fund_projects/migration.sql`

Documentation repository:

- `docs/modules/fund/implementation/2026-06-23-phase-1-slice-1h-project-schema-confirmation.md`

## Prisma Schema Changes

Added:

- `FundProjectStatus` enum
- `FundProject` model
- `FundProjectProduct` model
- `Organization.fundProjects` relation
- `Organization.fundProjectProducts` relation
- `FundProduct.projectProducts` relation
- `FundProductWorkflowClass.projectProducts` relation

No Event, Store, Order, commerce, payment, commission, dashboard, production batching, media/asset or AI models were added.

## Migration Created

Migration path:

```text
prisma/migrations/20260623170000_add_fund_projects/migration.sql
```

SQL summary:

- creates `fund.FundProjectStatus`;
- creates `fund.fund_projects`;
- creates `fund.fund_project_products`;
- adds tenant-scoped uniqueness for Project `project_number`;
- adds tenant-scoped uniqueness for Project `slug`;
- adds tenant-scoped uniqueness for Project/Product membership;
- adds indexes for Project status, close date, lifecycle state and archive state;
- adds indexes for Project/Product order, Product lookup and Workflow Class lookup;
- adds Project-to-Organization foreign key;
- adds ProjectProduct-to-Organization foreign key;
- adds composite same-tenant ProjectProduct-to-Project foreign key;
- adds composite same-tenant ProjectProduct-to-Product foreign key;
- adds ProjectProduct-to-WorkflowClass foreign key.

## `db:push`

`db:push` was not used.

## Seed / Reset Commands

Seed commands were not used.

Reset commands were not used.

## Models And Enums Created

### `FundProjectStatus`

Values:

- `DRAFT`
- `ACTIVE`
- `PAUSED`
- `CLOSED`
- `COMPLETED`
- `ARCHIVED`

### `FundProject`

Purpose:

- tenant-owned operational fundraising Project;
- does not require Event, Store or Order;
- stores operational status, lifecycle state, organiser contact snapshot, dates and archive metadata.

Key fields:

- `organizationId`
- `projectNumber`
- `name`
- `slug`
- `status`
- `lifecycleState`
- `organiserName`
- `organiserEmail`
- `organiserPhone`
- `opensAt`
- `closesAt`
- `productionDeadline`
- `internalNotes`
- archive metadata

### `FundProjectProduct`

Purpose:

- tenant-owned join between Project and Product;
- captures workflow class reference;
- captures Product and Workflow Class snapshots for historical stability;
- uses `isActive` for future soft removal rather than hard delete.

Snapshot fields:

- `productCodeSnapshot`
- `productNameSnapshot`
- `productShortDescriptionSnapshot`
- `workflowClassCodeSnapshot`
- `workflowClassNameSnapshot`
- `unitPriceNetSnapshot`
- `vatRateSnapshot`
- `currencySnapshot`

## Tenant Scoping Strategy

All new tenant-owned tables include required `organizationId`:

- `FundProject.organizationId`
- `FundProjectProduct.organizationId`

Tenant-scoped uniqueness:

- Project number is unique per tenant.
- Project slug is unique per tenant.
- Product may appear only once per Project in this slice via `@@unique([organizationId, projectId, productId])`.

Same-tenant joins:

- `FundProjectProduct(organizationId, projectId)` references `FundProject(organizationId, id)`.
- `FundProjectProduct(organizationId, productId)` references `FundProduct(organizationId, id)`.

This mirrors the existing `FundCatalogueProduct` tenant-safety pattern.

## Project Status Strategy

Project status uses `FundProjectStatus`.

Default:

```text
DRAFT
```

Status values are intentionally broad operational states. More detailed workflow behaviour remains in lifecycle state and future lifecycle tables.

## Lifecycle State Strategy

`FundProject.lifecycleState` is a string field.

Default:

```text
SETUP
```

Lifecycle tables were deliberately not created in this slice.

Future slices may introduce:

- `FundLifecycleState`
- `FundProjectLifecycleEvent`
- workflow-class-specific lifecycle extensions.

## Organiser Field Strategy

Organiser fields are optional.

Implemented fields:

- `organiserName`
- `organiserEmail`
- `organiserPhone`

These are snapshot/contact fields only. They are not authoritative identity records.

No organiser user relation, organiser organisation relation, `FundOrganiser`, or `FundProjectParticipant` model was created in this slice.

## Product Snapshot Strategy

`FundProjectProduct` stores both references and snapshots.

References:

- Project
- Product
- Workflow Class

Snapshots:

- Product code;
- Product name;
- Product short description;
- Workflow Class code;
- Workflow Class name;
- unit price net;
- VAT rate;
- currency.

Reason:

- Products may later be renamed, archived or repriced;
- Workflow Classes may later gain more configuration;
- Project history must remain meaningful after operational data changes.

## Same-Tenant Join Strategy

`FundProjectProduct` uses composite same-tenant relations for:

- Project;
- Product.

Product relation uses `ON DELETE RESTRICT`, because Products are soft-archived rather than hard-deleted.

Workflow Class relation uses `ON DELETE RESTRICT`, because workflow classes are protected operational reference records.

Project relation uses `ON DELETE CASCADE`, matching the Project ownership of its Product membership rows.

## Deliberately Not Implemented

This slice did not implement:

- routers;
- services;
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
- lifecycle transition engine;
- organiser identity model;
- Project data creation.

## Checks Run And Results

Passed:

```text
npx prisma validate
npm run db:generate
npm run type-check
npm run verify
```

Note:

- `npm run verify` initially failed in the sandbox because `tsx` could not create its temporary IPC pipe.
- The same command passed when rerun with approved local escalation.

## Manual Verification Checklist

Before promotion or implementation of Project services:

- confirm migration exists in source control;
- confirm migration creates only Project enum/table/join table;
- confirm `db:push` was not used;
- confirm seed/reset commands were not used;
- confirm `FundProjectStatus` has exactly the agreed values;
- confirm `FundProject.organizationId` is required;
- confirm `FundProjectProduct.organizationId` is required;
- confirm Project number is tenant-unique;
- confirm Project slug is tenant-unique;
- confirm Product may appear only once per Project;
- confirm Project/Product joins are same-tenant;
- confirm Product relation is restricted;
- confirm Workflow Class relation is restricted;
- confirm `closesAt` is nullable at schema level;
- confirm later API/service slice requires `closesAt` before activation;
- confirm no Events, Stores or Orders were added.

## Risks And Follow-Ups

Risks:

- manual Project number entry needs careful duplicate handling in the later API slice;
- `lifecycleState` string may later migrate to lifecycle tables;
- organiser snapshot fields are intentionally limited and may need richer organiser modelling later;
- Project Product snapshots must be populated consistently by future services;
- `closesAt` is nullable in schema, so future activation logic must enforce it before a Project becomes active.

Follow-ups:

- Project API/services with tenant scoping and audit logging;
- Project CRUD/admin UI;
- lifecycle table planning;
- optional Event schema planning;
- Event-to-Project date constraint planning.

## Recommended Next Slice

Recommended next slice:

```text
FUND Phase 1 Slice 1I - Project API and Services Planning
```

The next slice should plan Project tRPC routers, Zod validation, service-layer tenant safety, Project Product selection service behaviour, audit events and status transition rules before any UI is built.
