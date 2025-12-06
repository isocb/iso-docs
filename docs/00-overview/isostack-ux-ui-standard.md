

## 1. `isostack-ux-ui-standard.md` (v1.2)


**AI INSTRUCTION FROM OWNER: NEVER EDIT: REFERENCE ONLY**

# 📘 **IsoStack Unified UX / UI Standard**

### *Single Source of Truth for IsoStack Core and All Modules*

### Version 1.2 — Mantine AppShell, Sidebar Context + Fuzzy Search + Management Hierarchy

---

# 1. Purpose of This Document

IsoStack is a modular, multi-tenant SaaS framework.

This document defines the **complete UI/UX grammar** that must be used across:

- IsoStack Core  
- All first-party modules (Bedrock, TailorAid, EmberBox, APIKeyChain, LMSPro…)  
- All future modules  
- All refactoring work  
- All AI-assisted UI generation  

It ensures:

- **Consistency across products**  
- **Predictable user experience**  
- **Rapid development**  
- **Reduced cognitive load**  
- **A single, enforceable design system**

This is the master reference.  
Everything else must follow it.

---

# 2. IsoStack UX Philosophy

IsoStack’s UX is built on four principles:

### **2.1 One Mental Model**

> Users should learn IsoStack once, not once per module.

### **2.2 Harmony Through Constraints**

Modules may express identity through branding, but structure never changes.

### **2.3 Transparency of Context**

Users must always know:

- Who they are (Platform Owner, Tenant Admin, End User)  
- Which tenant they are managing  
- Which module they are viewing  

### **2.4 Minimum Friction**

IsoStack follows a **Click-to-View-and-Edit** paradigm:

- No separate “view mode”  
- Modals or child pages open directly into edit mode  

---

# 3. Global AppShell Structure

Every screen in IsoStack uses **Mantine AppShell (v7.13.x)**.


┌──────────────────────────────────────────────┐
│ Mantine Header (neutral)                    │
│ - Title / Breadcrumbs                       │
│ - Profile Menu                              │
│ - Environment Badge (DEV/STAGE/PROD)        │
├──────────────────────────────────────────────┤
│ Sidebar / Navbar (tinted by context)        │
│ - Context Badge                             │
│ - Impersonation Badge (if active)           │
│ - Module Switcher                           │
│ - Tenant Branding (optional)                │
│                                              │
│ Main Content Area                            │
│ - Tabs                                       │
│ - Lists / Tables                             │
│ - Dashboards                                 │
│ - Child Pages                                │
│ - Modals                                     │
└──────────────────────────────────────────────┘


### 3.1 Header

* Always neutral background
* Contains title/breadcrumbs, profile menu, environment badge
* Must never carry tenant/module context colours

### 3.2 Sidebar / Navbar

* Background **tinted** by context scope (see Section 4)
* Contains:

  * Context badge
  * Impersonation badge (when active)
  * Module switcher
  * Optional tenant branding (logo)

### 3.3 Main Content Area

* Hosts tabs, lists, forms, dashboards, child pages, and modals
* Follows consistent spacing and typography tokens

---

# 4. Context System (Sidebar-Based)

IsoStack is multi-tenant and role-driven. Context must always be visible.

## 4.1 Sidebar Tint

The sidebar background tint indicates the current scope:

| Scope    | Tint colour | Meaning                                       |
| -------- | ----------- | --------------------------------------------- |
| Platform | Green       | Platform Owner managing tenants and modules   |
| Tenant   | Purple      | Tenant Admin working in a single organisation |
| User     | Orange      | End user working inside modules               |

Tint is subtle (10–20%), not a block of saturated colour.

## 4.2 Context Badge

At the very top of the sidebar:


[ PLATFORM MODE ]
[ TENANT: Acme Ltd ]
[ USER MODE ]


The badge uses a solid version of the scope colour.

## 4.3 Impersonation Badge

If impersonation is active:


[ IMPERSONATING: Jane Doe ]


* Appears directly under the context badge
* A “Stop Impersonation” control must also be visible in the Header

## 4.4 No Top Context Bar

Mantine AppShell uses `height: 100vh` and provides no slot above the Header.

Therefore:

* ❌ No UI bar above the Header
* ❌ No coloured strip at the top of the viewport
* ✔️ Context is always signalled in the Sidebar

---

# 5. Module Switcher

The module switcher lives in the sidebar under the badges.

Rules:

1. Show module icon + label
2. Order modules alphabetically
3. Highlight the active module
4. Route by scope:

   * Platform → `/platform/<module>`
   * Tenant → `/tenant/[id]/<module>`
   * User → `/app/<module>`

The module switcher **must not contain bespoke tenant/app navigation**.
Modules provide their own internal navigation via tabs and in-page patterns.

---

# 6. Tabs and Navigation

Tabs are the primary intra-page navigation element.

## 6.1 Placement

Tabs sit directly below:

* Page title (or breadcrumb), and
* Any small help/context text

Example:

 
Client: Acme Ltd
[ Overview ] [ Users ] [ Modules ] [ Features ] [ Settings ]
  

## 6.2 Standard Tab Behaviour

* Exactly one tab is active at a time
* Tab content replaces the main page area under the tab row
* Tabs should be few and meaningful, not granular or noisy

## 6.3 Child Pages with Inherited Tabs

For **module/domain entities** (e.g. Bedrock Projects, TailorAid Question sets):

* Parent page defines the tab set
* Child pages inherit the same main tab row
* Child pages may add **secondary tabs** below the main tab row, e.g.:

 
[ Sheets ] [ Virtual Columns ] [ Display & Analysis ] [ Preview ]
    [ General ] [ Formatting ] [ Analysis ] [ Permissions ]
  

Secondary tabs must not visually compete with main tabs.

> This rule applies to **module/domain navigation** only.
> Platform-level management containers are covered by a different pattern (see Section 16).

---

# 7. List and Row Interaction Model

IsoStack defines **three row behaviours**, in priority order.

## 7.1 Default: Click → CRUD Modal

(**Click-to-View-and-Edit** pattern)

* Every row/card is a large click target
* Clicking the row opens a **CRUD modal** (Section 8)
* Opens directly in edit mode
* No separate “view mode”

Used for:

* Simple entities
* Small forms
* Items without meaningful children

Inline actions must use `stopPropagation()` to prevent accidental modal opens.

## 7.2 Complex Entities: Click → Child Page

Use a child page instead of a modal when:

* The entity has children
* Configuration requires multiple sections
* The entity spans more than ~10 inputs
* The editing experience benefits from tabs

Examples:

* Bedrock → Column → Configuration page
* TailorAid → Question → AI Behaviour / Red Flags / Metadata
* LMSPro → Team → Players

Child page rules:

* Inherits parent tab row (Section 6.3)
* Header shows entity name
* May add secondary tabs under the main tab row
* Sidebar context remains unchanged

## 7.3 Inline Quick Actions

Inline quick actions are for high-frequency, low-complexity operations:

* Status toggles
* Priority badges
* Mark-complete checkboxes

Rules:

* Must appear on the far right of the row
* Must be visually smaller than the main click target
* Must use `stopPropagation()`
* Must never be destructive (no inline delete)

## 7.4 Universal Table Controls (Mandatory Search & Sort)

All tables and list views across IsoStack — Core, Platform Management, Tenant Views, and Modules — must implement a **minimum standard control bar**, consisting of:

1. **Fuzzy search field**
2. **Sort selector (column dropdown)**
3. **Sort direction toggle (ascending/descending)**

This control bar is non-optional.

### 7.4.1 Fuzzy Search (Mandatory)

Every list/table must include, above the list:

#### A. Search Field

* Positioned top-left within the component
* Uses fuzzy search by default
* Debounced input (150–250ms)
* Placeholder: “Search…”
* Clear button appears when text is entered

#### B. Fuzzy Matching Behaviour

All searches must support:

* Partial matches
* Near matches
* Typos and transpositions
* Multi-word tokens
* Case-insensitive matching

IsoStack must never provide an exact-match-only search unless explicitly configured.

#### C. Effective Fuzzy Settings

Tables must use **effective search settings** resolved via:

> Module override → Organisation override → Platform defaults

These settings are configured in the **Search & Fuzzy Logic** accordion of Platform Settings (Section 17.2), and may be overridden:

* Per organisation (by Platform Owner only)
* Per module within an organisation (when allowed by policy)

### 7.4.2 Sort Controls (Mandatory)

Each list must display controls top-right:

#### A. Sort Dropdown

* Contains all **visible columns** in the table
* Hidden columns must not appear
* Uses human-friendly display labels
* Updates automatically when column visibility changes

Example options:

 
Name
Email
Created At
Status
Last Updated
  

#### B. Sort Direction Toggle

* Icon toggles between ▲ (ascending) and ▼ (descending)
* Clicking reverses sort direction
* Default: ascending
* Last used preference may be remembered per user in local storage

### 7.4.3 Control Bar Layout

 
┌────────────────────────────────────────────────────────────┐
│ Search: [ 🔍 input…                ]  Sort: [ Column ▼ ] [⇅] │
└────────────────────────────────────────────────────────────┘
  

* Left-aligned: search field
* Right-aligned: sort dropdown + direction toggle

Spacing and alignment follow design tokens (Section 10).

### 7.4.4 Behaviour Rules

* Controls must not scroll away with the table; they stay fixed at the top of the component
* Pressing Enter in the search field re-applies search
* Clearing search returns to the full list
* Sort is applied **after** filtering
* Lists must support server-side search/sort when datasets are large
* All users with permission to view the list see the controls

### 7.4.5 Management Hierarchy Pages

Every tab inside a **Management Hierarchy page** (Section 16), including:

* Users
* Modules
* Features
* Settings lists
* Activity logs
* Audit tables

must implement the same search + sort control bar.

This unifies:

* Platform Owner screens
* Tenant Admin screens
* Module Owner screens

---

# 8. CRUD Modal Rules

All CRUD modals share identical layout and behaviour.

## 8.1 Modal Layout

 
┌ Title (left)                 Close (right) ┐
├────────────────────────────────────────────┤
│ Scrollable main area                       │
│ - Input groups                             │
│ - Rich text blocks                         │
│ - Tag selectors                            │
│ - Metadata panels                          │
│        [Scroll Indicator if needed]        │
├────────────────────────────────────────────┤
│ Sticky Footer                              │
│ [Delete] (left)    [Cancel] [Save] (right) │
└────────────────────────────────────────────┘
  

## 8.2 Rules

* Delete always bottom-left
* Delete always red
* Cancel always grey
* Save always primary colour
* ESC closes modal
* Click outside closes modal
* Buttons show loading state when submitting
* Modal respects module/tenant branding

---

# 9. Child Page Rules

Used for advanced or hierarchical entities.

### Must include

* Breadcrumb
* Inherited parent tab row (for module/domain entities)
* Optional secondary tabs
* Page title reflecting entity
* Consistent spacing and margins
* Inline contextual actions in top-right of content

### Must not include

* Bespoke navigation bars
* Full-width colour blocks beyond theme
* Unscoped styles

---

# 10. Design Tokens (Platform-Wide)

### Spacing

* Outer padding: 16–24px
* Card padding: 16px
* Row spacing: 12px
* Modal interior: 20px

### Typography

* H2 – Page titles
* H4 – Section titles
* Body – 14px (0.875rem)

### Colour

Use Mantine theme with tenant/module overrides.

* Delete: Red
* Info: Blue
* Success: Green
* Warn: Yellow

### Transitions

* Shadows: 0.2s ease
* Modal transitions: Mantine defaults

---

# 11. Accessibility Standards

IsoStack must meet WCAG AA.

* Click targets ≥ 44 × 44 px
* Keyboard-accessible modals
* Visible focus rings
* ARIA-labelled tabs
* High contrast text
* ESC-to-close everywhere
* Focus returns to originating row/card

---

# 12. Module Author Requirements

Every module must provide:

 
id
label
icon
platformRoute
tenantRoute
userRoute
getDashboardCards()
getFeatureFlags()
  

### Required screens

* Dashboard
* Primary list
* CRUD modal OR child page
* Settings tab
* Help/Tooltip integration

### Optional screens

* Multi-layer relationships
* Analytics
* Bulk operations
* Import/export

---

# 13. Rules for Refactoring Older Modules

When updating a legacy module:

### 13.1 Replace custom patterns with standards

* Replace custom sidebars with IsoStack sidebar
* Replace bespoke tabs with IsoStack tabs
* Replace old modals with CRUD modal standard
* Align spacing, typography, colours
* Replace ad-hoc search/sort with universal table controls

### 13.2 Convert inconsistent navigation

* Multi-step wizards → tabs
* Deep nested modals → child pages
* Hidden actions → visible buttons

### 13.3 Align with Sidebar Context System

No module may override or hide:

* Sidebar tint
* Context badge
* Impersonation badge

---

# 14. AI / Copilot Guardrails

When generating UI, AI co-pilots must:

* Default row → CRUD modal (unless entity is a management container or complex entity)
* Use child pages only for complex entities that benefit from tabs
* Always output a tab row for multi-section screens
* Always include sticky modal footers
* Always inherit parent tabs on module/domain child pages
* Always place Delete bottom-left in modals
* Always apply sidebar tint and badges for context
* Never place UI elements above the Mantine Header
* Never create bespoke navigation patterns outside these rules
* Always include search + sort controls on any table/list
* Always respect spacing and typography tokens

---

# 15. Summary

IsoStack UX is defined by:

* Shared AppShell with sidebar-based context signalling
* Consistent tab-based navigation
* Click-to-View-and-Edit as the default pattern
* Standard CRUD modals and child pages
* Universal table controls with fuzzy search and sort
* Unified design tokens and accessibility rules
* Stable patterns for AI-assisted development

---

# 16. Management Hierarchy Navigation Pattern

Some entities in IsoStack represent **management containers**, not simple CRUD items.
These entities require a navigation pattern that differs from:

* Standard CRUD modals, and
* Module/domain child pages with tab inheritance

For **Platform Owners**, **Tenant Admins**, and some **Module Administrators**, the correct metaphor is:

> **Top-Level List → Management Dashboard Page (with its own tab set)**

## 16.1 When This Pattern Applies

Use this pattern when an entity:

* Acts as a parent object for multiple types of management data
* Has multiple administrative dimensions (Overview, Users, Modules, Features, Settings, etc.)
* Must support:

  * Deep linking
  * Bookmarkable URLs
  * Browser back/forward navigation
* Cannot be expressed effectively in a single modal
* Is inappropriate for tab inheritance because the parent context tabs are no longer relevant

Typical examples:

| Actor          | Entity  | Reason                               |
| -------------- | ------- | ------------------------------------ |
| Platform Owner | Clients | Each client has its own admin space  |
| Tenant Admin   | Users   | Roles, permissions, invitations      |
| Tenant Admin   | Modules | Per-module settings and features     |
| Module Owner   | Bundles | Complex feature bundle configuration |

These are **administrative domains** rather than simple records.

## 16.2 Navigation Behaviour

When the user clicks a row representing a management container:

1. **Do not open a modal**
2. **Do not inherit the parent’s tabs**
3. **Replace the tabs entirely** with a new tab set specific to the selected entity
4. Show a breadcrumb trail
5. Keep sidebar tint and badges unchanged
6. Perform a smooth single-page transition

This is the **only** pattern where tab sets are replaced rather than inherited.
It does **not** conflict with Section 6.3 because it operates at a different navigation level (admin domain vs module domain).

## 16.3 Management Page Structure

After clicking a row in a top-level management list, the page becomes:

* Breadcrumb, e.g. `Platform / Clients / Acme Ltd`
* New tab row, e.g.

 
[ Overview ] [ Users ] [ Modules ] [ Features ] [ Settings ]
  

* Full-width workspace below tabs for dashboards and lists
* Search + sort controls for any tables (Section 7.4)
* CRUD actions in modals for entities within tabs

## 16.4 Transition Behaviour

To avoid a jarring visual switch:

From `/platform?tab=clients`:

 
/platform?tab=clients
  → Row Click
  → React state updates immediately (no network wait)
  → Content area transforms (fade/slide animation)
  → URL updates to /platform?tab=clients&client=acme-id
  → Data fetch occurs in the background
  → Skeletons render while loading
  

This ensures:

* Instant feedback
* No sudden blank screens
* Bookmarkable, shareable URLs
* Proper browser back/forward behaviour
* Potential for caching previously loaded entities

This transition model is **mandatory** for all management container entities.

## 16.5 UI Constraints for Management Pages

* **Row click → always management page** for management containers
* **Never** use modals as the primary view for these entities
* **Create New** buttons still appear top-right in relevant tabs
* R/U/D operations inside a management page still use standard CRUD modals

Table rows within the management page:

* Obey the same rules as Section 7 (CRUD modal vs child page)
* May themselves open modals or secondary child pages

## 16.6 Example: Platform Owner → Client Management

### List View

 
Platform / Clients
[ New Client ]
----------------------------------------
| Acme Ltd       | 5 Modules | £120/mo |
| Star Corp      | 3 Modules | £60/mo  |
| Indigo Health  | 7 Modules | £220/mo |
----------------------------------------
  

### Click “Acme Ltd”

* Smooth transform to detail layout
* URL changes to `/platform?tab=clients&client=acme-id`
* Tab row is now:

 
[ Overview ] [ Users ] [ Modules ] [ Features ] [ Settings ]
  

* Skeleton loaders display while data loads

This is the canonical management hierarchy flow.

---

# 17. Platform Settings UX Pattern (Accordion-Based)

Platform Settings is the main control surface for global and cascading configuration.
It must use a **single-column Accordion layout** to keep complexity manageable.

## 17.1 Layout

Platform Settings structure:

* Title: **Platform Settings**
* Subtitle: Short explanatory text
* Body: Mantine `Accordion`, with each item representing a logical settings domain.

Recommended groups:

1. **Branding & Identity**

   * Logos, primary/secondary colours, typography defaults
2. **Email & Notifications**

   * Default from/reply-to, SMTP/provider configuration, key templates
3. **Security & Access**

   * Session settings, impersonation policy, passwordless configuration
4. **Search & Fuzzy Logic**

   * Global and cascading search configuration (Section 17.2)
5. **Banding, Currency & Billing**

   * Currency, number formats, pricing bands
6. **APIs & Integrations**

   * API keys, webhooks, external connectors

Each Accordion item:

* Has a clear title and optional helpful description
* Contains a structured form for that settings domain

Only a subset needs to be open at any one time, but allowing multiple-open mode is acceptable.

## 17.2 Search & Fuzzy Logic (Platform Level)

This Accordion item controls global and cascading search settings.

It contains three logical panels:

### 17.2.1 Platform Defaults Panel

Controls:

* Toggle: `Enable fuzzy search by default`
* Slider: `Fuzzy sensitivity` (Low → High)
* Numeric input: `Maximum results per search`
* Select: `Default search mode` (`Fuzzy` / `Exact` / `Hybrid`)

These values form the **baseline** for all lists and tables across IsoStack.

### 17.2.2 Organisation Override Panel

Visible only to Platform Owners.

Contains:

* Info text explaining that organisation overrides can only be configured by Platform Owners
* Searchable dropdown: `Select organisation`
* For the selected organisation:

  * Toggle: `Use custom search settings for this organisation`
  * When enabled:

    * Same fields as Platform Defaults (mode, sensitivity, max results)
  * A visual indicator of which organisations currently have overrides

This maps to the `OrganisationSearchSettings` concept in the architecture.

### 17.2.3 Module Override Policy Panel

Controls whether tenants may use module-specific search overrides.

Contains:

* Explanation of module-level overrides
* For each module in the catalogue:

  * Toggle: `Allow module overrides at tenant level`

If disabled for a module:

* That module must always use the organisation’s (or platform) effective settings
* Tenant Admins see read-only values in that module’s settings

This maps to `ModuleSearchPolicy` and `OrganisationModuleSearchSettings` in the architecture.

## 17.3 Organisation-Level Search Settings (Client Settings Tab)

When a Platform Owner views a specific organisation (via Platform → Clients → [Client]) and opens its **Settings** tab, a card labelled:

> **Search & Fuzzy Logic (Organisation Override)**

must be present.

This card contains:

* Explanation that values here override platform defaults for this organisation only
* Toggle: `Use custom search settings for this organisation`
* Same field set as Platform Defaults (mode, sensitivity, max results)

Tenant Admins see these values as **read-only**.
Only Platform Owners can edit them.

## 17.4 Module-Level Search Settings (Per Organisation, Per Module)

Inside each module’s **Settings** tab (when viewed in a tenant context):

* Show an information block indicating the source of effective settings, e.g.:

> “Current search settings source: Module override / Organisation override / Platform default”

* If module overrides are allowed by policy:

  * Toggle: `Use custom search settings for this module`
  * When enabled:

    * Same fields as platform/organisation (mode, sensitivity, max results)
* If overrides are not allowed:

  * Fields are read-only
  * Include a message such as:

    * “Module-level overrides have been disabled by your platform provider.”

This makes override precedence visible:

> Module → Organisation → Platform

---

This document is the authoritative reference for IsoStack UX and must be kept in sync with the core architecture and AI anchor documents.

  `
