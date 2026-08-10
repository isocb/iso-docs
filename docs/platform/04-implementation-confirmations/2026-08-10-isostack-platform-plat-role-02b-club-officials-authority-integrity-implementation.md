# PLAT-ROLE-02B Club Officials Authority Integrity Implementation

Date: 2026-08-10

Status: **IMPLEMENTED AND TECHNICALLY ACCEPTED ON LOCAL DEV; CONTROLLED DISPOSABLE-FIXTURE
REPAIR COMPLETE; PARENT 1–18 HUMAN MATRIX ACCEPTED; ITEM-7 CURRENT-CLUB JUNCTION
RECTIFICATION, FOCUSED RETEST AND READ-ONLY DERBY PROOF COMPLETE; LOCAL GATE PASS; NOT
COMMITTED IN ROLE CHILD `b1ede26f`; NOT PUSHED OR PROMOTED**

Plan:

[`PLAT-ROLE-02B planning`](../03-slice-planning/2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity-planning.md)

Review:

[`PLAT-ROLE-02B local review and human gate`](../05-review-and-test/2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity-local-gate.md)

## 1. Delivered Outcome

The item-3 read failure and item-15 destructive mutation now share one exact Club Officials
authority contract:

- valid same-current-Club C2 users are admitted through their exact active Club role and
  `clubs.officials.view`, not deprecated `lmsproClubRole` text;
- C1 Owner/Admin receives no Core-authority bypass: an exact active League role with the
  relevant component remains mandatory;
- a read-only role may view but may not assign, update or remove;
- list refusal/failure is rendered as an error with retry and can no longer masquerade as
  "No officials";
- the list identifies and displays the exact Club role rather than assuming
  `lmsproRoleIds[0]` is a Club role;
- existing-user assign and update preserve every exact League role while replacing only the
  Club-scoped role;
- remove preserves exact League roles and clears Club role, active Club link and current
  membership together;
- SeasonPro user edit reconciles the exact current Club and its current-season ClubOfficial
  junction atomically, removing stale prior-current Club contexts while preserving historic
  seasons;
- actor, target, tenant, current Club, active custom role, component and final persona are
  reloaded and validated server-side;
- unsafe self-removal and self-status change are refused; and
- User, current membership and audit persistence occurs inside one database transaction.

No Core Organisation-authority, invitation, Auth.js/session, schema, migration, seed,
provider or environment contract changed.

## 2. Principal Files

- `src/modules/lmspro/lib/club-official-policy.ts` — pure access, role-preservation and
  final-persona policy;
- `src/modules/lmspro/lib/club-official-policy.test.ts` — focused authority and role-integrity
  regression coverage;
- `src/modules/lmspro/lib/exact-club-membership-policy.ts` and its tests — deterministic
  exact current-Club junction reconciliation for SeasonPro user edit;
- `src/modules/lmspro/routers/club-officials.router.ts` — current-Club admission, atomic
  assign/update/remove and exact Club-role list enrichment; and
- `src/app/(app)/app/lmspro/club/officials/page.tsx` — truthful error/empty states, exact
  Club-role display and server-shaped mutation controls.

The already accepted uncommitted `PLAT-ROLE-02A` Owner-control files remain in the same
local working tree and were preserved.

## 3. Automated Evidence

| Gate | Result |
| --- | --- |
| Focused `PLAT-ROLE-02A/02B`, persona and exact-Club tests | PASS — 34/34 |
| Full Vitest regression | PASS — 372 passed, 12 skipped |
| TypeScript | PASS |
| Changed production-file ESLint | PASS — zero errors; retained pre-existing Admin Users warnings only |
| Critical-file verification | PASS via direct `npx tsx scripts/verify-critical-files.ts` |
| Next.js body-finalisation verification | PASS |
| Standalone request-body regression | PASS — small 1/1, representative 20/20, accepted 10 MB 1/1 |
| Production build | PASS — 131 routes/static pages generated |
| Diff whitespace validation | PASS |

The ordinary `npm run verify` wrapper initially met the execution sandbox's `tsx` IPC
restriction. Running the repository's exact verifier directly with the approved `npx tsx`
entry point passed, including its nested TypeScript gate. The standalone runtime test also
required its intended ephemeral localhost listener and passed outside that sandbox
restriction.

Build warnings about absent local Upstash HTTPS configuration are the existing local-only
environment limitation. They do not change deployed configuration or the Role correction.

## 4. Controlled Disposable-Fixture Repair

The repair ran only after technical gates and only after an in-transaction exact-state
check. It found one and only one `owner@isodo.co.uk` account with:

```text
Organisation          Acme Corporation
Core authority/status ADMIN / ACTIVE
Before roles          Club Secretary Club only
Current Club          Nottingham Tigers FC / APPROVED / current season
Current membership    exactly one
Source destructive audit CLUB_OFFICIAL_UPDATED at 2026-08-10 09:45:34.224Z
```

One transaction restored:

```text
League role           League Admin / exact active LEAGUE role
Club role             Club Secretary Club / exact active CLUB role
Club                  unchanged current Nottingham Tigers FC
Core authority/status unchanged ADMIN / ACTIVE
Membership            retained and display label aligned to Club Secretary Club
```

Post-repair read-back confirmed one account, both exact roles, the same tenant and current
Club, one current membership and a `PLAT_ROLE_02B_FIXTURE_REPAIRED` audit record linked to
the destructive source audit. No other account or environment was changed. The account was
not deleted or recreated.

## 5. Item-7 Follow-Through

The control owner has accepted the complete parent item-1-through-item-18 matrix. Item 7's
specified user edit, Organisation `MEMBER`, exact role/Club and reopen behaviour passed.
The observed Officials refusal is correct because the selected `Club Secretary Club` role
does not grant `clubs.officials.view`; no permission bypass or role-catalogue mutation was
implemented.

Read-only data/audit review nevertheless found that the edit retained the prior Derby
Spitfires current-season ClubOfficial junction after selecting Nottingham Tigers. The User
record was exact, but a junction consumer could retain an unauthorised second current Club
context. The added policy now removes all non-selected current-season memberships and
creates the selected one when missing, in the same transaction as User, authority and audit
persistence. A null Club removes all current-season memberships. Older-season history is
deliberately retained.

The focused item-7 retest and read-only exact-junction confirmation pass: the Member's exact
Club and its sole current-season junction are Derby Spitfires. The full matrix did not
require repetition. The local Role slice is complete and remains blocked from staging until
the combined exact dev SHA passes Security Scan.

No commit, push, staging or production authority is inferred from local technical
acceptance.
