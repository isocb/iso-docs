# FUND Phase 1 Slice 1Q-E - Project Product Eligibility API/Services Confirmation

Date: 2026-07-01

Status: Implemented locally - review/test pending

## 1. Slice Summary

Implemented read-only Project Product eligibility API/services for FUND.

The new service answers:

```text
For this Project, which Products are eligible to be selected into FundProjectProduct?
```

It derives eligibility from:

- Event-linked Catalogue availability;
- standalone/default Catalogue availability;
- active Catalogue Product membership;
- Product Project type suitability;
- Product organisation type suitability where Client organisation type is available;
- same-tenant Project, Event, Client, Catalogue and Product context.

The slice does not create, update or delete `FundProjectProduct` rows.

## 2. API Surface Added

New tRPC namespace:

```text
fund.productEligibility.*
```

New procedure:

```text
fund.productEligibility.listForProject
```

Input:

```text
projectId
evaluationAt?
projectTypeCode?
organizationTypeCode?
```

Output includes:

- Project summary;
- source mode: `EVENT` or `STANDALONE`;
- evaluation timestamp;
- source Catalogue groups;
- deduplicated eligible Products;
- Product source Catalogue references;
- active suitability codes;
- existing active Project Product membership state where present;
- warnings for missing context, missing sources or empty eligibility.

## 3. Eligibility Behaviour Implemented

Source availability remains mandatory:

- Event-linked Projects use active Event Catalogue availability for the linked active Event.
- Standalone Projects use active default standalone Catalogues.
- `INTERNAL_ONLY` Catalogues never feed eligibility.
- Event source scopes are `EVENT_ONLY` and `EVENT_AND_STANDALONE`.
- Standalone source scopes are `STANDALONE_ONLY` and `EVENT_AND_STANDALONE`.

Status/archive exclusions:

- archived Projects are rejected;
- inactive/archived Events produce no Event source Products and return a warning;
- inactive/archived Catalogues are excluded;
- inactive Catalogue Product memberships are excluded;
- inactive/archived Products are excluded;
- inactive Workflow Classes are excluded.

Suitability policy:

- Products with no active Project type suitability rows are unrestricted for Project type.
- Products with active Project type suitability rows require a matching Project type.
- Products with no active organisation type suitability rows are unrestricted for organisation type.
- Products with active organisation type suitability rows require a matching organisation type when available.
- If organisation type context is missing, the response includes a warning rather than failing the whole request.

Deduplication policy:

- eligible Products are deduplicated by `productId`;
- each eligible Product includes all source Catalogue references;
- each source Catalogue group lists the eligible Product ids it contributes;
- Product identity remains the final selection unit for later `FundProjectProduct` membership.

## 4. Files Changed

Application files:

- `src/modules/fund/lib/validation/product-eligibility.ts`;
- `src/modules/fund/services/product-eligibility.service.ts`;
- `src/modules/fund/routers/product-eligibility.router.ts`;
- `src/modules/fund/routers/index.ts`.

Documentation files:

- `docs/modules/fund/04-implementation-confirmations/2026-07-01-phase-1-slice-1q-e-project-product-eligibility-api-services-confirmation.md`;
- `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`.

## 5. Explicit Non-Goals Confirmed

This slice did not implement:

- Prisma schema changes;
- migrations;
- C2 Product picker UI;
- Project Product auto-selection;
- `FundProjectProduct` creation or mutation;
- Store;
- Orders;
- Commerce;
- Sales/Reporting;
- Product duplication;
- Catalogue duplication;
- Product media galleries;
- Product option modelling;
- option-to-image mapping;
- production/artwork/dispatch workflows;
- notifications;
- SeasonPro integration.

No `db:push` was run.

No seed or reset commands were run.

## 6. Checks Run

```text
npx prisma validate
```

Result: passed.

```text
npx eslint src/modules/fund/lib/validation/product-eligibility.ts src/modules/fund/services/product-eligibility.service.ts src/modules/fund/routers/product-eligibility.router.ts src/modules/fund/routers/index.ts
```

Result: passed.

```text
npm run type-check
```

Initial result: sandbox could not write `tsconfig.tsbuildinfo`.

Resolution: reran outside the sandbox.

Final result: passed.

```text
npm run verify
```

Initial result: sandbox `tsx` IPC pipe error.

Resolution: reran outside the sandbox.

Final result: passed.

```text
git diff --check
```

Result: passed.

## 7. Risks And Follow-Ups

- 1Q-E is C1-admin safe first; any future C2-facing eligibility procedure must derive Project access from authenticated Client membership/context.
- Project type suitability cannot be evaluated where Project type is missing; Products with active Project type suitability rows are excluded and a warning is returned.
- Organisation type suitability returns a warning instead of failing the whole request when organisation type context is missing.
- 1Q-F must consume `fund.productEligibility.listForProject` rather than `fund.products.list`.
- 1Q-F must keep grouped Catalogue UX and one shared Product selection state by `productId`.
- Store generation must use `FundProjectProduct`, not raw Event/Catalogue availability.

## 8. Recommended Next Step

Proceed to:

```text
1Q-E-R1 - Project Product Eligibility API/Services Review And Smoke Test
```

Review/test should confirm:

- Event-linked Project with active Event Catalogue returns eligible Products;
- standalone Project with default standalone Catalogue returns eligible Products;
- Product available through multiple eligible Catalogues appears once with multiple source Catalogue references;
- Product with matching active Project type suitability remains eligible;
- Product with non-matching active Project type suitability is filtered out;
- Product with no suitability rows remains eligible after source availability passes;
- missing source availability returns an empty list plus warning;
- cross-tenant Project access is rejected/not found;
- no `FundProjectProduct` rows are created.
