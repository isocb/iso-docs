# FUND Module Brief

**Canonical location:** `isodocs/docs/modules/fund/01-fund-module-brief.md`  
**Module slug:** `fund`  
**Platform:** IsoStack  
**Related product/module:** SeasonPro / LMSPro  
**Founding use case / production partner:** All My Own Work (AMOW)  
**Status:** Planning / ready for phased build  
**Document purpose:** Product vision, business context, module scope and shared terminology for the FUND module.

---

## 1. Document Purpose

This document explains the FUND module as a business and product concept.

It is intended for:

- Isoblue;
- Sue and Chris;
- AMOW;
- future developers;
- AI coding assistants such as Codex;
- future partners;
- future fundraising and production tenants.

This document should be treated as the **product and business brief** for FUND.

It explains:

- what FUND is;
- why it exists;
- how it relates to IsoStack;
- how it relates to AMOW;
- how it may relate to SeasonPro;
- the main people, organisations and workflows involved;
- the high-level phased direction.

This document is **not** a final database schema, UI specification or implementation plan.

Detailed build constraints, architectural rules and Codex guardrails belong in:

```text
02-fund-architecture-principles.md
```

Functional requirements and delivery tasks should be developed in separate follow-on documents.

---

## 2. Executive Summary

FUND is a reusable IsoStack module for fundraising, project lifecycle management, production workflow, e-commerce, organiser engagement, commission distribution and dashboard-led operational control.

FUND originated from the operational requirements of **All My Own Work (AMOW)**, but AMOW is not the module identity.

FUND should be understood as:

> A project lifecycle and production workflow module with fundraising, commerce, communication and commission capabilities layered around it.

This distinction is important.

FUND is not simply:

- an online shop;
- a store builder;
- an order form;
- a product catalogue;
- a WordPress replacement;
- an AMOW-only system.

FUND exists because many fundraising activities involve more than selling products online. They often require:

- project setup;
- organiser engagement;
- deadline control;
- artwork or data collection;
- production planning;
- fulfilment;
- dispatch;
- commission;
- reporting;
- follow-up communication.

The first major use case is AMOW, whose established fundraising model includes artwork-based school projects, downloadable templates, parent ordering, artwork return, production matching, manufacturing and batch dispatch.

The long-term opportunity is for FUND to become a reusable fundraising and production-coordination capability inside IsoStack, supporting AMOW first and then wider opportunities across schools, clubs, leagues, charities, community groups and other organisations.

---

## 3. Relationship to IsoStack

IsoStack is the shared foundation that underpins Isoblue’s application work.

Instead of rebuilding the same technical foundations for every client, IsoStack provides reusable platform services such as:

- authentication;
- user and organisation management;
- tenancy;
- permissions;
- dashboards;
- database infrastructure;
- e-commerce services;
- email and notifications;
- workflow automation;
- file storage;
- audit logging;
- monitoring;
- backups.

This allows Isoblue to focus development effort on each client’s unique workflow rather than repeatedly rebuilding the same underlying infrastructure.

For FUND, this means IsoStack provides the platform foundation, while FUND provides the fundraising, project lifecycle and production-specific logic.

---

## 4. What IsoStack Provides

IsoStack is expected to provide or own the shared platform capabilities that FUND consumes.

### Identity and Security

- User accounts
- Organisations
- Tenancy
- Roles and permissions
- Magic link authentication
- MFA / biometric readiness where supported
- Audit logging

### Data and Infrastructure

- PostgreSQL database
- Prisma ORM
- Tenant isolation
- Migration workflow
- Soft delete where appropriate
- Historical preservation where appropriate
- Monitoring and backup

### Communications

- Email services
- Notification services
- Email template management
- Resend integration
- Future automation triggers

### E-Commerce Services

- Shopping cart capability
- Stripe integration
- Orders
- Payments
- Refunds
- Payment lifecycle tracking

### Dashboard Framework

- Navigation
- Reusable widgets
- Reporting components
- Charts
- KPIs
- Search
- Tenant-aware dashboards

### Automation Framework

- Scheduled tasks
- Event triggers
- Workflow automation
- Date-based automation
- Future AI-assisted workflow hooks

### File Management

- Document storage
- Image storage
- Upload handling
- Optional Cloudflare R2 storage
- PDF generation
- Generated output storage

FUND must not recreate these platform services unless a clear architectural decision is made.

---

## 5. What FUND Adds

FUND adds the domain-specific logic required for fundraising and production-aware project workflows.

FUND is responsible for:

- fundraising campaigns;
- project lifecycle management;
- product workflow classes;
- product and catalogue availability within fundraising contexts;
- organiser engagement;
- project stores;
- sales and order attribution;
- artwork and personalisation workflows;
- production coordination;
- fulfilment tracking;
- commission rules;
- commission reporting;
- dashboard views for organisers, producers, tenants and platform owners.

FUND consumes IsoStack infrastructure and extends it with fundraising-specific business behaviour.

---

## 6. The Role of AMOW

AMOW has a special role within FUND.

AMOW is not simply “the first customer”.

AMOW should be represented through configuration and data as one or more of the following:

- founding use case;
- launch tenant;
- product catalogue owner;
- primary production partner;
- fulfilment partner;
- dispatch partner;
- workflow expert;
- seed/demo data context.

### 6.1 Launch Tenant

AMOW is the first implementation of FUND.

The initial module development is funded by AMOW’s real operational requirements and must solve AMOW’s workflow properly.

The first build must not lose the specific behaviours that make AMOW’s business work, particularly artwork-based projects.

### 6.2 Founding Production Partner

AMOW is initially the primary product provider and production partner.

AMOW supplies or manages:

- product sourcing;
- artwork-based product workflows;
- template management;
- artwork processing;
- production;
- fulfilment;
- dispatch;
- production knowledge.

### 6.3 Workflow Expert

AMOW contributes the real-world fundraising and production workflow that shapes FUND.

This includes:

- school fundraising;
- event-based selling;
- artwork templates;
- parent ordering;
- artwork return;
- artwork matching;
- group artwork collation;
- mass customisation;
- batch production;
- commission statements;
- organiser communication.

### 6.4 Marketplace Beneficiary

As FUND grows, AMOW may benefit from new routes to market.

For example, a SeasonPro football league may enable FUND and allow its clubs to run fundraising projects using AMOW products.

In this model, AMOW benefits not only from direct product and production revenue, but potentially also from configurable marketplace or producer commissions if additional producers join later.

This future opportunity must not undermine AMOW’s role as the founding production partner.

---

## 7. Relationship to SeasonPro

SeasonPro is a separate IsoStack module for football league management.

FUND should be designed as a sibling module that can integrate with SeasonPro but does not depend on it.

The strategic opportunity is that a SeasonPro tenant, such as a football league, can become a fundraising channel.

Example future flow:

1. A SeasonPro league tenant enables FUND.
2. The league selects approved fundraising products or product groups.
3. Clubs become organisers or project participants.
4. Each participating club receives a project/storefront or fundraising page.
5. Parents/supporters place orders.
6. Orders are linked to the relevant project and club.
7. Revenue and commission are calculated automatically.
8. AMOW or another production partner fulfils the products.
9. League and clubs view sales and commission through dashboards.

This creates additional value inside SeasonPro without hard-coding football-specific assumptions into the FUND core.

SeasonPro integration is an important opportunity, but the first priority remains solving AMOW’s artwork, production and fundraising workflow properly.

---

## 8. Core Design Understanding

FUND must be both:

1. **Specific enough** to solve the AMOW workflow properly.
2. **Generic enough** to become a reusable IsoStack module.

The key design understanding is:

> Projects are the operational unit of fundraising.  
> Product workflow class determines what must happen.  
> Events are optional campaign containers that provide shared deadlines and rules.  
> Stores are generated commerce surfaces for projects.

This means FUND should not be designed around “stores first”.

The store is important, but it is not the centre of the model.

The centre of the model is the project lifecycle and the product workflow required to fulfil that project.

---

## 9. Core Concepts

The following terminology should be used consistently unless replaced by a documented decision.

---

### 9.1 Tenant

A tenant is an IsoStack organisation account.

A tenant may be:

- AMOW;
- a school;
- a PTA;
- a football league;
- a football club;
- a community organisation;
- a charity;
- a producer;
- a fulfilment supplier.

A tenant may perform more than one role.

For example, AMOW may be:

- a tenant;
- a product catalogue owner;
- a producer;
- a production partner;
- a fulfilment partner.

---

### 9.2 Producer

A producer is a tenant acting as the organisation responsible for defining and/or supplying products.

Initial producer context:

- AMOW.

Future producers may include:

- printers;
- merchandise suppliers;
- clothing suppliers;
- fulfilment partners;
- other fundraising product providers.

Producer is a role a tenant can perform, not a separate platform identity outside tenancy.

---

### 9.3 Production Partner

A production partner is responsible for producing, fulfilling or dispatching products.

Initially AMOW may act as:

- primary production partner;
- fulfilment partner;
- dispatch partner.

Future products may be assigned to:

- AMOW;
- Supplier A;
- Supplier B;
- another production partner.

This should not require changes to FUND’s core workflow.

---

### 9.4 Product

A product is an item that can be sold through a fundraising project.

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

Products belong to tenants and are never owned by FUND itself.

---

### 9.5 Product Catalogue

A catalogue is a set of products made available by a tenant.

Examples:

- AMOW Christmas Catalogue 2026;
- AMOW Leavers Catalogue;
- AMOW Personalised Products;
- Future Producer Sportswear Catalogue.

A tenant can create and maintain one or more catalogues.

Catalogues can be associated with events, campaigns or independent projects.

---

### 9.6 Product Workflow Class

A product workflow class describes the operational behaviour required to fulfil a product.

This is one of the most important concepts in FUND.

Different product types require different workflows.

A simple product may only require an order and dispatch.

An AMOW artwork product requires downloadable templates, children’s artwork, parent ordering, artwork return, artwork matching and production.

A mass customisation product may require a list of names or data upload before production.

FUND must respect these differences.

---

### 9.7 Event

An event is an optional campaign container.

Examples:

- Christmas 2026;
- Mother’s Day 2027;
- Father’s Day 2027;
- Easter 2027;
- Leavers 2027;
- Summer Fundraiser.

An event may define:

- event name;
- event date;
- campaign opening date;
- production deadline;
- last permissible store closing date;
- product selection;
- catalogue selection;
- commission rules;
- lifecycle rules;
- communication sequences;
- branding;
- terms and policies.

An event is useful when multiple projects share deadlines, products, communications or production constraints.

Events are optional.

Projects can belong to an event, but a project may also operate independently.

---

### 9.8 Season

Season may be used as a friendly or operational term where helpful, especially for AMOW recurring campaigns.

For example:

- Christmas Season;
- Mother’s Day Season;
- Father’s Day Season.

In the core FUND model, **Event** is the preferred data concept.

Suggested rule:

- Use **Event** for the core model.
- Use **Season** as a display or marketing label where it helps users understand the campaign.

---

### 9.9 Project

A project is the operational unit of fundraising.

Every fundraising activity in FUND should have a project.

Examples:

- St Mark’s Primary Christmas 2026 card project;
- Northgate Juniors U10 leavers bottle project;
- Riverside United club fundraising store;
- Derby League club fundraising project;
- Playground appeal;
- School trip fundraiser.

A project may:

- belong to an event; or
- operate independently.

A project should have:

- unique project number;
- project name;
- organiser;
- optional event;
- store;
- project closing date;
- lifecycle state;
- selected products;
- communication history;
- production status;
- commission settings or inherited commission rules.

Where a project belongs to an event, its closing date must not exceed the event’s production deadline or final store close constraint.

Where a project does not belong to an event, it manages its own dates, products and rules.

---

### 9.10 Organiser

An organiser is the person or organisation initiating or managing a fundraising project.

Examples:

- school contact;
- PTA organiser;
- club secretary;
- SeasonPro club admin;
- league fundraising contact;
- community group organiser.

The organiser may be responsible for:

- creating the project;
- choosing a closing date;
- downloading templates;
- distributing materials;
- sharing store links;
- encouraging sales;
- uploading artwork or data;
- monitoring progress;
- reviewing commission information.

---

### 9.11 Store

A store is the public or semi-public ordering surface for a project.

Each project should generate or be associated with a unique store.

A store may be:

- a generated IsoStack storefront;
- a Stripe Checkout-based store;
- an embedded checkout page;
- an externally hosted storefront;
- a future commerce integration.

The internal FUND model must not be tied unnecessarily to one commerce provider.

Stores are generated from projects, not from events.

---

### 9.12 Sale / Order

A sale or order is a purchase made through a project store.

Orders should be linkable to:

- project;
- store;
- product;
- order items;
- customer;
- payment status;
- fulfilment status;
- production batch;
- commission calculation;
- export/reporting requirements.

Customers may not need IsoStack accounts.

---

### 9.13 Commission

Commission is a configured percentage or fixed value assigned to participating stakeholders.

Possible participants include:

- Isoblue;
- producer;
- production partner;
- fundraising operator;
- league;
- club;
- school;
- organiser.

Example values previously discussed:

- Isoblue: 2.5%;
- League Tenant: 1.5%;
- Club: 1.5%.

These are examples only and must be configurable, not hard-coded.

---

## 10. Product Workflow Classes

Product workflow classes must be understood at the product vision level because they explain why FUND is more than a shop.

---

### 10.1 A1 — Individual Artwork Projects

This is AMOW’s core established business model.

Typical products may include:

- Christmas cards;
- mugs;
- tea towels;
- calendars;
- printed gifts using individual child artwork.

High-level workflow:

1. Organiser creates a project.
2. Project template PDF is generated.
3. School downloads and prints multiple copies.
4. Children create artwork on the templates.
5. Artwork goes home to parents.
6. Parents order online via the project store.
7. Artwork returns to school.
8. School collates artwork in a batch.
9. School sends artwork to AMOW.
10. AMOW matches artwork against sales.
11. Products are produced.
12. Products are dispatched.

The project template is a key production and sales asset.

It is not merely a download.

It contains product information, prices, artwork space, project information and instructions that enable the offline/online workflow to function.

This workflow must be protected in the FUND design.

---

### 10.2 A2 — Group Artwork Products

This is a related artwork workflow.

Example:

- a class of children create self-portraits;
- AMOW collates those portraits;
- one composite design is created;
- the composite design is applied to a product;
- parents order the finished product.

Typical products may include:

- class tea towels;
- class mugs;
- group prints;
- year group keepsakes.

High-level workflow:

1. Project is created.
2. Template or artwork instructions are generated.
3. Children create individual artwork.
4. Artwork is collected.
5. AMOW collates artwork.
6. AMOW creates a composite design.
7. Design may require approval.
8. Product is made available or confirmed for production.
9. Orders are fulfilled.
10. Products are dispatched.

This workflow requires artwork collation and design preparation, not just order capture.

---

### 10.3 B — Logo / Brand Products with Mass Customisation

This product class supports bulk or group orders with personalisation data.

Example:

- 30 water bottles;
- each bottle receives a different name;
- names are uploaded as a list;
- the list is validated;
- production-ready output is created.

Typical products may include:

- water bottles;
- leavers products;
- hoodies;
- team merchandise;
- club merchandise.

High-level workflow:

1. Project is created.
2. Products are selected.
3. Logo or branding is supplied.
4. Names or personalisation data are uploaded.
5. Data is validated.
6. Production export is generated.
7. Products are produced.
8. Products are dispatched.

This workflow does not require school artwork templates or artwork return, but it does require reliable data upload and validation.

---

### 10.4 C — Standard Products

Standard products are products that can be ordered and fulfilled without artwork or personalisation.

High-level workflow:

1. Project/store is created.
2. Customer orders.
3. Payment is taken.
4. Product is produced or picked.
5. Product is dispatched.

This is the simplest workflow, but it must not define the whole FUND architecture.

---

## 11. Event and Project Relationship

The event/project relationship is central to the revised understanding of FUND.

### 11.1 Events Are Optional

Events are useful campaign containers.

They are not always required.

An event should exist where multiple projects share:

- a production deadline;
- a catalogue;
- a communication sequence;
- a commission model;
- branding;
- campaign dates;
- a final store close constraint.

Example:

```text
Christmas 2026
```

Event Date:

```text
25 December 2026
```

Production Deadline / Last Order Date:

```text
15 December 2026
```

Projects belonging to Christmas 2026 may close earlier, but not later.

---

### 11.2 Projects Are Mandatory

Projects are where fundraising actually happens.

Every store, order, production workflow and commission calculation ultimately belongs to a project.

A project may belong to an event, but it does not have to.

---

### 11.3 Event-Based Projects

Example:

```text
Christmas 2026 Event
  ├── St Mark’s Primary Christmas Project
  ├── Riverside School Christmas Project
  └── Northgate PTA Christmas Project
```

Each project may have its own closing date.

Validation rule:

```text
Project Closing Date <= Event Production Deadline / Final Store Close Date
```

This allows schools or organisers to close earlier while protecting AMOW’s production timetable.

---

### 11.4 Independent Projects

A project can operate independently of an event.

Examples:

- playground appeal;
- sports tour fundraiser;
- school trip fundraiser;
- one-off club campaign.

In this case, the project defines its own:

- products;
- dates;
- store rules;
- communications;
- production requirements.

Independent projects may still use the same product workflow classes, dashboards, store engine, commission engine and production process.

---

## 12. Dashboards

FUND requires different dashboard experiences for different audiences.

The dashboards should share the same underlying data, but show it differently.

---

### 12.1 Operations Dashboard

The Operations Dashboard is used by AMOW, producers, production partners and tenant administrators.

It supports operational control.

It should provide visibility of:

- events;
- projects;
- project lifecycle stages;
- sales;
- artwork status;
- data upload status;
- production status;
- dispatch status;
- revenue;
- commission;
- exceptions;
- upcoming deadlines;
- stores closing soon;
- missing artwork or data.

Key questions answered:

- What is active?
- What needs attention?
- What is approaching deadline?
- Which projects are missing artwork or data?
- What is in production?
- What has been dispatched?
- Which projects are complete?

---

### 12.2 Organiser Fundraising Dashboard

The Organiser Fundraising Dashboard is client-facing.

It is not just a reporting screen.

It is a key engagement tool.

It should help organisers understand:

- how their project is progressing;
- what they need to do next;
- how sales are going;
- when the store closes;
- whether artwork/data is outstanding;
- whether production has started;
- whether dispatch has happened;
- what commission has been earned.

For schools, clubs and fundraising groups, this dashboard should feel like:

> a calm, clear project hub.

It should reduce support queries, improve confidence and encourage continued engagement.

---

### 12.3 SeasonPro / League Dashboard

Where FUND is enabled for a SeasonPro tenant, league-level users may need a dashboard showing:

- participating clubs;
- club fundraising projects;
- aggregate sales;
- league commission;
- club commission;
- deadlines;
- exceptions;
- campaign progress.

This must not introduce football-specific assumptions into FUND core.

---

## 13. Strategic Objectives

FUND should help Isoblue and its clients:

1. Reduce dependency on disconnected tools.
2. Replace fragile form / automation / spreadsheet / store workflows with a coherent system.
3. Support AMOW’s established artwork workflows.
4. Support group artwork and mass customisation workflows.
5. Support seasonal fundraising with clear deadline management.
6. Support independent fundraising projects.
7. Allow AMOW to manage projects and production more efficiently.
8. Allow organisers to self-serve and track progress.
9. Allow future producers and production partners to join the platform.
10. Allow SeasonPro tenants and clubs to access fundraising opportunities.
11. Support configurable commission-based revenue.
12. Improve communication through automated email sequences.
13. Create a future-ready base for AI-assisted workflows.
14. Protect historical fundraising, sales and commission data.
15. Enable future marketplace-style fundraising capability.

---

## 14. What FUND Must Avoid

FUND should not become:

- a hard-coded AMOW-only workflow;
- a one-season-only system;
- a thin wrapper around an external shop;
- a store-first system with production bolted on later;
- a product catalogue with no project lifecycle;
- a manual order admin system with a dashboard bolted on later;
- a generic e-commerce platform that forgets artwork workflows;
- a SeasonPro-only feature;
- a football-specific fundraising module;
- a module that bypasses IsoStack tenancy, permissions or audit conventions;
- a system that treats AMOW’s artwork workflows as edge cases.

The core value lies in combining:

- product workflow classes;
- project lifecycle management;
- optional event grouping;
- product and catalogue selection;
- store/order handling;
- deadline control;
- organiser engagement;
- artwork/data handling;
- production coordination;
- commission reporting;
- dashboard visibility.

---

## 15. High-Level Functional Areas

This is a product-level summary only.

Detailed functional requirements belong in the functional specification.

### Product and Catalogue Management

- Tenant-owned products
- Tenant-owned catalogues
- Product workflow classes
- Pricing
- Images
- Product descriptions
- Availability
- Product retirement
- Production partner assignment

### Event Management

- Optional campaign containers
- Event date
- Production deadline
- Final store close constraint
- Product/catalogue selection
- Communication rules
- Commission rules
- Branding and policies

### Project Management

- Mandatory operational fundraising entity
- Optional event relationship
- Project number
- Organiser
- Closing date
- Selected products
- Store
- Lifecycle state
- Production status
- Commission state

### Store and Order Handling

- Project-linked stores
- Project-linked orders
- Payment status
- Order items
- Refunds/cancellations
- Sales totals
- Exportable order data

### Artwork and Data Handling

- Artwork template generation
- Downloadable project PDFs
- Artwork return tracking
- Artwork matching
- Group artwork collation
- Personalisation data upload
- Validation
- Production export

### Production and Fulfilment

- Production queues
- Production batches
- Production status
- Dispatch status
- Production partner assignment
- Export/reporting for fulfilment

### Communications

- Organiser emails
- Customer emails
- Lifecycle-triggered communication
- Date-triggered reminders
- Commission statement notifications
- Dispatch notifications

### Commissions

- Platform commission
- Producer commission or margin
- Production partner margin
- League commission
- Club commission
- School/organiser commission
- Statements and reporting

---

## 16. High-Level Phased Direction

The precise delivery plan may evolve, but the broad direction is:

### Phase 0 — Planning, Mapping and Decisions

- Confirm terminology.
- Confirm AMOW artwork workflows.
- Confirm product workflow classes.
- Confirm event/project relationship.
- Confirm initial data model.
- Confirm first build backlog.

### Phase 1 — Foundation, Products, Projects and Lifecycle

- Establish FUND module structure.
- Model tenants, products, catalogues, workflow classes, optional events and projects.
- Prove that artwork, group artwork and mass customisation workflows can coexist.
- Create basic admin surfaces.
- Protect tenant scoping.

### Phase 2 — Project Creation and Dashboards

- Create project creation flows.
- Generate project numbers.
- Enforce event deadline constraints where events exist.
- Create organiser dashboard.
- Create operations dashboard.

### Phase 3 — Templates, Stores and Orders

- Generate or manage project templates.
- Generate or associate stores.
- Link orders to projects.
- Show sales totals.
- Preserve project/order history.

### Phase 4 — Communications and Key Dates

- Add lifecycle-triggered and date-triggered communication.
- Create organiser reminder sequences.
- Create customer/order communication.
- Support re-arming when dates change.

### Phase 5 — Commission and Statements

- Configure commission participants.
- Calculate commission.
- Show summaries.
- Generate statements or exports.

### Phase 6 — Production and Fulfilment

- Add production dashboards.
- Track artwork/data status.
- Create production batches.
- Support dispatch tracking.
- Support AMOW production exports.

### Phase 7 — SeasonPro and Wider Tenant Integration

- Enable SeasonPro tenants to use FUND.
- Allow leagues/clubs to participate.
- Support league/club reporting and commission.
- Avoid football-specific assumptions in FUND core.

### Phase 8 — Marketplace and AI Assistance

- Support additional production partners.
- Support marketplace-style product opportunities.
- Add AI-assisted status summaries, communications, validation and support where appropriate.

---

## 17. First-Version Success Criteria

A good first version of FUND is not a complete marketplace or fully automated e-commerce ecosystem.

A good first version should prove the core model.

It should allow Isoblue and AMOW to:

- define product workflow classes;
- define tenant-owned products and catalogues;
- create an event with shared deadlines;
- create a project within an event;
- create an independent project;
- enforce project closing date rules;
- generate or manage templates for artwork projects;
- create or associate a project store;
- associate orders with projects;
- show dashboard summaries;
- track artwork or data requirements;
- calculate simple commission;
- preserve historical records;
- provide a base for further automation.

The first version succeeds if it proves that FUND can support AMOW’s real artwork and production workflows while remaining reusable across other fundraising contexts.

---

## 18. Final Product Principle

FUND should evolve into a reusable IsoStack module that supports AMOW first, then wider fundraising opportunities across schools, clubs, leagues, community organisations and production partners.

The best outcome is not the fastest code generation.

The best outcome is a module that remains:

- understandable;
- tenant-safe;
- configurable;
- historically reliable;
- commercially useful;
- production-aware;
- reusable;
- aligned with Isoblue’s long-term product direction.

FUND must protect the platform while helping it evolve.

Most importantly:

> FUND must solve AMOW’s artwork and production workflows properly before it expands into a wider marketplace opportunity.
