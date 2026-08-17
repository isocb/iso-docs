# CR-Fix — SeasonPro Incomplete-User Discoverability And Activation

Date: 2026-08-17

Identifier: `CR-Fix-PLAT-ROLE-04A`

Status: **EXACT `fcd162db` LIVE ON STAGING; DEV/STAGING TECHNICAL GATES PASS — MINIMUM
STAGING HUMAN SMOKE PENDING**

Parent:

[`CR-Fix-PLAT-ROLE-04`](CR-Fix-2026-08-17-isostack-platform-p1-tenant-module-persona-recovery.md)

## 1. Finding

The C1 SeasonPro user query returns every User in the tenant, including a User whose exact
module persona is incomplete. The UI then constructs only League and Club lists from valid
effective scope. A User whose effective scope is `NONE` appears in neither list.

That fail-closed routing is correct, but the omission creates an operational trap: C1 may
attempt to create the same email again and receive the correct duplicate conflict without
being able to find and repair the existing same-tenant record.

A second gap exists in status-only and bulk activation paths: selecting Core `ACTIVE` does
not itself require a complete SeasonPro persona.

## 2. Accepted Objective

- Keep incomplete same-tenant Users visible to authorised C1 managers.
- Present them as `SeasonPro access: Deactivated — persona repair required` in a dedicated
  repair view.
- Keep Core account status visibly separate from derived module-access state.
- Require the existing complete C1/C2 persona gate before SeasonPro access can become
  active.
- Make duplicate-conflict guidance direct C1 to the existing repair record without
  disclosing cross-tenant identity information.

## 3. Important Boundary

`User.status` is Core-wide. Automatically persisting `DEACTIVATED` merely because one
module persona is incomplete could incorrectly remove access to another active module.
Therefore this correction must model a derived SeasonPro access state and must never write
from a read/list query.

## 4. Risk

| Risk | Control |
| --- | --- |
| Existing User remains undiscoverable and is repeatedly re-entered | Dedicated C1 repair inventory containing same-tenant incomplete personas |
| Core and module deactivation become conflated | Separate labels and derived module state; no read-time write |
| Direct/bulk activation bypasses persona policy | Server validates the final exact persona whenever module activation is requested |
| Cross-tenant email existence is leaked | Generic duplicate response outside the actor's tenant; repair navigation only for visible same-tenant records |
| Accepted PLAT-ROLE-04 release changes after smoke | 04A remains a separate later commit and is excluded from the current staging candidate |

## 5. Non-Goals

- no automatic role inference or repair;
- no mutation during list/read;
- no bulk historic-data migration;
- no change to Core authentication status semantics;
- no weakening of fail-closed runtime routing; and
- no FUND, deployment or PLAT-ROLE-04 release change.
