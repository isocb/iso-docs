# FUND Phase 1 Slice 1R-E-B - C1 Store Portfolio Oversight And Exceptional Intervention Surface Implementation Planning

Date: 2026-07-15

Status: Implemented and reviewed/tested as passed locally; not yet committed or deployed

Roadmap renumbering notice: references in this accepted historical record to `1R-F` as
the public Store/C2 display slice now mean `1R-G`. Current `1R-F` is the later accepted
Project Offer And Artwork Readiness parent. The original wording is retained for audit.

Authoritative controls:

- `docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`
- `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`
- `docs/modules/fund/00-roadmap-control/2026-07-15-fund-store-artwork-orders-and-production-strategic-completion-roadmap.md`
- `docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-c1-store-oversight-c2-project-store-control-alignment-planning.md`
- `docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-a-store-authority-exceptional-intervention-lifecycle-service-alignment-implementation-planning.md`

Application baseline:

- application `dev` and `origin/dev` aligned at E-A commit `daafc349`;
- complete 141-migration application history, with migration 141 validated only on the
  retained disposable test database;
- shared Neon development and staging databases remain at the previously promoted
  140-migration boundary until a separate controlled database promotion;
- E-A schema, Store-authority policy and internal C1/C2 service alignment implemented and
  reviewed as passed; and
- E-B implementation, disposable validation and lifecycle documentation completed locally;
  no shared database or deployment action has occurred.

## 1. Goal

Give C1 one accurate operational overview of every Project Store in its tenant without
restoring C1 as the ordinary Store publisher.

E-B presents the E-A server contract. It does not invent Store state, infer readiness in
the browser or create a second Store-management policy.

```text
tenant Store portfolio
-> selected Store diagnostic detail
-> server-derived effective state, blockers and remediation
-> exceptional C1 intervention only when E-A permits it
```

The surface is for C1 supplier/seller oversight. Normal Project activation and Store
publish/pause/resume remain C2 responsibilities and are implemented in the later E-C UI.

## 2. Accepted Authority Boundary

### 2.1 C1 access

Only the session-derived tenant's effective C1 `OWNER` or `ADMIN` may access E-B.

Every query and mutation must:

- derive `organizationId` and effective actor from the authenticated context;
- reject a caller-supplied tenant or actor identity;
- return not-found for another tenant's Store, Project, Client, Event or Product;
- revalidate role and tenant in the service boundary;
- preserve the established impersonation/effective-actor contract; and
- expose no C2-only Project authority merely because the same User also has a Client
  membership.

C1 non-admin roles, C2-only members and public callers receive no portfolio data.

### 2.2 Normal and exceptional actions

E-B may expose:

- read-only tenant-wide Store oversight;
- read-only Store, Store Product, current configuration and bounded version history;
- server-authorised configuration/readiness refresh already accepted in 1R-D/E-A;
- E-A `EXCEPTIONAL_PAUSE` and `EXCEPTIONAL_CLOSE` actions;
- E-A `RELEASE_EXCEPTIONAL_PAUSE` and `REOPEN_EXCEPTIONAL_CLOSURE` actions; and
- links to an existing authoritative remediation surface.

E-B must not expose:

- routine C1 Store publish, pause or resume;
- Project activation as a substitute for C2;
- C2 Store copy, ordering, visibility or Product-selection mutation;
- Product price, tax, Catalogue, source-media or workflow editing inside the Store page;
- a Store Product release/hold action before a separately accepted service owns that
  evidence; or
- Store creation/preparation for a Project that has no Store; or
- archive, destructive deletion or metadata-based override controls.

The UI renders an exceptional action only when the freshly returned E-A
`allowedActions[]` contains that exact action. The server remains authoritative if UI
state becomes stale.

## 3. Bounded Routes And Navigation

Add only these authenticated C1 routes:

```text
/app/fund/stores
/app/fund/stores/[id]
```

Add a **Stores** card to the existing C1 FUND landing page. Do not add this card to C2 or
public navigation.

The list route is the C1 Store portfolio. The detail route is a diagnostic and exceptional
intervention surface. Existing C1 Project, Client, Event, Product and tenant payment
settings pages remain their own authorities.

No public Store URL, Store preview, checkout/return route or C2 Store tab is added.

## 4. Internal Query Contract

### 4.1 Portfolio query

Add one C1-only, bounded server query under the existing FUND Store router. It accepts:

```text
search
effectiveState[]
projectStatus[]
interventionState: ALL | ACTIVE | NONE
eventScope: ALL | EVENT | STANDALONE
paymentReadiness: ALL | READY | BLOCKED
storeScope: CURRENT | ARCHIVED | ALL
sort: PROJECT | CLIENT | EVENT | EFFECTIVE_STATE | OPENS_AT | CLOSES_AT | UPDATED_AT
direction: ASC | DESC
cursor
limit: default 25, maximum 100
```

The query must always constrain by the session-derived tenant. Search is limited to Store
title, Project number/name, Client name and Event name. It must not search intervention
notes, purchaser evidence, email addresses or opaque provider references.

Each row returns only the bounded projection needed by the table:

```text
Store id and intent status
Project id/number/name/status and explicit opensAt/closesAt
Client id/name
optional Event id/name
effectiveState and evaluatedAt
active-intervention kind/reason/startedAt, without operator note
Store Product total/visible/READY/INCOMPLETE/BLOCKED counts
payment readiness boolean
blocker codes grouped by C1/C2/TIME/LATER_WORKFLOW responsibility
allowed exceptional C1 actions
updatedAt
```

Effective state, blockers, payment readiness and actions must be composed through the E-A
policy plus the existing 1R-D readiness evaluator. The portfolio service may optimize
database loading, but it must not create a second precedence or blocker implementation.

Pagination, filter and sort results must be deterministic with Store ID as the final
tie-breaker. A page must not leak a count or identity from another tenant.

The router accepts no `evaluationAt`. It captures one server time for each request and
passes it to the service. A test clock may be injected directly into service tests only.
No browser value may select a past/future authority result or mutation time.

Because effective state and blocker responsibility are derived, the service must not fetch
one SQL page and then filter it in memory. It must load the tenant's bounded projection in
batched queries, evaluate every candidate at the single request time through the shared
E-A/1R-D composition, apply all filters and sorting, and only then return the requested
page. It must avoid per-Store Seller, connection, assignment or Product queries.

The opaque cursor contains only the normalized query fingerprint, last sort tuple and
Store ID. It is validated on reuse and cannot alter tenant scope or authority. Derived
state may legitimately change between page requests; the portfolio is a current
operational view, not a historical snapshot. Every mutation independently revalidates at
current server time.

### 4.2 Store oversight detail

Add one C1-only detail query keyed by Store ID. It returns:

- the same current E-A authority projection as the list row;
- read-only Store copy;
- Project, Client and optional Event summary with explicit Project dates and Event outer
  envelope;
- delivery-profile presence, commission-acceptance status and payment-readiness summary;
- all current Store Products with visibility, eligibility, readiness, reason codes,
  Product identity, workflow class and current immutable configuration version;
- bounded configuration-version history for one selected Store Product;
- active and resolved intervention history newest first; and
- safe existing remediation destinations.

C1 detail may display intervention `operatorNote` and `resolutionNote` because these are
C1-internal operational evidence. They must never be returned by C2/public procedures,
included in URLs, analytics attributes or browser logs.

The configuration view displays bounded fields rather than raw JSON:

```text
version
createdAt
server-derived short configuration fingerprint for display
source Product revision
Product code/name snapshot
display title/subtitle snapshot
net price/VAT/currency/tax snapshot
readiness status/reason snapshot
```

No version is editable, deletable or selectable as a new current version from E-B.
The service does not return the full configuration hash or raw configuration/input/media
JSON because the UI does not require them.

### 4.3 Remediation destinations

Map only to existing safe routes:

| Authority | Destination |
| --- | --- |
| Project or Project dates | `/app/fund/projects/[projectId]` |
| Client | `/app/fund/clients/[clientId]` |
| Event envelope | `/app/fund/events/[eventId]` |
| Product/Catalogue/source commercial evidence | `/app/fund/products` |
| Stripe Connect/payment readiness | `/settings/payments` |
| Commission or later artwork/release workflow with no accepted UI | display the blocker and owner; add no dead or speculative link |

Routes never carry tenant IDs, notes, provider references or readiness assertions.

## 5. Portfolio User Experience

### 5.1 Store table

The portfolio page uses the established FUND Mantine/DataTable patterns and provides:

- clear page title and supplier-oversight explanation;
- debounced search;
- effective-state, Project-state, intervention, Event/standalone and payment filters;
- deterministic sortable columns;
- compact Product/readiness counts;
- a visible exceptional-intervention indicator;
- cursor pagination or bounded incremental loading; and
- row navigation to the Store detail route.

Default view includes all nonarchived Stores. Archived Stores may be included through an
explicit filter but remain read-only.

Effective-state labels must distinguish at least:

```text
SETUP
SCHEDULED
OPEN
C2_PAUSED
C1_EXCEPTION_PAUSED
PROJECT_PAUSED
PROJECT_INACTIVE
CLOSED_BY_PROJECT_WINDOW
C1_EXCEPTION_CLOSED
BLOCKED
ARCHIVED
```

Project-window ending is described as **Project window ended**, never as a C1 Store
closure. A future opening is **Scheduled**, not blocked.

### 5.2 Store detail

The detail surface contains:

1. overview and effective-state summary;
2. Project window and optional Event-envelope explanation;
3. blockers grouped by responsible actor and linked remediation where available;
4. Store Product/readiness table;
5. immutable configuration-version inspection;
6. intervention history; and
7. exceptional-action panel.

Store title/introduction/fundraising objective are read-only for C1 in E-B. Their ordinary
owner remains C2.

Refreshing readiness/configuration is visibly a server recalculation. It is a separate
C1 diagnostic capability, not an E-A trading `allowedActions[]` value. The detail query
returns `canRefreshConfiguration`, and the refresh service revalidates C1 role, tenant,
Project and Store state at current server time. The UI never sends price, tax, revision,
hash, readiness code, effective state, configuration content or `evaluationAt`.

## 6. Exceptional Intervention Experience

### 6.1 Starting an intervention

Exceptional pause and closure use a dedicated accessible confirmation modal. It requires:

- one enum reason: LEGAL, PAYMENT, SAFETY, SELLER_OF_RECORD or OTHER;
- a nonblank bounded operator note;
- a clear explanation that the action overrides C2 intent but does not change Project
  dates; and
- explicit confirmation naming the Project and Store.

Closure uses stronger visual wording than pause and explains that only C1 may reopen it.
If closure supersedes a current exceptional pause, the confirmation states that the pause
will be resolved as `SUPERSEDED_BY_CLOSURE`.

### 6.2 Resolving an intervention

Release and reopen use a separate modal requiring a nonblank bounded resolution note.
Copy must explain that resolution removes only the C1 overlay. It does not publish the
Store or bypass C2 intent, Project lifecycle, Project dates or readiness.

### 6.3 Idempotency and stale state

The browser creates one opaque idempotency key when an action dialog opens and retains it
for every retry of that exact request. A new intent creates a new key. Resolution uses its
separate E-A resolution key.

The E-B router uses UI-safe intervention and refresh input schemas that do not accept
`evaluationAt`. Existing service test-clock parameters remain internal and are never
forwarded from a production browser request.

After success, invalidate and refetch both portfolio and detail queries. On conflict or
stale authority, close no dialog automatically: show a safe error, refetch, and render the
new server state/actions. Double click, refresh and network retry must not create duplicate
evidence.

No note, key or intervention content is persisted in browser storage.

## 7. Accessibility, Responsive And Failure States

The implementation must include:

- keyboard-operable rows and actions;
- labelled inputs and descriptions for reason/note confirmation;
- predictable initial focus, focus return and Escape handling;
- non-colour-only state and blocker communication;
- table-to-card or horizontally safe presentation at narrow widths;
- loading skeletons, empty portfolio, no-filter-results and retryable error states;
- explicit stale/refetch feedback after mutations; and
- no raw Prisma, provider, tenant, stack or internal-note detail in errors.

The UI must not optimistically claim an intervention or resolution before the server
returns committed E-A evidence.

## 8. Proposed Application Files

Expected bounded additions/changes:

```text
src/app/(app)/app/fund/page.tsx
src/app/(app)/app/fund/stores/page.tsx
src/app/(app)/app/fund/stores/[id]/page.tsx
src/modules/fund/components/stores/StorePortfolioPage.tsx
src/modules/fund/components/stores/StoreOversightDetailPage.tsx
src/modules/fund/components/stores/StoreEffectiveStateBadge.tsx
src/modules/fund/components/stores/StoreBlockersPanel.tsx
src/modules/fund/components/stores/StoreInterventionDialog.tsx
src/modules/fund/lib/validation/store-management.ts
src/modules/fund/routers/store-management.router.ts
src/modules/fund/services/store-management.service.ts
src/modules/fund/services/store-authority.service.ts
src/modules/fund/services/store-oversight.service.ts
targeted component/policy/service tests and a bounded E-B verification script
```

File names may be consolidated where that reduces duplication, but scope must remain the
same. E-B adds no Prisma model, migration, API route, provider adapter or storage service.

## 9. Validation Plan

### 9.1 Static and unit checks

- Prisma migration inventory remains 141;
- Prisma schema has no E-B change;
- type-check and production build;
- route/component static verification;
- pure view-model effective-state label and blocker-responsibility mapping tests;
- filter/sort/query normalization tests;
- exceptional-dialog/idempotency pure-state tests without introducing a new browser-test
  framework; and
- no routine C1 publish/pause/resume control in the component/router contract.

### 9.2 Disposable PostgreSQL service checks

Use only `TEST_DATABASE_URL` after proving it differs from `DATABASE_URL`:

- complete 141-migration baseline and zero failed migration;
- C1 OWNER/ADMIN sees all and only its tenant Stores;
- C1 non-admin, C2-only and cross-tenant callers are rejected safely;
- deterministic search/filter/sort/pagination;
- server-owned evaluation time and refusal of browser `evaluationAt`;
- batched derived-state composition without per-Store Seller/connection/readiness queries;
- standalone and Event-linked Project projection;
- every E-A effective state and blocker-responsibility group;
- exact Product/readiness/payment/configuration counts;
- current and historical configuration inspection;
- no full configuration hash or raw snapshot JSON in UI responses;
- C1-only internal intervention notes and no C2/public leakage;
- exceptional pause/release and closure/reopen through existing E-A services;
- truthful pause supersession by closure;
- idempotent retry, stale conflict, concurrency and rollback;
- refresh recalculates and refetches without accepting caller readiness/commercial data;
- A7, 1R-D, E-A, K1-F/K2 and tenant-isolation regressions; and
- zero E-B-prefixed test residue.

### 9.3 Browser and responsive checks

Using seeded disposable/local data only:

- desktop and narrow/mobile portfolio views;
- keyboard table/detail navigation;
- accessible pause, closure, release and reopen dialogs;
- loading, empty, filtered-empty, error and stale-mutation states;
- correct Project-window/Event-envelope wording at boundary instants;
- remediation links route only to existing tenant-safe pages;
- no C1 routine publication action;
- no C1 note in URLs, console output or non-C1 responses; and
- no public Store/Checkout UI activation.

Human C1 staging smoke remains a later controlled-promotion gate. E-B implementation
testing itself modifies no shared development, staging or production database.

## 10. Explicit Exclusions

E-B does not add:

- a Prisma schema change or migration;
- C2 Project Store UI (`1R-E-C`);
- public Store, preview, checkout or return UI (`1R-F` and later);
- routine C1 Project activation or Store publish/pause/resume;
- C2 Store copy, Product selection, ordering or visibility controls;
- Product/Catalogue price, tax, media or commercial editing;
- speculative Store Product artwork/presentation release evidence;
- upload, malware scan, artwork/template or production workflow;
- Order, refund, fulfilment or dispatch operations;
- commission calculation, statements or settlement;
- real Stripe calls or settings mutation; or
- unrelated LMSPro work.

## 11. Migration And Promotion Boundary

E-B creates no migration. Implementation and service/browser tests require the complete
141-migration disposable E-A baseline.

Application `origin/dev` containing E-A migration 141 does not prove that the shared Neon
development database has applied it. Before any later shared dev/staging E-B execution,
the controlled promotion must separately verify and apply the complete pending migration
bundle with `prisma migrate deploy`; `db push` and seed are forbidden.

No shared database action is authorised by this planning document.

## 12. Review Gate

Review must confirm:

1. E-B is C1 portfolio oversight, not ordinary Store control;
2. every state, blocker and action comes from the E-A/1R-D server authority;
3. C1 tenant isolation and OWNER/ADMIN access are exact;
4. internal intervention notes remain C1-only;
5. exceptional actions use E-A allowed actions, confirmation and separate idempotency;
6. Project dates and Event envelope are worded correctly;
7. Store copy and C2-owned presentation remain read-only;
8. missing artwork/release workflows appear only as blockers;
9. no schema, migration, public Store, C2 UI, real Stripe, Order, production or commission
   behaviour has leaked into E-B; and
10. disposable and browser validation are sufficient for the new surface.

This review is now complete and recorded in section 15. Only the bounded E-B
implementation may begin. E-C, 1R-F and later work remain unauthorised.

## 13. Review Prompt

```text
Review only FUND Phase 1 Slice 1R-E-B C1 Store Portfolio Oversight And Exceptional
Intervention Surface Implementation Planning. Do not implement application code and do
not begin 1R-E-C, 1R-F, artwork/template implementation, production, commission or another
slice.

Verify the plan against the accepted 1R-E parent, completed E-A schema/service authority,
1R-D readiness/configuration services, Commerce A1-A7, current C1 FUND routes and the
complete 141-migration application contract. Resolve any conflict in exact C1 tenant/role
authority, portfolio pagination/filtering, Project/Client/Event identity, server-derived
effective state and blocker ownership, Product/readiness/payment summaries, immutable
configuration history, C1-only intervention notes, remediation links, exceptional
pause/release/closure/reopen confirmation and idempotency, stale-state handling,
accessibility, responsive behavior, rollback and disposable/browser validation.

Confirm E-B is C1 oversight only: no routine C1 Project activation or Store
publish/pause/resume, no C2 Store UI, schema/migration, public Store/Checkout, Product
commercial editor, speculative artwork/release writer, real Stripe action, Order,
production, fulfilment or commission behavior.

If acceptable, mark only E-B accepted and provide its single bounded implementation
prompt. Make no Prisma, migration, service, router, route, provider, storage or UI change
during review.
```

## 14. Handoff

The E-B plan was reviewed and accepted before implementation. Its bounded application,
validation and lifecycle records are now complete locally. Review itself made no change.

Implementation confirmation:

`docs/modules/fund/04-implementation-confirmations/2026-07-15-phase-1-slice-1r-e-b-c1-store-portfolio-oversight-exceptional-intervention-surface-implementation-confirmation.md`

Review/test record:

`docs/modules/fund/05-review-and-test/2026-07-15-phase-1-slice-1r-e-b-r1-c1-store-portfolio-oversight-exceptional-intervention-surface-review-and-test.md`

## 15. Review And Acceptance Outcome

Review result: accepted on 2026-07-15.

The review reconciled E-B against the accepted 1R-E parent, completed E-A implementation
at `daafc349`, current Store router/service, existing FUND C1 routes, tenant payment
settings and the complete 141-migration application contract. It resolved:

- production routers use server time; browser inputs cannot supply `evaluationAt`;
- portfolio scope explicitly distinguishes current, archived and all Stores;
- derived-state filtering/sorting occurs after tenant-wide batched composition and before
  pagination, not after an arbitrary SQL page;
- cursors are opaque, query-bound and non-authoritative;
- every mutation revalidates exact current authority regardless of displayed state;
- E-B exposes existing configuration/readiness refresh but does not create/prepare a
  missing Store;
- refresh capability remains separate from E-A lifecycle/intervention allowed actions;
- the UI receives a short configuration fingerprint, never full hashes or raw snapshot
  JSON; and
- validation uses existing Vitest/pure-helper and manual browser methods rather than
  introducing a new browser-test framework.

No unresolved business or technical decision blocks bounded E-B implementation. Review
made no application, Prisma, migration, service, router, route, provider, storage or UI
change.

## 16. Accepted Implementation Prompt

```text
Continue only accepted FUND Phase 1 Slice 1R-E-B. Do not begin 1R-E-C, 1R-F,
artwork/template implementation, production, commission or another slice.

Starting from committed application `dev`/`origin/dev` baseline `daafc349` and the complete
141-migration application history, implement only the accepted C1 Store Portfolio
Oversight And Exceptional Intervention Surface. Add no Prisma schema or migration.

Add the authenticated C1 `/app/fund/stores` portfolio and `/app/fund/stores/[id]`
diagnostic routes, FUND landing-page Stores card, bounded C1-only portfolio/detail/version/
intervention queries, tenant-batched E-A/1R-D authority composition, deterministic
search/filter/sort/cursor behavior, existing-route remediation links, read-only Store copy
and Product/configuration evidence, server-authorised configuration/readiness refresh and
accessible exceptional pause/release/closure/reopen dialogs exactly as accepted.

Derive tenant, effective actor and current time only on the server. Production router
inputs must accept no `organizationId`, actor, `evaluationAt`, effective state, blocker,
readiness, price, tax, hash, version or configuration payload. Return only a short
configuration fingerprint and bounded display evidence; never return raw snapshot JSON or
full hashes. Keep C1 intervention notes on the C1 detail response only and out of URLs,
analytics, logs and every C2/public response.

Render exceptional actions only from freshly returned E-A allowed actions and revalidate
them inside the existing serializable service. Preserve one start/resolution idempotency
key per dialog intent and safe stale-state refetch. Keep configuration refresh separate
from trading actions. Add no missing-Store preparation, routine C1 Project activation or
Store publish/pause/resume, archive/delete, C2 Store UI, public Store/Checkout, Product
commercial editor, speculative artwork/release writer, real Stripe action, Order,
production, fulfilment or commission behavior.

Use only TEST_DATABASE_URL after proving it differs from DATABASE_URL. Verify the complete
141-migration disposable baseline, exact C1 tenant/role isolation, batched derived-state
pagination, every effective state/blocker/action, payment/Product/configuration summaries,
C1-only notes, refresh, exceptional intervention/idempotency/concurrency/rollback, A7/1R-D/
E-A/K1-F/K2 regressions, pure view-model tests, responsive/accessibility/browser states,
type-check, production build and zero test residue. Do not apply migration 141 or modify
shared development, staging or production databases.

After successful validation, create separate E-B implementation-confirmation and
review/test records, update the FUND, strategic, Commerce and root roadmaps plus planning
README, and stop. Do not start E-C or 1R-F.
```
