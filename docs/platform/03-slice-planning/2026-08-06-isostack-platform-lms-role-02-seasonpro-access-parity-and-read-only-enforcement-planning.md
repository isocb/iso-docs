# LMS-ROLE-02 SeasonPro Access Parity And Read-Only Enforcement Planning

Date: 2026-08-06

Status: **SUPERSEDED AS AN AUTOMATIC DELIVERY SLICE; AFFECTED CLUB OFFICIALS FAMILY IS
DELIVERED AND PRODUCTION-PROVEN; BROAD ALL-COMPONENT WORK IS NOT AUTHORISED; EXACT
RESOLVER QUESTION MOVED TO DEFERRED TRIGGER-BASED `PLAT-ROLE-R1`; NOT EXECUTABLE**

Final disposition:

[`Role Authority project closure and residual disposition`](../05-review-and-test/2026-08-10-isostack-platform-role-authority-project-closure-and-residual-disposition.md)

Do not use this conditional plan to initiate a SeasonPro-wide card/router rewrite. Only the
two exact `PLAT-ROLE-R1` resolver boundaries remain available for triggered review.

Accepted triage:

`docs/platform/02-triage/2026-08-06-isostack-core-platform-seasonpro-role-authority-triage.md`

## 1. Objective

Ensure an accepted direct-login authority matrix produces consistent SeasonPro card,
dashboard routing, navigation, read and mutation outcomes, including exact-node C2 isolation
and server-enforced read-only roles.

## 2. Contract

For every component/action pair selected by `PLAT-ROLE-01`:

```text
module entitlement
-> valid tenant membership
-> active module role and component/action grant
-> League/Club scope and affiliation/assignment
-> read-only restriction
-> seasonal visibility
-> independent server read/mutation authority
```

- remove unexplained Core Owner/Admin component bypasses where explicit module-role
  assignment is the accepted contract;
- ensure tenant Owners receive any default module-administrator role explicitly and
  auditably through provisioning, not through a hidden runtime bypass;
- align administration-card visibility with the exact server procedure guard;
- route Owner/Admin users with a League role to C1 presentation, Member users with a Club
  role and exact Club to their C2 node, and Owner/Admin users with separate valid League and
  Club roles plus exact Club to the deliberate context choice, using the same validated
  resolver;
- prove removing the League role, Club role or Club affiliation removes combined routing;
  never treat standalone `BOTH` as the canonical business persona;
- enforce read-only on every selected mutation and not only in the browser;
- preserve copied-URL/direct-procedure refusal and exact Club isolation; and
- distinguish no Product entitlement, no module role and seasonal closure as different
  handled outcomes.

## 3. Evidence Boundary

The inventory must nominate a bounded first set of user-management/role-management
components and procedures. Do not attempt every SeasonPro route in one diff. Each later
component family requires the same matrix and may become a follow-on slice.

Tests cover Owner/Admin with explicit League roles, Member with Club role and exact Club,
hat-swap, Unassigned, read-only, wrong Club, expired seasonal gate, copied URL and direct API.
P1 impersonation equivalence remains governed by `PLAT-REFINE-04`; this slice must not claim
that wider contract complete.

## 4. Stop

Stop for expansion into shared module route entitlement, impersonation/RLS redesign,
schema/migration, live role reassignment or an unbounded all-router rewrite.
