# FUND Phase 2 Refinement Wishlist And Slice Control

Date: 2026-06-30

Status: Superseded historical refinement ledger; not active control

Superseded by:

`docs/modules/fund/00-roadmap-control/2026-07-20-fund-refinement-wishlist-and-slice-control.md`

This document is retained for provenance only. Do not use its historical priority labels,
candidate ordering or “active” wording to select work. The 2026-07-20 reconciled register
contains the current absent-refinement inventory, while the authoritative FUND roadmap
alone selects the next bounded slice.

Parent roadmap:

`docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`

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
- Event-as-domain-window planning;
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
- Event as a domain-window planning unit;
- Event type/category taxonomy;
- Event branding and media;
- Event date and lifecycle clarity;
- Event-to-Project constraints.
- Event-side Catalogue/Product visibility.

Wishlist entries:

| Refinement ID | Phase 1 Alias | Name | Intent | Status |
| --- | --- | --- | --- | --- |
| `2R-EVENT-01` | `1P-G-F-A-R2C` | Event Type Option Set Planning | Replace free-text Event type/category with a C1-configurable dropdown/option-set pattern. | Wishlist |
| `2R-EVENT-02` | `1P-G-F-A-R2B` | Event Media, Branding And Public Context Planning | Decide whether Events need hero image, thumbnail, public form image, brand colour override or document/media attachments. | Wishlist |
| `2R-EVENT-03` | none | Event Date Constraint Review | Review how Event opens, closes and deadline anchors constrain Projects, Stores, production windows and public ordering windows. | Wishlist |
| `2R-EVENT-04` | none | Event Domain Window And Key Date Precedent Planning | Frame FUND Events against the LMSPro Key Date precedent: reminders, windows with open/close date-times and trigger date-times, with named anchors that can drive email sequences, commission periods and later operational rules. | Wishlist / Architecture planning |
| `2R-EVENT-05` | none | Event Catalogue And Product Visibility Management Planning | Add Event-side visibility for linked Catalogues and contributed Products, with a future Event detail tab that can show and potentially manage Event-to-Catalogue availability links. This should complement Product-side Catalogue memberships and Catalogue-side Product membership management without duplicating Product selection or Store behaviour. | Wishlist |

Research notes:

- compare current Event CRUD modal, Add Project modal and Project Intake form controls;
- avoid adding Event type schema until option ownership and defaults are understood;
- preserve existing Event-linked Project behaviour;
- Events are optional for standalone Projects, but where they exist they are key architectural control records rather than simple labels.
- LMSPro Key Dates provide the precedent: a planning unit may be a reminder, a window with open/close date-times, or a trigger date/time.
- FUND Events are closest to window-type Key Dates because they provide an open/close frame for fundraising activity.
- Event anchors should be reusable by multiple future systems: email sequences, reminders, prompts, post-close follow-ups, commission ladders, Store windows, production deadlines and other rules still to be identified.
- Event media and branding should be planned as part of Event public context, not as a disconnected public-form embellishment.
- Event detail should become a visible management unit for C1. Future Event UI should expose linked Product Catalogues and the Products they contribute, so C1 users can inspect Event availability from the Event as well as from Product/Catalogue management.
- Event-side linkage management should operate on Event-to-Catalogue availability. Catalogue-to-Product membership remains Catalogue/Product management, and Project selection remains `FundProjectProduct`.

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

### 4.4 Products, Catalogues And Presentation

Focus:

- richer Product definitions;
- Product media and image galleries;
- Product option modelling;
- option-to-image mapping;
- Catalogue presentation;
- public Store readiness once the core availability model exists.

Core boundary:

```text
Event/Catalogue/Product availability is core 1Q architecture, not optional refinement.
```

This section covers the richer Product/Catalogue presentation layer that improves Store quality and user confidence after the core availability rules are planned.

Wishlist entries:

| Refinement ID | Phase 1 Alias | Name | Intent | Status |
| --- | --- | --- | --- | --- |
| `2R-PRODUCT-01` | none | Product Media, Gallery And Option Definition Planning | Plan Product image galleries, Product option definitions and public/product-admin display expectations. | Wishlist |
| `2R-PRODUCT-02` | none | Product Options, Dependencies And Image Mapping Planning | Decide how options such as size, colour, text, upload/artwork requirements and dependent option combinations are modelled, validated and snapshotted for Project-level production inputs, Store and Order lines. | Wishlist / Store readiness candidate |
| `2R-PRODUCT-03` | `1R-B` schema dependency | Product Duplication Planning | Plan safe C1 duplication of complex Products, including details, pricing, public/admin copy, options, images/media references, workflow defaults and unique naming such as `Product name (copy)` and `Product name (copy 2)`. Copied Products are independent records and may deliberately drift from the original. | Promoted to Phase 1 Store-preparation dependency; implementation not started. |
| `2R-PRODUCT-04` | `1R-A` decision: parked | Product Type / Option Template Planning | Plan reusable C1 tenant-configurable Product Type templates such as Clothing, Printed mug or Artwork upload Product, where the type suggests option groups, controls, required uploads and validation rules without implying stock-control inventory. Store MVP requires Product options, but not reusable Product Type / Option Template modelling. | Wishlist / later refinement; not a Store MVP blocker |
| `2R-CATALOGUE-01` | `1Q` | Catalogue Presentation And Availability Refinement | Refine Catalogue presentation and merchandising after Event/Catalogue/Product availability rules are accepted. | Wishlist |
| `2R-CATALOGUE-02` | none | Catalogue/Product Public Store Readiness Review | Review whether Product and Catalogue presentation is sufficient before Store UI implementation. | Wishlist |
| `2R-CATALOGUE-03` | none | Catalogue Duplication And Product Copy Policy | Plan Catalogue duplication, including reference mode where the new Catalogue links to the same Products, and copy mode where the new Catalogue gets copied Product records. If deep-copying Products, copied Products should receive unique names/slugs/SKUs/references with `(copy)` / numbered suffixes and idempotency protection, and may drift in pricing, commission, copy, options, media and fulfilment behaviour. | Wishlist |
| `2R-CATALOGUE-04` | `1R-A` boundary resolved | Catalogue Product Commercial Terms And Override Planning | Product owns first-pass price, tax category, options and media; C1 tax profile supplies seller/tax rules; Catalogue membership does not override Product commercial terms. Differently priced seasonal/contextual offerings use independent Product copies. | Decision resolved; per-Catalogue overrides parked. |
| `2R-PROJECT-01` | `1Q-G` | Tenant-Defined Project Type Terminology And Suitability Labels | Plan tenant-owned labels/option-set wording for Project workflow types and Product suitability labels, so tenants can use their own terms while preserving stable internal eligibility behaviour. Current first-pass labels include `Individual Artwork Project`, `Group personalised product project`, `Bulk order / club-funded project` and `Not sure yet`. | Wishlist |

Research notes:

- Product eligibility for Events/Projects belongs to `1Q`.
- Store generation should use Project-selected Products, not all active tenant Products.
- Products referenced by multiple eligible Catalogues should collapse to one Project selection and one Store display row.
- Product copies created through duplication are distinct Product records and may appear separately if both original and copy are eligible.
- Core Product options are required for Store MVP because they are central to FUND buyer
  choice, personalisation and production evidence capture.
- Advanced Product gallery/media richness and option-image mapping can be phased if the
  first option model still supports safe Order capture.
- Product option media, Project-level production artwork/files, required purchaser uploads
  and option dependencies should not be bolted on after Orders if the workflow needs
  option/image/artwork evidence.
- Product options are buyer-facing configuration and evidence capture rules, not stock
  inventory. They may include enum/dropdown values, visual colour controls, free text,
  numeric inputs, toggles, multi-selects and image/file upload controls.
- Product option values may be mutually dependent, such as one size offering a different
  set of colours from another size.
- Artwork/file upload is conditional by Project Type/workflow and Product/Product Type
  rules. Some Projects may supply production artwork before purchase, some Orders may need
  purchaser-supplied files at checkout, and some workflows may need no upload at all.
- Upload planning must allow one or more files of different accepted types where the
  workflow requires it, and must make production readiness visible to C1 users.
- A Product Type / Option Template may help C1 configure repeatable option patterns, such
  as Clothing, Artwork upload Product or Logo/bulk order Product, but should not imply SKU
  inventory or stock level management unless a future inventory lane is explicitly planned.
- Product Type / Option Template is parked as later C1 configuration refinement. It should
  not block Store MVP because options can initially be configured directly on Products,
  Project Products or Store Products, and Product duplication can reduce repeated setup.
- Catalogue duplication needs two modes: duplicate Catalogue only as a new Catalogue with the same linked Products, and duplicate Catalogue plus Products as a new Catalogue with copied Products.
- Deep Product copying is powerful but needs careful planning around pricing, commission, public copy, SKUs, slugs, image/media reuse, options, audit history, references and idempotency.
- Buyer-facing price, VAT/tax display policy and public display overrides are distinct from Product selection. They should be planned as commercial terms before Store/Order implementation decides what needs to be snapshotted.
- Project Type terminology affects Project creation, Product suitability and Store/Product
  visibility. Tenant-defined labels should be planned without breaking existing internal
  eligibility codes or historical Project metadata.

### 4.5 C1 Dashboard And Action Widgets

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

### 4.6 Production, Dispatch And Commission

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
| `2R-PROD-05` | `1R-A` / `1R-B` planning dependency | Event And Standalone Project Commission Ladder Planning | Event-linked Projects inherit the authoritative Event flat/ladder policy. Standalone Projects use a C1-managed standalone flat rate or ladder. Stepped policies use Project-close offsets or fixed dates and preserve assigned versions for aggregate Project-sales audit. See `docs/modules/fund/01-cr-inputs/2026-07-13-fund-cr-commission-ladder-planner-input.md`. | Architecture accepted; schema/UI/accounting implementation not started. |

Research notes:

- production may group similar Products across Projects for efficiency;
- Project context remains important even when production is grouped across Projects;
- dispatch is both Project-linked and Client-linked;
- commission planning should consider Event-window offset rules, for example "more than 45 days before close" versus "last-minute sales", and fixed-date ladder thresholds where accepted;
- commission ladders must be considered during Commerce/Orders planning because aggregate Project-sales commission calculation depends on reliable Order sales evidence and ladder/version auditability;
- ladder configuration, buyer-facing sales evidence, aggregate Project sales calculation and later commission accounting/payment must remain distinct planning boundaries.

### 4.7 Notifications And Communications

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
| `2R-COMMS-03` | none | FUND Event And Project Email Sequences Planning | Plan SeasonPro-style domain-window email sequences for FUND Events, Projects, Store windows, artwork deadlines, production deadlines and dispatch milestones, using positive or negative offsets from named anchors such as Event open or Event close. | Wishlist / Future core dependency |
| `2R-COMMS-04` | none | Email Content Editor UX Alignment | Align editable email content surfaces for FUND notifications and sequences with the shared rich text email compose pattern, including a large comfortable data-entry window consistent with the LMSPro ad hoc email editor. | Wishlist |

Research notes:

- required authentication/confirmation emails may remain bounded transactional exceptions until the notification registry exists;
- broader workflow emails should not be scattered through feature code;
- notification content and trigger behaviour should be managed centrally;
- background email planning lives in `/Volumes/isostack/Git/isostack-bedrock/docs/00-READ_THIS/EMAIL_SERVICES/`;
- read `README.md`, `core-system-email-planning.md`, `seasonpro-email-reference-model.md` and `fund-event-email-scheduling-application.md` before promoting FUND email work;
- FUND should reuse the shared core email vocabulary: hard-coded transactional email, notification email, scheduled sequence and ad hoc email;
- SeasonPro/LMSPro is the working precedent for notification settings, recipient providers, sequence management and ad hoc email composition;
- the LMSPro Key Date precedent should be treated as the scheduling model: one domain window can have many email steps, each with recipients and an offset before or after open/close;
- notification and sequence body editors should not regress to cramped plain text inputs where the richer shared email editor pattern is available;
- email content editing should support longer copy, formatting, shortcodes/placeholders, preview/review affordances and comfortable drafting before send/save.

### 4.8 SeasonPro Integration

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
2R-EVENT-04 - Event Domain Window And Key Date Precedent Planning
2R-CLIENT-01 - Client Organisation Type Option Set Planning
2R-PRODUCT-01 - Product Media, Gallery And Option Definition Planning
2R-PRODUCT-02 - Product Option Image Mapping Planning
2R-PROD-05 - Event-Window Commission Ladder Planning
2R-COMMS-01 - FUND System Notifications And Editable Email Defaults Planning
2R-COMMS-03 - FUND Event And Project Email Sequences Planning
2R-COMMS-04 - Email Content Editor UX Alignment
```

These are valuable but should not displace Phase 1 core architecture unless they become a promotion blocker.

## 7. Immediate Control Note

The current Phase 1 priority after accepted `1R-A`, `1R-B`, `1R-C` and Commerce Core
foundation planning is:

```text
Review 1R-C1 - FUND Product Media/Input/Tax/Duplication Schema Implementation Planning
```

Planning documents:

```text
docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c1-product-media-input-tax-duplication-schema-implementation-planning.md
docs/core/commerce/03-slice-planning/2026-07-13-isostack-commerce-core-slice-commerce-a1-schema-seller-profile-enums-implementation-planning.md
```

Promoted wishlist boundaries are now recorded in `1R-B`/`1R-C`. Remaining wishlist items
should stay parked unless review shows that they block a safe FUND Store foundation or the
generic Commerce Core contract.
