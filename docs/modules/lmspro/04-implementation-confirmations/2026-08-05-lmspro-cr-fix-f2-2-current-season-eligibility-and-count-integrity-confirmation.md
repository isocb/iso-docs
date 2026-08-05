# LMSPro CR-Fix F2.2 — Current-Season Eligibility And Count Integrity Confirmation

Date: 2026-08-05

Status: **COMMITTED AND EXACT ON DEV/STAGING AT `ec7e0cc4`; AUTOMATED AND BUILD GATES
PASS; STAGING HUMAN SMOKE REQUIRED; MAIN NOT AUTHORISED**

Accepted corrected plan:

`docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f2-2-current-season-eligibility-and-count-integrity-planning.md`

Parent CR-Fix:

`docs/modules/lmspro/01-cr-inputs/CR-Fix-2026-08-05-lmspro-cohort-email-draft-persistence-and-audience-selection.md`

## 1. Exact Boundary

```text
implementation branch: dev
application commit: ec7e0cc4c22ee9470534e8d09df1e402bbf0f81e
commit subject: fix(communications): enforce LMSPro audience eligibility
local dev/origin-dev: ec7e0cc4c22ee9470534e8d09df1e402bbf0f81e
local staging/origin-staging: ec7e0cc4c22ee9470534e8d09df1e402bbf0f81e
main/origin-main: 9974eed5d271783722e685ba3e35ef843d48e30b
schema/migration: none
data mutation: none
saved-draft compatibility: deliberately excluded by control-owner decision
provider Send during automated verification: none
```

Staging was promoted by clean fast-forward from `9974eed5` to `ec7e0cc4`. Main remains at
the accepted F2.1 baseline and requires explicit authority after human staging acceptance.

## 2. Implemented Audience Algebra

The LMSPro provider now resolves the full filter collection under one module-owned
contract:

```text
eligible(source) = candidates(source)
                   INTERSECT current season when season-bound
                   INTERSECT selected Team statuses when Team-derived
                   INTERSECT selected Club statuses when Club-derived

final audience = DEDUPLICATE(UNION eligible(each selected recipient source))
```

This means:

- Age Groups, Divisions, explicit Clubs, League Roles, Club Roles, Club Officer Contacts,
  Referees and Venues remain additive sources;
- Team Status and Club Status are predicates and never independently add recipients;
- status-only selection resolves zero recipients;
- multiple checked values within one status dimension are OR alternatives;
- every season-bound ID is validated against the exact server-resolved current season;
- invalid, old-season and cross-tenant IDs fail closed;
- League Role recipients remain additive even where Team/Club status is inapplicable;
- League Role Club-history contexts are limited to status-eligible current-season
  memberships without excluding the League Role recipient;
- Club Role recipients require an active exact role plus an independently
  status-eligible authoritative Club membership; and
- a selected Age Group, Division or explicit Club never narrows a selected role source.

The generic Email and Sequence paths use the provider's multi-filter resolver where it is
available. Other module providers retain their existing per-filter behaviour.

## 3. Current Definitions And Counts

The implementation preserves the accepted canonical defaults:

- Team Status defaults to `CURRENT`;
- Club Status defaults to Current/`APPROVED` with at least one `CURRENT` Team allocated to
  a current-season Division;
- both status dimensions require at least one selected value;
- `AGED_OUT` is now represented explicitly in Team Status; and
- current-season ambiguity fails before audience persistence.

Picker Team counts now use the selected current-season Team/Club status eligibility. Club
counts deduplicate active official email addresses. Club Role counts require independently
eligible Club membership. Final provider-recipient and Club-history figures continue to
come from the same resolver/audience plan used by Save Draft.

## 4. Implemented Compose Behaviour

The recipient picker now separates:

- `Audience eligibility`, containing Team and Club Status; and
- `Additive audience sources`, containing recipient-producing cohorts.

Both Current defaults are selected on a new composition. The last checked value in either
status dimension cannot be removed. Status help text states that statuses restrict
applicable sources and do not add recipients. Zero-recipient selected sources remain
removable.

The contextual Division/Age Group recipient-type control remains unchanged and continues
to affect only those structural sources.

The Recipients-tab badge now uses content width, displays the complete resolved count and
has an accessible resolved-recipient label. The footer now labels distinct dashboard
records as `eligible Club histories` and explains their meaning through its title.

After a successful Send only, the list status filter is cleared so all Emails are visible.
Failed Send, Save Draft and Duplicate-to-Draft retain their existing filter behaviour.

## 5. Changed Application Files

```text
src/app/(app)/app/lmspro/communications/page.tsx
src/core/services/communications/components/CohortPicker.tsx
src/core/services/communications/components/ComposeEmailModal.tsx
src/core/services/communications/components/cohort-selection.ts
src/core/services/communications/components/cohort-selection.test.ts
src/core/services/communications/providers/types.ts
src/core/services/communications/routers/emails.router.ts
src/core/services/communications/routers/sequences.router.ts
src/modules/lmspro/communications/cohort-resolver.ts
src/modules/lmspro/communications/cohort-resolver.test.ts
src/modules/lmspro/communications/cohort-role-resolver.test.ts
src/modules/lmspro/communications/lmspro-audience-resolver.test.ts
src/modules/lmspro/communications/provider.ts
```

## 6. Automated Evidence

| Gate | Result |
| --- | --- |
| Focused selection/audience/role/Club-history tests | PASS — 32 tests across 5 files |
| Complete communications/LMSPro communications tests | PASS — 99 tests across 14 files |
| Full Vitest suite | PASS — 295; 12 intentionally skipped |
| TypeScript | PASS |
| Repository verification | PASS |
| Changed production-file ESLint | PASS — zero errors; 30 existing-style warnings |
| Production build | PASS — 131/131 pages |
| Diff check | PASS |
| Schema/migration | None |

The repository verifier's first wrapper run hit the established sandbox `tsx` IPC
`EPERM`; the approved direct checker passed, including its TypeScript gate. The build
emitted the established local Upstash HTTPS/configuration warnings during page collection;
they did not stop the build and are unrelated to F2.2.

## 7. Risk Assessment At Promotion

| Risk | Current control |
| --- | --- |
| Status still adds a broad unrelated audience | Multi-filter provider contract plus status-only zero-recipient tests |
| Additive role source is accidentally narrowed by Age Group | Mixed Age Group/League Role/Club Role union fixture |
| Old-season or cross-tenant structural ID enters the plan | Exact current-season source validation and fail-closed error |
| Non-current Club creates a dashboard history | Source-specific Club eligibility and eligible-context-only history construction |
| Shared address loses one Club context | Cross-source normalised-address deduplication test retaining every eligible Club ID |
| Preview differs from persistence | Shared resolver used by preview, create, update and sequence enrollment |
| F1 broad persistence regresses | Complete communications suite and production build pass; staging real-shape draft remains required |
| Provider delivery is unintentionally changed | Provider sender, batching and attachment routes are untouched |

No production audience data was queried or mutated during implementation. Automated
fixtures prove resolver semantics; staging human evidence must prove the real tenant data
shape and UI presentation.

## 8. Required Staging Human Smoke

First confirm Render staging displays `Live at ec7e0cc4`.

Use controlled non-sensitive content and Save Draft unless a step explicitly says Send:

1. Confirm Team Current and Club Current are selected by default.
2. Confirm the last selected status in either dimension cannot be cleared.
3. Select one Age Group with Team Managers and Club Secretaries; record provider-recipient,
   Team and eligible Club-history counts.
4. Confirm only current-season, selected-status Teams and Clubs contribute.
5. Add a non-current Team status and confirm only matching Teams inside that Age Group are
   added.
6. Add a non-current Club status and confirm only matching Club contexts are added.
7. Add one League Role and confirm its recipients are added without narrowing the Age Group.
8. Add one Club Role and confirm independently status-eligible role recipients are added,
   including eligible recipients outside the selected Age Group.
9. Confirm overlapping addresses remain one provider recipient while all eligible Club
   histories remain represented.
10. Remove every additive source while leaving statuses selected; confirm recipient count
    is zero and Send is disabled.
11. Save Draft, reopen it, and confirm sources, statuses and all counts are stable.
12. Confirm the Recipients-tab badge displays the complete multi-digit count.
13. Confirm Save Draft invokes no provider Send.
14. Negatively verify an excluded old-season, withdrawn or otherwise unselected-status
    Club does not receive a history.
15. In a deliberately controlled single-recipient Send, start from a Draft-filtered list
    and confirm successful Send returns to the complete unfiltered list while manual status
    filtering remains available.

A broad real-recipient Send is not required for staging acceptance. Main/live promotion is
not authorised by this confirmation.

## 9. Rollback

Rollback is an application revert of `ec7e0cc4` through the normal branch corridor. There
is no database rollback because F2.2 contains no schema migration or data mutation.

Stop and return to triage if staging shows different preview/persistence counts, an
inapplicable status removing a League Role recipient, a role source narrowing another
source, an excluded Club history, or F1 broad-draft persistence regression.
