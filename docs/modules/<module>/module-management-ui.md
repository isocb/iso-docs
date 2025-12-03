Below is a **fully-fledged, platform-wide “Dashboard Specification Layer”** for *all* IsoStack modules.
This becomes a **required section** in every module’s functional specification — just like “Data Ingest / Output / Display” is required for Bedrock.

This version is written cleanly, with clear minimum requirements, optional upgrades, and role-based separations.

This **slots directly into** your `/docs/modules/_TEMPLATE/architecture.md` or `/docs/core/module-standards.md`.

---

# **IsoStack Module Dashboard Requirements**

### *(Functional Specification Template — applies to all modules)*

Every IsoStack module must provide **two dashboards**, each serving a distinct audience:

1. **Platform Owner Dashboard**
2. **Tenant (Client Admin) Dashboard**

This ensures consistent control, transparency, and operability across the entire IsoStack ecosystem.

---

# **1. Platform Owner Dashboard (Global / System-Level)**

### **Purpose**

Allows the platform owner to:

* Control how the module integrates with IsoStack at a system level
* Define defaults, constraints, limits, and activation rules
* Manage environment-wide behaviour
* Pre-seed module assets, templates, and tooltips

### **Minimum Required Features (for every module)**

#### **1.1 Module Activation & Availability**

* Toggle module availability for tenants (enable/disable).
* Set activation defaults for new tenants (auto-enabled or opt-in).
* Define licensing constraints (if applicable).
* Set visibility in the main navigation menu.

#### **1.2 Global Settings Panel**

* Default values for module configuration.
* Feature flags (global-level and module-level).
* Standard naming / labels / terminology for UI.
* Default limits (e.g. max projects, max data sources, max exports).
* Default permission profiles.

#### **1.3 Branding & Interface Templates (Inherited)**

* Default dashboard layouts (templates).
* Default help/tooltips (layer: Global).
* Default R2 asset storage paths for module assets.

#### **1.4 Integration Control**

* Connectors allowed for this module (e.g., Knack, Sheets, R2).
* APIKeySafe connector templates.
* System-wide schedules or cron rules (if the module supports automation).
* Module-level webhooks (enabled/disabled + defaults).

#### **1.5 Usage, Billing & Telemetry**

* Module usage metrics per tenant (e.g., # projects, # data sources, CPU/time).
* Error logs / system-level health indicators.
* Billing plans associated with this module (if relevant).
* Aggregated module activity (last 7/30/90 days).

#### **1.6 Ownership & Support**

* Add/edit “support descriptions” or support links for that module.
* Add platform-wide notices (maintenance, warnings).
* Manage default content shown on module’s tenant dashboard.

---

# **2. Tenant Dashboard (Per Tenant / Client Admin)**

### **Purpose**

Gives a client admin visibility and control over *their* use of the module, independent of platform-wide settings.

Every module must implement a **Tenant Module Dashboard**, accessed under:

```
/app/settings/<module>
```

---

## **Minimum Required Features (for every module)**

### **2.1 User & Role Management (Module Scope)**

* View all tenant users with access to this module.
* Assign module-specific roles or permissions (if applicable).
* Set per-user restrictions (e.g., read-only, admin, editor).
* Invite new users (depends on global tenant settings).

### **2.2 Module Settings**

* All tenant-level settings specific to this module:

  * Names, labels, and presentation settings
  * Connectors and credential profiles
  * Limits (max rows, max projects, etc.)
  * Feature toggles (if allowed by platform owner)
  * Notification rules (email/SMS/webhook)

Settings must also show:

* System default values
* Tenant overrides
* Effective values (merged via inheritance)

### **2.3 Integrations & API Keys**

* List available connectors (provided by module + platform).
* Configure API keys via **APIKeySafe**:

  * Add credential profile
  * Make profile default
  * Test profile
* Configure module-specific URLs (e.g., callbacks, endpoints).
* Set custom domains if module supports public URLs.

### **2.4 Imports & Exports**

Depending on module type, provide:

* Import data (CSV, Sheets, API).
* Export data (CSV, JSON, PDF, ZIP).
* Data mapping preview (if relevant).
* History of past imports/exports with timestamps.

### **2.5 Logs & Activity**

* Recent actions for this module only.
* Module-specific audit events:

  * Configuration changes
  * Imports/exports
  * API calls (if via APIKeySafe)
  * User access

### **2.6 Module Overview Page**

A summary screen containing:

* Status indicator (OK / attention / error).
* Quick links to main module workflows.
* Usage summaries:

  * Number of projects / sheets / dashboards
  * Last activity
  * Any integration issues
* Capacity indicators (percent of quota used).

### **2.7 Documentation & Help**

* Contextual help (inherits from Global → App Owner → Tenant).
* Links to:

  * Tutorials
  * Module documentation
  * API docs for this tenant
  * Support contact

---

# **3. Optional Features (module-dependent)**

Modules may include additional dashboard sections where appropriate:

### **3.1 Scheduled Tasks**

* View and edit cron-like automated tasks.
* Trigger manual runs.
* View next-run predictions.

### **3.2 Module Templates**

* Choose from pre-built configurations.
* Duplicate templates.
* Create tenant-specific templates.

### **3.3 Domain Management**

* Add/update custom domains (used for public dashboards or embeds).
* Domain verification workflows.

### **3.4 Embeddable Widgets**

* Generate embed codes.
* Configure widget appearance.

### **3.5 Multi-Project Management**

* Grouping of projects.
* Archive/restore projects.
* Clone project settings to new projects.

---

# **4. Cross-Module Consistency Requirements**

To keep IsoStack modules predictable and usable:

* **Navigation:**
  Every Tenant Dashboard must use the pattern:

  ```
  Overview | Users | Settings | Integrations | Logs | Documentation
  ```

  (Some tabs optional based on module.)

* **Permissions Model:**
  All tenant dashboards use `tenant_user` and module roles for access control.

* **Styling:**
  Mantine 7 + IsoStack design tokens, consistent layout, breadcrumbs, typography.

* **Tooltip Engine:**
  Each dashboard must load tooltips from:

  ```
  Global → App Owner → Tenant
  ```

* **Audit Logging:**
  Every user action on these dashboards must log to `public.audit_log`.

* **Settings Engine:**
  All dashboard configuration must be backed by:

  ```
  <module_schema>.module_settings
  ```

  or equivalent schema structure.

---

# **5. Why This Matters**

This becomes the **contract** for every new module:

* Platform owner controls system-wide defaults, availability, and behaviour.
* Tenants get self-service configuration, reducing support load.
* Modules remain consistent across IsoStack.
* AI assistants (ChatGPT/Copilot) can build new modules quicker with predictable patterns.
* Documentation becomes standardised.
* Bedrock, TailorAid, Emberbox, APIKeySafe, LMSPro etc. all behave predictably to the customer.

---

# **6. One-Paragraph Summary (AI-Optimised)**

> “Every IsoStack module must include two dashboards: a **Platform Owner Dashboard** (module activation, global settings, templates, feature flags, connector availability, telemetry) and a **Tenant Dashboard** (user access, module settings, connectors & API keys, imports/exports, logs, overview). This structure is mandatory across all modules and ensures consistent control, configuration and visibility at both platform and client levels.”

---


