This update reflects:
* Single-module tenants seeing **only module branding**
* Multi-module tenants getting a **module switcher + branding change**
* IsoStack Core branding visible only to **Platform Owners in `/platform`**
* **Option 2** for the switcher layout (shell stays consistent; control hides when ≤1 module)
* Feature Sets used to define **Basic / Pro** etc.
* Alignment with your other docs (`architecture.md`, `ux-patterns.md`, `work-method.md`). 

---
title: IsoStack Core Upgrade — Multi-Tenant Module Framework
version: 2.1.0
status: in-progress
date: 2025-12-05
---

# IsoStack Core Upgrade — Multi-Tenant Module Framework

## 📋 Project Overview

**Objective:**  
Transform IsoStack from a flat SaaS starter into a professional, scalable **multi-tenant, multi-module framework** where modules (Bedrock, APIKeyChain, etc.) plug into a standard Core platform — but end users experience **module brands**, not the IsoStack framework.

**MVP Timeline:**  
Target: **End of day, 5 December 2025**

**Key Outcomes:**

- IsoStack Core provides:
  - tenancy, auth, user management
  - module catalogue and feature sets
  - AppShell, layouts, dashboards, module switcher
  - impersonation, audit logging, tooltips

- Tenants experience:
  - **Single-module** → one self-contained branded app (no IsoStack, no visible module switcher)
  - **Multi-module** → a family of branded apps with a shared shell and module switcher

- Platform Owners experience:
  - IsoStack Core as their branded control plane in `/platform`
  - The ability to enter tenant context, impersonate users, and manage modules/features.

---

## 🎯 Project Goals

### Primary Goals

1. **Unified AppShell (Mantine 7.13.2)**  
   - One shared layout for all scopes (Platform, Tenant, User) and all modules.

2. **Three-Scope Architecture**  
   - **Platform** (`/platform`, green)  
   - **Tenant** (`/tenant/[id]`, purple)  
   - **User** (`/app`, orange)  

3. **Dynamic Module System**  
   - Database-managed `ModuleCatalogue`  
   - `OrganisationModule` links modules to tenants  
   - Module branding and routes defined centrally.

4. **Standardised Dashboards**  
   - KPI row → Module cards → Lists  
   - Implemented for all three scopes.

5. **Module Switcher**  
   - Visible only when user has **2+ modules**  
   - Changes active module, branding, and default routes  
   - Platform Owner always sees switcher when in tenant/user context.

6. **Features vs Modules**  
   - **Modules** = functional apps (Bedrock, APIKeyChain)  
   - **Feature Sets** = bundles of Core capabilities (Starter / Pro / Enterprise)  
   - Separation of concerns between app logic and Core services.

7. **Impersonation**  
   - Platform Owners can view as specific tenant and tenant user for support  
   - Clear visual signalling and audit logging.

8. **Bedrock Integration**  
   - Bedrock becomes the first module fully integrated into the new system.

### Secondary Goals (Future)

- User-level module pinning  
- Impersonation auto-expiry and “recent impersonations”  
- Module versioning and upgrade paths  
- Marketplace-style module discovery  
- Bulk tenant operations for modules and features.

---

## 🔒 Global Architectural Constraints

### UI

- **Mantine 7.13.2** – version pinned; all components use v7 syntax.
- All authenticated screens use **Core AppShell**.
- Tooltip anchors are **explicitly defined** (cannot rely on Mantine’s generated class names).
- Dashboards follow **standard layout grammar**:
  - Row 1: KPIs (DashboardCard)
  - Row 2: Module cards
  - Row 3: Lists/tables.
- Icons: **Tabler** only; dual sizing:
  - 32px / stroke 1 for tiles
  - 24px / stroke 1 for smaller controls.

### Backend

- `public` schema holds:
  - users, organisations, roles
  - modules, organisation-modules
  - feature sets and platform feature flags
  - audit logs and other core tables.
- Each module uses its **own schema** (e.g. `bedrock.*`).
- No cross-schema writes between modules.
- All APIs are **tRPC 11**; no REST for core features.
- UUID primary keys throughout.

### Routing & Scopes

| Scope      | Base Route          | Colour  | Purpose                                 |
|-----------|----------------------|---------|-----------------------------------------|
| Platform  | `/platform`          | 🟢 Green | Platform owner analytics and admin      |
| Tenant    | `/tenant/[id]`       | 🟣 Purple | Tenant configuration and admin          |
| User      | `/app` (→ dashboard) | 🟠 Orange | User operational views across modules   |

### Security

- Impersonation cannot escalate privileges:
  - You cannot impersonate a user with a higher role than your own.
- Row-level security enforces tenant isolation.
- All admin actions (modules, features, impersonation) are audit logged.
- Module visibility is determined by:
  - tenant → module assignments  
  - user roles within tenant.

---

## 🏗️ Core Concept: Core vs Modules vs Features

### 1. Core (IsoStack Core Infrastructure)

Core provides cross-module services:

- Tenancy and authentication  
- Users and roles  
- AppShell, dashboards, module switcher  
- Tooltip engine  
- Audit logging  
- Billing and support (where implemented)  
- Feature Set definition (Starter / Pro / Enterprise style)

Core is **not a visible product** for tenant users. It is an internal platform and brand used **only in the Platform scope**.

### 2. Modules (Applications)

Each module is a functional app, for example:

- **Bedrock** – data and reporting  
- **APIKeyChain** – secure API key proxy  
- Future modules – Emberbox, TailorAid, LMSPro, etc.

Module properties:

- Own schema (`bedrock.projects`, `bedrock.sheets`, etc.)  
- Routes for Platform, Tenant, User scopes:
  - `/platform/bedrock`
  - `/tenant/[id]/bedrock`
  - `/app/bedrock`
- Own branding (logo, primary and secondary colours, name).
- Dashboards cards for each scope (where appropriate).
- Business logic isolated per module.

### 3. Features & Feature Sets (Core Capabilities)

Features are capabilities of Core that modules can use:

- Tooltip system  
- Issue tracker  
- Audit logs  
- Billing integrations  
- Notifications  
- Support ticketing

Feature Sets group these into bundles applied at **tenant level**, e.g.:

- **Starter** – Tooltips + Issues  
- **Professional** – Starter + Audit Logs + Billing  
- **Enterprise** – Professional + Support and additional services.

Modules read feature availability via:

```ts
tenant.featureSet
platformFeatureFlags
````

rather than hard-coding logic per tenant.

---

## 🎨 Branding & Identity Rules

### The “Invisible Core” Principle

* IsoStack as a concept is **hidden from tenant users and tenant admins**.
* Core branding is visible **only** in the Platform scope (`/platform`) for Platform Owners.
* Tenant users see **module brands only**.

### Single vs Multi Module Experience

| Tenant Type    | Modules Enabled | User View               | Branding               | Module Switcher                           |
| -------------- | --------------- | ----------------------- | ---------------------- | ----------------------------------------- |
| Single-module  | 1               | `/app` → that module    | Module branding        | Hidden (logic present, control not shown) |
| Multi-module   | 2+              | `/app` → default module | Active module branding | Visible                                   |
| Tenant admin   | 1               | `/tenant/[id]`          | Module branding        | Hidden                                    |
| Tenant admin   | 2+              | `/tenant/[id]`          | Active module branding | Visible                                   |
| Platform owner | Any             | `/platform`             | IsoStack Core          | Switcher visible in tenant/app scopes     |

### Branding Hierarchy

Branding resolution order:

1. **Platform scope** (`/platform`):

   * Always show **IsoStack Core** branding:

     * IsoStack logo
     * IsoStack colour palette
   * Module logos only appear in module-specific Platform pages (e.g. `/platform/bedrock` cards), not in the main header.

2. **Tenant/User scopes** (`/tenant/[id]`, `/app`):

   * If the user has **1 module only**:

     * Use that module’s branding as if it were a standalone app.
   * If the user has **2+ modules**:

     * Use the **active module’s branding** (logo + colours).
   * Optional future: allow Tenant branding to override parts of module branding.

### Module Switcher Visibility (Option 2)

* The AppShell always reserves a standard column for navigation.

* The module switcher control (select/dropdown) is:

  ```ts
  if (userModules.length <= 1) {
    // keep layout, do not render the control
    return null;
  }
  ```

* This means:

  * **Single-module** tenants see a clean sidebar (Home / Dashboard / Settings) with no switcher.
  * **Multi-module** tenants see an additional module switcher in the same layout space.
  * There is no layout “jump” when a tenant upgrades from 1 to 2 modules: the shell structure remains the same; only the control appears.

### Default Module Selection

On login or entry to `/app`:

* If user has **1 module**:

  * Redirect `/app` → `/app/<moduleSlug>`.
* If user has **2+ modules**:

  * Redirect `/app` → `/app/dashboard`, which:

    * shows a user dashboard and
    * highlights the **last active** or **first purchased** module.
* The system persists `activeModuleSlug` in session or user preferences for continuity.

---

## 📊 Data Model Summary

### ModuleCatalogue

Database-managed list of modules.

Key fields:

* `slug`: e.g. `bedrock`
* `name`: e.g. `Bedrock`
* `description`
* `icon`: Tabler icon name
* `primaryColor`, `secondaryColor`, `logo`
* `platformRoute`, `tenantRoute`, `userRoute`
* `schemas`: array of schema names owned by the module
* `enabled`, `isPremium`, `isTrial`.

### OrganisationModule

Link table between tenants and modules.

* `organisationId`
* `moduleId`
* `enabled`
* `enabledAt`, `enabledBy`.

Unique constraint: `(organisationId, moduleId)`.

### FeatureSet

Bundle of Core features.

* `name`: e.g. Starter, Professional, Enterprise
* Feature flags such as `hasTooltips`, `hasIssues`, `hasAuditLogs`, `hasBilling`, `hasSupport`.

Each `Organisation` references one `FeatureSet`.

### PlatformFeatureFlag

Global feature toggles (extending FeatureSets).

* `slug`
* `name`
* `description`
* `enabled`, `isPremium`.

### Session Shape (Simplified)

```ts
session: {
  user: {
    id: string;
    email: string;
    organisationId: string;
    role: Role;
    isPlatformOwner: boolean;
  };
  scope: 'platform' | 'tenant' | 'app';
  currentTenantId?: string;
  activeModuleSlug?: string;
  impersonation?: {
    realUserId: string;
    realOrganisationId: string;
    impersonatedUserId: string;
    impersonatedOrganisationId: string;
    startedAt: Date;
  };
}
```

---

## 🧱 AppShell & Navigation

### Structure

The AppShell is shared across all scopes:

* **Header**

  * Logo (IsoStack or active module)
  * Breadcrumbs
  * User menu
* **Sidebar (Navbar)**

  * Home (scope-dependent: Platform/Tenant/User)
  * Dashboard
  * Settings
  * **Module Switcher** (if user has 2+ modules or Platform Owner)
* **Context Bar**

  * Thin coloured bar showing current scope and, if applicable, impersonation status.
* **Main Content Area**

  * Dashboards or module-specific pages.

### Scope Indicator

**Visual Implementation (Phase 3):**
- Sidebar background color indicates current scope
- Context card at top of sidebar shows scope details

**Color Coding:**
* Platform: **green** background
  - Context card: "Platform Owner"
* Tenant: **purple** background  
  - Context card: "[Tenant Name]"
* User: **orange** background
  - Context card: "[Tenant Name] - [user@email.com]"

**When Impersonating:**
- Context card shows: "⚠️ Impersonating {email} [Stop Impersonation]"
- Orange background (user scope)
- Clear visual warning throughout session

### Branding Application

AppShell pulls branding from:

```ts
getActiveBranding(scope, user, activeModule)
```

* If `scope === 'platform' && user.isPlatformOwner`:

  * Use IsoStack branding.
* Else:

  * Determine `activeModule` from `activeModuleSlug` or the user’s module list.
  * Use the module’s branding.

CSS variables or Mantine theme overrides apply `primaryColor` and `secondaryColor` to components.

---

## 📂 Route Structure

### Platform Scope (`/platform`) – IsoStack Core

**Unified Platform Management Interface**

`/platform` provides a single, consistent management UI for all modules with:

**Structure:**
- **Module Selector Dropdown** (top of page, grey by default)
  - "All Modules" (default) or select specific module
  - When module selected:
    - Module logo appears (60x60 box with colored border)
    - UI adopts module's primary color (borders, tabs, accents)
    - All tabs filter data by selected module
  
**Navigation Tabs** (consistent across all modules):
- **Dashboard** → System-wide or module-specific KPIs
- **Clients** → Tenant/organization management (clickable to switch to tenant view)
- **Users** → Cross-tenant user management and impersonation
- **Features** → Platform feature flag management
- **Settings** → Module configuration, branding, versioning

**Routes:**
* `/platform` → Platform Management dashboard (tabbed interface with URL state)
  - `?tab=dashboard` → System-wide KPIs and metrics
  - `?tab=clients` → Tenant organization list (clickable rows)
  - `?tab=users` → Cross-tenant user management
  - `?tab=features` → Platform feature flags
  - `?tab=settings` → System configuration
* `/platform/clients/[id]` → Client detail view with tabs:
  - **Overview** → KPIs, module summary, team preview
  - **Users** → Team management, impersonation, invites
  - **Modules** → Module Access Manager (enable/disable, features, bundles, quotas)
  - **Features** → Client-specific feature flags
  - **Settings** → Branding, quotas, danger zone
* `/platform/modules` → Module catalogue CRUD (future)
* `/platform/bedrock` → Bedrock-specific platform settings (if needed)

**Visual Identity:**
- Green sidebar (Platform scope)
- "Platform Owner" context card in sidebar
- Logo and colors change based on selected module

Only Platform Owners have access.

### Tenant Scope (`/tenant/[id]`) – Tenant Admins + Platform Owners

**Dual-Access Pattern:**
This scope serves two user types with different permission levels:

**Tenant Admins** (viewing their own organization):
- Standard tenant administration capabilities
- Manage team members, settings, module configurations
- Cannot see platform-level controls

**Platform Owners** (viewing any tenant):
- All Tenant Admin capabilities PLUS:
- Platform overlay controls (visible only to Platform Owners):
  - "Override Settings" button
  - "Impersonate User" from team list
  - Direct module enable/disable
  - Billing overrides
  - Audit log access
- Entry point: Click tenant from `/platform` → Clients tab

**Routes:**
* `/tenant/[id]` → Tenant Dashboard (purple context bar, tenant name in context card)
* `/tenant/[id]/settings` → Tenant configuration
* `/tenant/[id]/team` → Team and roles (Platform Owners see impersonation actions)
* `/tenant/[id]/modules` → Enable/disable modules for this tenant
* `/tenant/[id]/bedrock` → Bedrock tenant configuration, if enabled

**Visual Identity:**
- Purple sidebar (Tenant scope)
- Context card shows: "[Tenant Name]" for admins, or "[Tenant Name]" with platform controls for Platform Owners

**Permission Check Pattern:**
```typescript
const isPlatformOwner = user.email === 'chris@isoblue.com'; // or check PlatformAdmin table

{isPlatformOwner && (
  <Button>Override Settings</Button>
)}
```

### User Scope (`/app`) – Tenant Users

* `/app` → Redirect to `/app/dashboard` or specific module route
* `/app/dashboard` → User dashboard (shows modules and tasks)
* `/app/bedrock` → Bedrock operational view
* `/app/apikeychain` → APIKeyChain operational view, if enabled.

---

## 👤 Tenant Switching & Impersonation

### Platform → Tenant Navigation Flow

**Key Pattern:** Platform Owners can seamlessly transition between platform management and tenant-specific views.

**Flow:**
1. Platform Owner is in `/platform` (green sidebar, "Platform Owner" context)
2. Navigates to **Clients** tab in Platform Management
3. Clicks on a specific client organization
4. System navigates to `/tenant/[id]`
5. **Sidebar changes to purple** (tenant scope)
6. Context card shows tenant name
7. Platform Owner sees **additional controls** that regular Tenant Admins don't see

**Scope-Based Permission Layering:**
- Same `/tenant/[id]` route serves both:
  - **Platform Owners** viewing a tenant → Full access + platform-specific controls
  - **Tenant Admins** viewing their own organization → Standard tenant admin access
- Components use `isPlatformOwner` checks to conditionally render platform features
- Examples of platform-only features:
  - "Override Settings" button
  - "Impersonate User" action
  - Billing override controls
  - Direct module enable/disable (bypassing approval flows)

### Tenant Switching

Platform Owner can:

* Use `/platform` → **Clients** tab to select a tenant and switch context
* On switch:
  * `scope` becomes `tenant` (purple)
  * `currentTenantId` is set
  * Redirect to `/tenant/[id]`
  * Platform Owner overlay controls appear

### User Impersonation

From tenant context:

* Platform Owner can impersonate a tenant user:

  * Session gets `impersonation` object
  * Context bar switches to orange with warning
  * All actions are logged with both real and impersonated user IDs.

Safety rules:

* Cannot impersonate a user with higher privileges.
* Optional future: time-limited impersonation.

---

## 🚀 Phased Implementation Plan (MVP)

### Phase 1 – Documentation (Complete)

* Align `architecture.md`, `ux-patterns.md`, `work-method.md`.
* Create/update this `multi-tenant-project.md`.

### Phase 2 – Data Models & Seeds

* Add Prisma models:

  * `ModuleCatalogue`
  * `OrganisationModule`
  * `FeatureSet`
  * `PlatformFeatureFlag`
* Run migrations, create seed data:

  * Bedrock module
  * Starter / Professional / Enterprise feature sets.

### Phase 3 – AppShell, Scope Indicator, Branding Hooks (Complete)

* ✅ Built shared AppShell using Mantine 7.13.2
* ✅ Implemented scope-based sidebar background colors (green/purple/orange)
* ✅ Created SidebarContext component showing current scope
* ✅ Implemented branding resolution (`getActiveBranding`, `useAppBranding` hook)
* ✅ Wire in Tooltip anchors and keyboard shortcuts

**Key Decisions:**
- Vertical bar concept abandoned in favor of sidebar background color
- Context card positioned at top of sidebar (future tenant switcher location)
- Clean visual hierarchy without obstructing header

### Phase 4 – Scope Dashboards (Complete)

* ✅ Created reusable `DashboardCard` component with KPI display
* ✅ Built Platform Dashboard at `/platform` with unified management interface:
  - Module selector dropdown with dynamic theming
  - Horizontal tabs: Dashboard, Clients, Users, Features, Settings
  - Module logo display with colored borders
  - Consistent tab structure across all modules
* ✅ Built Tenant Dashboard at `/tenant/[id]` with dual-access pattern
* ✅ Enhanced App Dashboard at `/dashboard` with DashboardCard components
* ✅ Added tRPC endpoints: `getPlatformStats`, `getById`, `listAll`
* ✅ Created route group layouts for (platform) and (tenant)

**Key Patterns Established:**
- Platform Management UI filters all tabs by selected module
- Module branding (logo, colors) dynamically applied throughout interface
- Same routes serve multiple user types with conditional rendering
- Unified visual language across all three scopes

* `/platform`, `/tenant/[id]`, `/app/dashboard`.
* Use standard dashboard layout:

  * KPI row
  * Module cards row
  * Activity lists.

### Phase 5 – Module Switcher (Complete)

* ✅ Built dynamic Module Switcher component in sidebar
* ✅ Reads `ModuleCatalogue` and `OrganisationModule` from database
* ✅ Visibility logic: Shows only when user has **2+ modules**
* ✅ Layout stable for single-module tenants (switcher control hidden, space reserved)
* ✅ Platform Owner sees switcher in all contexts
* ✅ Active module branding applied dynamically (logo, colors, routes)
* ✅ Tested with single-module (StartupCo) and multi-module (Acme) organizations

### Phase 6 – Modules & Features Manager (In Progress)

**Client Detail View - Complete** ✅
* ✅ Created `/platform/clients/[id]` route for tenant management
* ✅ Built tab-based interface: Overview, Users, Modules, Features, Settings
* ✅ Breadcrumb navigation: Platform Management → Clients → [Tenant Name]
* ✅ Made client table rows fully clickable
* ✅ URL-based tab state: `/platform?tab=clients` enables bookmarkable tabs
* ✅ Permission system: Platform Owners can view any organization
* ✅ Fixed DataTable `onRowClick` to properly pass record data

**Module Access Manager - Complete** ✅
* ✅ Built comprehensive module administration interface
* ✅ Whole row click opens detailed admin modal (removed action icons)
* ✅ Added `featureBundle` field to OrganisationModule schema (BASIC/PRO/ENTERPRISE)
* ✅ Created `toggleForOrganization` tRPC mutation with Platform Owner permissions
* ✅ Audit logging for module enable/disable actions
* ✅ Modal sections:
  - **Module Status & Access**: Enable/disable with visual status badge
  - **Feature Bundle & Pricing**: Bundle selector, payment status, billing cycle
  - **Module-Specific Features**: Feature flags per module (API access, analytics, branding)
  - **Usage & Quotas**: Active users, last used, API calls, capacity tracking
  - **Metadata**: Enabled date, version, history
* ✅ Future-ready for automated constraints and usage enforcement

**Users & Features Tabs - UI Complete** 🟡
* ✅ Users tab: Team member list with roles, status, join dates
* ✅ Platform Owner actions: Impersonate, Edit, Send Email (placeholders)
* ✅ Features tab: Feature flag toggles with descriptions
* ✅ Settings tab: Branding, Quotas, Danger Zone
* 🔄 TODO: Backend mutations for user management
* 🔄 TODO: Connect feature flags to real data
* 🔄 TODO: Settings save functionality

**Next Steps:**
* Implement user action endpoints (impersonate, edit, invite)
* Connect feature flags to PlatformFeatureFlag model
* Add settings save mutations (branding, quotas)
* Build confirmation modals for danger zone actions

### Phase 7 – Tenant Switching & Impersonation

* Tenant picker in platform views.
* Start/stop impersonation flows.
* Context bar and audit logging.

### Phase 8 – Bedrock Integration

* Register Bedrock in catalogue and organisation modules.
* Implement:

  * `/platform/bedrock`
  * `/tenant/[id]/bedrock`
  * `/app/bedrock`
* Add simple dashboard cards for all scopes.

### Phase 9 – QA & Cleanup

* End-to-end tests:

  * Single-module vs multi-module tenants
  * Module switcher behaviour
  * Branding changes per module
  * Tenant switching
  * Impersonation
* Clear old routes and dead code.
* Final documentation updates.

---

## ✅ Success Criteria

* Single-module tenants:

  * Never see IsoStack branding.
  * Never see a module switcher.
  * Experience a clean, module-branded app.

* Multi-module tenants:

  * See a consistent AppShell.
  * Can switch modules from the sidebar.
  * Always see the active module’s branding.

* Platform Owners:

  * Use `/platform` to manage tenants, modules and features.
  * Can safely switch tenant context and impersonate users.

* Technically:

  * All Mantine components use v7.13.2 syntax.
  * Prisma models and migrations are aligned with this spec.
  * tRPC routes expose modules, tenants, features and impersonation cleanly.
  * Tooltips integrate via explicit anchors, not DOM scraping.

---

*End of document — version 2.1.0*

```
```
