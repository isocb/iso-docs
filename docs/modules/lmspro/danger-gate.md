# Danger Gate

**Status:** Planned  
**Module:** LMSPro  
**Author:** IsoStack  
**Date:** June 2026  

---

## Background: The IsoStack Role Model

IsoStack uses a two-tier customer model:

- **C1** — the top-level customer account (e.g. a football league). This is the organisation itself.
- **C2** — the users *within* that organisation (e.g. club secretaries, referees, committee members).

Within both C1 and C2 there are people with very different responsibilities and capabilities. The role system is designed to provide **infinite granularity**: a C1 user might be the league owner but have no need to touch seasons or bulk-process clubs — so the system can be trimmed to give them only the capabilities they actually need, and nothing more. This is not primarily a security model; it is a **safety net** that prevents accidents by ensuring people only see and can trigger the actions relevant to their role.

The **Danger Gate** sits within this model as a coarse-grained guard over the most destructive operations. Rather than a long list of individual permission flags, a single `danger-gate` component key acts as a master switch: either a role is trusted to perform destructive actions, or it is not.

---

## Overview

The **Danger Gate** is a capability flag that can be toggled on or off per role in the LMSPro Role Manager. When a role does **not** have the Danger Gate capability, any UI elements and server-side operations that are classified as "dangerous" are hidden or blocked for users assigned to that role.

The goal is to prevent a league user from accidentally performing destructive actions (deleting seasons, mass-processing clubs, etc.) — not as a security enforcement layer, but as a safety net for day-to-day operations. A dedicated admin with the Danger Gate granted can still perform these actions.

---

## Architecture

### Why `componentKeys` is the right hook

`ModuleRole` already has a `componentKeys String[]` field. This array holds strings that identify UI capabilities granted to a role. The Danger Gate is implemented as a **single reserved component key**: `danger-gate`.

- A role with `componentKeys` containing `"danger-gate"` → user sees dangerous controls
- A role without `"danger-gate"` → dangerous controls are hidden (UI) and blocked (server)

This means:
- **No schema migration required** — uses the existing `componentKeys` column
- **Consistent with the existing component resolution system** in `componentResolution.ts`
- **Extensible** — future items are just string constants added to the `DANGER_GATE_KEYS` enum, not schema changes

---

## Danger Gate Items (Initial Set)

| Key | Feature | Location |
|-----|---------|----------|
| `danger-gate` | Master toggle (grants all below) | Role Manager |

The master `danger-gate` key controls all of the following dangerous operations. In future, individual sub-keys could be used for finer control (see Future Extensibility).

**Initially gated operations:**

> The gate applies to all users **except** P1 (platformAdmin) and the org `OWNER`. A C1 `ADMIN` user is gated by their module role just like a `MEMBER` unless their role has `danger-gate` in `componentKeys`.

| # | Operation | Page / Component |
|---|-----------|-----------------|
| 1 | Clone Season | Seasons page — "Clone Season" button |
| 2 | Delete archived season | Seasons page — delete within archived seasons |
| 3 | Delete any season (active/current) | Seasons page — delete within season view |
| 4 | Edit league users | Admin → Users — edit/role change actions |
| 5 | Bulk process clubs/teams | Admin → Clubs/Teams — bulk action controls |
| 6 | Delete league | Admin → League Settings — delete league |
| 7 | Delete age groups | Admin → Age Groups — delete age group |
| 8 | Manage roles | Admin → Roles — create/edit/delete roles |

---

## Implementation Plan

### Phase 1: Hook — `useDangerGate()` (30 min)

Create `src/modules/lmspro/hooks/useDangerGate.ts`:

```typescript
/**
 * Returns true if the current user's assigned roles include the danger-gate key.
 * Platform admins and org OWNER/ADMIN always bypass the gate.
 */
export function useDangerGate(): boolean
```

Logic:
1. Read `session.user.platformAdmin` — if `true` (P1), return `true` immediately (always bypass)
2. Read `session.user.role` — if `OWNER`, return `true` immediately (an org may have several OWNER accounts — all bypass)
3. **`ADMIN` (C1 league admin) is NOT an automatic bypass** — they are subject to their module role configuration
4. Fetch the user's assigned `ModuleRole` records via `lmsproRoleIds`
5. Check if any assigned `ModuleRole` has `componentKeys` containing `"danger-gate"`
6. Return `true` if found, `false` otherwise

> **Important distinction:** The `Role` enum (`OWNER`/`ADMIN`/`MEMBER`) is the app-level access tier, not the module permission layer. A C1 user with `ADMIN` app access can still have a module role that does NOT include the Danger Gate — in which case the gate applies to them exactly as it would a `MEMBER`. The bypass applies to any user with `OWNER` role (there may be several per org) and platform admins (P1).

---

### Phase 2: `<DangerGate>` Component (20 min)

Create `src/modules/lmspro/components/DangerGate.tsx`:

```tsx
interface DangerGateProps {
  children: React.ReactNode;
  fallback?: React.ReactNode; // Optional: show something else instead (e.g. disabled tooltip)
}

export function DangerGate({ children, fallback = null }: DangerGateProps) {
  const hasDangerGate = useDangerGate();
  if (!hasDangerGate) return <>{fallback}</>;
  return <>{children}</>;
}
```

Usage pattern in any component:
```tsx
<DangerGate>
  <Button color="red" onClick={handleDeleteSeason}>Delete Season</Button>
</DangerGate>

// Or with a disabled tooltip as fallback:
<DangerGate fallback={
  <Tooltip label="Your role does not permit this action">
    <Button color="red" disabled>Delete Season</Button>
  </Tooltip>
}>
  <Button color="red" onClick={handleDeleteSeason}>Delete Season</Button>
</DangerGate>
```

---

### Phase 3: Server-Side Guard (30 min)

Add a `requireDangerGate` helper in `src/modules/lmspro/lib/roles.ts`:

```typescript
/**
 * Throws FORBIDDEN if the user does not have the danger-gate component key.
 * Bypassed automatically for OWNER/ADMIN (Tier 1) and platform admins.
 */
export async function requireDangerGate(ctx: Context): Promise<void>
```

Apply to all tRPC mutations covering the gated operations listed above. This is the **enforcement layer** — the UI hides the controls, the server refuses the request.

---

### Phase 4: Role Manager UI Toggle (30 min)

In `src/app/(app)/app/lmspro/admin/roles/page.tsx`, add to the role edit modal:

```tsx
<Divider label="Danger Gate" labelPosition="left" />
<Switch
  label="Grant Danger Gate"
  description="Allows users with this role to perform destructive operations: delete seasons, clone season, bulk process clubs, manage roles, delete age groups."
  checked={formData.componentKeys.includes('danger-gate')}
  onChange={(e) => {
    const keys = formData.componentKeys.filter(k => k !== 'danger-gate');
    if (e.currentTarget.checked) keys.push('danger-gate');
    setFormData({ ...formData, componentKeys: keys });
  }}
  color="red"
/>
```

The red colour signals the elevated nature of this toggle.

---

### Phase 5: Wire `<DangerGate>` into Dangerous Actions (45 min)

Wrap each of the 8 gated operations in `<DangerGate>`. Each is a targeted 1-3 line change per file:

| File | Change |
|------|--------|
| `seasons/page.tsx` | Wrap Clone Season button |
| `seasons/page.tsx` | Wrap Delete Season button (active) |
| `seasons/page.tsx` | Wrap Delete Season button (archived) |
| `admin/users/page.tsx` | Wrap edit user / role change controls |
| `admin/clubs/page.tsx` | Wrap bulk action toolbar |
| `admin/teams/page.tsx` | Wrap bulk action toolbar |
| League settings page | Wrap delete league control |
| `admin/age-groups/page.tsx` | Wrap delete age group control |
| `admin/roles/page.tsx` | Wrap create/delete role controls |

---

## Data Flow Summary

```
User logs in
  → session.user.lmsproRoleIds = ['uuid-role-a', 'uuid-role-b']
  
useDangerGate()
  → if platformAdmin → return true (P1 bypass)
  → if role === OWNER → return true (org owner bypass — multiple allowed)
  → fetch ModuleRole records for role IDs
  → check any .componentKeys.includes('danger-gate')
  → return true/false

<DangerGate>
  → renders children if true
  → renders fallback (or nothing) if false

tRPC mutation (server)
  → requireDangerGate(ctx)
  → same logic, throws FORBIDDEN if not granted
```

---

## Future Extensibility

To add a new feature to the Danger Gate:

1. Add the constant to `DANGER_GATE_KEYS` enum in `src/modules/lmspro/lib/danger-gate.ts`
2. Wrap the UI element in `<DangerGate>`
3. Add `requireDangerGate(ctx)` to the corresponding tRPC mutation

**No schema migration, no role manager UI changes required.**

If finer-grained control is ever needed (e.g. "can clone seasons but not delete them"), individual sub-keys like `"danger-gate:clone-season"` can be introduced alongside the master `"danger-gate"` key, and `useDangerGate(key?)` can accept an optional specific key.

---

## What Danger Gate Does NOT Control

- **Authentication** — handled by NextAuth session
- **Tier 1 role enforcement** (OWNER/ADMIN/MEMBER) — handled by `requireRole()` in tRPC
- **Multi-tenancy scoping** — all queries remain `organizationId`-scoped regardless

The Danger Gate is a **UX safety net for trusted league users**, not a security boundary.

## Role Naming Clarification

| Platform Term | Prisma `Role` | Danger Gate behaviour |
|---|---|---|
| P1 (IsoStack/platform admin) | `OWNER` + `platformAdmin: true` | Always bypasses |
| C1 org owner(s) | `OWNER` | Always bypasses (org may have multiple OWNER accounts) |
| C1 league admin | `ADMIN` | **Gated by module role** |
| C2 club user | `MEMBER` | Gated by module role |

This distinction matters: a league may have several `ADMIN` users (C1), some of whom should have the Danger Gate and some who should not. The gate is controlled entirely by the module role's `componentKeys`, not by the app-level `Role` enum (except for `OWNER`).

---

## Rollout Suggestion

1. Implement Phases 1–4 first (hook, component, server guard, role manager toggle) — no visible change to users yet
2. Seed the default "League Admin" role with `danger-gate` included — no regression
3. Roll out Phase 5 one operation at a time, testing each
4. Once stable, the Platform Admin can grant/revoke the Danger Gate per-role via the Role Manager in each league's settings
