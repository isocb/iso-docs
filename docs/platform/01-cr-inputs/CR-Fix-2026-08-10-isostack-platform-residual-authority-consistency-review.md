# CR-Fix — Residual Authority Consistency Review

Date: 2026-08-10

Roadmap identifier: `PLAT-ROLE-R1`

Owning lane: IsoStack Platform, with a bounded SeasonPro component consumer check

Status: **CAPTURED AND DEFERRED; TRIGGER-BASED ASSURANCE/REMEDIAL REVIEW; NOT PORTFOLIO
NOW OR NEXT; NO IMPLEMENTATION AUTHORISED**

Closed parent project:

[`Core Platform And SeasonPro Role Authority clarification and remediation`](2026-08-04-isostack-core-platform-and-seasonpro-role-authority-clarification-and-remediation-cr.md)

Closure evidence:

[`Role Authority project closure and residual disposition`](../05-review-and-test/2026-08-10-isostack-platform-role-authority-project-closure-and-residual-disposition.md)

## 1. Purpose

Retain exactly two source-confirmed residual authority-consistency concerns after the
successful Role Authority release without treating the obsolete maximum-scope
`PLAT-ROLE-03`, `LMS-ROLE-01` and `LMS-ROLE-02` plans as mandatory delivery.

This is a review trigger and bounded remedial input. It is not evidence of exploitation,
cross-tenant disclosure, a failed production workflow or a current client blocker.

## 2. Exact Review Boundary

### R1 — remaining Core authority writer consistency

Review the reachable Settings Team user-edit path formed by:

- `src/components/team/EditUserModal.tsx`; and
- `src/server/actions/team.ts#updateTeamMember`.

The server action duplicates role/status, last-Owner and audit rules instead of consuming
the delivered `organization-authority` contract. The review must determine whether its
current reachable behaviour preserves non-self change, transactional audit, status safety
and session revocation. If not, create one small correction that routes authority/status
effects through the existing shared contract or removes that capability from this surface.

P1-only `createForOrganization` and `platformUpdateUser` remain in the static inventory but
must not be broadened into this review unless an activation trigger specifically concerns
P1 provisioning. Their existence alone is not authority for a Platform user-management
rewrite.

### R2 — module component-resolution consistency

Review only:

- `src/modules/lmspro/lib/componentResolution.ts#getEffectiveComponents`;
- `src/modules/lmspro/lib/componentResolution.ts#hasComponentAccess`;
- the first component family selected by evidence, if any.

Confirm whether every consumed `ModuleRole` is constrained to the user's tenant, the
requested module and active state, and whether the existing Core Owner/Admin shortcut can
produce a direct server result wider than the explicit assigned-module-role/card result.
If a reachable mismatch is proved, plan the smallest resolver/consumer correction and its
regression matrix. Do not audit every SeasonPro router in this item.

## 3. Explicitly Closed Or Excluded

The following are not outstanding work in this item:

- C1 Owner creation of C1 Owners, Admin Delegates or C2 Members;
- C1 Admin creation of C2 Members;
- C2 same-Club creation of a sibling C2 Member through the Club Officials workflow;
- C1/C2/hat-swap routing and exact-current-Club affiliation;
- the delivered Club Officials view/mutation/read-only contract;
- invitation containment, cross-tenant acceptance refusal and last-active-Owner demotion
  protection;
- a new canonical authority service, schema migration, bulk assignment repair, all-router
  entitlement rewrite, impersonation/RLS redesign or generic C2 user-management feature.

## 4. Activation Triggers

Open the review at the earliest of:

1. a planned change to Settings Team role/status editing, Owner recovery, P1 tenant-user
   provisioning or session-revocation policy;
2. onboarding another module to shared Organisation-authority mutation;
3. relying on a read-only or component-based role to deny an Owner/Admin action in a new
   SeasonPro component family;
4. evidence that cards, copied URLs and direct procedures disagree for the same actor;
5. a security, tenant-isolation, self-change, last-Owner or stale-session finding in either
   exact boundary; or
6. the next deliberate Platform authority/security housekeeping window after Support
   Ticketing and the selected FUND delivery cycle, if none of the earlier triggers fires.

A trigger authorises triage/review only. Implementation still requires a bounded plan and
the ordinary review, human-smoke and promotion gates.

## 5. Risk And Current Disposition

| Risk | Current assessment | Control |
| --- | --- | --- |
| Duplicate Core writer drifts from delivered service | Medium integrity risk; reachable legacy surface exists, but no failed production evidence is recorded | Triggered R1 review before affected workflow expansion |
| Component/server permission differs from visible card | Medium authorization-consistency risk; source concern retained, normal tested personas are green | Triggered R2 review before relying on a new granular/read-only family |
| Review expands into a platform rewrite | High delivery/cognitive-load risk | Two exact source boundaries and explicit exclusions above |
| Deferral becomes forgotten debt | Medium management risk | Authoritative Platform inventory row plus root/printable trigger reference |

Disposition: **deferred and explicitly parked**. Support Ticketing may proceed. The Role
Authority project remains closed unless a new production defect independently reopens it.
