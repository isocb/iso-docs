# PLAT-ROLE-02 Core-Role Mutation Containment Planning

Date: 2026-08-06

Status: **COMPLETE AND DELIVERED THROUGH PRODUCTION AT EXACT `60ac76c1`; PARENT 1–18,
02A/02B, FOCUSED ITEM 7, STAGING 8/8, SECURITY/HEALTH AND PRODUCTION C1/C2 EVIDENCE PASS;
SAME-CLUB C2 SIBLING CREATION/MAGIC-LINK AUTHENTICATION PROVEN; PROJECT CLOSED**

Final disposition:

[`Role Authority project closure and residual disposition`](../05-review-and-test/2026-08-10-isostack-platform-role-authority-project-closure-and-residual-disposition.md)

Accepted triage:

`docs/platform/02-triage/2026-08-06-isostack-core-platform-seasonpro-role-authority-triage.md`

Dependency:

`PLAT-ROLE-01` must confirm the complete static writer boundary. Live-state inventory is not
required to close source-confirmed escalation paths.

`PLAT-ROLE-01` completed that static boundary and added the active invitation-acceptance
route to this plan. The complete 13-item matrix and this bounded implementation were
accepted on 2026-08-06.

Selected containment workflow: a controlled combined transaction. SeasonPro can submit a
separately named `organizationAuthority` request, but the shared Platform-owned authority
service alone validates, persists and audits Organisation authority. Module provisioning
and that controlled authority action either commit together or fail together.

Implementation checkpoint `5e551938` reached the first local human gate but was not
promotable: its first test revealed that both the test and implementation permitted an
invalid Member + League persona. Corrective child `7e453665` applies the complete accepted
persona contract consistently and is the only commit eligible for the replacement gate.

The replacement gate then exposed a separate presentation defect before persistence: the
Owner-only SeasonPro User Type input was selected from a JWT-backed client-session role and
the confirmed Acme Owner received the fixed C2 badge. Bounded corrective child
[`PLAT-ROLE-02A`](2026-08-10-isostack-platform-plat-role-02a-seasonpro-owner-user-type-control-correction-planning.md)
uses the existing server-backed current/effective-user profile, fails closed while it is
unresolved, and has passed its corrected actor/target human gate. The parent matrix resumed,
but item 3 exposed a separate first-component-family `LMS-ROLE-02` candidate: a valid C2
Club user reaches the Club dashboard and Profile but the Officials route still depends on
deprecated `lmsproClubRole` text and masks its refusal as an empty list. Item 4 does not begin
until that finding receives a bounded disposition.

Human testing nevertheless continued through items 4–14 successfully. Item 15 then proved
the higher-risk sibling mutation failure: `clubOfficials.update` replaced a valid Admin's
League-plus-Club role set with only the Club role, bypassed the composite-persona validator
and removed effective SeasonPro access without deleting the Core account. All further
testing stops. The item-3 read defect and item-15 integrity defect require one bounded
Club Officials authority-integrity/repair disposition before this parent can resume.

That disposition is now the accepted urgent-remedial child
[`PLAT-ROLE-02B`](2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity-planning.md).
Its plan fixes item 3 in the same correction as item 15, performs only the evidenced local
fixture repair after technical acceptance, and then requires the complete parent matrix to
restart at item 1 and run through item 18. That complete matrix is now accepted. A bounded
item-7 follow-through removes a stale former current-season Club junction discovered during
an otherwise passing exact-Club edit. Its focused local retest and read-only Derby
exact-junction proof now pass.

## 1. Objective

Remove the confirmed ways in which non-Owner/module procedures can create or assign Core
Owner/Admin authority, while preserving the accepted ability of a C1 Owner to create C1
Admins and additional C1 Owners through a Platform-owned authority contract.

## 2. Containment Contract

### SeasonPro procedures

- remove independent Core-role policy and direct persistence from
  `lmspro.users.create/update`;
- enforce the complete SeasonPro persona atomically: C1 is Owner/Admin + League role; C2 is
  Member + Club role + exact current Club; no Member + League role;
- permit a C1 Owner to request Organisation `ADMIN` or `OWNER` only through the bounded
  Platform-owned same-tenant authority contract selected by the amended plan;
- reject legacy/new callers which continue to submit that field rather than silently
  accepting or ignoring an elevation request;
- retain same-tenant module-role and Club-affiliation management inside its existing
  permissions, subject to later consumer hardening; and
- retain current P1 authority only through explicit Platform procedures, not a hidden
  SeasonPro bypass.

### Shared ordinary invitation

- a Core `ADMIN` may invite only Core `MEMBER`;
- a Core `OWNER` may create/invite `MEMBER`, `ADMIN` or an additional `OWNER`, but only after
  the Platform-owned path enforces same-tenant, self-change, last-Owner, audit and session
  rules;
- the current generic path must not accept `OWNER` merely because its schema accepts every
  enum value; and
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

- rename the business control to `Organisation Authority`; never label it `Platform Role`;
- show it only to an authorised C1 Owner and route the request through the Platform-owned
  contract, not the SeasonPro role payload;
- for other actors, show neutral read-only guidance that Organisation authority is managed
  by the tenant Owner; and
- keep functional SeasonPro role and Club-affiliation controls visibly separate.

## 3. Explicit Non-Goals

- no broad canonical service migration beyond the minimum safe owner workflow required to
  avoid removing accepted C1 Owner capability;
- no wider Owner transfer/recovery redesign;
- no schema, migration or data repair;
- no change to existing user Core roles;
- no redesign of account statuses, impersonation or module route entitlement;
- no broad component/card/read-only alignment;
- no generic C2 access to the League user-management router. The desired same-node creation
  outcome was subsequently delivered through the bounded Club Officials workflow and
  production-proven; no `LMS-ROLE-01` expansion remains required; and
- no automatic module role assignment based on Core role.

## 4. Automated Acceptance

Prove direct procedure calls cannot:

1. let a Member change their own Core role through SeasonPro;
2. let a module-authorised League/Club user change another person's Core role;
3. let Core Admin create or update a Core Owner through SeasonPro;
4. let Core Admin invite Admin or Owner through the ordinary invitation path;
5. let Core Owner create another Owner through an unguarded generic enum path rather than
   the accepted Platform-owned Owner workflow;
6. relink or re-role an existing cross-tenant account during invitation acceptance;
7. persist a partial User or Invitation after a refused request; or
8. bypass exact tenant/module-role/Club validation for the fields still accepted.

Also prove:

- C1 creation produces Owner/Admin plus a League role;
- C2 creation produces Member plus Club-only role and exact current Club;
- Member + League role, Member + `BOTH`, Member + Club role without exact Club, and
  Owner/Admin + Club-only without a League role fail before persistence;
- an authorised C1 Owner can deliberately create an Organisation Admin and additional
  Owner through the accepted Platform-owned path;
- current Owner-only Core `updateRole` behaviour remains unchanged by containment;
- explicit P1 procedures remain separately protected; and
- existing user listing/editing does not demote a Core role merely by saving module fields;
- containment does not broaden C2 creation, role assignment or Club selection while removing
  the unsafe Core-role fields from the shared SeasonPro procedures; and
- the currently working separate-League-role plus separate-Club-role plus exact-Club routing
  state survives create/edit/reopen unchanged; containment does not introduce a standalone
  `BOTH` persona.

Run focused router/UI tests, full tests, type-check, changed lint, verification, production
build, Security Scans and exact staging smoke.

## 5. Human Local And Later Staging Smoke

- create C1 League users and confirm they are Organisation Owner/Admin plus League role;
- create C2 Club users and confirm they are Member plus Club role and exact current Club;
- edit their SeasonPro roles/affiliations and confirm Core authority is unchanged;
- confirm no editable Organisation-authority control appears for a non-Owner in SeasonPro;
- as Core Admin, confirm ordinary Member invitation works and elevated invitation is
  refused;
- as a C1 Owner, confirm deliberate creation of a C1 Admin and an additional C1 Owner uses
  the Platform-owned contract and preserves the intended SeasonPro role/affiliation;
- with an existing known dual-context user, confirm the separate League role, separate Club
  role and exact Club still produce the working League/Club context choice after containment;
- use a copied/direct procedure test account to confirm refused escalation without altering
  a real user; and
- with disposable tenant fixtures only, confirm a cross-tenant existing email cannot be
  moved or re-roled by invitation acceptance.

## 6. Recovery And Stop

Application revert is the rollback. No data rollback should exist. Any requirement to
rewrite live roles, add schema or change P1/impersonation authority stops this slice.

The source-confirmed `canAccessClub` finding was contained inside the implementation because
the same invalid persona otherwise retained League-wide data access. The correction is
bounded to the shared persona/runtime-scope rule; broad access-parity redesign remains out
of scope.
