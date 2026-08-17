# PLAT-ROLE-04 P1 Tenant Module Persona Recovery Planning

Date: 2026-08-17

Identifier: `CR-Fix-PLAT-ROLE-04`

Status: **IMPLEMENTED AND LOCALLY ACCEPTED — EXACT `250baf12` LIVE ON STAGING WITH GREEN
SCANS AND HEALTH; STAGING HUMAN GATE PENDING**

Source:

[`CR-Fix-PLAT-ROLE-04`](../01-cr-inputs/CR-Fix-2026-08-17-isostack-platform-p1-tenant-module-persona-recovery.md)

Triage:

[`P1 tenant module persona recovery triage`](../02-triage/2026-08-17-isostack-platform-p1-tenant-module-persona-recovery-triage.md)

## 1. Objective

Deliver one trustworthy P1 recovery workflow which can repair or create a tenant user with
complete Core and SeasonPro authority in one operation. Preserve fail-closed runtime
routing and every exact tenant/module boundary.

## 2. Safe Development Boundary

- Branch from recorded exact application commit `328aadf0a360b4c65837327060302ddc525f6168`.
- Prefer a dedicated worktree/branch because the current dev workspace contains unrelated
  user-owned changes and FUND Stage C is externally suspended.
- Do not alter the existing workspace file, Fund code, Stage C runner, credentials, Render
  worker or R2 bucket.
- No staging/live read or mutation is required during implementation.
- Stop after local automated gates and focused human smoke unless the control owner
  separately authorises promotion.

## 3. Workstream A — One P1 Persona Contract

Create or extract a small shared adapter which receives:

- target tenant and active modules;
- Core Organisation authority;
- current exact SeasonPro role IDs and exact Club;
- assignable active exact League and Club roles; and
- current Clubs only.

It must derive a truthful UI state:

```text
OWNER/ADMIN + League role                  C1 League
OWNER/ADMIN + League + Club role + Club    C1 League and C2 Club hat
MEMBER + Club role + Club                  C2 Club
OWNER/ADMIN with no League role            Incomplete — no SeasonPro access
all other composites                       Invalid — cannot save
```

Keep Core authority and SeasonPro persona in separate labelled sections. Never present
`BOTH` as an assignable role or map Owner/Admin alone to C1.

### 3.1 Role-catalogue provisioning preflight

Do not assume bare tenant creation has module roles. Establish and test this lifecycle:

```text
Core tenant created without SeasonPro product
-> no SeasonPro persona required
SeasonPro product assigned
-> ensure exact tenant League and Club defaults
-> assign exact League Admin role to existing Owner(s)
P1 user create/repair
-> verify exact assignable catalogue before accepting a persona
```

The existing product-assignment, League-registration and generic SeasonPro-onboarding paths
already invoke `seedDefaultLmsproRoles`. Preserve that behaviour and add regression evidence
that product assignment cannot complete without an exact League role for its Owner.

For an active SeasonPro tenant with no exact League role or no exact Club role, provide a
P1-only explicit `Provision missing default roles` recovery operation. It must:

- be idempotent and transactional;
- create only a missing standard exact `LEAGUE` and/or exact `CLUB` default;
- never assign or create a standalone `BOTH` persona for this recovery;
- preserve every tenant-authored exact role and component configuration;
- never auto-assign a role to a User during catalogue bootstrap; P1 must select and save
  the intended complete persona explicitly;
- audit created/default role IDs and the acting P1; and
- return the refreshed exact selectors before P1 continues.

Do not mutate the catalogue on page load or hide bootstrap inside a read query. Existing
legacy `League & Club`/`BOTH` rows remain stored but excluded; no migration belongs here.

## 4. Workstream B — Authoritative P1 Client UI

Update the shared `ClientUsersTab` used by both current client-detail routes:

- detect whether the selected tenant has active SeasonPro;
- load roles with P1 tenant override, templates excluded;
- load current Clubs with P1 tenant override;
- show exact League and Club selections plus effective-persona status on edit;
- require a valid complete composite on Save when persona/authority is changed;
- include the same complete composite in Create User;
- prevent Save/Create while role or Club data is loading or invalid;
- show explicit zero-role/current-Club states rather than empty controls;
- offer the explicit P1 catalogue-bootstrap action only when an active SeasonPro tenant is
  missing an exact League or Club default;
- tell P1 that a repaired user's active session will be ended; and
- refresh and reopen from server state after success.

The global Platform Administrators tab remains unchanged.

The older `/platform/orgs/[id]` implementation should either use the shared adapter or be
made clearly subordinate to it. A broad route-removal exercise is not required for this
emergency slice, but two conflicting mutation contracts must not remain.

## 5. Workstream C — Server Update Integrity

Refine `users.platformUpdateUser` so that:

1. only a real P1 actor can call it, with impersonation incapable of broadening target
   scope;
2. the target account is not P1 and belongs to the tenant shown by the operating surface;
3. supplied roles are unique, active, exact, tenant-owned and `lmspro`-owned;
4. supplied Club is exact, current and target-tenant owned;
5. the final role/Club/Core composite is validated before persistence;
6. User update, exact-current-Club junction reconciliation and audit are one transaction;
7. audit records before/after authority, scoped role IDs and Club change without secrets;
8. no write occurs on any invalid or failed composite; and
9. a successful authority/persona/status change invokes target-session revocation.

Do not weaken the existing persona resolver. Decide explicitly in implementation tests how
a name-only edit of a historical incomplete account behaves; the P1 recovery modal should
require a complete persona before an authority/persona Save, while unrelated non-persona
maintenance must not manufacture authority.

## 6. Workstream D — Atomic P1 Creation

Extend `users.createForOrganization` only for the selected tenant's active module contract:

- accept optional exact SeasonPro role IDs and exact Club ID;
- require a complete SeasonPro composite for a new SeasonPro tenant user;
- validate before hashing/token/user persistence where practical;
- commit User, exact Club junction, reset token and audit atomically;
- retain existing Core-only behaviour for non-SeasonPro tenants; and
- return no success if any part fails.

No existing identity may be transferred across tenants. An email already owned by any user
remains a hard conflict.

## 7. Automated Gates

Focused policy/router tests must prove:

- non-P1 callers and impersonated cross-tenant contexts are refused;
- foreign tenant/module, inactive, template, `BOTH` and unscoped roles are refused;
- foreign, historic or non-current Clubs are refused;
- Owner/Admin without League role cannot be newly created or saved as complete;
- Member requires Club role and exact current Club and cannot receive League role;
- Club-only Member creation succeeds without a League role and resolves to C2 only;
- a C1 Club hat preserves League role and requires Club role plus Club;
- hat-swap creation/edit accepts separate exact League and Club roles plus current Club and
  rejects a standalone legacy `BOTH` role;
- P1 bare tenant creation remains valid before product assignment and does not pretend the
  Owner already has SeasonPro access;
- SeasonPro product assignment idempotently creates exact defaults and assigns an exact
  League role to the existing Owner inside its controlled provisioning boundary;
- an active SeasonPro tenant with no exact League/Club default reports unhealthy catalogue,
  and its explicit P1 bootstrap is idempotent, audited and preserves custom roles;
- an existing incomplete Owner can be repaired to a complete C1 composite;
- invalid update/create leaves User, junction, token and audit unchanged;
- exact current-Club junction reconciliation preserves historical-season evidence;
- audit before/after evidence is written in the same transaction;
- session revocation is requested only after successful authority/persona commit;
- non-SeasonPro Core-only create/edit remains unchanged; and
- existing Role Authority, Club Officials, invitation and runtime-scope regressions remain
  green.

Then run full tests, type-check, changed-file lint, repository verification, critical-file
verification and production build.

## 8. Focused Local Human Gate

Use disposable local accounts and controlled test data:

1. As P1, open a SeasonPro tenant through `/platform?tab=clients` and confirm the current
   Client Users editor shows Core authority and SeasonPro persona separately.
2. Open a deliberately incomplete Owner/Admin and confirm it says `Incomplete — no
   SeasonPro access`, not C2.
3. Assign one exact active League role, Save and reopen; confirm Core Owner/Admin and role
   persist.
4. Impersonate or sign in afresh; confirm the repaired user receives C1 League routing and
   the expected configured capability.
5. Where local Redis revocation is configured, confirm the pre-repair session is revoked.
   Otherwise confirm the UI truthfully warns that automatic revocation is unavailable,
   then sign out and back in before checking the repaired authority. Automatic revocation
   itself remains mandatory on staging.
6. Create a disposable replacement Owner/Admin with one exact League role; confirm no
   intermediate unassigned user is visible and reopen is stable.
7. Create a disposable Member with one exact Club role/current Club; confirm C2 routing,
   no League dashboard and that no League role was required or assigned.
8. Add a Club role/current Club to a C1 user; confirm the League role is preserved and hat
   swap works. Confirm the composite contains separate exact League and Club role IDs and
   that no standalone `BOTH` role is selected.
9. Confirm foreign/template/inactive roles and old/foreign Clubs are unavailable; submit
   one direct invalid request and confirm no persistence.
10. Open a non-SeasonPro tenant and confirm its Core-only P1 flow remains unchanged.
11. Confirm the older P1 organisation route, if retained, cannot produce a contradictory
    composite.
12. Confirm every successful recovery/create has an audit event and every failed attempt
    has no partial User, Club-junction or token state.
13. Create a product-neutral Core tenant and confirm no SeasonPro persona is claimed. Assign
    a SeasonPro product and confirm exact League/Club defaults exist and the Owner receives
    an exact League role before SeasonPro access is offered.
14. In a controlled fixture with an active SeasonPro product but missing exact defaults,
    confirm P1 sees an explicit catalogue fault, runs the audited bootstrap once, can run it
    again harmlessly, and can then create both a Club-only C2 and League C1.

Any cross-tenant, partial-write, stale-session, Core/persona confusion or runtime-routing
failure blocks staging.

## 9. Staging And Production Gates

### Staging

After exact dev alignment and a passing Security Scan, promote the exact commit only. Run a
short indicative smoke rather than the full local matrix:

1. P1 sees the incomplete Northgate staging account truthfully.
2. Record its before-state without exposing credentials.
3. Assign the intended existing Northgate League role and save once.
4. Reopen and confirm exact Core/League composite.
5. Fresh authentication or controlled impersonation receives C1 League routing.
6. Confirm target-session revocation and audit evidence.
7. Confirm one disposable invalid cross-tenant/direct request persists nothing.
8. Confirm public health and exact Render commit identity.

### Production

Promotion to main requires explicit staging human acceptance and a passing exact staging
scan. After exact main scan, health and Render identity, production recovery is a separate
controlled operation:

- first inspect whether the affected record actually exists;
- record the exact intended tenant, user and role before-state;
- make one P1 repair only if the control owner explicitly authorises it;
- verify audit, fresh authentication and effective C1 scope; and
- do not run a broad mutation smoke against live tenants.

## 10. Recovery

Code rollback is the exact bounded commit revert. Data rollback uses only the captured
single-user before-state and must still pass the complete persona validator; never restore
an unsafe state merely to match a snapshot.

If staging repair succeeds but promotion is stopped, leave the staging user in the valid
repaired state and record that fact. Resume FUND Stage C only after this CR-Fix is closed or
explicitly re-dispositioned.
