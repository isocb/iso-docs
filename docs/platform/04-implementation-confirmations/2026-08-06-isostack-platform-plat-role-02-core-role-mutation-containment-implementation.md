# PLAT-ROLE-02 Core-Role Mutation Containment Implementation

Date: 2026-08-06

Status: **DELIVERED THROUGH PRODUCTION IN EXACT `60ac76c1`; PARENT 1–18, 02A/02B,
FOCUSED ITEM 7, STAGING 8/8, EXACT-JUNCTION, SECURITY, HEALTH AND PRODUCTION C1/C2
EVIDENCE PASS; SAME-CLUB C2 SIBLING CREATION/MAGIC-LINK AUTHENTICATION PROVEN; PROJECT
CLOSED WITH EXACT RESIDUAL REVIEW PARKED AS `PLAT-ROLE-R1`**

Plan:

[`PLAT-ROLE-02 planning`](../03-slice-planning/2026-08-06-isostack-platform-plat-role-02-core-role-mutation-containment-planning.md)

## 1. Delivered Outcome

The Critical authority paths and the corrected complete SeasonPro persona contract are
contained without changing schema or live data:

- SeasonPro no longer accepts the old generic `role` field. Its strict create/update
  contracts separate `organizationAuthority` from module roles and reject stale callers.
- C1 creation requires Organisation Owner/Admin plus an exact League role. C2 creation
  requires Organisation Member plus an exact Club role and exact current Club. Invalid
  Member + League, Member + `BOTH` and incomplete composites fail before persistence.
- An Organisation Owner may deliberately request C1 Admin, additional C1 Owner or C2 Member
  through the shared Platform-owned authority service; Admin may create C2 Member only.
- Organisation Authority changes are same-tenant, Owner-only, non-self, audited and
  session-revoking. Demotion of the last active Owner is refused.
- Shared invitations enforce Admin-to-Member and Owner-to-Member/Admin/Owner. Refused
  elevation fails before Invitation or pending User persistence.
- Both active invitation-acceptance paths fail closed for cross-tenant, role-mismatched or
  non-pending existing accounts. Same-tenant compatible pending completion and invitation
  acceptance are atomic.
- Elevated invitations require audit evidence produced by the current policy. Older
  elevated invitations must be reissued by an Owner.
- `RA-H02` is contained: a module-role identifier is no longer treated as League-wide Club
  access. Only a valid Owner/Admin + exact active League role grants League-wide access;
  otherwise a valid Member + Club role + exact current Club is required.
- The working dual-context contract is unchanged: separate League role + separate Club role
  + exact Club. No standalone `BOTH` persona was introduced.

The combined SeasonPro creation transaction is deliberate. The browser submits a separately
named Organisation Authority request, while the shared Platform service owns validation,
persistence and audit; Organisation and module records cannot partially diverge.

The first implementation checkpoint, `5e551938`, correctly stopped at its local human gate.
That gate exposed an invalid Member + League acceptance assumption. It was not promoted.
Corrective child `7e453665` preserves the valuable containment and replaces that assumption
with one shared persona policy used by creation, editing, listing, runtime routing and Club
access.

## 2. Principal Implementation Boundary

- `src/server/core/services/organization-authority.ts` — shared bounded create/update policy.
- `src/server/core/services/invitation-acceptance.ts` — fail-closed acceptance resolution.
- `src/server/core/routers/users.router.ts` and `src/server/actions/invitations.ts` — ordinary
  invitation, acceptance, Core update and explicit P1 procedure containment.
- `src/modules/lmspro/lib/seasonpro-persona-policy.ts` — single composite C1/C2/hat-swap
  validation and runtime-scope policy.
- `src/modules/lmspro/routers/users.router.ts` — strict atomic persona provisioning and exact
  tenant/module/Club validation.
- `src/modules/lmspro/routers/user-context.router.ts` and `welcome/page.tsx` — matching
  runtime context and `RA-H02` Club-access containment.
- SeasonPro users, Platform organisation users and Team settings UI — accurate separation
  and policy-shaped controls.

No Prisma schema, migration, seed, bulk repair, existing role rewrite, tenant relink or
environment configuration was added.

## 3. Verification Evidence

At corrected exact application commit `7e453665`:

| Gate | Result |
| --- | --- |
| Focused authority/persona tests | PASS — 34/34 |
| Full Vitest regression | PASS — 351 passed, 12 skipped |
| TypeScript | PASS |
| Changed production-file ESLint | PASS — zero errors; 13 existing warnings |
| Critical-file verification | PASS |
| Next.js request-body backport verification | PASS |
| Production build | PASS — 131 static pages generated |
| `npm audit --audit-level=moderate` | PASS — zero vulnerabilities |
| Diff checks / pre-commit checks | PASS |

The production build emitted expected local warnings because Upstash is not configured in
the local environment. This is not a deployed-environment finding and no environment claim
is made.

## 4. Retained Boundaries And Risks

- C2 same-node delegation is delivered through the bounded Club Officials workflow:
  `clubb@isodo.co.uk` created sibling C2 Member `clubc@isodo.co.uk`, which authenticated by
  magic link. The generic League user-management router need not be opened to C2 actors.
- The delivered operating Owner/status rules close this project. Any later recovery-policy
  expansion activates a fresh review rather than mandatory `PLAT-ROLE-03`.
- Wider component/read-only and legacy Core-writer consistency are outside this delivered
  slice and retained only in trigger-based `PLAT-ROLE-R1`.
- No existing live assignment has been inspected or repaired.
- Stale clients sending the old `role` field now fail explicitly and must refresh.

The delivered Role child is `b1ede26f`, retained in exact release `60ac76c1`. No schema or
migration rollback exists or is needed.

## 5. Final Closure

The bounded
[`PLAT-ROLE-02A` Owner-control human gate](../05-review-and-test/2026-08-10-isostack-platform-plat-role-02a-seasonpro-owner-user-type-control-correction-local-gate.md)
passes. The displaced parent run subsequently discovered the item-3 legacy read/error-mask
defect and item-15 destructive whole-role replacement. The urgent-remedial
[`PLAT-ROLE-02B` plan](../03-slice-planning/2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity-planning.md)
combines both as mandatory acceptance gates. Its separate implementation confirmation now
records the completed local correction, automated gates and exact fixture repair without
changing this parent's original delivered-code evidence.

The complete parent item-1-through-item-18 matrix now passes. Item 7 exposed one adjacent
stale-current-Club junction defect after its stated persona/reopen assertion passed; the
bounded correction, focused edit/reopen and read-only exact Derby junction proof all pass.
The local, staging and production gates are complete. The parent project is closed by
[`Role Authority project closure and residual disposition`](../05-review-and-test/2026-08-10-isostack-platform-role-authority-project-closure-and-residual-disposition.md).
