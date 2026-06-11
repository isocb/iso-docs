

FUND 
superceded by the brief:  FUND_MODULE_BRIEF.md


A **Functional Specification** that explains:

* what IsoStack provides
* what FUND adds
* who the actors are
* what the workflows are
* what the module boundaries are
* how multi-tenancy works
* what the dashboards do
* what must be configurable
* what future phases must not break

This becomes the reference document for:

* Sue
* future developers
* AI coding assistants
* client discussions
* future module expansion

---

# FUND Functional Specification

## Version 1.0

---

# 1. Purpose

FUND is an IsoStack module providing fundraising, e-commerce, project lifecycle management, commission distribution, organiser engagement and production coordination.

The module originated from the operational requirements of All My Own Work (AMOW), but is being designed as a reusable capability within the wider IsoStack ecosystem.

The objective is to provide a configurable fundraising platform capable of supporting:

* Schools
* PTAs
* Football Clubs
* Football Leagues
* Community Organisations
* Charities
* Membership Bodies

without requiring bespoke redevelopment.

---

# 2. IsoStack Context

## What IsoStack Provides

IsoStack provides the shared infrastructure upon which all modules are built.

This infrastructure is not specific to FUND and should not be recreated within the module.

### Identity & Security

Provided by IsoStack:

* User Accounts
* Roles
* Permissions
* Organisations
* Tenancy
* Authentication
* Magic Links
* MFA / Biometrics
* Audit Logging

---

### Data Layer

Provided by IsoStack:

* PostgreSQL Database
* Tenant Isolation
* Soft Delete
* Audit Trails
* Versioning

---

### Communications

Provided by IsoStack:

* Email Services
* Notification Services
* Template Management

---

### E-Commerce Services

Provided by IsoStack:

* Shopping Cart
* Stripe Integration
* Orders
* Payments
* Refunds

---

### Dashboard Framework

Provided by IsoStack:

* Navigation
* Widgets
* Reporting Components
* Charts
* KPIs
* Search

---

### Automation Framework

Provided by IsoStack:

* Scheduled Tasks
* Event Triggers
* Workflow Engine

---

### File Management

Provided by IsoStack:

* Document Storage
* Image Storage
* PDF Generation
* Upload Management

---

# 3. FUND Responsibilities

FUND provides business logic relating to:

* Fundraising
* Projects
* Events
* Stores
* Products
* Organisers
* Commissions
* Production Workflow

FUND consumes IsoStack services.

FUND does not implement infrastructure.

---

# 4. Tenant Model

## Overview

FUND is a multi-tenant module.

Each Tenant operates independently.

Examples:

* AMOW
* Derby Junior Football League
* Community Charity
* PTA

---

## Tenant Responsibilities

A Tenant may:

* Maintain Product Catalogues
* Create Events
* Create Projects
* Manage Stores
* View Sales
* View Commissions
* Manage Users

---

# 5. Product Management

## Product Ownership

Products belong to Tenants.

Products are never owned by FUND itself.

Examples:

### AMOW Catalogue

* Christmas Cards
* Tea Towels
* Calendars
* Water Bottles

### Future Supplier Catalogue

* Sportswear
* Hoodies
* Trophies

---

## Product Attributes

Products may contain:

* Name
* Description
* Images
* Price
* VAT Status
* Production Partner
* Personalisation Rules
* Availability Status
* Commission Rules

---

## Product Categories

Products should support:

### Standard Products

Purchased without modification.

---

### Artwork Products

Require artwork submission.

---

### Personalised Products

Require personalisation data.

Example:

* Water Bottles
* Mugs
* Leavers Products

---

# 6. Event Management

## Purpose

Events act as project grouping mechanisms.

Examples:

* Christmas 2026
* Mother's Day 2027
* Easter 2027

---

## Event Attributes

Each Event contains:

### Event Name

Example:

Christmas 2026

---

### Event Date

The date being celebrated.

Example:

25 December 2026

---

### Production Deadline

Latest production completion date.

Example:

15 December 2026

---

### Product Selection

Products available within the Event.

Selected from Tenant Product Catalogues.

---

### Commission Rules

Applicable commission settings.

---

### Lifecycle Rules

Deadlines and workflow behaviour.

---

# 7. Project Management

## Purpose

Projects are the operational unit of fundraising.

Each Project belongs to an Event.

---

## Project Attributes

* Project Number
* Project Name
* Organiser
* Event
* Store
* Closing Date
* Lifecycle State

---

## Validation Rules

Project Closing Date must be:

≤ Event Production Deadline

Projects may close earlier.

Projects may never close later.

---

# 8. Project Types

## Seasonal Fundraising

Projects within AMOW or Tenant-defined Events.

Examples:

* Christmas
* Mother's Day

---

## Client Defined Fundraising

Created outside the normal Event calendar.

Examples:

* Playground Appeal
* Sports Tour

Internally treated as Events.

---

## Mass Customisation

Supports:

* Personalised Products
* Bulk Orders
* Name Uploads
* Production Exports

---

# 9. Project Lifecycle Engine

The lifecycle engine is the core orchestration mechanism.

Every Project follows a lifecycle.

## Standard Lifecycle

Draft

↓

Created

↓

Products Selected

↓

Template Ready

↓

Store Open

↓

Selling

↓

Closing Soon

↓

Closed

↓

Artwork / Data Received

↓

Validated

↓

Production

↓

Dispatched

↓

Commission Issued

↓

Complete

---

## Lifecycle Behaviour

Each state may:

* Trigger Notifications
* Trigger Automation
* Generate Tasks
* Update Dashboards
* Create Reports

---

# 10. Store Engine

## Store Generation

Each Project generates a unique Store.

Store URL generated automatically.

---

## Store Rules

Stores inherit:

* Products
* Prices
* Branding
* Terms
* Policies

from their Event.

---

## Closure Rules

Store closes automatically at:

23:59 Project Closing Date

but never later than:

23:59 Event Production Deadline

---

# 11. Dashboard Requirements

## Operations Dashboard

Audience:

* Tenant Administrators
* Production Staff

Purpose:

Operational control.

Displays:

* Events
* Projects
* Revenue
* Production
* Dispatch
* Exceptions

---

## Organiser Dashboard

Audience:

* Schools
* Clubs
* Fundraisers

Purpose:

Engagement and project management.

Displays:

* Store Link
* Project Status
* Sales Progress
* Key Dates
* Production Status
* Dispatch Status
* Commission Information

---

# 12. Communications Engine

## Organiser Communications

Examples:

* Project Created
* Template Ready
* Store Open
* Reminder
* Closing Soon
* Closed
* Production Started
* Dispatched

---

## Customer Communications

Examples:

* Order Confirmation
* Sales Reminder
* Dispatch Notification

---

# 13. Commission Engine

## Purpose

Automatically calculate and distribute revenue.

---

## Commission Types

### Platform Commission

Example:

Isoblue = 2.5%

---

### Tenant Commission

Example:

League = 1.5%

---

### Organisation Commission

Example:

Club = 1.5%

---

### Production Margin

Allocated to production provider.

Initially AMOW.

---

## Rules

All values configurable.

Never hard-coded.

---

# 14. Production Management

## Initial Model

AMOW acts as:

* Primary Production Partner
* Fulfilment Partner
* Dispatch Partner

---

## Future Model

Support multiple Production Partners.

Products may be assigned to:

* AMOW
* Supplier A
* Supplier B

without changing FUND workflows.

---

# 15. SeasonPro Integration

SeasonPro Tenants may enable FUND.

Examples:

League enables FUND.

↓

League selects approved products.

↓

Clubs become Organisers.

↓

Stores generated automatically.

↓

Sales tracked.

↓

Commission distributed automatically.

---

# 16. Non-Functional Requirements

FUND must:

* Be multi-tenant
* Be role-based
* Be mobile responsive
* Support audit logging
* Support automation
* Support future AI assistance
* Support future marketplace capability
* Remain independent of any single production provider

while recognising AMOW as the founding production partner.

---

# 17. Development Principle

The FUND module should be developed in phases aligned to the IsoStack philosophy:

Correct → Perfect → Adapt → Prevent

Each phase should:

* Deliver usable value
* Reduce operational risk
* Support parallel running
* Preserve future flexibility

The architecture should prioritise lifecycle management, configurability and tenant independence over short-term implementation convenience.

This document is now at the right level to sit in `/docs/modules/fund/01-functional-specification.md` within your IsoStack documentation hierarchy. It explains FUND in terms of the platform, the business model, the workflows and the future roadmap without prematurely locking you into tables, APIs or UI decisions.
