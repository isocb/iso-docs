DO NOT USE. FOR HUMAN RECORD ONLY

I read the requested FUND docs and inspected the current repo patterns. I made **no code, schema, migration, seed or route changes**.

**Findings**
FUND is currently shell-only in `isostack-bedrock`: `src/modules/fund/module.config.ts`, registry/navigation wiring, dashboard landing metadata, and `/app/fund`. There are no FUND Prisma models, migrations, routers, services or CRUD pages yet.

The current architectural direction is clear: FUND must be **project lifecycle and production workflow first**, with commerce layered around projects later. The active docs are aligned with that. The documentation index is slightly stale: `README.md` references `03/04/05` docs, but only `01`, `02`, `README`, `README-AI`, `fund-tool-selection-thoughts.md` and `_archive/` are present.

**Recommended Active Docs**
Keep:

- `01-fund-module-brief.md`
- `02-fund-architecture-principles.md`
- `03-fund-functional-specification.md` to create next
- `04-fund-phase-1-implementation-plan.md` to create next
- `05-fund-open-questions.md` to create next
- `README.md` and `README-AI.md`, updated to match actual filenames

Archive/mark superseded:

- `_archive/01-functional-specification.md`
- `_archive/FUND_MODULE_BRIEF.md`
- `_archive/FUND_MODULE_PROJECT.md`
- `_archive/2026-06-11-fund-phase1-implementation-backlog-legacy.md`
- `_archive/2026-06-11-fund-future-phase-notes-legacy.md`
- `_archive/2026-06-fund-codex-handoff-slice-1a-staging-legacy.md`

Keep `fund-tool-selection-thoughts.md` as supporting context, not the implementation plan.

**Revised Roadmap**
Phase 0: documentation consolidation, open questions, schema design review only.

Phase 1: prove model foundation in this order:

1. Confirm existing module shell/status.
2. Product Workflow Classes.
3. Tenant-owned Products and Catalogues.
4. Projects as mandatory operational fundraising entities.
5. Optional Events as campaign containers.
6. Event-to-Project date constraints.
7. Lifecycle states and workflow extensions.
8. Operations Dashboard visibility.
9. Organiser Fundraising Dashboard visibility.
10. Store generation/association only after foundations are stable.

Later phases: templates/PDFs, stores/orders/payments, communications, commissions, production batching, SeasonPro channel, marketplace.

**Phase 1 Backlog**
Implementation backlog should be slices:

1. Shell and entitlement confirmation: verify `fund` feature flag, module catalogue/provisioning, nav, `/app/fund`.
2. Workflow-class foundation: define A1, A2, B, C as first-class records or controlled reference data.
3. Products/catalogues: tenant-owned catalogue and product management, each product requiring workflow class.
4. Project core: project number, organiser, owner tenant, lifecycle state, optional event link, selected products.
5. Events: optional campaign containers with shared dates, catalogues, commission defaults.
6. Date constraints: project close date must not exceed event latest close/production deadline.
7. Lifecycle engine: common states plus workflow-specific extensions.
8. Operations dashboard: read-only visibility of projects, deadlines, workflow requirements.
9. Organiser dashboard: project hub showing status, next actions, key dates.
10. Store association: generated/linked store placeholder only, not full commerce.

**Data Model Notes**
No schema work yet, but likely entities:

- `FundProductWorkflowClass`
- `FundProduct`
- `FundCatalogue`
- `FundCatalogueProduct`
- `FundEvent`
- `FundProject`
- `FundProjectProduct`
- `FundProjectLifecycleState`
- `FundProjectLifecycleEvent`
- later: `FundStore`, `FundOrderReference`, `FundArtworkAsset`, `FundPersonalisationData`, `FundProductionBatch`, `FundCommissionRule`, `FundCommissionLine`

Use dedicated `fund` Postgres schema if approved, but every tenant-owned table still needs required `organizationId`.

**Tenant Safety**
Every tenant-owned FUND record must include `organizationId`, indexed and enforced in all queries. Schema separation is not tenant isolation. tRPC procedures must use `protectedProcedure`, Zod input validation, `organizationId` filters, and `TRPCError` for denied access.

**Permissions**
Use Platform `OWNER`/`ADMIN` for initial management. For module roles, current user schema has `lmsproRoleIds`, `bedrockRoleIds`, `tailoraidRoleIds`, but no `fundRoleIds`. Before implementation, decide whether to add `fundRoleIds` or generalise module-role assignment. Suggested component keys:

- `fund.workflowClasses.manage`
- `fund.products.manage`
- `fund.catalogues.manage`
- `fund.projects.manage`
- `fund.events.manage`
- `fund.operations.view`
- `fund.organiser.view`

**Audit Logging**
Audit all meaningful mutations:

- workflow class created/updated
- product/catalogue created/updated/archived
- project created/updated/status changed
- event created/updated
- project date constraint override/failed attempt
- lifecycle transition
- store association
- later: order import/payment/commission/production events

**Open Questions**
Resolve before schema work:

- Should workflow classes be platform templates, tenant-customisable, or both?
- Should FUND add `fundRoleIds` or generalise module role assignment?
- What is the canonical organiser model: user, organisation, contact, or project participant?
- Are AMOW products owned by AMOW tenant even when sold through another tenant?
- Can a project use products from multiple catalogues/producers in Phase 1?
- Is project number global, tenant-scoped, event-scoped, or producer-scoped?
- Are lifecycle states fixed enums, database-defined templates, or hybrid?
- Which dates are required on independent projects?
- What is the minimum non-commerce store association shape?
- Which AMOW A1 template workflow must be proven first?

**Manual Test Scenarios**
For each early slice:

- Shell: tenant with `fund` enabled can see dashboard/nav and `/app/fund`; disabled tenant cannot.
- Workflow classes: A1/A2/B/C visible and cannot be deleted accidentally.
- Products/catalogues: products require tenant, catalogue and workflow class; no cross-tenant visibility.
- Projects: project creation requires tenant, organiser, workflow-aware product selection and lifecycle start.
- Events: project can exist with or without event.
- Date constraints: event project cannot close after event latest close; independent project can use own dates.
- Lifecycle: A1 shows artwork/template states; B shows data-upload states; C stays simple.
- Dashboards: operations view shows all tenant projects; organiser view shows only relevant projects/actions.

**Do Not Build Yet**
Do not build full storefronts, Stripe checkout, GoCardless, order capture, commission engine, production batching, PDF generation engine, SeasonPro club flows, marketplace producer onboarding, AI automation, customer accounts, public store routes, or destructive/import tooling in Phase 1 foundation.

**Risks**
Main risks are modelling too much commerce too early, treating AMOW artwork as an edge case, forcing every project into an event, hard-coding AMOW or SeasonPro assumptions, and adding FUND permissions awkwardly because module-role assignment is not fully generic yet.

**Recommended Next Codex Prompt**
```text
Create the revised FUND documentation set only:
03-fund-functional-specification.md
04-fund-phase-1-implementation-plan.md
05-fund-open-questions.md

Use 01-fund-module-brief.md and 02-fund-architecture-principles.md as canonical.
Do not edit code, Prisma, migrations, routers or UI.
Update README.md and README-AI.md only if needed to point to the new active docs.
```