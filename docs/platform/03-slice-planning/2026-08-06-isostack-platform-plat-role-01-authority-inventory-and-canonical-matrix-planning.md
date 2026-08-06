# PLAT-ROLE-01 Authority Inventory And Canonical Matrix Planning

Date: 2026-08-06

Status: **SELECTED AND STATIC READ-ONLY DELIVERY COMPLETE AT APPLICATION `72c02d92`; HUMAN
MATRIX ACCEPTANCE PENDING; OPTIONAL LIVE AGGREGATE INVENTORY NOT AUTHORISED OR RUN**

Accepted triage:

`docs/platform/02-triage/2026-08-06-isostack-core-platform-seasonpro-role-authority-triage.md`

## 1. Objective

Produce the complete evidence and accepted decision matrix required to implement Core and
SeasonPro authority without guessing. Report; do not repair.

## 2. Static Inventory

Inventory and classify every:

- writer of `User.role`, `PlatformAdmin`, account status, module-role arrays and Club
  affiliation;
- create, invite, completion, update, removal, suspension and recovery procedure;
- browser control and payload capable of requesting those changes;
- Core guard, component resolver, direct Core bypass and module/action guard;
- use of C1/C2/C3 or legacy League/Club role fields;
- session refresh/revocation consumer after authority changes;
- real-versus-effective principal consumer relevant to direct login and P1 support; and
- route/card/API mismatch in the SeasonPro user-management and administration boundary.

For each item record actor, target tenant, allowed roles, target fields, audit action,
session effect, failure behaviour and owning future slice.

## 3. Canonical Matrix Output

Produce a human-readable and test-oriented matrix covering at least:

- P1 real actor;
- tenant Owner, Admin and Member;
- limited League Member;
- Club Member with valid affiliation;
- Unassigned user;
- module entitlement present/absent;
- module role active/inactive/missing;
- read-only role;
- direct login and the separately identified impersonation dependency; and
- card visibility, direct navigation, read and mutation outcomes.

The matrix must state which facts grant Core authority, module capability, data scope and
seasonal presentation. It must not use an unqualified C-number as a permission.

## 4. Optional Read-Only Live Inventory

Live-state queries require separate exact-environment/database authority. If authorised,
return aggregate, non-identifying counts only for:

- active Owner/Admin/Member by tenant;
- zero/one/multiple active Owners;
- League module-role users who are Core Members;
- Club-role users who are Core Owner/Admin;
- missing/orphaned/inactive/template role assignments;
- incompatible or missing Club affiliation; and
- P1-created partial accounts with no valid SeasonPro role.

No names, email addresses, raw role IDs or row-level personal evidence enters the lifecycle
record. No update/delete/relink/activation is permitted.

## 5. Evidence And Acceptance

Required output:

1. one writer/consumer inventory evidence record;
2. one accepted business authority matrix;
3. confirmed file/procedure boundary for `PLAT-ROLE-02`;
4. explicit decisions or retained blockers for `PLAT-ROLE-03`;
5. mapping to `PLAT-REFINE-02/03/04` and `LMS-W-USERS-01`; and
6. a finding register which distinguishes confirmed defect, design decision and conditional
   live-data concern.

Review must prove all repository searches are reproducible and no mutation occurred.

Delivery evidence:

`docs/platform/04-implementation-confirmations/2026-08-06-isostack-platform-plat-role-01-static-authority-inventory-and-matrix-delivery.md`

Review/human gate:

`docs/platform/05-review-and-test/2026-08-06-isostack-platform-plat-role-01-review-and-human-matrix-gate.md`

## 6. Stop Boundary

This slice ends with evidence and decisions. It does not edit application code, schema,
configuration or live data and cannot mark any authority defect remediated.
