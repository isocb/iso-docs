
title: APIKeyChain – Dashboard Specification
description: Platform Owner and Tenant dashboard requirements for the APIKeyChain module
status: draft
version: 0.1.0
---

# APIKeyChain – Dashboard Specification

APIKeyChain is the IsoStack module that provides **secure, multi-tenant management of API keys and connector profiles**, plus a **proxy layer** to call third-party APIs without exposing secrets to client-side code or low-code tools.

Every environment must expose two distinct dashboards:

1. **Platform Owner Dashboard** – global control of APIKeyChain behaviour across IsoStack.
2. **Tenant (Client Admin) Dashboard** – per-tenant control over their connectors, keys and usage.

These dashboards follow the standard IsoStack module pattern, but with behaviours and fields specific to secure key management and API proxying.

---

# 1. Platform Owner Dashboard (Global / System-Level)

## 1.1 Purpose

The Platform Owner Dashboard for APIKeyChain controls:

- How APIKeyChain is **enabled, configured and constrained** across the platform.
- Which **connector types** are available to tenants.
- Global **security policies**, **rate limits** and **audit visibility**.
- Default **templates** and **help content** for tenant dashboards.

This dashboard is **not visible** to tenants. It is only accessible to platform-level roles.

---

## 1.2 Minimum Required Features

### 1.2.1 Module Activation & Tenant Access

The platform owner must be able to:

- Enable/disable APIKeyChain globally.
- Enable/disable APIKeyChain **per tenant**.
- Set defaults for new tenants:
  - Auto-enabled
  - Disabled by default (opt-in)
- Control whether a tenant can:
  - Create connectors
  - Use platform-defined connector templates only
  - Create custom connectors (yes/no)

### 1.2.2 Global Connector Templates

The platform owner can define and manage **connector templates**, which tenants then instantiate:

Each template includes:

- Name and type (e.g. `Knack`, `Google Sheets`, `Mailchimp`, `Generic HTTP`).
- Base URL.
- Required header/query fields (without values).
- Allowed HTTP methods.
- Default timeouts and retry policies.
- A short description and usage notes.

Functions:

- Create, update, delete templates.
- Mark templates as:
  - **Global** (visible to all tenants).
  - **Restricted** (visible only to specified tenants).
- Control which templates are visible in each tenant’s APIKeyChain dashboard.

### 1.2.3 Global Security & Policy

The platform owner defines platform-wide security posture for APIKeyChain:

- Encryption policy (use IsoStack standard; view status only).
- Secret rotation recommendations (e.g. 90 days).
- Global rate limits per tenant and per connector type.
- IP allowlisting/denylisting options for external proxy endpoints.
- Policy on external usage:
  - Internal use only (IsoStack modules)
  - Internal + external (e.g. Knack/Squarespace allowed)

These policies act as **upper bounds** or defaults; tenants cannot weaken them.

### 1.2.4 Monitoring, Usage & Billing Signals

Minimum surface:

- Per-tenant metrics:
  - Number of connectors.
  - Number of credential profiles.
  - API call volume (per day/week/month).
  - Error rates (4xx/5xx).
- Top connector types by usage (e.g. Knack, Sheets).
- Global health indicator for APIKeyChain (OK / degraded / failing).
- Optional: billable usage indicators (e.g. calls/month vs plan).

### 1.2.5 Global Documentation & Help

The platform owner can:

- Define global help text, FAQs and warnings for APIKeyChain.
- Seed default **tooltips** for APIKeyChain fields (Global tooltip layer).
- Link to platform documentation, legal terms (e.g. data protection, key handling).

These are inherited down into tenant dashboards (Global → App Owner → Tenant).

---

# 2. Tenant Dashboard (Client Admin Level)

## 2.1 Purpose

The Tenant Dashboard for APIKeyChain allows a client admin to:

- Manage **their own connectors and keys**, within policy constraints set by the platform owner.
- See **who** is using which keys and **how**.
- Configure **module-level settings** and integration points for their systems (e.g. Bedrock, Knack, Squarespace, internal apps).

Accessible only to tenant admins / module admins.

Route pattern:

`/app/settings/apikeychain`

---

## 2.2 Layout

Standard IsoStack pattern:

- **Overview**
- **Connectors**
- **Credential Profiles**
- **Usage & Logs**
- **Integrations**
- **Documentation & Help**

Not every tab has to be a separate page in v1, but these concepts must exist in the UX.

---

## 2.3 Minimum Required Features

### 2.3.1 Overview

A summary card-style view with:

- Status of APIKeyChain for this tenant (Active / Inactive / Limited).
- Number of active connectors and profiles.
- Call volume (last 7/30 days).
- Recent errors or warnings (e.g. “Knack connector failing: invalid key”).
- Quick links:
  - “Add connector”
  - “View logs”
  - “Manage keys”
  - “How to integrate with Bedrock”

### 2.3.2 Connectors

Tenant admins can:

- View a list of connectors available in their tenant:
  - Connectors created from **platform templates**.
  - Any tenant-specific custom connectors (if allowed).
- See per-connector:
  - Name, type.
  - Base URL.
  - Number of credential profiles.
  - Status (Configured / Needs attention / Disabled).
- Create a new connector (within platform rules):
  - Choose a template or “generic HTTP” (if permitted).
  - Set connector-level metadata (names, usage notes).
- Edit or archive connectors (where not locked by platform policy).

Connectors represent **logical services**, not the secrets themselves.

### 2.3.3 Credential Profiles (Keys & Secrets)

Tenant admins manage **credential profiles** for each connector.

For each profile:

- Display:
  - Profile display name (e.g. “Knack – Production”, “Brevo – Sandbox”).
  - Environment label (production/sandbox).
  - Last tested timestamp.
  - Status (OK / failing / untested).
- Actions:
  - Add a profile: supply secret values (API keys, app IDs, etc.).
  - Mark as default profile for that connector.
  - Test credentials (calls `test` endpoint via proxy).
  - Rotate or revoke keys.
  - Archive or delete profile (subject to policies).

Secrets must **never be shown in clear text** after initial entry. UI shows only partial IDs or masked values where needed.

### 2.3.4 Usage & Logs

Tenant admins can see a **module-scoped activity log**:

- API calls made via APIKeyChain for this tenant:
  - Time.
  - Connector name.
  - Status code.
  - Source (Bedrock, TailorAid, external HTTP, etc.).
- Filters:
  - By connector.
  - By status (error vs success).
  - By date range.

They can also see:

- Aggregate metrics (calls/day, error rate).
- Flags for potential issues:
  - Repeated authentication failures.
  - High error rates.
  - Approaching rate limit.

### 2.3.5 Integrations

This section shows **where APIKeyChain is being used** in the tenant’s IsoStack environment:

- List of IsoStack modules hooked into APIKeyChain:
  - Bedrock (e.g. “Project X uses connector: Knack – Production”).
  - TailorAid (if applicable).
  - Other custom apps.
- For each integration:
  - Linked connector and profile.
  - Status (configured / missing profile / failing).
  - Shortcut to edit connector/profile.

If external HTTP usage is allowed:

- Provide:
  - Base proxy URL(s) for this tenant.
  - Documentation on how to call the proxy from external systems.
  - Optional signing tokens or requirements (configured at tenant level, constrained by platform policy).

### 2.3.6 Settings

Tenant-wide module settings for APIKeyChain, within platform constraints:

- Who can:
  - Create connectors.
  - Create credential profiles.
  - View usage logs.
- Notification rules:
  - Email alerts on repeated failures.
  - Alerts on key expiration (if supported).
  - Alerts when usage exceeds a threshold.
- Defaults:
  - Default environment (production vs sandbox).
  - Default timeout/retry policy (subject to global max/min).
- Optional:
  - Allow external usage (if globally enabled, tenant can opt in/out).

---

## 2.4 Documentation & Help

Every tenant dashboard must offer:

- Plain-language explanation of what APIKeyChain does.
- Examples:
  - “How to connect Knack to Bedrock via APIKeyChain”.
  - “How to rotate an API key safely”.
- Links to:
  - Tenant-specific API documentation (proxy endpoints etc.).
  - Platform documentation pages.

Tooltip hierarchy applies:

- Global → App Owner → Tenant.

---

# 3. Optional / Future Enhancements

For APIKeyChain specifically, the following features are optional but desirable:

### 3.1 Key Lifecycle Management

- Mark keys with expiry dates.
- Dashboard highlighting keys nearing expiry.
- Suggested rotation workflow (create new profile → switch default → revoke old).

### 3.2 Anomaly Detection

- Simple heuristics for suspicious usage:
  - Sudden spike in call volume.
  - Access from unknown source (if tracked).
- Alerts in the Tenant dashboard and optionally at Platform level.

### 3.3 Templates & Recipes

- Pre-built integration recipes:
  - “Use Knack with Bedrock”.
  - “Use Sheets with Bedrock”.
- One-click setup flows leveraging connector templates.

---

# 4. Cross-Module Consistency

APIKeyChain dashboards must still obey the general IsoStack dashboard rules:

- Navigation follows:
  `Overview | Users (if applicable) | Settings | Integrations | Logs | Documentation`
- All configuration backed by:
  `apikeychain.module_settings` (or equivalent module settings tables).
- All actions audit-logged to `public.audit_log`.
- Mantine 7 visual language and standard layout.
- Permissions based on `tenant_user` and module-specific roles.

---

# 5. One-Paragraph Summary (AI-Ready)

> “APIKeyChain must provide a **Platform Owner Dashboard** to control module activation, connector templates, global security policies and usage telemetry, and a **Tenant Dashboard** where client admins manage their own connectors, credential profiles (keys), usage logs, integrations with modules like Bedrock, and module-level settings (notifications, defaults, external access). Secrets are never exposed in clear text; everything is tenant-scoped, policy-constrained and fully audit-logged.”

---

# End of Document
```

