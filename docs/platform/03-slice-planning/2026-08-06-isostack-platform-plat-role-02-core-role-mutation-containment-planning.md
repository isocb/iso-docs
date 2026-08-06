# PLAT-ROLE-02 Core-Role Mutation Containment Planning

Date: 2026-08-06

Status: **CRITICAL CONTAINMENT PLAN PREPARED; NO IMPLEMENTATION AUTHORITY; PRODUCTION REMAINS
UNCHANGED**

Accepted triage:

`docs/platform/02-triage/2026-08-06-isostack-core-platform-seasonpro-role-authority-triage.md`

Dependency:

`PLAT-ROLE-01` must confirm the complete static writer boundary. Live-state inventory is not
required to close source-confirmed escalation paths.

`PLAT-ROLE-01` completed that static boundary and added the active invitation-acceptance
route to this plan. Human matrix acceptance and explicit implementation authority remain
required.

## 1. Objective

Remove the confirmed ways in which non-Owner/module procedures can create or assign Core
Owner/Admin authority, without waiting for the broader shared authority-service redesign.

## 2. Containment Contract

### SeasonPro procedures

- remove Core `role` from `lmspro.users.create` input;
- always create an ordinary SeasonPro user as Core `MEMBER`;
- remove Core `role` from `lmspro.users.update` input and persistence;
- reject legacy/new callers which continue to submit that field rather than silently
  accepting or ignoring an elevation request;
- retain same-tenant module-role and Club-affiliation management inside its existing
  permissions, subject to later consumer hardening; and
- retain current P1 authority only through explicit Platform procedures, not a hidden
  SeasonPro bypass.

### Shared ordinary invitation

- a Core `ADMIN` may invite only Core `MEMBER`;
- an ordinary tenant invitation may not create `OWNER` while the ownership-appointment
  decision remains unresolved;
- a Core `OWNER` may invite `MEMBER` or `ADMIN` under the interim containment matrix; and
- invalid escalation requests fail server-side with `FORBIDDEN` before user/invitation
  persistence.

### Invitation acceptance

- possession of an otherwise valid invitation token must never move an existing User from
  another tenant or replace that User's Core role;
- an email already attached to another tenant fails closed with a neutral conflict/recovery
  outcome and no User/Invitation mutation;
- compatible same-tenant pending completion remains delegated to the later accepted shared
  provisioning contract unless its safe boundary is already explicit; and
- acceptance and invitation state changes must not leave partial persistence.

### SeasonPro UI

- remove the editable `Platform Role` control from the SeasonPro user modal;
- do not send Core role in create/update payloads;
- show neutral read-only guidance that Core tenant authority is managed through the
  authorised organisation/Platform process; and
- keep functional SeasonPro role and Club-affiliation controls visibly separate.

## 3. Explicit Non-Goals

- no canonical shared service yet;
- no new Owner appointment/transfer UI;
- no schema, migration or data repair;
- no change to existing user Core roles;
- no redesign of account statuses, impersonation or module route entitlement;
- no broad component/card/read-only alignment; and
- no automatic module role assignment based on Core role.

## 4. Automated Acceptance

Prove direct procedure calls cannot:

1. let a Member change their own Core role through SeasonPro;
2. let a module-authorised League/Club user change another person's Core role;
3. let Core Admin create or update a Core Owner through SeasonPro;
4. let Core Admin invite Admin or Owner through the ordinary invitation path;
5. let Core Owner use the ordinary invitation path to create Owner;
6. relink or re-role an existing cross-tenant account during invitation acceptance;
7. persist a partial User or Invitation after a refused request; or
8. bypass exact tenant/module-role/Club validation for the fields still accepted.

Also prove:

- SeasonPro create produces Core Member plus the accepted module role/affiliation;
- current Owner-only Core `updateRole` behaviour remains unchanged by containment;
- explicit P1 procedures remain separately protected; and
- existing user listing/editing does not demote a Core role merely by saving module fields.

Run focused router/UI tests, full tests, type-check, changed lint, verification, production
build, Security Scans and exact staging smoke.

## 5. Human Staging Smoke

- create League and Club users and confirm both are Core Members with their intended module
  roles/affiliations;
- edit their SeasonPro roles/affiliations and confirm Core authority is unchanged;
- confirm no editable Core-role control appears in SeasonPro;
- as Core Admin, confirm ordinary Member invitation works and elevated invitation is
  refused;
- as Core Owner, confirm the existing authorised Core role-management surface still works
  only within its current boundary; and
- use a copied/direct procedure test account to confirm refused escalation without altering
  a real user; and
- with disposable tenant fixtures only, confirm a cross-tenant existing email cannot be
  moved or re-roled by invitation acceptance.

## 6. Recovery And Stop

Application revert is the rollback. No data rollback should exist. Any requirement to
rewrite live roles, add schema or change P1/impersonation authority stops this slice.

Before implementation, review whether the source-confirmed `canAccessClub` rule—currently
treating any `lmsproRoleIds` value as League access—requires a separate immediate
data-scope containment slice. Do not silently fold broad access-parity redesign into this
Core-role release.
