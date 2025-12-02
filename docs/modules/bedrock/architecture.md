# Bedrock Module Architecture

**Version:** 3.0  
**Status:** Draft for Implementation  
**Related Docs:**  
- `information-architecture.md` (conceptual UX & behaviour)  
- `data-model.md` (entities and tables)  
- `development-plan.md` (phases and milestones)

---

## 1. Architectural Role Within IsoStack

Bedrock is an **IsoStack module** that uses:

- IsoStack **core** for:
  - Authentication (NextAuth v5 / magic links)
  - Multi-tenancy (organisations)
  - Branding (tenant logo/colours)
  - Tooltips & help system
  - Media storage (Cloudflare R2)
- Bedrock’s own **schema** (e.g. `bedrock.*`) for:
  - Projects
  - Data connectors and sheet ingestion
  - Virtual columns and relationships
  - View definitions and analysis config

The guiding principle is:

> **Core owns people and organisations.  
> Modules own their own domain data.**

---

## 2. High-Level Components

### 2.1 Backend

- **Runtime:** Node.js, same as IsoStack core
- **Framework:** Next.js API routes and/or tRPC routers under `/server/bedrock/*`
- **ORM:** Prisma, mapping to `bedrock.*` tables
- **Database:** Neon PostgreSQL (shared instance, module-specific schema)

Key backend responsibilities:

- Validate and store project configuration
- Fetch and cache sheet data
- Apply transformations (virtual columns)
- Resolve relationships and joins
- Execute grouping, sorting, and basic aggregations
- Enforce view-level visibility rules (public/private/email-filtered)

### 2.2 Frontend

- **Framework:** Next.js App Router  
- **UI Library:** React + Mantine 6  
- **State & Data:** tRPC/react-query style hooks

Key frontend surfaces:

- **Owner / Admin UI:**
  - Project list
  - Project editor (Tabs: Sheets / Relationships & Virtual / Display & Analysis)
- **End-user View UI:**
  - Read-only views with grouping, sorting, and filtering
  - Public and private variants

### 2.3 Modules and Permissions

IsoStack core knows:

- Which tenants have Bedrock enabled
- Which users (within a tenant) can:
  - Administer Bedrock projects
  - View private Bedrock views
  - Export data (if allowed)

Permissions are **organisation-scoped**; Bedrock does not invent its own separate user system.

---

## 3. Three-Layer Data Architecture

Bedrock’s internal architecture follows the three-layer model:

1. **Layer 1 – Ingestion (Sheets)**
2. **Layer 2 – Modelling (Relationships & Virtual Columns)**
3. **Layer 3 – Presentation (Display & Analysis / View Definitions)**

### 3.1 Layer 1 – Sheet Ingestion

**Purpose:** Represent the data we have received from sources, without interpretation.

Core entities (see `data-model.md` for detail):

- `Project` – the parent
- `Sheet` – a single data source (e.g. a Google Sheet tab)
- `SheetColumn` – physical column description (name, type, key flags)
- `SheetRow` / `SheetData` – raw row JSON

Rules:

- No renaming, hiding, or analysis at this layer.
- Used as the **anchor** for everything else.
- Only concerns: “can I read this?” and “what shape is it?”

### 3.2 Layer 2 – Relationships & Virtual Columns

**Purpose:** Define how raw sheets relate to each other and how data is transformed.

Core entities:

- `Relationship` – master/detail linkage between sheets
- `VirtualColumn` – transformation definitions (concat, formula, regex, currency, date, width)

Responsibilities:

- Joins and navigation between sheets
- All **data-shaping** prior to display
- Does not know about “public vs private views” – purely structural/transformational

### 3.3 Layer 3 – Display & Analysis (View Definitions)

**Purpose:** Define what end-users actually see.

Core entities:

- `ViewDefinition` – a single logical view (with URL, visibility, etc.)
- `ViewFieldConfig` – which columns appear and how they are labelled
- `ViewAnalysisConfig` – grouping, sorting, and aggregations per view

Responsibilities:

- Column selection and order
- Labels and basic formatting
- Group-by and aggregate behaviour (sum, count, avg, min, max)
- Visibility modes:
  - Public
  - Private (authenticated)
  - Email-filtered

---

## 4. Tenancy & Isolation

- All Bedrock data is partitioned by **IsoStack `organisation_id`**.
- RLS can be applied at the `organisation_id` level in the `bedrock` schema.
- View access is then further scoped by:
  - User membership of organisation
  - View visibility mode
  - Optional email-based filters

Bedrock **never stores its own independent “tenant” concept**; it always maps back to core’s organisation model.

---

## 5. Connectors & Data Sources

Initial target:

- **Google Sheets via public or service-account access**  
  - Tenant provides sheet URL(s) and tab names.
  - The IsoStack service account (or public access) is used to read data.
  - Connector configuration is stored in Bedrock’s schema.

Future:

- Additional connectors (Knack, Airtable, etc.) can be registered as new connector types, but they follow the same ingestion → transform → display pipeline.

Data mapping is always:

> Connector → Sheet(s) → Relationships/Virtual Columns → View Definitions

---

## 6. Logging & Tooltips

- **Logging:**  
  - Key configuration changes (new project, new view, view visibility changes) are written to IsoStack’s core audit log with a `module = "bedrock"` tag.
- **Tooltips:**  
  - Bedrock reuses IsoStack’s tooltip system for:
    - Onboarding the three-layer model
    - Explaining analysis options
    - Explaining visibility modes
  - Bedrock-specific tooltip categories (e.g. `bedrock.sheets`, `bedrock.virtual`, `bedrock.views`) can be defined.

---

## 7. Non-Goals (for Bedrock 3.0 Architecture)

- No separate Bedrock-specific user accounts or auth flows.
- No cross-tenant analytics or cross-project aggregation in v3.0.
- No full BI-style charting engine in v3.0 (tables + simple metrics only).
- No arbitrary per-cell or per-row permissions (beyond email-filter).

These can be layered later if needed; the architecture keeps that door open but does not require it now.

---
