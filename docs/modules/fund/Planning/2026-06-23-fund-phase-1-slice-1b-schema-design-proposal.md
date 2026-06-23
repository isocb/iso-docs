# FUND Phase 1 Slice 1B — Schema Design Proposal

**Canonical location:** `isodocs/docs/modules/fund/Planning/2026-06-23-fund-phase-1-slice-1b-schema-design-proposal.md`  
**Module slug:** `fund`  
**Status:** Proposal / schema-design-only  
**Date:** 2026-06-23  
**Source documents:**

- `01-fund-module-brief.md`
- `02-fund-architecture-principles.md`
- `03-fund-functional-specification.md`
- `04-fund-phase-1-implementation-plan.md`
- `05-fund-open-questions.md`

---

## 1. Scope

This document records the Phase 1 Slice 1B schema design proposal for FUND.

It is a planning artefact only.

Do not treat this document as permission to:

- edit Prisma schema;
- create migrations;
- run `db:push`;
- run seed/reset commands;
- create routers;
- create services;
- create UI.

FUND must remain lifecycle-first and production-aware. Commerce is layered around Projects later.

---

## 2. Recommended Entities

Phase 1 should introduce only the entities needed to prove the lifecycle-first model:

- `FundProductWorkflowClass`
- `FundProduct`
- `FundCatalogue`
- `FundCatalogueProduct`
- `FundEvent`
- `FundProject`
- `FundProjectProduct`
- `FundLifecycleState`
- `FundProjectLifecycleEvent`

Defer:

- `FundStore`
- `FundOrder`
- `FundArtworkAsset`
- `FundPersonalisationData`
- `FundProductionBatch`
- `FundCommissionRule`
- `FundCommissionLine`

Those deferred entities should not lead the model.

---

## 3. Relationships

Recommended early relationship shape:

```text
Organization
  -> FundProductWorkflowClass
  -> FundProduct
      -> FundProductWorkflowClass
  -> FundCatalogue
      -> FundCatalogueProduct
          -> FundProduct
  -> FundEvent
      -> optional catalogues/products
      -> FundProject[]
  -> FundProject
      -> optional FundEvent
      -> FundProjectProduct[]
      -> FundLifecycleState
      -> FundProjectLifecycleEvent[]
```

Projects must remain valid without Events.

Stores must later belong to Projects, not Events.

---

## 4. Tenant Scoping

Every tenant-owned FUND model should include:

```prisma
organizationId String @map("organization_id")
organization   Organization @relation(fields: [organizationId], references: [id], onDelete: Cascade)
```

Rules:

- Use application-level `organizationId` filtering on all queries.
- Treat RLS as a defence layer, not a replacement for application-level scoping.
- Verify referenced records belong to the same tenant.
- Reject cross-tenant IDs.
- Do not allow implicit cross-tenant product or catalogue sharing in Phase 1.

---

## 5. Product Workflow Class Strategy

Recommendation: hybrid system defaults.

A1, A2, B and C should be protected system/default records.

Use database records rather than only enums because workflow classes need metadata:

- required assets;
- lifecycle extensions;
- dashboard prompts;
- future validation behaviour;
- future production requirements;
- future communication triggers.

Stable default codes:

| Code | Name |
|---|---|
| A1 | Individual Artwork Project Product |
| A2 | Group Artwork Product |
| B | Logo / Bulk Mass Customisation Product |
| C | Standard Product |

Tenant-specific workflow extensions can come later.

---

## 6. Project Model

`FundProject` should be the centre of the schema.

Core fields to plan:

- `id`
- `organizationId`
- `projectNumber`
- `name`
- `description`
- `status`
- `lifecycleStateId`
- `eventId?`
- `organiserUserId?`
- `organiserOrganizationId?`
- `organiserName?`
- `opensAt?`
- `closesAt`
- `productionDeadline?`
- `createdBy`
- `createdAt`
- `updatedAt`
- `archivedAt?`

Rules:

- Project creation must not require Store creation.
- Project creation must not require Event selection.
- Selected products should determine workflow requirements.
- Project records must preserve historical meaning even when products or catalogues change later.

---

## 7. Optional Event Model

`FundEvent` should be an optional campaign grouping and constraint container.

Fields to plan:

- `id`
- `organizationId`
- `name`
- `slug`
- `eventDate?`
- `campaignOpensAt?`
- `projectCreationClosesAt?`
- `latestStoreClosesAt?`
- `productionDeadline?`
- `status`
- `description?`
- `createdAt`
- `updatedAt`
- `archivedAt?`

Validation rule:

```text
Project.closesAt <= Event.latestStoreClosesAt
```

Fallback if no latest store close exists:

```text
Project.closesAt <= Event.productionDeadline
```

This should be enforced in application logic first. Cross-row database check constraints are not straightforward and should not be forced into Slice 1B.

---

## 8. Lifecycle Modelling

Recommendation: database-backed lifecycle states plus project event history.

Use:

- `FundLifecycleState` for available state definitions;
- `FundProjectLifecycleEvent` for lifecycle transition history.

`FundLifecycleState` should support:

- common states;
- workflow-class-specific states;
- display order;
- terminal-state flag;
- organiser-action flag;
- producer/admin-action flag;
- dashboard status metadata.

This avoids hard-coding every future AMOW production state too early.

---

## 9. Product and Catalogue Model

`FundProduct` belongs to tenant and requires a workflow class.

Suggested fields:

- `id`
- `organizationId`
- `workflowClassId`
- `name`
- `slug`
- `sku?`
- `description?`
- `status`
- `basePrice?`
- `currency`
- `requiresArtwork`
- `requiresPersonalisationData`
- `requiresTemplate`
- `metadata Json?`
- `createdAt`
- `updatedAt`
- `archivedAt?`

`FundCatalogue` suggested fields:

- `id`
- `organizationId`
- `name`
- `slug`
- `status`
- `description?`
- `createdAt`
- `updatedAt`
- `archivedAt?`

`FundCatalogueProduct` should join catalogue and product with:

- `catalogueId`
- `productId`
- `displayOrder`
- optional availability overrides.

---

## 10. Organiser Model Options

Best Phase 1 option: hybrid fields on `FundProject`.

Use optional references where possible:

- `organiserUserId?`
- `organiserOrganizationId?`
- `organiserName?`
- `organiserEmail?`

This supports early AMOW/internal project setup without forcing full public organiser accounts.

A later `FundProjectParticipant` model can support richer organiser/team roles.

---

## 11. Module Role Strategy

Current repo state:

- `ModuleRole` is generic.
- User assignment is not fully generic.
- Current user fields include `lmsproRoleIds`, `bedrockRoleIds`, and `tailoraidRoleIds`.
- There is no `fundRoleIds`.

Recommendation for Phase 1:

- Use platform `OWNER` / `ADMIN` for management initially.
- Do not add `fundRoleIds` until a decision is made.
- Prefer a future generic module-role assignment table over another hard-coded array, but treat that as broader platform work.

Potential component keys:

- `fund.workflowClasses.view`
- `fund.workflowClasses.manage`
- `fund.products.manage`
- `fund.catalogues.manage`
- `fund.events.manage`
- `fund.projects.manage`
- `fund.lifecycle.manage`
- `fund.operations.view`
- `fund.organiser.view`

---

## 12. Audit Events

Plan these early:

- `FUND_WORKFLOW_CLASS_CREATED`
- `FUND_WORKFLOW_CLASS_UPDATED`
- `FUND_PRODUCT_CREATED`
- `FUND_PRODUCT_UPDATED`
- `FUND_PRODUCT_ARCHIVED`
- `FUND_CATALOGUE_CREATED`
- `FUND_CATALOGUE_UPDATED`
- `FUND_EVENT_CREATED`
- `FUND_EVENT_UPDATED`
- `FUND_PROJECT_CREATED`
- `FUND_PROJECT_UPDATED`
- `FUND_PROJECT_LIFECYCLE_CHANGED`
- `FUND_PROJECT_DATE_CONSTRAINT_REJECTED`

Use existing `AuditLog` in `public`.

Each audit record should include:

- action;
- entity type;
- entity ID;
- user ID;
- organization ID;
- useful metadata.

---

## 13. Indexes and Uniqueness Constraints

Recommended constraints:

- `FundProductWorkflowClass`: unique `[organizationId, code]` if tenant-scoped, or unique `[code]` if platform defaults only.
- `FundProduct`: unique `[organizationId, slug]`; index `[organizationId, status]`; index `[organizationId, workflowClassId]`.
- `FundCatalogue`: unique `[organizationId, slug]`; index `[organizationId, status]`.
- `FundCatalogueProduct`: unique `[catalogueId, productId]`; index `[productId]`.
- `FundEvent`: unique `[organizationId, slug]`; index `[organizationId, status]`; index `[organizationId, latestStoreClosesAt]`.
- `FundProject`: unique `[organizationId, projectNumber]`; index `[organizationId, status]`; index `[organizationId, eventId]`; index `[organizationId, closesAt]`.
- `FundProjectProduct`: unique `[projectId, productId]`; index `[productId]`.
- `FundProjectLifecycleEvent`: index `[organizationId, projectId, createdAt]`.

---

## 14. Migration Risks

Key risks:

- Adding `fund` to Prisma datasource `schemas` must be migration-safe.
- New `Organization` relations need careful naming to avoid relation ambiguity.
- Workflow classes as seed/default data need an idempotent strategy; avoid destructive seed commands.
- Generic module-role assignment would be platform-affecting and should not be hidden inside FUND schema work.
- Event-to-Project date constraints should start in application logic rather than complex DB cross-row constraints.
- Cross-tenant product/catalogue sharing should be deferred or explicitly modelled later.

---

## 15. Open Decisions Before Implementation

Resolve before editing Prisma schema:

1. Are A1/A2/B/C platform defaults, tenant records, or hybrid?
2. Is project number tenant-scoped?
3. Is organiser a user, organisation, contact, or hybrid?
4. Will Phase 1 use platform roles only?
5. Should lifecycle states be database-backed?
6. Should `fund` schema be added now?
7. Are products strictly tenant-owned in Phase 1?
8. Is catalogue sharing deferred?
9. Should project/event date constraints be enforced in application logic first?

Recommended answers:

- A1/A2/B/C: protected system defaults.
- Project number: tenant-scoped for Phase 1.
- Organiser: hybrid fields now, participant model later.
- Roles: platform roles only for early Phase 1.
- Lifecycle: database-backed.
- Schema: dedicated `fund` schema.
- Products: strictly tenant-owned in Phase 1.
- Catalogue sharing: defer.
- Date constraints: application logic first.

---

## 16. Recommended Slice 1C Implementation Plan

Slice 1C should implement Product Workflow Classes only.
For Slice 1C, A1, A2, B and C should be platform-level protected defaults, not tenant-owned records. Do not duplicate the four default workflow classes per tenant unless a later decision explicitly introduces tenant-specific workflow extensions.

Create the proposed schema diff for Slice 1C, but do not create a migration until reviewed.

Scope:

- Add minimal `fund` schema support.
- Add `FundProductWorkflowClass`.
- Add protected default classes A1, A2, B and C.
- Add read/list access for workflow classes.
- Add management only if needed for platform/admin users.
- Add audit logging for create/update if management exists.
- Add checks proving A1/A2/B/C are first-class and not cosmetic labels.

Do not include:

- Products;
- Catalogues;
- Projects;
- Events;
- Stores;
- Orders;
- Payments;
- Commissions;
- Production batching.

This keeps the first schema slice narrow and reviewable.

