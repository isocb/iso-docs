# FUND Future Phase Notes

> Legacy planning document. Superseded by:
> - 01-fund-module-brief.md
> - 02-fund-architecture-principles.md
>
> Do not use this as the active Phase 1 implementation plan without revision.


**Module:** FUND  
**Status:** Planning notes for phases after Phase 1  
**Purpose:** Capture future implementation direction without overloading the active Phase 1 backlog.  
**Canonical context:** `FUND_MODULE_BRIEF.md`  
**Current active build plan:** `FUND_PHASE1_IMPLEMENTATION_BACKLOG.md`

---

## 1. Purpose of this Document

This document records future phase considerations for the FUND module.

It should not be treated as an implementation instruction for the current build phase. Its purpose is to preserve useful thinking about later work while keeping Phase 1 focused on the database foundation and core admin surface.

Codex and future developers should use this document only after checking:

1. the current module status;
2. the canonical FUND brief;
3. the current active phase backlog;
4. the IsoStack Codex Operating Charter.

---

## 2. Current Position

FUND is being developed as a reusable IsoStack module for:

- fundraising;
- e-commerce;
- project lifecycle management;
- organiser engagement;
- commission distribution;
- production coordination;
- dashboard-led operational control.

AMOW is the founding use case and likely initial production / fulfilment partner, but AMOW is not the module identity.

Phase 1 is expected to establish:

- module registration;
- database foundation;
- PostgreSQL `fund` schema separation where appropriate;
- tenant-safe core models;
- basic admin CRUD;
- tRPC routers;
- validation;
- audit logging;
- initial demo/seed data.

Future phases should build on that foundation without undermining tenant isolation, migration safety or configurability.

---

## 3. Phase 2 — Project Flow and Organiser Dashboard

### Goal

Create a usable Project creation and management flow for organisers and tenant administrators.

### Likely Capabilities

- Project creation wizard or guided form.
- Project Number generation.
- Event-linked Project configuration.
- Project closing date validation.
- Project status display.
- Store placeholder/status display.
- Organiser dashboard.
- Required-action prompts.
- Project summary cards.
- Basic project timeline.

### Key Questions

- Should Project Numbers be globally unique, tenant-specific or Event-specific?
- Can Organisers be non-user contacts initially, or must they be IsoStack users?
- Should the Organiser dashboard be available only to authenticated users?
- Which Project states are required before the full lifecycle engine exists?
- What is the minimum useful Project status model before automation?

### Acceptance Direction

A tenant admin or organiser should be able to create and review a fundraising Project without needing store, payment, production or commission automation to be complete.

---

## 4. Phase 3 — Store and Order Integration

### Goal

Allow Projects to generate or connect to Stores and capture Orders.

### Likely Capabilities

- Store generation or Store link association.
- Store slug/URL generation.
- Store open/closed status.
- Store product selection.
- Basic basket/order flow.
- Stripe Checkout integration.
- Stripe payment success/failure handling.
- Order and Order Item recording.
- Store closure enforcement.
- Order export.

### Key Questions

- Should the first Store be a native IsoStack Store or an integration with an external storefront?
- Should customers have accounts, or should purchasing remain accountless?
- How will customer data be stored and protected?
- What metadata must be passed into Stripe Checkout?
- How will Orders be linked reliably to Projects?
- What is the minimum viable refund/cancellation model?
- How will VAT status and tax reporting be handled?

### Acceptance Direction

A test customer should be able to place a paid order through a Project Store in Stripe test mode, and that Order should appear against the correct Project.

---

## 5. Phase 4 — Commission Engine

### Goal

Calculate configurable revenue shares for platform, producer, organiser, league, club or other stakeholders.

### Likely Capabilities

- Commission rule configuration.
- Commission participants.
- Commission by Product, Event, Project or Tenant.
- Commission Line generation from paid Orders.
- Commission summaries.
- Commission export.
- Commission statement generation.
- Refund/cancellation adjustment logic.

### Key Questions

- Should commission be calculated on gross, net-of-VAT, net-of-fees or another basis?
- Are Stripe/payment fees deducted before commission?
- Are production costs represented separately from commission?
- Should commission rules be versioned?
- When does commission become payable?
- How are refunds, chargebacks and cancelled Orders handled?
- Should commission be recalculated or locked once issued?

### Acceptance Direction

Paid Orders should create reviewable Commission Lines using configurable rules, with no hard-coded AMOW, league or club percentages.

---

## 6. Phase 5 — Lifecycle Automation and Communications

### Goal

Introduce the lifecycle engine, key dates and automated communications.

### Likely Capabilities

- Lifecycle templates.
- Lifecycle states.
- Lifecycle transitions.
- Key Dates.
- Date-based email sequences.
- Lifecycle-triggered notifications.
- Re-arming of pending communications when dates change.
- Sent email logging.
- Manual reset/re-send for selected communication steps.
- Dashboard indicators for lifecycle status.

### Suggested Standard Lifecycle

```text
Draft
→ Created
→ Products Selected
→ Template Ready
→ Store Open
→ Selling
→ Closing Soon
→ Closed
→ Artwork / Data Received
→ Validated
→ Production
→ Dispatched
→ Commission Issued
→ Complete
```

### Key Questions

- Which lifecycle states are universal?
- Which lifecycle states should be configurable by Event or Product type?
- Should lifecycle transitions be manual, automatic or both?
- Should Key Dates belong to Events, Projects or both?
- How much of the SeasonPro key-date/email-sequence logic can be reused?
- How should communications be previewed before sending?
- What audit events are required for lifecycle state changes?

### Acceptance Direction

A Project should be able to move through a clear lifecycle, and selected dates or states should trigger tenant-safe, logged communications.

---

## 7. Phase 6 — SeasonPro Integration

### Goal

Enable SeasonPro tenants, leagues and clubs to use FUND without making FUND football-specific.

### Likely Capabilities

- FUND enablement for SeasonPro tenants.
- League-level fundraising opportunities.
- Club-level Project creation or opt-in.
- Club-specific Store generation.
- League and Club dashboards.
- League and Club commission reporting.
- Shared tenant and role permission mapping.
- Cross-module navigation between SeasonPro and FUND.

### Key Questions

- How do SeasonPro league and club records map to FUND Organisers?
- Are clubs full Tenants, child organisations, or module-specific participants?
- Who owns the Project data: league tenant, club tenant or fundraising producer?
- Should Clubs manage their own FUND Projects through the SeasonPro portal?
- How are permissions inherited from SeasonPro?
- How is commission split between producer, platform, league and club?
- How should FUND appear in SeasonPro packaging and pricing?

### Acceptance Direction

A SeasonPro League should be able to enable a fundraising campaign, allow Clubs to participate, and see sales/commission summaries without FUND becoming football-only.

---

## 8. Phase 7 — Production and Fulfilment

### Goal

Support production management from validated orders to dispatch.

### Likely Capabilities

- Production dashboard.
- Production batches.
- Order-to-batch assignment.
- Artwork/data validation.
- Production task tracking.
- Production partner assignment.
- Dispatch status.
- Delivery records.
- Production exception handling.
- Export formats for fulfilment.
- Attach generated outputs to Projects, Orders or Batches.

### Key Questions

- What exact production exports does AMOW require?
- Are production batches grouped by Event, Project, Product, deadline or supplier?
- Can multiple Production Partners fulfil different Products within the same Event?
- What dispatch data is required?
- Should customers receive dispatch notifications?
- How should production exceptions be reported to Organisers?
- Should production workflow states be separate from Project lifecycle states?

### Acceptance Direction

A Production Partner should be able to see what needs producing, group work into batches, track fulfilment and update dispatch status.

---

## 9. Phase 8 — AI Assistance and Marketplace Expansion

### Goal

Add intelligent assistance and prepare FUND for a wider producer / marketplace model.

### Likely AI Capabilities

- Generate organiser emails.
- Summarise Project status.
- Create producer to-do lists.
- Detect missing information.
- Draft sales updates.
- Generate production summaries.
- Assist support responses.
- Flag lifecycle or deadline risks.
- Generate test scenarios.
- Explain dashboard data.

### Likely Marketplace Capabilities

- Multiple Producers.
- Multiple Production Partners.
- Product discovery by eligible Tenants.
- Product/package enablement.
- Commission rule templates.
- Supplier onboarding.
- Product availability rules.
- Tenant-specific catalogue curation.

### Key Questions

- What AI actions are advisory only?
- What AI actions can create draft communications?
- What AI actions can trigger workflow changes?
- What human approval is required before AI-generated content is sent?
- How are prompts, outputs and decisions logged?
- How are multiple Producers governed?
- Can AMOW receive commission or platform advantage as the founding Producer?
- What marketplace rules must be configurable?

### Acceptance Direction

AI should assist structured workflows rather than replace them. Marketplace expansion should allow new Producers and Production Partners without creating bespoke forks.

---

## 10. Cross-Phase Principles

Future phases must preserve the following:

### 10.1 Tenant Safety

Every tenant-owned record must remain scoped by `organizationId` or the correct IsoStack tenancy equivalent.

PostgreSQL schema separation is for module organisation, not tenant security.

### 10.2 Migration Safety

All database changes must use Prisma migrations.

Do not use `db:push`.

Do not run destructive reset/seed commands without explicit approval.

### 10.3 Configurability

Avoid hard-coding:

- AMOW;
- Christmas;
- specific product types beyond reusable categories;
- commission percentages;
- production partners;
- league or club rules;
- email wording;
- lifecycle labels unless intentionally defined as default templates.

### 10.4 Historical Integrity

Products, prices, Orders, commission rules and production status must remain historically meaningful.

Do not overwrite historical values where a versioned or copied value is required.

### 10.5 Clear Module Boundaries

FUND should own fundraising-specific business logic.

IsoStack should continue to own shared services such as auth, tenancy, audit logging, payments, file storage, notifications, feature flags, module access and platform settings.

### 10.6 Phase Discipline

Do not allow future features to leak into Phase 1 unless they are required as safe placeholders for the foundation.

Each future phase should have its own reviewable backlog before implementation starts.

---

## 11. Parking Lot

Use this section for ideas that may be valuable later but should not distract from the active phase.

- Public fundraising landing pages.
- Short campaign URLs.
- QR codes for Project Stores.
- Social sharing assets.
- Automated sales nudges for Organisers.
- Parent/customer reorder links.
- Support for discount codes.
- Support for early-bird commission incentives.
- Support for grouped school/class orders.
- Support for club/team sub-projects.
- Support for white-labelled producer portals.
- Integration with SeasonPro club pages.
- AI-generated campaign copy.
- AI-generated artwork checks.
- AI-generated production exception summaries.
- Customer-facing delivery tracking.
- Marketplace product approval workflow.
- Producer performance dashboard.
- Multi-currency support.
- Gift Aid support for charity campaigns, if appropriate.
- Direct debit or GoCardless-style fundraiser subscription options, if ever relevant.

---

## 12. Suggested Rule for Codex

When Codex is asked to work on a future phase, use this rule:

```text
Do not implement from future_phase_notes.md directly.

First create a phase-specific implementation backlog for the requested phase, following the same structure as FUND_PHASE1_IMPLEMENTATION_BACKLOG.md.

The backlog must identify:
- scope;
- out-of-scope items;
- models;
- routes;
- routers;
- services;
- permissions;
- tenant scoping;
- validation;
- audit events;
- seed/demo data;
- risks;
- manual tests.

Only after that backlog is reviewed should implementation begin.
```

---

## 13. Status

This is a planning note only.

No code changes, schema changes, migrations, routers, UI routes or workflow implementations are authorised by this document alone.
