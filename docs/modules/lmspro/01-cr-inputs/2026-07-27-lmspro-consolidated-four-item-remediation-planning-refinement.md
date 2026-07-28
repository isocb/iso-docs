# LMSPro Consolidated Four-Item Remediation Planning Refinement

Date: 2026-07-27

Module: LMSPro / SeasonPro using the shared IsoStack communications service

Status: Planning refinement accepted through formal programme triage; business answers
reconciled; four separately bounded R9 child lifecycles recorded; `R9-A0` selected as
read-only Item 3 inventory; no application implementation authorised

Source CR:

`docs/modules/lmspro/01-cr-inputs/2026-07-22-lmspro-consolidated-email-integrity-club-visibility-and-remedial-work-cr-input.md`

Authoritative roadmap:

`docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`

Related accepted foundations:

- `docs/modules/lmspro/03-slice-planning/2026-07-06-lmspro-remediation-slice-r4-b-communications-email-announcements-workflow-planning.md`;
- `docs/modules/lmspro/03-slice-planning/2026-07-20-lmspro-remediation-slice-r8-a-attachment-aware-email-delivery-route-and-fail-closed-evidence-planning.md`; and
- the completed R8-A subordinate planning, implementation, review, staging and live records.

## 1. Authority And Lifecycle Boundary

This refinement converts the completed four-item CR input into a coherent candidate delivery
shape for later reconciliation by the separate control window.

Where the source CR's earlier automatic Waiting List assumptions conflict with the reconciled
business decisions in sections 19 and 20, this later refinement controls formal triage.

It:

- preserves the four business briefs as one coordinated planning envelope;
- identifies dependencies, ordering, risk gates and candidate workstreams;
- separates accepted foundation, settled decisions, planning recommendations and mandatory
  planning/data gates; and
- prepares the CR for formal triage and bounded slice planning.

It does not:

- make the formal `02-triage` accept, defer or split decision;
- assign an executable remediation-slice identifier;
- select the next roadmap slice;
- authorise application code, schema, migrations, infrastructure or live-data work;
- change the authoritative roadmap or its current status;
- create implementation, review, test, promotion or deployment evidence; or
- include the C1 League dashboard reorganisation formerly expected as a fifth item.

The C1 League dashboard reorganisation is a standalone piece of work. It requires its own CR,
triage and planning lifecycle and must not be inferred into any of the four workstreams below.

## 2. Purpose And Strategic Delivery Decision

The four-item plan is:

1. **Club dashboard email visibility and history integrity**;
2. **attachment dropzone click-to-browse regression**;
3. **Club admission, current participation and waiting-list alignment**; and
4. **responsive Team status and waiting-list-position visibility**.

The planning decision is to retain these four items in one coordinated remediation envelope
because they share LMSPro Club, Team, communications, C1/C2 and seasonal-operating boundaries.

That coordination does not require one indivisible production release. The four items have
materially different risk profiles:

- items 2 and 4 are focused user-interface corrections with no intended schema or business-state
  mutation;
- item 1 introduces a new access-bearing Email-to-Club visibility contract and current-season
  reconciliation considerations; and
- item 3 changes the meaning and convergence of live Club, Team, division and season state and
  therefore requires the strongest data-safety controls.

The later control window should preserve one triaged four-item programme while selecting small,
separately reviewable implementation boundaries. Item 3 must not be bundled into a low-risk UI
release merely because all four concerns share this planning envelope.

## 3. Evidence Classification

### 3.1 Existing Accepted Foundation

- R4 remains the accepted shared email composition, cohort, draft, duplication, sent-history and
  Club dashboard communications foundation.
- R8-A is complete through staging and live and remains the accepted attachment persistence,
  validation, acknowledgement, fail-closed delivery, provider routing, rate limiting, retry and
  status foundation.
- Current LMSPro tenancy, Club, Team, season and C1/C2 permission boundaries remain controlling
  unless a later accepted slice changes them explicitly.
- Current waiting-list positions remain server-calculated evidence scoped to the applicable age
  group.

### 3.2 Settled Business Direction

- The consolidated CR contains four items, not five.
- The C1 League dashboard reorganisation will be handled separately.
- Delivery-recipient identity and Club-history visibility are different authorities.
- Club admission and seasonal participation are different authorities.
- A Club is Current only when it has at least one same-season Team that is both `CURRENT` and
  validly division/AGG allocated.
- A Team becomes Waiting List only through a conscious status decision. An unallocated Team is
  distinct, remains important to Division Manager allocation work and is excluded from Current
  counts.
- An admitted Club with no qualifying Current/allocated Team is a Waiting List Club even when one
  or more of its Teams remains unallocated rather than individually wait-listed.
- A Registered Club is a proven/admitted Club with a primary C2 representative and may contain
  Current, unallocated or consciously wait-listed Teams. Registration does not imply Current.
- Waiting List is not suspension or withdrawal and does not undo onboarding or C2 access.
- Waiting-list status words and available position/total must remain visibly readable at narrow
  widths.
- Drag-and-drop and click/keyboard browse must coexist on the attachment control.
- Each C2 Club-history context requires an authoritative primary recipient for that Club.
- Each season is discrete for C2 Email history; no season-to-season history carry-forward is
  required.

### 3.3 Planning Recommendations

- Materialise explicit Email-to-Club visibility from authoritative audience context.
- Keep provider-address deduplication while retaining every authorised Club context.
- Prefer additive and compatibility-safe persistence changes.
- Use deterministic dry-run inventory before any current-season or live-state reconciliation.
- Share Team-status presentation semantics across the League and Club Team pages.
- Keep item 2 and the presentation-only part of item 4 independently releasable.
- Settle item 3 terminology before item 4 introduces any new status labels.
- Use a desktop-first current-and-previous-major Chrome/Edge acceptance baseline for item 2, with
  current Firefox and Safari smoke where those browsers are used.
- Use content-driven responsive behaviour for item 4, provisionally stacking the row at 767 px and
  below, using a compact/intermediate layout from 768-1023 px and retaining the full table at
  1024 px and above.

### 3.4 Dependencies And Implications

- Item 1 depends on accepted delivery-outcome terminology and complete Email creation/send-path
  inventory.
- Item 3 may change the business cohorts used by communications, dashboards and operational
  selectors; item 1 must not hard-code the current overloaded meaning of `ClubStatus.APPROVED`.
- Item 4 may correct clipping against current values before item 3 is implemented, but it must not
  independently redefine Current, Approved or Waiting List.
- Item 1 requires tenant-, season- and Club-safe current-season treatment. Item 3 has no historic
  season to rewrite because this is the first operational season.
- Item 2 must consume R8-A contracts without reopening them.
- Three canonical routes create valid Registered/admission evidence: completed validated
  SeasonPro import; the linked two-stage registration form after email validation and
  authorised C1 approval; and deliberate direct creation by an authorised C1 tenant user.
  None sets the Current-compatible `ClubStatus.APPROVED` merely because registration is
  complete. The Club also needs a qualifying Current/allocated Team; otherwise the admitted
  Club is a Waiting List Club.

## 4. Ownership And Product Boundaries

| Area | Controlling ownership | C1 impact | C2 impact | Public / Commerce / FUND |
| --- | --- | --- | --- | --- |
| Item 1: Email visibility | Shared communications persistence plus LMSPro Club authority | Audience explanation, manual linking and operational history | Authorised Club history and detail access | No Commerce or FUND change; no public email exposure |
| Item 2: Attachment browse | Shared compose UI under completed R8-A policy | Pointer and keyboard attachment selection | None | No Commerce, FUND or public-surface change |
| Item 3: Club participation | LMSPro admission, Club, Team, division and season authority | Approval, allocation, counts, filters, cohorts and overrides | Club access, Team requests and truthful participation state | Public directory eligibility must be inventoried if it consumes Club status; no Commerce or FUND change |
| Item 4: Team status visibility | LMSPro League and Club Team presentation | League Team table | Club Team table | No Commerce, FUND or public-surface change |

C1 means the authorised League administrative context. C2 means the authorised Club context.
C1 hat-swap or roleplay access must use the same resolved Club boundary as genuine C2 access and
remain visibly distinguishable and audited under existing controls.

## 5. Consolidated Included Scope

The candidate four-item programme includes:

- explicit Email-to-Club many-to-many visibility;
- authoritative audience aggregation before provider-address deduplication;
- consistent parent/recipient delivery-result reconciliation;
- unique-Email Club-history pagination and aligned list/detail permission checks;
- deterministic current-season visibility audit and bounded reconciliation planning;
- attachment dropzone pointer and keyboard browse restoration;
- preservation of R8-A validation, persistence, acknowledgement and delivery behaviour;
- separation of durable Club admission from seasonal participation;
- Team-status and division-allocation convergence;
- admitted, Current, Waiting List and operational cohort alignment;
- season-clone and roll-forward participation rules;
- live-data inventory, dry-run, compatibility and rollback planning;
- shared responsive Team-status presentation across C1 and C2; and
- automated, browser, accessibility, staging and production verification proportionate to each
  workstream's risk.

## 6. Consolidated Excluded Scope

The candidate programme excludes:

- the standalone C1 League dashboard reorganisation;
- changes to R8-A provider routing, private R2 policy, file allowlist, three-file/10 MB limits,
  three external-link limit, rate limiting or retry;
- key-date sequence attachment authoring;
- a separate LMSPro-only email service;
- mailbox-open/read tracking;
- raw email-address matching as Club access authority;
- mutation of immutable sent Email content or historic provider evidence;
- broad Announcement redesign;
- automatic exposure of BCC addresses or another Club's recipient evidence;
- revocation of onboarding merely because a Club has no allocated Team;
- deactivation of Club officials merely because a Club becomes Waiting List;
- changing Team waiting-list order or its server calculation;
- broad redesign of unrelated LMSPro pages;
- destructive or ambiguous production-data backfill;
- Commerce, FUND, Platform or public-site expansion; and
- roadmap, implementation, deployment or lifecycle-status changes from this refinement.

## 7. Controlling Terminology

### Email Recipient

One deduplicated provider-delivery destination and its delivery outcome. It does not by itself
grant a Club access to an Email.

### Email-to-Club Visibility Association

An explicit same-tenant record that one Club is authorised to retain and display one Email in its
C2 history. One Email may be visible to several Clubs and one Club may see several Emails.

### Admitted Club

A Club whose onboarding/admission decision is approved, including a direct/imported Club with
equivalent explicit auditable admission evidence.

### Registered Club

A proven/admitted Club with a primary C2 representative who can sign in and receive authorised
updates. It has indicated that Teams are intended for one or more age groups. It may have Current,
unallocated or consciously wait-listed Teams, including zero Current Teams. Registration does not
mean Current or `APPROVED`.

### Current Club

A Registered, non-overridden Club with at least one same-tenant, same-season Team whose status is
`CURRENT` and whose division/AGG allocation is valid for that tenant and season. The business
prefers `ClubStatus.APPROVED` to remain the compatibility representation of this Current state.

### Unallocated Team

A Team retained for planning and Division Manager allocation work without a valid division/AGG
allocation. It is excluded from Current Team and Current Club counts. It is not automatically
Waiting List.

### Waiting List Club

A Registered Club with no qualifying same-season Current/allocated Team. This Club aggregate does
not convert its unallocated Teams to Team Waiting List: each Team remains unallocated unless an
authorised conscious Team Waiting List decision is made. Club Waiting List does not mean
suspended, withdrawn or unadmitted.

### Provider Accepted

The provider accepted the delivery request. It is not proof of inbox delivery or human reading.

### Visible Waiting-List Position

The readable Team position and total, such as `3 of 12`, shown directly with the Waiting List
status rather than available only through colour, hover or tooltip.

## 8. Candidate Workstream 1 - Club Email Visibility And History Integrity

### 8.1 Goal

Give each authorised C2 Club one stable history row for every successfully issued Email that was
explicitly in that Club's audience, without duplicate provider delivery or exposure of another
Club's communication.

### 8.2 Prospective Persistence Contract

Later schema planning should define an additive association equivalent to:

```text
Email 1 ---- * Email-to-Club visibility * ---- 1 LMSProClub
```

The association should retain:

- organisation/tenant identity;
- Email identity;
- Club identity;
- controlled source or reason;
- source entity/workflow evidence where useful;
- creation/finalisation timestamp; and
- durable audit evidence.

The later plan must define same-tenant referential enforcement, effective uniqueness for
`Email + Club`, handling of multiple source reasons and deletion/retention behaviour.

### 8.3 Prospective Audience Materialisation

Inventory and align every Email creation/finalisation path, including:

- manual recipients with explicit Club or Team linkage;
- direct Club and Team cohorts;
- Club-role cohorts;
- Announcement-targeted Club audiences;
- ordinary sequences;
- key-date sequences; and
- other current LMSPro Email paths discovered during the inventory.

Resolve all authorised Club contexts before provider-address deduplication. One address may receive
one provider message while supporting several Club visibility associations. A User representing
several Clubs should see the Email independently in each authorised Club context. Authoritative CC
context may contribute a Club association, but a raw CC address is not authority and BCC remains
private. Every Club context must still have an authoritative primary recipient.

### 8.4 Delivery Reconciliation

Ad-hoc, ordinary sequence and key-date sequence paths should use one accepted delivery-result
contract that:

- preserves workflow identity separately from audience identity;
- reconciles parent Email and recipient outcomes;
- prevents queued, failed or retried attempts from appearing as successfully issued by default;
- never duplicates a previously accepted recipient during retry; and
- applies the accepted C2 visibility threshold consistently.

### 8.5 C1 And C2 Experience

C1 should see before finalisation:

- deduplicated provider-recipient count;
- exact intended Club-history audience;
- unlinked manual recipients;
- the consequence that an unlinked manual address will not appear in C2 history; and
- unresolved audience warnings that fail closed.

C2 should receive:

- one row per authorised Email;
- stable newest-first unique-Email cursor pagination;
- accessible progressive loading or `Load more`;
- clear loading, retry and end-of-history states;
- scroll-position preservation when opening and closing detail; and
- no recipient summary, BCC list, cross-Club recipient evidence or unrestricted organisation
  history.

The planning default is 50 unique Emails per page because that preserves the current initial scale
while correcting recipient-row pagination into Email pagination. The control must provide an
accessible explicit `Load more` action rather than requiring infinite scroll.

### 8.6 Permissions

List and detail must share the same server-side authority:

```text
same tenant
+ authorised current/effective Club context
+ exact Email-to-Club visibility association
-> list or open Email
```

Team-derived access must prove that the Team belongs to the authorised Club. Possession of an Email
or recipient UUID is never sufficient.

### 8.7 Current-Season Treatment And Retention

Each season is discrete. No association or communication history carries into a successor-season
Club dashboard and no season-to-season historic backfill is required. Begin with a read-only
inventory of the current operational season only. Deterministic candidate sources include direct
Club recipients, Team recipients resolved to their recorded Club, explicit linked Club/Team fields
and durable workflow evidence.

Do not infer current-season access from mutable contact addresses, names or current User
memberships. Ambiguous rows should remain absent or enter an authorised review report. Email
content, provider evidence and recipient outcomes remain immutable.

C2 may reopen retained attachments and shared links only while the Email remains available in that
season. C2 history and attachment/link access expire at season expiration under the standard
retention policy. The system can expire its own visibility and private-download authority but
cannot force an externally hosted shared link to expire; it must stop presenting that link after
the season boundary. Immutable provider and audit evidence remains governed separately by the
platform retention policy.

### 8.8 Workstream Acceptance

- Every C2-visible Email has explicit same-tenant Club authority.
- Shared addresses retain all intended Club contexts without duplicate provider delivery.
- Each Club sees one row per Email.
- Pagination continues beyond the initial 50 unique Emails without gaps or duplicates.
- Ad-hoc and sequence delivery evidence reconciles consistently.
- List and detail deny other-Club and cross-tenant access.
- Current-season reconciliation is deterministic, auditable and non-destructive.
- One User with several authorised Club contexts sees the Email in each applicable context without
  duplicate provider delivery.
- C2 recipient identities remain hidden and retained resources cease to be available after season
  expiration.

## 9. Candidate Workstream 2 - Attachment Click-To-Browse

### 9.1 Goal

Restore the attachment zone's truthful combined interaction:

```text
drag an accepted local file
OR
activate the same zone by pointer or keyboard to browse
```

### 9.2 Investigation Gate

Reproduce the defect in supported browsers before selecting a correction. Inspect:

- Mantine Dropzone activation props and version/runtime behaviour;
- disabled and loading state transitions;
- overlays and pointer-event interception;
- nested remove/link controls;
- focus and keyboard activation; and
- duplicate picker activation while files are being processed.

No candidate cause is accepted without runtime evidence.

### 9.3 Preserved R8-A Contracts

The correction must preserve:

- the accepted PDF/image/text allowlist;
- maximum three uploads and 10 MB cumulative content;
- private R2 storage;
- validation and explicit C1 responsibility acknowledgement;
- exact draft, reopen and duplicate-to-draft resource evidence;
- fail-closed delivery preflight;
- separate external HTTPS shared-document links; and
- no-attachment batch behaviour.

### 9.4 Interaction And Accessibility

- Pointer activation opens exactly one local picker.
- Enter/Space or the accepted keyboard interaction opens the same picker.
- The control has a programmatic name and visible focus.
- Loading/disabled text is truthful and temporary.
- Remove and adjacent link actions do not open the picker.
- Dropped and browsed files enter the same validation path and appear once.

The production acceptance baseline is desktop-first because this is an internal operational tool:

- current and previous major Chrome and Edge on supported desktop operating systems;
- current Firefox as a secondary desktop check;
- current Safari on macOS where League operators use it; and
- pointer plus keyboard coverage at the normal supported desktop widths.

This is restoration of the existing `Drag files here or click to browse` contract, not new
functionality. A separate internal browse button is required only if runtime evidence shows the
Dropzone itself cannot provide reliable pointer and keyboard activation with an accessible name.

### 9.5 Workstream Acceptance

- Click, keyboard and drag-and-drop all work in new, saved, reopened and duplicated drafts.
- Rejections and limit breaches remain understandable and safe.
- Processing cannot trigger duplicate selection or leave the control permanently inert.
- R8-A attachment delivery, external-link and no-attachment regressions pass.

## 10. Candidate Workstream 3 - Club Admission And Seasonal Participation

### 10.1 Goal

Preserve durable admission while deriving truthful seasonal Club participation from valid Team
allocation evidence.

### 10.2 Domain Contract

```text
registered/admitted Club
+ at least one same-tenant, same-season CURRENT Team
+ valid same-tenant, same-season division/AGG allocation
+ no Suspended/Withdrawn override
= Current Club
= ClubStatus.APPROVED compatibility representation

registered/admitted Club
+ zero qualifying CURRENT Teams
= Waiting List Club
+ retain its distinct unallocated and consciously wait-listed Team evidence
```

The Application approval decision remains immutable admission evidence. Team placement must not
reopen or revoke onboarding. Zero qualifying Current Teams makes the admitted Club a Waiting List
Club, but it does not automatically make every Team Waiting List. Unallocated Teams remain
distinct in-process allocation evidence until an authorised Team status decision is made.

All three accepted instantiation routes require durable admission evidence:

- completed validated SeasonPro import records import/source identity and controlled-system
  authority;
- the linked two-stage form records email validation followed by the authorised C1
  Application approval decision; and
- direct C1 creation records the authorised tenant actor and deliberate registration
  decision.

Each route must retain its tenant, season, timestamp and primary C2 representative evidence.
Email validation alone, an unreviewed submission, bare row creation or Team presence is not
admission evidence. A Registered/admitted Club uses the Current-compatible
`ClubStatus.APPROVED` only when it also has a qualifying Current/allocated Team; otherwise
its Club participation state is Waiting List.

### 10.3 Team Invariant

The preferred target is:

```text
Team CURRENT
-> valid same-tenant, same-season division/AGG allocation

Team WAITING_LIST
-> explicit authorised wait-list decision

Team unallocated
-> retained for allocation work
-> excluded from Current counts
-> not automatically WAITING_LIST
```

The current reviewed-but-unallocated state remains part of the Division Manager workflow. Later
bounded planning must preserve that operational distinction while eliminating or explicitly
translating contradictory `CURRENT + aggId null` rows. No unallocated Team may be silently changed
to Waiting List.

### 10.4 Writer Inventory

Inventory and align every retained writer, including:

- Application approve, wait-list and reject;
- direct Club creation and import;
- Team registration and approval;
- allocation, reallocation and de-allocation;
- bulk Team status changes and generic Team edit;
- wait-list, suspension, withdrawal, cancellation, no-response, inactive and aged-out paths;
- age-group changes that clear allocation;
- deletion and other terminal operations;
- season clone, continuation and roll-forward; and
- authorised Club suspension, withdrawal and reinstatement.

Team mutation and Club reconciliation must be idempotent and concurrency-safe. Where participation
state is persisted, the mutation and reconciliation should share one transaction or an
equivalently strong repairable contract.

### 10.5 Consumer Inventory

Define every consumer by business cohort rather than by an overloaded enum label:

- Admitted Clubs;
- Registered Clubs;
- Current Clubs;
- Waiting List Clubs (Registered/admitted Clubs with zero qualifying Current/allocated Teams);
- Clubs with unallocated Teams;
- Current Teams;
- all operational/non-terminal Clubs; and
- purpose-specific suspended/withdrawn cohorts.

Consumers include:

- C1 Club lists, editors, filters, badges and statistics;
- dashboards and counts;
- C2 Club access and Team-request guards;
- Club and Team communication cohorts;
- key-date and Announcement selectors;
- public/directory eligibility where applicable;
- reporting and audit; and
- season clone and roll-forward.

### 10.6 Live-Data Safety

Before schema or behaviour changes:

1. Produce tenant- and season-scoped read-only counts for every relevant Club/Application/Team/
   allocation combination.
2. Separate deterministic states from ambiguous or contradictory records.
3. Avoid personal contact data in reports.
4. Define an additive or expand/contract compatibility sequence.
5. Provide a dry-run-by-default, bounded and idempotent reconciliation design.
6. Prove Club Waiting List and Team unallocated/Waiting List states preserve Club-official access,
   Team requests and required communications.
7. Rehearse against representative disposable PostgreSQL data and an authorised production-like
   dataset.
8. Record schema/code/reconciliation ordering, recovery point, rollback boundary and go/no-go
   evidence before live mutation.

No destructive semantic backfill, closed-season rewrite or silent resolution of ambiguity is
acceptable.

### 10.7 Season Continuity

Destination-season participation must be derived from destination-season allocations. A source
Club's Current value must not be copied as authority where the destination Club has no qualifying
Team. This is the first operational season, so no historic closed-season data rewrite is required;
future source-season history must remain unchanged.

### 10.8 Workstream Acceptance

- Approved onboarding remains approved.
- A Registered Club with no qualifying Team is a Waiting List Club without automatically
  converting its unallocated Teams to Team Waiting List.
- The first qualifying Team makes the Club Current.
- The last qualifying Team ceasing to qualify makes the Club Waiting List while preserving each
  Team's distinct unallocated or consciously wait-listed evidence.
- Suspended/Withdrawn overrides cannot be silently reversed.
- Registered Waiting List Club officials retain authorised access and Team-request capability,
  including while their Teams remain unallocated.
- No `CURRENT` Team remains unallocated under the accepted final contract.
- Counts, filters, editors, cohorts and season rollover use named business definitions.
- An actual automatic Club Current/Waiting List transition may create a Club notification
  through the existing Notification Manager. User-triggered CRUD behaviour continues to
  respect its existing on-CRUD notification control; automatically derived behaviour falls
  back to Notification Manager. Its master and per-event switches, platform-default or
  tenant-custom content and existing recipient-routing contract remain authoritative.
- Re-evaluation without a category change, evidence-only inventory and dry-run must not
  send. Bulk reconciliation notification behaviour requires its own explicit promotion
  decision and must not silently inherit the ordinary live-transition trigger. Later
  implementation planning must define transition-event idempotency and delivery/audit
  evidence before automatic sending is enabled.
- Production reconciliation is measured, deterministic, idempotent, auditable and recoverable.

## 11. Candidate Workstream 4 - Responsive Team Status Visibility

### 11.1 Goal

Keep Team identity, age group, division state, full status wording and available waiting-list
position readable on both the C1 League Teams and C2 Club Teams surfaces at every supported width.

### 11.2 Shared Presentation Contract

Both surfaces should share, where practical:

- status label and colour mapping;
- waiting-list position formatting;
- complete accessible status text;
- non-clipping status-pill behaviour;
- narrow-layout/column-priority rules; and
- representative responsive regression fixtures.

The settled compact visible value is `Waiting List 3/12`; its accessible name must communicate
`Waiting List, position 3 of 12`. Tooltip content may add explanation but must not be the only
source.

### 11.3 Narrow-Width Priority

Preserve first:

1. Team/Club identity as applicable;
2. age group;
3. status and available waiting-list position; and
4. division or **Unallocated**.

Team number, Free Days, manager contact, notes, change-request indicators and secondary links may
move into accessible row detail. A compact stacked row/card is preferred at phone widths. An
explicit table scroll area may be a supported intermediate fallback but not the only mobile
design.

The planning baseline is:

- up to 767 px: stacked row/card;
- 768-1023 px: compact table or hybrid layout with lower-priority fields in row detail; and
- 1024 px and above: full table.

The breakpoint is content-driven: implementation may move it slightly where representative long
values prove that the four priority fields cannot remain readable. Lower-priority fields should
use one shared, explicit, keyboard-operable `More details` row disclosure on both surfaces rather
than relying on hover.

### 11.4 Accessibility And Responsiveness

- Never ellipsise or clip the status words.
- Do not shrink the status below an accepted accessible text size.
- Reserve status width before truncating long division names.
- Make full truncated division text discoverable through accessible detail.
- Preserve keyboard row/detail behaviour.
- Test 320, 375, 390/430, 768, 1024 and 1280 CSS-pixel viewports plus 200% zoom.
- Cover the current and previous major releases of Chrome, Edge, Firefox and Safari, including
  current iOS Safari for the phone-width contract.
- Test long Team, Club and division names and every current status value.

### 11.5 Scope Guard

This workstream does not change:

- Team status or waiting-list order;
- division allocation;
- waiting-list position calculation;
- Team number or Free Days behaviour;
- schema, migrations or server authority; or
- the item 3 domain decision.

If delivered before item 3, it should improve layout against the existing status contract without
inventing future terminology.

### 11.6 Workstream Acceptance

- Full Waiting List text and available position/total remain visibly readable.
- Status cannot collapse, clip or overlap at supported widths or 200% zoom.
- Lower-priority evidence remains accessible after leaving the summary row.
- C1 and C2 Team surfaces use equivalent status semantics and presentation.
- No Team, division, waiting-list or permission behaviour changes.

## 12. Candidate Ordering And Gates

These are strategic stages, not executable slice identifiers.

### Stage A - Control-Window Triage And Decision Closure

- formally accept one four-item programme and create separately bounded implementation slices;
- settle which unresolved decisions block each workstream;
- preserve the requested decreasing-complexity order: item 3, item 1, item 4, then item 2, while
  allowing read-only discovery and reproduction to proceed independently;
- select separately reviewable implementation boundaries; and
- reconcile the chosen order with the authoritative roadmap.

### Stage B - Read-Only Inventory And Reproduction

- inventory all Email creation/send paths for item 1;
- reproduce the Dropzone defect for item 2;
- inventory all item 3 writers, consumers and live-data state combinations; and
- capture representative responsive fixtures for item 4.

### Stage C - Independent Presentation Corrections

- item 2 may proceed once the runtime cause and preserved R8-A regression boundary are proven;
- item 4 may proceed against current terminology once it is explicitly prevented from deciding
  item 3 semantics; and
- each correction should retain separate review and rollback evidence.

### Stage D - Email Visibility Foundation And Prospective Writers

- accept the visibility threshold and source contract;
- introduce compatibility-safe visibility persistence;
- populate prospective ad-hoc/cohort/sequence paths;
- align unique-Email list/detail permission and pagination; and
- exclude cross-season association while reconciling only deterministic current-season evidence.

### Stage E - Participation Compatibility And Controlled Reconciliation

- settle persistence and terminology;
- add compatibility code and complete the consumer/writer alignment;
- run dry-run inventory and authorised reconciliation;
- enforce the final Team/Club invariants only after contradiction counts converge; and
- use separate production data go/no-go and rollback controls.

## 13. Schema, Migration And Historic Implications

### Item 1

Likely additive persistence is required. Later planning must define naming, keys, indexes,
same-tenant enforcement, association-source evidence, backfill strategy and unique-Email cursor
performance. Current-season association must not rewrite Email content or delivery evidence, and
no association carries into a successor season.

### Item 2

No schema, migration or historic-data change is expected.

### Item 3

The business meaning is settled: `ClubStatus.APPROVED = Current`; completed validated
import, approved two-stage form registration and authorised direct C1 creation are the
three valid Registered/admission routes; and a Registered Club with no qualifying
Current/allocated Team is Club Waiting List while its unallocated Teams remain distinct.
The exact additive persistence and compatibility design remains for bounded planning.
Renaming or replacing a deployed value in one step is unsafe while live code and data
consume it, so prefer expand/contract compatibility until every writer and consumer has
moved to the accepted meaning.

### Item 4

No schema, migration or historic-data change is expected.

## 14. Cross-Workstream Test And Review Matrix

### Automated Checks

- audience-context aggregation before address deduplication;
- exact Email-to-Club uniqueness and tenant isolation;
- ad-hoc/sequence parent-recipient result reconciliation;
- stable unique-Email cursor pagination with equal timestamps;
- list/detail other-Club and cross-tenant denial;
- Dropzone pointer, keyboard, drag, rejection, limits and loading state;
- Team/Club reconciliation for first, additional and last qualifying Team without converting an
  unallocated Team to Waiting List;
- suspended/withdrawn override protection;
- retry and concurrent Team mutation convergence;
- season-clone destination-state derivation; and
- shared Team-status formatting and accessible naming.

### Browser And Accessibility Checks

- C1 compose audience explanation and unlinked manual-recipient warning;
- C2 history pagination, retry, end state and detail return;
- new, reopened and duplicated drafts using click, keyboard and drag;
- C1 Club/Team approval, allocation, de-allocation, status and filter surfaces;
- C2 access and Team-request capability as Current and Waiting List;
- C1/C2 Team lists at supported responsive widths and 200% zoom; and
- keyboard and screen-reader status wording.

### Operational And Live-Data Checks

- read-only item 1 historic classification counts;
- item 3 live contradiction counts by tenant and season;
- migration history and application ancestry;
- representative rehearsal and before/after dry-run counts;
- C2 access and communications protection;
- bounded monitoring for association/reconciliation failures; and
- separate code rollback and data recovery evidence.

## 15. Risks And Mitigations

### Cross-Club Email Exposure

Mitigation: explicit same-tenant visibility association, authoritative audience evidence and
identical list/detail authority.

### False C2 Sent History

Mitigation: accepted provider-outcome threshold and shared delivery reconciliation before an
association becomes visible.

### Duplicate Provider Delivery

Mitigation: retain address deduplication while aggregating Club contexts separately.

### R8-A Regression

Mitigation: constrain item 2 to activation/accessibility behaviour and rerun attachment,
external-link, draft and no-attachment regressions.

### Club Access Revocation Through Terminology Change

Mitigation: define admitted and participating cohorts separately and preflight C2 guards before
any item 3 reconciliation.

### Silent Live Reclassification

Mitigation: inventory, ambiguity report, dry-run default, explicit mutation intent, audit,
transactional convergence and production go/no-go.

### Item 4 Rework After Item 3

Mitigation: share the presentation mechanism but keep labels driven by the accepted domain mapping;
do not let responsive work decide persistence semantics.

### Compound Release Risk

Mitigation: coordinate decisions in one programme but retain separately reviewable, promotable and
reversible implementation boundaries.

## 16. Programme Acceptance Principles

The four-item programme is complete only when:

1. all four accepted workstreams have their own bounded implementation and evidence boundaries;
2. C1/C2 email-history differences are explainable by explicit audience and delivery rules;
3. no Club gains access through mutable address matching or another Club's Team/recipient;
4. attachment pointer, keyboard and drag interactions are truthful and retain R8-A integrity;
5. admission remains durable while seasonal participation reflects valid Team allocations;
6. Waiting List does not behave as suspension, withdrawal or loss of authorised Club access;
7. live-data reconciliation is measured, non-destructive, idempotent and recoverable;
8. Team status and waiting-list position remain visible and accessible at supported widths;
9. Commerce, FUND, public and unrelated LMSPro behaviour remain unchanged except for explicitly
   inventoried Club-status consumers accepted into item 3; and
10. the standalone C1 League dashboard reorganisation remains outside this programme.

## 17. Superseded Pre-Answer Decision Capture

This section is retained only to show the pre-answer planning state. Where it conflicts with
section 19, section 19 controls this refinement.

1. The consolidated remediation contains exactly four items.
2. The C1 League dashboard reorganisation is standalone work and is not item 5 of this CR.
3. The four items remain coordinated in one planning envelope.
4. Coordination does not require one indivisible implementation or production release.
5. R4 and completed R8-A remain foundations rather than reopened scope.
6. Email delivery-recipient identity is not Club-history authority.
7. Provider-address deduplication must retain every authorised Club context.
8. Club admission and seasonal participation were already understood to be separate.
9. The Current Club qualifying-Team rule remains accepted.
10. The earlier automatic Team Waiting List inference is superseded by sections 19 and 20. Club
    Waiting List is the accepted aggregate for a Registered Club with no qualifying Current/
    allocated Team.
11. The access-preservation principle remains accepted.
12. Attachment browse, keyboard activation and drag-and-drop must coexist.
13. Full waiting-list status and available position/total must remain visibly readable.
14. No application implementation starts from this planning-only refinement.

## 18. Raw Business Answers

This section preserves the user's answers as supplied on 2026-07-27. They are normalised into
settled decisions, recommendations and mandatory planning/data gates in sections 19 and 20.

### Item 1 - Email Visibility

1. Does C2 visibility require at least one accepted primary recipient for the Club, every intended
   primary recipient, or an explicit C1 publish-to-history decision?
   CHRIS: Every C2 must have a primary recipient
2. What limited status should C2 see for partial delivery? CHRIS: Dont Understand
3. Can authoritative CC context contribute visibility, while raw CC/BCC addresses remain
   non-authoritative and BCC remains private?

CHRIS: Yes -

4. For a User representing several Clubs, which selected Club contexts qualify for visibility?
CHRIS: Whilst possible this is an unlikely edge case and displaying emails in each club context would be accesptable
5. What durable Club lineage, if any, carries historic communication into a successor-season Club
   dashboard?
CHRIS: Each season can be discrete

6. Which legacy evidence is sufficient for automatic historic association, and what authorised C1
   review handles ambiguity?
CHRIS: no season to season history is required

7. What recipient summary, if any, may C2 see?
CHRIS: no recipient summary required

8. May C2 reopen retained attachments/shared links, and under what private-download, expiry and
   retention policy?
CHRIS: Yes open atatchments - expiry and retention expire with the end of the season

9. What unique-Email page size and accessible load-more behaviour are required?
CHRIS: No specific requirements

10. What retention/deletion rules apply to visibility associations?
CHRIS: Standard retention policies apply: Season expiration

### Item 2 - Attachment Browse

1. Which supported browser/device matrix is the production acceptance baseline?
 CHRIS: Please advise, this is not a public tool, and it will likely be used on a desktop.
2. Does the existing Dropzone interaction meet the required keyboard semantics once activation is
   restored, or is an explicit internal browse button required?
CHRIS: drag and drop works acceptably.  Click to open browser is required to be reinstated, this is no new finctionality, it is functionality that was lost as a regression. - the wording on the component even says drag or click here...

### Item 3 - Club Participation

1. Should persistence rename `ClubStatus.APPROVED`, introduce a distinct participation value or
   retain `APPROVED` as a compatibility representation of Current?
CHRIS: retain 'APPROVE' as a compatibility representation of 'Current'

2. What exact auditable admission evidence applies to direct/imported Clubs without an
   Application?
CHRIS: Please explain - I think imported clubs should automatically be set to approved

3. Is a reviewed-but-unallocated Team always Waiting List, or does the business require a separate
   transitional state?
CHRIS: waiting list is a concious decision with reject an option - and remaining unallocated exlcludes the team from counts - unallocated is important in the logic of displaying and allocating teams in the division manager - I thin this should be left as it is.


4. What precisely does **Registered Clubs** mean?
CHRIS:  A registered club is a club that has applied to be recognized as a club within the system. It may have to pay fees, A registered club is a legitimate applicant or currently active club in the league... it may be on a waiting list or be a  club with allocated teams.  A registered club has indicated to the league that they have teams to join certain age groups.  There may be no space for their teams in the chosen age group(s), and so a registered club might have 0 current teams, but several unallocated (ie in planning and allocation phase) or have teams added to an age group waiting list.  So a Registered Club is a proven entity, with a primay c2 user who can log in and receive emailed updates.  Registration does not imply Current (Approved) which means that the club has at least one current team ie a team that is allocated to an age group and division/AGG.


5. Which public/directory surfaces consume Club status and which cohort should each use?
CHRIS: I dont know what the cohort labels are currently.  In the League Management Dashboard, there is a clubs page listing Current clubs witha. cohort filter, and the dashboard includes a summry of club count....

6. Should automatic Current/Waiting List transitions create notifications?
CHRIS: Yes, Club notification may be automatic and switchable. User-triggered CRUD uses its
existing notification switch; automatic behaviour falls back to the existing Notification
Manager, where all or individual notifications can be switched on/off and default content
can be customised.
7. Which observed live contradictions are deterministic corrections and which require authorised
   review?



8. How should historic closed-season participation be displayed without rewriting it?
CHRIS: As it is currently.  This is the first season in use - therefor no historic data


### Item 4 - Responsive Team Status

1. What are the minimum supported phone widths and browser versions?
CHRIS: industry standard please

2. At which breakpoint should each table become a stacked row/card?
CHRIS: Decision delegated to AI
3. Should the visible position use compact `3/12` or the more explicit `3 of 12` at each width?
CHRIS: More Compact
4. Which existing row-detail interaction is the accepted home for lower-priority fields on each
   page?
   CHRIS: Please advise

### Control-Window Reconciliation

1. Will formal triage accept one programme with separately bounded implementation slices, or split
   the four items into separate triage records?
CHRIS: formal acceptance will update roadmap and create separately bounded implementation slices

2. Which workstream is selected first after roadmap reconciliation?
CHRIS: Implement in decreasing order of complecity.
3. Which open questions may be deferred without weakening the first selected workstream?
CHRIS: Unknown.

## 19. Reconciled Settled Business Decisions

1. The consolidated remediation contains exactly four items.
2. The C1 League dashboard reorganisation is standalone work and is not item 5 of this CR.
3. The four items remain coordinated in one planning envelope, but formal triage will create
   separately bounded implementation slices.
4. Coordination does not require one indivisible implementation or production release.
5. Candidate delivery order is decreasing complexity: item 3, item 1, item 4, then item 2.
6. R4 and completed R8-A remain foundations rather than reopened scope.
7. Email delivery-recipient identity is not Club-history authority.
8. Provider-address deduplication must retain every authorised Club context.
9. Every C2 Club-history context requires an authoritative primary recipient for that Club.
10. Authoritative CC context may contribute Club visibility; raw CC/BCC addresses do not grant
    authority and BCC remains private.
11. A User authorised for several Clubs may see the same Email in each authorised Club context
    without duplicate provider delivery.
12. C2 receives no recipient summary.
13. Each season is discrete for C2 Email history. No season-to-season communication history or
    legacy association is required.
14. C2 may reopen retained attachments and shared links until season expiration, after which the
    system stops presenting them under the standard retention boundary.
15. Club admission/registration and seasonal Current participation are separate.
16. A Registered Club is a proven/admitted Club with a primary C2 representative. It may have
    Current, unallocated or consciously wait-listed Teams and may have zero Current Teams.
17. A Club requires at least one same-season `CURRENT` Team with a valid division/AGG allocation
    to be Current.
18. `ClubStatus.APPROVED` should remain the compatibility representation of Current.
19. Team Waiting List is a conscious status decision. Team unallocated is distinct, remains part
    of the Division Manager workflow and is excluded from Current counts.
20. Club Waiting List and Team unallocated/Waiting List states do not undo onboarding or
    automatically remove C2 access.
21. An actual automatic Club Current/Waiting List transition may use the existing
    Notification Manager. User-triggered CRUD retains its on-CRUD notification control;
    automated behaviour falls back to the manager's master/per-event switches,
    default-or-custom content and recipient routing. No-op evaluation, inventory, dry-run
    and unauthorised reconciliation do not send.
22. There is no historic closed-season participation data to rewrite because this is the first
    operational season.
23. Attachment browse, keyboard activation and drag-and-drop must coexist. Click-to-browse is
    restoration of the instruction already displayed by the control, not new functionality.
24. The compact visible Team position is `Waiting List 3/12`, with a complete accessible name.
25. Item 4 uses a content-driven responsive contract with a provisional stacked layout at 767 px
    and below; breakpoint implementation detail is delegated within the acceptance boundary.
26. The separate control window will update the authoritative roadmap after formal triage.
27. No application implementation starts from this planning-only refinement.
28. For partial Club delivery, C2 sees recipient-free `Partially sent` only when at least one
    intended primary recipient for that Club was provider accepted. If none was accepted, the
    Email is not presented as Sent.
29. C2 Email visibility and private-resource access expire at the season boundary while immutable
    provider and audit evidence remains governed by platform retention.
30. Externally hosted shared links cannot be forcibly expired, so C2 stops presenting them after
    the season boundary.
31. C2 history uses 50 unique Emails per page with an explicit accessible `Load more` action.
32. Item 2's desktop-first current/previous Chrome and Edge baseline, with current Firefox and
    Safari checks where used, is accepted.
33. Completed validated import, approved two-stage form registration and authorised direct
    C1 creation are the three valid Registered/admission routes. Each retains its
    route-specific authority and primary-C2 evidence. Registration alone sets the
    Current-compatible `ClubStatus.APPROVED` only with a qualifying Current/allocated Team;
    otherwise the Club is Waiting List.
34. Unallocated Teams are a distinct in-process allocation state. They are neither Current nor
    automatically Team Waiting List, while their Registered Club remains Club Waiting List until
    at least one Team qualifies as Current/allocated.

## 20. Reconciled Final Answers And Remaining Planning Gates

### Item 1 - Email Visibility

The business accepted the planning recommendations for:

- recipient-free `Partially sent` presentation where at least one intended Club primary recipient
  was accepted;
- no Sent presentation where none of the Club's intended primary recipients was accepted;
- season-bound C2 visibility and private-resource access while immutable provider/audit evidence
  remains retained separately;
- removal of externally hosted shared links from C2 presentation after season expiry; and
- 50 unique Emails per page with an explicit accessible `Load more` action.

No remaining business question blocks item 1 triage. Implementation planning must still inventory
all creation/send paths and prove the accepted permission, reconciliation and retention contracts.

### Item 2 - Attachment Browse

The business accepted the advised desktop-first browser baseline. No unresolved business question
blocks reproduction. Runtime evidence must determine whether the existing Dropzone can reliably
restore click and keyboard browse or needs an internal browse button.

### Item 3 - Club Participation

The business accepted the item 3 direction with one controlling clarification:

- Team Waiting List remains a conscious authorised Team status; an unallocated Team is a distinct
  in-process allocation state and is excluded from Current counts.
- Club Waiting List is the aggregate state for a Registered/admitted Club with no qualifying
  Current/allocated Team. This remains true when one or more Teams is unallocated rather than
  individually wait-listed.
- Completed validated SeasonPro import, the linked two-stage form after email validation
  and authorised C1 approval, and authorised direct C1 creation are all valid
  Registered/admission routes. Each must retain route-specific durable evidence and a
  primary C2 representative.
- Registration through any of those routes becomes `ClubStatus.APPROVED`/Current only with
  a qualifying Current/allocated Team; otherwise the Club is Waiting List.
- The read-only tenant/season contradiction inventory and explicit consumer classification are
  accepted as required planning/data gates, not unresolved business questions or mutation
  authority.

### Item 4 - Responsive Team Status

No unresolved business question blocks responsive fixture capture. The advised baseline is 320,
375, 390/430, 768, 1024 and 1280 CSS-pixel widths, 200% zoom, and the current/previous major
evergreen browsers. Use a shared keyboard-operable `More details` disclosure for lower-priority
fields unless implementation inventory finds an existing equivalent interaction that should be
reused.

### Control-Window Reconciliation

Formal triage is complete:

`docs/modules/lmspro/02-triage/2026-07-27-lmspro-r9-consolidated-four-item-remediation-triage.md`

It accepts one coordinated R9 programme with separately bounded `R9-A` through `R9-D`
lifecycles, preserves the Item 3, Item 1, Item 4, Item 2 order and selects `R9-A0` as the
read-only writer, consumer and live-state inventory boundary. All recorded business
questions are resolved. No application, schema, migration, reconciliation, live-data or
deployment work is authorised by this refinement or by R9-A0.
