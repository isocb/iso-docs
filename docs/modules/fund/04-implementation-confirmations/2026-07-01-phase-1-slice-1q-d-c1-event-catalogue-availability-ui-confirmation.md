# FUND Phase 1 Slice 1Q-D - C1 Event Catalogue Availability UI Confirmation

Date: 2026-07-01

Status: Implemented

## 1. Slice Summary

Implemented the C1 Product Manager UI for configuring Event-to-Catalogue availability, standalone/default Catalogue availability and Product suitability rules.

This builds on the 1Q-B schema foundation and 1Q-C `fund.availability.*` API/services. It does not implement C2 Product picker behaviour, Store, Orders, Commerce, Project Product auto-selection, Product eligibility services for C2 or production workflows.

## 2. UI Surface Added

Added a new Product Manager tab:

```text
/app/fund/products -> Availability
```

The tab is part of the existing C1 Products and Catalogues page.

It provides three C1 configuration panels:

- Event Catalogues;
- Standalone Catalogue Availability;
- Product Suitability.

## 3. Event Catalogue Availability UI

The Event Catalogues panel lets C1 Product Manager users:

- select an Event;
- view existing Event/Catalogue availability;
- add Catalogues to the Event availability set;
- remove Catalogues from the submitted set;
- set active/inactive state;
- set sort order;
- set optional availability windows;
- save through `fund.availability.setEventCatalogues`.

The UI uses existing Event and Catalogue list queries and does not create Project Product memberships.

This configures eligibility only.

## 4. Standalone Catalogue Availability UI

The Standalone Catalogue Availability panel lets C1 Product Manager users:

- view current Catalogues;
- set `availabilityScope`;
- set `isDefaultStandalone` where the selected scope supports standalone availability;
- save through `fund.availability.updateCatalogueAvailability`.

The UI prevents default standalone selection for Event-only or internal-only Catalogue scopes.

This establishes standalone/default availability configuration only. It does not expose Products to C2 users by itself.

## 5. Product Suitability UI

The Product Suitability panel lets C1 Product Manager users:

- select a Product;
- view active suitability rules;
- configure supported Project type / fundraising format codes;
- configure supported Client organisation type codes;
- save through:
  - `fund.availability.setProductProjectTypes`;
  - `fund.availability.setProductOrganizationTypes`.

Project type labels match the accepted public/C2 wording:

- Individual Artwork Project;
- Group personalised product project;
- Bulk order / club-funded project;
- Not sure yet.

Organisation type labels use the stable first-pass codes from the public Project initiation flow:

- School;
- Playgroup;
- Club;
- PTA / Friends group;
- Charity / community group;
- Other.

## 6. Files Changed

Application files:

- `src/app/(app)/app/fund/products/page.tsx`;
- `src/modules/fund/components/availability/AvailabilityManager.tsx`.

Documentation files:

- `docs/modules/fund/04-implementation-confirmations/2026-07-01-phase-1-slice-1q-d-c1-event-catalogue-availability-ui-confirmation.md`.

## 7. Explicit Non-Goals Confirmed

This slice did not implement:

- Prisma schema changes;
- migrations;
- C2 Product picker;
- Project Product eligibility API/services for C2;
- Project Product auto-selection;
- Project Product inheritance or snapshots;
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

## 8. Checks Run

```text
npm run type-check
```

Result: passed.

```text
npx eslint src/modules/fund/components/availability/AvailabilityManager.tsx src/app/\(app\)/app/fund/products/page.tsx
```

Result: passed.

```text
git diff --check
```

Result: passed.

```text
npm run verify
```

Initial result: sandbox `tsx` IPC pipe error.

Resolution: reran outside the sandbox.

Final result: passed.

```text
npm run lint
```

Result: failed on pre-existing unrelated repository-wide lint issues outside the 1Q-D changed files. The changed 1Q-D files passed targeted ESLint.

## 9. Testing Expectations

Post-review status:

```text
1Q-D-R1 is accepted as passed by operator confirmation on 2026-07-01.
```

Static checks, route smoke and authenticated C1 browser smoke are accepted for this slice. Detailed UI/UX revisions are deferred to a later refinement pass and do not block 1Q-E.

Accepted C1 smoke path:

1. Sign in as a FUND C1 admin user.
2. Open `/app/fund/products`.
3. Confirm the Product Manager tabs show Products, Catalogues and Availability.
4. Open the Availability tab.
5. Event Catalogues:
   - select an Event;
   - add an active Catalogue;
   - set sort order;
   - optionally set availability dates;
   - save;
   - refresh and confirm the saved state reloads.
6. Standalone Catalogue Availability:
   - change a Catalogue availability scope;
   - toggle default standalone where allowed;
   - save;
   - refresh and confirm the saved state reloads.
7. Product Suitability:
   - select a Product;
   - select one or more Project types;
   - select one or more organisation types;
   - save;
   - refresh and confirm the saved state reloads.
8. Confirm archived Events, Catalogues and Products are not offered for new configuration through the default current-list UI.
9. Confirm no C2 Product picker, Store, Orders or Commerce behaviour appears.

Expected route behaviour:

- unauthenticated access to `/app/fund/products` redirects to sign-in;
- authenticated C1 admin access shows the Availability tab;
- non-admin FUND users should remain governed by existing `assertFundAdmin` API protections.

## 10. Risks And Follow-Ups

- 1Q-E planning now locks Product eligibility query behaviour: Products with no active suitability rows remain unrestricted for that suitability dimension after source availability passes.
- 1Q-E must consume Event/standalone Catalogue availability and Product suitability as eligibility inputs without creating Project Product memberships directly.
- 1Q-F must update the Project Product picker to use eligible Products as the source list, group Products by source Catalogue, deduplicate by Product identity and keep `FundProjectProduct` as the selected subset.
- Store generation must use `FundProjectProduct`, not raw Event/Catalogue availability.
- Product media, options and richer Catalogue presentation remain deferred Product Manager refinement unless Store MVP planning makes them blockers.

## 11. Recommended Next Slice

```text
1Q-E - Project Product Eligibility API/Services
```

Goal:

```text
Implement tenant-scoped Project Product eligibility API/services that derive eligible Products from Event-linked or standalone Catalogue availability, Product Project type suitability and Product organisation type suitability, without implementing C2 Product picker UI, Store, Orders or Commerce behaviour.
```

## 12. Fresh Chat Prompt

```text
We are working on IsoStack FUND.

Current app branch:
dev

Current completed slice:
1Q-D - C1 Event Catalogue Availability UI

Read first:
- isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md
- isodocs/docs/modules/fund/03-slice-planning/2026-06-30-fund-phase-1-slice-1q-event-catalogue-product-availability-and-workflow-suitability-planning.md
- isodocs/docs/modules/fund/03-slice-planning/2026-06-30-fund-phase-1-slice-1q-a-product-catalogue-suitability-schema-options-planning.md
- isodocs/docs/modules/fund/03-slice-planning/2026-07-01-fund-phase-1-slice-1q-e-project-product-eligibility-api-services-planning.md
- isodocs/docs/modules/fund/03-slice-planning/2026-07-01-fund-phase-1-slice-1q-f-catalogue-centric-project-product-picker-ui-planning.md
- isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1q-b-event-catalogue-availability-schema-implementation-confirmation.md
- isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1q-c-c1-event-catalogue-availability-api-services-confirmation.md
- isodocs/docs/modules/fund/04-implementation-confirmations/2026-07-01-phase-1-slice-1q-d-c1-event-catalogue-availability-ui-confirmation.md
- isodocs/docs/modules/fund/05-review-and-test/2026-07-01-phase-1-slice-1q-d-r1-c1-event-catalogue-availability-ui-review-and-smoke-test.md

Proceed with:
1Q-E - Project Product Eligibility API/Services

Goal:
Implement tenant-scoped Project Product eligibility API/services that derive eligible Products from Event-linked or standalone Catalogue availability, Product Project type suitability and Product organisation type suitability, without implementing C2 Product picker UI, Store, Orders or Commerce behaviour.

Important boundaries:
- Availability is the source list.
- `FundProjectProduct` remains the selected Product list.
- Do not auto-create Project Product memberships in 1Q-E unless explicitly planned.
- Do not implement C2 Product picker UI.
- Do not implement Store, Orders, Commerce, Sales/Reporting, Product media galleries, Product options, production, dispatch, notifications or SeasonPro integration.
- Preserve same-tenant checks and archived/inactive exclusion.
- Use the accepted no-suitability-rows policy: missing active suitability rows mean unrestricted for that suitability dimension after source availability passes.
```
