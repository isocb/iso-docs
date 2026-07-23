# LMSPro Consolidated Email Integrity, Club Visibility And Remedial Work CR Input

Date: 2026-07-22

Module: LMSPro / SeasonPro using the shared IsoStack communications service

Status: Consolidated CR input opened; remedial item 1 captured; R8-A staging acceptance
complete; eligible for later triage but no executable slice selected

Priority: High for communications-history integrity and C2 access control

Authoritative roadmap:

`docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`

## 1. Planning-Only Boundary

This document is a consolidated change-request input. It records evidence, business intent,
required outcomes, dependencies and open questions for later triage and bounded slice planning.

It does not:

- authorise application code, schema, migration, infrastructure or deployment work;
- assign or select an executable remediation slice;
- change the active R8-A attachment-delivery lane;
- amend roadmap status or lifecycle evidence;
- authorise retrospective production-data mutation; or
- replace the authoritative LMSPro roadmap.

The separate control window remains responsible for triage, slice selection, implementation,
testing, lifecycle records, promotion and roadmap reconciliation.

## 2. Source Request And Consolidated CR Structure

The business has identified five email-remediation concerns that should ultimately be considered
as one coordinated LMSPro email-remedial programme rather than five unrelated fixes.

This document opens that consolidated CR and records the first item in full:

1. **Club dashboard email visibility and history integrity** - captured in this revision;
2. email-remediation item 2 - reserved for later business evidence;
3. email-remediation item 3 - reserved for later business evidence;
4. email-remediation item 4 - reserved for later business evidence; and
5. email-remediation item 5 - reserved for later business evidence.

Reserved items are not requirements and must not be inferred or implemented until the business
adds their evidence and desired outcomes.

The active attachment-delivery cycle has now completed its staging test/documentation gate.
Production remains governed separately by the combined-release HOLD. This CR is therefore
eligible for later triage when selected by the roadmap, but capturing or committing it does not
select implementation, displace the production decision or infer requirements for items 2-5.

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

This consolidated CR must consume the final accepted R8-A delivery and status contracts. It must
not reopen attachment transport, private R2 policy, provider routing, rate limiting or retry while
that lifecycle remains active.

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

LMSPro can create successor Club records during season cloning. Later planning must define whether
historic communication follows a durable Club lineage into the current dashboard or remains bound
to the exact season Club record. Name matching alone must not become historic access authority.

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
- implementing the four reserved remedial items before their evidence is supplied; and
- roadmap, deployment or production-data changes from this CR input.

## 14. Dependencies And Sequencing Implications

Hard dependencies:

1. complete, test, document and sign off the active R8-A attachment lifecycle;
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

1. This is remedial item 1 within a planned five-item consolidated LMSPro email CR.
2. The consolidated CR remains subordinate to the LMSPro roadmap and awaits triage after R8-A
   attachment sign-off.
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

## 18. Open Business And Planning Questions

The following must be answered or explicitly deferred during later triage/planning. They do not
reopen the settled many-to-many direction.

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

The controlling window may later:

1. append remedial items 2 through 5 when their business evidence is supplied;
2. complete and close the active R8-A lifecycle;
3. triage the consolidated CR as one coordinated email-remediation capability;
4. decide whether item 1 requires one or several bounded slices; and
5. reconcile accepted work into the authoritative roadmap without treating this CR as execution
   authority.
