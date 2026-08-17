# PLAT-ROLE-04 P1 Tenant Module Persona Recovery Implementation

Date: 2026-08-17

Status: **IMPLEMENTED AND LOCALLY ACCEPTED AT `28aa1ca3`; EXACT RELEASE CANDIDATE
`250baf12` LIVE ON STAGING WITH GREEN PROTECTED SCANS, HEALTH AND 8/8 HUMAN SMOKE; MAIN
AWAITS EXPLICIT AUTHORITY**

Plan:

[`PLAT-ROLE-04 planning`](../03-slice-planning/2026-08-17-isostack-platform-plat-role-04-p1-tenant-module-persona-recovery-planning.md)

Review and human gate:

[`PLAT-ROLE-04 consolidated local gate`](../05-review-and-test/2026-08-17-isostack-platform-plat-role-04-p1-tenant-module-persona-recovery-gate.md)

Staging handoff:

[`PLAT-ROLE-04 staging promotion and indicative smoke`](../05-review-and-test/2026-08-17-isostack-platform-plat-role-04-staging-promotion-and-indicative-smoke.md)

## 1. Exact Boundary

Implementation was performed in the application repository on branch `dev`, based on exact
`328aadf0a360b4c65837327060302ddc525f6168`, and committed as
`28aa1ca37b0072b9b200bf4c076adec5c9099c60`. The first Render staging build exposed a
pre-existing repository build-boundary defect: the application root TypeScript project
also compiled the isolated FUND renderer proof, while Render's application install did not
contain its proof-only packages. No PLAT-ROLE-04 runtime code executed in that failed build.

The bounded correction `250baf12556de082fa11d005a8709fee656d8cd3` excludes all
`scripts/proofs/**` paths from the application root TypeScript project and explicitly keeps
the FUND proof files in their dedicated project. Local `dev`, `origin/dev` and
`origin/staging` are now exact `250baf12`; `origin/main` remains unchanged at `cde4eaff`.

The pre-existing user-owned edit to `1july2026.code-workspace` was not altered or included
in this slice. No FUND source, proof artefact, environment value, credential, Render Stage C
resource or R2 object was changed.

## 2. Implemented Contract

### Authoritative P1 Client Users UI

The shared `ClientUsersTab` used by `/platform?tab=clients` and
`/platform/clients/[id]` now:

- presents Core `Organisation Authority` separately from the SeasonPro module persona;
- reports valid `C1 League`, `C2 Club`, `C1 + Club hat`, incomplete and invalid states;
- loads active tenant-owned roles and current Clubs through P1 tenant overrides;
- exposes exact League roles separately from one exact Club role/current Club;
- never offers legacy `BOTH`, template, inactive or foreign roles;
- requires a complete persona before Create or persona-changing Save;
- identifies legacy/unavailable roles and historic Club links for explicit repair;
- provides an explicit `Provision missing default roles` action when the active SeasonPro
  tenant lacks an exact League or Club catalogue dimension; and
- reports session-revocation success or unavailability truthfully.

Non-SeasonPro tenants retain the Core-only user flow. The global Platform Administrator
surface was not changed.

### Server authority and persistence

`users.createForOrganization` and `users.platformUpdateUser` now enforce the same complete
server-side composite:

```text
Owner/Admin + exact tenant League role                 C1
Member + exact tenant Club role + exact current Club   C2
Owner/Admin + League + Club role + current Club        C1 with Club hat
legacy BOTH / foreign / inactive / template / old Club rejected
```

The server validates active SeasonPro product ownership, target tenant, active exact module
roles and current Club before writes. Create commits User, exact Club junction, reset token
and audit in one transaction. Update commits User, exact-current Club-junction
reconciliation and before/after audit in one transaction. Invalid composites persist
nothing.

Only a direct P1 session may use the recovery mutations; an impersonated P1 context is
refused. Existing identities cannot be transferred between tenants. Status-only suspension
of an incomplete account remains possible, while an authority/persona change must repair
the full composite.

Session revocation runs only after a successful authority-affecting commit. The revocation
service now returns an observable result, allowing the UI to avoid claiming success when
local or deployed Redis is unavailable.

### Exact default-role recovery

The default-role seeder now exposes an idempotent exact-default helper. The explicit P1
bootstrap:

- runs only for an active SeasonPro tenant;
- creates only a genuinely missing standard `League Admin` (`LEAGUE`) and/or `Club
  Secretary` (`CLUB`) row;
- refuses conflicting inactive/wrong-scope/system rows rather than rewriting them;
- preserves tenant-authored roles and the established onboarding/product provisioning
  behaviour;
- never creates or assigns a `BOTH` persona; and
- audits created and resolved exact role IDs.

The bootstrap does not silently assign a User. P1 must select and save the intended
complete persona explicitly.

### Truthful read model

The P1 organisation read model now resolves only active, non-template roles owned by the
selected tenant and current Clubs. Core Owner/Admin with no exact League role is returned
as incomplete rather than being inferred as C1 or C2. A legacy `BOTH` assignment is not
treated as an effective exact League role.

## 3. Files Changed

Application runtime and UI:

- `src/app/(platform)/platform/clients/[id]/_components/ClientUsersTab.tsx`
- `src/server/core/routers/users.router.ts`
- `src/server/core/routers/organizations.router.ts`
- `src/server/core/services/platform-seasonpro-persona.ts`
- `src/lib/session-revocation.ts`
- `src/modules/lmspro/lib/platform-persona-summary.ts`
- `src/modules/lmspro/lib/seed-default-roles.ts`

Focused evidence:

- `src/server/core/routers/users.platform-seasonpro.test.ts`
- `src/modules/lmspro/lib/platform-persona-summary.test.ts`
- `src/modules/lmspro/lib/seed-default-roles.test.ts`

No Prisma schema or migration changed.

Release-boundary correction only:

- `tsconfig.json`
- `scripts/proofs/fund-1r-f-a/tsconfig.json`

This correction changes neither Platform nor FUND runtime behaviour. It restores the
intended compile ownership: production builds validate application code, while the
dedicated FUND project and Linux-parity workflow validate proof code and dependencies.

## 4. Verification

| Check | Result |
| --- | --- |
| Focused persona/default-role/current-Club tests | PASS — 5 files, 35/35 |
| Complete non-FUND Vitest run | PASS — 67 files passed, 1 skipped; 434 tests passed, 12 skipped |
| TypeScript | PASS |
| Critical-file verifier | PASS |
| Next request-body finalisation verifier | PASS |
| Production build | PASS — 131 pages generated |
| Root compiler excludes isolated FUND proof | PASS — root `--listFiles` contains no `scripts/proofs/fund-1r-f-a` path |
| Dedicated FUND compiler retains proof | PASS — dedicated project includes and validates `renderer.ts` and `vitest.config.ts` |
| FUND Linux-container parity on exact release candidate | PASS — run `32011557112` |
| Diff check | PASS |
| FUND contamination check | PASS — only the dedicated proof `tsconfig` boundary changed; no proof implementation, evidence, runtime resource or credential changed |

Initial full test discovery additionally passed 435 tests. Its sole failure was the existing FUND
PDF proof attempting to launch Chromium inside the restricted macOS sandbox. That proof
was intentionally not rerun with broader privileges and no FUND evidence was regenerated.

Changed-file lint exposed no new runtime-service error. Its overall command remains
qualified by the repository lint project excluding test files, one pre-existing legacy
`require()` finding in `organizations.router.ts`, and existing `any`/unused warnings.

The local build warns that the local Upstash URL is unavailable. This is expected evidence
for the new truthful failure path: local P1 must see the explicit sign-out/in warning.
Configured automatic session revocation remains a mandatory staging check.

## 5. Deviations And Decisions

- Work remained in the existing local `dev` workspace rather than a new worktree because
  the control owner explicitly requested dev implementation. Exact base and contamination
  were recorded, and the unrelated workspace edit was preserved.
- The explicit role-catalogue bootstrap does not auto-assign an Owner. This is safer than
  inferring the intended tenant role and keeps recovery deliberate. Normal product
  assignment continues to seed defaults and assign League Admin to existing Owners.
- The older `/platform/orgs/[id]` editor is retained as a subordinate legacy surface. It
  now shares the hardened server mutation, so it cannot persist a contradictory composite.
- No bulk legacy `BOTH` migration was introduced.

## 6. Local Acceptance And Stop Condition

The control owner completed the consolidated local smoke on 2026-08-17 with no application
error. Every human-applicable item passed; catalogue-bootstrap fixture limits and the two
technical-only checks are recorded explicitly in the review gate. The bounded
implementation commit and deployment-boundary correction are aligned through staging as
exact release candidate `250baf12`. Dev Security Scan `32011557075`, staging Security Scan
`32011784475` and FUND Linux-parity run `32011557112` pass. Public staging health returns
HTTP 200, database connected and RLS 11/11 after Render deploy
`dep-da1cjovavr4c73fmm5r0` became live at exact `250baf12`. The control owner subsequently
reported the indicative staging smoke 8/8 PASS. Main remains unchanged pending explicit
promotion authority.

FUND Stage C remains preserved at its recorded suspended no-secret/no-object checkpoint.
The agreed incomplete-user discoverability/activation refinement is separately captured as
`CR-Fix-PLAT-ROLE-04A`; it is not silently included in or a blocker to this accepted exact
release.
