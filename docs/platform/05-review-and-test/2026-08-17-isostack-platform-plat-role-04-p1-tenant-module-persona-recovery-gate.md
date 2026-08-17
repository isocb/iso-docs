# PLAT-ROLE-04 P1 Tenant Module Persona Recovery Gate

Date: 2026-08-17

Status: **LOCAL AND STAGING GATES PASS — EXACT `250baf12` LIVE ON STAGING; MAIN AWAITS
EXPLICIT AUTHORITY**

Plan:

[`PLAT-ROLE-04 planning`](../03-slice-planning/2026-08-17-isostack-platform-plat-role-04-p1-tenant-module-persona-recovery-planning.md)

Staging handoff:

[`PLAT-ROLE-04 staging promotion and indicative smoke`](2026-08-17-isostack-platform-plat-role-04-staging-promotion-and-indicative-smoke.md)

## 1. Review Boundary

Review only the bounded P1 tenant-user recovery/create contract. The reviewer must reject:

- any weakening of the SeasonPro runtime persona resolver;
- any new cross-tenant account transfer;
- a UI-only authority check without server validation;
- non-atomic User/junction/token/audit persistence;
- hidden use of template, `BOTH`, inactive or foreign roles;
- a Club-only C2 being incorrectly forced to receive a League role;
- a hat-swap persona being replaced by a standalone `BOTH` role;
- an active SeasonPro tenant being left without an explicit exact-role bootstrap path;
- silent continuation of a stale target session; or
- unrelated Fund, support, email or role-taxonomy changes.

## 2. Automated Evidence

| Gate | Result | Evidence |
| --- | --- | --- |
| Focused P1 persona/default-role policy tests | PASS | Five files, 35/35 tests pass, including live P1-record and no-impersonation gates |
| Existing SeasonPro persona/current-Club regression | PASS | Included in the focused 35/35 result |
| Non-FUND repository regression | PASS | 67 files passed, 1 skipped; 434 tests passed, 12 skipped |
| Full repository discovery | QUALIFIED | 435 tests passed; only the isolated FUND PDF proof failed because sandboxed Chromium could not open its macOS rendezvous service. It was not rerun or regenerated in this Platform lane |
| TypeScript | PASS | `npm run type-check` |
| Changed-file lint | QUALIFIED | New runtime service files have no lint errors. Repository test files are outside the lint parser project; one legacy `require()` error and existing `any`/unused warnings remain in touched legacy files |
| Critical-file verification | PASS | `npx tsx scripts/verify-critical-files.ts`; sandbox IPC required the already-approved local execution boundary |
| Next request-body finalisation verifier | PASS | Next.js 15.5.21 backport verified |
| Production build | PASS | 131 pages generated; local Upstash URL is intentionally unavailable, producing truthful rate-limit/session-revocation warnings |
| Application/proof TypeScript ownership | PASS | Root compiler excludes `scripts/proofs/**`; dedicated FUND compiler still includes and validates `renderer.ts` and `vitest.config.ts` |
| Exact-candidate FUND Linux parity | PASS | GitHub run `32011557112` passed all pinned-container proof steps for `250baf12` |
| Diff/contamination review against exact base | PASS | Runtime changes are bounded to Platform/SeasonPro persona administration. The later proof `tsconfig` ownership correction changes no proof implementation/evidence/runtime resource/credential. Pre-existing `1july2026.code-workspace` edit is untouched |

## 3. Local Human Evidence

Use the consolidated matrix in section 3.1. Record each check as `PASS`, `FAIL` or `BLOCKED`
with the exact non-sensitive fixture used. A partial result does not authorise staging.

Overall local result: **PASS — CONTROL OWNER REPORTED NO ERRORS ON 2026-08-17**

### 3.1 Consolidated local human smoke matrix

Use `http://localhost:3000/platform?tab=clients` as the authoritative surface and disposable
local accounts. Delete or suspend disposable accounts only through the normal UI after
evidence is recorded.

1. PASS Open an active SeasonPro tenant. Confirm the User table and modal separately label
   `Organisation Authority` and `SeasonPro Persona`.
2. PASS Open a deliberately incomplete Owner/Admin. Confirm it displays `Incomplete — no
   SeasonPro access`, never C2. Confirm legacy `League & Club`/`BOTH`, template and inactive
   roles are absent from selectors.
3. PASS Give that Owner/Admin one exact League role, save and reopen. Confirm Core authority,
   exact role and `C1 League` persist. Sign out/in or impersonate afresh and confirm C1
   League routing.
4. PASS Observe the save notification. With local Redis configured, confirm the previous target
   session is revoked. Without it, confirm the orange warning explicitly says automatic
   revocation is unavailable and requires sign-out/sign-in; do not record unavailable
   automatic revocation as locally proved.
5. PASS Create a disposable C1 Owner or Admin with one exact League role. Confirm creation is
   atomic, reopening is stable and no intermediate unassigned account appears.
6. PASS Create a disposable C2 Member with one exact Club role and one current Club. Confirm no
   League role is required, C2 Club routing works and C1 League routing is unavailable.
7. PASS Edit a C1 account to add one exact Club role and current Club. Confirm its League role is
   preserved, the persona reads `C1 + Club hat`, hat swap works, and two exact roles—not a
   `BOTH` role—are stored.
8. PASS Change the exact current Club and reopen. Confirm the User field and exact-current Club
   official junction agree, while historic-season evidence is not deleted.
9. PASS Submit one controlled direct invalid request using a foreign/old Club or unavailable
   role. Confirm the mutation fails and User, Club junction, token and audit state do not
   partially change.
10. PASS Confirm status-only suspension remains possible for an incomplete account; changing
    its authority/persona still requires a complete valid composite.
11. PASS Open a non-SeasonPro tenant. Confirm P1 retains the Core-only create/edit flow and no
    SeasonPro persona is claimed.
12. ACCEPTED ALTERNATE EVIDENCE — missing-role fixtures are not managed in SeasonPro human
    test data. The explicit catalogue message was observed elsewhere; automated tests prove
    missing-only creation, idempotence and no silent User assignment.
13. AUTOMATED PASS — NOT A HUMAN TEST. Confirm the retained `/platform/orgs/[id]` editor cannot save a contradictory composite
    through the same server mutation.
14. PASS Inspect audit evidence for successful create, persona update and catalogue bootstrap.
    Confirm failed validation has no success audit. Confirm no secrets are present.
15. TECHNICAL PASS — NOT A HUMAN TEST. Recheck the unrelated workspace edit remains unchanged and no path under
    `src/modules/fund`, `scripts/proofs/fund-1r-f-a`, Render Stage C or R2 was modified.

Stop immediately on any cross-tenant choice, partial persistence, stale-authority success
claim, C2 League access, loss of C1 League access during hat swap, or hidden `BOTH` role.

## 4. Staging Evidence

Record exact dev/staging commit, Security Scan run, Render identity, public health and all
eight indicative checks from planning section 9.

Do not repeat the entire local mutation matrix on staging unless implementation review
exposes a materially different environment dependency. The focused Northgate recovery,
session, audit, isolation and runtime checks are the staging purpose.

Overall staging result: **PASS — DEPLOYMENT, TECHNICAL GATES AND 8/8 HUMAN SMOKE**

```text
feature commit           28aa1ca37b0072b9b200bf4c076adec5c9099c60
release candidate        250baf12556de082fa11d005a8709fee656d8cd3
origin/dev               250baf12556de082fa11d005a8709fee656d8cd3
origin/staging           250baf12556de082fa11d005a8709fee656d8cd3
origin/main              cde4eaff1e14b2f02ba0953fe8693e7feb02bb61 (unchanged)
dev Security Scan        32011557075 — PASS
staging Security Scan    32011784475 — PASS
FUND Linux parity        32011557112 — PASS
staging public health    PASS — 08:51:39Z; database connected; RLS 11/11
Render exact identity    PASS — deploy dep-da1cjovavr4c73fmm5r0 live at 250baf12
indicative human smoke   PASS — 8/8, control owner, 2026-08-17
```

The staging fast-forward necessarily includes the already-recorded inert FUND proof/tooling
ancestry from `6f9ef016` through `328aadf0`. That ancestry is confined to the isolated proof
workflow/scripts and package metadata. No FUND runtime route/schema, Stage C secret, Render
worker action or R2 object operation was added by this promotion.

### 4.1 Failed-first-build and bounded correction

Render records the first promoted feature commit `28aa1ca3` as `build_failed`. The build
stopped during root `npm run type-check` because that broad project also discovered the
isolated FUND proof files, while the application deployment did not have the proof-only
`jsqr`, `playwright`, `pngjs` and `vitest/config` packages. The component synchroniser's
`Expected 44, found 50` message was a non-blocking inventory warning; it was not the build
failure and no records were automatically deleted or rewritten.

Correction `250baf12` is deliberately limited to TypeScript project ownership. The root
application project now excludes `scripts/proofs/**`; the dedicated FUND project explicitly
retains those files. Local application type-check/build, dedicated proof type-check, exact
dev/staging Security Scans and exact-candidate Linux parity all pass. This is not a FUND
renderer change and does not weaken proof validation.

The public health observation made while Render was rebuilding proved continuity of the
previous live staging service only. Render subsequently recorded deploy
`dep-da1cjovavr4c73fmm5r0` as `live` at exact `250baf12` at 08:51:24 UTC. A fresh health
response at 08:51:39 UTC then proved database connected and RLS 11/11 for the post-deploy
service boundary.

Pre-implementation operational exception: **ONE-ROW STAGING DATA CORRECTION AND MANUAL
AUDIT INSERT COMPLETE; FRESH-SESSION HUMAN RESULT PASS**.

Recorded controlled evidence:

```text
tenant          Northgate Vale Youth / 3f0ea6ba-6e61-4d5c-ae89-526e5f078ed7
user            nvy@isodo.co.uk / 6ce7e4a3-359c-46fe-b873-3f9bd7b3bc42
Core authority  OWNER (unchanged)
Club            Alderwick Athletic / 327f9832-e541-421f-ae71-241f9f10e781
before roles    legacy League & Club BOTH + exact Club Secretary CLUB
after roles     exact League Admin LEAGUE + exact Club Secretary CLUB
affected rows   1
audit log       b8cc8740-e41b-4a2e-8044-8f8dbec56a6a
rollback proof  earlier failed compound transaction rolled back; before state re-read
```

The successful guarded statement replaced only the legacy `BOTH` UUID with the verified
tenant `League Admin` UUID and retained the Club role/current Club. This restores a valid
hat-swap composite. That operational exception and its fresh-session result pass, but they
precede this code release and do not replace the later exact staging deployment gate.

## 4.2 Accepted Follow-On Finding

The local review identified that a same-tenant User with an incomplete SeasonPro persona is
returned by the server but omitted from both C1 League and Club tabs because its effective
scope is `NONE`. The control owner accepted a separate `CR-Fix-PLAT-ROLE-04A` design: make
such users discoverable as `SeasonPro access: Deactivated — persona repair required`, keep
Core account status separate, and prohibit activation until the complete persona validates.

This finding is fail-closed today and did not invalidate the P1 recovery matrix. It is not
part of the tested PLAT-ROLE-04 commit and must not be slipped into the staging promotion.

## 4.3 Audit-Log Admin Visibility Observation

Staging item 7 passed through an Organisation Owner: successful create/update evidence,
failed-request disposition and absence of secrets were verified. A C1 Admin could not view
any audit logs. Static review confirms this is the current server contract: organisation
audit-log retrieval is explicitly `OWNER`-only. The Settings UI nevertheless exposes the
Audit Logs tab to both `ADMIN` and `OWNER`.

This is a pre-existing fail-closed UI/policy consistency finding. It does not show missing
PLAT-ROLE-04 audit persistence, does not invalidate the staging pass and does not authorise
changing audit visibility. A later decision must either retain Owner-only access and hide
or explain the Admin tab, or explicitly design a safe delegated Admin read capability.

## 5. Production Evidence

Production promotion and production account recovery are separate decisions. Record exact
main commit/scan/Render identity/health first. Only then may an explicitly authorised
single-user P1 repair be recorded.

Overall production result: **PENDING**

## 6. Closure And Resumption

Closure requires exact code alignment through the accepted environment, truthful data
recovery disposition, audit/session evidence and roadmap reconciliation. On closure,
resume the suspended FUND Stage C proof from its recorded no-secret/no-object checkpoint or
record a new deliberate portfolio decision.
