---
title: "IsoStack New Module Architecture Template"
status: active
last_updated: 2026-06-11
scope: module-planning
---

# New Module Architecture Template

> **Active template for new IsoStack modules.**  
> This is the canonical planning source for module architecture and should be used in preference to older or duplicate templates.

`isodocs` is the canonical documentation home for planning and architecture guidance.  
`isostack-bedrock` docs should stay code-adjacent unless they contain implementation notes tied directly to the codebase.

## 1) Use this template only after repo validation

Before filling in exact names, verify what already exists in the target repository:

- module feature names and IDs
- registration points in `module.config.ts` and module registry
- tRPC export pattern
- permission checks and role names
- existing table and column naming patterns
- navigation wrappers and layout shells

Do not assume:

- table names (for example `organisation_modules`)
- route paths
- permission constants
- migration conventions

If a name differs from this template, use the repository's actual name and note it in your implementation notes.

This template also aligns with:

- `docs/core/modules/module-development-guide.md`
- `docs/guides/table-crud-pattern.md`
- `docs/core/tenancy-model.md`
- `SAFE_DATABASE_WORKFLOW.md`

## 2) Scope and non-goals

### In scope

- module domain model and bounded context
- API and service surface
- module-specific permissions and views
- settings and feature options owned by the module
- module-level observability where needed

### Out of scope

- core auth/session handling
- global identity model
- core tenancy primitives
- platform navigation primitives
- base security middleware and AppShell behaviour
- deployment infrastructure and shared platform utilities

## 3) Core integration points

Every new module must declare:

- module identity and registration metadata
- tenant route access
- feature visibility and entitlement
- settings/branding usage through platform hooks

Avoid adding own top-level shells or replacing core AppShell and navigation.  
Use existing Core route wrappers and access control boundaries.

## 4) Data model conventions

### PostgreSQL schema strategy

- Module-owned tables should live in a dedicated Postgres schema (for hygiene), where that is the repository convention.
- Tenant scoping remains explicit in data design using `organizationId` on tenant-owned tables.
- Never treat schema separation as a substitute for tenant scoping.

If this repository uses a different tenant scope field, use that exact field instead and record the difference in the module plan.

### Recommended table requirements

For every tenant-owned table:

- include `organizationId` as required
- enforce referential integrity to `Organization`
- ensure isolation logic exists at application level in query inputs and filters
- ensure RLS readiness is implemented at table level where possible

For lookup/reference tables owned by platform admins only, define and justify any exceptions.

### RLS and isolation

- RLS should be implemented and kept migration-safe.
- Application-level tenant filtering must remain in place regardless of RLS and should run by default.
- Access checks should always include user context and organisation context.

## 5) API and server surface

Follow the current repository pattern for module routers/services:

- keep business logic in service files
- keep validation close to boundaries (Zod schemas)
- keep DB queries in server services or repositories, not UI components
- keep procedures permission-aware and tenant-aware

Define module routers only as needed for the module’s first delivery.

## 6) UI standards and list/table behaviour

For all list and table UIs in the module, follow this current standard:

- table rows are clickable and open edit modal
- no action icon columns for edit/delete
- delete action is only available in modal footer
- row click handlers should normalize payload as:
  - `params?.record ?? params`
- sortable headers should:
  - be clickable
  - sort ascending on first click
  - reverse sort on second click
  - show inactive columns with lighter sort icon state and active with darker state

Use shared list controls and modal patterns from `docs/guides/table-crud-pattern.md`.

## 7) Observability and compliance

Log meaningful events for key domain mutations (create/update/delete, bulk actions, permissions changes) in the project’s audit model.

## 8) Database workflow safety

- Do not use `db:push`.
- Do not use destructive seed/reset commands in deployed environments.
- Follow `SAFE_DATABASE_WORKFLOW.md` for all schema changes and environment promotion.
- If seeding is needed for this module, confirm idempotence before running in any non-local environment.

## 9) Documentation checklist for readiness

- [ ] Module registration and activation path is verified in current repo.
- [ ] Tenant isolation strategy is declared and includes `organizationId` (or repo-specific equivalent).
- [ ] RLS and application-level tenant checks are both planned and explicit.
- [ ] Table contracts use the shared CRUD pattern from `docs/guides/table-crud-pattern.md`.
- [ ] Query payload path includes normalised row click shape (`params?.record ?? params`) in examples/specs.
- [ ] tRPC/router/service boundaries are clear and permission checks are mapped.
- [ ] UI routes and settings screens are listed and tied to role scope.
- [ ] Safe migration workflow is documented, including no `db:push`, and staged migration path.

## 10) Acceptance criteria (before implementation start)

This template is ready for implementation only when all items are complete:

1. Repository inspection confirms module-level patterns and avoids stale assumptions.
2. Tenant scoping and security are explicitly modelled in plan and tests.
3. CRUD screens use row-click modal editing and header sort toggles.
4. Inert sort icons and active sort contrast are defined in the UI specification.
5. Module router and migration strategy are aligned to the target environment path.
6. SAFE_DATABASE_WORKFLOW and rollout path are stated and reviewed.

## 11) Existing guide comparison

Use this template in combination with:

- `docs/core/modules/module-development-guide.md` for baseline module onboarding and registration patterns.
- `docs/guides/table-crud-pattern.md` for table behaviour details.

There is currently no separate canonical module architecture template replacing this document.

