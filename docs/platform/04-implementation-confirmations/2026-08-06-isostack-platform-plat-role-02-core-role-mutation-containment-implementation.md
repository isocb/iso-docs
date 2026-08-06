# PLAT-ROLE-02 Core-Role Mutation Containment Implementation

Date: 2026-08-06

Status: **IMPLEMENTED LOCALLY ON `dev` AT `5e551938`; AUTOMATED, BUILD AND SECURITY GATES
PASS; AWAITING LOCAL HUMAN SMOKE; NOT PUSHED OR PROMOTED**

Plan:

[`PLAT-ROLE-02 planning`](../03-slice-planning/2026-08-06-isostack-platform-plat-role-02-core-role-mutation-containment-planning.md)

## 1. Delivered Outcome

The Critical authority paths are contained without changing schema or live data:

- SeasonPro no longer accepts the old generic `role` field. Its strict create/update
  contracts separate `organizationAuthority` from module roles and reject stale callers.
- Ordinary SeasonPro creation produces an Organisation Member. An Organisation Owner may
  deliberately request Admin or additional Owner through the shared Platform-owned
  authority service; Admin may create Member only.
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
  access. Only an active League-scoped role or the retained legacy League assignment grants
  League-wide access; otherwise exact permitted Club context is required.
- The working dual-context contract is unchanged: separate League role + separate Club role
  + exact Club. No standalone `BOTH` persona was introduced.

The combined SeasonPro creation transaction is deliberate. The browser submits a separately
named Organisation Authority request, while the shared Platform service owns validation,
persistence and audit; Organisation and module records cannot partially diverge.

## 2. Principal Implementation Boundary

- `src/server/core/services/organization-authority.ts` — shared bounded create/update policy.
- `src/server/core/services/invitation-acceptance.ts` — fail-closed acceptance resolution.
- `src/server/core/routers/users.router.ts` and `src/server/actions/invitations.ts` — ordinary
  invitation, acceptance, Core update and explicit P1 procedure containment.
- `src/modules/lmspro/routers/users.router.ts` — strict module provisioning consumer and
  exact tenant/module/Club validation.
- `src/modules/lmspro/routers/user-context.router.ts` — `RA-H02` Club-access containment.
- SeasonPro users, Platform organisation users and Team settings UI — accurate separation
  and policy-shaped controls.

No Prisma schema, migration, seed, bulk repair, existing role rewrite, tenant relink or
environment configuration was added.

## 3. Verification Evidence

At exact application commit `5e551938`:

| Gate | Result |
| --- | --- |
| Focused authority policy tests | PASS — 24/24 |
| Full Vitest regression | PASS — 341 passed, 12 skipped |
| TypeScript | PASS |
| Changed production-file ESLint | PASS — zero errors; 16 existing warnings |
| Critical-file verification | PASS |
| Next.js request-body backport verification | PASS |
| Production build | PASS — 131 static pages generated |
| `npm audit --audit-level=moderate` | PASS — zero vulnerabilities |
| Diff checks / pre-commit checks | PASS |

The production build emitted expected local warnings because Upstash is not configured in
the local environment. This is not a deployed-environment finding and no environment claim
is made.

## 4. Retained Boundaries And Risks

- C2 same-node user creation remains fail closed for `LMS-ROLE-01`; this containment does
  not enable it prematurely.
- Wider status/removal/Owner-recovery rules remain `PLAT-ROLE-03` decisions.
- Wider component/read-only consistency and impersonation redesign remain outside this
  slice.
- No existing live assignment has been inspected or repaired.
- Stale clients sending the old `role` field now fail explicitly and must refresh.

Application revert of `5e551938` is the code rollback. No data rollback exists or is needed.

## 5. Current Stop

Stop on local `dev` for the human matrix smoke. Do not push `origin/dev`, promote to staging,
or claim environment completion until the matching review gate is accepted.
