# FUND Phase 2 Refinement Wishlist And Slice Control

Date: 2026-06-30

Status: Active refinement wishlist

Purpose:

```text
Capture desirable FUND refinements that improve product quality, configurability, branding, workflow depth and operator polish, while keeping Phase 1 focused on structural build, core workflows, data storage, security and public route foundations.
```

This document is planning/documentation only. It does not implement code, change Prisma schema, create migrations, run deployment commands or start new feature work.

## 1. Refinement Philosophy

Phase 1 is the structural pass:

- core C1 FUND dashboard surface;
- Clients, Events, Products, Catalogues and Projects;
- Project-to-Client linkage;
- Project Intake schema, public routes, moderation and approval;
- security boundaries;
- storage foundations;
- C1/C2 lane separation;
- route, tenant and same-tenant safety.

Phase 2 refinement is the resolution pass:

- better branding and media;
- richer option sets;
- better configured defaults;
- clearer operator ergonomics;
- workflow-specific UI polish;
- communication/notification manageability;
- deeper production and commerce readiness;
- stronger reusable patterns across C1 workflows.

The guiding rule:

```text
Do not block Phase 1 architecture momentum for refinements unless the refinement is required for data safety, security, route safety, tenant safety or a core workflow to function.
```

## 2. Refinement Slice Lifecycle

Refinement work should continue to use the established IsoStack slice process:

```text
wishlist entry
-> slice planning
-> implementation
-> implementation confirmation
-> review and test
-> staging smoke
-> promotion decision
```

Wishlist entries should not become implementation work until they are promoted into a dedicated planning document.

Each promoted refinement slice should include:

- problem statement;
- user/workflow context;
- accepted boundaries;
- data/schema implications;
- UI/API implications;
- security/tenant implications;
- testing plan;
- out-of-scope exclusions;
- promotion gate.

## 3. Suggested Folder/Document Pattern

Keep the high-level refinement register here:

```text
docs/modules/fund/00-roadmap-control/2026-06-30-fund-phase-2-refinement-wishlist-and-slice-control.md
```

When a wishlist item is promoted, create the normal slice documents:

```text
docs/modules/fund/03-slice-planning/YYYY-MM-DD-fund-phase-2-slice-<id>-<name>-planning.md
docs/modules/fund/04-implementation-confirmations/YYYY-MM-DD-phase-2-slice-<id>-<name>-confirmation.md
docs/modules/fund/05-review-and-test/YYYY-MM-DD-phase-2-slice-<id>-<name>-review.md
```

Recommended slice ID style:

```text
2R-<area>-<number>
```

Examples:

```text
2R-INTAKE-01 - Event Media And Branding
2R-EVENT-01 - Event Type Option Set
2R-CLIENT-01 - Client Organisation Type Option Set
2R-UX-01 - Form Field Alignment Review
```

Where a refinement is tightly connected to a Phase 1 slice, preserve the Phase 1 reference as an alias:

```text
Phase 1 alias: 1P-G-F-A-R2B
Phase 2 refinement ID: 2R-INTAKE-01
```

This keeps continuity with the original discussion while preventing Phase 1 from becoming an endless branch of polish work.

## 4. Refinement Areas

### 4.1 Public Project Intake And Initiation

Focus:

- public form presentation;
- Event-scoped form context;
- branded/embedded form surfaces;
- client-facing wording;
- submission confidence and clarity;
- intake moderation ergonomics.

Wishlist entries:

| Refinement ID | Phase 1 Alias | Name | Intent | Status |
| --- | --- | --- | --- | --- |
| `2R-INTAKE-01` | `1P-G-F-A-R2B` | Event Media And Branding Schema/UI Planning | Let Event-scoped public forms inherit Event-specific image/media/brand treatment where appropriate, while preserving tenant/module/platform branding fallback. | Wishlist |
| `2R-INTAKE-02` | `1P-G-F-A-R2D` | Client Organisation Type Option Set Planning | Replace hard-coded organisation type choices with tenant-configurable option sets where needed. | Wishlist |
| `2R-INTAKE-03` | none | Public Form Embed Route And CSP Planning | Provide a dedicated embed-safe route or embedding policy for Squarespace, Wix, WordPress and similar third-party sites without weakening admin/app CSP. | Wishlist |
| `2R-INTAKE-04` | none | Public Form Confirmation Experience Polish | Improve pending/confirmed/expired states, help text and retry affordances after the core submission flow is stable. | Wishlist |

Research notes:

- confirm whether Event imagery belongs on `FundEvent`, a reusable media attachment model, or a branding override model;
- review current platform upload/media conventions before adding image fields;
- preserve public route security and avoid making admin routes embeddable;
- ensure public forms can render standalone and in future embed contexts.

### 4.2 Events

Focus:

- Event configuration depth;
- Event type/category taxonomy;
- Event branding and media;
- Event date and lifecycle clarity;
- Event-to-Project constraints.

Wishlist entries:

| Refinement ID | Phase 1 Alias | Name | Intent | Status |
| --- | --- | --- | --- | --- |
| `2R-EVENT-01` | `1P-G-F-A-R2C` | Event Type Option Set Planning | Replace free-text Event type/category with a C1-configurable dropdown/option-set pattern. | Wishlist |
| `2R-EVENT-02` | `1P-G-F-A-R2B` | Event Image And Public Context Planning | Decide whether Events need hero image, thumbnail, public form image, brand colour override or document/media attachments. | Wishlist |
| `2R-EVENT-03` | none | Event Date Constraint Review | Review how Event dates constrain Projects, Stores, production windows and public ordering windows. | Wishlist |

Research notes:

- compare current Event CRUD modal, Add Project modal and Project Intake form controls;
- avoid adding Event type schema until option ownership and defaults are understood;
- preserve existing Event-linked Project behaviour.

### 4.3 Clients And Client Organisations

Focus:

- Client organisation/account richness;
- addresses and delivery defaults;
- future Client users/members;
- Client type/role options;
- C2 dashboard readiness.

Wishlist entries:

| Refinement ID | Phase 1 Alias | Name | Intent | Status |
| --- | --- | --- | --- | --- |
| `2R-CLIENT-01` | `1P-G-F-A-R2D` | Client Organisation Type Option Set Planning | Decide whether organisation types should be tenant-configurable, module-defaulted or centrally governed. | Wishlist |
| `2R-CLIENT-02` | none | Client Address And Delivery Defaults Planning | Add structured organisation address and delivery defaults before Store, Orders, Production and Dispatch rely on them. | Wishlist |
| `2R-CLIENT-03` | `1P-F-F` | Client Users, Roles And Notification Boundary Planning | Plan future login-capable Client users/members, role labels and access permissions. | Wishlist / Future core dependency |

Research notes:

- `FundClient` is the C2 organisation/account, not a contact snapshot;
- primary contact fields remain C1 operational snapshots until the Client user/member model is planned;
- public intake may propose a Client organisation and main organiser, but ownership is only established through trusted approval/auth flows.

### 4.4 C1 Dashboard And Action Widgets

Focus:

- consistent action-card pattern;
- workflow counts;
- action-required state;
- dashboard navigation depth;
- C1 production/admin ergonomics.

Wishlist entries:

| Refinement ID | Phase 1 Alias | Name | Intent | Status |
| --- | --- | --- | --- | --- |
| `2R-DASH-01` | none | C1 Action Widget Standardisation | Refine action cards with summary rows, active border states and row click-through across Project Intake, Production, Dispatch and future workflows. | Wishlist |
| `2R-DASH-02` | none | C1 Dashboard Workflow Grouping | Group dashboard cards by operational area once Products, Events, Projects, Intake, Production and Commerce are all present. | Wishlist |

Research notes:

- action-required cards should use restrained semantic treatment, such as a 1px brand-primary border only when counts require admin action;
- row click should open the relevant workflow/detail page;
- avoid row action icon clutter where table/card row click is the established pattern.

### 4.5 Production, Dispatch And Commission

Focus:

- C1 supplier/producer operations;
- artwork checking;
- product grouping across Projects;
- dispatch and fulfilment;
- commission logic;
- Store/Orders/Commerce readiness.

Wishlist entries:

| Refinement ID | Phase 1 Alias | Name | Intent | Status |
| --- | --- | --- | --- | --- |
| `2R-PROD-01` | `1P-I` | Production Workflow Refinement | Expand C1 production planning into schema/API/UI slices after core Store/Orders/Commerce direction is accepted. | Wishlist |
| `2R-PROD-02` | none | Artwork Checking Workflow | Plan Project-linked artwork review states and evidence before production batching. | Wishlist |
| `2R-PROD-03` | none | Dispatch And Delivery Defaults | Align dispatch workflow with Client/Project delivery address planning. | Wishlist |
| `2R-PROD-04` | none | Commission Surface Planning | Place commission under the Client/Project/Order/Commerce structure with clear reporting boundaries. | Wishlist |

Research notes:

- production may group similar Products across Projects for efficiency;
- Project context remains important even when production is grouped across Projects;
- dispatch is both Project-linked and Client-linked.

### 4.6 Notifications And Communications

Focus:

- editable system email defaults;
- trigger registry;
- pause/resume controls;
- default recipients;
- dashboard-visible messages;
- SeasonPro-style communications precedent.

Wishlist entries:

| Refinement ID | Phase 1 Alias | Name | Intent | Status |
| --- | --- | --- | --- | --- |
| `2R-COMMS-01` | `1P-N0` | FUND System Notifications And Editable Email Defaults Planning | Plan notification triggers, editable copy, default recipients and pause/resume controls using the SeasonPro/LMSPro communications Notifications tab precedent. | Wishlist / Future core dependency |
| `2R-COMMS-02` | none | Client Dashboard Announcements Planning | Plan C1-to-Client announcements, campaign prompts and 1:1 communication surfaces. | Wishlist |

Research notes:

- required authentication/confirmation emails may remain bounded transactional exceptions until the notification registry exists;
- broader workflow emails should not be scattered through feature code;
- notification content and trigger behaviour should be managed centrally.

### 4.7 SeasonPro Integration

Focus:

- SeasonPro Club-originated fundraising Projects;
- League module entitlement;
- approved FUND producer tenant configuration;
- catalogue availability;
- Club-to-FUND Client mapping;
- sale method selection.

Wishlist entries:

| Refinement ID | Phase 1 Alias | Name | Intent | Status |
| --- | --- | --- | --- | --- |
| `2R-SEASONPRO-01` | `1P-J` | SeasonPro Club To FUND Project Initiation | Preserve and later plan the Club dashboard -> Start fundraising Project path. | Wishlist |
| `2R-SEASONPRO-02` | none | League FUND Producer/Catalogue Availability | Decide how a League configures approved FUND producer tenants and product catalogue availability for Clubs. | Wishlist |

Research notes:

- Club users should see fundraising products through the League/SeasonPro context, not supplier-management internals;
- until trusted direct creation is planned, SeasonPro-originated requests should route through moderated Project Intake.

## 5. Promotion Criteria

A wishlist item should be promoted into active planning when one of these is true:

- it blocks a core user workflow from being usable;
- it blocks a staging/live promotion;
- it prevents safe Store/Orders/Commerce design;
- it affects security, tenant isolation, trusted route context or public route safety;
- it is required for a customer-facing demo or operational presentation;
- it is low-risk and improves consistency across multiple existing screens.

A wishlist item should remain parked when:

- it is mainly visual polish;
- it requires unplanned schema ownership decisions;
- it depends on a future lane such as Store/Orders/Commerce, Client users or SeasonPro integration;
- it can be documented now without slowing the current core build.

## 6. Current Highest-Value Refinement Candidates

Near-term candidates after the current public Project initiation remediation review:

```text
2R-INTAKE-03 - Public Form Embed Route And CSP Planning
2R-EVENT-01 - Event Type Option Set Planning
2R-INTAKE-01 / 2R-EVENT-02 - Event Media And Branding Schema/UI Planning
2R-CLIENT-01 - Client Organisation Type Option Set Planning
2R-COMMS-01 - FUND System Notifications And Editable Email Defaults Planning
```

These are valuable but should not displace Phase 1 core architecture unless they become a promotion blocker.

## 7. Immediate Control Note

The current Phase 1 priority remains:

```text
1P-G-F-A-R2-B - Public Project Initiation Remediation Review And Staging Smoke Test
```

After the R2-B review, decide whether to:

- promote the public Project initiation remediation to staging/live;
- continue Phase 1 public intake hardening;
- instantiate a refinement slice from this wishlist;
- return to core Store/Orders/Commerce, production or Client dashboard planning.
