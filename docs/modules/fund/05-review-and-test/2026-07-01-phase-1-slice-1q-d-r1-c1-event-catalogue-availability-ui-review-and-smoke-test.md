# FUND Phase 1 Slice 1Q-D-R1 - C1 Event Catalogue Availability UI Review And Smoke Test

## 1. Slice

```text
1Q-D-R1 - C1 Event Catalogue Availability UI Review And Smoke Testing
```

Reviewed implementation slice:

```text
1Q-D - C1 Event Catalogue Availability UI
```

Implementation confirmation:

```text
docs/modules/fund/04-implementation-confirmations/2026-07-01-phase-1-slice-1q-d-c1-event-catalogue-availability-ui-confirmation.md
```

## 2. Review Scope

Reviewed the 1Q-D C1 Product Manager UI work:

- Products and Catalogues page tab integration;
- new Availability tab;
- Event-to-Catalogue availability controls;
- standalone/default Catalogue availability controls;
- Product Project type suitability controls;
- Product organisation type suitability controls;
- use of existing `fund.availability.*` API/services;
- explicit boundary against C2 Product picker, Store, Orders and Commerce behaviour.

Application files reviewed:

- `src/app/(app)/app/fund/products/page.tsx`;
- `src/modules/fund/components/availability/AvailabilityManager.tsx`.

## 3. Static Review Result

Static review confirms:

- Availability is exposed as a C1 Product Manager tab under `/app/fund/products`;
- Event Catalogue configuration uses existing Event/Catalogue list queries and `fund.availability.setEventCatalogues`;
- Event Catalogue availability supports active/inactive state, sort order and optional availability windows;
- standalone Catalogue availability uses `fund.availability.updateCatalogueAvailability`;
- default standalone selection is disabled when the selected Catalogue scope does not support standalone availability;
- Product suitability uses `fund.availability.getProductSuitability`, `setProductProjectTypes` and `setProductOrganizationTypes`;
- Project type labels match the accepted public/C2 wording;
- organisation type labels match the stable first-pass public Project initiation codes;
- no schema, migration, C2 Product picker, Project Product auto-selection, Store, Orders or Commerce behaviour was added.

## 4. Checks Run

```text
npm run type-check
```

Result:

```text
Passed.
```

```text
npx eslint src/modules/fund/components/availability/AvailabilityManager.tsx src/app/\(app\)/app/fund/products/page.tsx
```

Result:

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

```text
npm run verify
```

Initial result:

```text
Failed inside the managed sandbox because `tsx` could not create its IPC pipe.
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
npm run lint
```

Result:

```text
Failed on pre-existing unrelated repository-wide lint issues outside the 1Q-D changed files.
```

The changed 1Q-D files passed targeted ESLint.

## 5. Local Route Smoke

Started the local Next dev server.

Sandbox result:

```text
npm run dev
```

Initial result:

```text
Failed inside the managed sandbox because the server could not bind to port 3000.
```

Resolution:

```text
Reran outside the sandbox.
```

Server result:

```text
Next dev server started on http://localhost:3001 because port 3000 was already in use.
```

Route check:

```text
curl -I http://localhost:3001/app/fund/products
```

Result:

```text
HTTP/1.1 307 Temporary Redirect
location: /auth/signin?callbackUrl=%2Fapp%2Ffund%2Fproducts
```

This confirms the route compiles and remains protected when unauthenticated.

The dev server was stopped after the route smoke check.

## 6. Authenticated Browser Smoke Status

Authenticated C1 browser smoke testing is accepted as passed by operator confirmation on 2026-07-01.

Confirmation summary:

- the 1Q-D C1 Availability UI is technically acceptable;
- static checks, type-check, targeted ESLint, route smoke and verify passed;
- detailed C1 UI/UX revisions are deliberately deferred to a later refinement pass;
- the previous authenticated C1 browser smoke caveat is closed for this slice.

Accepted smoke coverage:

- sign in as a FUND C1 admin user;
- open `/app/fund/products`;
- confirm Products, Catalogues and Availability tabs render;
- open the Availability tab;
- select an Event;
- add an active Catalogue;
- set sort order and optional availability dates;
- save Event Catalogue availability;
- refresh and confirm the saved Event Catalogue state reloads;
- change a Catalogue availability scope;
- toggle default standalone where allowed;
- save and confirm the Catalogue availability state reloads;
- select a Product;
- set one or more Project type suitability values;
- set one or more organisation type suitability values;
- save and confirm the Product suitability state reloads;
- confirm archived Events, Catalogues and Products are not offered for new configuration through the default current-list UI;
- confirm no C2 Product picker, Store, Orders or Commerce behaviour appears.

## 7. Boundary Confirmation

Confirmed still out of scope:

- Prisma schema changes;
- migrations;
- C2 Product picker;
- Project Product eligibility API/services for C2;
- Project Product auto-selection;
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

1Q-D-R1 review outcome:

```text
Pass: static checks, type-check, targeted ESLint, local unauthenticated route smoke, verify and operator-confirmed authenticated C1 browser smoke are accepted for 1Q-D.
```

The C1 Availability UI is technically acceptable for the 1Q lane. Detailed UI/UX revisions should be handled in the refinement pass rather than blocking 1Q-E.

## 9. Recommended Next Step

Proceed to:

```text
1Q-E - Project Product Eligibility API/Services
```

1Q-E must define and implement Product eligibility query behaviour using:

- Event-linked Catalogue availability;
- standalone/default Catalogue availability;
- Product Project type suitability;
- Product organisation type suitability;
- same-tenant checks;
- archived/inactive exclusion.

The 1Q-E planning document now locks the no-suitability-rows policy: Products with no active suitability rows remain unrestricted for that suitability dimension after source availability passes.

The 1Q-F planning document now locks the follow-on picker direction: group eligible Products by source Catalogue, deduplicate by Product identity and keep one shared selected Product state for `FundProjectProduct`.
