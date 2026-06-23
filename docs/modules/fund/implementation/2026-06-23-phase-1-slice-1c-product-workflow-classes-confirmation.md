# Phase 1 Slice 1C — Product Workflow Classes

Date: 2026-06-23

Status: Implemented on `isostack-bedrock` `dev`

## Implementation Summary

FUND Phase 1 Slice 1C introduced Product Workflow Classes as protected platform-level defaults.

The implementation is deliberately narrow:

- registered the `fund` Prisma schema;
- added `FundProductWorkflowClass`;
- created migration SQL for the four protected defaults;
- added a read-only tRPC list endpoint;
- registered the FUND router in the application router tree.

No tenant-owned FUND operational records were created.

## Files Changed

App repository:

- `prisma/schema.prisma`
- `prisma/migrations/20260623130000_add_fund_product_workflow_classes/migration.sql`
- `src/modules/fund/routers/index.ts`
- `src/modules/fund/routers/workflow-classes.router.ts`
- `src/server/core/routers/index.ts`

Documentation repository:

- `docs/modules/fund/Planning/2026-06-23-fund-phase-1-slice-1c-product-workflow-classes-proposal.md`
- `docs/modules/fund/implementation/2026-06-23-phase-1-slice-1c-product-workflow-classes-confirmation.md`

## Prisma And Schema Changes

The Prisma datasource schema list now includes `fund`:

```prisma
schemas = ["public", "bedrock", "lmspro", "pulse", "fund"]
```

The new model is:

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

`FundProductWorkflowClass` does not include `organizationId`. These records are platform-level reference data, not tenant-owned operational data.

## Migration Created

Migration path:

```text
prisma/migrations/20260623130000_add_fund_product_workflow_classes/migration.sql
```

SQL summary:

- creates the `fund` schema if it does not exist;
- creates `fund.fund_product_workflow_classes`;
- creates a unique index on `code`;
- creates indexes on active/sort order and system-default flags;
- inserts A1, A2, B and C as protected defaults;
- uses `ON CONFLICT ("code") DO NOTHING`.

Confirmation:

- `db:push` was not used.
- Seed commands were not used.
- Reset commands were not used.

## Default Workflow Classes Created

The migration creates:

- `A1` — Individual Artwork Project Product
- `A2` — Group Artwork Product
- `B` — Logo / Bulk Mass Customisation Product
- `C` — Standard Product

All defaults are created with:

- `isSystemDefault = true`
- `isReadOnly = true`
- `isActive = true`

## Final Default Behaviour Flags

| Code | requiresTemplate | requiresArtwork | requiresGroupArtwork | requiresPersonalisationData | requiresProductionExport |
| --- | ---: | ---: | ---: | ---: | ---: |
| A1 | true | true | false | false | false |
| A2 | true | true | true | false | false |
| B | false | false | false | true | true |
| C | false | false | false | false | false |

These flags intentionally avoid over-stating workflow requirements. Detailed behaviour should be carried later by `lifecycleConfig`, `dashboardConfig`, `validationConfig`, product-level rules or future workflow extension modelling.

## tRPC Endpoint Created

Router path:

```text
src/modules/fund/routers/workflow-classes.router.ts
```

Registered under:

```text
fund.workflowClasses.list
```

Procedure:

- `list`

Access control:

- authenticated tRPC procedure through `withFeature('fund')`;
- returns active records only;
- orders by `sortOrder`, then `code`;
- no tenant filter because the records are platform-level reference data.

No create, update or delete endpoint was added.

## Deliberately Not Implemented

This slice did not implement:

- tenant-owned Product records;
- Catalogue records;
- Project records;
- Event records;
- Store records;
- Order records;
- payment logic;
- commission logic;
- production batching;
- organiser dashboard;
- operations dashboard;
- workflow class management UI;
- SeasonPro integration;
- AI workflows;
- tenant-facing create/update/delete endpoints for workflow classes.

## Checks Run And Results

Passed:

- `npx prisma validate`
- `npm run db:generate`
- `npm run type-check`
- `npm run verify`

Notes:

- `npm run verify` initially failed inside the sandbox because `tsx` could not create its IPC pipe under `/var/folders/...`.
- The same verify command passed when rerun with the required local execution permission.

Failed:

- `npm run lint`

Lint result:

- failed on existing broad repo lint issues in unrelated Bedrock, LMSPro and Pulse UI files;
- output included existing `react/no-unescaped-entities`, unused variable and `no-explicit-any` issues;
- no lint failure was reported for the new FUND router files.

## Manual Verification Checklist

Before promotion, verify:

- migration exists in source control;
- migration SQL creates `fund` schema safely;
- migration SQL inserts exactly A1, A2, B and C;
- A1, A2, B and C use the corrected final behaviour flags above;
- `db:push` was not used;
- seed/reset commands were not used;
- Prisma schema validates;
- Prisma client generates;
- TypeScript type-check passes;
- `fund.workflowClasses.list` is available in the tRPC router tree;
- a user with the FUND feature can read active workflow classes;
- a user without the FUND feature receives a forbidden response;
- no tenant-facing mutation endpoint exists.

## Risks Or Follow-Up Issues

Overall implementation risk: Low.

Known considerations:

- The `fund` schema is newly registered in Prisma and should be applied through normal migration deployment.
- The table is platform-level reference data, so it intentionally has no `organizationId`.
- Future tenant-owned FUND tables must still use explicit `organizationId` tenancy.
- The current repo lint script is not clean across unrelated existing UI files.
- No runtime UI currently consumes the endpoint.

## Recommended Next Slice

Recommended next slice:

```text
Phase 1 Slice 1D — Tenant-owned Products and Catalogues schema proposal
```

The next slice should remain schema/design focused before implementation because product ownership, producer access and catalogue exposure have tenant-safety implications.

## Suggested Next Codex Prompt

```text
Proceed with FUND Phase 1 Slice 1D planning only: tenant-owned Products and Catalogues schema proposal.

Do not edit code yet.
Do not edit Prisma schema yet.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.

Use the active FUND docs and the Slice 1B/1C planning and implementation notes.

Focus on tenant-owned Products, Catalogues, Product-to-Workflow-Class relationships, catalogue visibility, producer ownership, tenant safety, audit requirements, indexes, uniqueness constraints, and open decisions before implementation.
```
