# LMSPro CR Input — Recipient-Tab Accordion And Responsive Layout Refinement

Date: 2026-08-06

Planning status: **R11-A IMPLEMENTED; AUTOMATED/BUILD PASS; LOCAL AUTHENTICATED SMOKE 18/18
PASS; COMMITTED AT `83356030`; DEV AND ORIGIN/DEV MATCH; PROMOTED TO STAGING; STAGING
DEPLOYMENT/SMOKE PENDING**

Module: LMSPro / SeasonPro communications using the shared IsoStack Email composer

Source request: Refine the Recipients tab of the Email compose/send modal so all audience
accordions start closed, user-opened sections remain open for the current Email composition,
the Division/Age Group “include” control is presented directly with that structural cohort,
Audience Eligibility follows all Additive Audience Sources, and the selector/Selected
Groups layout becomes legible and usable on mobile.

Application evidence reviewed at: `ec7e0cc4c22ee9470534e8d09df1e402bbf0f81e`

Authoritative LMSPro roadmap:

`docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`

Related completed audience-integrity work:

`docs/modules/lmspro/04-implementation-confirmations/2026-08-05-lmspro-cr-fix-f2-2-current-season-eligibility-and-count-integrity-confirmation.md`

Related open Email `CR-Fix` and F3 follow-on:

`docs/modules/lmspro/01-cr-inputs/CR-Fix-2026-08-05-lmspro-cohort-email-draft-persistence-and-audience-selection.md`

Accepted triage:

`docs/modules/lmspro/02-triage/2026-08-06-lmspro-r11-a-recipient-tab-responsive-accordion-ui-triage.md`

Bounded slice plan:

`docs/modules/lmspro/03-slice-planning/2026-08-06-lmspro-r11-a-recipient-tab-responsive-accordion-ui-planning.md`

Local implementation confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-08-06-lmspro-r11-a-recipient-tab-responsive-accordion-ui-local-confirmation.md`

Local review and test summary:

`docs/modules/lmspro/05-review-and-test/2026-08-06-lmspro-r11-a-recipient-tab-responsive-accordion-ui-review-and-test.md`

## 1. Planning-Only And Non-Authorising Boundary

This document captures the source request and settled product decisions now reconciled by
the authoritative LMSPro control window into R11-A triage and bounded planning.

The CR, triage and plan do not by themselves:

- alter portfolio `Now` or `Next`;
- authorise application code, schema, migration, deployment or production-data work;
- create implementation, review, test, promotion or acceptance evidence; or
- reopen the accepted F2.2 audience algebra, counts, recipient authority or Send behaviour.

The control window has registered this CR, assigned bounded planning identifier R11-A and
recorded its non-displacing disposition. The current Email `CR-Fix` and its F3 follow-on
retain their existing authority and ordering unless a later control decision explicitly
changes them.

## 2. Purpose And Strategic Decision

The recipient picker now contains the correct audience concepts, but its default expansion
and desktop-first layout make the Recipients tab unnecessarily dense, particularly on a
narrow screen.

The settled presentation direction is:

```text
fresh blank Email composition
-> every recipient-picker accordion starts closed
-> mandatory Team Current and Club Current defaults remain selected but collapsed

saved draft or deliberately pre-populated composition
-> open each accordion containing stored/initial audience selections
-> do not persist a separate accordion-state field

user then opens or closes an accordion
-> retain that choice for the current open Email composition
-> do not lose it because counts refresh, filters change or the user changes modal tabs

next fresh blank Email composition
-> discard the prior composition's accordion state
-> start every accordion closed again

visual order
-> Additive Audience Sources:
   -> Divisions/Age Groups
   -> contextual “For selected Divisions and Age Groups, include” control
   -> Clubs and every remaining additive source
-> Audience Eligibility
-> Selected Groups in a responsive companion region
```

On desktop, the existing two-region selector/summary relationship may remain. On mobile,
the regions must stack into one legible flow rather than preserving two narrow columns.

## 3. Controlling Terminology

| Term | Meaning in this CR |
| --- | --- |
| Accordion | A category header that expands or collapses its recipient/status choices |
| Additive Audience Sources | Recipient-producing groups such as Age Groups, Divisions, Clubs, League Roles and Club Roles |
| Audience Eligibility | Team Status and Club Status controls which restrict applicable sources but do not add recipients |
| Selected Groups | The companion summary of selected recipient-producing source types and resolved-recipient count |
| Current composition session | One continuous open compose/edit-modal interaction for one Email, including modal tab changes and reactive recipient-count refreshes |
| Fresh blank Email | A new compose operation with no deliberately supplied audience filters beyond mandatory LMSPro Current defaults |
| Stored selection | A cohort/status filter loaded from a saved draft or deliberately supplied as an initial filter; it is business selection state, not accordion UI metadata |

Accordion expansion is presentation state. It must not change selected filters, recipient
types, effective statuses, provider recipients, Club histories or persisted Email content.

## 4. Existing Accepted Foundation

The following behaviour remains authoritative and must be preserved:

1. Additive sources add independently eligible audiences before global email-address
   deduplication.
2. Team Status and Club Status restrict only applicable sources and cannot create an
   audience by themselves.
3. Team Current and Club Current remain selected defaults on a fresh LMSPro Email.
4. At least one value remains selected in each required status dimension.
5. The Division/Age Group recipient-type control affects only those structural sources.
6. Preview, Save Draft and Send consume the same resolved audience.
7. The complete resolved recipient count remains visible.
8. F3 separately owns uploaded-file-only acknowledgement policy; this UI CR must not absorb
   or delay that policy work without an explicit roadmap decision.

Closing the status accordions by default hides their detail, not their active Current
defaults. The collapsed header should therefore continue to communicate enough state to
avoid implying that eligibility is inactive.

## 5. Current Implementation Evidence

Read-only review of the current application found:

- `CohortPicker.tsx` seeds `defaultExpandedIds` with `teamStatus`, `clubStatus`,
  `clubRoles` and `leagueRoles`, so those categories open by default;
- expansion is held locally by each tree node, but there is no explicit composition-level
  expansion contract or fresh-composition reset signal;
- search deliberately auto-expands categories containing matches;
- Audience Eligibility is rendered before the Additive Audience Sources search/tree;
- `ComposeEmailModal.tsx` uses fixed `Grid.Col span={7}` and `span={5}` columns for the
  selector and Selected Groups, so the two-column proportions do not collapse at a mobile
  breakpoint; and
- Selected Groups uses compact horizontal header/action arrangements that have insufficient
  width on narrow screens.

These findings support a bounded UI/state refinement. They do not indicate a need to
change the audience resolver, Email schema or provider delivery routes.

## 6. Included Scope

### 6.1 Closed Defaults

- Team Status starts collapsed.
- Club Status starts collapsed.
- Every Additive Audience Sources category starts collapsed.
- The selected Team Current and Club Current defaults remain active while hidden.
- A collapsed status header should expose a concise selected-state cue if necessary for
  truthful presentation, without reopening the section.

### 6.2 Composition-Scoped Expansion State

- On a fresh blank Email, all categories initialise closed; the mandatory Current defaults
  do not count as stored selections for this one initialisation case.
- When a saved draft or deliberately pre-populated composition loads, each category with a
  stored selection initialises open. This includes a status category whose values came from
  the saved draft.
- This selection-derived initial state is calculated once per composition session. It is
  not continuously reapplied after every selection change.
- Opening one accordion must not open unrelated accordions.
- User-opened and user-closed states persist while the same composition modal remains open.
- After initialisation, an explicit user open/close choice wins even when that category
  contains selections. A concise collapsed summary prevents those selections being hidden.
- State survives recipient selection changes, count refetches, search changes, modal-tab
  changes and ordinary React rerenders.
- Closing/resetting the modal and starting a fresh Email resets every accordion to closed.
- Search may expand matching categories as a direct consequence of the user's search. The
  bounded plan should distinguish that transient behaviour from the user's explicit
  open/closed choices so clearing search does not create confusing state loss.

### 6.3 Visual Order

Within the recipient-group selector, render:

1. Additive Audience Sources heading and search;
2. the Divisions accordion, which contains Age Group/Division choices;
3. immediately after that accordion, the conditional `For selected Divisions and Age
   Groups, include` control when one of those structural sources is selected;
4. Clubs and all remaining additive-source accordions; and
5. Audience Eligibility, containing Team Status and Club Status, after the complete
   additive-source sequence.

The Division/Age Group structural selector and its recipient-type choices form one logical
cohort widget. The contextual control must not sit after Audience Eligibility or below the
whole picker, because that presentation obscures which sources it modifies.

The control window may refine spacing and separators, but must retain the accepted product
labels and the explanation that statuses restrict rather than add recipients.

### 6.4 Responsive Selector And Selected Groups

- At a suitable desktop breakpoint, the picker and Selected Groups may retain their current
  side-by-side relationship.
- Below that breakpoint they stack at full width, with the picker first and Selected Groups
  second.
- The mobile layout must not rely on horizontal scrolling to read a group name, selected
  count or Remove action.
- Group labels and counts may wrap naturally.
- Remove controls must remain visible, comfortably tappable and associated with the correct
  group.
- The resolved-recipient badge must display its complete value without forcing the heading
  into an illegible line.
- Empty-state wording must describe the stacked layout without referring only to a “left
  panel”.

## 7. Responsive And Accessibility Principles

The eventual bounded plan should require evidence at representative narrow and wide widths,
not only a browser resize that leaves desktop proportions intact.

Acceptance principles:

- no clipped labels, counts, checkboxes, chevrons or Remove actions;
- no recipient-picker horizontal page overflow at the accepted mobile width;
- accordion controls expose accurate expanded/collapsed state to assistive technology;
- the whole category header and its explicit control behave consistently for keyboard,
  pointer and touch input;
- visible focus treatment remains intact;
- source/status distinctions remain understandable when every category is collapsed; and
- responsive reflow does not alter selections or expansion state during the same
  composition session.

## 8. Candidate Workstreams For Later Control-Window Planning

These are planning candidates, not executable slice identifiers:

1. **Expansion-state ownership** — replace pre-expanded defaults with explicit
   composition-scoped category state and a reliable fresh-compose reset boundary.
2. **Picker order** — combine the Division/Age Group accordion with its contextual
   recipient-type control, then render remaining additive sources and finally Audience
   Eligibility without changing source/status semantics.
3. **Responsive composition grid** — introduce base full-width columns and a deliberate
   desktop breakpoint for the selector/Selected Groups split.
4. **Mobile Selected Groups treatment** — reflow heading, count, labels and Remove actions
   into readable, touch-safe rows/cards.
5. **Focused evidence** — add component/state tests and authenticated desktop/mobile human
   smoke without exercising provider Send.

## 9. Explicit Non-Goals

This CR does not propose:

- changing cohort resolution, current-season scope, Team/Club status meaning or role
  authority;
- changing selected-filter persistence or saved Email recipient rows;
- changing default selected statuses or recipient types;
- changing manual recipients, CC/BCC, attachments, links, templates or delivery routes;
- adding new audience categories;
- changing recipient or Club-history count definitions;
- changing the whole Email modal outside the Recipients-tab responsive need; or
- creating a database field merely to store incidental UI expansion state without a
  separate product decision.

## 10. Risks And Controls

| Risk | Planning control |
| --- | --- |
| Collapsed statuses appear inactive | Preserve Current selections and provide a concise collapsed-state cue |
| Accordion state resets during a count query | Own state above reactive tree data and test refetch/filter changes |
| A fresh Email inherits prior expansion | Reset against an explicit composition identity/lifecycle boundary |
| Search expansion overwrites user choices | Model transient search disclosure separately from explicit expansion where necessary |
| Responsive reflow loses state or selections | Test live breakpoint changes during one composition |
| Mobile Remove action targets the wrong group | Retain stable typed filter keys and clear row association |
| UI work regresses F2.2 semantics | Reuse existing selection/resolver contracts and run focused regression coverage |
| Scope expands into durable draft metadata | Derive initial disclosure from stored business filters and keep later UI choices session-only |

Overall risk is **Low to Medium**: the requested behaviour is presentational, but careless
state ownership could reset selections, conceal active eligibility or leak expansion state
from one composition into the next.

## 11. Acceptance Principles

The later executable plan should prove at minimum:

1. a fresh Email opens with every source and eligibility accordion closed;
2. Team Current and Club Current remain selected and effective while collapsed;
3. a saved draft opens categories containing stored selections without persisting separate
   accordion metadata;
4. a deliberately pre-populated new composition opens its selected categories;
5. each category can be independently opened and closed;
6. explicit expansion state survives selecting/removing groups, eligibility changes,
   recipient-count refresh and switching away from/back to the Recipients tab;
7. manually closing a selected category keeps it closed for that session while its header
   summarises the active selection;
8. closing and opening a fresh blank Email resets every category closed;
9. the Division/Age Group recipient-type control appears immediately after its structural
   accordion and before Clubs/other additive sources;
10. the complete Additive Audience Sources sequence appears before Audience Eligibility;
11. desktop retains a useful selector/summary relationship;
12. mobile stacks the regions at full width with readable Selected Groups entries;
13. labels, complete counts and Remove controls remain legible and usable without horizontal
   overflow;
14. search disclosure is predictable and does not corrupt explicit state;
15. selection, preview and Save Draft counts remain unchanged from the accepted F2.2
    behaviour; and
16. UI-only smoke invokes no provider Send.

Suggested human evidence viewports are one narrow mobile width, one intermediate/tablet
width and one desktop width. Exact breakpoint values remain an implementation detail to be
selected against the existing Mantine theme and modal width.

## 12. Dependencies And Roadmap Implications

- F2.2 is the accepted semantic foundation and must not be weakened.
- The current Email `CR-Fix` remains portfolio `Now` through its recorded production/F3
  sequence; this CR does not displace it.
- FUND `1R-F-A` remains the root portfolio `Next` unless the authoritative control window
  deliberately changes that decision.
- This standard UI refinement is triaged and planned for later selection. A future control
  decision may deliberately combine it with a compatible Email UI slice, but registration
  and planning alone do not authorise either treatment.
- The authoritative LMSPro CR inventory now contains the direct source link and explicit
  R11-A disposition; later status changes must update that same row.

## 13. Settled Business Decisions

1. All Team Status, Club Status and additive-source accordions are closed by default.
2. An accordion remains in the user's chosen state during the same Email composition.
3. A fresh Email starts with all accordions closed.
4. Accordion UI state is session-only and requires no database/API persistence.
5. Saved or deliberately pre-populated selections determine which categories open when a
   composition session is initialised; mandatory Current defaults alone do not open a
   fresh blank Email's status categories.
6. A user's later manual open/close choice wins for that session, with active selections
   summarised on a collapsed header.
7. The Division/Age Group accordion and its conditional recipient-type control are presented
   as one combined structural cohort widget before Clubs and other additive sources.
8. The complete Additive Audience Sources sequence is presented above Audience Eligibility.
9. The desktop two-region layout becomes responsive rather than being forced onto mobile.
10. Selected Groups is presented as a readable full-width stacked region on mobile.
11. Existing audience meaning, selected defaults, counts and delivery behaviour are
   unchanged.

## 14. Open Business And Planning Questions

None. The control owner accepted session-only UI persistence and selection-derived initial
disclosure. Saved drafts reuse their stored business filters to decide which categories
open; they do not store or restore the user's previous manual accordion layout.

## 15. Control-Window Handoff

The authoritative control window should:

1. retain this source CR's explicit roadmap disposition without moving portfolio `Now` or
   `Next`;
2. retain the completed 18/18 authenticated local UI-smoke evidence;
3. complete the focused staging deployment and smoke gate for exact commit `83356030`; and
4. preserve F2.2 semantic regression gates and the no-provider-Send UI evidence boundary.

The control owner reported the corrected local candidate **18/18 PASS**. Application commit
`83356030` is exact across local `dev`, `origin/dev`, local `staging` and `origin/staging`.
The push to `origin/staging` triggered the staging deployment; exact deployed-build and
authenticated staging smoke evidence remain pending. `main` and `origin/main` remain at
`ec7e0cc4` and no live promotion is authorised.
