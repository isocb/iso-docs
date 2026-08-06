# LMSPro R11-A — Recipient-Tab Accordion And Responsive Layout Implementation And Live Branch Promotion Confirmation

Date: 2026-08-06

Status: **IMPLEMENTED; AUTOMATED/TYPE/VERIFY/LINT/BUILD GATES PASS; LOCAL SMOKE 18/18 AND
STAGING SMOKE ALL GREEN; EXACT `83356030` ALIGNED THROUGH MAIN; LIVE DEPLOYMENT TRIGGERED;
PUBLIC LIVE HEALTH PASS; EXACT RENDER BUILD/AUTHENTICATED PRODUCTION SMOKE PENDING**

Accepted plan:

`docs/modules/lmspro/03-slice-planning/2026-08-06-lmspro-r11-a-recipient-tab-responsive-accordion-ui-planning.md`

Review and test summary:

`docs/modules/lmspro/05-review-and-test/2026-08-06-lmspro-r11-a-recipient-tab-responsive-accordion-ui-review-and-test.md`

Authoritative LMSPro roadmap:

`docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`

## 1. Exact Local Boundary

```text
application base before R11-A: ec7e0cc4c22ee9470534e8d09df1e402bbf0f81e
exact R11-A application commit: 833560309786c71265c361b71f3523dbc100499d
dev/origin-dev: 833560309786c71265c361b71f3523dbc100499d
staging/origin-staging: 833560309786c71265c361b71f3523dbc100499d
main/origin-main: 833560309786c71265c361b71f3523dbc100499d
staging authenticated smoke: all green
live deployment: triggered by origin/main push
live public health after push: PASS; exact deployed build pending
schema/migration: none
API/payload change: none
provider Send invoked: no
```

The application worktree was clean and exact with `origin/dev` before R11-A began. After
18/18 local smoke acceptance, the candidate was committed on `dev`, pushed to `origin/dev`,
then promoted through a controlled fast-forward of local `staging` and `origin/staging`.
After all-green staging smoke and explicit authority, local `main` was fast-forwarded from
`staging` and pushed to `origin/main`. No direct remote-ref promotion was used.

## 2. Implemented Behaviour

### 2.1 Fresh And Stored-Selection Disclosure

- A fresh blank Email starts with every additive and eligibility category collapsed.
- Mandatory Team Current and Club Current defaults remain selected and are summarised on
  their collapsed headers.
- An existing draft or deliberately pre-populated composition derives its initially open
  categories from stored/initial cohort filters.
- Nested stored selections open every expandable ancestor required to reveal them.
- Unknown future filter types fail safely closed in disclosure without changing their
  business selection.

No accordion layout value is added to Email persistence. Reopened drafts derive disclosure
from existing filter data.

### 2.2 Composition-Scoped State

The Email modal now owns an explicit composition-session boundary. The picker is reset only
when a new modal session starts.

Within one session, explicit open/closed choices survive:

- recipient and status changes;
- cohort-tree/count refetches;
- modal-tab changes;
- responsive reflow; and
- the first Save Draft assigning a new `currentDraftId`.

The previous page-level `key={composeDraftId ?? 'new'}` remount was removed because it
destroyed the modal/picker state at first Save Draft. The parent now supplies the known
draft identity separately while initial draft data loads; saving a new Email does not
create a second session.

### 2.3 Controlled Tree And Search

Expandable tree-node state is owned by `CohortPicker` rather than reset-prone recursive
node defaults. Each node has a stable typed expansion key.

Search now matches descendants recursively and temporarily discloses matching ancestors.
It does not write into the user's explicit expansion set, so clearing search restores the
session state.

Collapsed category headers display a readable selected label or selected-count summary.
Nested expandable nodes also summarise selected descendants where their collapse would
otherwise hide them.

### 2.4 Ordering And Responsive Presentation

- The existing Division/Age Group recipient-type panel is passed into `CohortPicker` as a
  bounded presentation slot immediately after the authoritative Divisions category.
- When a Division or Age Group is selected, its `For selected Divisions and Age Groups,
  include` control therefore appears before Clubs and every other additive source.
- Recipient-type state and ownership remain in `ComposeEmailModal`; the picker only controls
  placement, so no selection or persistence contract is duplicated.
- Additive Audience Sources, including that combined structural cohort widget, now appears
  before Audience Eligibility.
- Audience Eligibility retains the explanation that statuses restrict rather than add
  recipients.
- The selector/Selected Groups Grid now uses full-width base columns and the `7/5` split
  only from the accepted desktop breakpoint.
- Mobile Selected Groups headings/cards wrap, labels can break safely and Remove actions
  remain associated and visible.
- The empty state now says `Select groups above`, which is truthful in the stacked layout.
- The picker's selected badges wrap rather than forcing a narrow horizontal row.

This placement is the control owner's correction to the initial R11-A request and
supersedes the first local arrangement, which placed the contextual panel after the whole
picker.

### 2.5 Reopened-Draft Disclosure Display Correction

The first authenticated local smoke run passed every item except test 7. On reopening a
draft, the chevron correctly showed the stored-selection category as open, but its content
remained visually collapsed until the category was closed and opened again.

This proved that stored-filter expansion state had been restored, while the animated
`Collapse` presentation had not matched that state. The modal can restore the open state
while its opening transition is still in progress; a measured-height collapse can therefore
retain a zero-height presentation even though `aria-expanded` and the chevron are correct.

Both nested and top-level cohort disclosures now use a zero-duration collapse. Open content
therefore renders directly from the authoritative expansion state and cannot retain a stale
measured height. This is a presentation-only correction: selection derivation, stored
filters, payloads and recipient resolution are unchanged.

## 3. Changed Application Files

```text
src/app/(app)/app/lmspro/communications/page.tsx
src/core/services/communications/components/CohortPicker.tsx
src/core/services/communications/components/ComposeEmailModal.tsx
src/core/services/communications/components/cohort-accordion-state.ts
src/core/services/communications/components/cohort-accordion-state.test.ts
```

No server router, provider, resolver, Prisma schema, migration, delivery or attachment file
changed.

## 3.1 Post-Promotion Public Staging Evidence

After the `origin/staging` push:

- `https://staging.seasonpro.co.uk/api/health` returned HTTP 200;
- the response reported `healthy`, database `connected` and RLS `11/11` enabled; and
- the signed-out communications route returned HTTP 307, consistent with its authentication
  boundary.

These checks prove that the public staging service boots and its database/RLS health gate is
green. They do not expose the deployed Git SHA and do not replace authenticated C1 browser
smoke. The control owner subsequently reported the staging smoke all green.

## 3.2 Live Branch Promotion And Public Health Evidence

After all-green staging acceptance and explicit live-promotion authority:

- local `main` was confirmed exact with `origin/main` at the prior `ec7e0cc4` boundary;
- local `main` fast-forwarded from `staging` to exact `83356030`;
- `origin/main` advanced to `83356030`, triggering the Render live deployment;
- `https://app.seasonpro.co.uk/api/health` returned HTTP 200 after the push;
- the response reported `healthy`, database `connected` and RLS `11/11` enabled; and
- the signed-out live communications route returned HTTP 307 at its authentication boundary.

Public health does not expose the Render Git SHA and does not replace authenticated
production UI smoke. Exact Render live-build identification and focused production
acceptance therefore remain pending.

## 4. Automated Evidence

| Gate | Result |
| --- | --- |
| Focused accordion/selection tests | PASS — 15 tests across 2 files |
| Communications/LMSPro communications suite | PASS — 106 tests across 15 files |
| Full Vitest suite | PASS — 302; 12 intentionally skipped |
| TypeScript | PASS |
| Critical-file repository verification | PASS |
| Changed production-file ESLint | PASS — zero errors; 17 pre-existing-style warnings |
| Production build | PASS — 131/131 pages |
| Diff whitespace check | PASS |
| Schema/migration | None |

The production build emitted the established local Upstash HTTPS/configuration warnings
during page collection. They did not stop the build and are unrelated to R11-A.

The final repository-verifier invocation initially encountered the established sandbox
`tsx` IPC `EPERM`; its approved direct rerun passed, including the nested TypeScript gate.

The test-only file is intentionally outside the repository ESLint TypeScript project, as
are the existing colocated Vitest files. It executes successfully under Vitest. Production
files have zero lint errors.

## 5. Preserved Contracts

R11-A does not change:

- F2.2 additive-source/restrictive-eligibility algebra;
- Team/Club Current defaults or last-required-status protection;
- recipient types, role authority or cohort counts;
- preview, Save Draft or Send payloads;
- provider-recipient or eligible Club-history construction;
- attachment/link acknowledgement or F3 policy; or
- provider delivery, batching or Email status behaviour.

## 6. Release Position

Static review and automated gates are green. The control owner reports all 18 local smoke
items passing, including the corrected reopened-draft disclosure display in test 7.

Exact commit `83356030` passed all-green staging smoke and is aligned through `origin/main`.
Public live health is green after the main push. Confirm Render identifies that exact live
commit and execute focused authenticated production smoke before lifecycle closure.

## 7. Rollback

Rollback is a bounded revert of application commit `83356030` through the same controlled
branch corridor. No database or data rollback is required.
