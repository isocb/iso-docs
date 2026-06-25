# FUND Phase 1 Slice 1P-R1A - C1 Admin UI Consistency Remediation Confirmation

Date: 2026-06-25

## 1. Slice Name

Phase 1 Slice 1P-R1A - C1 Admin UI Consistency Remediation

## 2. Implementation Summary

Retrospectively documented and confirmed a set of iterative C1 admin UI consistency corrections made after Slice 1P-R1 immediate remediation.

The corrections aligned the FUND C1 admin foundation with the current IsoStack UI standard:

- FUND dashboard cards now behave as whole-card navigation targets.
- FUND dashboard card accents now use brand colour semantics rather than arbitrary per-card decorative colours.
- FUND table sorting was moved to visible column-header click/reverse-sort behaviour.
- FUND section breadcrumbs were made consistent across Products, Projects and Events.
- FUND sidebar/module navigation icons were made destination-specific rather than repeating generic Home icons.
- Active UI documentation was updated so future C1 and C2 dashboard work follows the same conventions.

## 3. Files Changed

App files:

- `src/app/(app)/app/fund/page.tsx`
- `src/app/(app)/app/fund/products/page.tsx`
- `src/app/(app)/app/fund/projects/page.tsx`
- `src/app/(app)/app/fund/events/page.tsx`
- `src/core/components/layout/Navbar.tsx`
- `src/core/config/module-navigation.ts`
- `src/modules/fund/module.config.ts`
- `src/modules/fund/components/shared/FundTableControls.tsx`
- `src/modules/fund/components/products/ProductTable.tsx`
- `src/modules/fund/components/catalogues/CatalogueTable.tsx`
- `src/modules/fund/components/projects/ProjectTable.tsx`
- `src/modules/fund/components/events/EventTable.tsx`

Documentation files:

- `docs/2026-IsoStack-Docs/Standards/ui-ux/isostack-ux-ui-standard.md`
- `docs/2026-IsoStack-Docs/Standards/ui-ux/table-crud-pattern.md`
- `docs/2026-IsoStack-Docs/Standards/ui-ux/TABLE_CRUD_PATTERN_IMPLEMENTATION.md`
- `isodocs/docs/modules/fund/README-AI.md`

## 4. Dashboard Card Behaviour

The FUND dashboard cards were updated so that:

- the whole card is the click target;
- nested link buttons are not used inside clickable cards;
- each card uses muted surfaces and brand-accent affordances;
- peer cards do not use arbitrary blue/cyan/pink/green/red decoration;
- colour outside brand primary/secondary is reserved for status, urgency, RAG, warning, error, success, information or action-required meaning.

This applies as guidance for future C2 organiser dashboard cards as well.

## 5. Table Sorting Behaviour

The FUND Products, Catalogues, Projects and Events tables were aligned to the current table pattern:

- fuzzy search and filters remain above the table;
- sorting happens in visible column headers;
- clicking a sortable header sorts by that column;
- clicking the active header reverses direction;
- active sort direction is shown with subtle up/down icon treatment.

Documentation was updated to remove the previous sort-selector-in-filter-bar pattern.

## 6. Breadcrumb And Navigation Icon Behaviour

Breadcrumbs were applied consistently to the main C1 FUND admin section pages:

- Products.
- Projects.
- Events.

FUND sidebar/module navigation icons were made destination-specific so sibling routes do not repeat a generic Home icon.

## 7. Documentation Updates

The active IsoStack UI standard now explicitly states that colour has meaning:

- brand primary/secondary colours are for identity, navigation accents and primary/non-status affordances;
- non-brand colours communicate status, urgency, RAG/action-required, warning, error, success or information;
- arbitrary colour variation should not be used to make screens look attractive.

The FUND AI handoff now records the same dashboard card guardrail for future FUND C1 and C2 work.

## 8. What Was Deliberately Not Implemented

This slice did not implement:

- Prisma schema changes.
- Migrations.
- `db:push`.
- Seed/reset commands.
- New routers, services, Zod schemas or tRPC endpoints.
- C2 dashboard implementation.
- Store, Order, Commerce Core, payment, commission, production batching or organiser onboarding work.
- Event/Catalogue/Product availability modelling.
- Product workflow suitability modelling.

## 9. Checks Run

Checks run after the UI consistency updates:

- `npm run type-check` - passed.
- `git diff --check` in the app repo - passed.
- `git diff --check` in the docs repo - passed.
- `npm run verify` - first attempt failed due to the known sandbox `tsx` IPC pipe restriction; rerun outside the sandbox completed successfully and passed.

## 10. Risks And Follow-Ups

- The owner-controlled UI standard was updated because the user explicitly requested the colour-semantics clarification. Future changes to that file should still be treated as owner-controlled.
- A visual browser pass should confirm the card hover/click affordance feels sufficiently discoverable without nested buttons.
- Future C2 dashboard planning should reuse this card pattern rather than introducing separate decorative card colour variants.

## 11. Recommended Next Step

Complete/commit the current 1P-R1 and 1P-R1A remediation batch, then proceed with 1P-R2 review confirmation and roadmap update if not already complete.
