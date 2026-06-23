# FUND Functional Specification

**Canonical location:** `isodocs/docs/modules/fund/03-fund-functional-specification.md`  
**Module slug:** `fund`  
**Status:** Planning / pre-schema  
**Source documents:** `01-fund-module-brief.md`, `02-fund-architecture-principles.md`  
**Purpose:** Functional scope and behavioural requirements for FUND before implementation.

---

## 1. Purpose

This document describes what FUND must do functionally.

It does not define a final Prisma schema, migration, API contract or UI implementation.

FUND must be built as:

> A Project Lifecycle and Production Workflow Engine with fundraising, commerce, organiser engagement, commission and dashboard capabilities layered around it.

FUND must not be planned as a shop-first, store-first or order-first module.

---

## 2. Current Implementation Status

Current `isostack-bedrock` status:

- FUND module shell exists.
- `/app/fund` exists as a shell page.
- FUND is registered in the module registry.
- FUND has a minimal navigation entry.
- FUND has a `fund` feature flag.

Not yet implemented:

- FUND Prisma schema.
- FUND migrations.
- FUND tRPC routers.
- FUND services.
- FUND CRUD UI.
- FUND stores.
- FUND orders.
- FUND payment processing.
- FUND production workflows.
- FUND commission engine.

---

## 3. Core Functional Model

The functional model is:

```text
Tenant
  ├── Product Workflow Classes
  ├── Products
  ├── Catalogues
  ├── Events (optional campaign containers)
  └── Projects (mandatory operational fundraising entities)
        ├── selected products
        ├── lifecycle state
        ├── workflow requirements
        ├── optional generated/associated store
        ├── later orders
        ├── later artwork/data assets
        ├── later production tracking
        └── later commission records
```

The incorrect model to avoid is:

```text
Store -> Orders -> Production
```

Stores and orders matter, but they must be layered around Projects after the project lifecycle foundations are clear.

---

## 4. Product Workflow Classes

Every FUND product must have a Product Workflow Class.

Product Workflow Class determines:

- required data;
- required assets;
- lifecycle stages;
- validation rules;
- dashboard actions;
- production requirements;
- communications;
- exports or generated documents.

Initial workflow classes:

| Code | Name | Core Meaning |
|---|---|---|
| A1 | Individual Artwork Project Product | Individual child/user artwork drives the product workflow. |
| A2 | Group Artwork Product | Multiple artwork sources are collated into a composite product. |
| B | Logo / Bulk Mass Customisation Product | Bulk products require logo, branding or personalisation data. |
| C | Standard Product | Product does not require artwork or personalisation beyond the order. |

Workflow classes must be treated as functional drivers, not display labels.

---

## 5. Products and Catalogues

Products belong to tenants.

FUND itself must not own products.

Functional requirements:

- tenant can define products;
- product requires a Product Workflow Class;
- product may have images, descriptions, prices and availability state;
- product may be assigned to one or more catalogues;
- catalogue belongs to a tenant;
- catalogue can be used by Events or independent Projects;
- product retirement must preserve historical project/order meaning.

Initial product management can be admin-only and internal-facing.

---

## 6. Projects

Projects are mandatory operational fundraising entities.

Every fundraising activity must be represented by a Project.

Functional requirements:

- project belongs to a tenant via `organizationId`;
- project has a unique project number;
- project has a name;
- project has an organiser context;
- project may belong to an Event;
- project may operate independently;
- project has selected products;
- selected products determine workflow requirements;
- project has lifecycle state;
- project has a closing date;
- project stores future commerce associations;
- project preserves historical state even when products or catalogues change.

Project creation must not require store creation as the first step.

---

## 7. Events

Events are optional campaign containers.

Events are important for AMOW seasonal campaigns such as:

- Christmas;
- Mother’s Day;
- Father’s Day;
- Leavers;
- Summer campaigns.

Functional requirements:

- event belongs to a tenant;
- event can define campaign dates;
- event can define latest store close date;
- event can define production deadline;
- event can define available catalogues/products;
- event can define default commission rules later;
- event can define communication rules later;
- project may inherit constraints from event;
- project may close earlier than event deadline;
- project must not close later than event latest close/production deadline.

Do not require every Project to belong to an Event.

---

## 8. Lifecycle

FUND needs a common lifecycle with workflow-specific extensions.

Common lifecycle:

```text
Draft -> Created -> Store Open -> Selling -> Closed -> Complete
```

A1 extension examples:

```text
Template Generated
Template Downloaded
Artwork In Circulation
Artwork Returned To School
Artwork Received By Producer
Artwork Matched To Orders
Artwork Verified
Production
Dispatched
```

A2 extension examples:

```text
Artwork Collection Open
Artwork Received
Artwork Collated
Composite Design Created
Design Approved
Production
Dispatched
```

B extension examples:

```text
Personalisation Data Required
Data Uploaded
Data Validated
Production Export Generated
Production
Dispatched
```

C extension examples:

```text
Order Received
Production / Fulfilment
Dispatched
```

The first implementation should prove the lifecycle model before automating every transition.

---

## 9. Dashboards

### Operations Dashboard

Audience:

- AMOW;
- producers;
- production partners;
- tenant administrators;
- Isoblue where appropriate.

The Operations Dashboard should show:

- active Events;
- active Projects;
- workflow classes in use;
- upcoming deadlines;
- stores closing soon once stores exist;
- artwork/data requirements;
- production readiness;
- blocked projects;
- completion status.

### Organiser Fundraising Dashboard

Audience:

- schools;
- PTAs;
- clubs;
- fundraisers;
- future SeasonPro club users.

The Organiser Dashboard should show:

- project number;
- project status;
- next required action;
- selected products;
- key dates;
- store link once available;
- sales summary once orders exist;
- artwork/data status where relevant;
- commission summary once commissions exist.

This dashboard is an engagement tool, not just a report.

---

## 10. Commerce

Commerce is layered around Projects.

Functional requirements for later phases:

- project can generate or associate a store;
- orders link to project, store, products and order items;
- payment status is captured;
- refunds/cancellations are captured;
- order history remains stable;
- internal model must not be tightly coupled to one commerce provider.

Stripe direct integration is the current preferred direction, but Phase 1 should not be built around Stripe.

---

## 11. Artwork and Production

AMOW artwork workflows are founding requirements.

A1 must preserve:

- project template generation;
- project number on template;
- product/pricing information on template;
- child artwork area;
- parent ordering instructions;
- school download/print workflow;
- artwork return;
- artwork batching;
- producer receipt;
- artwork/order matching;
- production and dispatch.

A2 must preserve:

- multiple artwork sources;
- collation stage;
- composite design stage;
- optional approval;
- production-ready output.

B must preserve:

- quantity handling;
- logo/artwork upload where required;
- personalisation data upload;
- data count validation;
- production export.

Do not simplify AMOW into a generic upload-and-order flow.

---

## 12. Commissions

Commissions must be configurable.

Possible participants:

- Isoblue;
- producer;
- production partner;
- fundraising operator;
- league;
- club;
- school;
- organiser.

Commission calculation is not part of early Phase 1 foundation, but schema planning must not block future commission rules and records.

---

## 13. Permissions

Initial access may use platform OWNER/ADMIN plus module entitlement.

FUND-specific roles should be planned before implementation.

Likely functional permissions:

- manage workflow classes;
- manage products;
- manage catalogues;
- manage events;
- manage projects;
- view operations dashboard;
- view organiser dashboard;
- manage lifecycle transitions;
- manage stores later;
- manage orders later;
- manage production later;
- view commission later.

Important open architecture issue:

Current user role assignment has hard-coded module arrays such as `lmsproRoleIds`, `bedrockRoleIds` and `tailoraidRoleIds`. There is no `fundRoleIds` yet. This must be resolved before FUND module-role implementation.

---

## 14. Audit Requirements

Audit all significant mutations.

Early required audit actions:

- `FUND_WORKFLOW_CLASS_CREATED`
- `FUND_WORKFLOW_CLASS_UPDATED`
- `FUND_PRODUCT_CREATED`
- `FUND_PRODUCT_UPDATED`
- `FUND_PRODUCT_ARCHIVED`
- `FUND_CATALOGUE_CREATED`
- `FUND_CATALOGUE_UPDATED`
- `FUND_EVENT_CREATED`
- `FUND_EVENT_UPDATED`
- `FUND_PROJECT_CREATED`
- `FUND_PROJECT_UPDATED`
- `FUND_PROJECT_LIFECYCLE_CHANGED`
- `FUND_PROJECT_DATE_CONSTRAINT_REJECTED`

Later audit actions:

- store generated or associated;
- order imported or received;
- payment status changed;
- commission rule changed;
- commission line generated;
- artwork/data uploaded;
- production batch created;
- dispatch status changed.

---

## 15. Tenant Safety

Tenant-owned FUND records must:

- include required `organizationId`;
- relate to `Organization`;
- be queried with `organizationId` filters;
- be indexed by `organizationId`;
- be RLS-ready where applicable;
- never expose another tenant’s products, projects, catalogues, events or dashboards.

Cross-tenant marketplace or producer access must be explicitly modelled later and must not happen accidentally through unscoped queries.

---

## 16. Do Not Build Yet

Do not build yet:

- full storefronts;
- Stripe Checkout;
- GoCardless;
- order capture;
- public customer accounts;
- commission calculation;
- production batching;
- PDF generation engine;
- AMOW template rendering;
- SeasonPro integration;
- marketplace producer onboarding;
- AI automation;
- import/export tools beyond planning;
- destructive admin tooling.

---

## 17. Phase 1 Functional Success Criteria

Phase 1 succeeds if IsoStack can prove:

1. FUND shell is visible to entitled tenants.
2. Product Workflow Classes A1, A2, B and C exist as first-class concepts.
3. Tenant-owned products can be associated with workflow classes.
4. Tenant-owned catalogues can group products.
5. Projects can be created as mandatory operational entities.
6. Projects can exist with or without Events.
7. Events can constrain Project dates where used.
8. Lifecycle state can reflect workflow-specific requirements.
9. Operations dashboard can show project/workflow visibility.
10. Organiser dashboard can show project status and next actions.
11. Store association is deferred until project and lifecycle foundations are stable.

