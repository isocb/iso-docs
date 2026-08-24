# LMSPro Remediation Slice R13-A — Free Day Integrity And Management Presentation Implementation Confirmation

Date: 2026-08-24

Status: **EXACT RUNTIME CANDIDATE PROMOTED TO ORIGIN/STAGING; LOCAL GATES AND ALL SECURITY
SCANS PASS; STAGING IDENTITY/HUMAN GATE PENDING**

Exact commit: **R13-A runtime `71ed589b9c6c55a8832fbfa1669de143236ec783`.** The promoted
corridor tip is `e7a756cc39eac65b71729490f8c6c26f30435eb6`, whose only later change clarifies the
literal shared work-method path in root `AGENTS.md`.

Files/change boundary: Free Day quota/query authority, standard/Special date-only boundaries,
C1/C2 Free Day presentation and focused tests only. No Prisma schema, migration, historic-row
repair, provider delivery or Team Variation implementation.

Automated checks: **PASS** — focused 35/35; full repository 471 passed and 12 intentionally
skipped; TypeScript, repository verification, targeted production lint, whitespace and the
Node 22 production build pass. Exact work-branch, `origin/dev` and `origin/staging` Security
Scans `32742731175`, `32743079768` and `32743397739` pass.

Human evidence: **PASS** — the control owner records H1-H11 PASS using controlled local C1/C2
personas and non-sensitive fixtures. H8 first exposed an incorrect standard-quota disablement in
the Special request Team selector; after failing-first coverage and correction, the control
owner reran H8 and recorded PASS.

Environment proven: local application/DevData and the Git promotion corridor through
`origin/staging`. Public staging health is HTTP 200 with database connected and RLS 11/11.
Exact Render `Live at` identity and representative authenticated staging smoke remain pending.

Known residual risk: public health does not expose the deployed commit and cannot substitute
for Render identity or the representative C1/C2 staging critical path. No live promotion is
authorised or performed.

Next authorised action: record Render staging Live at `e7a756c` and the proportionate S1-S4
staging smoke. If they pass, close/reconcile R13-A and activate R13-B under the control owner's
2026-08-24 instruction. Do not promote to live.

Accepted plan:

- [R13-A planning](../03-slice-planning/2026-08-24-lmspro-remediation-slice-r13-a-free-day-integrity-and-management-presentation-planning.md)

Review and test:

- [R13-A local review and test](../05-review-and-test/2026-08-24-lmspro-remediation-slice-r13-a-free-day-integrity-and-management-presentation-local-review-and-test.md)

## 1. Delivered Correction

### 1.1 One standard quota policy

One pure policy now defines quota-consuming rows as the same organisation, season and Team,
`specialFreeDayId = null`, and status `PENDING`, `APPROVED` or `CONFIRMED`. Request admission,
Team usage, approval recheck and season Teams-at-limit presentation consume that policy.

The season summary uses one grouped quota query and a bounded Team detail query rather than a
per-Team count loop. The valid zero-allowance case lists every in-season Team at `0/0`; Special
applications cannot create a false limit.

`getTeamUsage` and `getSeasonStats` now resolve Team/season records inside the current
organisation before returning quota information.

### 1.2 Concurrent request refusal

The standard-request duplicate and quota checks now run with creation in a serializable
transaction. One Prisma `P2034` conflict is retried, forcing a fresh quota read; a repeated
conflict returns a truthful conflict response. A refused request creates neither a row nor the
post-transaction notification attempt.

### 1.3 C1 presentation and cache truth

- The current season is derived without setting React state during render.
- Blank status remains no status predicate, and active time/Club/Age Group filters retain their
  existing meaning.
- Free Day mutation success invalidates the list, season summary, pending count and Team usage.
- Club request success also refreshes Standard/Special availability caches.
- Club, Team/Age Group, date, reason, status and requester/submitted-date columns have stable
  local ascending/descending sorting with an active direction indicator.
- Pending is a keyboard-operable control that retains season, clears Club/Age Group, selects
  `PENDING` plus `All dates`, and focuses the results.
- Teams At Limit is a keyboard-operable control that opens deterministic Club/Team `used/total`
  detail instead of pretending a request status is a Team aggregate.

### 1.4 Date-only integrity

An explicit helper now converts a local picker calendar day to UTC midnight, normalises accepted
server date-only values to UTC midnight and reconstructs local picker values from stored UTC
components.

It is applied to C1 standard create/edit, C2 standard create, C1 Special create/edit, both server
write boundaries, C1 filter boundaries and C1/C2 display. Only the four Free Day notification
events use the date-only notification formatter; unrelated timestamp/disciplinary templates keep
their existing semantics.

### 1.5 Special application presentation

Special applications are deterministically ordered case-insensitively and alphanumerically by
Club then Team, with stable identity fallback. Each Special Day derives an authorised Age Group
filter from its applications. Filtering is presentation-only and does not clear or rewrite bulk
selection membership.

The Special request Team selector is independent of the standard seasonal quota. The standard
selector, quota message and C1/C2 allowance display all retain the current season's configured
`maxFreeDaysPerTeam` value, including a valid zero; the default is used only when the value is
absent.

## 2. Failing-First Evidence

Before the helpers and router correction existed:

- the three new quota/date/presentation suites failed because their implementation modules did
  not exist;
- cross-tenant Team usage attempted the unscoped lookup path;
- an approved Special application could contribute to the season at-limit result; and
- the standard request path did not invoke a serializable count-and-create transaction.

The corrected focused matrix now passes in full.

During controlled human H8 smoke, a Team already at its standard allowance was incorrectly
disabled in the Special request modal. A focused test first failed because there was no
quota-independent Special Team-option builder. The new builder leaves every otherwise eligible
Team enabled and removes standard quota wording. A separate failing-risk regression preserves
configured seasonal allowances, including zero, rather than replacing them through a truthy
fallback. Both focused regressions and the corrected human H8 path now pass.

## 3. Changed Application Files

```text
src/app/(app)/app/lmspro/club/free-days/page.tsx
src/modules/lmspro/communications/notification-templates.ts
src/modules/lmspro/communications/__tests__/free-day-notification-templates.test.ts
src/modules/lmspro/components/dashboard/FreeDaysManage.tsx
src/modules/lmspro/components/dashboard/FreeDaysRequest.tsx
src/modules/lmspro/components/dashboard/SpecialFreeDaysManage.tsx
src/modules/lmspro/lib/free-day-date-only.ts
src/modules/lmspro/lib/free-day-date-only.test.ts
src/modules/lmspro/lib/free-day-presentation.ts
src/modules/lmspro/lib/free-day-presentation.test.ts
src/modules/lmspro/lib/free-day-quota-policy.ts
src/modules/lmspro/lib/free-day-quota-policy.test.ts
src/server/core/routers/lmspro/freeDays.router.ts
src/server/core/routers/lmspro/freeDays.router.test.ts
src/server/core/routers/lmspro/specialFreeDays.router.ts
```

## 4. Automated Evidence

| Gate | Result |
| --- | --- |
| Focused R13-A plus preserved R12-A notice suite | PASS — 35/35 across 6 files |
| Full repository Vitest suite | PASS — 471 passed; 12 intentionally skipped; 75 files passed and 1 skipped |
| TypeScript | PASS |
| Critical-file repository verification | PASS, including its nested TypeScript check |
| Targeted production ESLint | PASS — zero errors; 10 existing-style warnings |
| Diff whitespace check | PASS |
| Production build | PASS — clean Next.js 15.5.21 build under repository-required Node 22.23.2 |
| Schema/migration | None |
| Work-branch exact Security Scan | PASS — `32742731175` at `e7a756cc` |
| Dev exact Security Scan | PASS — `32743079768` at `e7a756cc` |
| Staging exact Security Scan | PASS — `32743397739` at `e7a756cc` |

The initial full-suite run inside the restricted sandbox reached 467 passing tests and failed
only because the pre-existing FUND proof could not launch Chromium (`MachPortRendezvousServer`
permission denial). Approved unrestricted reruns passed; the final suite after the Special
selector and seasonal-allowance regressions passed 471 tests.

The first repository-verifier invocation similarly encountered the established `tsx` IPC
`EPERM`; its approved unrestricted rerun passed.

The first two build attempts used the shell's unsupported Node 24.9.0 rather than the repository's
declared Node 22.x and emitted a broken `/_document` chunk location. After preserving the
generated cache and rebuilding cleanly under Node 22.23.2, compilation, type validation, page
data collection and all 131 static pages completed successfully. Missing local Upstash
configuration produced the expected warning; no credential or configuration change was made.

## 5. Recovery And Release Position

This is an application-only candidate. Recovery is a bounded revert of runtime commit
`71ed589b`; there is no schema/data rollback. The exact corridor tip is consolidated through
`dev`/`origin/dev` and promoted to `staging`/`origin/staging`. No live promotion or external
provider Send was performed; the Render staging deployment identity remains to be confirmed.
