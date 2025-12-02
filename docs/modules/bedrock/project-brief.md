Absolutely — here is the **fully refined, clarified, project-initiation-ready** version of your *Bedrock Information Architecture* document.
I have:
✔ Fixed all consistency issues✔ Clarified Tab 2 vs Tab 3 responsibilities✔ Added the missing conceptual scaffolding (scope, non-goals, assumptions, open questions, phase plan)✔ Cleaned structure, headings, typos✔ Retained your voice and intent✔ Ensured alignment with IsoStack’s module model

# Bedrock Information Architecture (Project Initiation Draft)
**Version:** 2.1**Date:** 2025-11-18**Status:** Project Initiation (Ready for Dev)**Author:** Chris (BA / Product Owner)**Module:** Bedrock (IsoStack Module 001)

# 1. Overview
Bedrock is the **reporting engine of IsoStack** and the first full application module.It enables clients to connect spreadsheet-like data, transform it, and define views for end-users.
Bedrock 3.0:
* **Reuses concepts from Bedrock 1.0 & 2.0**
* **Introduces a new schema, new UI, new workflow**
* **Implements the IsoStack module framework**
* **Lives in a dedicated database schema** (e.g., bedrock.*)
* **Is fully modular** — owner can enable/disable per tenant

⠀Bedrock 2.0’s database is **reference-only**, not reused directly.
Projects in Bedrock follow a clear pipeline:
**Input → Transform → Configure → Output**
Every configuration exists in **only one layer**, and end-user display settings live exclusively in the **Display & Analysis**layer.

# 2. Design Principles
**1** **Single Source of Truth**Every configuration lives in exactly one place.
**2** **Clear Data Flow****Select Source → Ingest → Transform → Configure → Display**
**3** **Read vs Write Separation**Sheets = what we received.Virtual Columns & Display = what we do with it.
**4** **Progressive Disclosure**Start simple, reveal complexity only when needed.
**5** **Explicit State**Users should always know what data was detected and validated.
**6** **Module Encapsulation**All Bedrock data persists in its own schema; it never pollutes the IsoStack core.

⠀
# 3. Project Visibility
Each project may expose one or more **views**.
* **Public** – viewable by link, no authentication
* **Private** – requires IsoStack login & permissions
* **Email-filtered** – each user only sees rows that match their email address

⠀Visibility is defined **per view**, not per project.

# 4. Information Architecture Overview
A client may have **many projects**, and each project has **three layers**:
### ┌─────────────────────────┐
### │     Data Connector      │  External/Internal Source
### └────────┬────────────────┘
###          │
###          ▼
### ┌───────────────────────────────┐
### │  1. SHEETS (Layer 1 – Ingest) │  Read-only validation
### └────────┬──────────────────────┘
###          │
###          ▼
### ┌───────────────────────────────┐
### │  2. RELATIONSHIPS & VIRTUAL   │  Join logic & data transformation
### │     COLUMNS (Layer 2)         │
### └────────┬──────────────────────┘
###          │
###          ▼
### ┌───────────────────────────────┐
### │  3. DISPLAY & ANALYSIS        │  View definitions (Output)
### │     (Layer 3)                 │
### └────────┬──────────────────────┘
###          │
###          ▼
### ┌───────────────────────────────┐
### │        End User View          │
### └───────────────────────────────┘
**This three-layer separation is non-negotiable and defines the Bedrock 3.0 philosophy.**

# 5. Layer-by-Layer Specification

# Layer 1 — Sheets (Ingestion / Read-Only Validation)
# Purpose
To confirm that Bedrock successfully ingested data from a Sheet or data source.This layer is **diagnostic only** — no renaming, no configuration, no transformations.
# User Mental Model
“These are the sheets I connected, and Bedrock has correctly read them.”
# UI Structure (Accordion)
### Accordion Header
* Sheet name
* Status (✓ Synced, ⚠ Warning, ✗ Error)
* Last sync timestamp
* Column count
* Row count

⠀Accordion Content
* Table of detected column names (raw)
* Detected data types
* Sample values (first 3 non-empty rows)
* Indicators for:
  * empty cells
  * long text
  * booleans, numbers, dates
* Sheet metadata
* Sync controls (“Refresh Now”, auto-sync toggle)
* Link back to Google Sheet

⠀Users CAN
* Verify data types
* Verify detected columns
* Inspect sample rows
* Refresh sheet
* Jump to source

⠀Users CANNOT
* Rename columns
* Hide columns
* Edit data
* Change types
* Add relationships

⠀**Layer 1 is purely: “show me what you received”.**

# Layer 2 — Relationships & Virtual Columns
This tab houses **all transformation logic** and **all technical relationships**.

# Section 1: Technical Relationships (Master/Detail)
### Purpose
Define the **join logic** between sheets.
### Configuration
* Master sheet
* Detail sheet
* Join column (PK/FK)
* Relationship name/label

⠀This establishes the **technical data structure** for later use in Layer 3.
### Notes
* Relationships here define *how* sheets connect
* Layer 3 defines *how those relationships are displayed*

⠀
# Section 2: Virtual Columns (Transformations)
### Purpose
Create new columns derived from raw sheet data.
### Types
1 Concatenation
2 Formula
3 Regex
4 Currency formatting
5 Date formatting

⠀Configuration Options
* Display name
* Output type
* Calculator type
* Source columns
* Rules/formula
* Alignment

⠀Behaviour
* Computed on-demand
* Can reference other virtual columns
* Available in Layer 3 views as if they were real columns

⠀
# Layer 3 — Display & Analysis (View Definitions)
This is **the single source of truth** for what end-users see.
Each project may have **multiple View Definitions**, each with:
* public/private flag
* its own URL
* its own column list
* its own grouping/sorting/analysis
* its own master/detail presentation

⠀The Layer 3 UI is a **collapsible accordion of views**.

# Section 1: View Definition Overview
For each View:
* Name
* Visibility (public/private/email-filter)
* Which relationship or sheet it is based on
* Preview button
* URL

⠀
# Section 2: Column Selection UI (Left/Right Panels)
### Left Panel — All Available Columns
Grouped by source sheet:
* Real sheet columns
* Virtual columns
* Column type badges
* Icons for:
  * FK/PK
  * Virtual
  * Numeric
  * Date

⠀Right Panel — Selected Columns (Displayed to end-user)
* Drag-and-drop order
* Visibility toggle
* Icons showing:
  * Grouping
  * Sorting
  * Analysis
  * Label override

⠀
# Section 3: Column Editor Modal
Includes:
* Include/exclude
* Display label
* Order
* Alignment
* Grouping
* Sorting direction
* Analysis options (sum, count, avg)

⠀
# Section 4: Project-Level Formatting
* Currency symbol
* Thousands separator
* Decimal places
* Default date format
* Timezone

⠀
# 6. New Project Flow
**1** **Connect Sheet**
**2** **Inspect Sheet (Layer 1)**
**3** **Define Relationships (optional)**
**4** **Create Virtual Columns (optional)**
**5** **Configure Views (Layer 3)**
**6** **Preview**
**7** **Publish (public/private/email-filtered)**

⠀
# 7. Benefits of This Architecture
* Eliminates ambiguity between ingestion, transformation, and presentation
* UX matches user expectation: step-by-step, left-to-right
* Single source of truth for display logic
* Easy to maintain, extend, and document
* Ready for multi-tenant isolation via IsoStack

⠀
# 8. Project Scope & Non-Goals
# In Scope
* Sheets ingestion (public Google Sheets first)
* Relationships engine
* Virtual column engine
* Display & Analysis layer
* Public/private/email-filter view system
* Multiple view definitions per project
* Separate bedrock.* schema
* Integration with IsoStack core (auth, branding, tooltips)

⠀Out of Scope (for Bedrock 3.0)
* Arbitrary connectors beyond Google Sheets (Knack = stub only)
* Per-column permissions
* Conditional formatting
* Charting beyond basic table-based analysis
* Multi-project dashboards
* Row-level security beyond email filtering

⠀
# 9. Assumptions & Dependencies
* IsoStack core auth (NextAuth v5) fully working
* IsoStack core multi-tenancy (organisations) stable
* Branding engine available
* R2 storage available
* **Bedrock gets its own schema** (clean isolation)
* Public Sheets used initially; OAuth added later

⠀
# 10. Known Open Questions
1 Should each View Definition be its own DB entity?
2 How should public URLs be structured?
3 Should email filtering be optional or always on for private views?
4 Do we allow multiple master-detail chains (e.g., 3-level joins)?
5 How will Bedrock display definitions fit into IsoStack’s tooltip system?

⠀
# 11. Phase Plan (High-Level)
## Phase 1 — Bedrock Skeleton (MVP)
* Project creation
* Add sheet
* Ingest & display Layer 1
* Basic View Definition engine
* End-user table rendering

##⠀Phase 2 — Relationships & Virtual Columns
* Master/detail joining
* Virtual column engine (minimum concat + formula)

##⠀Phase 3 — Full Display & Analysis
* Grouping, sorting
* Per-group & overall analysis
* Column editor modal
* Public/private/email-filtered views

##⠀Phase 4 — Stabilisation
* platform refinement and fixes highlighted by using bedrock
* Documented module lifecycle
* Ready for LMSPro adoption

⠀
# 12. Approval
* Product Owner
* Technical Lead
* UX Lead
* Ready to Implement
