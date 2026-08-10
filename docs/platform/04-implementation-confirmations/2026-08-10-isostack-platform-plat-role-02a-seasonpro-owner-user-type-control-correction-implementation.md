# PLAT-ROLE-02A SeasonPro Owner User-Type Control Correction Implementation

Date: 2026-08-10

Status: **IMPLEMENTED, ACCEPTED AND DELIVERED THROUGH PRODUCTION IN EXACT `60ac76c1`;
COMPLETE PARENT LOCAL/STAGING/PRODUCTION GATES PASS; CLOSED**

Plan:

[`PLAT-ROLE-02A planning`](../03-slice-planning/2026-08-10-isostack-platform-plat-role-02a-seasonpro-owner-user-type-control-correction-planning.md)

## 1. Delivered Outcome

- SeasonPro User Management now obtains the acting user's Organisation authority and
  identifier from the existing server-backed `users.getProfile` query.
- The Owner-only user-type input no longer depends on `useSession().user.role`.
- A confirmed Owner receives the editable C1 Owner/C1 Admin/C2 Member input.
- Admin and Member remain on the fixed C2 Member presentation.
- Loading or missing profile authority is a separate unavailable state, not an implicit
  non-Owner state. **Create User** remains disabled and the handler fails closed.
- The self-authority-edit guard uses the same authoritative profile identifier.
- Explanatory copy now states that an Owner may create C1 users and C2 Members.
- A focused pure presentation-policy test covers Owner, Admin, Member, loading and missing
  authority.

The existing server-side Organisation-authority service, mutation policy, persona
validation, database schema and stored account data are unchanged.

## 2. Changed Application Boundary

- `src/app/(app)/app/lmspro/admin/users/page.tsx`;
- `src/modules/lmspro/lib/seasonpro-user-type-control.ts`; and
- `src/modules/lmspro/lib/seasonpro-user-type-control.test.ts`.

## 3. Verification Evidence

| Gate | Result |
| --- | --- |
| Focused user-type/authority/persona tests | PASS — 24/24 |
| Full Vitest regression | PASS — 357 passed, 12 skipped |
| TypeScript | PASS |
| Changed production-file ESLint | PASS — zero errors; 10 pre-existing page warnings |
| Critical-file verification | PASS |
| Next.js request-body backport verification | PASS |
| Clean production build | PASS — 131 static pages generated |
| Diff whitespace check | PASS |

The first two build attempts collided with the already-running local development server's
generated `.next` manifests. This also caused a temporary Auth.js `ClientFetchError` in the
browser because `/api/auth/providers` could not read those generated manifests. The exact
generated `.next` cache was removed, the clean production build then passed, and the stale
development process was stopped and restarted. Local port 3000 returned to `Ready`; no
source, database, role or account data was removed.

Expected local build warnings remain because Upstash is not configured in local development.
No deployed-environment claim is made.

## 4. Current Stop

The implementation remains uncommitted on local `dev`, based on `7e453665`. The corrected
actor/target human gate passes and control returned to parent `PLAT-ROLE-02`. Its later
item-3/item-15 Club Officials failures were corrected by `PLAT-ROLE-02B` and do not reopen
this correction. The complete parent 1–18 matrix subsequently passed. The current stop is
the separate focused item-7 exact-Club junction retest; do not push or promote before it is
accepted.
