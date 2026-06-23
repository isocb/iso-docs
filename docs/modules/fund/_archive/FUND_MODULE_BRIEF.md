# FUND Module Brief — Canonical Overarching Document

**Canonical location:** `isodocs/docs/modules/fund/FUND_MODULE_BRIEF.md`  
**Module slug:** `fund`  
**Platform:** IsoStack  
**Related product/module:** SeasonPro / LMSPro  
**Founding use case / production partner:** All My Own Work (AMOW)  
**Status:** Planning / ready for phased build  
**Document purpose:** Product, architecture, workflow and AI-development briefing for the FUND module.

---

## 1. Document Purpose

This document is the single overarching brief for the FUND module.

It consolidates the earlier FUND functional specification, FUND planning considerations, AI handoff notes and Codex operating guidance into one reference document that can be used by:

- Isoblue;
- Sue and Chris;
- future developers;
- AI coding assistants such as Codex;
- client discussions;
- future module expansion planning.

This document should be treated as product and architecture context, not as a final database schema or final UI specification.

Where implementation details are required, Codex or future developers must inspect the current IsoStack repository and follow existing platform patterns.

---

## 2. Executive Summary

FUND is a reusable IsoStack module for:

- fundraising;
- e-commerce;
- project lifecycle management;
- organiser engagement;
- commission distribution;
- production coordination;
- dashboard-led operational control.

FUND originated from the operational requirements of **All My Own Work (AMOW)**, but AMOW is **not** the module identity.

AMOW should be represented through configuration and data as one or more of the following:

- founding use case;
- tenant;
- product catalogue owner;
- production partner;
- fulfilment partner;
- dispatch partner;
- seed/demo data context.

FUND itself is the reusable platform module.

The module must be capable of supporting:

- schools;
- PTAs;
- football clubs;
- football leagues;
- community organisations;
- charities;
- membership bodies;
- future fundraising and production tenants.

The long-term opportunity is that a tenant such as a SeasonPro football league can enable fundraising opportunities for its clubs, with product supply and fulfilment handled by AMOW or another production partner, while commission is distributed automatically between relevant stakeholders.

---

## 3. Current Implementation Status

FUND is currently **planning-only**.

At the time of this document:

- no FUND Prisma models have been created;
- no FUND migrations have been created;
- no FUND tRPC routers have been created;
- no FUND UI routes have been created;
- no FUND production workflow has been built;
- no FUND commerce integration has been implemented.

The current work is Phase 0: project identity, documentation consolidation and implementation planning.

Codex must not assume that files, models, routes or database structures exist until it has inspected the repository.

---

## 4. Relationship to IsoStack

FUND must be built as a module within IsoStack, not as a separate application and not as an AMOW-specific fork.

IsoStack provides the reusable platform infrastructure.

FUND consumes IsoStack services and adds fundraising-specific business logic.

### 4.1 IsoStack Provides

IsoStack is expected to provide or own the following cross-cutting platform capabilities:

#### Identity and Security

- user accounts;
- organisations;
- tenancy;
- roles;
- permissions;
- authentication;
- magic links;
- MFA / biometric readiness where supported;
- audit logging.

#### Data Layer

- PostgreSQL database;
- Prisma ORM;
- tenant isolation;
- migration workflow;
- soft delete where appropriate;
- versioning or historical preservation where appropriate;
- audit trails.

#### Communications

- email services;
- notification services;
- template management;
- Resend integration;
- future automation triggers.

#### E-Commerce Services

- shopping cart capability;
- Stripe integration;
- orders;
- payments;
- refunds;
- payment lifecycle tracking.

#### Dashboard Framework

- navigation;
- reusable widgets;
- reporting components;
- charts;
- KPIs;
- search;
- tenant-aware dashboards.

#### Automation Framework

- scheduled tasks;
- event triggers;
- workflow engine;
- date-based automation;
- future AI-assisted workflow hooks.

#### File Management

- document storage;
- image storage;
- upload handling;
- optional Cloudflare R2 storage;
- PDF generation;
- generated output storage.

### 4.2 FUND Responsibilities

FUND provides the domain-specific logic relating to:

- fundraising campaigns;
- Events;
- Projects;
- project Stores;
- product availability within fundraising contexts;
- Organisers;
- commission rules;
- production workflow;
- artwork/data handling;
- project dashboards;
- organiser engagement;
- SeasonPro fundraising integration.

FUND must not recreate IsoStack infrastructure.

---

## 5. Relationship to SeasonPro

SeasonPro is the marketing name of LMSPro and is already built on IsoStack.

FUND should be designed as a sibling module that can integrate with SeasonPro but does not depend on it.

The strategic opportunity is that a SeasonPro tenant, such as a football league, can become a fundraising channel.

Example flow:

1. SeasonPro League Tenant enables FUND.
2. League selects approved fundraising products or product groups.
3. Clubs become Organisers or project participants.
4. Each participating club receives a project/storefront or fundraising page.
5. Parents/supporters place orders.
6. Orders are linked to the relevant Project and Club.
7. Revenue and commission are calculated.
8. AMOW or another production partner fulfils the products.
9. League and clubs can view sales and commission through dashboards.

This allows FUND to create additional value inside SeasonPro without hard-coding football-specific assumptions into the FUND core.

---

## 6. Core Design Principle

FUND must be both:

1. **Specific enough** to solve the AMOW workflow properly.
2. **Generic enough** to become a reusable IsoStack fundraising module.

The system should be built around configurable entities and workflows rather than hard-coded seasonal assumptions.

Examples:

- AMOW Christmas campaign is a specific example of an Event.
- Mother’s Day is another Event.
- A school summer fair can be a client-defined Event.
- A SeasonPro club fundraising campaign is another variant.
- A leavers product campaign can be another Event or Project type.

The underlying concepts should remain consistent.

---

## 7. Key Architectural Rule

Products, Projects, Events, Stores and Orders must be tenant-aware.

A product should belong to a Tenant. A Tenant may act in one or more business roles:

- Producer;
- Production Partner;
- Fulfilment Partner;
- Fundraising Operator;
- League;
- Club;
- School;
- Organiser;
- Platform Owner.

This avoids a separate ownership model that conflicts with IsoStack’s multi-tenant architecture.

Where the word **Producer** is used, it should be understood as a role a Tenant may perform, not as a separate platform identity outside tenancy.

---

## 8. Core Terminology

The following terminology should be used consistently unless replaced by a documented decision.

### 8.1 Tenant

An IsoStack organisation account.

A Tenant may be:

- AMOW;
- a school;
- a PTA;
- a football league;
- a football club;
- a community organisation;
- a charity;
- a producer;
- a fulfilment supplier.

### 8.2 Producer

A Tenant acting as the organisation responsible for defining and/or supplying products.

Initial Producer context: AMOW.

Future Producers may include printers, merchandise suppliers or other fundraising product providers.

### 8.3 Production Partner

A Tenant or supplier responsible for producing, fulfilling or dispatching products.

Initially AMOW may act as:

- primary production partner;
- fulfilment partner;
- dispatch partner.

Future products may be assigned to:

- AMOW;
- Supplier A;
- Supplier B;
- another production partner.

This must not require changes to FUND’s core workflow.

### 8.4 Product

An item that can be sold through a fundraising campaign.

Examples:

- Christmas card pack;
- mug;
- tea towel;
- water bottle;
- leavers product;
- personalised print item;
- sportswear;
- hoodie;
- trophy;
- calendar.

Products belong to Tenants and are never owned by FUND itself.

### 8.5 Product Category / Product Type

Products should support different operational behaviours.

Initial product categories:

#### Standard Products

Purchased without modification.

#### Artwork Products

Require artwork submission, validation or output generation.

#### Personalised Products

Require customer or organiser personalisation data.

Examples:

- water bottles with names;
- mugs with names;
- leavers products;
- group artwork products.

### 8.6 Catalogue

A set of products made available for selection.

A Tenant can create catalogues. A catalogue can be associated with one or more Events or campaign types.

### 8.7 Event

The primary grouping mechanism for fundraising activity.

Examples:

- Christmas 2026;
- Mother’s Day 2027;
- Father’s Day 2027;
- Easter 2027;
- Leavers 2027;
- Playground Appeal;
- Sports Tour.

An Event may define:

- event name;
- event date;
- campaign opening date;
- artwork deadline;
- store close deadline;
- production deadline;
- product selection;
- commission rules;
- lifecycle rules;
- default communication sequences;
- branding, terms and policies.

### 8.8 Season

Season may be used as an operational or marketing term where helpful, especially for AMOW or recurring campaigns.

However, in the core FUND model, **Event** should be treated as the primary campaign grouping object unless the codebase establishes a clearer distinction.

Suggested rule:

- Use **Event** for the core data model.
- Use **Season** as a display or grouping label where it helps users understand recurring campaign periods.

### 8.9 Organiser

The person or organisation initiating or managing a fundraising Project.

Examples:

- school contact;
- PTA organiser;
- club secretary;
- SeasonPro club admin;
- league fundraising contact.

### 8.10 Project

The operational unit of fundraising.

Each Project belongs to an Event.

Examples:

- St Mark’s Primary Christmas 2026 card project;
- Northgate Juniors U10 leavers bottle project;
- Riverside United club fundraising store;
- Derby League club fundraising project.

A Project should have:

- unique project number;
- project name;
- organiser;
- Event;
- Store;
- closing date;
- lifecycle state;
- selected products;
- communication history;
- production status;
- commission settings or inherited commission rules.

### 8.11 Store

The public or semi-public ordering surface for a Project.

Each Project should generate or be associated with a unique Store.

A Store may be:

- a generated IsoStack storefront;
- a Stripe Checkout-based store;
- an embedded checkout page;
- an externally hosted storefront;
- a future commerce integration.

The internal model must not be tied unnecessarily to one commerce provider.

### 8.12 Sale / Order

A purchase made through a Project Store.

Orders should be linkable to:

- Project;
- Store;
- Product;
- Order Items;
- customer;
- payment status;
- fulfilment status;
- production batch;
- commission calculation;
- export/reporting requirements.

### 8.13 Commission

A configured percentage or fixed value assigned to participating stakeholders.

Possible participants:

- Isoblue;
- Producer;
- Production Partner;
- Fundraising Operator;
- League;
- Club;
- School;
- Organiser.

Example values previously discussed:

- Isoblue: 2.5%;
- League Tenant: 1.5%;
- Club: 1.5%.

These are examples only and must be configurable, not hard-coded.

---

## 9. User Roles

### 9.1 Isoblue Platform Owner

Responsible for:

- module configuration;
- tenant onboarding;
- global settings;
- support;
- feature flags;
- integration management;
- cross-tenant oversight;
- product packaging.

### 9.2 Tenant Admin

Responsible for:

- managing users within their organisation;
- managing organisation-level settings;
- accessing tenant-level reporting;
- controlling tenant participation in FUND.

### 9.3 Producer Admin

Responsible for:

- product catalogues;
- product pricing;
- product availability;
- Event creation;
- production deadlines;
- fulfilment settings;
- project monitoring;
- production reporting.

### 9.4 Production Staff

Responsible for:

- artwork/data checking;
- production queue management;
- batching;
- fulfilment;
- dispatch;
- status updates.

### 9.5 Organiser

Responsible for:

- creating or managing Projects;
- selecting available products;
- uploading artwork or data;
- managing project details;
- sharing Store links;
- monitoring sales;
- reviewing commission information;
- communicating with supporters where appropriate.

### 9.6 SeasonPro League Admin

Where FUND is enabled for a SeasonPro tenant.

Responsible for:

- enabling fundraising for the league;
- selecting products or fundraising opportunities;
- viewing club participation;
- monitoring aggregate sales;
- understanding league commission.

### 9.7 Club Admin

Where FUND is used through SeasonPro.

Responsible for:

- creating or confirming a club fundraising Project;
- sharing the club Store link;
- monitoring club sales;
- receiving club commission information.

### 9.8 Customer / Parent / Supporter

Responsible for:

- visiting a Store;
- choosing products;
- placing an order;
- making payment;
- receiving order confirmation;
- receiving fulfilment or dispatch updates where applicable.

Customers may not need an IsoStack account.

---

## 10. Strategic Objectives

FUND should help Isoblue and its clients:

1. Reduce dependency on disconnected tools.
2. Replace fragile form / automation / spreadsheet / store workflows with a coherent system.
3. Support seasonal fundraising with clear deadline management.
4. Allow AMOW to manage projects and production more efficiently.
5. Allow Organisers to self-serve and track progress.
6. Allow future Producers and Production Partners to join the platform.
7. Allow SeasonPro tenants and clubs to access fundraising opportunities.
8. Support commission-based revenue.
9. Improve client communication through automated email sequences.
10. Create a future-ready base for AI-assisted workflows.
11. Protect historical fundraising, sales and commission data.
12. Enable future marketplace-style fundraising capability.

---

## 11. What FUND Must Avoid

FUND should not become:

- a hard-coded AMOW workflow;
- a one-season-only system;
- a hidden spreadsheet replacement with no real workflow model;
- a thin wrapper around an external shop;
- a system dependent on a single third-party automation tool;
- a product catalogue with no project lifecycle;
- a manual order admin system with a dashboard bolted on later;
- a SeasonPro-only feature;
- a football-specific fundraising module;
- a module that bypasses IsoStack tenancy, permissions or audit conventions.

The core value lies in combining:

- project lifecycle management;
- product selection;
- Store/order handling;
- deadline control;
- organiser engagement;
- production coordination;
- commission reporting;
- dashboard visibility.

---

## 12. Core Functional Areas

### 12.1 Product and Catalogue Management

Required capabilities:

- create Products;
- assign Products to a Tenant;
- define Product metadata;
- define Product category/type;
- define Product availability;
- group Products into Catalogues;
- assign Catalogues to Events;
- manage prices;
- manage VAT status;
- define production partner where applicable;
- define personalisation rules;
- manage images and descriptions;
- support product retirement without losing history.

Future capabilities:

- Product variants;
- size and colour options;
- artwork templates;
- bulk customisation;
- generated previews;
- production rules;
- supplier-specific fulfilment instructions.

### 12.2 Event Management

Required capabilities:

- create Events;
- define Event name;
- define Event date;
- define campaign open date;
- define Store closing deadline;
- define production deadline;
- assign Products or Catalogues;
- define commission rules;
- define lifecycle rules;
- define communication sequences;
- define terms, policies and branding inheritance;
- activate/deactivate Event.

Example Event:

- Event Name: Christmas 2026;
- Event Date: 25 December 2026;
- Production Deadline: 15 December 2026;
- Store close deadline: configured at Event level;
- Products: selected from AMOW Christmas Catalogue 2026.

### 12.3 Project Management

Required capabilities:

- create a Project;
- assign Project to an Event;
- assign Organiser;
- generate unique Project Number;
- define Project name;
- define Project closing date;
- enforce closing date constraints;
- select available products;
- create or associate Store;
- track lifecycle state;
- track production state;
- track commission state.

Validation rule:

```text
Project Closing Date must be less than or equal to Event Production Deadline.
```

Projects may close earlier. Projects may never close later.

### 12.4 Project Types

Initial Project types should support:

#### Seasonal Fundraising

Projects within AMOW or Tenant-defined Events.

Examples:

- Christmas;
- Mother’s Day;
- Easter.

#### Client-Defined Fundraising

Created outside the normal Event calendar.

Examples:

- Playground Appeal;
- Sports Tour;
- Club Fundraising Drive.

These should be internally treated as Events or Event-backed Projects, not as a separate workflow unless a clear reason emerges.

#### Mass Customisation

Supports:

- personalised products;
- bulk orders;
- name uploads;
- artwork/data validation;
- production exports.

### 12.5 Project Lifecycle Engine

The lifecycle engine is the core orchestration mechanism.

Every Project follows a lifecycle.

Suggested standard lifecycle:

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

Each lifecycle state may:

- trigger notifications;
- trigger automation;
- generate tasks;
- update dashboards;
- create reports;
- enable or disable UI actions;
- update customer or organiser visibility.

The lifecycle must be configurable enough to support different Product types and Production Partners.

### 12.6 Store Engine

Required capabilities:

- generate or associate a unique Store for each Project;
- generate Store URL automatically where possible;
- inherit available products from Event;
- inherit prices from Event/Product configuration;
- inherit branding, terms and policies;
- support Store open and close state;
- support order capture;
- pass Project Number and metadata into Orders;
- link Orders back to the Project.

Store closure rule:

```text
Store closes automatically at 23:59 on Project Closing Date,
but never later than 23:59 on Event Production Deadline.
```

### 12.7 Payments and Order Handling

Required capabilities:

- support Stripe Checkout or IsoStack payment flow;
- capture payment lifecycle;
- record Orders;
- record Order Items;
- record refunds or cancellations;
- associate Orders with Projects;
- associate Order Items with Products;
- calculate totals;
- provide exportable order data;
- protect historical price/order records.

The commerce layer may evolve, but the internal order model must remain coherent.

### 12.8 Artwork and Data Handling

Required capabilities:

- upload artwork files;
- upload personalisation data;
- validate submitted files/data;
- associate files with Projects, Products, Orders or Production Batches;
- store generated outputs;
- support PDF/output generation;
- support production exports.

Future capabilities:

- AI-assisted validation;
- automatic proof generation;
- template-based output generation;
- production-ready batch export.

### 12.9 Production Management

Initial model:

AMOW acts as:

- primary production partner;
- fulfilment partner;
- dispatch partner.

Future model:

- multiple production partners;
- product-specific production partners;
- outsourced fulfilment;
- production dashboards;
- dispatch tracking;
- production batch assignment.

Required capabilities:

- view production queue;
- group Orders into batches;
- track artwork/data status;
- track production status;
- track dispatch status;
- export production files;
- report production exceptions.

### 12.10 Dashboard Requirements

Initial dashboard types:

#### Operations Dashboard

Audience:

- Tenant Administrators;
- Producer Admins;
- Production Staff;
- Isoblue where appropriate.

Purpose:

- operational control.

Displays:

- Events;
- Projects;
- revenue;
- production;
- dispatch;
- exceptions;
- upcoming deadlines;
- Stores closing soon;
- missing artwork/data.

#### Organiser Dashboard

Audience:

- schools;
- clubs;
- fundraisers;
- SeasonPro club users.

Purpose:

- engagement and project management.

Displays:

- Store link;
- Project status;
- sales progress;
- key dates;
- production status;
- dispatch status;
- commission information;
- required actions.

#### SeasonPro League Dashboard

Audience:

- League Admins.

Purpose:

- league-level fundraising oversight.

Displays:

- participating clubs;
- club Stores;
- aggregate sales;
- league commission;
- deadlines;
- exceptions.

### 12.11 Communications Engine

FUND should reuse the SeasonPro concept of Key Dates and email sequences where possible.

Required capabilities:

- define email templates;
- attach email steps to dates or lifecycle states;
- offset emails before/after dates;
- re-arm sequences if dates change;
- log email sends;
- allow manual reset/re-send where appropriate.

Organiser communication examples:

- Project Created;
- Template Ready;
- Store Open;
- Reminder;
- Closing Soon;
- Closed;
- Production Started;
- Dispatched;
- Commission Statement Available.

Customer communication examples:

- Order Confirmation;
- Store Reminder;
- Payment Confirmation;
- Dispatch Notification.

### 12.12 Commission Engine

Required capabilities:

- define commission participants;
- define commission rates;
- apply rules by Product, Project, Event or Tenant;
- calculate commission per Order or Order Item;
- calculate totals by participant;
- support reporting;
- support statements or exports;
- support refund/cancellation adjustments.

Commission types may include:

- platform commission;
- tenant commission;
- organisation commission;
- club commission;
- producer margin;
- production margin.

All values must be configurable.

No commission value should be hard-coded.

### 12.13 AI-Assisted Future Workflows

Future AI capabilities may include:

- generating organiser emails;
- summarising Project status;
- creating producer to-do lists;
- detecting missing information;
- writing sales updates;
- producing production summaries;
- assisting support responses;
- flagging deadline or lifecycle risks;
- generating test scenarios;
- generating dashboard explanations.

AI should be added only after the structured data model and lifecycle engine are sound.

---

## 13. Conceptual Data Model

This is not a final Prisma schema. It is a conceptual model for development planning.

Potential core entities:

- FundEvent
- FundProject
- FundProjectType
- FundProjectLifecycleState
- FundLifecycleRule
- FundStore
- FundCatalogue
- FundProduct
- FundProductVariant
- FundProductCategory
- FundProjectProduct
- FundOrder
- FundOrderItem
- FundPayment
- FundRefund
- FundCommissionRule
- FundCommissionLine
- FundProductionPartner
- FundProductionBatch
- FundArtworkAsset
- FundPersonalisationData
- FundExport
- FundEmailTemplate
- FundEmailSequence
- FundEmailSequenceStep
- FundKeyDate
- FundDashboardMetric

Relationship principles:

- Products belong to Tenants.
- Catalogues belong to Tenants.
- Events belong to Tenants.
- Events may use one or more Catalogues.
- Projects belong to Events.
- Projects are created by or for Organisers.
- Stores belong to Projects.
- Orders belong to Stores and Projects.
- Order Items belong to Orders and Products.
- Commission Lines are generated from Orders or Order Items.
- Production Batches group Orders or Order Items.
- Key Dates belong to Events and/or Projects.
- Email Sequences attach to Key Dates or lifecycle states.
- Every tenant-level record must be scoped by `organizationId` or the correct IsoStack tenancy equivalent.

---

## 14. Suggested Module Structure

Codex must inspect the repository before assuming exact paths, but the expected module structure is:

```text
src/modules/fund/
├── module.config.ts
├── docs/
├── routers/
├── schemas/
├── services/
├── components/
└── lib/

src/app/(app)/app/fund/
```

Canonical planning documentation should live in:

```text
isodocs/docs/modules/fund/
```

Code-adjacent docs in the application repository should be short pointers or implementation notes, not duplicate canonical planning documents.

---

## 15. Phased Development Plan

### Phase 0 — Planning, Mapping and Decisions

Current phase.

Goals:

- consolidate documentation;
- confirm terminology;
- confirm that FUND replaces AMOW as module identity;
- map AMOW seasonal workflow;
- map client-defined fundraising workflow;
- identify shared lifecycle stages;
- define minimum viable entities;
- confirm initial commerce approach;
- confirm module structure;
- confirm AI/Codex working rules.

Outputs:

- canonical module brief;
- functional specification;
- implementation status note;
- AI handoff;
- open questions list;
- first build backlog.

### Phase 1 — Database Foundation and Core Admin Surface

Goals:

- create module structure;
- create core Prisma models under the appropriate FUND schema or namespace;
- create Producer/Tenant-linked Product, Catalogue, Event and Project foundation;
- create basic admin UI;
- create seed/demo data;
- establish permissions;
- establish audit logging.

Success criteria:

- Isoblue can create or view FUND configuration.
- A Tenant can own Products.
- Products can be grouped into Catalogues.
- An Event can be created and linked to Products/Catalogues.
- A Project can be created against an Event.
- No tenant leakage is possible.

### Phase 2 — Project Creation and Organiser Dashboard

Goals:

- create Project creation flow;
- generate Project Numbers;
- enforce Project closing date constraints;
- create Organiser-facing dashboard;
- expose Store status and required actions;
- show key dates.

Success criteria:

- Organiser can see relevant Project information only.
- Project inherits relevant Event constraints.
- Project status is visible and understandable.

### Phase 3 — Store and Order Integration

Goals:

- connect or simulate Store layer;
- capture Orders;
- link Orders to Projects;
- track payment state;
- support project sales totals;
- provide order export.

Success criteria:

- test Orders are linked to the correct Project.
- Producer and Organiser dashboards reflect sales.
- Order data is exportable.

### Phase 4 — Commission Engine

Goals:

- configure commission participants;
- configure rates;
- calculate commission lines;
- show commission summaries;
- support statement/export generation.

Success criteria:

- Isoblue, Producer, League, Club and Organiser commission can be calculated as configured.
- no commission values are hard-coded.
- refunds/cancellations have an understood impact model.

### Phase 5 — Key Dates, Lifecycle Automation and Communications

Goals:

- create lifecycle engine;
- adapt SeasonPro-style key date/email sequence logic;
- create default fundraising sequences;
- send reminders through Resend;
- support re-arming when dates change;
- log sent emails.

Success criteria:

- key dates and lifecycle states can trigger email steps.
- changed deadlines update pending email schedules.
- significant communication events are logged.

### Phase 6 — SeasonPro Integration

Goals:

- allow SeasonPro tenant to enable FUND;
- allow league-level fundraising opportunities;
- allow clubs to create or access fundraising Projects;
- allow league/club commission reporting.

Success criteria:

- a SeasonPro League can participate in a FUND campaign.
- Clubs can be linked to Projects.
- Sales and commission can be viewed in league/club context.
- No football-specific logic pollutes FUND core.

### Phase 7 — Production and Fulfilment

Goals:

- add production dashboards;
- batch Orders;
- track artwork/data status;
- track fulfilment status;
- support outsourced production delegation;
- support production exports.

Success criteria:

- Production Partner can see what needs producing.
- Orders can move through production stages.
- Export/reporting supports real fulfilment.

### Phase 8 — AI Assistance and Marketplace Expansion

Goals:

- add AI-assisted workflow support;
- add smarter communication generation;
- support multiple producers/production partners;
- support marketplace-style product opportunities.

Success criteria:

- FUND remains configurable and tenant-safe.
- AI features assist the workflow without replacing structured data.
- Additional producers can participate without bespoke forks.

---

## 16. Initial Seed / Demo Data

Initial test/demo data should include:

- Tenant / Producer: All My Own Work;
- Example Event: Christmas 2026;
- Example Event Date: 25 December 2026;
- Example Production Deadline: 15 December 2026;
- Products:
  - Christmas Cards;
  - Mugs;
  - Tea Towels;
  - Water Bottles;
- Catalogue: AMOW Christmas Catalogue 2026;
- Organisers:
  - sample school;
  - sample SeasonPro club;
- Projects:
  - school Christmas card Project;
  - club fundraising Project;
- Commission rules:
  - Isoblue platform share;
  - Producer share;
  - Organiser share;
  - optional League/Club share.

All demo data must be fictional.

---

## 17. Initial Test Scenarios

### Scenario 1 — Create an Event

Steps:

- Producer creates Christmas 2026.
- Adds Event date.
- Adds production deadline.
- Adds Store closing deadline.
- Assigns Catalogue.

Expected result:

- Event is created.
- Dates validate correctly.
- Catalogue is linked.

### Scenario 2 — Create a Project

Steps:

- Organiser creates a Project within Christmas 2026.
- Selects Products from the available Catalogue.
- Chooses a Store closing date.

Expected result:

- Project is created.
- Project Number is generated.
- Store closing date cannot exceed Event Production Deadline.

### Scenario 3 — Generate or Link Store

Steps:

- Project Store is generated or linked.
- Store inherits products, prices, branding, terms and policies.
- Store is opened for test orders.

Expected result:

- Store is available.
- Project metadata is preserved.
- Orders can be attributed back to the Project.

### Scenario 4 — Capture Orders

Steps:

- Test Orders are imported or created.
- Orders include Project Number or Store metadata.

Expected result:

- Orders attach to correct Project.
- Sales totals update.
- Dashboards reflect sales.

### Scenario 5 — Commission Calculation

Steps:

- Orders are processed against configured commission rules.

Expected result:

- Commission Lines are created.
- Totals are visible by participant.
- No fixed commission assumptions are used.

### Scenario 6 — SeasonPro Club Fundraising

Steps:

- SeasonPro League enables FUND.
- Club creates a fundraising Project.
- Orders are placed.
- League and Club commission are calculated.

Expected result:

- Club and League see relevant data only.
- Producer sees fulfilment data.
- Isoblue sees platform-level data.

### Scenario 7 — Lifecycle and Email Automation

Steps:

- Project moves through lifecycle states.
- Key Date reminders are scheduled.
- A key date is changed.

Expected result:

- Pending communication steps re-arm correctly.
- Sent emails are logged.
- Dashboards update.

---

## 18. Open Questions

The following should be resolved before or during early development.

1. What is the preferred initial commerce layer?
2. Should Stores be generated inside IsoStack or linked to an external storefront initially?
3. What is the minimum viable order import/sync process?
4. How much Product variant complexity is required for Phase 1?
5. How should artwork uploads be stored and secured?
6. What documents or PDFs are required for Producers and Organisers?
7. What production export formats are required by AMOW?
8. What existing AMOW workflow elements must be preserved temporarily?
9. How should Project Numbers be generated?
10. Should Project Numbers be globally unique or unique per Event/Producer?
11. Should customers have accounts, or should purchasing remain accountless?
12. How should refunds/cancellations affect commission?
13. What is required for VAT and tax reporting?
14. What reporting is required by schools/clubs?
15. How should SeasonPro club permissions map into FUND permissions?
16. Which lifecycle states are universal and which are Product/Event-specific?
17. Should Store terms and policies be inherited from Event, Tenant or Platform?
18. Which dashboard metrics are required for the first usable version?
19. What audit events are legally or commercially important?
20. How should multi-producer fulfilment be represented in the first schema?

---

## 19. Definition of a Good First Version

A good first version of FUND is not a complete e-commerce platform.

A good first version should allow Isoblue and AMOW to:

- define an Event;
- define a Catalogue of Products;
- create Projects;
- enforce key dates and closing dates;
- generate or associate Stores;
- associate Orders with Projects;
- show dashboard summaries;
- calculate simple commission;
- reduce spreadsheet reliance;
- preserve historical records;
- provide a base for further automation.

The first version should prove the data model and workflow.

---

## 20. Codex Operating Rules for FUND

Codex must follow the IsoStack Codex Operating Charter.

The overriding principle is:

> Understand first. Plan second. Change third. Verify always.

### 20.1 Before Editing

Codex must:

1. read the relevant FUND docs;
2. read the IsoStack Codex Operating Charter;
3. check the current branch;
4. confirm it is not working directly on `main`;
5. inspect existing module patterns;
6. identify database impact;
7. identify tenant/permission impact;
8. propose a small implementation plan;
9. wait for approval where required.

### 20.2 Branch Discipline

Normal work must flow:

```text
dev → staging → main
```

Codex must never work directly on `main` for ordinary development.

### 20.3 Database Discipline

Codex must not use:

```bash
npx prisma db push
```

or any project alias for `db:push`.

Codex must not run destructive seed/reset commands unless explicitly approved.

Schema changes must begin in:

```text
prisma/schema.prisma
```

Use migrations only.

After generating a migration, Codex must inspect generated SQL for dangerous operations.

### 20.4 Tenant Safety

Every normal tenant-level query must be scoped by `organizationId` or the correct IsoStack tenancy equivalent.

Missing tenant scoping is a serious data leak risk.

### 20.5 tRPC and Validation

Codex should use tRPC as the normal frontend-to-backend communication layer.

Routers must:

- use Zod validation;
- use protected procedures where authentication is required;
- enforce roles and permissions;
- scope tenant data;
- log significant mutations;
- return predictable typed data.

### 20.6 Audit Logging

Significant FUND mutations should normally create audit records.

Examples:

- Event created;
- Product changed;
- Project created;
- Store opened;
- Store closed;
- Order imported;
- Commission rule changed;
- Commission issued;
- Production status changed.

### 20.7 UI Rules

IsoStack uses Mantine.

Codex should prefer existing Mantine UI patterns and established table CRUD conventions.

When creating user-facing UI, Codex should consider tooltip/help anchors.

### 20.8 Documentation Rules

When behaviour changes, Codex should update or propose updates to FUND documentation.

Canonical planning documentation belongs in:

```text
isodocs/docs/modules/fund/
```

Code-adjacent module docs should be short pointers or implementation notes.

---

## 21. Recommended AI Handoff Prompt

Use this or an adapted version when resuming FUND work with Codex.

```text
You are working on IsoStack, a live multi-tenant SaaS platform.

Before editing anything:
1. Read the IsoStack Codex Operating Charter.
2. Read the FUND canonical module brief.
3. Check the current branch.
4. Confirm you are not working directly on main.
5. Inspect existing module, tRPC, Prisma, Mantine and permission patterns.
6. Do not use db:push.
7. Do not run seed/reset commands.
8. Preserve tenant scoping by organizationId.
9. Use migrations for schema changes.
10. Explain your proposed plan before editing.

FUND is currently planning-only. No database models, migrations, routers or UI routes have been built yet.

AMOW is the founding use case / production partner context, not the module identity.

Continue FUND module build from Phase 1:
Create the database foundation models in prisma/schema.prisma under the appropriate FUND schema or namespace.
Do not create or apply a Prisma migration until the schema has been reviewed.
```

---

## 22. Preferred Development Loop

For each FUND implementation task:

1. Inspect the relevant documentation and code.
2. Identify the smallest useful vertical slice.
3. State the goal.
4. List files likely to change.
5. Identify database impact.
6. Identify tenant/permission impact.
7. Identify audit logging impact.
8. Identify tooltip/help impact.
9. Implement using existing IsoStack patterns.
10. Add or update seed/demo data where appropriate.
11. Add validation and tests where practical.
12. Run verification.
13. Update documentation.
14. Summarise:
    - what was inspected;
    - what changed;
    - what did not change;
    - what checks were run;
    - what remains to test manually.

---

## 23. Final Product Principle

FUND should evolve into a reusable IsoStack module that supports AMOW first, but then wider fundraising opportunities across schools, clubs, leagues, community organisations and other production partners.

The best outcome is not the fastest code generation.

The best outcome is a module that remains:

- understandable;
- deployable;
- tenant-safe;
- migration-safe;
- commercially useful;
- configurable;
- historically reliable;
- aligned with Isoblue’s long-term product direction.

FUND must protect the platform while helping it evolve.
