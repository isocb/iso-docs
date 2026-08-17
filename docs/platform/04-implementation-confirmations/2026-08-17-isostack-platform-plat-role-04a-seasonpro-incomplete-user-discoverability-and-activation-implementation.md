# PLAT-ROLE-04A SeasonPro Incomplete-User Discoverability And Activation Implementation

Date: 2026-08-17

Status: **EXACT `fcd162db` LIVE THROUGH MAIN; ALL TECHNICAL AND STAGING HUMAN GATES PASS —
MINIMUM PRODUCTION HUMAN SMOKE PENDING**

Plan:

[`PLAT-ROLE-04A planning`](../03-slice-planning/2026-08-17-isostack-platform-plat-role-04a-seasonpro-incomplete-user-discoverability-and-activation-planning.md)

Human gate:

[`PLAT-ROLE-04A local review and smoke`](../05-review-and-test/2026-08-17-isostack-platform-plat-role-04a-seasonpro-incomplete-user-discoverability-and-activation-local-gate.md)

## 1. Exact Boundary

Implementation was performed locally on application branch `dev` from exact production
baseline `250baf12556de082fa11d005a8709fee656d8cd3`, accepted by the control owner and
committed as `fcd162db60956858233821fd3f29c55e17d954dd`. Local `dev`, `origin/dev`,
`origin/staging` and `origin/main` are exact at that commit. The
pre-existing user-owned edit to `1july2026.code-workspace` remains outside this slice and
untouched.

No Prisma schema, migration, tenant data, credential, Render service, R2 object, FUND
runtime or FUND proof file changed.

## 2. Implemented Contract

The C1 SeasonPro User Management surface now has three truthful populations:

```text
valid exact League persona       League Users
valid exact Club persona         Club Users
missing/legacy/invalid persona   Needs repair
```

The repair population shows same-tenant identities that were previously returned by the
server but hidden by the two-tab client split. Raw Core account status is displayed
separately from derived SeasonPro access. A repair record therefore reads
`Deactivated — persona repair required` without writing `User.status` during a list/read.

Exact-persona derivation rejects unavailable, foreign, inactive, template, `BOTH`,
duplicate-Club-role and prior-season Club composites. A same-name current Club may be
offered as an edit suggestion, but it no longer makes the stored historic Club UUID appear
valid.

The existing edit modal exposes stored/unknown assignments for explicit correction. An
active account cannot be saved or activated until it has one complete valid persona:

```text
Owner/Admin + League role                              C1
Member + Club role + exact current Club                C2
Owner/Admin + League role + Club role + current Club   C1 with Club hat
```

Direct and bulk activation now apply the same server-side gate before persistence. Bulk
validation completes before the transaction, preventing a partly activated selection.
Status-only suspension/deactivation of an already incomplete record remains possible and
keeps the module fail-closed.

Same-tenant duplicate creation directs the C1 manager to League, Club or Needs repair.
Cross-tenant conflicts retain the generic response. Authority-affecting direct and bulk
updates revoke target sessions after commit and return the actual revocation result so the
UI does not claim success when local Redis is unavailable.

## 3. Files Changed

Runtime and UI:

- `src/app/(app)/app/lmspro/admin/users/page.tsx`
- `src/modules/lmspro/routers/users.router.ts`
- `src/modules/lmspro/lib/seasonpro-persona-policy.ts`
- `src/modules/lmspro/lib/platform-persona-summary.ts`
- `src/modules/lmspro/lib/lmspro-user-persona-validation.ts`

Focused evidence:

- `src/modules/lmspro/lib/seasonpro-persona-policy.test.ts`
- `src/modules/lmspro/lib/lmspro-user-persona-validation.test.ts`
- `src/modules/lmspro/routers/users.activation.test.ts`

## 4. Automated Evidence

| Gate | Result |
| --- | --- |
| Focused persona/read/activation tests | PASS — 4 files, 30/30 tests |
| Complete non-FUND Vitest run | PASS — 68 files passed, 1 skipped; 441 tests passed, 12 skipped |
| TypeScript | PASS |
| Critical-file verifier | PASS |
| Next request-body finalisation verifier | PASS |
| Production build | PASS — 131 pages generated |
| Changed runtime-file lint | PASS WITH EXISTING WARNINGS — 0 errors; 10 legacy warnings in the C1 user page |
| Diff check | PASS |

The local build again reports that the local Upstash URL is unavailable. That is expected
in this environment and exercises the truthful sign-out/sign-in warning; configured
session revocation remains a human staging requirement after local acceptance.

## 5. Risk Controls

| Risk | Implemented control |
| --- | --- |
| Invalid account becomes invisible | Dedicated same-tenant Needs repair inventory |
| Derived module state disables another product | No Core-status mutation during list/read |
| Historic Club is silently accepted | Stored Club must itself belong to the current season |
| Direct or bulk activation bypasses the composite | Shared final-persona validator before every activation write |
| Bulk request partially succeeds | Validate the whole target set before the transaction |
| Stale session retains old authority | Revoke after commit and report success/unavailability truthfully |
| Duplicate response leaks another tenant | Repair guidance only for same-tenant identity; generic cross-tenant conflict |

## 6. Stop Condition

The local gate is accepted and exact dev Security Scan `32018358354` passes. The control
owner then authorised staging: exact `fcd162db` is live through `origin/staging`, staging
Security Scan `32018776885`, Render deploy `dep-da1drj5g1s2s73c6pge0` and public health
pass. All three staging-applicable human checks pass. The two malformed-fixture checks are
not applicable because staging has no invalid record and the UI prevents creating one;
the accepted local/automated evidence closes them. The control owner then authorised main:
exact main Security Scan `32019884264`, Render deploy `dep-da1e1ve7bikc73ckt9eg`, public
health and signed-out routing pass. The minimum production human smoke remains pending.
