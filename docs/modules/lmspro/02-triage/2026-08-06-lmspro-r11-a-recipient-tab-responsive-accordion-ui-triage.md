# LMSPro R11-A — Recipient-Tab Accordion And Responsive Layout Triage

Date: 2026-08-06

Module: LMSPro / SeasonPro communications

Status: **IMPLEMENTED; AUTOMATED/BUILD PASS; LOCAL AUTHENTICATED SMOKE 18/18 PASS; COMMITTED
AT `83356030`; DEV/ORIGIN-DEV ALIGNED AND PROMOTED TO STAGING; STAGING SMOKE PENDING; NO
PORTFOLIO NOW/NEXT DISPLACEMENT**

Source CR:

`docs/modules/lmspro/01-cr-inputs/2026-08-06-lmspro-recipient-tab-responsive-accordion-ui-cr-input.md`

Bounded plan:

`docs/modules/lmspro/03-slice-planning/2026-08-06-lmspro-r11-a-recipient-tab-responsive-accordion-ui-planning.md`

Local confirmation and review:

`docs/modules/lmspro/04-implementation-confirmations/2026-08-06-lmspro-r11-a-recipient-tab-responsive-accordion-ui-local-confirmation.md`

`docs/modules/lmspro/05-review-and-test/2026-08-06-lmspro-r11-a-recipient-tab-responsive-accordion-ui-review-and-test.md`

Authoritative LMSPro roadmap:

`docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`

Accepted F2.2 foundation:

`docs/modules/lmspro/04-implementation-confirmations/2026-08-05-lmspro-cr-fix-f2-2-current-season-eligibility-and-count-integrity-confirmation.md`

## 1. Triage Outcome

Accept the request as a small bounded UI/usability slice, identified as `R11-A`, with no
server, schema, data, audience-resolution or provider-delivery work.

The slice is planning-complete only when its linked plan expresses:

- closed defaults for a fresh blank Email;
- selection-derived initial disclosure for saved/pre-populated Emails;
- session-only user expansion state;
- collapsed summaries that do not hide active selections;
- a combined Division/Age Group structural widget with its contextual recipient-type
  control immediately beneath that accordion;
- Additive Audience Sources before Audience Eligibility;
- responsive selector/Selected Groups layout; and
- F2.2 semantic regression protection.

The control owner subsequently authorised local implementation, reported all 18 local smoke
checks passing, and explicitly authorised commit plus staging promotion. Exact application
commit `83356030` is aligned through `origin/dev` and `origin/staging`. This bounded release
does not make R11-A portfolio `Now` or alter the root `Now`/`Next` pair.

## 2. Classification

| Dimension | Decision |
| --- | --- |
| Type | Standard UI refinement; not `CR-Fix` |
| Primary concern | Cognitive load and mobile usability in the Email Recipients tab |
| Severity | Low functional severity; Medium usability impact on narrow screens |
| Urgency | Normal |
| Tenant/data risk | Low if bounded; no intended data or authority change |
| Expedite | Rejected/not required |
| Current workaround | Desktop/wider viewport and manual accordion management |
| Delivery position | Planned candidate after the currently controlled Email `CR-Fix` sequence unless the root/child control explicitly changes |

The mobile layout is compromised, but the accepted recipient resolver and delivery path
remain operational. This does not meet the remedial-expedite threshold.

## 3. Accepted Business Rules

### 3.1 Fresh Blank Composition

A fresh blank Email starts with every eligibility and additive-source accordion collapsed.
Team Current and Club Current remain selected and effective, but those mandatory defaults
alone do not open their categories.

### 3.2 Stored Or Deliberately Initialised Selections

When an existing draft or deliberately pre-populated composition opens, categories
containing stored/initial filters open automatically. This is derived from existing
business selection state; no accordion metadata is persisted.

For a reopened draft, a stored Team/Club status selection is meaningful stored content and
therefore opens its status category. The special all-closed exception applies only to a
fresh blank composition's automatically supplied Current defaults.

### 3.3 User Choice During The Session

Initial disclosure is calculated once per composition session. After that:

- explicit user open/close choices win;
- choices survive tab changes, query refetches, selection changes and rerenders;
- manually closing a category containing selections is allowed;
- its collapsed header summarises active selections; and
- a new fresh composition discards the prior session's UI state.

Saving a draft does not turn accordion expansion into stored Email data. Reopening the
draft derives a new initial state from its stored cohort/status filters.

## 4. Evidence And Prior Decision

Read-only application review at `ec7e0cc4` confirms:

- `CohortPicker.tsx` currently defaults Team Status, Club Status, Club Roles and League
  Roles open;
- expansion is local to recursive tree nodes and lacks a composition reset/initialisation
  contract;
- Audience Eligibility renders above Additive Audience Sources;
- search auto-expands matching categories; and
- `ComposeEmailModal.tsx` uses fixed `7/5` Grid spans for the selector and Selected Groups.

Historical R4-B3/R4-004 deliberately opened Club Roles and League Roles by default. R11-A
supersedes only that presentation default. It must preserve R4-B live-role accuracy and the
later F2.1/F2.2 taxonomy, authority and audience-resolution corrections.

## 5. Scope Decision

### Included

- client-side accordion initialisation and session state;
- collapsed selected-state summaries;
- ordering of additive and eligibility blocks;
- placement of the Division/Age Group recipient-type control inside the additive sequence,
  immediately after its structural accordion and before Clubs;
- responsive Grid behaviour and mobile Selected Groups presentation;
- wording that remains accurate in stacked layouts;
- keyboard/touch/assistive-state behaviour; and
- focused automated and human UI regression evidence.

### Excluded

- database/API fields for accordion state;
- changes to cohort filters, defaults, resolver algebra or recipient counts;
- provider Send, batching, attachment or F3 acknowledgement behaviour;
- general modal redesign;
- new audiences or role semantics; and
- roadmap displacement or implementation authority.

## 6. Risk Assessment

| Risk | Rating | Required control |
| --- | --- | --- |
| Fresh Current defaults reopen eligibility | Medium | Treat them as the explicit fresh-blank initialisation exception |
| Saved selections are concealed | Medium | Derive initial open categories and provide collapsed summaries |
| Saving changes `currentDraftId` and resets UI | Medium | Use a stable open-session identity that does not change after Save Draft |
| Tree/query rerender loses expansion | Medium | Lift explicit expansion state above recursive nodes |
| Search corrupts manual state | Low/Medium | Keep transient search disclosure separate from explicit expansion |
| Mobile controls clip or become ambiguous | Medium | Full-width base layout and representative viewport evidence |
| F2.2 recipient semantics regress | High impact/Low likelihood | No resolver changes and focused count/selection regression gates |

Overall triage risk is **Low to Medium** and suitable for one bounded UI slice.

## 7. Dependencies And Ordering

1. F2.2 remains the accepted audience-semantic foundation.
2. The open Email `CR-Fix` retains portfolio `Now` through its production/F3 sequence.
3. FUND `1R-F-A` remains root portfolio `Next`.
4. R11-A received explicit bounded implementation and staging-promotion authority without
   displacing the authoritative portfolio `Now`/`Next` pair.

Combining R11-A with another later Email UI slice is permissible only if a future accepted
plan preserves its state and responsive acceptance matrix. It must not be casually folded
into F3 if that would expand or delay F3's uploaded-file policy outcome.

## 8. Triage Exit Decision

Proceed to the linked bounded R11-A plan. The plan may identify exact client files, pure
state helpers, tests and human-smoke gates. It may not authorise implementation or change
portfolio order.

## 9. Open Questions

None. The control owner has settled session-only expansion persistence and
selection-derived initial disclosure.
