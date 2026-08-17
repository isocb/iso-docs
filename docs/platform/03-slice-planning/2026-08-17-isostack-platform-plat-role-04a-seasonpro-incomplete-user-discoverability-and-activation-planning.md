# PLAT-ROLE-04A SeasonPro Incomplete-User Discoverability And Activation Planning

Date: 2026-08-17

Status: **BOUNDED PLAN ACCEPTED BUT DEFERRED — NO CODE, COMMIT OR PROMOTION AUTHORISED**

Source:

[`CR-Fix-PLAT-ROLE-04A`](../01-cr-inputs/CR-Fix-2026-08-17-isostack-platform-plat-role-04a-seasonpro-incomplete-user-discoverability-and-activation.md)

Triage:

[`PLAT-ROLE-04A triage`](../02-triage/2026-08-17-isostack-platform-plat-role-04a-seasonpro-incomplete-user-discoverability-and-activation-triage.md)

## 1. Server Read Contract

Extend the C1 SeasonPro user read model with a derived persona/access classification using
the shared exact-persona policy:

```text
valid exact C1/C2 composite   ACTIVE module persona
missing/legacy/invalid        NEEDS_REPAIR; no effective module access
```

Return same-tenant incomplete Users regardless of whether they qualify for the League or
Club lists. Preserve raw Core status as a separate field. Never update User or audit state
from the query.

## 2. C1 UI

- Add a `Needs repair` tab/count alongside League and Club users.
- Show contact, raw Core status, stored/unknown roles and Club context.
- Label derived state `SeasonPro access: Deactivated — persona repair required`.
- Open the existing edit modal with unsupported assignments visible for removal.
- Disable module activation until the complete exact persona passes.
- On a same-tenant duplicate create conflict, explain that the existing record may be in
  `Needs repair`; retain a generic conflict for identities outside the tenant.

## 3. Mutation Integrity

- Treat requested SeasonPro activation as a complete-persona operation even when role and
  Club fields are unchanged.
- Apply the same rule to direct and bulk status/action paths.
- Allow an incomplete User to remain fail-closed while being repaired; the final activation
  write must be atomic with role/Club reconciliation and audit.
- Revoke sessions after successful module-authority activation/change and report revocation
  outcome truthfully.

## 4. Tests

Prove:

1. an incomplete same-tenant User is returned and classified `NEEDS_REPAIR`;
2. it appears in neither valid League nor Club population but remains discoverable;
3. list/read performs no write;
4. Core status remains unchanged by derived module state;
5. direct and bulk activation reject incomplete, `BOTH`, foreign, inactive and historic
   composites without partial persistence;
6. a complete repair becomes valid and leaves the repair population;
7. multi-module Core access is not deactivated by SeasonPro incompleteness; and
8. cross-tenant duplicate information is not disclosed.

Then run the normal type, regression, verification, build and focused human gates.

## 5. Human Gate

Create one disposable incomplete same-tenant User. Confirm C1 finds it in `Needs repair`,
cannot activate it incomplete, can repair it with the correct exact persona, and then sees
it in the appropriate League or Club tab. Confirm another module's Core access is unchanged.

## 6. Stop Condition

This plan is registered but deferred. It must be deliberately selected by the root roadmap
before implementation. It does not amend, block or ride with exact PLAT-ROLE-04 staging
promotion, and it does not displace suspended FUND Stage C from `Next`.
