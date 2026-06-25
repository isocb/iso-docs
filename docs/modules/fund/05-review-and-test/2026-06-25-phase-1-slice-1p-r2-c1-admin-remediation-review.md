# FUND Phase 1 Slice 1P-R2 — C1 Admin Immediate Remediation Review

Date: 2026-06-25

## Review Summary

Reviewed the 1P-R1 C1 admin remediation and the retrospective 1P-R1A UI consistency remediation against the triage document, slice plans and implementation confirmations.

Recommendation:

```text
Proceed, with one note: complete an authenticated browser spot-check before staging promotion if this branch is being deployed beyond local/dev review.
```

No product-blocking code defects were found during static/code review and automated checks.

## Tests / Review Completed

Completed:

- reviewed Project/Event date constraint implementation in Project create, Project detail/edit, Event helper text and readiness panel;
- reviewed Project service validation to confirm server-side Project/Event date rules remain authoritative;
- reviewed Issue Manager module filtering and tagging implementation;
- reviewed P1/platform owner module visibility path;
- reviewed non-P1 module visibility path remains organisation-scoped;
- reviewed optional polish for Project Product activation gate visibility;
- reviewed Products breadcrumb addition;
- reviewed FUND sidebar icon changes;
- reviewed FUND dashboard card interaction/colour consistency changes;
- reviewed Issue Manager module input consolidation;
- reviewed shared UI standard updates that were explicitly owner/user requested during the review;
- ran `npm run type-check`;
- ran `npm run verify`;
- ran `git diff --check` in the app repo;
- ran `git diff --check` in the docs repo.

Not completed in this CLI session:

- authenticated browser click-through of `/app/fund/*` and `/platform/issues`, because no authenticated browser session/credentials were available in this environment.

## Issue #46 Review — Project/Event Date Constraints

Static/code review result:

```text
Passed at code-review level.
```

Confirmed:

- Event-linked Project close-date constraint is represented in UI helper messaging.
- Project readiness now treats linked Event date constraint failures as blockers.
- Standalone Projects still rely on normal Project validation.
- Event `closesAt` remains the latest permissible effective close date, not a copied Project field.
- Project create now revalidates close date when Event changes.
- Project detail/edit now revalidates open, close and production deadline fields when Event changes.
- Project detail/edit date pickers are constrained by selected Event dates where practical.
- Server-side validation still rejects:
  - Project open before Event open;
  - Project close after Event close;
  - Project production deadline after Event production deadline;
  - Project production deadline before effective close date.

Remaining manual browser checks:

- attempt invalid linked Project close date via the browser UI;
- confirm readiness state and helper text update after Event/date changes;
- confirm server error is surfaced if a stale/malicious invalid update is submitted.

## Issue #50 Review — Issue Manager Module Filtering

Static/code review result:

```text
Passed at code-review level.
```

Confirmed:

- Issue Manager module filtering now uses `catalogueModuleId` on the existing `IssueCatalogueModule` relation.
- Module filter can also match legacy/context fields where they correspond to the selected module.
- P1/platform owner module list uses enabled `ModuleCatalogue` records and includes the idempotent FUND module catalogue default.
- FUND module catalogue upsert uses `update: {}`, so existing customisations are not overwritten.
- Non-P1 users remain limited to modules enabled for their own organisation.
- Issue module tagging is idempotent.
- Issue modal distinguishes `Application / Area` from `Modules`.
- Selecting a matching application/area auto-selects the matching Issue Module when available.
- Issue modal now exposes a single `Modules` control for the module data used by filtering, issue-list badges and Change Request exports.
- The legacy singular IsoStack `Module` selector is no longer shown in the CRUD form.

Remaining manual browser checks:

- confirm FUND appears in the Issue Manager module filter for P1;
- confirm filtering by FUND returns matching FUND issues where they exist;
- confirm stable empty state when no matching issues exist;
- confirm no Server Components render error occurs in the authenticated app.

## Optional Polish Review

### Issue #47 — Project Product Activation Gate Visibility

Static/code review result:

```text
Passed at code-review level.
```

Confirmed:

- Project Overview readiness panel now clearly warns when no active Project Products exist.
- The warning includes active Project Product count.
- The warning includes a `Go to Products tab` affordance.
- Full Project Product mutation controls remain on the Products tab.

### Issue #44 — Product Breadcrumb Navigation

Static/code review result:

```text
Passed at code-review level.
```

Confirmed:

- `/app/fund/products` now includes a breadcrumb back to FUND.
- `/app/fund/projects` now includes a breadcrumb back to FUND.
- `/app/fund/events` now includes a breadcrumb back to FUND.

### Issue #45 — Sidebar Icon Polish

Static/code review result:

```text
Passed at code-review level after documentation-owner correction.
```

Confirmed:

- FUND overview navigation uses `IconLayoutDashboard`.
- FUND Projects navigation uses `IconClipboardList`.
- FUND Events and Products remain destination-specific.
- the sidebar renderer icon map includes the FUND destination-specific icon names and should no longer fall back to generic Home icons.

### 1P-R1A — Dashboard Cards, Colour Semantics And Table Sorting

Static/code review result:

```text
Passed at code-review level.
```

Confirmed:

- `/app/fund` dashboard cards are whole-card navigation targets.
- Nested link buttons were removed from clickable dashboard cards.
- FUND dashboard cards use muted surfaces with brand-accent affordances rather than arbitrary peer-card colours.
- IsoStack colour guidance now explicitly states that non-brand colour is for RAG/status/urgency/action-required meaning, not decoration.
- FUND Products, Catalogues, Projects and Events tables now use column-header click/reverse-sort behaviour.
- Sorting guidance was removed from the search/filter control-bar pattern and documented as visible column-header sorting.

## Documentation-Owner Note

The review handled two documentation-owner cases:

1. The initial 1P-R1 implementation placed icon guidance in:

```text
docs/2026-IsoStack-Docs/Standards/ui-ux/isostack-ux-ui-standard.md
```

That file is treated as owner-controlled/reference-only. No explicit owner approval was present in the original prompt trail for that icon guidance.

Review correction made:

- removed the unapproved guidance from the owner-controlled UI standard;
- moved FUND-specific icon guidance into:

```text
isodocs/docs/modules/fund/README-AI.md
```

This keeps the shared standard unchanged while preserving the FUND AI guardrail.

2. Later in the review, the user explicitly requested shared UI standard changes for:

- column-header sorting rather than sort controls in the filter bar;
- semantic colour use, where brand primary/secondary handle normal accents and non-brand colours indicate RAG/status/urgency/action-required meaning.

Those owner-requested shared UI standard changes remain in the active standard.

## Defects Found

Two review defects were found after the first review pass:

- #44 breadcrumb remediation only covered `/app/fund/products`; Projects and Events list pages also needed breadcrumbs.
- #45 FUND sidebar navigation still showed house icons because `IconClipboardList`, `IconCalendarEvent` and `IconPackage` were not registered in the sidebar renderer icon map, so the renderer fell back to `IconHome`.

Documentation process defect found and corrected:

- owner-controlled UI standard had been edited without explicit owner approval.

Additional UI consistency issues found interactively and corrected:

- FUND dashboard cards were not all using a whole-card click target.
- FUND dashboard cards used arbitrary blue/cyan/pink section colours.
- Issue Manager CRUD had both a singular legacy `Module` selector and a separate module-tagging selector, even though table filtering, badges and CR exports use the module-tagging relation.

## Fixes Made During Review

Application:

- added breadcrumbs to `/app/fund/projects`;
- added breadcrumbs to `/app/fund/events`;
- added `IconClipboardList`, `IconCalendarEvent` and `IconPackage` to the sidebar renderer icon map;
- changed `fundModuleConfig.icon` from `IconHome` to `IconHeart`;
- confirmed `/app/fund/products` already had the breadcrumb from 1P-R1.

Documentation:

- added FUND-specific icon guidance to `README-AI.md`.
- added retrospective 1P-R1A planning and implementation confirmation documents for UI consistency remediation.
- updated active UI standards for owner-requested column-header sorting and semantic colour use.

Additional UI consistency corrections:

- changed `/app/fund` dashboard cards to whole-card links;
- removed arbitrary per-card dashboard colours and used brand-accent navigation affordances;
- aligned FUND tables to column-header sorting;
- consolidated the Issue Manager CRUD module field to one `Modules` selector used by filtering, badges and CR exports.

No new product feature work was added during 1P-R2; changes were limited to review corrections, UI consistency remediation and documentation alignment.

## Schema / Migration / Data Safety

Confirmed:

- no Prisma schema changes;
- no migrations created;
- no `db:push`;
- no seed/reset commands;
- no database destructive commands.

## C1 / C2 Boundary Confirmation

Confirmed:

- no C2 organiser dashboard implementation was added;
- no organiser invitations were added;
- no Project Request/onboarding work was added;
- no C2 ownership/access model was implemented in this remediation slice;
- C1 admin remediation remains inside the existing C1 admin foundation and platform Issue Manager paths.

## Regression Results

Static/code review found no regressions to:

- FUND Project/Event linkage service validation;
- Project Product activation readiness logic;
- Issue Manager general module tagging path;
- non-P1 organisation-scoped module visibility;
- Products/Catalogues page structure;
- FUND navigation configuration.
- Issue Manager module filtering/export semantics.

Post-review correction checks confirmed:

- FUND sidebar icon names are now present in the renderer icon map and should no longer fall back to `IconHome`.
- FUND list pages now have breadcrumbs for Projects, Events and Products/Catalogues.
- FUND dashboard cards are now a consistent single-click navigation surface.
- Issue Manager module CRUD input now matches the table/filter/export module model.

Authenticated browser route regression was not completed in this CLI session.

## Checks Run

- `npm run type-check` — passed.
- `npm run verify` — first sandboxed run failed because `tsx` could not create a local IPC pipe; rerun with approved escalation passed.
- `git diff --check` in app repo — passed.
- `git diff --check` in docs repo — passed.

## Remaining Risks / Follow-Ups

- Authenticated browser spot-check remains recommended before staging promotion.
- Issue Manager still has some legacy data fields (`moduleName`, `isocareModule`) for compatibility, but the visible CRUD module selector now follows the module tagging model used by filters and exports.
- #48 Event/Catalogue/Product availability remains open and should be handled in an architecture-planning slice.
- #49 Product Workflow Class suitability remains open and should be handled with #48 before Store, Commerce or production workflow expansion.

## Recommendation

Proceed to:

```text
Phase 1 Slice 1P-A / 1P-B — C2 Project Access Model and Project Participant Schema planning
```

Keep #48 and #49 visible in the roadmap/control register and resolve them before Store/Commerce planning or implementation.
