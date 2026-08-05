# LMSPro CR-Fix F2.1 — Cohort Taxonomy And Picker Correction Local Confirmation

Date: 2026-08-05

Status: **COMMITTED AND EXACT ON DEV/STAGING/MAIN AT `9974eed5`; LOCAL AND FINAL STAGING
HUMAN SMOKE PASS; AUTOMATED, SECURITY AND PUBLIC STAGING HEALTH GATES PASS**

Accepted plan:

`docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f2-1-cohort-taxonomy-and-picker-correction-planning.md`

Parent CR-Fix:

`docs/modules/lmspro/01-cr-inputs/CR-Fix-2026-08-05-lmspro-cohort-email-draft-persistence-and-audience-selection.md`

## 1. Exact Boundary

```text
implementation branch: dev
F2.1 implementation commit: 9974eed5d271783722e685ba3e35ef843d48e30b
commit subject: fix(communications): correct LMSPro cohort role taxonomy
local dev/origin-dev: 9974eed5d271783722e685ba3e35ef843d48e30b
local staging/origin-staging: 9974eed5d271783722e685ba3e35ef843d48e30b
local main/origin-main: 9974eed5d271783722e685ba3e35ef843d48e30b
Render live exact-build confirmation: pending after main push
main Security Scan: PASS — 31015039314
schema/migration: none
data mutation: none
saved-draft compatibility: deliberately excluded by control-owner decision
provider Send: not exercised
```

The staging promotion was a clean fast-forward from `07a71906` through the previously
requested documentation-only commit `0791adbf` to F2.1 commit `9974eed5`. The F2.1 commit
itself contains exactly the seven application/test files recorded below.

The control owner subsequently reported the final staging F2.1 schedule entirely green
across all ten checks and explicitly authorised production promotion. Main was
fast-forwarded and pushed to `9974eed5` on 2026-08-05, and exact main Security Scan
`31015039314` passed.

## 2. Implemented Role Taxonomy

The communications provider now treats access context and recipient roles separately:

- League Roles are built from exact active tenant `LEAGUE` roles only;
- Club Roles are built from exact active tenant `CLUB` roles only;
- `BOTH` access-mode roles are emitted by neither role tree;
- the League resolver accepts exact `LEAGUE` role IDs only;
- the Club resolver accepts exact `CLUB` role IDs only; and
- an invalid, cross-scope or `BOTH` role ID is rejected before recipient lookup.

There is no name-based `League & Club` special case. The rule is enforced from exact scope
at both the picker-data and server-resolution boundaries.

## 3. Implemented Picker Presentation

The cohort picker now:

- uses the shared `CohortNode` contract and its real `recipientCount` field;
- displays category nodes as visually distinct headings rather than apparent selectable
  rows with missing checkboxes;
- gives every eligible child item one checkbox;
- disables a proved zero-recipient item and labels its zero count;
- clearly labels an empty category as having no available recipients;
- reports counts as recipients rather than an unexplained number; and
- uses human-readable cohort and selected-item labels in the selection summary.

The existing `<cohort type>:<node ID>` selection key remains because it is valid generic
identity for genuinely different cohort types. It is no longer used to justify duplicate
`BOTH` role presentation.

## 4. Implemented Recipient-Type Placement

The global-looking `Include recipient types` panel was removed.

When at least one Division or Age Group filter is selected, a contextual panel now appears
directly beneath the cohort picker:

```text
For selected Divisions and Age Groups, include:
Team Managers
Club Secretaries
Other Club Officials
```

The panel explicitly states that these choices do not affect Clubs, League Roles, Club
Roles or other recipient groups. The shared helper used for both presentation and payload
construction recognises only `divisions` and `ageGroups`.

## 5. Changed Application Files

```text
src/core/services/communications/components/CohortPicker.tsx
src/core/services/communications/components/ComposeEmailModal.tsx
src/core/services/communications/components/cohort-selection.ts
src/core/services/communications/components/cohort-selection.test.ts
src/modules/lmspro/communications/cohort-resolver.ts
src/modules/lmspro/communications/cohort-role-resolver.test.ts
src/modules/lmspro/communications/provider.ts
```

## 6. Automated Evidence

| Gate | Result |
| --- | --- |
| Focused selection/role/resolver tests | PASS — 12 tests across 3 files |
| Complete communications/LMSPro communications tests | PASS — 90 tests across 13 files |
| Full Vitest suite | PASS — 286; 12 intentionally skipped |
| TypeScript | PASS |
| Repository verification | PASS |
| Changed production-file ESLint | PASS — zero errors; 26 pre-existing warnings |
| Supported Node 22.23.2 production build | PASS — 131/131 pages |
| Diff check | PASS |
| Exact dev Security Scan | PASS — `31013858136` |
| Exact staging Security Scan | PASS — `31013879648` |
| Public staging health | PASS — database connected; RLS 11/11 |

The first repository-verification attempt hit the established sandbox `tsx` IPC `EPERM`.
The identical command passed with the required local permission.

The first supported-Node runtime/build lookup was unable to reach the package registry from
the restricted sandbox. It was stopped and rerun through the permitted external path. The
build passed. Established local Upstash HTTPS/configuration warnings were emitted during
page collection; they did not stop the build and are unrelated to F2.1.

Public staging health passed at `2026-08-05T14:13:32.164Z`. The endpoint does not expose the
Git commit, so final human smoke must first confirm Render displays `Live at 9974eed`.

## 7. Explicit Saved-Draft Exclusion

No existing-draft inventory, migration, warning, compatibility adapter or automatic filter
rewrite was implemented. The control owner confirmed that this is a new feature used by
one person, who will be instructed to delete pre-release drafts.

## 8. Local Human Smoke Evidence

The control owner tested the exact implementation locally before commit. No code changed
between that human test and commit `9974eed5`.

| Check | Result |
| --- | --- |
| League Roles contains exact League roles only | PASS |
| Club Roles contains exact Club roles only | PASS |
| No `League & Club`/`BOTH` entry in either role list | PASS |
| Role rows have checkboxes and truthful counts | PASS |
| Empty/zero-recipient states are clear and cannot add audience | PASS |
| Assigned League role changes preview and survives Save Draft/reopen | PASS |
| Assigned Club role changes preview and survives Save Draft/reopen | PASS |
| Recipient-type panel appears only for Division/Age Group | PASS |
| Recipient types affect the structural cohort only | PASS |
| Save Draft invokes no provider Send | PASS |

## 9. Remaining Staging Human Gate

After confirming Render displays `Live at 9974eed`, repeat the focused role and
recipient-type smoke on staging. Provider Send remains a separate, deliberately controlled
test decision.

At minimum confirm:

1. League Roles contains exact League roles only; PASS
2. Club Roles contains exact Club roles only; PASS
3. no `League & Club`/`BOTH` access entry appears in either role list; PASS
4. role rows have checkboxes and truthful counts; PASS
5. empty/zero-recipient states are clear and cannot add an audience; PASS
6. one assigned League role changes the preview count and survives Save Draft/reopen; PASS
7. one assigned Club role changes the preview count and survives Save Draft/reopen; PASS
8. the recipient-type panel appears only after selecting a Division/Age Group; PASS
9. those recipient-type choices affect that structural cohort only; and PASS
10. Save Draft invokes no provider Send. PASS

No main/live promotion is authorised by this confirmation.
