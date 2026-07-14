# FUND Phase 1 Slice 1R-D - Store Readiness And C1 Configuration API/Services Implementation Confirmation

Date: 2026-07-14

Status: Implemented and validated on disposable PostgreSQL / application committed locally at `db85fcc` / no shared deployment

Planning record:

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1r-d-store-readiness-c1-configuration-api-services-implementation-planning.md`

Review/test record:

`docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1r-d-r1-store-readiness-c1-configuration-api-services-review-and-test.md`

## 1. Implemented Boundary

Implemented only the accepted internal C1 Store configuration service/API boundary:

- idempotent Project Store preparation and Store Product synchronisation;
- Product-authoritative Project Product commercial/tax snapshot refresh;
- deterministic eligibility, media, input and required-asset readiness;
- immutable canonical Store Product configuration versions;
- Store-owned copy, visibility, ordering and primary Product-media selection;
- guarded publish, pause, resume, close and archive transitions;
- exact C2-accepted commission evidence as a first-publication prerequisite;
- deep, transactional and retry-safe Product duplication into explicitly selected
  Catalogues.

No Prisma schema or migration, public Store, C2 acceptance, checkout, Commerce Order,
payment/refund/pro-forma/provider, upload/scanning, production workflow, commission
calculation, route page or UI was added.

## 2. Application Files

```text
src/modules/fund/lib/store-configuration.ts
src/modules/fund/lib/store-configuration.test.ts
src/modules/fund/lib/validation/store-management.ts
src/modules/fund/lib/validation/products-catalogues.ts
src/modules/fund/services/store-management.service.ts
src/modules/fund/services/product-eligibility.service.ts
src/modules/fund/services/products.service.ts
src/modules/fund/services/projects.service.ts
src/modules/fund/routers/store-management.router.ts
src/modules/fund/routers/products.router.ts
src/modules/fund/routers/index.ts
scripts/verify-fund-1r-d-store-services.ts
scripts/run-fund-1r-d-store-service-tests.ts
```

## 3. Store Configuration Contract

All mutations derive tenant identity from the authenticated C1 actor, use serializable
transactions and acquire a transaction advisory lock keyed by tenant plus Project. Store
creation is idempotent and creates at most one Store Product for each active Project
Product.

Refresh preserves Store-owned display copy and visibility while re-evaluating:

- 1Q-E Product eligibility;
- Product status, workflow, price, VAT/tax and currency;
- managed same-tenant Product media and primary-media selection;
- Product, Project Product and Store Product input precedence;
- required Project and presentation Production Assets.

Canonical snapshots are hashed. An unchanged hash reuses the current immutable version;
changed source or Store-owned configuration creates the next insert-only version. Project
Product snapshots are touched only when their resolved commercial evidence actually
changes.

## 4. Publication And Lifecycle

Publication recalculates readiness inside the same lock and requires an active,
unarchived, not-yet-closed Project, a delivery profile, at least one visible READY Store
Product and exact current C2-accepted commission-assignment evidence whose close snapshot
matches `Project.closesAt`.

C1 publication is an operational transition after C2 acceptance, not a C1 moderation
decision. First publication records the same immutable instant on the Store and accepted
assignment atomically. Project opening in the future does not block publication; runtime
trading remains governed later by authoritative Project dates.

## 5. Product Duplication

The duplicate procedure serializes on tenant plus target code/slug, validates an active
same-tenant source and explicit available target Catalogues, and creates a DRAFT Product
with independent identity and revision 1. It copies Product values, managed media
associations, Project/organisation-type suitability, input definitions, choices and
choice-media mappings.

No source Catalogue membership is inferred. Exact retry requires the same source, target
identity, name and target Catalogue set. Injected failure rolls back Product, children,
memberships and audit evidence together.

## 6. Validation Completed

Passed:

- Prisma multi-schema validation;
- TypeScript type-check and repository critical-file verification;
- targeted ESLint with zero errors;
- four pure configuration/hash/precedence/lifecycle unit tests;
- dedicated 1R-D static contract verification;
- Commerce A1/A2, FUND C1-C6 and R3-A/R3-B/R3-C/R3-D static regressions;
- disposable PostgreSQL service, tenant, readiness, lifecycle, duplication, concurrency
  serialization and rollback checks;
- exact 137/0 migration inventory and zero prefixed test residue;
- `git diff --check`.

## 7. Database Safety And Deployment

The runner compared connection identity and refused execution unless `TEST_DATABASE_URL`
differed from `DATABASE_URL`. It used only the retained disposable Neon test database and
reported no connection string or credential.

No shared development, staging or production database was contacted or modified. No
migration was created or applied. Application commit `db85fcc` exists locally on `dev`;
remote push and deployment remain separate release actions.

## 8. Honest Behaviour Boundary

The new router is an internal C1 procedure boundary only. It does not render a Store,
activate a public route, collect C2 acceptance, create a basket/Order, take payment, upload
media, calculate commission or authorize production.
