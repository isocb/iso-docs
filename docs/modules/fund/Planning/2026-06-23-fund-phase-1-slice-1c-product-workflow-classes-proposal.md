# FUND Phase 1 Slice 1C - Product Workflow Classes Implementation Proposal

Date: 2026-06-23

Status: Proposal only

This document proposes the implementation approach for FUND Phase 1 Slice 1C. It does not authorise code, Prisma schema, migration, route, service, UI, seed, reset or `db:push` work.

Canonical inputs:

- `01-fund-module-brief.md`
- `02-fund-architecture-principles.md`
- `03-fund-functional-specification.md`
- `04-fund-phase-1-implementation-plan.md`
- `05-fund-open-questions.md`
- `Planning/2026-06-23-fund-phase-1-slice-1b-schema-design-proposal.md`

## Slice Goal

Slice 1C should introduce Product Workflow Classes as protected platform-level defaults for FUND.

This slice should prove the first foundational FUND concept without creating Products, Catalogues, Projects, Events, Stores, Orders, dashboards or workflow execution.

The protected defaults are:

- `A1` - Individual Artwork Project Product
- `A2` - Group Artwork Product
- `B` - Logo / Bulk Mass Customisation Product
- `C` - Standard Product

## Architectural Decision

For Slice 1C, Product Workflow Classes should be platform-level protected defaults, not tenant-owned records.

Reasoning:

- A1, A2, B and C are core platform semantics, not tenant configuration.
- The classes define how FUND understands production workflow behaviour.
- Tenant-owned extensions can be deferred until there is a proven need.
- Products and Projects will later reference these classes while remaining tenant-scoped.
- Keeping the defaults platform-level avoids duplicate A1/A2/B/C records per tenant.

## Proposed Prisma Model

The proposed model is:

```prisma
model FundProductWorkflowClass {
  id          String  @id @default(uuid())
  code        String  @unique
  name        String
  description String? @db.Text

  requiresTemplate            Boolean @default(false) @map("requires_template")
  requiresArtwork             Boolean @default(false) @map("requires_artwork")
  requiresGroupArtwork        Boolean @default(false) @map("requires_group_artwork")
  requiresPersonalisationData Boolean @default(false) @map("requires_personalisation_data")
  requiresProductionExport    Boolean @default(false) @map("requires_production_export")

  lifecycleConfig  Json @default("{}") @map("lifecycle_config")
  dashboardConfig  Json @default("{}") @map("dashboard_config")
  validationConfig Json @default("{}") @map("validation_config")

  isSystemDefault Boolean @default(true) @map("is_system_default")
  isReadOnly      Boolean @default(true) @map("is_read_only")
  isActive        Boolean @default(true) @map("is_active")
  sortOrder       Int     @default(0) @map("sort_order")

  createdAt DateTime @default(now()) @map("created_at")
  updatedAt DateTime @updatedAt @map("updated_at")

  @@index([isActive, sortOrder])
  @@index([isSystemDefault])
  @@map("fund_product_workflow_classes")
  @@schema("fund")
}
```

## Schema Placement

The model should live in the `fund` schema.

Implementation would require adding `fund` to the Prisma datasource schema list:

```prisma
schemas = ["public", "bedrock", "lmspro", "pulse", "fund"]
```

This is a schema registration change only. It should not imply tenant-owned FUND tables yet.

## Tenant Scoping

`FundProductWorkflowClass` should not have `organizationId` in Slice 1C.

The records are platform-level reference data. Tenant scoping should begin when tenant-owned FUND entities are introduced, such as Products, Catalogues, Projects and Events.

Expected future relationship:

- Tenant-owned `FundProduct` has `organizationId`.
- Tenant-owned `FundProduct` references `FundProductWorkflowClass`.
- Tenant-owned `FundProject` references tenant-owned Products/Catalogues and selected workflow behaviour through those Products.

## Default Creation Strategy

The four defaults should be created through the migration SQL, not through seed/reset commands.

Recommended approach:

- Create the `fund` schema if required.
- Create `fund_product_workflow_classes`.
- Insert A1, A2, B and C using stable values.
- Use `ON CONFLICT ("code") DO NOTHING` to keep the insert idempotent.

Recommended default behaviour flags:

| Code | requiresTemplate | requiresArtwork | requiresGroupArtwork | requiresPersonalisationData | requiresProductionExport |
| --- | --- | --- | --- | --- | --- |
| A1 | true | true | false | false | false |
| A2 | true | true | true | false | false |
| B | false | false | false | true | true |
| C | false | false | false | false | false |

The JSON config fields should initially be empty objects. They are deliberately reserved for later lifecycle/dashboard/validation configuration and should not be over-modelled in Slice 1C.

These booleans should not overstate detailed workflow requirements. A1 and A2 should not require personalisation data by default. B should require personalisation data and production export, but should not require a template or artwork by default. Later product-level configuration, validation metadata or workflow extension modelling should carry more specific logo/artwork requirements.

## Protection Strategy

The system defaults should be protected against accidental deletion or mutation.

Recommended controls:

- `code` is globally unique.
- `isSystemDefault = true`.
- `isReadOnly = true`.
- No delete mutation in Slice 1C.
- No update mutation in Slice 1C unless there is a very strong reason.
- Any future admin mutation must reject updates to read-only system defaults unless an explicit platform-admin-only maintenance path is introduced.
- Default records should be changed through reviewed migrations, not tenant administration.

## tRPC Read/List Strategy

Slice 1C should expose a read-only list endpoint only.

Recommended router:

- `src/modules/fund/routers/workflow-classes.router.ts`

Recommended procedure:

- protected procedure
- FUND feature-gated
- returns active workflow classes ordered by `sortOrder`, then `code`
- no tenant filter, because the records are platform-level reference data
- no create/update/delete procedures in Slice 1C

Expected query behaviour:

```ts
findMany({
  where: { isActive: true },
  orderBy: [{ sortOrder: "asc" }, { code: "asc" }],
})
```

## Admin and Management Strategy

No tenant-facing management UI should be built in Slice 1C.

No platform admin UI is required in Slice 1C.

If management becomes necessary later, it should be platform-admin-only and should preserve the protected nature of A1, A2, B and C.

Tenant-specific workflow extensions should remain deferred until a real tenant requirement exists.

## Audit Logging Strategy

No runtime audit logging is required for read-only listing of platform defaults.

Future mutation paths should audit:

- `FUND_WORKFLOW_CLASS_CREATED`
- `FUND_WORKFLOW_CLASS_UPDATED`
- `FUND_WORKFLOW_CLASS_ARCHIVED`
- `FUND_WORKFLOW_CLASS_PROTECTED_UPDATE_REJECTED`
- `FUND_WORKFLOW_CLASS_PROTECTED_DELETE_REJECTED`

Audit metadata should include:

- workflow class id
- workflow class code
- changed fields
- actor user id
- platform or organization context where applicable

## Tenant-Safety Implications

This slice is low tenant-risk because it introduces platform-level reference data only.

Important safeguards:

- Do not add tenant-owned FUND data yet.
- Do not add `organizationId` to the workflow class model unless the architectural decision changes.
- Do not create products, projects, events or stores in this slice.
- Do not expose tenant mutation paths.
- Ensure future tenant-owned entities reference workflow classes without allowing cross-tenant data leakage.

Because the table is platform-level reference data, it should not require the same tenant RLS policy shape as tenant-owned operational tables.

## Manual Test Checklist

When implementation is later approved, test the following:

- Prisma schema validates after adding the `fund` schema and model.
- Migration creates the `fund` schema.
- Migration creates `fund.fund_product_workflow_classes`.
- Migration creates exactly four active default rows: A1, A2, B and C.
- `code` uniqueness prevents duplicate workflow class codes.
- A1, A2, B and C have `isSystemDefault = true`.
- A1, A2, B and C have `isReadOnly = true`.
- Active list endpoint returns A1, A2, B and C in sort order.
- A tenant with the FUND feature enabled can read the list.
- A tenant without the FUND feature cannot access the list.
- There are no create, update or delete endpoints for tenant users.
- Type checking passes.
- Security scan does not flag default values.
- No Product, Catalogue, Project, Event, Store or Order table is created in this slice.

## Exact Files Likely To Change During Implementation

If approved later, Slice 1C is expected to touch only:

- `prisma/schema.prisma`
- `prisma/migrations/<timestamp>_add_fund_workflow_classes/migration.sql`
- `src/modules/fund/routers/workflow-classes.router.ts`
- `src/modules/fund/routers/index.ts`
- `src/server/core/routers/index.ts`

Optional documentation update:

- `isodocs/docs/modules/fund/Planning/2026-06-23-fund-phase-1-slice-1c-product-workflow-classes-proposal.md`

Do not change:

- Product models
- Catalogue models
- Project models
- Event models
- Store models
- Order models
- UI pages
- navigation
- dashboards
- seed/reset scripts

## Migration Risks

Overall risk: Low.

Primary risks:

- Adding the new `fund` schema to Prisma datasource configuration must be done correctly.
- The migration must be safe against repeat application in non-production environments.
- The default records must not be treated as tenant-owned data.
- The read/list endpoint must be feature-gated so FUND remains controlled by module access.
- The JSON config fields must not become a place to hide unreviewed workflow logic too early.

Mitigations:

- Keep Slice 1C narrow.
- Use migration-created defaults.
- Keep the router read-only.
- Defer tenant extensions.
- Defer Products, Projects, Events and Stores.
- Verify Prisma validation and type-checking before any promotion.

## Recommended Slice 1C Implementation Plan

1. Confirm the working branch and clean status.
2. Add `fund` to the Prisma datasource schema list.
3. Add `FundProductWorkflowClass` to `prisma/schema.prisma`.
4. Create a migration for the fund workflow class table.
5. Add migration SQL inserts for A1, A2, B and C.
6. Add a read-only FUND workflow classes router.
7. Register the FUND router in the server router tree.
8. Run Prisma validation.
9. Run type-checking.
10. Manually verify the endpoint shape if local auth/test harness allows.
11. Stop before Products, Projects, Events, Stores, Orders, UI or dashboard work.

## Do Not Build In Slice 1C

- Tenant-owned Product records
- Tenant-owned Catalogue records
- Project records
- Event records
- Store generation
- Commerce or payment logic
- Organiser dashboard
- Operations dashboard
- Production workflow execution
- Artwork upload workflows
- SeasonPro integration
- Tenant-managed custom workflow classes
- Workflow class admin UI

## Recommended Next Codex Prompt

```text
Proceed with FUND Phase 1 Slice 1C implementation for Product Workflow Classes only.

You may edit Prisma schema, create a migration, and add a read-only tRPC list router.

Do not run db:push.
Do not run seed/reset commands.
Do not create Products, Catalogues, Projects, Events, Stores, Orders, UI pages or dashboards.

Use:
- isodocs/docs/modules/fund/Planning/2026-06-23-fund-phase-1-slice-1c-product-workflow-classes-proposal.md
- isodocs/docs/modules/fund/01-fund-module-brief.md
- isodocs/docs/modules/fund/02-fund-architecture-principles.md
- isodocs/docs/modules/fund/03-fund-functional-specification.md
- isodocs/docs/modules/fund/04-fund-phase-1-implementation-plan.md

Implement only:
- fund schema registration
- FundProductWorkflowClass model
- migration-created A1/A2/B/C protected defaults
- read-only tRPC list endpoint

Run Prisma validation and type-checking when complete.
```
