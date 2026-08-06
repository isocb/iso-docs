# LMSPro R11-A — Recipient-Tab Accordion And Responsive Layout Planning

Date: 2026-08-06

Module: LMSPro / SeasonPro communications

Status: **CONTROL-OWNER AUTHORISED IMPLEMENTATION AND STAGING PROMOTION; AUTOMATED/BUILD
PASS; LOCAL AUTHENTICATED SMOKE 18/18 PASS; COMMITTED AT `83356030`; DEV/ORIGIN-DEV AND
STAGING/ORIGIN-STAGING ALIGNED; POST-PUSH PUBLIC HEALTH PASS; EXACT BUILD/AUTHENTICATED
STAGING SMOKE PENDING**

Source CR:

`docs/modules/lmspro/01-cr-inputs/2026-08-06-lmspro-recipient-tab-responsive-accordion-ui-cr-input.md`

Accepted triage:

`docs/modules/lmspro/02-triage/2026-08-06-lmspro-r11-a-recipient-tab-responsive-accordion-ui-triage.md`

Authoritative LMSPro roadmap:

`docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`

Accepted F2.2 confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-08-05-lmspro-cr-fix-f2-2-current-season-eligibility-and-count-integrity-confirmation.md`

Local implementation confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-08-06-lmspro-r11-a-recipient-tab-responsive-accordion-ui-local-confirmation.md`

Local review and test summary:

`docs/modules/lmspro/05-review-and-test/2026-08-06-lmspro-r11-a-recipient-tab-responsive-accordion-ui-review-and-test.md`

Application planning baseline: `ec7e0cc4c22ee9470534e8d09df1e402bbf0f81e`

## 1. Planned Outcome

Deliver one client-only UI refinement to the Email Recipients tab:

```text
fresh blank compose
-> all picker categories closed
-> mandatory Current statuses still active and summarised

draft/pre-populated compose
-> categories containing stored/initial filters start open

user interaction
-> explicit open/closed choices persist for that modal session
-> Save Draft, count refetch, tab change and responsive reflow do not reset them

next fresh blank compose
-> all picker categories closed again

layout
-> Divisions/Age Groups and their contextual recipient types form one widget
-> remaining additive sources follow
-> Audience Eligibility follows the complete additive sequence
-> selector and Selected Groups side-by-side only where width supports it
-> readable full-width stack on mobile
```

No separate accordion state is persisted. A reopened draft derives its initially open
categories from its existing stored cohort/status filters.

## 2. Authority And Delivery Boundary

The control owner explicitly authorised local implementation and required a pause before
staging. This authority covers the bounded code, tests and local evidence records only; it
does not authorise commit, push or promotion.

R11-A must not change:

- server routers, provider interfaces or cohort resolvers;
- database schema, migrations or stored Email shape;
- Team/Club Current defaults or the last-required-status rule;
- additive-source/restrictive-eligibility algebra;
- preview, Save Draft or Send recipient resolution;
- Club-history construction or count meaning; or
- attachment/link acknowledgement and provider routes.

## 3. Supersession Boundary

R11-A supersedes the R4-B3/R4-004 presentation rule that opened Club Roles and League Roles
by default. It does not supersede R4-B's live-role accuracy, draft workflow or any F2.1/F2.2
correction.

The new controlling presentation rule is:

- all categories closed on a fresh blank Email;
- stored/initial selections disclose their category on session initialisation; and
- explicit user disclosure choice wins thereafter for that session.

## 4. Expected Application Surfaces

Primary files:

```text
src/app/(app)/app/lmspro/communications/page.tsx
src/core/services/communications/components/CohortPicker.tsx
src/core/services/communications/components/ComposeEmailModal.tsx
```

Implementation review confirmed the page-level `key={composeDraftId ?? 'new'}` remounted
the composer when first Save Draft assigned an ID. Removing that UI remount and passing the
known draft identity explicitly is required to meet the accepted same-session persistence
contract; it does not change routing, persistence or delivery.

Expected testable helper and unit test, either new or incorporated into the existing
selection helper where implementation review finds that cleaner:

```text
src/core/services/communications/components/cohort-accordion-state.ts
src/core/services/communications/components/cohort-accordion-state.test.ts
```

Existing regression surfaces:

```text
src/core/services/communications/components/cohort-selection.ts
src/core/services/communications/components/cohort-selection.test.ts
```

No server, schema, provider, resolver or delivery file is expected to change. Stop and
return to planning if implementation appears to require one.

## 5. Composition Session Contract

### 5.1 Stable Session Identity

`ComposeEmailModal` should establish one stable UI session identity when the modal opens.
That identity must:

- change for every close/reset followed by a new open;
- remain stable when the active modal tab changes;
- remain stable when recipient counts refetch;
- remain stable when filters change; and
- remain stable when Save Draft assigns `currentDraftId` to an Email that began as new.

Do not key accordion state directly to `currentDraftId`: the transition from unsaved to
saved during the same session would otherwise reset the picker.

### 5.2 Initial Selection Snapshot

At session initialisation, distinguish:

1. **Fresh blank compose** — no draft and no deliberately supplied audience filters;
   effective Current defaults are present but every category starts closed.
2. **Saved draft** — map its stored cohort/status filters to categories and open each
   selected category.
3. **Deliberately pre-populated compose** — map supplied initial audience filters in the
   same way.

This derivation runs once for the session. Later filter changes must not continuously force
categories open or closed.

### 5.3 Session-Only Explicit State

Maintain explicit category expansion as client state keyed by stable category identity.
Recursive tree nodes should receive their effective expansion and a toggle callback rather
than owning reset-prone default state independently.

After initialisation:

- user toggles update explicit state;
- one category never toggles another;
- a selected category may be manually collapsed;
- removing its final selection does not automatically collapse it;
- adding/removing selections elsewhere does not reset it; and
- no value is sent in create/update Email payloads.

## 6. Initial Disclosure Rule

Provide a pure, testable mapping equivalent to:

```text
deriveInitialExpandedCategories({
  compositionKind,
  initialFilters
})

if compositionKind == freshBlank:
  return empty set

otherwise:
  return category IDs represented by non-empty initialFilters
```

The mapping must cover every current picker category, including:

- Age Groups;
- Divisions;
- Clubs;
- League Roles;
- Club Roles;
- Club Officer Contacts;
- Referees;
- Venues;
- Team Status; and
- Club Status.

Unknown future filter types should fail safely closed in UI disclosure without removing or
changing their stored selection. If the picker already supplies an authoritative category
mapping, reuse it rather than creating a divergent list.

## 7. Collapsed Selected-State Summary

Every category header must remain truthful while collapsed:

- unselected category: no selected-state cue;
- one selected value: show its readable label where space permits, otherwise a truthful
  `1 selected` cue with accessible detail;
- multiple values: show a compact selected count, with readable detail available after
  expansion; and
- Team/Club status: expose the active status label/count so mandatory eligibility is not
  mistaken for being disabled.

Do not duplicate recipient totals on category headers. The existing node recipient counts
and resolved-recipient total retain their accepted meanings.

## 8. Search Behaviour

Search may temporarily disclose categories containing matching results. It must not mutate
the explicit session expansion set.

Effective disclosure should be equivalent to:

```text
explicitly expanded OR temporarily disclosed by active search
```

When search clears, each category returns to its explicit session state. A search must not
silently overwrite a user's earlier open/closed choice.

## 9. Presentation Order

Inside `CohortPicker`, render:

1. Additive Audience Sources heading and search;
2. Divisions category, including its Age Group/Division tree;
3. the conditional `For selected Divisions and Age Groups, include` control immediately
   after Divisions when a relevant structural source is selected;
4. Clubs and every remaining additive category; and
5. Audience Eligibility heading, explanation, Team Status and Club Status.

Pass the existing contextual control into the picker as a bounded presentation slot after
the authoritative `divisions` category. Do not duplicate recipient-type state or move its
business ownership out of `ComposeEmailModal`. Searching for another category may hide the
combined structural widget temporarily with its filtered category; clearing search restores
it without changing selections.

The exact spacing may follow the existing Mantine design language. Preserve the wording
that statuses restrict applicable sources and do not add recipients.

## 10. Responsive Layout

Replace fixed all-width `7/5` spans with responsive spans equivalent to:

```text
base/mobile: selector 12 columns, Selected Groups 12 columns
accepted desktop breakpoint: selector 7 columns, Selected Groups 5 columns
```

The exact breakpoint should use the existing Mantine theme and be verified at the actual
modal width. Do not retain two narrow columns merely because the viewport is nominally
tablet-sized.

On the stacked layout:

- selector comes first;
- Selected Groups follows at full width;
- empty wording says “Select groups above” or equivalent, not “left panel”;
- group name, selected count and Remove action remain clearly associated;
- rows/cards may wrap vertically;
- Remove controls remain touch-safe and visible;
- the full resolved-recipient badge remains legible; and
- no horizontal page or modal overflow is introduced.

## 11. Detailed Implementation Sequence

### Phase A — Pure State Contract

1. Define stable category identifiers/mapping.
2. Implement and unit-test fresh/draft/pre-populated initial disclosure.
3. Prove default Current filters do not open a fresh blank composition.
4. Prove stored Current filters do open a reopened draft's status categories.

### Phase B — Composition Identity And Controlled Expansion

1. Establish the stable modal-open session identity.
2. Pass the session boundary and initialisation context into `CohortPicker`.
3. Lift explicit expansion state above recursive tree nodes.
4. Ensure Save Draft's `currentDraftId` transition does not reset state.
5. Separate transient search disclosure from explicit state.

### Phase C — Order And Selected Summaries

1. Insert the existing Division/Age Group recipient-type panel directly after its structural
   category.
2. Render remaining additive sources and then eligibility.
3. Add truthful collapsed selection summaries.
4. Preserve existing selection controls, disabled zero-recipient behaviour and status help.

### Phase D — Responsive Reflow

1. Introduce full-width base Grid spans.
2. Select and validate the desktop split breakpoint.
3. Reflow Selected Groups headers/cards/actions for mobile.
4. Correct positional empty-state wording.

### Phase E — Verification And Confirmation

1. Run pure-state and existing selection tests.
2. Run communications-focused regression tests and type-check.
3. Run targeted lint and production build.
4. Create implementation confirmation only after implementation exists.
5. Promote only through the normal dev/staging/main corridor after explicit authority and
   accepted human evidence.

## 12. Automated Acceptance Matrix

At minimum, prove:

| Case | Expected result |
| --- | --- |
| Fresh blank LMSPro compose | Empty expanded-category set despite effective Current defaults |
| Fresh pre-populated Age Group | Age Groups open; unrelated categories closed |
| Reopened draft with Age Group, League Role and statuses | Those represented categories open; unrelated sources closed |
| Manual close of selected category | Remains closed during filter/count rerenders |
| Save assigns draft ID | Expansion state unchanged |
| Tab away/back | Expansion state unchanged |
| Search for closed category | Temporarily disclosed; explicit state restored after clear |
| Close/reset then fresh compose | Empty expanded-category set |
| Mobile layout | Full-width ordered regions with no forced horizontal overflow |
| F2.2 regression | Selections and resolved counts unchanged |

Use component-level rendering tests if the existing test environment supports them without
disproportionate harness work. The pure state model must be unit-tested regardless.

## 13. Authenticated Human UI Smoke

Run this matrix on local first. If a later control decision authorises staging, repeat it
against the exact staged commit. Use controlled content and Save Draft only where draft
reopening is required. Do not invoke provider Send.

1. Open a fresh blank Email and confirm every additive and eligibility category is closed.
2. Confirm Team Current and Club Current remain effective and are summarised while closed.
3. Open several categories, switch modal tabs and return; confirm the chosen state remains.
4. Change sources/statuses and wait for counts to refresh; confirm state remains.
5. Manually close a category containing selections; confirm it stays closed and summarises
   those selections.
6. Save the Email as a draft; confirm the same open session does not reset.
7. Close and reopen that draft; confirm categories represented by stored filters initialise
   open while unrelated categories remain closed.
8. Close the draft and open a fresh blank Email; confirm every category resets closed.
9. Search for a result in a closed category, then clear search; confirm explicit state is
   restored.
10. Select an Age Group or Division and confirm its `include` control appears immediately
    beneath Divisions and above Clubs/other additive sources.
11. Confirm changing those recipient types affects only the selected Division/Age Group
    source and the control disappears when no such source remains.
12. Confirm the complete Additive Audience Sources sequence appears above Audience
    Eligibility.
13. At a narrow mobile viewport, confirm selector then Selected Groups stack full width.
14. Confirm group names, counts and Remove controls are readable/tappable without horizontal
    overflow.
15. At an intermediate viewport, confirm the layout does not create two illegible columns.
16. At desktop width, confirm the useful `7/5`-style relationship remains.
17. Confirm selection, resolved-recipient and eligible Club-history counts match the same
    filters before and after responsive reflow.

## 14. Required Engineering Gates

- focused accordion-state tests;
- existing cohort-selection tests;
- communications/LMSPro communications regression suite;
- TypeScript check;
- repository critical-file verification;
- targeted changed-file lint;
- production build;
- diff check; and
- authenticated local human smoke in Section 13; and
- the same staging smoke only after a later explicit promotion decision.

No broad recipient send is required or permitted as R11-A evidence.

## 15. Stop Conditions

Stop and return to planning if:

- UI state appears to require schema/API persistence;
- saving a draft cannot retain session state without changing Email business data;
- category mapping requires a server/provider change;
- responsive work changes selected filters or counts;
- collapsed summaries cannot expose active required statuses accessibly;
- the proposed implementation touches F3 acknowledgement/provider behaviour; or
- the slice would delay the currently controlled Email `CR-Fix` without a roadmap decision.

## 16. Rollback

Rollback is a bounded application revert of R11-A. There is no database, migration or data
rollback. The prior `ec7e0cc4` recipient picker remains the semantic baseline.

## 17. Open Questions

None. Session-only UI state, selection-derived initial disclosure, fresh-blank closed
defaults, ordering and responsive behaviour are settled.

## 18. Implementation Authority Gate

R11-A is implemented with automated/build gates green. Test 7 initially exposed an
open-state/visible-content mismatch on draft reopen; the bounded zero-duration disclosure
correction then passed focused retest, completing the authenticated local matrix at 18/18.
The control owner authorised commit and promotion. Exact application commit `83356030` is
aligned through `origin/dev` and `origin/staging`; post-push public staging health is PASS.
Exact Render-build identification and the focused authenticated staging smoke remain the
next gate. No live promotion is authorised.
