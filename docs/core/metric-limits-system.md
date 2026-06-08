# Metric Limits System

**Location:** `src/server/core/`  
**Last updated:** June 2026  
**Status:** Schema + UI complete. Resolver map implemented for LMSPro `teams`. All other metrics pending counter wiring.

---

## Overview

The metric limits system lets P1 define measurable resource limits (Teams, Clubs, Projects, etc.) per product tier, with optional bundle add-ons that boost those limits. It replaces all hardcoded "team limit" fields that were specific to LMSPro.

The system has three layers:

```
MetricDefinition      ← The "what": a named, reusable resource type (e.g. "Teams")
    ↓
ModuleMetric          ← "LMSPro tracks: Teams (default), Clubs, League Admins"
    ↓
ProductMetricLimit    ← "LMSPro Pro tier: base 100 Teams, 10 Clubs"  (null row = unlimited)

ProductAddon          ← "League Boost Bundle" (a purchasable add-on)
    ↓
ProductAddonMetric    ← "+25 Teams AND +10 Clubs" (composite boosts, one row per metric)

OrganizationMetricOverride  ← Per-org comped override (replaces base limit for that org)
```

---

## Data Model

### `MetricDefinition` (public schema)
The universe of all countable resource types. Managed by P1 only.

| Field | Type | Notes |
|---|---|---|
| `id` | uuid | PK |
| `slug` | string unique | `teams`, `clubs`, `projects` — used as key in resolver map |
| `singularLabel` | string | `Team` |
| `pluralLabel` | string | `Teams` |
| `description` | string? | Admin-facing description |
| `sortOrder` | int | Display order in tables |

### `ModuleMetric` (public schema)
Assigns a `MetricDefinition` to a module, meaning "this module tracks this resource".

| Field | Type | Notes |
|---|---|---|
| `id` | uuid | PK |
| `moduleId` | FK → `ModuleCatalogue.id` | |
| `metricDefinitionId` | FK → `MetricDefinition.id` | |
| `isDefault` | bool | One per module — the "primary" metric shown in dashboards |
| `sortOrder` | int | Display order within module |

**Unique constraint:** `(moduleId, metricDefinitionId)` — a metric can only be assigned once per module.

### `ProductMetricLimit` (public schema)
Sets a base limit and RAG thresholds for one metric on one product package. **If no row exists for a metric, it is treated as unlimited.**

| Field | Type | Notes |
|---|---|---|
| `packageId` | FK → `ProductPackage.id` | |
| `moduleMetricId` | FK → `ModuleMetric.id` | |
| `baseLimit` | int? | null = unlimited |
| `ragAmber` | int? | % of effective limit where UI goes amber (e.g. 90) |
| `ragRed` | int? | % of effective limit where UI goes red (e.g. 100) |

**Unique constraint:** `(packageId, moduleMetricId)`.

### `ProductAddonMetric` (public schema)
One boost row per metric per bundle. A bundle with two rows boosts two metrics simultaneously.

| Field | Type | Notes |
|---|---|---|
| `addonId` | FK → `ProductAddon.id` | |
| `moduleMetricId` | FK → `ModuleMetric.id` | |
| `unitsPerBundle` | int | e.g. 25 → "+25 Teams per bundle purchased" |

**Unique constraint:** `(addonId, moduleMetricId)`.

### `OrganizationMetricOverride` (public schema)
Comped override for a specific org's product, replacing `baseLimit` for that org only.

| Field | Type | Notes |
|---|---|---|
| `orgProductId` | FK → `OrganizationProduct.id` | |
| `moduleMetricId` | FK → `ModuleMetric.id` | |
| `overrideLimit` | int? | null = comped unlimited |

---

## Seeded Metric Definitions (as of June 2026)

| Slug | Singular | Plural | Assigned to |
|---|---|---|---|
| `teams` | Team | Teams | LMSPro (default) |
| `clubs` | Club | Clubs | LMSPro |
| `league_admins` | League Admin | League Admins | LMSPro |
| `clients` | Client | Clients | Pulse (default) |
| `projects` | Project | Projects | Pulse |
| `admin_users` | Admin User | Admin Users | Pulse |

---

## The "What" vs the "How"

**The What** (fully implemented):
- `MetricDefinition` rows define what is measurable
- `ModuleMetric` rows say which module tracks which metric
- `ProductMetricLimit` rows say the base limit per product tier
- `ProductAddonMetric` rows say how much each bundle boosts each metric
- All of the above are managed via P1 UI in `/platform` → Product Manager tab

**The How** (partially implemented):
- The system needs to **count actual usage** to compare against the limit
- This requires a **counter function** per metric that queries the correct DB table
- Counter functions are registered in `src/server/core/metricCounters.ts`
- Without a counter function, a metric's limit is stored but never enforced

---

## Counter Function Map

**File:** `src/server/core/metricCounters.ts`

The key is `"<moduleSlug>.<metricSlug>"`.

### Current status

| Key | Counter | SQL target | Status |
|---|---|---|---|
| `lmspro.teams` | `countLmsproCurrent Teams` | `lmspro."lmspro_teams"` WHERE `seasonId` is current season AND `status = 'CURRENT'` | ✅ Implemented |
| `lmspro.clubs` | `countLmsproClubs` | `lmspro."lmspro_clubs"` WHERE `seasonId` is current season AND `status != 'WITHDRAWN'` | ✅ Implemented |
| `lmspro.league_admins` | `countLmsproAdmins` | `public."users"` WHERE `organizationId` = org AND `role IN ('ADMIN','OWNER')` | ✅ Implemented |
| `pulse.clients` | `countPulseClients` | `pulse."pulse_organisations"` WHERE `organizationId` = org AND `status = 'ACTIVE'` | ✅ Implemented |
| `pulse.projects` | `countPulseProjects` | `pulse."pulse_projects"` WHERE `organizationId` = org AND `status = 'ACTIVE'` | ✅ Implemented |
| `pulse.admin_users` | `countPulseAdmins` | `public."users"` WHERE `organizationId` = org AND `role IN ('ADMIN','OWNER')` | ✅ Implemented |

> **Note:** `lmspro.league_admins` and `pulse.admin_users` both count from `public.users` — same query, different metric slugs. This is intentional: if a future module has a different definition of "admin user", it can use its own counter.

---

## How Effective Limit Is Calculated

```
effectiveLimit = (overrideLimit ?? baseLimit) + Σ(quantity × unitsPerBundle for all active addons)
```

- If `overrideLimit` exists for this org+metric → use it instead of `baseLimit`
- If `baseLimit` is null and no override → metric is **unlimited** (no enforcement)
- Bundle boosts always add on top, even for comped orgs

### RAG status thresholds

```
usage / effectiveLimit × 100 ≥ ragRed   → RED   (at or over limit)
usage / effectiveLimit × 100 ≥ ragAmber → AMBER (approaching limit)
otherwise                               → GREEN
```

Default fallbacks (used when no explicit values set): Amber = 90%, Red = 100%.

---

## tRPC Procedures

All in `src/server/core/routers/addons.router.ts`.

### P1-only (requireRole OWNER|ADMIN)

| Procedure | Purpose |
|---|---|
| `addons.listMetricDefinitions` | All MetricDefinitions in the universe |
| `addons.createMetricDefinition` | Add a new metric to the universe |
| `addons.listModuleMetrics` | Metrics assigned to a specific module |
| `addons.assignModuleMetric` | Assign a library metric to a module |
| `addons.updateModuleMetric` | Toggle isDefault, update sortOrder |
| `addons.removeModuleMetric` | Remove assignment (does not delete the MetricDefinition) |
| `addons.listProductMetricLimits` | All metrics for a package's modules, merged with existing limits |
| `addons.upsertProductMetricLimit` | Set/update base limit + RAG thresholds |
| `addons.removeProductMetricLimit` | Clear limit (reset to unlimited) |
| `addons.create` | Create addon with `metricBoosts[]` array |
| `addons.update` | Update addon, optionally replace `metricBoosts[]` |
| `addons.setOrgMetricOverride` | Per-org comped override for a specific metric |

### Tenant-facing (protectedProcedure)

| Procedure | Purpose |
|---|---|
| `addons.getTeamLimitStatus` | LMSPro teams limit status with RAG + bundle breakdown |
| `addons.getMetricLimitStatus` | **Generic version** — any module + metric slug |
| `addons.listAvailableForOrg` | Purchasable addons for org's current product |
| `addons.updateOrgBundleQuantity` | Buy/adjust bundles (Stripe-wired) |

---

## How to Add a New Metric (Step-by-Step)

### Step 1 — Define the metric (P1 UI, no code)
1. Go to `/platform` → **Product Manager** tab → scroll to **Metric Library**
2. Click **New Metric**
3. Fill in: slug (e.g. `invoices`), singular (`Invoice`), plural (`Invoices`), optional description
4. Save

### Step 2 — Assign to a module (P1 UI, no code)
1. In the **Module Catalogue** table, click the module row (e.g. Pulse)
2. Open the **Metrics** tab
3. Select the new metric from the dropdown, click **Assign**
4. Toggle **Default** if this is the primary metric for the module

### Step 3 — Add the counter function (code change required)

Edit `src/server/core/metricCounters.ts`:

```typescript
'pulse.invoices': async (prisma, organizationId) => {
  // Count active invoices for this org
  return prisma.pulseInvoice.count({
    where: { organizationId, status: { not: 'DRAFT' } },
  });
},
```

The key MUST be `"<moduleSlug>.<metricSlug>"` exactly as stored in `ModuleCatalogue.slug` and `MetricDefinition.slug`.

### Step 4 — Set limits on products (P1 UI, no code)
1. Go to `/platform` → **Product Manager** tab → click a product row
2. In the product edit modal, open the **Bundles & Limits** tab (`ProductAddonsPanel`)
3. The new metric appears automatically in the **Metric Limits** table (now that it's assigned to a module that product includes)
4. Enter a base limit and RAG thresholds, click **Save**

### Step 5 — Wire enforcement at the point of creation (code change required)

In whatever tRPC mutation creates the resource (e.g. `pulse.createInvoice`), add a guard:

```typescript
import { getMetricLimitStatus } from '@/server/core/metricCounters';

const status = await getMetricLimitStatus(ctx.prisma, orgId, 'pulse', 'invoices');
if (status && status.usage >= status.effectiveLimit) {
  throw new TRPCError({ code: 'FORBIDDEN', message: 'Invoice limit reached for your plan.' });
}
```

---

## Key Files

| File | Purpose |
|---|---|
| `prisma/schema.prisma` | Lines 955–1055: MetricDefinition, ModuleMetric, ProductMetricLimit, ProductAddonMetric, OrganizationMetricOverride |
| `prisma/seed.ts` | Seeds 6 MetricDefinitions + 6 ModuleMetric assignments |
| `src/server/core/metricCounters.ts` | Counter function map — add new metrics here |
| `src/server/core/routers/addons.router.ts` | All CRUD + limit-status tRPC procedures |
| `src/app/(platform)/platform/_components/ModuleCatalogueTab.tsx` | Metric Library section + module Metrics tab |
| `src/app/(platform)/platform/_components/ProductAddonsPanel.tsx` | Product metric limits table + bundle compositor |
| `src/app/(app)/billing/_components/BillingPageClient.tsx` | Tenant-facing limit display + bundle purchase |

---

## What Does NOT Exist Yet

- **`getMetricLimitStatus` generic procedure** — currently only `getTeamLimitStatus` exists (LMSPro teams). A generic version accepting `moduleSlug + metricSlug` is needed for Pulse and future modules.
- **Enforcement gates** in Pulse mutation routers — currently no mutation checks limits before creating a project/client/etc.
- **Usage display in Pulse UI** — no equivalent of the LMSPro team usage bar in the Pulse dashboard.
- **APIKeychain metrics** — `ApiKey` table is in `public` schema (`public.api_keys`), counted by `organizationId`. No MetricDefinition or ModuleMetric assigned yet. Would need: slug `api_keys`, assigned to `apikeychain` module, counter = `prisma.apiKey.count({ where: { organizationId, revokedAt: null } })`.

---

## Design Decisions (recorded for AI context continuity)

1. **"Unlimited until reigned in"** — absence of a `ProductMetricLimit` row means unlimited. Never enforce a zero-limit by default.
2. **Metrics are module-scoped** — `MetricDefinition` is a shared library but the `ModuleMetric` join is the authoritative "this module tracks this". Products inherit metrics via their included modules.
3. **Bundles are composite** — a single `ProductAddon` can boost multiple metrics simultaneously via multiple `ProductAddonMetric` rows. The UI shows all boosts as teal badges.
4. **Override replaces base, not adds** — `OrganizationMetricOverride.overrideLimit` replaces `baseLimit` entirely for comped orgs. Bundle boosts still stack on top.
5. **Counter key format** — `"<moduleSlug>.<metricSlug>"` not `metricDefinitionId`. This makes the map readable and survives database reseeds.
6. **The counter is not stored** — current usage is computed live on each `getMetricLimitStatus` call. No caching. For high-traffic orgs, consider Redis caching with short TTL.
