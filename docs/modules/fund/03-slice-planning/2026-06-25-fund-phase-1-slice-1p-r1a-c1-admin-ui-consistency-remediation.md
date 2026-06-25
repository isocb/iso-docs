# FUND Phase 1 Slice 1P-R1A - C1 Admin UI Consistency Remediation

Date: 2026-06-25

## 1. Slice Goal

Retrospectively document the small iterative C1 admin UI consistency corrections made during 1P-R1 review/remediation.

This slice exists because the work was discovered and corrected interactively rather than through a pre-written implementation prompt. The goal is to make the intent, boundaries and verification record explicit so the development trail remains auditable.

## 2. Context

The C1 FUND admin foundation was accepted as a release baseline after staging testing. During follow-on remediation/review, several UI consistency issues were identified:

- Product breadcrumbs should not be the only breadcrumb correction; Projects and Events should also use clear breadcrumbs.
- FUND sidebar/navigation entries should not all use generic Home icons.
- FUND tables should follow the current expected column-click sort and reverse-sort pattern rather than sort controls in the search/filter bar.
- FUND dashboard cards should use a consistent whole-card navigation pattern.
- Colour should follow IsoStack brand/status semantics, not decorative red/blue/green/pink section variation.

## 3. Implementation Boundary

This slice is limited to C1 admin UI consistency and documentation updates.

Allowed:

- Update C1 FUND dashboard card interaction pattern.
- Update FUND list/table sorting controls to column-header sorting where practical.
- Update breadcrumbs on C1 FUND section pages.
- Update sidebar/module navigation icons to be destination-specific.
- Update active UI guidance to document the current pattern.
- Update FUND AI handoff notes so future dashboard/card work follows the same rules.

Not allowed:

- Prisma schema changes.
- Migrations.
- `db:push`.
- Seed/reset commands.
- New routers, services, Zod schemas or tRPC endpoints.
- C2 dashboard implementation.
- Store, Order, Commerce Core, payment, commission, production batching or organiser onboarding work.

## 4. UI Rules To Apply

### Dashboard Cards

- The whole card should be the click target when the card opens a section page.
- Do not nest link buttons inside clickable navigation cards.
- Use muted card surfaces and typography.
- Use the active module/tenant brand primary or secondary colour for non-status accents.
- Do not assign arbitrary peer-card colours for decoration.
- Non-brand colour should mean status, urgency, RAG, warning, error, success, information or action required.

### Tables

- Use fuzzy search and filters above the table.
- Sorting belongs in the visible column headers.
- Header click sorts by that column.
- Clicking the active header reverses sort direction.
- Active sort headers should show subtle up/down direction feedback.

### Navigation

- Use destination-specific icons for module surfaces.
- Avoid repeating generic Home icons for sibling destinations.
- Use breadcrumbs consistently on C1 admin section pages.

## 5. Files Expected To Change

Likely app files:

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

Likely documentation files:

- `docs/2026-IsoStack-Docs/Standards/ui-ux/isostack-ux-ui-standard.md`
- `docs/2026-IsoStack-Docs/Standards/ui-ux/table-crud-pattern.md`
- `docs/2026-IsoStack-Docs/Standards/ui-ux/TABLE_CRUD_PATTERN_IMPLEMENTATION.md`
- `isodocs/docs/modules/fund/README-AI.md`

## 6. Checks To Run

- `npm run type-check`
- `npm run verify`
- `git diff --check` in the app repo
- `git diff --check` in the docs repo if `isodocs` changes

## 7. Documentation Note

This is a retrospective plan. It intentionally documents work that was corrected interactively during review rather than planned in advance.

Future comparable UI consistency changes should normally receive a small plan before implementation, but this document records the decision trail for the already-completed correction.
