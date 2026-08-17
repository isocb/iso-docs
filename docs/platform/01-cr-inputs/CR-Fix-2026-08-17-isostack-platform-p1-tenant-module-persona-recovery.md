# CR-Fix — P1 Tenant Module Persona Recovery

Date: 2026-08-17

Identifier: `CR-Fix-PLAT-ROLE-04`

Status: **URGENT REMEDIAL EXPEDITE ACCEPTED — EXACT `250baf12` LIVE AND HUMAN-ACCEPTED ON
STAGING; MAIN AWAITS EXPLICIT AUTHORITY**

Related completed authority project:

[`Core Platform And SeasonPro Role Authority clarification and remediation`](2026-08-04-isostack-core-platform-and-seasonpro-role-authority-clarification-and-remediation-cr.md)

## 1. Trigger

On staging, the valid Northgate Vale Youth Football League account `nvy@isodo.co.uk` has
Organisation authority `OWNER` but no exact SeasonPro League role. The account is therefore
unable to operate as C1 even though its Core authority still says Owner. Equivalent
behaviour is evident on dev; production has not been tested and must not be inferred as a
confirmed affected record.

This is not a conversion of `OWNER` to `MEMBER`. It is an incomplete composite:

```text
Core Organisation authority  OWNER
SeasonPro League role         absent
SeasonPro effective scope     NONE
Observed result               no C1 League capability
```

The runtime denial is correct for an incomplete persona. The recovery defect is that the
authoritative P1 Client > Users editor can change Core authority and tenant membership but
does not expose the tenant's exact module roles or Club context.

## 2. Business Objective

Give P1 a safe, audited recovery path for a tenant whose remaining users cannot administer
SeasonPro. From the authoritative P1 tenant-user surface, P1 must be able to:

- inspect Core authority separately from effective SeasonPro persona;
- assign only active, exact roles owned by that tenant and module;
- assign the exact current Club when a C2 or C1 Club hat requires it;
- repair an existing incomplete account in one validated operation; and
- create a replacement tenant user with a complete initial SeasonPro persona rather than
  persisting an Owner/Admin first and leaving module authority unassigned.

This is an emergency recovery capability, not a general widening of P1 or tenant authority.

## 3. Confirmed Review Evidence

### Current authoritative P1 surface

`ClientUsersTab` is used by both the current inline `/platform?tab=clients` detail and
`/platform/clients/[id]`. Its create/edit modals expose Organisation role, status and
default module, but no SeasonPro role or Club. The UI states that module roles are managed
inside the module.

Its update request omits `lmsproRoleIds` and `lmsproClubId`. Its create request calls
`users.createForOrganization`, which currently accepts no module-persona fields.

### Existing but non-authoritative capability

The older `/platform/orgs/[id]` user surface already loads tenant-scoped active exact
SeasonPro roles and current Clubs, separates League and Club roles and sends the composite
to `users.platformUpdateUser`. This is useful implementation evidence, but an undocumented
duplicate route is not an acceptable operational recovery control.

### Server behaviour

`users.platformUpdateUser` already accepts SeasonPro role IDs and Club ID and rejects
foreign, inactive, template or wrong-module roles. It currently permits a fully unassigned
persona and writes the User before a separate audit write. It does not revoke the target's
session after this P1 mutation.

`users.createForOrganization` creates Core authority without module roles. Consequently,
the incomplete C1 state remains repeatable through P1 creation; it is not only historical
data from the earlier Role Authority work.

The shared SeasonPro persona resolver correctly gives an Owner/Admin without an exact
League role no effective C1 scope. That rule must not be weakened to make an incomplete
record appear authorised.

## 4. Required Behaviour

On a tenant with an active SeasonPro product/module:

1. P1 sees Organisation authority and SeasonPro persona as separate, plainly labelled
   concepts.
2. An existing incomplete account is identified as `Incomplete — no SeasonPro access`, not
   described as C2 or silently treated as a valid Owner.
3. Owner/Admin requires at least one exact active tenant-owned League role.
4. Member requires an exact active tenant-owned Club role and one exact current Club.
5. A C1 Club hat remains optional, but requires both an exact Club role and exact current
   Club while retaining its League role.
6. `BOTH`, template, inactive, unscoped, foreign-tenant and wrong-module roles are not
   assignable and fail closed if requested directly.
7. P1 edit and P1 create validate the final complete composite before any User, Club
   junction, reset-token or audit persistence.
8. Authority/persona changes revoke the target user's active session so the next login
   resolves the repaired state; failure to revoke is visible operationally and must not be
   reported as a full success.
9. A valid Club-only user is supported as Organisation `MEMBER` plus one exact Club role
   and one exact current Club. It requires no League role and receives C2 Club scope only.
10. A valid hat-swap user is supported as Organisation `OWNER` or `ADMIN` plus separate
    exact League and Club roles and one exact current Club. A standalone `BOTH` role is not
    the hat-swap persona.
11. Before P1 creates or repairs a SeasonPro user, the server verifies that the active
    tenant has at least one assignable exact League role and at least one assignable exact
    Club role. A missing catalogue produces an explicit P1 recovery action rather than an
    empty selector or another unassigned account.
12. Non-SeasonPro tenants retain their existing Core-only P1 user flow.

## 4.1 Provisioning Finding

The ordinary active-SeasonPro provisioning paths are substantially safe but the guarantee
belongs to product/module provisioning rather than bare tenant creation:

- public League registration seeds tenant `League Admin` and `Club Secretary` roles and
  assigns `League Admin` to the new Owner;
- generic SeasonPro trial onboarding does the same;
- P1 product assignment calls the same seeder and assigns `League Admin` to every existing
  Organisation Owner; and
- P1 `Create Organisation` creates a product-neutral Core tenant and Owner first. It does
  not seed module roles until a SeasonPro product is assigned, which is valid while the
  tenant has no active SeasonPro product.

Product assignment is transactional, so an active product should not be left halfway
through its role seed by that path. However, historic/imported/partially provisioned data
can still lack an exact role catalogue. The P1 recovery flow must therefore check the
catalogue rather than assume it.

The current default-role seeder also retains a legacy tenant role named `League & Club`
with `BOTH` scope. This row is not the accepted hat-swap model and must remain unavailable
to the P1 selector and direct mutation. Existing rows do not require migration in this
CR-Fix.

## 5. Risk Assessment

| Risk | Severity | Control |
| --- | --- | --- |
| A tenant has no usable C1 administrator | Critical operational availability | P1-only, tenant-scoped recovery of a complete persona |
| Core Owner is mistaken for effective C1 | High authority/truthfulness | Display Core authority and effective module persona separately |
| P1 recreates the same incomplete C1 state | High and currently repeatable | Make SeasonPro-aware P1 creation atomic and complete |
| Cross-tenant or template role assignment | Critical isolation | Resolve roles server-side by target tenant, module, active state and exact scope |
| Stale authenticated session retains old authority | High security/integrity | Revoke target sessions after authority/persona change and require fresh sign-in |
| User/audit/Club state partially persists | High integrity | One transaction with final-persona validation before writes |
| Legacy duplicate P1 routes diverge again | Medium operational | Reuse/extract one P1 persona editor or make both consumers share the same contract |
| Active SeasonPro tenant has no exact League or Club role to select | Critical recovery loop | P1-visible catalogue health check and explicit audited idempotent default-role bootstrap |
| Legacy `BOTH` row is mistaken for hat-swap authority | High authority/routing | Exclude and reject `BOTH`; require separate exact League and Club roles plus current Club |
| Emergency work contaminates FUND Stage C | High delivery/control | Dedicated bounded change, preserve exact `328aadf0`, no unrelated branch or external-resource action |
| Live repair is attempted before release acceptance | Critical | No production mutation; promote through dev/staging and require an explicit live recovery decision |

Security exposure is presently limited by the P1-only mutation boundary, but the recovery
and availability impact is critical because every tenant administrator can become
operationally stranded.

## 6. Immediate Containment

- Do not alter `nvy@isodo.co.uk` in production or assume production contains the same data.
- Do not weaken the runtime rule by treating Core Owner/Admin alone as SeasonPro C1.
- Do not use direct database edits as the operating recovery path.
- Avoid P1 creation of a SeasonPro Owner/Admin until the complete-persona flow is delivered;
  use an existing valid C1 Owner where one exists.
- Preserve the suspended FUND Stage C resource and exact candidate without modification.
- If staging recovery is required before code is promoted, stop and make a separate
  controlled operational decision; the legacy route is evidence, not an approved
  workaround.

### 6.1 Controlled staging operational exception — 2026-08-17

The control owner has identified a critical demo/sales need for one usable staging League
user before the remediation is implemented. The authoritative P1 tenant-user modal has no
module-role input; that absence is the exact defect and means the application UI cannot be
used for this recovery. The older duplicate route is not an approved substitute for the
authoritative operating surface.

The authorised exception is therefore one staging-only direct Neon correction after exact
tenant/user/role read-only checks. It must preserve existing role IDs, add only one verified
active exact tenant `LEAGUE` role, affect one User row, retain explicit manual audit
evidence, record before/after state and require a fresh target-user sign-in. If the current
role IDs resolve to an unexpected tenant, scope, inactive role or missing record, stop and
reassess before mutation.

The current user field is `users."lmsproRoleIds"`, a `text[]` of `module_roles.id` UUIDs.
Neither the role name nor deprecated `users."lmsproLeagueRoles"` is a valid substitute.
No production exception is authorised.

## 7. Explicit Non-Goals

- no automatic last-valid-C1 prevention rule;
- no broad repair, migration or inference across tenants;
- no transfer of an existing account between tenant organisations;
- no role taxonomy, permissions or runtime-routing redesign;
- no migration or reassignment of existing legacy `BOTH` rows;
- no email-address takeover or silent identity reassignment;
- no P1 global Platform Administrator changes;
- no authentication, magic-link, biometric or invitation redesign; and
- no FUND Stage C implementation, credential or external-resource change.

The separate question of preventing a tenant action from removing its final valid C1 is a
follow-on finding, not a condition for this recovery slice.

## 8. Expedite Decision

The control owner accepted this CR-Fix as the single portfolio expedite before further FUND
Stage C execution. The suspended Stage C proof is therefore `Next` at its exact safe
resumption point:
the temporary Render worker remains suspended, no secrets have been injected and the
private R2 bucket remains empty. Acceptance authorised implementation on local dev only;
staging and production remain separately gated. The bounded implementation and local human
smoke now pass. Implementation commit `28aa1ca3` plus bounded application/proof TypeScript
build isolation commit `250baf12` form the exact staging candidate. Dev and staging
Security Scans pass. Render is live at exact `250baf12`, post-deploy health passes and the
indicative staging human gate is 8/8 PASS. Main is unchanged and requires explicit
promotion authority.
