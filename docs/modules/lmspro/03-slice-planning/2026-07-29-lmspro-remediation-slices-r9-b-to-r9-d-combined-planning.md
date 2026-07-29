# LMSPro Remediation Slices R9-B To R9-D Combined Planning

Date: 2026-07-29

Module: LMSPro / SeasonPro using the shared IsoStack communications service

Status: ACCEPTED PLAN — one local implementation branch authorised for R9-B prospective
application/additive migration work and the R9-C/R9-D code-only UI batch; no STAGING,
production, historic reconciliation, environment or deployment action authorised

Completed programme baseline:

```text
R9-A — Club Admission And Seasonal Participation
production application commit 15559f1275d7f8ae3990cc6a9dcda5f35748e570
```

Remaining accepted programme items:

```text
R9-B — Club Email Visibility And History Integrity
R9-C — Responsive Team Status And Waiting-List-Position Visibility
R9-D — Attachment Click-To-Browse Restoration
```

Authoritative records:

- `docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`;
- `docs/modules/lmspro/01-cr-inputs/2026-07-22-lmspro-consolidated-email-integrity-club-visibility-and-remedial-work-cr-input.md`;
- `docs/modules/lmspro/01-cr-inputs/2026-07-27-lmspro-consolidated-four-item-remediation-planning-refinement.md`;
- `docs/modules/lmspro/02-triage/2026-07-27-lmspro-r9-consolidated-four-item-remediation-triage.md`; and
- `docs/modules/lmspro/05-review-and-test/2026-07-29-lmspro-r9-live-promotion-confirmation.md`.

Controlling IsoDocs parent:

```text
780551b1d18e5d7536583654390dbc18af0887c2
```

## 1. Decision And Proportionate Delivery Shape

Use this one planning record to remove duplicated administration, while retaining three
observable outcomes:

1. `R9-B` changes the Email audience, persistence and C2 access contract. It receives its
   own implementation, migration, security and data-evidence acceptance section.
2. `R9-C` changes only shared C1/C2 Team presentation.
3. `R9-D` changes only attachment-control activation while preserving R8-A.

R9-C and R9-D are sufficiently small, independent and behaviour-bounded to share one
code-only UI implementation batch. R9-B may use the same development branch and release
candidate, but it must remain separately testable and reversible. One release is acceptable
only when all three outcomes pass their own gates.

The recommended implementation shape is:

```text
one branch from the exact aligned application baseline
-> R9-B additive persistence and prospective application compatibility
-> R9-C + R9-D code-only UI corrections
-> one combined automated validation run
-> independent R9-B, R9-C and R9-D acceptance results
-> local review
-> later controlled STAGING snapshot, migration, deploy and focused smoke
-> separate R9-B historic dry-run/reconciliation decision if evidence requires it
-> promotion only after every included outcome passes
```

Formal control accepted this plan on 2026-07-29. The exact local implementation prompt in
section 12 now controls. It does not authorise STAGING, production or historic reconciliation.

## 2. Verified Baseline And Existing Coverage

The 2026-07-29 read-only repository review found:

```text
application local dev:       15559f1275d7f8ae3990cc6a9dcda5f35748e570
application origin/dev:      15559f1275d7f8ae3990cc6a9dcda5f35748e570
application local staging:   15559f1275d7f8ae3990cc6a9dcda5f35748e570
application origin/staging:  15559f1275d7f8ae3990cc6a9dcda5f35748e570
application local main:      15559f1275d7f8ae3990cc6a9dcda5f35748e570
application origin/main:     15559f1275d7f8ae3990cc6a9dcda5f35748e570
application working tree:    clean
IsoDocs main/origin-main:    780551b1d18e5d7536583654390dbc18af0887c2
IsoDocs working tree:        clean
```

The repository baselines are aligned. There is no branch drift or uncommitted application
work to absorb.

Existing lifecycle coverage is deliberately reused:

- R4 is the accepted Email compose, cohort, draft, Sent-history and C2 communications
  foundation.
- R8-A is the completed attachment allowlist, validation, private storage, acknowledgement,
  draft, delivery-job, retry and provider-evidence foundation.
- R9-A is complete and controls the accepted Club and Team terminology consumed by R9-B and
  R9-C.
- The consolidated R9 CR and refinement already settle the business decisions for R9-B,
  R9-C and R9-D.
- No separate accepted implementation plan, implementation confirmation or review record
  already exists for R9-B, R9-C or R9-D.

This plan does not recreate the completed R4, R8-A or R9-A lifecycle.

## 3. Evidence Classification

### 3.1 Confirmed Source Findings

The findings recorded against named files below were confirmed at exact application commit
`15559f1275d7f8ae3990cc6a9dcda5f35748e570`.

### 3.2 Settled Business Authority

The consolidated CR and accepted refinement control the intended outcome. In particular:

- delivery-recipient identity is not Club-history authority;
- one Email may be visible in several authorised Club contexts without duplicate provider
  delivery;
- current email-address matching is not access authority;
- each season is discrete for C2 history;
- C2 receives no recipient summary;
- partial delivery is displayed to a Club only when at least one intended primary recipient
  for that Club was provider accepted;
- Team status semantics remain those accepted and implemented through R9-A;
- visible Waiting List position uses compact `Waiting List 3/12` with the complete accessible
  name `Waiting List, position 3 of 12`; and
- pointer, keyboard and drag-and-drop attachment selection must coexist.

### 3.3 Technical Gates, Not Business Questions

The following require implementation evidence but do not reopen the business contract:

- the exact database representation of Email-to-Club audience and its linked primary-delivery
  evidence;
- aggregate current-season historic classification counts;
- runtime reproduction of the Dropzone failure and selection of the smallest reliable repair;
  and
- the final content-driven responsive breakpoint after representative long-value fixtures.

No unresolved business decision blocks implementation planning.

## 4. R9-B Confirmed Source Inventory

### 4.1 Current Persistence And Authority

`prisma/schema.prisma` retains:

- one organisation-scoped `Email`;
- one or more `EmailRecipient` rows containing one delivery address, optional
  `entityType/entityId` and delivery status;
- optional single `linkedClubId` and `linkedTeamId` fields on `Email`; and
- attachment jobs and per-recipient delivery attempts.

There is no explicit many-to-many Email-to-Club visibility association and no durable mapping
from one deduplicated provider recipient to every Club audience context that recipient
represents.

### 4.2 Current Creation And Send Paths

The retained persistent `Email` creation/send paths are:

| Path | Current durable identity | Confirmed concern |
| --- | --- | --- |
| Ad-hoc/cohort compose | `src/core/services/communications/routers/emails.router.ts` | recipient contexts are deduplicated by lowercase address and one `entityType/entityId` survives; manual Club/Team link is optional and singular |
| Announcement Email | `src/modules/lmspro/routers/announcements.router.ts` | direct Club identity is created before address deduplication, but one shared address retains only one Club recipient row |
| Key-date confirmation reminder | `src/modules/lmspro/routers/key-date-confirmations.router.ts` | direct Club identity is available, but persisted recipient rows are currently written as `sent` after the batch even where individual delivery failed |
| Ordinary sequence | `scripts/jobs/processors/sequences.ts` | enrollment entity identity is retained, but the parent becomes `SENT` without updating the created recipient from its default `pending` state |
| Key-date sequence | `scripts/jobs/processors/key-date-sequences.ts` | resolved Club context is reduced to name/address and the recipient is stored only as `KeyDateSequenceStep`; the parent becomes `SENT` while the recipient remains `pending` |
| Attachment delivery job | `src/core/services/communications/routers/emails.router.ts` and `scripts/jobs/processors/email-attachment-delivery.ts` | strong per-recipient delivery evidence exists, but it is not connected to a Club-history audience contract |

Draft update, recipient replacement and duplicate-to-draft are also audience writers and must
use the same prospective audience materialisation contract before the new Email is finalised.

Direct transactional notifications sent through `sendEmail` without a persistent `Email`
record are not part of the current C1 Sent record and are outside this bounded R9-B history
correction. R9-B must not silently turn application, Team, participation or variation
notifications into a new archive. A later product request may expand that boundary explicitly.

No scheduled-Email worker was found. The existing composer can persist `SCHEDULED`, but this
review found no retained processor that selects due scheduled Email records. That is an
adjacent integrity concern to report separately; R9-B must not imply scheduled delivery was
repaired unless it is deliberately accepted into scope.

### 4.3 Current C2 Consumers

`src/modules/lmspro/routers/communications.router.ts` currently:

- authorises the requested Club, then separately queries sent `EmailRecipient` rows whose
  identity is an exact Club or one of the Club's Teams;
- separately queries `SENT` Emails carrying one linked Club or Team;
- paginates raw recipient rows rather than unique Emails;
- combines and slices the two result sets in memory;
- can display one Email more than once;
- returns recipient name/address to C2 even though the settled contract requires no recipient
  summary;
- returns Email content in the list response rather than loading it through the exact detail
  authority; and
- has a detail check for direct Club recipients but does not equivalently prove that a Team
  recipient belongs to the authorised Club.

`src/modules/lmspro/components/dashboard/ClubCommunicationsPanel.tsx` requests only the first
50 results and does not consume `nextCursor`. It opens content already present in the list
payload. It does not provide the accepted unique-Email `Load more` contract or C2 attachment/
shared-link reopening.

The shared C1 `communications.emails.list/get` routes use organisation membership but do not
themselves enforce the LMSPro C1 Sent/compose component authority. R9-B must ensure a C2 user
cannot use an organisation-wide shared route to bypass the exact Club association.

## 5. R9-B Bounded Implementation Contract

### 5.1 Additive Audience Persistence

Introduce additive persistence equivalent to:

```text
Email
-> EmailClubVisibility (one row per exact season-specific Club audience)
-> EmailClubVisibilityRecipient (the intended primary EmailRecipient evidence for that Club)
```

The exact Prisma names may follow repository conventions, but the migration must provide:

- organisation, season, Email and Club identity on the visibility association;
- effective uniqueness for `Email + Club`;
- source/reason evidence without relying on mutable names or addresses;
- creation/finalisation timestamps;
- one or more linked primary `EmailRecipient` rows used to derive the Club-specific delivery
  outcome;
- immutable resolved-subject/body evidence for each accepted provider recipient, so C2 never
  has to reconstruct historic personalised content from current entity state;
- same-tenant and same-season validation before insertion;
- indexes for `organisation + season + Club + sent ordering`; and
- cascade/restrict behaviour that preserves immutable sent evidence under existing retention
  rules.

The association may exist while delivery is pending, but it is C2-visible only when its linked
delivery evidence meets the accepted threshold. Delivery labels are derived:

```text
zero intended primary recipients accepted
-> not presented as Sent in C2

at least one, but not every, intended primary recipient accepted
-> Partially sent

every intended primary recipient accepted
-> Sent
```

CC context may add controlled audience-source evidence, but raw CC/BCC address text is not
authority and BCC remains private. Every C2-visible Club context still requires an
authoritative primary recipient.

### 5.2 One Prospective Audience Materialisation Service

Create one shared service used by:

- ad-hoc and cohort draft create/update/recipient replacement;
- duplicate-to-draft final review;
- Announcement Email creation;
- key-date confirmation reminders;
- ordinary sequences;
- key-date sequences; and
- attachment and no-attachment delivery-result reconciliation.

The service must:

1. resolve every authorised Club context before provider-address deduplication;
2. deduplicate provider delivery independently of Club visibility;
3. retain every intended Club for a shared address;
4. reject cross-tenant or cross-season Club/Team evidence;
5. retain workflow identity separately from Club audience identity;
6. leave genuinely external manual recipients unlinked;
7. provide C1 with provider-recipient and Club-history-audience counts; and
8. fail closed where the selected Club context cannot be proven.

This service is application-level authority; database constraints and unique indexes remain
the final duplicate/cross-reference protection selected by the accepted migration.

### 5.3 Delivery-Outcome Alignment

Use one result reconciliation contract for:

- the live no-attachment batch path;
- the completed R8-A attachment job;
- Announcement Email;
- key-date confirmation reminder;
- ordinary sequence; and
- key-date sequence.

Prospective paths must update parent, recipient and Club-visibility outcome consistently.
Retries must update the same immutable Email boundary without creating false visibility or
duplicate delivery. R8-A provider routing, attachment fingerprinting, rate limits and retry
semantics remain unchanged.

Historic parent or recipient outcomes are not rewritten by this application slice.

### 5.4 C1 Experience

Before final save/send, C1 must see:

- deduplicated provider-recipient count;
- exact Club-history audience count;
- a clear warning that unlinked manual addresses will not appear in a Club dashboard; and
- a fail-closed warning for unresolved Club audience context.

The optional manual Club/Team link remains available for genuinely external addresses, but
its history consequence must no longer be hidden.

### 5.5 C2 List, Detail And Resource Authority

Replace recipient-row selection with a unique-Email query:

```text
same organisation
+ exact effective season-specific Club
+ explicit EmailClubVisibility
+ accepted Club-specific delivery threshold
-> list or open the Email
```

The list must:

- return one row per Email;
- omit recipient names, addresses, BCC and provider diagnostics;
- return only list metadata, not the full body;
- order by stable `sentAt + Email id` newest first;
- return 50 unique Emails and an exact continuation cursor; and
- support an explicit accessible `Load more`, retry and end-of-history state.

The detail route must repeat the same authority using Email/visibility identity, not trust a
recipient UUID. It may return the Club-authorised resolved content and safe resource metadata.
Where several accepted primary recipients for the same Club received different personalised
content, the detail may show each distinct Club-authorised content variant without identifying
the recipient; it must not choose one mutable current contact or expose another Club's variant.
Private attachment download authority and shared-link presentation must expire when the season
is archived/expired under the existing season-retention boundary. The server must authorise
each private resource request; a browser-held URL or Email UUID is not authority.

C1 organisation-wide list/detail access must remain available only to the appropriate
communications authority. C2 access must use the Club-specific route.

### 5.6 Historic Current-Season Evidence Gate

The prospective schema and application correction require an additive migration. Existing
current-season C1 Sent Emails will not automatically have the new association.

Before any historic insert, prepare and separately authorise a tenant/season-scoped aggregate
read-only dry-run that classifies:

- direct Club recipients;
- Team recipients resolvable to their recorded same-season Club;
- explicit linked Club/Team;
- Announcement target/recipient evidence;
- ordinary sequence Club/Team entity evidence;
- key-date reminder evidence;
- shared-address collisions;
- `User`, `KeyDateSequenceStep` and unlinked manual identities;
- parent/recipient delivery contradictions; and
- deterministic, ambiguous and excluded candidate totals.

Do not retrieve names, addresses, message content or row-level identifiers in the review
record. Do not infer association from current contact addresses, names or current membership.

Any accepted reconciliation must be an idempotent insert-only operation into the new audience
tables. It must not change Email content, recipient outcome, provider evidence, attachments,
Clubs, Teams, users or access. Ambiguous records remain absent. Production execution requires
its own exact snapshot, rehearsal and approval; it is not authorised by this plan.

## 6. R9-C Confirmed Source Findings And Implementation Contract

### 6.1 Confirmed Findings

The two controlling surfaces are:

- C1 League Teams: `src/app/(app)/app/lmspro/teams/page.tsx`; and
- C2 Club Teams: `src/app/(app)/app/lmspro/club/teams/page.tsx`.

Both are wide Mantine tables without a deliberate phone card/row contract or purposeful table
scroll container. Global styling suppresses horizontal body overflow.

The pages independently implement status badges and waiting-list text:

- C1 shows position/total only when the age-group filter is selected;
- C2 shows it whenever the server returns it;
- C1 has a local status switch while C2 uses `getStatusLabel`;
- neither badge has the accepted complete accessible waiting-list name;
- the C2 badge has fewer non-shrinking protections; and
- row-click interaction is not an equivalent keyboard-operable `More details` control.

`src/modules/lmspro/routers/teams.router.ts` already supplies age-group-scoped
`waitingListPosition` and `waitingListTotal`. R9-C does not need a server, schema, migration,
ordering or data change.

### 6.2 Shared Presentation

Create one shared Team-status presentation helper/component that:

- maps every current `TeamStatus` and computed override to the accepted friendly label and
  colour;
- displays `Waiting List 3/12` whenever valid position evidence is available;
- exposes `Waiting List, position 3 of 12` as the accessible name;
- never clips, ellipsises or shrinks the complete status text below the accepted body size;
- retains explanation in a tooltip/detail without making hover the only source; and
- displays `Approved & Unallocated` for the R9-A `APPROVED` compatibility state.

Both pages consume the same helper/component.

### 6.3 Responsive Layout

Use the accepted content-driven baseline:

- up to 767 CSS px: compact stacked row/card;
- 768-1023 CSS px: compact table/hybrid with lower-priority evidence removed from the summary;
- 1024 CSS px and above: full table.

The summary priority is:

1. Team and Club identity where applicable;
2. age group;
3. full status and available waiting-list position; and
4. division or `Unallocated`.

Team number, Free Days, manager contact, notes, variation indicators and secondary links may
move to the existing modal or one explicit keyboard-operable `More details` action. Row click
may remain as a convenience but must not be the only way to open detail.

R9-C preserves all filters, sorting, row actions, tenant/Club authority, Team values, waiting-
list ordering and R9-A workflow semantics.

## 7. R9-D Confirmed Source Findings And Implementation Contract

### 7.1 Confirmed Findings

`src/core/services/communications/components/ComposeEmailModal.tsx` renders Mantine Dropzone
7.13.2 with:

- working `onDrop` and `onReject` paths;
- the accepted R8-A file type and size contract;
- `loading={uploadingAttachment}`;
- visible `Drag files here or click to browse` wording; and
- child content with `pointerEvents: none`.

The current source does not explicitly set `activateOnClick`, `activateOnKeyboard`, an
`openRef`, or a programmatic activation label. Mantine's type contract supports those
properties, but static source alone does not prove why the installed runtime does not open
the picker. There is no current component/browser regression test for activation.

### 7.2 Runtime Gate And Bounded Repair

The implementation must first reproduce the failure on the exact local baseline using
current Chrome or Edge and record:

- pointer activation;
- Enter/Space activation;
- focus visibility;
- drag-and-drop;
- idle, processing and limit states; and
- whether any overlay, modal, nested control or Dropzone default suppresses activation.

Then use the smallest evidence-backed correction:

1. prefer reliable activation of the Dropzone itself with explicit pointer, keyboard and
   accessible-name behaviour; or
2. if the installed Dropzone cannot provide that reliably, retain it for drag/drop and add
   one clearly labelled internal `Browse files` button wired through `openRef`.

The repair must open exactly one picker, send dropped and browsed files through the same
selection/validation path, and prevent remove/link controls or processing state from opening
another picker.

It must not change:

- the R8-A2R PDF/image/text allowlist;
- three-file and 10 MB cumulative limits;
- private R2 storage;
- per-Email acknowledgement;
- persisted draft/reopen/duplicate behaviour;
- shared-document-link behaviour;
- attachment job selection, provider routing, retry or rate limiting; or
- no-attachment batch delivery.

## 8. Implementation Boundaries And Recovery

### 8.1 One Branch, Three Outcomes

Proposed branch:

```text
fix/lmspro-r9-b-d-remediation
```

Start only from exact clean commit:

```text
15559f1275d7f8ae3990cc6a9dcda5f35748e570
```

Use logical commits or clearly separable change groups:

1. R9-B additive schema and audience service;
2. R9-B prospective writers, delivery reconciliation and C1/C2 consumers;
3. R9-C shared status presentation and responsive layouts; and
4. R9-D activation restoration and focused regression protection.

They may be reviewed and released together, but a failed outcome must be isolatable without
discarding the others.

### 8.2 Migration And Rollback

Only R9-B is expected to create a migration. It must be additive:

- new tables, foreign keys/constraints and indexes;
- no enum rename;
- no deletion or rewrite of existing Email/recipient/resource evidence; and
- no automatic historic insert inside the schema migration.

If application rollback is needed after migration, the old application must ignore the new
empty/additive tables safely. R9-C and R9-D are code-only and revert independently.

Historic association insertion, if later accepted, uses a separately recoverable transaction
and exact pre-execution snapshot. It is not coupled to schema deployment.

### 8.3 Documentation

Avoid separate lifecycle paperwork for each outcome. If implementation is accepted, create:

- one combined implementation confirmation with R9-B, R9-C and R9-D sections; and
- one combined review-and-test record with separately passable automated, C1/C2, responsive
  and attachment-interaction sections.

A separately approved R9-B reconciliation may be recorded in the same review record with one
credential-safe SQL artifact if required. It does not need a new CR or a new programme.

## 9. Automated And Human Acceptance

### 9.1 Shared Automated Gate

Run the existing complete relevant test suite, type checking, lint/build and Security Scan
once for the combined branch. Add focused tests for:

- audience aggregation before lowercase-address deduplication;
- one Email associated once to every intended Club;
- same-tenant/same-season rejection;
- shared-address multi-Club context without duplicate provider recipients;
- manual linked and unlinked recipients;
- Announcement, key-date reminder, ordinary sequence and key-date sequence prospective
  audience evidence;
- parent/recipient/Club outcome for all accepted, partial and all failed;
- retry/idempotency and attachment-job outcome convergence;
- stable unique-Email cursor ordering with equal timestamps;
- C2 list/detail other-Club and cross-tenant denial;
- absence of recipient identity in C2 results;
- friendly Team labels and complete accessible waiting-list text;
- status presentation with and without position evidence;
- attachment selection deduplication, rejection and processing locks; and
- the selected click/keyboard activation contract at the smallest practical component/browser
  level.

Do not introduce a full end-to-end framework solely for R9-D. If the existing Vitest environment
cannot prove the installed browser file-picker interaction proportionately, retain focused
selection tests and make the recorded browser smoke the authoritative activation proof.

### 9.2 Focused Local And STAGING Human Smoke

R9-B:

1. C1 sends one controlled no-attachment Email to one Club cohort.
2. It appears once in C1 Sent and once in the exact C2 Club history.
3. Another C2 Club cannot list or open it.
4. One shared recipient representing two deliberately selected Clubs receives one provider
   delivery while both authorised Club histories show one row.
5. A manual unlinked recipient shows the warning and creates no Club-history row.
6. Partial and failed controlled deliveries show only the accepted recipient-free C2 state.
7. `Load more` retains stable order and returns no duplicate Email.
8. One controlled attachment Email can be opened from C2 and its private resource remains
   same-Club authorised.

R9-C:

1. Check C1 and C2 at 320, 375, 390/430, 768, 1024 and 1280 CSS px and 200% zoom.
2. Cover Current, Approved & Unallocated, Pending Approval, Waiting List with single- and
   multi-digit position/total, Suspended, Withdrawn and the remaining current enum values.
3. Confirm full status wording, identity, age group and division/Unallocated remain visible.
4. Confirm `More details` is keyboard operable and lower-priority evidence remains available.
5. Confirm no Team value, filter, sort, allocation or waiting-list order changes.

R9-D:

1. In a new draft, use pointer, keyboard and drag/drop.
2. Repeat pointer and keyboard use in a saved/reopened draft and duplicated draft.
3. Confirm one picker and one selected-file row per activation.
4. Confirm invalid type, over-limit, remove and processing behaviour.
5. Send one controlled attachment Email and one no-attachment Email to prove R8-A routing
   remains intact.
6. Use current/previous Chrome and Edge, with current Firefox and Safari smoke where used.

Human testing must use controlled recipient/Club fixtures and must not expose another Club's
communication.

## 10. Promotion Conditions

Promotion is viable only when:

- R9-B migration applies cleanly to the intended snapshot/rehearsal target;
- old application rollback remains compatible with the additive schema;
- all prospective Email writers populate exact audience evidence;
- C2 list/detail/resource denial tests pass;
- any required historic dry-run is reviewed and any mutation is separately approved;
- R9-C passes the responsive/accessibility matrix without changing data;
- R9-D passes pointer, keyboard, drag and R8-A delivery regressions;
- Security Scan, build and health checks pass; and
- the combined implementation/review record identifies the exact tested commit.

Failure of R9-C or R9-D may be removed/reverted independently. R9-B must not be promoted with
an incomplete writer or permission conversion merely to retain the UI items in the same
release.

## 11. Disposition

The combined planning boundary is complete and proportionate.

- R9-B is one independently testable additive application/migration outcome.
- R9-C and R9-D should share one code-only UI implementation batch.
- All three may use one branch, one automated validation run and one release candidate.
- No live database evidence was required or queried during this planning review.
- Current-season R9-B aggregate evidence remains a later explicitly authorised read-only gate.
- There is no blocking business question.
- R9-D's exact repair remains correctly conditional on runtime reproduction; that is a technical
  implementation gate, not a reason for another planning lifecycle.

Formal control accepted this plan on 2026-07-29. Local implementation and application of the
single additive migration to the authorised local development database may proceed from the
exact baseline. Do not query or mutate STAGING or production, alter environments, deploy or
execute historic reconciliation.

## 12. Next Implementation-Approval Prompt

```text
Formally accept the combined LMSPro R9-B to R9-D plan:

isodocs/docs/modules/lmspro/03-slice-planning/2026-07-29-lmspro-remediation-slices-r9-b-to-r9-d-combined-planning.md

Use exact application baseline:
15559f1275d7f8ae3990cc6a9dcda5f35748e570

Commence one local development branch:
fix/lmspro-r9-b-d-remediation

Implement the accepted R9-B prospective Email-to-Club audience persistence, writer/delivery
alignment, C1 audience explanation and C2 unique-Email list/detail/resource authority. Create
one additive migration only. Do not place historic data reconciliation inside the migration
and do not rewrite existing Email, recipient, provider or attachment evidence.

Implement R9-C and R9-D as one code-only UI batch. R9-C must share Team-status presentation
across C1/C2 without changing Team values or waiting-list calculation. For R9-D, first record
runtime reproduction and then use the smallest evidence-backed Dropzone activation repair,
preserving every completed R8-A contract.

Work locally against the normal development environment first. Apply the additive migration
only to the authorised local development database. Run the combined focused tests, existing
relevant suites, type checking, lint/build and Security Scan. Create one combined implementation
confirmation and one combined review-and-test record with separate R9-B, R9-C and R9-D results.

Do not query or mutate STAGING or production. Do not change environment values, deploy, send
an uncontrolled Email or execute historic reconciliation.

Stop after the local implementation is committed and technically green. Provide the focused
local human smoke schedule, the exact commit and migration, any technical exception, and the
next controlled STAGING prompt.
```
