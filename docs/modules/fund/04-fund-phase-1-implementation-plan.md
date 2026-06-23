# FUND Phase 1 Implementation Plan

**Canonical location:** `isodocs/docs/modules/fund/04-fund-phase-1-implementation-plan.md`  
**Module slug:** `fund`  
**Status:** Planning / pre-implementation  
**Source documents:** `01-fund-module-brief.md`, `02-fund-architecture-principles.md`, `03-fund-functional-specification.md`  
**Purpose:** Revised Phase 1 plan for proving the FUND model safely.

---

## 1. Purpose

This document defines the recommended Phase 1 implementation plan for FUND.

It is intentionally implementation-facing, but it does not authorise code, schema, migrations or database commands by itself.

Before implementation starts, Codex must still inspect the current branch and repo state.

Forbidden during planning:

- editing Prisma schema;
- creating migrations;
- running `db:push`;
- running seed/reset commands;
- creating routers;
- creating UI pages;
- creating services.

---

## 2. Phase 1 Goal

Phase 1 should prove that FUND can support the correct model:

```text
Product Workflow Classes
  -> Tenant-owned Products and Catalogues
  -> Projects as mandatory operational entities
  -> Optional Events as campaign containers
  -> Workflow-aware Lifecycle
  -> Dashboard visibility
  -> Store association later
```

Phase 1 must not drift into:

```text
Store -> Orders -> Production
```

---

## 3. Known Starting Point

Existing `isostack-bedrock` implementation:

- FUND module config exists.
- FUND is in module registry.
- FUND has feature flag key `fund`.
- FUND has minimal navigation.
- `/app/fund` shell page exists.
- Dashboard landing metadata exists.

No FUND data layer exists yet.

---

## 4. Repository Patterns to Follow

Current patterns observed:

- module code lives under `src/modules/<module>/`;
- app routes live under `src/app/(app)/app/<module>/`;
- module navigation is in `src/core/config/module-navigation.ts`;
- module registry is in `src/modules/module.registry.ts`;
- tRPC routers use `createTRPCRouter` and `protectedProcedure`;
- validation uses Zod;
- significant mutations write `AuditLog`;
- tenant data uses `organizationId`;
- module schemas exist for `bedrock`, `lmspro`, `pulse`;
- Prisma datasource currently lists schemas explicitly;
- module role records are generic `ModuleRole`, but user role assignment fields are currently module-specific arrays.

---

## 5. Phase 1 Slices

### Slice 1A — Confirm Shell and Activation

Status: implemented.

Confirm:

- `/app/fund` loads for entitled tenants;
- navigation appears when `fund` is enabled;
- disabled tenants cannot access FUND unintentionally;
- code-adjacent docs point to canonical `isodocs`.

No schema changes.

Manual tests:

- tenant with `fund` enabled sees FUND tile and nav;
- tenant without `fund` enabled does not;
- `/app/fund` shows shell-only status;
- no database calls are made by shell page.

---

### Slice 1B — Schema Design Plan Only

Deliverable:

- reviewed schema design proposal;
- no Prisma edit yet;
- no migration yet.

Design notes must cover:

- dedicated `fund` schema;
- required `organizationId`;
- relations to `Organization`;
- Product Workflow Class strategy;
- Products and Catalogues;
- Projects;
- optional Events;
- lifecycle state modelling;
- module-role strategy;
- audit actions;
- RLS readiness;
- migration order.

Manual tests:

- peer review confirms no store/order-first drift;
- peer review confirms no mandatory Event assumption;
- peer review confirms tenant isolation on every tenant-owned entity.

---

### Slice 1C — Product Workflow Classes

Goal:

- introduce workflow classes as first-class operational concepts.

Functional requirements:

- A1 Individual Artwork Project Product;
- A2 Group Artwork Product;
- B Logo / Bulk Mass Customisation Product;
- C Standard Product;
- workflow class drives required lifecycle extensions and dashboard actions;
- workflow class is not just a label.

Implementation notes for later:

- decide whether workflow classes are seeded platform defaults, database-managed records, enum-backed records, or hybrid;
- preserve tenant override/customisation question for later.

Manual tests:

- all four classes are visible;
- A1 shows template/artwork requirements;
- A2 shows collation/composite requirements;
- B shows personalisation data requirements;
- C shows simple fulfilment requirements;
- users cannot delete required system classes accidentally.

---

### Slice 1D — Tenant-Owned Products and Catalogues

Goal:

- prove products belong to tenants and require workflow class.

Functional requirements:

- product belongs to `organizationId`;
- product has workflow class;
- product can be active, draft or archived;
- catalogue belongs to tenant;
- catalogue can contain products;
- catalogue/product historical meaning is preserved.

Manual tests:

- Tenant A cannot see Tenant B products;
- product cannot be saved without workflow class;
- archived product remains visible in historical context;
- catalogue can group products from same tenant;
- no product is owned by FUND itself.

---

### Slice 1E — Projects as Mandatory Operational Entities

Goal:

- prove Project as the centre of FUND.

Functional requirements:

- project belongs to tenant;
- project has project number;
- project has name;
- project has organiser context;
- project has closing date;
- project has lifecycle state;
- project can select products;
- selected products determine workflow requirements;
- project does not require store creation at this stage.

Manual tests:

- project can be created without Event;
- project can be created before Store exists;
- project selected products show workflow requirements;
- project number is generated or validated according to chosen rule;
- project list is tenant-scoped.

---

### Slice 1F — Optional Events

Goal:

- prove Events as optional campaign containers.

Functional requirements:

- event belongs to tenant;
- event can define event date;
- event can define campaign open date;
- event can define latest store close date;
- event can define production deadline;
- event can define product/catalogue availability;
- project may link to event;
- independent project remains valid.

Manual tests:

- event can be created;
- project can link to event;
- project can remain independent;
- event displays related projects;
- deleting/archive behaviour is safe and reviewed before implementation.

---

### Slice 1G — Event-to-Project Date Constraints

Goal:

- enforce project close date constraints when Event exists.

Rule:

```text
Project Closing Date <= Event Latest Store Close / Production Deadline
```

Functional requirements:

- projects may close earlier than Event deadline;
- projects may not close later;
- changing Event dates must identify affected Projects;
- rejected changes must be user-readable and audit-worthy.

Manual tests:

- project closes before event deadline: accepted;
- project closes on event deadline: accepted;
- project closes after event deadline: rejected;
- independent project follows own dates;
- event date reduction warns or blocks if existing projects would become invalid.

---

### Slice 1H — Lifecycle States and Workflow Extensions

Goal:

- prove common lifecycle plus workflow-specific extensions.

Functional requirements:

- common lifecycle exists for every Project;
- A1 has artwork/template states;
- A2 has collation/composite states;
- B has personalisation/data states;
- C has simple fulfilment states;
- lifecycle transitions are auditable.

Manual tests:

- A1 project exposes template/artwork lifecycle;
- A2 project exposes group-artwork lifecycle;
- B project exposes data-upload lifecycle;
- C project exposes simple lifecycle;
- invalid lifecycle transitions are blocked.

---

### Slice 1I — Operations Dashboard Visibility

Goal:

- provide internal operational visibility before deep commerce.

Functional requirements:

- show Events;
- show Projects;
- show workflow class;
- show lifecycle state;
- show deadlines;
- show missing actions;
- show blocked/attention states.

Manual tests:

- operations user sees tenant projects;
- cross-tenant projects are not visible;
- A1/A2/B/C projects display distinct requirements;
- overdue/approaching deadlines are visible;
- dashboard does not require orders or stores.

---

### Slice 1J — Organiser Fundraising Dashboard Visibility

Goal:

- provide organiser-facing project hub.

Functional requirements:

- organiser sees relevant projects only;
- project number is visible;
- current stage is visible;
- next required action is visible;
- key dates are visible;
- store link placeholder appears only when store exists;
- workflow requirements are understandable.

Manual tests:

- organiser sees assigned project;
- organiser does not see unrelated projects;
- A1 project tells organiser about template/artwork steps;
- B project tells organiser about data requirements;
- no order/payment dependency is required.

---

### Slice 1K — Store Association Planning / Placeholder

Goal:

- add only the minimum concept of store association after Project and Lifecycle are stable.

Functional requirements:

- Project can have zero or one initial Store association;
- store is generated from or linked to Project;
- Event does not own Store directly;
- no full checkout implementation in Phase 1 foundation.

Manual tests:

- project without store remains valid;
- project with associated store displays link/status;
- store association is tenant-scoped;
- store is never created directly from Event.

---

## 6. Suggested Data Model Planning Notes

Potential early entities:

- `FundProductWorkflowClass`
- `FundProduct`
- `FundCatalogue`
- `FundCatalogueProduct`
- `FundProject`
- `FundProjectProduct`
- `FundEvent`
- `FundProjectLifecycleState`
- `FundProjectLifecycleEvent`

Potential later entities:

- `FundStore`
- `FundOrderReference`
- `FundArtworkAsset`
- `FundPersonalisationData`
- `FundProductionBatch`
- `FundCommissionRule`
- `FundCommissionLine`
- `FundEmailSequence`
- `FundKeyDate`

Planning constraints:

- no final names until schema design review;
- use dedicated `fund` schema if approved;
- add `fund` to Prisma datasource schemas only in migration-safe schema work;
- keep `organizationId` required on tenant-owned tables;
- do not model Event as mandatory parent of Project;
- do not model Store as parent of Project.

---

## 7. Tenant Safety Requirements

All tenant-owned reads and writes must:

- resolve current user;
- resolve current `organizationId`;
- filter by `organizationId`;
- verify referenced records belong to the same tenant;
- reject cross-tenant IDs;
- write audit records for significant changes.

RLS is a defence layer, not a replacement for application-level scoping.

---

## 8. Permission and Role Considerations

Initial implementation may rely on Platform `OWNER` / `ADMIN` for management.

Before module role implementation, decide:

1. Add `fundRoleIds` to `User`.
2. Generalise module role assignment away from hard-coded arrays.
3. Temporarily defer module-role assignment while using platform roles only.

Preferred long-term direction is a generic module-role assignment model, but this may be larger than FUND Phase 1.

Potential component keys:

- `fund.workflowClasses.view`
- `fund.workflowClasses.manage`
- `fund.products.view`
- `fund.products.manage`
- `fund.catalogues.view`
- `fund.catalogues.manage`
- `fund.events.view`
- `fund.events.manage`
- `fund.projects.view`
- `fund.projects.manage`
- `fund.lifecycle.manage`
- `fund.operations.view`
- `fund.organiser.view`

---

## 9. Audit Logging Requirements

Use existing `AuditLog` pattern.

Every mutation should record:

- action;
- entity type;
- entity ID;
- user ID;
- organization ID;
- metadata with human-readable context.

Audit lifecycle changes and rejected safety-critical actions, especially date constraint failures and project state transitions.

---

## 10. Phase 1 Risks

| Risk | Mitigation |
|---|---|
| Store-first drift | Keep stores out until Slice 1K. |
| AMOW artwork flattened into generic uploads | Keep A1/A2 workflow requirements explicit. |
| Event incorrectly made mandatory | Test independent Projects early. |
| Cross-tenant leakage | Require `organizationId` on every tenant-owned query. |
| Permission model becomes inconsistent | Resolve `fundRoleIds` versus generic module role assignment before role work. |
| Schema overbuild | Keep schema slices narrow and review each migration. |
| Commerce provider coupling | Keep internal Store/Order model provider-neutral. |

---

## 11. Phase 1 Do Not Build Yet

Do not build in Phase 1 foundation:

- Stripe Checkout;
- GoCardless;
- live payment gating;
- full public storefront;
- order item model beyond planning;
- refund handling;
- commission engine;
- statement generation;
- AMOW PDF template generation;
- production batch management;
- fulfilment exports;
- SeasonPro distribution channel;
- marketplace onboarding;
- AI assistant workflows.

---

## 12. Recommended Next Implementation Prompt

Use this only after this documentation set is reviewed:

```text
You are working on IsoStack, a live multi-tenant SaaS platform.

Implement FUND Phase 1 Slice 1B only: schema design proposal.

Do not edit code.
Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.

Read:
- isodocs/docs/modules/fund/01-fund-module-brief.md
- isodocs/docs/modules/fund/02-fund-architecture-principles.md
- isodocs/docs/modules/fund/03-fund-functional-specification.md
- isodocs/docs/modules/fund/04-fund-phase-1-implementation-plan.md
- isodocs/docs/modules/fund/05-fund-open-questions.md

Inspect the current repo patterns and produce a schema design proposal only.
Include entities, relationships, tenant-safety notes, permission impact, audit requirements, migration risks and open questions.
```

