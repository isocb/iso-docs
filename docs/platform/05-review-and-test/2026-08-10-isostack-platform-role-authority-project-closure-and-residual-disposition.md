# Role Authority Project Closure And Residual Disposition

Date: 2026-08-10

Status: **ROLE AUTHORITY PROJECT COMPLETE AND CLOSED; EXACT `60ac76c1` ALIGNED THROUGH
PRODUCTION; LOCAL, STAGING, SECURITY, HEALTH AND PRODUCTION HUMAN EVIDENCE PASS; ONE
DEFERRED TRIGGER-BASED RESIDUAL REVIEW RETAINED AS `PLAT-ROLE-R1`**

Parent CR:

[`Core Platform And SeasonPro Role Authority clarification and remediation`](../01-cr-inputs/2026-08-04-isostack-core-platform-and-seasonpro-role-authority-clarification-and-remediation-cr.md)

Residual input:

[`PLAT-ROLE-R1 residual authority consistency review`](../01-cr-inputs/CR-Fix-2026-08-10-isostack-platform-residual-authority-consistency-review.md)

## 1. Closure Evidence

| Evidence | Result |
| --- | --- |
| `PLAT-ROLE-01` canonical matrix | PASS — 13/13 accepted |
| `PLAT-ROLE-02/02A/02B` local matrix | PASS — complete 1–18 plus focused item 7 |
| Automated regression | PASS — 372 passed, 12 retained skips |
| Build/type/verification | PASS |
| Exact local/remote dev, staging and main | `60ac76c1` |
| Exact dev/staging/main Security Scans | PASS |
| Staging human smoke | PASS — 8/8 plus read-only exact-current-Club junction proof |
| Staging and production health | PASS — HTTP 200, database connected, RLS 11/11 |
| Production Render identity | PASS — control owner confirmed Live at `60ac76c1` |
| Production C1 route/authentication | PASS |
| Production C2 route/Officials/authentication | PASS |
| Same-node C2 creation outcome | PASS — `clubb@isodo.co.uk` created sibling C2 Member `clubc@isodo.co.uk`, which authenticated successfully by magic link |

No schema, migration, seed, bulk repair or environment-contract change was required.

## 2. Delivered Business Outcome

- P1 remains separate from tenant Organisation authority.
- Organisation `OWNER`, `ADMIN` and `MEMBER` remain separate from SeasonPro functional
  roles and C1/C2 routing context.
- Owners can create Owners, Admin Delegates and C2 Members; Admin Delegates can create C2
  Members only.
- C1 requires Owner/Admin plus an exact League role. C2 requires Member plus an exact Club
  role and exact current Club.
- Hat swap derives from separate League and Club roles plus exact Club; `BOTH` is not a
  standalone persona.
- The Club Officials workflow permits a suitably authorised C2 Member to create a sibling
  C2 Member in the same Club. The new user remains Organisation `MEMBER`, receives the
  bounded Club context and can complete authentication.
- Cross-tenant, invalid-role, incomplete-persona, last-active-Owner and unsafe self-change
  cases fail before unauthorized persistence.
- Club Officials reads/mutations enforce exact current Club, exact functional role and
  read-only behaviour server-side while preserving unrelated League roles.

## 3. Superseded Conditional Work

The original `PLAT-ROLE-03`, `LMS-ROLE-01` and `LMS-ROLE-02` documents were deliberately
conditional maximum-scope plans. Delivery through `PLAT-ROLE-02/02A/02B` and its corrective
iterations implemented the required operating outcomes and invalidated their treatment as
automatic next slices.

They are retained as historical planning provenance only. They are **not authorised,
scheduled or required before Support Ticketing or FUND**. Their remaining source concerns
are reduced to the exact `PLAT-ROLE-R1` review boundary; no other residual is kept
cognitively active by this closure.

## 4. Trigger And Reopening Rule

Role Authority is not reopened merely because a historical plan contains broader ideas.
Use the six explicit triggers in `PLAT-ROLE-R1`. A trigger opens review/triage, not automatic
implementation. Any separate production authority defect requires a new bounded `CR-Fix`.

Current portfolio handoff: close Role Authority and begin the formal Support Ticketing
client-readiness triage. FUND remains protected at its recorded boundary until that
self-contained project completes.
