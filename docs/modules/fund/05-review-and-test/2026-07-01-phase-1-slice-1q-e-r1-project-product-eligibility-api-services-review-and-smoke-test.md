# FUND Phase 1 Slice 1Q-E-R1 - Project Product Eligibility API/Services Review And Smoke Test

Date: 2026-07-01

Status: Passed - developer/API smoke

## 1. Slice

```text
1Q-E-R1 - Project Product Eligibility API/Services Review And Smoke Test
```

Reviewed implementation slice:

```text
1Q-E - Project Product Eligibility API/Services
```

Implementation confirmation:

```text
docs/modules/fund/04-implementation-confirmations/2026-07-01-phase-1-slice-1q-e-project-product-eligibility-api-services-confirmation.md
```

Application commit:

```text
7a7354a feat(fund): add project product eligibility services
```

## 2. Review Scope

Reviewed the 1Q-E read-only eligibility implementation:

- validation input for Project eligibility requests;
- `fund.productEligibility.listForProject` router surface;
- Product eligibility service;
- router registration under `fund.productEligibility`;
- Event-linked source Catalogue eligibility;
- standalone/default Catalogue eligibility;
- Product Project type suitability;
- Product organisation type suitability where context is available;
- Product deduplication with source Catalogue context;
- explicit boundary against Product picker UI, Store, Orders and Commerce.

Application files reviewed:

- `src/modules/fund/lib/validation/product-eligibility.ts`;
- `src/modules/fund/services/product-eligibility.service.ts`;
- `src/modules/fund/routers/product-eligibility.router.ts`;
- `src/modules/fund/routers/index.ts`.

## 3. Browser Smoke Boundary

```text
1Q-E has no visible browser UI.
```

Operator/browser smoke is not applicable for the new 1Q-E behaviour because no browser
surface was intentionally added.

Browser smoke for 1Q-E is limited to negative/regression confirmation:

- existing protected FUND routes should still load;
- no C2 Product picker UI should appear;
- no Store, Orders or Commerce behaviour should appear.

C1 operator-visible testing resumes in 1Q-F, when the Project Product picker consumes
`fund.productEligibility.listForProject`.

## 4. Checks Run

```text
npx prisma validate
```

Result:

```text
Passed.
```

```text
npx eslint src/modules/fund/lib/validation/product-eligibility.ts src/modules/fund/services/product-eligibility.service.ts src/modules/fund/routers/product-eligibility.router.ts src/modules/fund/routers/index.ts
```

Result:

```text
Passed.
```

```text
npm run type-check
```

Initial result:

```text
Failed inside the managed sandbox because TypeScript could not write tsconfig.tsbuildinfo.
```

Resolution:

```text
Reran outside the sandbox.
```

Final result:

```text
Passed.
```

```text
npm run verify
```

Initial result:

```text
Failed inside the managed sandbox because tsx could not create its IPC pipe.
```

Resolution:

```text
Reran outside the sandbox.
```

Final result:

```text
Passed.
```

```text
git diff --check
```

Result:

```text
Passed.
```

## 5. API/Service Smoke

Smoke method:

```text
NODE_PATH=/Volumes/isostack/Git/isostack-bedrock/node_modules npx tsx /private/tmp/fund-1qe-smoke.ts
```

The first sandbox attempt failed because `tsx` could not create its IPC pipe. The smoke
runner was rerun outside the sandbox.

The smoke runner used transaction-scoped temporary test data and deliberately rolled the
transaction back after assertions passed. No smoke-test FUND records were left behind.

Result:

```text
Passed.
```

Smoke output summary:

```text
status: passed
rolledBack: true
eventEligibleProductCount: 3
standaloneEligibleProductCount: 1
missingSourceWarnings:
- ORGANIZATION_TYPE_MISSING
- NO_SOURCE_CATALOGUES
```

Confirmed cases:

- Event-linked Project with active Event Catalogue returns eligible Products.
- Standalone Project with default standalone Catalogue returns eligible Products.
- Product available through multiple eligible Catalogues appears once with multiple source Catalogue references.
- Product with matching active Project type suitability remains eligible.
- Product with non-matching active Project type suitability is filtered out.
- Product with no suitability rows remains eligible after source availability passes.
- Missing source availability returns an empty list plus warning.
- Cross-tenant Project access is rejected/not found.
- No `FundProjectProduct` rows are created.

## 6. Static Review Result

Static review confirms:

- source availability is mandatory;
- Event-linked eligibility is derived from active Event Catalogue availability;
- standalone eligibility is derived from default standalone Catalogues;
- `INTERNAL_ONLY` Catalogues do not feed eligibility;
- inactive/archived Events, Catalogues, Catalogue Product memberships and Products are excluded;
- Products are deduplicated by `productId`;
- source Catalogue context is retained on each eligible Product;
- missing active suitability rows mean unrestricted for that suitability dimension;
- active suitability rows narrow eligibility;
- the service is read-only and does not create `FundProjectProduct` rows;
- no C2 Product picker UI, Store, Orders, Commerce, production, dispatch, notifications or SeasonPro integration was added.

## 7. Boundary Confirmation

Confirmed still out of scope:

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
- production/artwork/dispatch workflows;
- notifications;
- SeasonPro integration.

## 8. Review Outcome

1Q-E-R1 review outcome:

```text
Pass: static checks, type-check, targeted ESLint, verify and transaction-scoped API/service smoke are accepted for 1Q-E.
```

No operator-visible browser smoke is expected for 1Q-E. The implementation is ready to be
consumed by the 1Q-F Catalogue-centric Project Product picker UI remediation.

## 9. Recommended Next Step

Proceed to:

```text
1Q-F - Catalogue-Centric Project Product Picker UI Remediation
```

1Q-F should consume:

```text
fund.productEligibility.listForProject
```

1Q-F must make eligibility visible in the Project Product picker, grouped by source
Catalogue, deduplicated by Product identity and preserving one shared selected Product
state for `FundProjectProduct`.
