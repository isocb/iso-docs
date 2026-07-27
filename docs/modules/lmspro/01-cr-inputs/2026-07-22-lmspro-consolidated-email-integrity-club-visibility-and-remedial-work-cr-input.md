# LMSPro Consolidated Email Integrity, Club Visibility And Remedial Work CR Input

Date: 2026-07-22
Last updated: 2026-07-27

Module: LMSPro / SeasonPro using the shared IsoStack communications service

Status: Four-item consolidated CR input complete; R8-A production promotion complete; eligible
for control-window triage but no executable slice selected

Priority: High for communications-history integrity, C2 access control and truthful seasonal
Club participation

Authoritative roadmap:

`docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`

## 1. Planning-Only Boundary

This document is a consolidated change-request input. It records evidence, business intent,
required outcomes, dependencies, settled answers and mandatory planning/data gates for later
triage and bounded slice planning.

It does not:

- authorise application code, schema, migration, infrastructure or deployment work;
- assign or select an executable remediation slice;
- reopen or change the completed R8-A attachment-delivery lane;
- amend roadmap status or lifecycle evidence;
- authorise retrospective production-data mutation; or
- replace the authoritative LMSPro roadmap.

The separate control window remains responsible for triage, slice selection, implementation,
testing, lifecycle records, promotion and roadmap reconciliation.

## 2. Source Request And Consolidated CR Structure

The business has identified four related remedial concerns across LMSPro communications and the
operating lifecycle. They should be considered as one coordinated compound CR rather than four
unrelated fixes.

This document records the complete four-item consolidated CR:

1. **Club dashboard email visibility and history integrity** - captured in this revision;
2. **Attachment dropzone click-to-browse regression** - captured in this revision;
3. **Club admission, current participation and waiting-list alignment** - captured in this
   revision;
4. **Responsive Team status and waiting-list-position visibility** - captured in this revision.

The C1 League dashboard reorganisation previously expected as item 5 is now a separate,
standalone piece of work. It is not part of this consolidated CR and must receive its own CR,
triage and planning lifecycle before implementation.

The attachment-delivery cycle has completed its staging and live gates. This four-item CR is
complete as a planning input and may proceed to control-window triage. Capturing or committing
the current observations does not select or authorise implementation.

## 3. Related Accepted Foundations

### 3.1 R4 Communications Foundation

The accepted LMSPro communications foundation remains:

- **LMSPro CR Input - Communications, Email And Announcements Remediation** -
  `docs/modules/lmspro/01-cr-inputs/2026-07-06-lmspro-cr-communications-email-announcements-remediation-input.md`;
- **LMSPro Remediation Slice R4-B - Communications Email And Announcements Workflow Planning** -
  `docs/modules/lmspro/03-slice-planning/2026-07-06-lmspro-remediation-slice-r4-b-communications-email-announcements-workflow-planning.md`; and
- the related R4 implementation and review records.

R4 established shared email composition, cohort resolution, drafts, duplication, sent history and
Club dashboard communications. This CR does not replace that foundation. It records gaps exposed by
later operational use and by email features added through separate paths.

### 3.2 R8-A Attachment Integrity Foundation

Attachment transport remains controlled separately by:

- **LMSPro CR Input - Attachment-Aware Email Delivery And Fail-Closed Evidence Remediation** -
  `docs/modules/lmspro/01-cr-inputs/2026-07-20-lmspro-cr-attachment-aware-email-delivery-and-fail-closed-evidence-remediation-input.md`;
- the accepted R8-A controlling plan; and
- its subordinate R8-A1 through R8-A3 planning, implementation and review lifecycle.

R8-A is complete through staging and live. This consolidated CR must consume its final accepted
delivery and status contracts and must not reopen attachment transport, private R2 policy,
provider routing, rate limiting or retry.

### 3.3 Current Evidence Surfaces

The first remedial item is supported by read-only review of:

```text
src/modules/lmspro/routers/communications.router.ts
src/modules/lmspro/components/dashboard/ClubCommunicationsPanel.tsx
src/core/services/communications/routers/emails.router.ts
src/core/services/communications/components/ComposeEmailModal.tsx
src/modules/lmspro/communications/cohort-resolver.ts
scripts/jobs/processors/sequences.ts
scripts/jobs/processors/key-date-sequences.ts
prisma/schema.prisma
```

The third remedial item is supported by read-only review of the current Club Application, Club,
Team, division, season-clone, communications and access contracts, including:

```text
prisma/schema.prisma
src/modules/lmspro/routers/club-applications.router.ts
src/modules/lmspro/routers/clubs.router.ts
src/modules/lmspro/routers/teams.router.ts
src/modules/lmspro/routers/seasons.router.ts
src/modules/lmspro/communications/cohort-resolver.ts
src/core/services/communications/components/ComposeEmailModal.tsx
src/app/(app)/app/lmspro/team-approval/page.tsx
src/app/(app)/app/lmspro/clubs/page.tsx
```

The fourth remedial item is supported by read-only review of:

```text
src/app/(app)/app/lmspro/teams/page.tsx
src/app/(app)/app/lmspro/club/teams/page.tsx
src/modules/lmspro/lib/teamStatus.ts
src/styles/globals.css
```

## 4. Strategic Decision

LMSPro must distinguish **delivery recipients** from **Club communication visibility**.

An `EmailRecipient` answers:

```text
which address received one provider delivery attempt and what happened to that attempt?
```

It is not sufficient to answer:

```text
which C2 Club dashboards are authorised to retain and display this communication?
```

The required direction is therefore an explicit, tenant-scoped, many-to-many association between
`Email` and LMSPro Club context. The final persistence name is determined in later schema planning;
this CR uses **Email-to-Club visibility association** as the conceptual term.

```text
Email
-> one or more delivery recipients
-> zero, one or more authorised Club visibility associations

Club
-> zero or more visible Emails
-> each Email appears once regardless of how many Club recipients received it
```

The association must be materialised from authoritative audience context when the Email is
finalised or created for delivery. C2 visibility must not be inferred later merely because a
current Club contact happens to use the same email address.

## 5. Controlling Terminology

### 5.1 Email

The shared immutable communication record containing subject, body, module, lifecycle and sent
evidence.

### 5.2 Email Recipient

One deduplicated provider-delivery destination and its resolved content and delivery outcome. A
recipient address may represent more than one Club context.

### 5.3 Email-to-Club Visibility Association

An explicit record that a particular Club is authorised to see a particular Email in its C2
communications history. It is separate from delivery-recipient identity and supports many Clubs
for one Email and many Emails for one Club.

The conceptual association should retain at least:

- tenant/organisation identity;
- Email identity;
- Club identity;
- controlled association source/reason;
- source entity or workflow evidence where useful;
- creation/finalisation timestamp; and
- durable audit evidence.

The later schema plan should enforce one effective visibility row per `Email + Club`, while
allowing several source reasons to be retained if operationally necessary.

### 5.4 Provider Accepted

The provider accepted the delivery request. This does not prove inbox delivery or human reading.
Later UI and planning must not describe provider acceptance as stronger evidence than it is.

### 5.5 Club Communications History

The C2 Club dashboard history of successfully issued communications that were explicitly in that
Club's audience. It is not a view of every organisation Email and is not generated by matching
current raw addresses.

## 6. Remedial Item 1 - Club Dashboard Email Visibility And History Integrity

### 6.1 Business Observation

Some Emails appear in the C1 League dashboard Sent area and were received by the intended Club,
but they are absent from the Emails area of the C2 Club dashboard. Other Emails appear correctly,
making the behaviour look intermittent.

The discrepancy undermines the Club dashboard as a dependable communication record. C1 and C2 can
currently see different histories even where provider delivery succeeded.

### 6.2 Confirmed Current Display Contract

The C1 Sent area lists organisation `Email` records and their parent status.

The C2 Club dashboard uses two narrower routes:

1. a sent `EmailRecipient` whose exact entity is the current `Club` or one of its `Team` records;
   or
2. an overall `SENT` Email carrying an explicit `linkedClubId` or `linkedTeamId`.

This explains why the problem is selective rather than random.

## 7. Five Confirmed Visibility Defects

### 7.1 Issue 1 - Manual Addresses Have No Club Identity By Default

Manual recipient payloads contain an address but no `entityType` or `entityId`. The compose UI
offers a separate `Link to Club/Team` control, but explicitly labels it optional.

Current outcome:

```text
C1 enters a Club contact as a manual address
-> provider accepts and recipient receives Email
-> C1 Sent history shows Email
-> no Club/Team entity and no explicit link
-> C2 Club history cannot select it
```

Required remediation:

- retain support for genuinely external, unlinked recipients;
- make the visibility consequence explicit in C1 UI: an unlinked manual address will not appear
  in a Club dashboard;
- when C1 identifies one or more intended Clubs, create explicit visibility associations;
- never infer Club visibility solely by comparing the manual address with mutable contact data;
  and
- show the final Club-history audience clearly before send/finalisation.

### 7.2 Issue 2 - Club-Role Recipients Are Stored As Users

The Club-role cohort resolver stores the delivery entity as `User`. The C2 history query accepts
only exact `Club` or `Team` recipient entities.

Current outcome:

```text
C1 selects a Club role
-> recipient User receives Email
-> EmailRecipient entityType = User
-> C2 query ignores User
-> Club history omits Email
```

Required remediation:

- resolve and persist every authoritative Club audience represented by a Club-role selection;
- keep provider delivery deduplicated by address;
- allow one deduplicated User/address delivery to create visibility for several Clubs when the
  selected audience legitimately includes each Club;
- snapshot the relevant audience at finalisation rather than rely on future membership state; and
- distinguish league-role recipients from Club-role recipients so league-only communication is not
  exposed to a Club merely because the User later acquires a Club role.

### 7.3 Issue 3 - Sequence Parent And Recipient States Diverge

The general and key-date sequence processors can update the parent `Email` to `SENT` without
updating its `EmailRecipient` from the default `pending` state. Key-date sequence recipients are
also classified as `KeyDateSequenceStep`, not as their intended Club audience.

Current outcome:

```text
provider accepts sequence Email
-> parent Email becomes SENT and appears to C1
-> recipient remains pending and/or has workflow-step entity
-> C2 requires recipient status = sent plus Club/Team entity
-> Club history omits Email
```

Required remediation:

- use one shared delivery-result reconciliation contract for ad-hoc, ordinary sequence and
  key-date sequence Emails;
- update parent and recipient outcomes consistently;
- preserve sequence/step identity as workflow evidence without using it as the only audience
  identity;
- create the exact Email-to-Club visibility associations for the sequence audience; and
- prove failed and retried sequence attempts cannot create false C2 sent-history entries.

### 7.4 Issue 4 - Address Deduplication Discards Additional Club Context

The shared resolver deduplicates all recipients by lowercase email address and retains one
recipient object. Where the same address legitimately represents several Clubs, Teams or selected
filters, only one `entityType/entityId` survives.

Current outcome:

```text
one address represents Club A and Club B
-> one provider delivery is correctly preferred
-> only one entity association survives
-> only one Club can recover the Email through recipient filtering
```

Required remediation:

- continue provider-address deduplication to prevent duplicate messages;
- aggregate, rather than overwrite, all authorised Club audience contexts before persistence;
- create one visibility association for each intended Club;
- display the Email once in each authorised Club history; and
- ensure a shared address never grants one Club access to another Club's unrelated communication.

### 7.5 Issue 5 - Fifty Recipient Rows Are Not A Paginated Email History

The Club panel requests at most 50 recipient rows. The server returns a cursor for one query path,
but the component does not consume it. Results are not deduplicated by Email, so a single Email with
several Club-related recipients can consume several of the 50 visible positions.

Current outcome:

```text
recipient rows and manually linked Email rows queried separately
-> combined and sorted in memory
-> sliced to 50
-> no further page requested by C2 UI
-> older unique Emails disappear without an end-of-history explanation
```

Required remediation:

- paginate unique Club-visible Emails, not raw recipient rows;
- use a deterministic server cursor based on stable sent ordering and Email identity;
- provide incremental loading within the existing bounded communications scroll area;
- load the next page as the user scrolls, or expose an accessible `Load more` control with the
  same cursor contract;
- prevent gaps or duplicates when several Emails have the same sent timestamp;
- preserve scroll position when viewing and closing an Email; and
- show clear loading, end-of-history and retry states.

## 8. Explicit Many-To-Many Visibility Contract

The later bounded schema plan must define an association equivalent to:

```text
Email 1 ---- * Email-to-Club visibility * ---- 1 LMSProClub
```

Conceptual invariants:

1. Every association is tenant scoped and references a same-tenant Email and Club.
2. One Email appears at most once in one Club's history.
3. One provider recipient may support several Club associations.
4. Several provider recipients for one Club still produce one visible Email row.
5. Manual linkage creates only the Clubs explicitly selected by C1.
6. Club/Team cohorts create associations from the resolved authoritative entities.
7. Club-role cohorts retain every selected Club context even after address deduplication.
8. Sequence and key-date workflows persist workflow identity and Club audience separately.
9. A visibility association becomes C2-visible only under the accepted delivery-outcome policy.
10. Sent Email content and historic delivery evidence remain immutable.
11. Current contact-address matching is not an access-control mechanism.
12. Deleting or changing a later User role/contact must not silently rewrite historic visibility.

Candidate controlled association sources include:

- direct Club cohort;
- Team cohort resolved to its Club;
- Club-role membership within a selected cohort;
- explicit manual Club link;
- explicit manual Team link resolved to its Club;
- Announcement-targeted Club;
- ordinary sequence audience;
- key-date sequence audience; and
- authorised deterministic historic reconciliation.

These are planning categories, not proposed enum values.

## 9. C1 And C2 Experience

### 9.1 C1 League Administrator

C1 should be able to see before finalisation:

- deduplicated provider-recipient count;
- exact intended Club-history audience count;
- which manual recipients are unlinked;
- a clear statement that unlinked addresses do not appear in a Club dashboard; and
- warnings where audience context cannot be resolved safely.

C1 Sent history remains the organisation-wide operational record. It should be able to explain the
Club audience without changing the immutable sent Email.

### 9.2 C2 Club User

C2 should see:

- one row per authorised Email;
- the exact final subject and body appropriate to the Club context;
- accurate provider-accepted/sent presentation under the accepted terminology;
- stable newest-first progressive scrolling;
- no duplicates caused by several officials or Teams; and
- no Emails belonging only to another Club, league-only role or unrelated manual recipient.

The Club dashboard must not expose BCC addresses, internal provider diagnostics, other Clubs'
recipient lists or unrestricted organisation email history.

## 10. Permissions And Security Correction

List and detail access must share one server-side authority:

```text
same tenant
+ authorised current/effective Club context
+ exact Email-to-Club visibility association
-> list or open communication
```

The current detail route checks direct `Club` recipients but does not equivalently prove that a
requested `Team` recipient belongs to the C2 user's Club. The later remediation must close this
adjacent authorisation weakness. Possession or guessing of an `EmailRecipient` UUID must never be
sufficient to read another Club's communication.

C1 hat-swap/Club-context access should use the same resolved Club boundary as genuine C2 access.

## 11. Historic Data And Season Continuity

Historic repair must not rewrite Email content, provider evidence or recipient outcomes.

Candidate deterministic reconciliation inputs are:

- existing direct `Club` recipient identity;
- existing `Team` recipient identity resolved to its recorded Club;
- existing explicit `linkedClubId`;
- existing explicit `linkedTeamId` resolved to Club;
- workflow records that durably identify the exact Club audience; and
- other same-tenant evidence explicitly accepted during planning.

Do not automatically assign historic visibility by matching a recipient address to current Club
contacts or current User memberships. These values are mutable and may be shared.

Each season is discrete for C2 Email history. Historic communication remains bound to the exact
season Club context and does not carry into a successor-season dashboard. Current-season
reconciliation must still use durable same-tenant evidence; name matching alone must never become
historic access authority.

Ambiguous historic rows should be reported for C1 review or deliberately remain absent. They must
not be silently exposed.

## 12. Included Scope For Later Triage

- explicit Email-to-Club many-to-many visibility persistence;
- audience aggregation before provider-address deduplication discards context;
- consistent parent/recipient delivery outcome reconciliation;
- ad-hoc, Club/Team cohort, Club-role, ordinary sequence and key-date sequence coverage;
- one-Email-per-Club query semantics;
- cursor pagination and progressive scroll/load-more C2 UX;
- list/detail tenant and Club authorisation alignment;
- deterministic historic audit/reconciliation proposal;
- representative automated and human regression coverage; and
- operational evidence that explains why an Email is or is not visible to a Club.

## 13. Excluded Scope

- changing R8-A attachment provider routing, private storage, retry or rate limits;
- creating a separate LMSPro-only email service;
- treating provider acceptance as proven inbox delivery;
- mailbox-open/read tracking;
- automatic Club association from raw address similarity;
- exposing league-only or unrelated communications to C2;
- redesigning Announcement presentation except where its email audience must populate visibility;
- changing Email content after send;
- bulk mutation of ambiguous historic records without an accepted reconciliation plan;
- the standalone C1 League dashboard reorganisation formerly expected as item 5;
- implementing any of these four remedial items before triage and bounded slice acceptance; and
- roadmap, deployment or production-data changes from this CR input.

## 14. Dependencies And Sequencing Implications

Hard dependencies:

1. retain the completed, tested and signed-off R8-A attachment lifecycle as the delivery
   foundation;
2. accept the final shared Email/delivery status terminology produced by R8-A;
3. inventory every current Email creation/send path before schema planning;
4. decide the visibility threshold and historic reconciliation policy; and
5. perform explicit schema, migration, permission and rollout planning before implementation.

The visibility association can later support both attachment and non-attachment Emails without
changing their provider transport. Transport and Club-history visibility remain separate concerns.

## 15. Candidate Planning Workstreams

These are advisory workstreams, not executable slice identifiers:

1. data audit and authoritative Email-creation/send-path inventory;
2. Email-to-Club visibility schema, source and immutability proposal;
3. prospective audience materialisation across ad-hoc, cohort and sequence paths;
4. deterministic historic reconciliation and ambiguity report;
5. C2 unique-Email query, detail authorisation and progressive-scroll contract;
6. C1 audience explanation and manual-link clarity;
7. focused security, pagination, sequence and shared-address regression tests; and
8. staged rollout, monitoring and lifecycle documentation.

## 16. Acceptance Principles

Remedial item 1 is successful when:

- every C2-visible Email has an explicit same-tenant Club visibility association;
- C1 and C2 history differences are explainable by controlled audience/delivery rules;
- manual linked communications appear and manual unlinked communications state their consequence;
- Club-role recipients remain visible to every intended Club after address deduplication;
- ordinary and key-date sequence parent/recipient outcomes reconcile consistently;
- one shared address can represent several authorised Clubs without duplicate provider delivery;
- each Club sees one row per Email regardless of its number of recipients or Teams;
- scrolling beyond 50 unique Emails retrieves stable additional pages without gaps or duplicates;
- list and detail access deny other-Club and cross-tenant records;
- historic remediation never relies solely on current email-address matching;
- no sent Email content or delivery evidence changes retrospectively; and
- the existing proven email delivery routes receive regression protection.

## 17. Settled Business Decisions

1. This is remedial item 1 within the complete four-item consolidated LMSPro remediation CR.
2. The consolidated CR remains subordinate to the LMSPro roadmap; R8-A attachment sign-off is
   complete and the four-item CR is eligible for control-window triage.
3. C1 Sent history and C2 Club history serve different authorised scopes but must reconcile under
   explicit rules.
4. Email delivery recipient identity is not sufficient to control Club-history visibility.
5. LMSPro requires an explicit many-to-many Email-to-Club visibility association.
6. Provider delivery may remain deduplicated by address while Club audience context remains
   many-to-many.
7. One Email appears once per authorised Club, regardless of recipient count.
8. Manual-address Club visibility requires explicit C1 association; raw address matching is not
   authority.
9. Club-role, Team, ordinary sequence and key-date sequence workflows must populate the same
   visibility contract where a Club is in the intended audience.
10. C2 must be able to progressively scroll/load beyond the initial 50 unique Emails.
11. List and detail routes must enforce the same tenant and Club authority, including Team-derived
    communication.
12. Historic sent Email content and delivery evidence remain immutable.
13. No application implementation begins from this CR input.

## 18. Pre-Answer Business And Planning Questions

This section preserves the questions that preceded the 2026-07-27 business answers. The linked
planning refinement reconciles them into settled decisions and mandatory planning/data gates.
Where this section conflicts with that later refinement, the refinement controls formal triage.
These questions do not reopen the settled many-to-many direction.

### 18.1 C2 Visibility Threshold

Should a Club association become visible when:

- at least one intended primary recipient for that Club is provider accepted;
- every intended primary recipient for that Club is provider accepted; or
- C1 explicitly publishes the communication to Club history independently of provider outcome?

Failed and queued Emails must not be presented as successfully sent by default.

### 18.2 Partial Delivery Presentation

Where some Club recipients succeed and others fail, what limited status should C2 see, and which
operational detail remains C1-only?

### 18.3 CC And BCC

Do CC recipients contribute Club visibility when they have authoritative Club context? BCC
addresses must never be exposed. The initial safe direction is that raw CC/BCC addresses do not
create visibility automatically.

### 18.4 User With Several Club Memberships

When a Club-role User belongs to several Clubs, should visibility include every Club represented by
the selected cohort, or only the Club context through which that User qualified for this send?

### 18.5 Season-Clone Continuity

What durable Club lineage should allow a current C2 Club dashboard to see communications issued to
an exact predecessor Club record in an earlier season?

### 18.6 Historic Reconciliation

Which deterministic legacy sources are sufficient for automatic association, and what C1 review
mechanism handles ambiguous manual/User/workflow-step records?

### 18.7 Recipient Presentation

Should C2 see recipient names/addresses, a role summary, or simply that the Email was issued to the
Club? Privacy review is required where several officials or Teams were included.

### 18.8 Attachments And Shared Links In History

Should a C2 history detail expose retained attachments/shared links after send, and under what
private-download, expiry and retention contract? This must not be inferred from R8-A transport.

### 18.9 Scroll Page Size And Accessibility

Confirm the initial unique-Email page size and whether automatic infinite scroll must always have an
equivalent keyboard-accessible `Load more` action.

### 18.10 Retention

Define retention and deletion rules for Club visibility associations when Email, Club, season or
tenant retention policies apply.

## 19. Planning Handoff

Planning-only four-item refinement:

`docs/modules/lmspro/01-cr-inputs/2026-07-27-lmspro-consolidated-four-item-remediation-planning-refinement.md`

The next controlling-window action is formal triage. It must:

1. retain completed R8-A as the delivery foundation rather than reopening it;
2. triage the complete four-item CR as one coordinated compound-remediation programme;
3. create separately bounded implementation slices while preserving the accepted programme;
4. open the C1 League dashboard reorganisation through a separate CR lifecycle when selected; and
5. reconcile accepted work into the authoritative roadmap without treating this CR as execution
   authority.

## 20. Remedial Item 2 - Attachment Dropzone Click-To-Browse Regression

### 20.1 Business Observation

Following the R8-A attachment remediation and production promotion, human LMSPro testing found
that the email attachment control still accepts files dragged onto it but no longer reliably
opens the local operating-system file picker when the same zone is clicked.

The previously understood interaction was one combined control:

```text
drag files onto the attachment zone
OR
click the attachment zone to browse for local files
```

The loss of click-to-browse was not requested by the business and was not an accepted R8-A
security, storage, delivery, rate-limit or provider decision. The current UI continues to state
`Drag files here or click to browse`, so a non-responsive click is also a direct mismatch between
the displayed instruction and actual behaviour.

### 20.2 Required Outcome

A later bounded remediation must:

- restore both drag-and-drop and click-to-open-file-picker behaviour to the same attachment zone;
- preserve the accepted R8-A2R file allowlist, three-file limit, cumulative 10 MB limit, private
  R2 persistence, validation, acknowledgement and fail-closed delivery contracts;
- preserve keyboard access so the file picker can be opened without a pointing device;
- give the control an accessible name, visible focus treatment and truthful disabled/loading
  state;
- prevent a click on remove, link or another adjacent control from opening the file picker;
- prevent double selection or repeated picker activation while selected files are being
  processed;
- work for a new Email, saved draft, reopened draft and duplicated-to-draft Email;
- retain the separate external HTTPS shared-document-link editor and avoid describing an
  uploaded local file as a link;
- add focused component/browser regression coverage for pointer click, keyboard activation,
  drag-and-drop, rejection, limits and processing state; and
- include a human smoke check in the supported staging and production browsers.

### 20.3 Investigation Boundary

Current read-only review confirms that `ComposeEmailModal` still renders a Mantine `Dropzone` and
still displays the click-to-browse instruction. The regression therefore requires focused runtime
and browser investigation before a fix is selected. Candidate causes may include dropzone
activation props, an overlay or disabled/loading state, event interception, focus behaviour or a
dependency/runtime interaction; none is accepted as the cause without evidence.

This CR does not authorise an opportunistic component rewrite or any change to attachment policy,
provider delivery, R2 credentials, email visibility, recipient resolution or the external-link
contract.

### 20.4 Acceptance Principles

Remedial item 2 is successful when:

1. clicking anywhere in the intended attachment zone opens one local file picker;
2. keyboard activation opens the same picker;
3. dropping an accepted file continues to work;
4. refused files and limit breaches remain safely rejected with understandable feedback;
5. accepted files appear once and retain the exact R8-A validation/persistence evidence;
6. loading prevents conflicting selection without leaving the control permanently inert;
7. the instruction shown to the user matches the tested interaction; and
8. no attachment delivery, no-attachment batch, external-link or draft-rehydration regression is
   introduced.

## 21. Remedial Item 3 - Club Admission, Current Participation And Waiting-List Alignment

### 21.1 Business Observation

A Club may be accepted into the league while none of its Teams currently has a division
allocation. This includes:

- a newly accepted Club whose requested Teams still await placement;
- a Club with Teams that are all on the waiting list;
- a Club with no Teams in the season; and
- a previously participating Club whose last current Team loses its division allocation or moves
  to another non-current state.

The reconciled business meaning is:

```text
admitted Club + one or more current, division-allocated Teams = Current Club

admitted Club + zero current, division-allocated Teams = Waiting List Club
+ preserve unallocated and consciously wait-listed Team evidence
```

Approval of the Club's onboarding application must remain durable admission evidence. Moving the
seasonal Club between participation states must not reopen, revoke or repeat onboarding. Club
Waiting List is the aggregate for zero qualifying Current/allocated Teams; it does not
automatically change an unallocated Team into Team Waiting List.

### 21.2 Verified Current Lifecycle

The present model already contains two distinct records but does not consistently preserve their
different meanings:

1. `LMSProClubApplication.status` records onboarding review:
   `PENDING -> EMAIL_VERIFIED -> APPROVED` or `REJECTED`.
2. `LMSProClub.status` records a mixture of admission and operational state:
   `PENDING`, `APPROVED`, `WAITING_LIST`, `SUSPENDED` or `WITHDRAWN`.
3. The normal application approval path marks both the Application and Club `APPROVED`, even when
   every requested Team is still `NEW_CLUB_PENDING_TEAM`.
4. The application wait-list path marks the Application `APPROVED`, correctly recognising that a
   wait-listed Club has still passed onboarding, while setting the Club to `WAITING_LIST`.
5. A Team can currently be `CURRENT` while `aggId` is null. The Team Approval surface explicitly
   describes this state as **Approved & Unallocated**.
6. Team status and division allocation can be changed independently. Removing or changing a
   division does not reconcile the Club's status.
7. Several Club lists, dashboard counts, communication cohorts, registration guards and workflow
   selectors equate `ClubStatus.APPROVED` with active/current participation.
8. Season cloning currently carries the source Club status and Team status forward rather than
   deriving the destination Club's participation state from destination-season allocations.

The requested rule is therefore not a safe label-only change. A direct automatic
`APPROVED <-> WAITING_LIST` update without aligning these consumers could hide a Club from
communications, prevent its officials from registering Teams, distort counts or preserve the
wrong status into a new season.

#### Verified CRUD, table, filter and count contradiction

`ClubStatus` has no `CURRENT` enum value. The currently deployed application nevertheless presents
the same stored `APPROVED` value under several different business labels:

- the main Clubs table renders `APPROVED` as a **Current** badge;
- its default status filter stores `ClubStatus.APPROVED` but labels the option **Current**;
- the main Clubs add flow defaults a directly created Club to `PENDING`, while the season-level
  Clubs add flow defaults the same shared create procedure to `APPROVED`;
- the create/edit Club modal on that same page labels the same value **Approved** and explains
  `Approved = active in season`;
- that modal omits `WAITING_LIST`, although the table and filter display it;
- the season-level Clubs editor labels `APPROVED` as **Approved** and does include
  `WAITING_LIST`;
- the Club detail editor labels `APPROVED` as **Approved** and omits `WAITING_LIST`;
- the main dashboard queries `APPROVED` Clubs and labels the count **Active Clubs**;
- another dashboard card queries `APPROVED` Clubs and labels the result **Registered Clubs**;
- the season statistics query `APPROVED` Clubs and label the result **Approved Clubs**; and
- the communications cohort picker exposes `APPROVED` as **Approved**.

The current queries are internally counting the stored `APPROVED` value, but their displayed
meaning is not stable. They do not prove that each counted Club has a current, division-allocated
Team. Likewise, the Club table's Team count currently counts Teams whose status is `CURRENT`, even
though that status may presently coexist with a null division allocation.

Later planning must therefore define each count and selector by business cohort rather than merely
renaming its label:

- **Admitted Clubs** - onboarding/admission has been approved;
- **Current Clubs** - at least one qualifying current, division-allocated Team;
- **Waiting List Clubs** - admitted with zero qualifying current, division-allocated Teams;
- **Registered Clubs** - define explicitly whether this means all admitted, all non-terminal, or
  every Club record; and
- **Current Teams** - current and validly division-allocated under the accepted final invariant.

### 21.3 Recommended Domain Separation

Later bounded planning should preserve two separate authorities:

#### Admission/onboarding authority

- `LMSProClubApplication.status = APPROVED` means the league accepted the application.
- That evidence remains approved when the Club is Current or Waiting List.
- Team placement must never mutate the historic Application decision.
- Directly created or imported Clubs that have no Application require equivalent explicit,
  auditable admission evidence; admission must not be inferred from a Team count.

#### Seasonal participation authority

The business-facing Club participation states should be:

- **Current** - the admitted Club has at least one Team in the same season whose status is
  `CURRENT` and whose division/AGG allocation is non-null and valid;
- **Waiting List** - the admitted Club has zero such Teams while retaining the distinct evidence
  for unallocated and consciously wait-listed Teams;
- **Suspended** - an explicit disciplinary or administrative override;
- **Withdrawn** - an explicit terminal operational decision; and
- **Pending** - only while admission/onboarding itself remains undecided.

The existing database value `APPROVED` currently represents the business-facing **Current** state
in several surfaces. Later planning should determine whether to rename that enum value or retain it
as a compatibility value while presenting the truthful `Current` label. No enum or migration
decision is made by this CR.

Current and Club Waiting List are derived from qualifying Team allocation evidence. Team Waiting
List remains a conscious status decision. Club participation should not remain an unconstrained
choice in a generic Club CRUD status dropdown. The later surface contract should:

- show the derived seasonal participation state read-only with its reason/evidence;
- keep Application approval within the onboarding review workflow;
- provide explicit authorised actions for suspension, withdrawal and reinstatement;
- provide an explicit admitted/direct-create workflow where a Club does not originate from an
  Application;
- prevent a manual Club edit from contradicting the derived Current/Club Waiting List aggregate.

### 21.4 Team Status And Division Invariant

The preferred target contract is:

```text
Team CURRENT
-> valid same-tenant, same-season division/AGG allocation

Team WAITING_LIST
-> explicit authorised waiting-list decision

Team unallocated
-> retained for Division Manager allocation work
-> excluded from Current counts
-> not automatically WAITING_LIST
```

Accordingly:

- approving and allocating a Team should set its division and `CURRENT` status atomically;
- a Team accepted in principle but not allocated remains the distinct reviewed/unallocated state
  used by the Division Manager workflow;
- moving a Team to `WAITING_LIST` requires a conscious authorised status decision;
- removing the last valid division allocation should not leave the Team `CURRENT`;
- assigning a waiting-list Team to a valid division should move it to `CURRENT`;
- pending-review states remain distinct from both Current and Waiting List; and
- `SUSPENDED`, `WITHDRAWN`, `CANCELLED`, `AGED_OUT`, `INACTIVE` and `NO_RESPONSE` Teams do not make
  a Club Current.

This removes the contradictory `CURRENT + unallocated` combination without silently converting
the reviewed/unallocated state to Waiting List. Later planning must preserve and name that
operational state consistently.

### 21.5 Recommended End-To-End Transitions

#### New Club accepted

1. Application becomes and remains `APPROVED`.
2. Club is admitted, provisioned and available to its authorised officials.
3. Club begins Waiting List because no Team is yet Current and division-allocated.
4. Requested Teams remain pending review until the league decides their placement.

#### First Team allocated

1. The Team's valid division allocation and `CURRENT` status are committed together.
2. The Club becomes Current in the same controlled operation.
3. The transition is audited once and may drive a bounded notification only if later accepted.

#### Additional Team allocated or wait-listed

- The Club remains Current while at least one qualifying Team remains.
- A newly wait-listed Team does not make the whole Club Waiting List while another qualifying Team
  remains Current.

#### Last qualifying Team ceases to be current and allocated

1. The Team transition and allocation change are committed together.
2. The admitted Club becomes Waiting List while each remaining Team retains its actual
   unallocated, waiting-list or other non-current status.
3. Club officials retain the access required to manage the Club and submit or amend future Team
   requests.
4. Onboarding remains approved and is not repeated.

#### Team later reallocated

- The Team returns to `CURRENT` with its valid division allocation.
- The Club returns to Current without a new onboarding decision.

#### Manual Club overrides

- `SUSPENDED` and `WITHDRAWN` take precedence over derived Current/Waiting List state.
- Team allocation must not silently reactivate a suspended or withdrawn Club.
- Reinstatement must be an explicit authorised and audited Club action, followed by evaluation of
  the actual Team allocation evidence.

### 21.6 Required Alignment Surface

A later bounded slice must inventory and align every retained writer and consumer, including:

- Application approve, wait-list and reject paths;
- direct Club creation and import;
- Team registration, approval, wait-list, allocation, de-allocation, bulk status and edit paths;
- Team cancellation, suspension, withdrawal, no-response, ageing and deletion paths;
- age-group changes that clear a division;
- season clone, continuation and roll-forward;
- Club lists, detail pages, filters, badges, quick statistics and dashboards;
- Club-official access and Team-registration guards;
- key-date confirmations, announcements, email composition and communication cohorts;
- directory/public eligibility where applicable; and
- audit, notification and historic reporting.

The exact qualifying Team count must be tenant- and season-scoped and should be calculated as:

```text
count(
  Team.organizationId = Club.organizationId
  AND Team.seasonId = Club.seasonId
  AND Team.clubId = Club.id
  AND Team.status = CURRENT
  AND Team.aggId references a valid division in that same tenant and season
)
```

All status reconciliation must be idempotent and concurrency-safe. If participation state is
persisted for filtering and reporting, the Team mutation and Club reconciliation should share one
transaction or an equivalently strong repairable contract. It must not depend on a browser action
being the only writer.

### 21.7 Access And Communications Guard

Waiting List is not suspension.

A Club moving from Current to Waiting List must not automatically:

- deactivate Club officials;
- remove the Club dashboard;
- prevent an admitted Club from submitting Team requests;
- erase or hide historic Club communications;
- remove the Club from every operational email audience;
- revoke admission or Application approval; or
- behave as withdrawal.

Each consumer must request the correct cohort explicitly:

- **admitted Clubs** may include both Current and Waiting List;
- **currently participating Clubs** include only Clubs with qualifying allocated Teams;
- **waiting-list Clubs** include admitted Clubs with zero qualifying allocated Teams;
- **all operational Clubs** may include Current, Waiting List and other explicitly selected
  non-terminal states; and
- suspended/withdrawn handling remains purpose-specific.

This distinction is especially important because several current queries filter only
`ClubStatus.APPROVED`.

### 21.8 Season Boundary

Participation is season-specific. A new-season Club must not become Current merely because its
source-season predecessor was Current.

Season clone and roll-forward should:

- retain durable Club identity/lineage and historic admission evidence;
- create or retain destination-season Team records according to the accepted continuation rules;
- reconcile the destination Club from destination-season Team allocations;
- set the destination Club to Waiting List where no qualifying allocation exists, without
  changing any unallocated Team to Team Waiting List; and
- avoid changing the closed source season's historic status.

### 21.9 Acceptance Principles

Remedial item 3 is successful when:

1. an approved Application remains approved regardless of seasonal Team placement;
2. a newly admitted Club with no qualifying Team is a Waiting List Club while its Teams retain
   their actual individual states;
3. a Club becomes Current when its first Team becomes both current and division-allocated;
4. a Club remains Current while any qualifying Team remains;
5. a Club becomes Waiting List when its last qualifying Team ceases to qualify;
6. no `CURRENT` Team remains division-unallocated under the accepted final contract;
7. suspended and withdrawn Club decisions cannot be overwritten by Team reconciliation;
8. Waiting List Club officials retain their accepted access and Team-request capability;
9. dashboard counts, filters, communications and season rollover use the correct admitted/current/
   waiting-list cohort;
10. every Club badge, editor, filter, count and communication selector uses one defined business
    term and never exposes `APPROVED` as both Approved and Current without explanation;
11. a generic CRUD edit cannot contradict the derived Current/Waiting List state;
12. every retained writer converges idempotently under same-request retries and concurrency;
13. historic onboarding, Club, Team, allocation, communication and audit evidence is preserved;
    and
14. no implementation begins from this CR input.

### 21.10 Business Defaults For Later Review

The reconciled defaults and gates are:

- **yes** - a Registered/admitted Club with no qualifying Current/allocated Team is Club Waiting
  List;
- **no automatic Team conversion** - unallocated or pending Teams do not become Team Waiting List;
- **explicit Team decision required** - Team Waiting List remains conscious even while its Club
  aggregate is Waiting List;
- **yes** - one current and validly allocated Team is sufficient for the Club to be Current;
- **no** - a suspended, withdrawn, cancelled, inactive, aged-out or no-response Team does not count;
- **no** - Waiting List does not remove Club-official access or undo onboarding;
- **no** - season clone does not carry Current blindly; it recalculates from destination evidence;
  and
- **no automatic notification** - C1 communicates participation changes manually.

### 21.11 Live-Data Safety And Controlled Promotion

LMSPro is a live, operational system. Remedial item 3 will eventually act on real Club,
Application, Team, division, User-access, season and communications evidence. The normal
`feature branch -> dev -> origin/dev -> staging -> main` promotion route is necessary but is not,
by itself, sufficient protection for production data.

Later planning and implementation must treat the production data contract as a controlling
constraint:

1. **No assumption of a clean baseline.** Existing combinations such as `APPROVED` Clubs with no
   qualifying Teams, `CURRENT` Teams with null divisions, wait-listed Clubs with mixed Team states,
   direct/imported Clubs without Applications and cloned-season inconsistencies must be expected
   and measured.
2. **Read-only inventory first.** Before schema or behaviour changes, provide tenant- and
   season-scoped read-only reports that count every relevant state combination and identify only
   safe record identifiers. Do not print personal contact data, credentials or unrestricted
   metadata.
3. **Classify before correcting.** Separate deterministic conversions from ambiguous records.
   Ambiguous or contradictory live records must be retained and surfaced for authorised review;
   they must not be silently forced into Current or Waiting List.
4. **No destructive semantic backfill.** Do not delete Clubs, Applications, Teams, allocations,
   officials, communications or audit evidence to make the new invariant pass. Do not rewrite
   historic closed-season truth as if the new rule had always existed.
5. **Forward-only compatibility.** Where persistence changes are required, prefer an additive or
   expand/contract sequence that allows the currently deployed application and the candidate
   application to coexist safely during promotion and rollback. Do not rename or remove the
   `APPROVED` enum value in one irreversible step without a separately proven compatibility plan.
6. **Dry-run reconciliation.** Any production reconciliation command must be bounded,
   tenant-/season-scoped, idempotent, dry-run by default and capable of producing before/after
   counts without mutation. Mutation mode requires explicit operator intent and durable audit.
7. **Transactional convergence.** Each applied correction must preserve same-tenant ownership and
   update the minimum related evidence atomically. A partial Team/Club conversion must roll back
   rather than leave a more contradictory live state.
8. **User-access protection.** Preflight must prove that a Current-to-Waiting-List reconciliation
   will not deactivate Club officials, revoke dashboard access or block the admitted Club's
   accepted Team-request workflow.
9. **Communication protection.** Preflight must prove that historic Email visibility and intended
   admitted/current/waiting-list cohorts remain available under the new terminology. A production
   conversion must not silently remove Clubs from necessary operational messages.
10. **Representative rehearsal.** Validate against disposable PostgreSQL data representing every
    observed production state combination, then rehearse the exact migration/reconciliation
    sequence against an authorised production snapshot or structurally representative clone.
11. **Migration and code ordering.** The later implementation plan must state the exact safe order
    for schema, compatibility code, reconciliation, constraint enforcement and UI terminology.
    Migration-before-code or code-before-migration must not be assumed generically.
12. **Explicit live preflight and go/no-go.** Immediately before Main promotion, rerun the
    read-only production inventory, confirm migration history and candidate ancestry, preserve an
    approved database recovery point, record rollback commands and stop for the authorised
    production decision.
13. **Post-promotion verification.** Verify live LMSPro login, Club-official access, Club and Team
    counts, application history, Team allocation workflows, dashboards, communication cohorts and
    season views before declaring the data lifecycle complete.
14. **Rollback recognises data reality.** Code rollback and data recovery are separate controls.
    The plan must define which forward-applied data remains compatible with the previous code and
    when database point-in-time recovery would be required. It must never describe a Git revert as
    sufficient database rollback.

Staging evidence remains essential, but a green staging run does not authorise an unexamined live
reclassification. Production inventory may differ from staging and must be evaluated independently
at the controlled promotion gate.

No live inventory, backfill, migration, reconciliation or environment change is authorised by this
CR input.

## 22. Remedial Item 4 - Responsive Team Status And Waiting-List-Position Visibility

### 22.1 Business Observation

The League Teams page and C2 Club Teams page both show Team status in a table badge. For
waiting-list Teams the badge may also include the Team's numeric position and total, for example:

```text
Waiting List 3/12
```

As the viewport narrows, the table compresses the status cell and the badge. The numeric value can
become clipped or hidden, especially on mobile. This removes decision-relevant information from
the people most likely to consult it quickly on a phone.

The required outcome is not merely that the badge remains coloured. The full visible words
**Waiting List** and the available position/total must remain readable without hover, opening a
tooltip or guessing from colour.

### 22.2 Verified Current Surface

Read-only review confirms:

- `/app/lmspro/teams` renders a wide League table containing Team number, Club, notes, change
  requests, Team name, age group, division, manager, status and free days;
- `/app/lmspro/club/teams` renders a wide Club table containing age group, Team number, Team name,
  change request, division, status, Team manager and free days;
- neither table currently defines a deliberate mobile column-priority or compact-card contract;
- neither table currently wraps the full result in a purposeful horizontal table `ScrollArea`;
- global page styling suppresses horizontal body overflow, so table width pressure can be expressed
  as clipping or compression rather than an obvious supported scroll interaction;
- the League waiting-list badge adds `whiteSpace: nowrap` and relaxes label overflow, but the badge
  and containing table cell can still be squeezed;
- the Club waiting-list badge uses the default Badge sizing and has fewer anti-collapse
  protections; and
- both surfaces already provide a row/detail interaction where lower-priority evidence can remain
  accessible if it is removed from the narrow summary row.

This is a shared responsive-presentation defect. It does not require a change to waiting-list
ordering, Team status, division allocation or the numeric values returned by the server.

### 22.3 Information Priority

At restricted width, the row must prioritise the information needed to identify the Team and
understand its immediate position:

#### League Team summary

1. Team/Club identity;
2. age group;
3. status, including visible waiting-list position/total where available; and
4. division or **Unallocated** state.

#### Club Team summary

1. Team name;
2. age group;
3. status, including visible waiting-list position/total where available; and
4. division or **Unallocated** state.

The following may leave the narrow summary row, but must remain available in the row detail or an
equivalent accessible interaction:

- Team number;
- free-day usage;
- Team-manager contact detail;
- notes and change-request indicators; and
- secondary external-division links.

The Team number may remain available to assist waiting-list ordering in the detail/tooltip, but it
must not consume scarce mobile row width ahead of the actual waiting-list position.

### 22.4 Recommended Responsive Contract

Later bounded planning should use one shared Team-status presentation contract on both pages.

#### Status pill

- never ellipsise or clip the status words;
- do not allow the pill to shrink below the width needed for its visible content;
- use `white-space: nowrap`, non-shrinking flex behaviour and an explicit content-based minimum
  inline size;
- keep readable text at or above the accepted small-body accessibility size rather than solving
  width pressure with progressively tiny text;
- permit a deliberate break between the status and position only if a two-line compact pill is
  tested and remains visually clear;
- render the position as visible text, preferably `3/12` or `3 of 12`, alongside **Waiting List**;
- retain the richer explanatory tooltip for pointer/keyboard users, but never make the tooltip the
  only source of the position; and
- expose a complete accessible name such as `Waiting List, position 3 of 12`.

#### Narrow layout

The preferred mobile treatment is a compact stacked row/card rather than forcing every desktop
column into one compressed line:

```text
Team name                         Waiting List
Club / age group                 Position 3 of 12
Division name or Unallocated
```

Where the existing Table is retained at intermediate widths:

- hide Team number and Free Days first;
- collapse Team-manager contact detail into the row detail;
- preserve Team/Club identity, age group and status;
- give the status column a non-shrinking minimum width;
- truncate a long division display name with an ellipsis only after reserving status width;
- provide the full division name through an accessible title/tooltip and in row detail; and
- use an explicit table `ScrollArea` only as a supported fallback, not as the sole mobile design.

The implementation should not abbreviate **Waiting List** to an unexplained icon or initials. Colour
must remain supplementary and not be the only status signal.

### 22.5 Shared Behaviour And Scope

The later remediation should avoid two pages drifting again by sharing, where practical:

- status label and colour mapping;
- waiting-list position formatting;
- accessible status text;
- compact/mobile status presentation; and
- breakpoint/column-priority rules.

It must preserve:

- the League rule that a waiting-list position is scoped to the selected age group;
- the Club view's authorised waiting-list evidence;
- current sorting and filtering authority;
- row/detail navigation and keyboard operation;
- Team and Club tenant isolation; and
- every existing status value and server-calculated position.

It adds no status mutation, waiting-list reorder, division allocation, free-day behaviour, Team
number change, email, schema, migration or live-data reconciliation.

### 22.6 Responsive And Accessibility Validation

A later bounded slice must validate both pages with representative long Team, Club and division
names and at least the following states:

- Current;
- Waiting List with single- and multi-digit position/total;
- Pending Approval;
- New Club Pending;
- Awaiting Club Approval;
- Suspended;
- Withdrawn;
- Cancelled;
- No Response; and
- Unallocated division.

Validation must cover:

- supported phone portrait and landscape widths;
- tablet and desktop widths;
- browser zoom to at least 200%;
- keyboard-only navigation;
- screen-reader accessible status wording;
- no clipped or overlapped status/position text;
- no inaccessible evidence caused by hidden columns;
- long division-name truncation with a discoverable full value;
- row/detail opening without accidental nested-action activation; and
- equivalent behaviour on the League and Club Team surfaces.

### 22.7 Acceptance Principles

Remedial item 4 is successful when:

1. **Waiting List** remains visibly readable at every supported width;
2. an available waiting-list position and total remain visibly readable without hover;
3. status text does not collapse, ellipsise or shrink below the accepted accessible size;
4. lower-priority columns yield space before Team identity, age group, status or division state;
5. hidden Team number, Free Days, manager and operational indicators remain available through
   accessible row detail;
6. long division text cannot displace or obscure Team status;
7. the League and Club pages share the same status semantics and responsive behaviour;
8. no Team status, waiting-list ordering, division, free-day or server-authority behaviour changes;
   and
9. no implementation begins from this CR input.
