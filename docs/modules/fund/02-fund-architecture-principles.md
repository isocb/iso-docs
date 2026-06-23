# FUND Architecture Principles

**Canonical location:** `isodocs/docs/modules/fund/02-fund-architecture-principles.md`  
**Module slug:** `fund`  
**Platform:** IsoStack  
**Related document:** `01-fund-module-brief.md`  
**Audience:** Codex, future developers, Isoblue, technical reviewers  
**Status:** Planning / pre-implementation guardrails  
**Purpose:** Architecture, modelling and implementation principles for building FUND correctly.

---

## 1. Purpose of This Document

This document defines the architectural principles that must guide the implementation of the FUND module.

It exists because FUND must not accidentally become a simple shop, store builder or catalogue system. FUND is being funded initially to solve the real operational workflow of All My Own Work (AMOW), whose business model depends heavily on artwork collection, artwork matching, template generation, production coordination, fulfilment and deadline control.

The purpose of this document is to protect that understanding during design and development.

This document should be read before any schema, route, service, UI or workflow implementation work begins.

---

## 2. Relationship to the FUND Module Brief

The FUND module documentation is split deliberately:

- `01-fund-module-brief.md` explains what FUND is, why it exists, who it serves, and the strategic opportunity.
- `02-fund-architecture-principles.md` explains how FUND must be designed so that the implementation does not drift towards the wrong abstraction.

The module brief is product and business context.

This document is architecture and implementation guardrail context.

Codex and future developers should read both documents, but this document should be treated as the stronger source when deciding how to model FUND internally.

---

## 3. Core Architectural Statement

FUND is a **Project Lifecycle and Production Workflow Engine** with fundraising, commerce, organiser engagement, commission and dashboard capabilities layered around it.

FUND is not primarily:

- an e-commerce module;
- a store builder;
- a product catalogue;
- a payment integration;
- a simple campaign page generator;
- an AMOW-only workflow;
- a SeasonPro-only feature.

The heart of FUND is the ability to manage fundraising projects that move through different workflow paths depending on the type of product being sold and produced.

The key phrase to remember is:

> FUND is lifecycle-first and production-aware. Commerce is layered around the project lifecycle, not the other way round.

---

## 4. Fundamental Model

The correct conceptual model is:

```text
Tenant
  ├── Product Catalogues
  ├── Events (optional campaign containers)
  └── Projects (mandatory operational fundraising entities)
        ├── Product Workflow Class
        ├── Lifecycle State
        ├── Store
        ├── Orders
        ├── Artwork / Data Assets
        ├── Production Status
        └── Commission Records
```

The dangerous but incorrect model is:

```text
Store
  └── Orders
        └── Production
```

That incorrect model would lose the AMOW workflow and reduce FUND to a thin online selling layer.

---

## 5. Architectural Principle 1 — Product Workflow Class Is First-Class

Every product must belong to a Product Workflow Class.

The Product Workflow Class determines:

- what data must be collected;
- what documents must be generated;
- what lifecycle stages apply;
- what dashboard actions are required;
- what production steps are required;
- what validation rules apply;
- what exports or generated outputs may be needed;
- what communications should be triggered.

Product Workflow Class must not be treated as a label, tag or cosmetic category. It is a functional driver of behaviour.

---

## 6. Product Workflow Classes

Initial FUND development must support, or at least explicitly model, the following workflow classes.

---

### 6.1 A1 — Individual Artwork Project Product

This is the core AMOW workflow and must be protected.

Examples:

- Christmas cards;
- calendars;
- mugs using individual child artwork;
- tea towels using individual child artwork;
- similar artwork-led fundraising products.

Typical workflow:

```text
Project Created
→ Template Generated
→ School Downloads Template
→ School Prints Multiple Copies
→ Children Create Artwork
→ Artwork Sent Home With Ordering Instructions
→ Parents Order Online
→ Artwork Returned To School
→ School Batches Artwork
→ Artwork Sent To AMOW
→ AMOW Matches Artwork To Orders
→ Production
→ Dispatch
→ Completion / Commission
```

Critical requirements:

- downloadable project template PDF;
- project number on template;
- prices and product information on template;
- space for children to create artwork;
- instructions for parents;
- online store linked to project number;
- artwork return tracking;
- artwork/order matching;
- batch production handling.

Important note:

The downloadable template is not a minor output. For A1 products, it is central to the business process. It acts as both production instruction and parent-facing sales support.

---

### 6.2 A2 — Group Artwork Product

This is a derivative artwork workflow where multiple children contribute artwork that is collated into one combined product.

Examples:

- class self-portrait product;
- group tea towel;
- year group artwork product;
- class mug or print using multiple portraits.

Typical workflow:

```text
Project Created
→ Template / Artwork Instructions Generated
→ Children Create Individual Artwork
→ Artwork Returned
→ Artwork Collated
→ Composite Design Created
→ Optional Approval
→ Store Sales / Order Confirmation
→ Production
→ Dispatch
→ Completion / Commission
```

Critical requirements:

- support for multiple artwork sources;
- collation status;
- composite design stage;
- optional proof or approval stage;
- production-ready output.

This workflow is related to A1 but must not be collapsed into A1 without preserving its additional collation and composite design requirements.

---

### 6.3 B — Logo / Bulk Mass Customisation Product

This workflow supports products where a project orders items in bulk and each item may contain personalised data.

Examples:

- 30 water bottles, each with a different name;
- leavers products;
- hoodies with names or numbers;
- team merchandise;
- logo-based bulk products with personalisation.

Typical workflow:

```text
Project Created
→ Products Selected
→ Quantity Defined
→ Logo / Artwork Supplied Where Required
→ Names / Personalisation Data Uploaded
→ Data Validated
→ Production Export Generated
→ Production
→ Dispatch
→ Completion / Commission
```

Critical requirements:

- bulk quantity handling;
- upload of names or personalisation data;
- validation that data count matches product quantity;
- production export;
- production tracking;
- dispatch tracking.

This workflow does not require school-printed child artwork templates and should not be forced through the A1 artwork-return process.

---

### 6.4 C — Standard Product

This workflow supports simple products that do not require artwork, personalisation or production data beyond the order itself.

Examples:

- generic merchandise;
- non-personalised fundraising products;
- stock items.

Typical workflow:

```text
Project Created
→ Store Open
→ Orders Placed
→ Production / Pick / Pack
→ Dispatch
→ Completion / Commission
```

Critical requirements:

- simple product selection;
- order capture;
- fulfilment tracking;
- commission calculation.

This workflow is the simplest case and must not drive the architecture for all other workflow classes.

---

## 7. Architectural Principle 2 — Projects Are Mandatory

A Project is the primary operational entity in FUND.

Every fundraising activity must be represented as a Project.

Examples:

- St Mark’s Primary Christmas 2026 card project;
- Northgate Juniors U10 bottle fundraiser;
- Riverside United club fundraising store;
- PTA playground appeal;
- class portrait product project.

A Project owns or links to:

- organiser;
- selected products;
- lifecycle state;
- closing date;
- store;
- orders;
- artwork/data assets;
- production state;
- communications;
- commission records.

A Project may belong to an Event, but it does not have to.

---

## 8. Architectural Principle 3 — Events are not mandatory for every Project, but they remain a key concept for AMOW seasonal campaigns and any fundraising activity where multiple Projects share deadlines, product selections, communication rules, commission periods or production constraints.

Earlier thinking treated Events as mandatory. This is no longer correct.

Events are optional grouping and constraint containers.

An Event exists when there is a shared campaign context, such as:

- common product selection;
- common event date;
- common production deadline;
- common final order deadline;
- common branding;
- common communication sequence;
- common commission model.

Examples:

- Christmas 2026;
- Mother’s Day 2027;
- Father’s Day 2027;
- Leavers 2027;
- Summer Sports Tour Fundraiser.

A Project may:

1. belong to an Event; or
2. operate independently without a parent Event.

---

## 9. Event-Based Projects

When a Project belongs to an Event, it inherits configuration and constraints from that Event.

An Event may define:

- event name;
- event date;
- campaign opening date;
- final project creation date;
- event production deadline;
- latest store closing date;
- available product catalogue or product selection;
- communication sequence;
- commission rules;
- branding;
- terms and policies.

Example:

```text
Event: Christmas 2026
Event Date: 25 December 2026
Production Deadline: 15 December 2026
Latest Store Close: 15 December 2026 at 23:59
Products: AMOW Christmas Catalogue 2026
```

Child Projects:

```text
Project A: St Mark’s Primary
Store Close: 1 December 2026 at 23:59

Project B: Northfield School
Store Close: 5 December 2026 at 23:59

Project C: Riverside Primary
Store Close: 10 December 2026 at 23:59
```

All are valid because each Project closes no later than the Event production deadline / latest store close.

Validation rule:

```text
Project Closing Date <= Event Latest Store Close / Production Deadline
```

Projects may close earlier than the Event deadline.

Projects must never close later than the Event deadline.

---

## 10. Independent Projects

Some Projects may not belong to an Event.

Examples:

- playground appeal;
- football tour fundraiser;
- club fundraising drive;
- one-off school fundraising project;
- bulk personalised bottle order;
- special community appeal.

Independent Projects define their own:

- closing date;
- product selection;
- communication rules;
- branding where needed;
- production deadline where needed;
- commission rules where needed.

They must still follow a Project Lifecycle and must still use Product Workflow Classes.

Independent Project support avoids creating artificial Events where no shared campaign container is needed.

---

## 11. Architectural Principle 4 — Stores Are Generated From Projects

Stores are generated from Projects, not from Events.

An Event may influence the Store, but the Project owns the Store context.

A Store is the public or semi-public sales surface for a Project.

A Store should inherit from the Project:

- project number;
- project name;
- selected products;
- prices;
- terms and policies;
- branding;
- close date;
- organiser context;
- commission context.

If the Project belongs to an Event, much of that configuration may itself have been inherited from the Event.

The hierarchy is therefore:

```text
Event (optional)
  → Project
      → Store
```

not:

```text
Event
  → Store
      → Project
```

---

## 12. Architectural Principle 5 — Products Belong to Tenants

Products belong to Tenants.

Products must never belong to FUND itself.

This allows FUND to support:

- AMOW as initial product provider;
- future producers;
- production partners;
- SeasonPro tenants selecting approved products;
- multiple catalogues;
- marketplace expansion.

Example:

```text
Tenant: AMOW
  Catalogue: AMOW Christmas Catalogue 2026
    Product: Christmas Cards
    Product: Calendar
    Product: Tea Towel
    Product: Water Bottle

Tenant: Future Producer
  Catalogue: Sportswear Catalogue
    Product: Hoodie
    Product: Training Top
    Product: Kit Bag
```

Events may select from one or more catalogues.

Projects inherit or select products from the available Event or tenant catalogue configuration.

---

## 13. Architectural Principle 6 — Lifecycle Must Be Workflow-Aware

A single fixed lifecycle is not sufficient.

FUND needs a common core lifecycle plus workflow-specific extensions.

---

### 13.1 Core Project Lifecycle

All Projects may share a minimal core lifecycle:

```text
Draft
→ Created
→ Store Open
→ Selling
→ Closed
→ Complete
```

---

### 13.2 Artwork Product Extension

A1 Artwork Products require additional states such as:

```text
Template Generated
→ Template Downloaded
→ Artwork In Circulation
→ Artwork Returned To School
→ Artwork Received By Producer
→ Artwork Matched To Orders
→ Artwork Verified
→ Production
→ Dispatched
```

---

### 13.3 Group Artwork Extension

A2 Group Artwork Products require states such as:

```text
Artwork Collection Open
→ Artwork Received
→ Artwork Collated
→ Composite Design Created
→ Design Approved
→ Production
→ Dispatched
```

---

### 13.4 Mass Customisation Extension

B Mass Customisation Products require states such as:

```text
Personalisation Data Required
→ Data Uploaded
→ Data Validated
→ Production Export Generated
→ Production
→ Dispatched
```

---

### 13.5 Standard Product Extension

C Standard Products may only require:

```text
Order Received
→ Production / Fulfilment
→ Dispatched
```

---

## 14. Architectural Principle 7 — AMOW Artwork Workflows Are Not Edge Cases

AMOW artwork workflows are not edge cases.

They are the founding workflow and the reason the first funded implementation exists.

The system must explicitly preserve:

- project template generation;
- template download by school / organiser;
- printed templates distributed to children;
- artwork created by children;
- artwork sent home with ordering instructions;
- parents ordering online against the Project Number;
- artwork returned to school;
- school batching artwork;
- AMOW receiving physical or uploaded artwork;
- artwork matched to orders;
- production and dispatch.

Codex must not simplify this into:

```text
Upload artwork → Place order → Dispatch
```

That is not the established AMOW workflow.

---

## 15. Architectural Principle 8 — Commerce Is Layered Around Lifecycle

Orders and payments are important, but they do not define the module.

Commerce should be implemented as a service layer around Projects and Stores.

Orders must be linkable to:

- Project;
- Store;
- Product;
- Product Workflow Class;
- Order Items;
- customer / parent / supporter;
- payment status;
- fulfilment status;
- production batch;
- commission records.

The internal order model should not be tightly coupled to a single external commerce provider.

The commerce provider may change over time.

The Project and Order relationship must remain stable.

---

## 16. Architectural Principle 9 — Dashboards Reflect Lifecycle, Not Just Data

FUND dashboards must not be passive reporting screens.

They should reflect lifecycle state and required action.

---

### 16.1 Operations Dashboard

Used by:

- AMOW;
- producers;
- production staff;
- tenant administrators;
- Isoblue where appropriate.

It should show:

- active Events;
- active Projects;
- Projects approaching deadlines;
- Stores closing soon;
- missing artwork;
- missing personalisation data;
- orders requiring production;
- production exceptions;
- dispatch status;
- commission status.

It answers:

- What needs attention?
- Which deadlines are approaching?
- What is ready for production?
- What is blocked?
- What has been dispatched?

---

### 16.2 Organiser Fundraising Dashboard

Used by:

- schools;
- clubs;
- PTAs;
- fundraisers;
- SeasonPro club users where applicable.

It should show:

- Project Number;
- Store link;
- current lifecycle stage;
- sales progress;
- key dates;
- required actions;
- template downloads;
- artwork/data requirements;
- production progress;
- dispatch progress;
- commission information.

It answers:

- How are sales going?
- What happens next?
- What do I need to do?
- Has production started?
- Have products been dispatched?

The Organiser Fundraising Dashboard is an engagement tool, not just a data view.

---

## 17. Architectural Principle 10 — Commissions Are Configurable

Commission values must never be hard-coded.

Commissions may vary by:

- tenant;
- product;
- catalogue;
- Event;
- Project;
- participant role;
- production partner;
- channel;
- future marketplace rules.

Example values discussed:

- Isoblue platform commission: 2.5%;
- League tenant commission: 1.5%;
- Club commission: 1.5%.

These are examples only.

Possible commission participants include:

- Isoblue;
- AMOW;
- producer;
- production partner;
- league;
- club;
- school;
- organiser;
- fundraising operator.

The commission engine must be capable of generating transparent commission records from orders or order items.

---

## 18. Architectural Principle 11 — AMOW Is Founding Production Partner and Launch Tenant

AMOW is not merely sample data.

AMOW is:

- the founding use case;
- the launch tenant;
- the initial product catalogue owner;
- the primary production partner;
- the initial fulfilment partner;
- the initial dispatch partner;
- the operational expert behind the artwork workflows.

FUND should not be hard-coded to AMOW, but AMOW’s workflows must be treated as first-class requirements.

Future producers may join.

AMOW may also benefit from configurable marketplace commission or production revenue when FUND creates new routes to market.

---

## 19. Architectural Principle 12 — SeasonPro Is a Future Distribution Channel, Not a Core Dependency

SeasonPro integration is strategically important, but it must not drive the first implementation.

SeasonPro should be treated as a future distribution channel where:

```text
SeasonPro League Tenant
→ Enables FUND
→ Selects approved fundraising products
→ Clubs create Projects
→ Parents / supporters order
→ Commission is distributed
→ Producer fulfils orders
```

FUND must not become football-specific.

No football-specific assumptions should pollute the core FUND model.

SeasonPro integration should use configurable relationships, tenant roles, permissions and commission rules.

---

## 20. Architectural Principle 13 — IsoStack Owns Infrastructure; FUND Owns Domain Logic

FUND must consume IsoStack infrastructure rather than recreate it.

IsoStack owns:

- authentication;
- magic links;
- user accounts;
- organisations;
- roles;
- permissions;
- audit logging;
- tenant isolation;
- database infrastructure;
- file storage where provided;
- email delivery services;
- dashboard framework;
- tRPC conventions;
- validation patterns;
- module navigation;
- feature flags;
- shared settings where applicable.

FUND owns:

- fundraising-specific Events;
- Projects;
- Product Workflow Classes;
- Product/catalogue behaviour within fundraising;
- Store rules;
- Project lifecycle rules;
- artwork/data workflow;
- production coordination;
- commission domain logic;
- organiser engagement logic;
- FUND-specific dashboard behaviour.

---

## 21. Conceptual Entity Priorities

This is not a final Prisma schema. It is an architectural ordering of importance.

Priority entities for early schema design:

1. FundProductWorkflowClass
2. FundProduct
3. FundCatalogue
4. FundProject
5. FundProjectLifecycleState
6. FundEvent
7. FundStore
8. FundOrder / FundOrderImport / FundOrderReference
9. FundArtworkAsset
10. FundPersonalisationData
11. FundProductionBatch
12. FundCommissionRule
13. FundCommissionLine
14. FundEmailSequence / FundKeyDate

Important note:

The exact entity names may change after repository inspection, but the conceptual priorities should not be reversed.

Product Workflow Class and Project Lifecycle must not be bolted on after Store and Order modelling.

---

## 22. Forbidden Assumptions

Codex and developers must not assume:

- every Project belongs to an Event;
- every Product follows the same lifecycle;
- every Product is a simple online order item;
- every Project starts with a Store;
- Store creation is the centre of the workflow;
- Events are mandatory;
- AMOW’s printed template workflow is obsolete;
- artwork workflows are edge cases;
- group artwork is the same as individual artwork;
- mass customisation is the same as artwork submission;
- SeasonPro is required for FUND;
- football clubs are the primary user type;
- commerce provider choice defines the internal order model;
- commission rates can be hard-coded;
- customers necessarily need IsoStack accounts;
- production partner equals tenant owner in all cases;
- Product Catalogue equals Event;
- Event equals Project.

---

## 23. Development Priorities

Initial FUND development should prioritise proving the model before building deep commerce features.

Recommended order:

1. Confirm module structure and documentation.
2. Model Product Workflow Classes.
3. Model Tenant-owned Products and Catalogues.
4. Model Projects as mandatory operational entities.
5. Model optional Events as campaign containers.
6. Enforce Event-to-Project date constraints where Events exist.
7. Model lifecycle states and workflow extensions.
8. Build Operations Dashboard visibility.
9. Build Organiser Fundraising Dashboard visibility.
10. Add Store generation / association.
11. Add Order capture or import.
12. Add commission calculation.
13. Add lifecycle-based communications.
14. Add production and fulfilment workflow.
15. Add SeasonPro integration.
16. Add marketplace / multi-producer expansion.

---

## 24. Initial Architecture Success Criteria

A successful early implementation proves that:

1. Products can be assigned to workflow classes.
2. A1 Artwork Products can require template generation and artwork return tracking.
3. A2 Group Artwork Products can require artwork collation and composite production stages.
4. B Mass Customisation Products can require personalisation data upload and validation.
5. Projects can exist with or without Events.
6. Event-based Projects inherit constraints from Events.
7. Project close dates cannot exceed Event deadlines where Events exist.
8. Stores are linked to Projects.
9. Orders are linked to Projects and Products.
10. Dashboards reflect lifecycle stage and required action.
11. Commissions are configurable.
12. AMOW’s founding workflow remains intact.
13. The same model can later support SeasonPro without becoming football-specific.

---

## 25. Codex Operating Guidance

Before editing code, Codex must:

1. read `01-fund-module-brief.md`;
2. read this document;
3. inspect the current IsoStack repository;
4. identify existing module patterns;
5. identify existing tenancy conventions;
6. identify existing permission patterns;
7. identify existing audit logging conventions;
8. identify existing tRPC and Zod patterns;
9. identify existing Mantine UI patterns;
10. propose a small implementation plan before making changes.

Codex must not assume that FUND models, routes, routers, services or UI files already exist.

Codex must not use `db push`.

Codex must not run destructive database commands without explicit approval.

Codex must preserve tenant scoping in all normal tenant-level queries.

Codex must not work directly on `main` for ordinary development.

---

## 26. Recommended AI Handoff Prompt

Use this when resuming FUND implementation work with Codex:

```text
You are working on IsoStack, a live multi-tenant SaaS platform.

Before editing anything:
1. Read 01-fund-module-brief.md.
2. Read 02-fund-architecture-principles.md.
3. Inspect the existing IsoStack repository and module patterns.
4. Confirm the current branch and do not work directly on main.
5. Do not use db:push.
6. Do not run seed/reset/destructive database commands without approval.
7. Preserve tenant scoping by organizationId or the current IsoStack tenancy equivalent.
8. Use tRPC, Zod, Prisma and Mantine patterns already established in the codebase.
9. Propose a small implementation plan before editing.

FUND is lifecycle-first and production-aware.

Product Workflow Class is first-class.
Projects are mandatory.
Events are optional campaign containers.
Stores are generated from Projects.
Commerce is layered around Projects, not the centre of the model.

AMOW artwork workflows are founding requirements, not edge cases.
Do not simplify FUND into a shop/order system.
```

---

## 27. Final Architectural Principle

The best version of FUND is not the fastest store builder.

The best version of FUND is a reusable, tenant-safe, lifecycle-driven, production-aware module that solves AMOW’s artwork and production workflows first, while remaining flexible enough to support future fundraising channels, SeasonPro integration, additional producers and marketplace-style expansion.

FUND must protect the core workflow before it expands the commercial opportunity.
