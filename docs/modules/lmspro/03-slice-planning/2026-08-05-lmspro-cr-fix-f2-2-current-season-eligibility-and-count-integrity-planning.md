# LMSPro CR-Fix F2.2 — Current-Season Eligibility And Count Integrity Planning

Date: 2026-08-05

Module: LMSPro / SeasonPro communications

Status: **IMPLEMENTED AT `ec7e0cc4`; AUTOMATED/BUILD PASS; STAGING HUMAN SMOKE 15/15 PASS;
EXACT THROUGH MAIN; RENDER LIVE EXACT-BUILD CONFIRMATION PENDING**

Accepted corrected triage:

`docs/modules/lmspro/02-triage/2026-08-05-lmspro-cr-fix-f2-2-current-season-eligibility-and-count-integrity-triage.md`

Parent CR-Fix:

`docs/modules/lmspro/01-cr-inputs/CR-Fix-2026-08-05-lmspro-cohort-email-draft-persistence-and-audience-selection.md`

Predecessor F2.1 plan:

`docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f2-1-cohort-taxonomy-and-picker-correction-planning.md`

Existing F3 policy refinement:

`docs/modules/lmspro/01-cr-inputs/2026-08-05-lmspro-cr-fix-f3-uploaded-file-only-acknowledgement-planning-refinement.md`

Authoritative LMSPro roadmap:

`docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`

Implementation confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-08-05-lmspro-cr-fix-f2-2-current-season-eligibility-and-count-integrity-confirmation.md`

## 1. Planning Outcome

Replace the current resolver's undifferentiated filter concatenation with one
current-season audience plan that distinguishes additive recipient sources from
restrictive eligibility filters.

The outcome must make the C1's selected scope truthful before an Email is saved:

```text
eligible recipients(Age Groups / Divisions / explicit Clubs)
UNION eligible recipients(League Roles)
UNION eligible recipients(Club Roles)
UNION eligible recipients(other deliberately selected audience sources)
-> global normalised-address deduplication
-> exact eligible Club histories
```

Current season and the selected Team/Club statuses are applied inside each source resolver
where the source has the corresponding authoritative entity relationship. They are not
recipient-producing sources and never add an audience by themselves.

## 2. Authoritative Product Vocabulary

| Term | Meaning |
| --- | --- |
| Current season | The one tenant LMSPro season with `isCurrent = true`, resolved on the server |
| Current Team | `LMSProTeam.status = CURRENT` in the current season |
| Current Club | Canonical participating Current Club: current-season `APPROVED` Club with at least one `CURRENT` Team allocated to a current-season Division |
| Team-status scope | One or more selected TeamStatus values; defaults to `CURRENT` |
| Club-status scope | One or more selected ClubStatus values; defaults to canonical Current |
| Audience source | A deliberate recipient-producing selection such as an Age Group, Division, explicit Club, League Role or Club Role |
| Structural source | A selected Age Group, Division or explicit Club plus its selected recipient types |
| Recipient type | Team Manager, primary-contact Club Secretary or Other Club Official derived from qualifying entities |
| Club Role | Exact active C1-defined `ModuleRole` with `roleScope = CLUB` |
| Eligibility filter | Current season, Team Status or Club Status; narrows an applicable source but never creates recipients |
| Provider recipient | One normalised email address sent one provider message |
| Club history | One distinct qualifying Club dashboard visibility record for the Email |

`Club Secretary` under recipient types remains a product label for
`LMSProClub.primaryContact`. It is not inferred from a Club Role name.

## 3. Canonical Filter Algebra

### 3.1 Defaults

Every new compose operation begins with:

```text
season = server-resolved current season
teamStatuses = [CURRENT]
clubStatuses = [CURRENT]
```

The browser displays both defaults as checked. The server applies the same defaults when
the fields are omitted, so request manipulation cannot broaden the audience.

At least one Team status and one Club status must remain selected. An empty status array is
invalid rather than meaning `all`.

### 3.2 OR Within One Source Type

Examples:

```text
Age Group U8 OR U9
Team Status CURRENT OR WAITING_LIST
Club Status CURRENT OR WAITING_LIST
Club Role Coach OR Welfare Officer
```

### 3.3 UNION Across Recipient-Producing Sources

Example:

```text
eligible recipients(U8 OR U9, Team CURRENT, Club Current)
UNION eligible recipients(League Role X)
UNION eligible recipients(Club Role Y, Club Current)
-> deduplicate by normalised email address
```

Age Group/Division/Club sources, League Roles, Club Roles and other recipient-producing
cohorts are additive. Selecting a League Role or Club Role must add its independently
eligible recipients; it must not narrow a simultaneously selected structural source.

### 3.4 Status Filters Never Produce An Audience

Team Status and Club Status are restrictive controls only:

- selecting or changing statuses without any recipient-producing source resolves zero
  recipients;
- a status selection must never add all matching Team or Club primary contacts;
- Team Status constrains a source only when that source is resolved through Teams;
- Club Status constrains a source only when that source is resolved through Clubs; and
- current-season authority constrains every source whose underlying entity is season-bound.

### 3.5 Source-Specific Eligibility

Eligibility is evaluated independently for each source before the source results are
unioned:

- Age Group and Division sources apply current season, selected Team statuses and selected
  Club statuses before deriving the chosen recipient types;
- an explicit Club source applies selected Club statuses and current-season participation
  rules where applicable;
- a Club Role source applies active-user/exact-role authority and authoritative membership
  in an independently status-eligible Club; an Age Group or Division selection does not
  narrow that role source;
- a League Role source applies tenant, active-user and exact League Role authority. Team
  and Club statuses do not apply where no authoritative Team or Club relationship exists;
  and
- other sources such as Referees or Venues remain additive and apply only the eligibility
  predicates supported by their authoritative relationships.

No selector may acquire a fabricated Team/Club relationship merely so a status filter can
be applied. The source/count breakdown must show which selected source added recipients
and which eligibility filters applied.

The canonical algebra is:

```text
eligible(source) = candidates(source)
                   INTERSECT current season, when season-bound
                   INTERSECT any selected Team status, when Team-derived
                   INTERSECT any selected Club status, when Club-derived

final audience = DEDUPLICATE(UNION eligible(each selected audience source))
```

`INTERSECT any selected status` means OR among the checked values inside that status
dimension. It does not mean a recipient must possess every checked status.

## 4. Qualifying Entity Plan

### 4.1 Resolve Current Season Once

Resolve the tenant's current season at the start of the audience operation. Absence or
ambiguity must fail closed with a clear operator error.

Do not rely only on an Age Group or Division foreign key to imply the season. Every Team,
Club, Age Group and Division query must carry the exact tenant and current-season scope.

### 4.2 Resolve Each Structural Source Independently

Each selected structural source produces its own eligible entity set:

- an Age Group source selects Teams in any chosen Age Group, then applies organization,
  exact current season, selected Team statuses and selected Club statuses;
- a Division source selects Teams in any chosen Division, then applies the same applicable
  eligibility constraints; and
- an explicit Club source selects any chosen Club, then applies organization, applicable
  current-season participation and selected Club statuses.

Do not intersect one selected structural source with another. For example, selecting U8
and Division A means `eligible recipients(U8) UNION eligible recipients(Division A)`, not
only U8 Teams in Division A. Multiple IDs inside the same source type are OR alternatives.

Selected Age Group, Division and Club IDs must first be validated against the tenant and,
where season-bound, the exact current season. Cross-tenant, old-season or unknown IDs fail
closed.

### 4.3 Resolve Qualifying Clubs

For each independently resolved source, its eligible Club contexts are constrained by:

- organization;
- exact current season;
- selected Club statuses; and
- that source's Team evidence where Age Group, Division or Team Status is applicable.

Canonical `Current` retains the existing participation definition: `APPROVED` plus at least
one `CURRENT` Team allocated to a Division belonging to the current season. Selecting an
additional status deliberately broadens only the Club-status dimension.

### 4.4 Apply Recipient Types

Within each independently eligible structural source:

- Team Managers come only from qualifying Teams with a valid manager email;
- Club Secretaries come from each qualifying Club's `primaryContact`;
- Other Club Officials come from authoritative `LMSProClubOfficial` memberships on
  qualifying Clubs and active Users with valid email addresses.

Do not produce one Club Secretary record per Team. Produce one Club primary-contact record
per eligible Club within that source, union all sources, and then perform global address
deduplication.

### 4.5 Resolve Club Roles As An Additive Source

When one or more exact Club Roles are selected, include only Users who:

- are active in the tenant;
- hold at least one selected exact active `CLUB` ModuleRole; and
- have an authoritative `LMSProClubOfficial` membership on at least one independently
  eligible Club under the applicable current-season/Club-status rules.

Retain every qualifying membership Club ID for Club-history evidence. Do not infer that the
selected ModuleRole is assigned on a particular membership row; the schema does not express
that claim.

Do not restrict this source to Clubs represented by a simultaneously selected Age Group,
Division or explicit Club source. Union its recipients with those structural recipients,
then perform global deduplication.

If product acceptance requires exact Role-X-on-Club-Y assignment, stop F2.2 for a separate
role-authority/schema decision.

### 4.6 Resolve League Roles And Other Sources Additively

League Roles resolve independently through exact active `LEAGUE` ModuleRole authority and
active tenant Users. They are unioned with all other eligible sources. Team and Club status
filters do not exclude a League Role recipient when the schema supplies no Team or Club
relationship for that source.

Apply the same rule to Referee, Venue and other recipient-producing cohorts: resolve the
source through its own authority and applicable eligibility predicates, then union it. Do
not turn a source into a constraint on another source.

## 5. Unified Resolver Contract

Create one LMSPro audience-planning boundary used by:

- live preview counts;
- create draft;
- update draft; and
- any explicit re-resolution operation.

It should return a structure equivalent to:

```text
seasonId
effectiveTeamStatuses
effectiveClubStatuses
per-source qualifyingTeamIds/qualifyingClubIds where applicable
providerRecipients with exact clubIds
providerRecipientCount
clubHistoryCount
source/count/eligibility breakdown suitable for truthful UI display
```

Save Draft persists the resulting recipient rows and Club histories atomically using the
already-corrected F1 path. Send continues to use those persisted recipients; provider code
must not reinterpret picker filters.

The existing generic `resolveEmailRecipients` may perform the final source union and merge
manual recipients, but status filters must not enter that union as recipient sources. It
must consume the independently eligible source results and perform one global address
deduplication while retaining every exact authorised Club context.

## 6. Filter Persistence And Compatibility

Use the existing JSON cohort-filter storage; no schema migration is expected.

Persist enough canonical scope to reopen exactly:

- selected current-season structural IDs;
- effective Team statuses;
- effective Club statuses;
- recipient types;
- exact Club Role IDs; and
- every selected additive audience-source ID.

The earlier control-owner decision remains: pre-release drafts are not a compatibility
target and the sole user will delete them. Before F2.2 staging acceptance, delete drafts
created under the former status-as-audience-source or global-intersection planning
semantics. Do not write a migration or silently reinterpret their already-persisted
recipient rows.

New create/update inputs which omit status fields default safely to Current. Invalid,
empty, cross-tenant or old-season filters fail before persistence.

## 7. UI Plan

### 7.1 Status Controls

Place a visible `Audience scope` panel beside the structural cohort selector:

```text
Season: <current season name> (fixed)
Team status: [x] Current  [ ] Approved & Unallocated  [ ] Waiting List ...
Club status: [x] Current [ ] Pending [ ] Waiting List [ ] Suspended [ ] Withdrawn
```

- both controls are multi-select;
- Current is checked initially;
- C1 may add or replace statuses, but cannot leave the dimension empty;
- labels must map exactly to supported enum values;
- include `AGED_OUT` or deliberately document its exclusion; the current Team Status list
  exposes legacy `INACTIVE` but omits `AGED_OUT`; and
- explain that statuses restrict applicable selected audience sources and never add
  recipients.

### 7.2 Recipient And Role Controls

- keep the F2.1 recipient-type panel adjacent to Age Groups/Divisions;
- keep Club Role names exactly as configured by C1;
- explain that Age Group/Division, League Role and Club Role selections add eligible
  recipient sources;
- explain that a selected Club Role is resolved through status-eligible Club membership
  independently of any selected structural source;
- do not imply that primary-contact Club Secretary depends on a role named Club Secretary;
  and
- keep source-specific eligibility and additive contribution clear in the preview.

### 7.3 Truthful Counts

Replace ambiguous badges with labels equivalent to:

```text
<n> provider recipients
<n> qualifying Club histories
```

Add help text:

```text
Provider recipients are deduplicated email addresses.
Club histories are distinct qualifying Clubs whose dashboards will show the communication.
```

Where practical, show `eligible Teams` and `eligible Clubs` before recipient-type
resolution. All displayed counts must come from the unified resolver, not tree-node sums.

Picker leaf counts must respect the current season and default status scope. A raw count of
all Teams attached to an Age Group is not an acceptable `Current` count.

### 7.4 Recipients-Tab Count Badge

The tab currently renders the count in an extra-small circular Badge. That fixed shape can
clip even a multi-digit count.

- retain the compact count beside the `Recipients` tab;
- use content-width/minimum-width presentation rather than `circle`;
- display the complete resolved count without truncation at least through the candidate-500
  operating range;
- retain the loading indicator while preview resolution is in progress; and
- expose an accessible label equivalent to `<n> resolved recipients`.

### 7.5 Post-Send List State

`handleDraftSaved` deliberately selects the `DRAFT` list filter. A later successful Send
returns to the list but currently leaves that filter in place, making the newly sent Email
appear absent.

On successful Send only:

- close the compose modal;
- return to the Email list;
- clear `statusFilter` to `null` before/with list invalidation; and
- show all Emails without a status predicate.

Keep the existing clearable status filter so C1 can deliberately select a status again.
Do not clear it on a failed Send, and do not change the intentional Draft-filter behaviour
after Save Draft or Duplicate to Draft.

## 8. Server Authority And Failure Behaviour

Server authority must:

- resolve the current season independently of browser input;
- validate every selected ID against tenant and current season;
- validate status values against exact supported enums;
- apply safe Current defaults when status fields are absent;
- reject empty status dimensions;
- build Club histories only from eligible Club contexts contributed by selected sources;
- preserve one provider recipient per normalised address plus all qualifying Club IDs;
- preserve F1 atomic persistence and rollback; and
- return a clear audience-scope error without file/attachment wording.

No provider Send is allowed during preview or Save Draft evidence.

## 9. Candidate Application Surface

Expected bounded source areas:

- `src/core/services/communications/types.ts`;
- `src/core/services/communications/components/cohort-selection.ts` and tests;
- `src/core/services/communications/components/CohortPicker.tsx`;
- `src/core/services/communications/components/ComposeEmailModal.tsx`;
- `src/app/(app)/app/lmspro/communications/page.tsx` for successful-Send list state;
- `src/modules/lmspro/communications/cohort-resolver.ts` and tests;
- a new or extracted LMSPro source-aware eligibility planner and focused tests;
- `src/core/services/communications/routers/emails.router.ts` only to call the unified plan;
- `src/core/services/communications/lib/email-club-audience.ts` only if its input contract
  needs truthful qualifying Club evidence; and
- current communications documentation.

No Prisma schema, migration, provider, attachment, delivery-job or R2 change is expected.

## 10. Automated Evidence Matrix

### 10.1 Season And Status

1. Current-season Age Group excludes a matching old-season Team.
2. Default scope includes `CURRENT` Teams only.
3. Default Club scope includes canonical Current Clubs only.
4. Adding `WAITING_LIST` Team status includes matching waiting-list Teams inside the same
   structural/Club scope only.
5. Adding `WAITING_LIST` Club status includes those Clubs without broadening other
   dimensions.
6. Empty Team or Club status arrays fail.
7. Unknown, cross-tenant and old-season IDs fail.

### 10.2 Additive Sources And Restrictive Eligibility

8. U8 + CURRENT includes Current U8 Teams, not all U8 plus all Current Teams.
9. U8/U9 + CURRENT applies OR within Age Groups and AND with status.
10. Division + Club status restricts to Clubs represented by qualifying Teams in that
    Division.
11. U8 + League Role X is the union of eligible U8 recipients and active League Role-X
    recipients; neither source narrows the other.
12. U8 + Club Role X is the union of eligible U8 recipients and active Role-X Users with
    membership in independently status-eligible Clubs, including eligible Role-X users
    outside U8 Clubs.
13. Team/Club status selections without an audience source produce zero recipients.
14. League Role recipients are not removed by Team/Club statuses where that source has no
    authoritative Team/Club relationship.
15. Club Role names are arbitrary; no `Club Secretary` string branch exists.
16. Primary-contact Club Secretaries are independent of Club Role names.
17. Multiple Club Roles are OR within the role source.

### 10.3 Counts And Deduplication

18. One shared address across several eligible sources and qualifying Clubs produces one
    provider recipient and retains all exact Club histories.
19. Several recipients in one Club produce one Club-history count.
20. A non-qualifying Club contributes neither recipient context nor Club history.
21. Preview, create, update and reopened draft counts agree.
22. The observed shape cannot report more Current-only Club histories than the union of
    independently eligible Current Club contexts.
23. Save Draft invokes no Send/provider operation.
24. Recipient-tab badge visibly renders counts `1`, `12`, `100` and `500` without clipping.
25. A successful Send clears a pre-existing `DRAFT` status filter and reloads the complete
    Email list.
26. A failed Send does not change list/filter state.
27. Save Draft and Duplicate to Draft retain their intentional Draft-filter behaviour.

### 10.4 Regression

28. F1 broad persistence and rollback tests remain green.
29. F2.1 exact League/Club role taxonomy remains green.
30. Manual recipients and explicit Club linking retain current behaviour.
31. No-attachment and attachment delivery selection remain unchanged.
32. Shortcode entity/related-Team context uses only eligible source entities.

## 11. Human Smoke Plan

Use controlled non-sensitive content and Save Draft only until the final gate.

1. Confirm exact current season is displayed and fixed.
2. Confirm Team Current and Club Current are checked by default.
3. Select one Age Group with Team Managers and primary-contact Club Secretaries.
4. Record qualifying Team, provider-recipient and Club-history counts.
5. Add one non-current Team status and confirm only that Age Group's eligible Teams are
   added.
6. Add one non-current Club status and confirm only qualifying Clubs inside the structural
   scope are added.
7. Add an exact C1-defined Club Role and confirm its independently Club-status-eligible
   recipients are added without narrowing the Age Group source.
8. Add one League Role and confirm its active recipients are added without being removed by
   inapplicable Team/Club statuses.
9. Remove all audience-producing selections while leaving statuses selected and confirm
   the count is zero.
10. Save Draft, confirm create/update only, reopen and verify filters/counts are unchanged.
11. Negatively verify an old-season, withdrawn or otherwise excluded Club does not gain a
   history.
12. Verify no `communications.emails.send` mutation or provider event occurred.
13. Confirm the Recipients-tab badge shows the complete resolved count.
14. In a later controlled single-recipient Send, begin from a Draft-filtered list and
    confirm successful Send returns to the unfiltered complete list while the status filter
    remains available.

A later controlled one-recipient Send may prove delivery regression after audience
acceptance. A broad real-recipient Send is not an acceptance test.

## 12. Risk Assessment

| Risk | Impact | Control |
| --- | --- | --- |
| Current defaults applied only in browser | High | Repeat defaults and validation at server authority |
| Additive source is accidentally treated as a constraint and valid recipients are dropped | High | Mixed Age Group/League Role/Club Role union tests |
| Status selector accidentally remains a recipient source and broadens the audience | High | Status-only zero-recipient tests plus source-specific predicate tests |
| Club Role membership is overclaimed as per-Club role assignment | High | Record exact schema limitation and stop if stronger authority required |
| Club histories are built before source eligibility or lost during deduplication | High | Build from eligible source contexts and retain the union of exact authorised Club IDs |
| Preview uses different code from Save Draft | High | One unified resolver contract |
| Existing draft retains unsafe persisted audience | High | Delete designated pre-release drafts; no compatibility inference |
| A status filter is incorrectly applied to a source with no relevant entity relationship | High | Explicit source-by-source applicability tests; never fabricate a relationship |
| Count correction masks rather than fixes recipients | High | Recipient-level fixtures and negative delivery-context assertions |
| Query complexity recreates F1 timeout | High | Bounded set-based queries and real-shape performance regression |
| Count badge clips valid audience sizes | Low | Auto-width visual/component checks across operating-range values |
| Successful Send leaves stale Draft filter | Medium | Success-handler state test; failed-Send and Save Draft negative tests |

## 13. Performance And Atomicity

The unified plan must use bounded, set-based queries. It may not reintroduce one-query-per-
Team, one-query-per-Club or sequential per-recipient persistence.

Required performance evidence includes the existing real-shape 411/candidate-500 safe
fixtures with default Current scopes and at least one multi-status case. The accepted F1
transaction envelope and atomic rollback guarantees remain unchanged.

## 14. Rollback And Stop Conditions

Rollback is a bounded application revert through the normal corridor. No database rollback
should be needed because no schema/data migration is planned.

Stop and return to triage if:

- current season cannot be resolved uniquely;
- exact Club Role-to-Club assignment is required but not represented;
- a schema migration or data backfill becomes necessary;
- counts cannot share the same resolver used for persistence;
- any cross-tenant/old-season entity can enter the plan;
- F1 atomicity or performance regresses;
- provider/attachment behaviour must change; or
- a source's authoritative status/season applicability cannot be determined.

## 15. Explicit Non-Goals

- Renaming or creating Club Roles.
- Assuming a role called `Club Secretary` exists.
- Changing primary-contact ownership.
- Reworking C1/C2/hat-swap access context.
- Implementing the separate F3 attachment/link acknowledgement policy.
- Raising the 300/500 delivery envelope.
- Migrating or repairing pre-release drafts.
- Sending a broad production Email for proof.
- Redesigning the Email list or removing status filtering.

## 16. Accepted Decision And Current Gate

The control owner corrected and then authorised implementation of:

1. the additive-source/restrictive-eligibility algebra;
2. canonical Current Club meaning;
3. active User role plus independently status-eligible Club membership as the Club Role
   source authority, without narrowing it to another selected source;
4. delete/recreate treatment for pre-F2.2 drafts; and
5. the source-specific eligibility applicability in Section 3.5, including no Team/Club
   status filtering of League Roles without an authoritative relationship.

Application commit `ec7e0cc4` implements this boundary. The control owner accepted all 15
staging human-smoke checks and explicitly authorised live promotion. Dev, staging and main,
including their origin refs, are exact at that commit. Render live exact-build confirmation
is the remaining production-evidence step.
