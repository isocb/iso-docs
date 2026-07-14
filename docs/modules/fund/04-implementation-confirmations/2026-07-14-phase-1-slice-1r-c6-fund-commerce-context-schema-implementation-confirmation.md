# FUND Phase 1 Slice 1R-C6 - FUND Commerce Context Schema Implementation Confirmation

Date: 2026-07-14

Status: Implemented and validated on disposable PostgreSQL / application committed locally at `9947669` / no shared deployment

Planning record:

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1r-c6-fund-commerce-context-schema-implementation-planning.md`

Review/test record:

`docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1r-c6-r1-fund-commerce-context-schema-review-and-test.md`

## 1. Implemented Boundary

Implemented only the accepted typed FUND evidence foundation keyed to generic Commerce A2
Orders and Order lines:

- `FundOrderContext` for exact Project, Store, Client, delivery and optional provisional
  commission-assignment observation;
- `FundOrderLineContext` for exact Commerce line, Store Product, Project Product, Product
  and immutable configuration-version ownership;
- `FundOrderLineInputSnapshot` for typed value, multi-select, presence, validation and
  signed price-modifier evidence;
- `FundOrderLineAssetSnapshot` for multiple exact immutable Production Asset versions and
  explicit purchaser-artwork backup role/purpose evidence.

No checkout or Order creation service, Store readiness/publication, payment, refund,
pro-forma, provider, Stripe, upload, scanning, production authorization/projection,
commission calculation, API, route or UI was added.

## 2. Application Files

```text
prisma/schema.prisma
prisma/migrations/20260714235900_fund_1r_c6_commerce_context_foundation/migration.sql
scripts/verify-fund-1r-c6-schema.ts
scripts/verify-fund-1r-c6-pre-migration.sql
scripts/verify-fund-1r-c6-database.sql
scripts/run-fund-1r-c6-database-tests.ts
scripts/verify-commerce-a1-schema.ts
scripts/verify-fund-1r-c4-schema.ts
```

The two earlier verifier changes are prospective maintenance only: A1 now verifies its own
four-enum/Seller Profile contract while permitting accepted later Commerce models, and C4
verifies that its own migration did not add the Order-line asset relation while permitting
C6 to add that deferred model now.

## 3. Schema Delivered

Added seven Fund-prefixed enums:

```text
FundOrderProductionStatus
FundOrderFulfilmentStatus
FundOrderLineArtworkReadinessStatus
FundOrderLineProductionUnitProjectionStatus
FundOrderLineInputPresenceStatus
FundOrderLineInputValidationStatus
FundOrderLineAssetRole
```

Added four FUND tables:

```text
fund.fund_order_contexts
fund.fund_order_line_contexts
fund.fund_order_line_input_snapshots
fund.fund_order_line_asset_snapshots
```

The migration also adds only these supporting generic/source keys:

```text
commerce.commerce_order_lines (organization_id, id, order_id)
fund.fund_project_store_products
  (organization_id, id, store_id, project_id, project_product_id, product_id)
```

Reverse Prisma relation fields permit client generation but do not transfer creation or
lifecycle ownership from Commerce to FUND.

## 4. Exact Identity And Evidence

Database foreign keys enforce:

- one typed context per exact tenant/Commerce Order;
- one line context per exact tenant/Commerce Order line and owning Order;
- identical parent Store/Project ownership;
- exact Store Product/Project Product/Product tuple;
- exact immutable Store Product configuration version;
- exact Project/Client, optional Project/Event, delivery profile/Project and provisional
  commission assignment/Project ownership;
- exact input definition provenance;
- exact logical Production Asset and immutable asset-version ownership.

Required delivery/project/workflow snapshots are nonblank and country codes are uppercase.
Commission observation ID/timestamp is paired. Input presence and validation shapes,
selected-choice JSON arrays, revision/sort evidence and purchaser-backup role/purpose are
checked in PostgreSQL.

Signed input modifiers remain evidence. Later checkout logic must map negative values to
Commerce discount fields; C6 performs no monetary reconciliation.

## 5. Migration And Data Preservation

Migration `20260714235900_fund_1r_c6_commerce_context_foundation` advances the inventory
from 136 to 137.

It creates no Order context, line context, input snapshot or asset snapshot and changes no
existing commercial or FUND value. It refuses any pre-existing case-normalized
`sourceModuleCode = FUND` Commerce Order because typed history cannot be inferred safely.
Representative generic non-FUND Commerce Order/line evidence remained exact.

## 6. Validation Completed

Passed:

- Prisma format, multi-schema validation and client generation;
- dedicated C6 schema/migration verification;
- Commerce A1/A2 and FUND C1/C2/C3/C4/C5/R3-A/R3-D static regressions;
- TypeScript type-check, repository critical-file verification and targeted verifier lint;
- expected migration refusal with rollback resolution;
- representative 136-to-137 migration with exact source preservation and zero backfill;
- complete fresh application of all 137 migrations;
- Event-scoped and standalone contexts, multi-select/signed/optional/incomplete input and
  multi-file purchaser-backup evidence;
- duplicate, cross-tenant, mismatched identity, check and restrictive-deletion cases;
- C6-owned database-to-Prisma drift inspection;
- final zero-residue cleanup and `git diff --check`.

Final disposable inventory:

```text
applied migrations: 137
failed migrations: 0
residual C6 rows: 0
residual C6 fixture rows: 0
```

## 7. Database Safety And Deployment

The test runner proved `TEST_DATABASE_URL` distinct from `DATABASE_URL` before every
connection and derived the matching direct Neon endpoint only in process memory. No
credential or connection string was printed or committed.

No shared development, staging or production database was contacted or modified.
Application commit `9947669` exists locally on `dev`; remote push and shared deployment are
separate release actions and are not claimed here.

## 8. Honest Behaviour Boundary

C6 stores typed evidence only. Reverse relations and status vocabulary provide no runtime
creation, transition, payment, production, retention or commission behavior. The public
backup photograph is a conditional production backstop, not proof of payment, receipt of
the physical original or authorization to select the backup for production.
