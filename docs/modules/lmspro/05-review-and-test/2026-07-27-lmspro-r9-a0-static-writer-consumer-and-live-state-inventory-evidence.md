# LMSPro R9-A0 Static Writer, Consumer And Live-State Inventory Evidence

Date: 2026-07-27

Module: LMSPro / SeasonPro

Status: EVIDENCE COMPLETE — exact-baseline static inventory and bounded STAGING aggregate
inventory complete; awaiting the next control review

Parent plan:

`docs/modules/lmspro/03-slice-planning/2026-07-27-lmspro-remediation-slice-r9-a0-club-participation-writer-consumer-and-live-state-inventory-planning.md`

Read-only query pack:

`docs/modules/lmspro/05-review-and-test/2026-07-27-lmspro-r9-a0-bounded-read-only-live-state-query-pack.md`

## 1. Verdict

The accepted R9 triage and R9-A0 plan are complete, internally consistent and
proportionate for an evidence-first boundary.

They correctly recognise three valid ways to register/admit a Club:

1. a completed validated Club import through the SeasonPro import tool;
2. the linked two-stage registration form after email validation and an authorised C1
   approval; and
3. deliberate direct creation by an authorised C1 tenant user.

They also correctly keep registration/admission separate from Current seasonal
participation. Source review confirms that this separation is necessary: the current
application overloads `ClubStatus.APPROVED`, permits `CURRENT` Teams without a valid AGG
allocation and uses those raw statuses for several different business cohorts.

The plan did not need expansion before evidence collection. The combined static and STAGING
aggregate evidence is sufficient for the next control review, but it is not sufficient to
infer admission truth for evidence-free Clubs or to authorise implementation, migration or
reconciliation.

## 2. Exact Evidence Boundary

```text
IsoDocs controlling commit reviewed:
0800f40ce671b31bd6c6a0d9b77ede7ebe037b0f

Application source reviewed:
df40f45cda955ef00e8f790de89a476c2463a629

dev/origin-dev:
df40f45c

staging/origin-staging:
df40f45c

main/origin-main:
b9287ffa

Database target:
STAGING; credential-safe fingerprint d18b9abe1450

Database queries:
READ-ONLY PREFLIGHT AND Q1-Q15 COMPLETE; BOTH TRANSACTIONS ROLLED BACK

Application, schema, migration, data, deployed-environment and deployment changes:
NONE
```

The application review used the clean exact-commit worktree at
`/private/tmp/isostack-bedrock-dev-security-20260727`. The application repository remained
unchanged.

## 3. Model And Migration Findings

The current data model contains:

- `LMSProClub.status`, whose enum describes `APPROVED` as an active Club in the current
  season;
- `LMSProClubApplication`, including email validation, reviewer, review timestamp and a
  unique created-Club link;
- `LMSProClubOfficial`, including an authoritative membership junction and `isPrimary`;
- `LMSProTeam.status`, with `CURRENT` as the default;
- nullable Team `ageGroupId` and `aggId`;
- an AGG carrying its own tenant and season identifiers; and
- disciplinary records retaining the previous Club or Team status for restoration.

There is no durable, route-neutral Club admission authority or Club-instantiation source on
the Club row. There is also no composite relation or constraint proving that a Team, Club,
season, age group and AGG all belong to the same tenant and season. Application checks cover
some writers, but the schema permits contradictory or cross-boundary combinations.

The relevant migration ancestry is incremental: import mappings, flexible age groups/AGGs,
Team statuses, Club Applications, Team registration/continuation, Club officials and later
roll-forward states were added separately. No migration currently establishes the accepted
R9-A admission/participation distinction. The first authorised snapshot target failed its
preflight. The corrected STAGING target subsequently passed migration, tenant and season
preconditions; the complete aggregate results are recorded in Section 9.

## 4. Club Registration And Admission Route Evidence

| Route | Current writer | Retained evidence | Static classification |
| --- | --- | --- | --- |
| Validated SeasonPro import | `src/modules/lmspro/import/handlers/club.ts` — Club import handler | completed `ImportJob`; `LegacyKeyMapping` containing entity type, legacy ID, new Club ID, import job and optional original data; `CLUB_IMPORTED` audit event | Valid registration route, but the Club is written directly as `APPROVED`; primary-C2 provisioning failure is caught and does not fail the import; route evidence is indirect rather than represented on the Club |
| Two-stage linked form | `src/modules/lmspro/routers/club-applications.router.ts` — submit, verify, name Teams, approve/wait-list/reject | Application status, email validation timestamp, reviewer, review timestamp, created-Club link and review audit; shell Club and placeholder Teams may exist before admission | Strongest present admission evidence. Email validation alone is not admission. Authorised approve and wait-list actions both retain an approved Application, but approve writes Club `APPROVED` before any Team qualifies as Current |
| Direct authorised C1 creation | `src/modules/lmspro/routers/clubs.router.ts` — `create` | authenticated actor and tenant, Club creation timestamp and `LMSPRO_CLUB_CREATED` audit event | Valid registration route, but the Club row has no explicit route/admission field; status is caller-supplied or defaults to `PENDING`; primary contact is optional and audit metadata does not explicitly state the admission decision |

The three routes are therefore recognised, but their evidence is not equivalent:

- the form route has a purpose-built durable review record;
- the import route relies on completed import/mapping/audit evidence; and
- the direct route relies primarily on actor-scoped audit and creation evidence.

A Club row by itself cannot prove which accepted route admitted it. Route evidence can also
overlap after later edits or imports. Live inventory must therefore report `multiple-route`
and `unknown` groups rather than selecting a route by assumption.

## 5. Static Writer Inventory

### 5.1 Club and Application writers

| Writer | Actor and scope | Effect and transaction boundary | Contract result |
| --- | --- | --- | --- |
| Club import handler | authorised import actor; import job tenant; explicit/current fallback season | creates Club as `APPROVED`, then mapping and audit inside the import transaction; calls primary-C2 provisioning but catches failure | **Contradictory** for participation; **integrity concern** when the admitted Club lacks authoritative primary C2 |
| Application `submit` | public form, explicit tenant/season | creates `PENDING` Application and email-verification evidence; no admission | **Compatible** |
| Application `verifyEmail` | public token | marks email verified, then can create a `PENDING` shell Club and `AWAITING_CLUB_APPROVAL` Teams through separate writes; these are not the admission decision | **Compatible if treated as pre-admission**; **ambiguous** to consumers that equate Club existence with admission; partial-state risk |
| Application `nameTeams` | validated naming token | creates/updates the shell and deletes/recreates placeholder Teams through multiple writes; remains pre-admission | **Compatible if treated as pre-admission**; retry/partial-state sensitivity |
| Application `approve` | authorised C1 reviewer, tenant scoped | sequentially writes/creates Club as `APPROVED`, converts placeholder Teams, provisions primary C2 and finally records Application `APPROVED`, reviewer and timestamp; no encompassing transaction | **Contradictory** because the Club becomes Current before a qualifying Team exists; admission evidence itself is **compatible**; partial-state risk |
| Application `waitlist` | authorised C1 reviewer, tenant scoped | sequentially writes/creates Club `WAITING_LIST`, retains pending Team requests, provisions primary C2 and records approved review; no encompassing transaction | **Compatible shape** for an admitted Club without qualifying Teams; partial-state risk |
| Application `reject` | authorised C1 reviewer, tenant scoped | sequentially cancels placeholder Teams, withdraws shell Club and records rejected review | **Override/terminal purpose**; partial-state risk |
| Direct Club `create` | C1 with `clubs.manage`; validates tenant season | creates with caller status or `PENDING`; contact-user and junction writes are not one transaction with the Club | **Ambiguous** admission representation; **integrity concern** on partial failure or absent contact |
| Generic Club `update` | C1 with `clubs.manage`; tenant scoped | permits direct status changes plus contact edits; status/access sync follows the Club update and audit | **Contradictory** as an unrestricted participation writer; non-atomic access consequence |
| Club `approve` | C1 with approval component; tenant scoped | sets `APPROVED`, audits and reactivates linked users without checking qualifying Teams | **Contradictory** |
| Club delete | C1 with `clubs.manage`; tenant scoped | deletes only when no Teams exist | **Terminal purpose**; unrelated to convergence except for orphan prevention |
| Disciplinary suspend/lift | tenant administrator | transactionally records previous status and writes `SUSPENDED`; lift restores the stored status | **Override** that must be preserved; restoration can reintroduce an earlier contradiction |
| Season clone | C1 season manager; tenant and source season scoped | creates new Club rows and official rows in one transaction; faithfully copies Club status | **Contradictory/ambiguous** because overloaded status and route evidence are propagated without Application/import ancestry |

Primary-C2 provisioning is not uniform. The shared `provisionClubUser` service assigns the
default Club role, authoritative official junction and an active account for import and
Application approval. Direct Club creation uses separate legacy logic, permits no primary
contact and can create users with empty `lmsproRoleIds`. This is a dependency on
`PLAT-REFINE-02`, not authority to duplicate or repair that lifecycle in R9-A0.

### 5.2 Team, status and allocation writers

| Writer | Actor and scope | Effect and transaction boundary | Contract result |
| --- | --- | --- | --- |
| Team import handler | authorised import actor; tenant/import season | status defaults to `CURRENT`; missing division mapping leaves `aggId` null; writes mapping and audit | **Contradictory**: may create Current/unallocated Teams |
| C1 Team `create` | `teams.manage`; tenant/season/Club checked | requires Club `APPROVED`; status defaults to `CURRENT`; AGG is optional | **Contradictory**: blocks admitted Waiting List Clubs and permits Current/unallocated |
| C2 `submitRegistration` | authenticated Club official; tenant/season resolved | requires an `APPROVED` Club; creates `PENDING`, unassigned Team in a transaction | Team state is **compatible**; Club guard is **contradictory** because a registered Waiting List Club must retain request authority |
| Application placeholder/naming writers | validated form token | create/recreate `AWAITING_CLUB_APPROVAL` Teams | **Compatible pre-admission state** |
| Application approve/wait-list | authorised C1 | converts placeholders to `NEW_CLUB_PENDING_TEAM` | **Compatible in-process Team state** |
| Team `update` | `teams.manage`; existing Team is tenant scoped | status, age group and AGG may be changed independently; age-group change can clear AGG without clearing `CURRENT`; an explicitly supplied AGG ID is not revalidated for tenant/season/age group; status changes can notify | **Contradictory** and **cross-boundary integrity concern** |
| `allocateToAGG` | `teams.allocate`; tenant and Team-season AGG check | changes AGG and optionally age group but never status; notification is opt-in | **Ambiguous/incomplete** because allocation does not converge participation |
| Team approval UI/API | C1 Team approval | can set `CURRENT`, `WAITING_LIST` or terminal status separately from allocation; explicitly displays Current/unallocated bucket | conscious Team Waiting List is **compatible**; Current/unallocated is **contradictory** |
| Bulk Team status | `teams.manage`; tenant scoped | changes status independently for selected Team IDs | **Contradictory** for `CURRENT` without valid allocation; deliberate `WAITING_LIST` is **compatible** |
| Club-side Team edit | authorised Club official | may set own Team `WITHDRAWN`; no allocation change | **Explicit terminal purpose** |
| Variation approval | authorised C1 | name changes are unrelated; withdrawal sets Team `CANCELLED`; status change and request decision are transactional | **Terminal purpose** |
| Disciplinary suspend/lift | tenant administrator | stores and restores prior Team status | **Override**; restoration can reintroduce a contradiction |
| Season clone | C1 season manager | faithfully copies all Team statuses and mapped/null allocations in one transaction | **Contradictory/ambiguous** because existing invalid states are propagated |
| Continuation reset/intent | C1/C2 or timed read endpoint | changes only `continuingNextSeason`; does not change present-season status | **Compatible separate authority**, although a read endpoint currently performs the reset mutation |
| Age-group roll-forward | C1 season manager | promotes only `CURRENT` Teams; oldest Teams become `AGED_OUT`; AGG links generally persist | **Integrity-sensitive**: raw `CURRENT` is the eligibility authority even when allocation is absent/invalid |
| Team delete/batch delete | C1 | terminal destructive actions with tenant filtering and audit | **Terminal purpose** |

No background repair script at this baseline writes Club or Team participation state.
`scripts/jobs/processors/key-date-sequences.ts` is a consumer, not a participation writer.

## 6. Static Consumer And Named-Cohort Inventory

| Consumer family | Current dependency | Required named cohort | Finding |
| --- | --- | --- | --- |
| C1 Club lists and season Club tabs | default/filter on raw `APPROVED`; labels vary between Current and Approved | Current Clubs, with separate Registered/Waiting List views | **Contradictory terminology and cohort** |
| C1 Club detail and summary | includes only raw `CURRENT` Teams | Current Teams for current counts; separate unallocated/pending views | **Contradictory** because allocation validity is ignored |
| Dashboard quick stats and season stats | counts raw `APPROVED` Clubs and raw `CURRENT` Teams | Current Clubs and Current Teams | **Contradictory** |
| Metric counter | current season plus Team `CURRENT` | Current Teams | **Contradictory** because AGG and tenant/season relation validity are not checked |
| Team approval | pending statuses plus Club status; separate `CURRENT AND aggId IS NULL` bucket | in-process Teams, Club Waiting List, unallocated Teams, consciously Team-wait-listed Teams | Partly **compatible**, but demonstrates accepted contradictions |
| Division/AGG management | raw `CURRENT` Teams; explicitly exposes orphan/unassigned Current Teams | valid Current Teams plus visible allocation-work exceptions | **Contradictory** for counts/capacity; useful integrity surface |
| C2 landing and Club access | role IDs, legacy Club ID and official junction; generally not Club status | all operational/non-terminal admitted Clubs | Mostly **compatible** with retained C2 access; direct provisioning gaps can produce `NONE` access |
| C2 Team request | requires Club `APPROVED` | all operational/non-terminal admitted Clubs, excluding explicit overrides as later decided | **Contradictory** for Club Waiting List |
| Club user activation/deactivation | withdraw/suspend deactivates; `APPROVED` reactivates; Waiting List does neither | explicit suspended/withdrawn access purpose, not participation aggregate | **Integrity-sensitive**; convergence must not call this status side effect |
| Communications Club tree | raw `APPROVED`, active season | Current Clubs if the tree is participation-targeted | **Contradictory** unless renamed as Current |
| Communications AGG/age-group cohorts and tree counts | selected tenant AGG/age-group IDs, but recipient queries include Teams of every status and tree counts do not filter Team status | Current Teams for participation notices, or an explicitly named all-state cohort | **Ambiguous/over-inclusive** until each communication purpose is named |
| Explicit selected-Club cohort | selected tenant Club IDs, officials included regardless of status | explicit authorised Club selection | **Compatible only as an explicit selection**, not a Current/operational shortcut |
| Explicit Club-status cohort | raw selected statuses, no season boundary | explicit status purpose | **Integrity concern**: cross-season recipients can be included |
| Explicit Team-status cohort | raw selected statuses, no season boundary | explicit Team-state purpose | **Integrity concern**: cross-season recipients can be included |
| Officer-contact cohort | `APPROVED` plus `WAITING_LIST`, no season boundary | all operational/non-terminal admitted Clubs | Semantically closer, but **cross-season integrity concern** |
| Key-date `ALL_CLUBS` | current key-date tenant/season and `APPROVED` plus `WAITING_LIST` | all operational/non-terminal admitted Clubs | **Compatible shape** |
| Key-date `CLUBS_NOT_RESPONDED` | treats absent or pending Application as no response | a workflow-specific response cohort | **Ambiguous**: valid imported/direct Clubs normally have no Application |
| Announcements default audience | raw `APPROVED` unless IDs explicitly supplied | must be selected as Current Clubs or all operational/non-terminal admitted Clubs | **Ambiguous/likely exclusion risk** for Waiting List Clubs |
| Key-date confirmations | some administrator views select only `APPROVED` Clubs | workflow-specific eligible operational Clubs | **Ambiguous** and likely overloaded |
| Public directory | current season Club `APPROVED`; Team `CURRENT` | Current Clubs and valid Current Teams | **Contradictory** because qualification ignores AGG validity |
| Free-day and disciplinary C1 screens | Club `APPROVED` and/or Team `CURRENT` filters | Current Clubs/Teams for playing operations; explicit override views | **Needs purpose-by-purpose classification**; raw filters are insufficient |
| Email shortcodes and notification recipients | entity ID lookups and contact records | purpose-specific selected entity | Generally **unrelated** to aggregate convergence once cohort selection is corrected |
| Club and Team import/export handlers | tenant scoped; optional season filter; exports raw status and unfiltered Club Team count | complete record export or an explicitly filtered named cohort | **Compatible for full-fidelity export**; not a Current-count authority |
| Season clone | copies raw Club/Team status and allocations | Registered Clubs plus separately derived new-season participation | **Contradictory** and high-risk |
| Age-group roll-forward | raw Team `CURRENT` | valid Current Teams | **Contradictory** |
| Tests, fixtures and import templates | encode Team default `CURRENT`, Club import `APPROVED`, raw labels | accepted named cohorts | **Compatibility evidence requiring later update**, not authority to change now |

## 7. Direct Status Dependency Classification

The source baseline currently uses the same stored value for incompatible meanings:

```text
Club APPROVED
-> admitted/registered in Application and import writers
-> Current in C1 UI and counts
-> active/access-restoration condition
-> communications eligibility
-> public-directory eligibility
-> Team-request eligibility
-> season-clone authority
```

```text
Team CURRENT
-> approval decision
-> count/capacity authority
-> directory visibility
-> communications cohort
-> roll-forward eligibility
-> may still have no AGG or no age-group relation
```

The accepted named cohorts cannot be recovered reliably from status alone. The minimum
compatibility rule suggested by source evidence is:

```text
Current Team
= Team.status CURRENT
+ Team, Club, AGG and season share the same tenant and season
+ AGG exists
+ explicit Club suspended/withdrawn override does not apply
```

```text
Current Club
= admitted Club
+ at least one qualifying Current Team
+ no suspended/withdrawn override
```

This is a provisional evidence statement, not an authorised schema, migration or
implementation design.

## 8. Contradictions, Ambiguities, Overrides And Integrity Concerns

### Deterministic source contradictions

- import and direct C1 Team creation can create `CURRENT` Teams without an AGG;
- Application approval and Club approval can set Club `APPROVED` before any Team qualifies;
- C1/C2 Team creation requires Club `APPROVED`, excluding admitted Club Waiting List;
- age-group edits can clear allocation without changing Team `CURRENT`;
- counts, directory and rollover treat raw `CURRENT` as sufficient;
- season clone carries overloaded Club status and contradictory Team state forward; and
- automatic Club participation convergence does not presently exist.

### Technical/data ambiguities requiring live aggregate evidence

- how many Clubs have import, approved-form, direct, multiple or unknown route evidence;
- whether all completed imports have durable mapping/audit and authoritative primary C2;
- whether direct C1 creation audit is complete for every relevant Club;
- how many current rows are closed-season history rather than the first operational season;
- how many Teams have null, missing, cross-tenant, cross-season or age-group-mismatched
  allocations;
- whether `WAITING_LIST` Clubs already have qualifying Teams;
- whether suspensions would restore a now-invalid prior status;
- whether same-name season resolution joins the intended Club; and
- whether route evidence and current primary-C2 membership disagree.

### Explicit overrides

- Club `SUSPENDED` and `WITHDRAWN`;
- Team `SUSPENDED`, `WITHDRAWN`, `CANCELLED`, `INACTIVE`, `AGED_OUT` and `NO_RESPONSE`;
- active disciplinary records and their retained previous statuses; and
- rejected Applications and terminal Team decisions.

### Integrity concerns

- application-level relations do not enforce composite same-tenant/same-season integrity;
- route-neutral admission evidence is absent from the Club row;
- some direct communications status cohorts omit season scope;
- imported primary-C2 provisioning can fail without failing the import;
- direct C1 Club creation and the shared provisioning service have different account/role
  behaviour;
- Club status and user activation/deactivation are coupled in generic update paths; and
- clone-time stale `lmsproClubId` handling relies partly on same-name matching.

## 9. STAGING Live-State Evidence

### 9.1 Execution control

```text
Authorised target:       STAGING
Target fingerprint:      d18b9abe1450
Operator:                Codex in the controlled session
Execution UTC:           2026-07-28T09:53:37Z
Expected application:    df40f45cda955ef00e8f790de89a476c2463a629
Render display:          df40f45 (accepted seven-character truncation)
Transaction read-only:   ON
Statement timeout:       15 seconds
Database connection:     PASS
Supplied tenant/season:  ONE MATCH; same tenant; current and ACTIVE
Expected latest migration:
20260722120000_lmspro_r8_a3_email_delivery_jobs — APPLIED
Unfinished migrations:   0
Rolled-back entries:     8 — all affected migration names have a successful applied record
Q1-Q15:                  COMPLETE
Aggregate live counts:   RECORDED BELOW
Row data:                NOT ACCESSED
Preflight transaction:   ROLLBACK
Q1-Q15 transaction:      ROLLBACK
```

The earlier authorised snapshot fingerprint `6ee30baaf29f` remains recorded as a stopped
attempt: it lacked the supplied tenant/season and expected July migration ancestry, so no
inventory query was run against it. The revised STAGING target passed every precondition.

The eight historical rolled-back migration rows cover seven migration names. Every affected
name also has a finished, non-rolled-back applied record, including the one name with two
rolled-back attempts. They are therefore classified as resolved retries rather than an
unexpected unfinished migration.

### 9.2 Q1-Q15 aggregate results

| Query | Aggregate result |
| --- | --- |
| Q1 — raw statuses | 61 Clubs: 59 `APPROVED`, 1 `WAITING_LIST`, 1 `WITHDRAWN`. 400 Teams: 355 `CURRENT`, 40 `WAITING_LIST`, 5 `CANCELLED`. |
| Q2 — instantiation evidence | 6 Clubs have approved two-stage-form evidence; 55 have no evidence detectable by the accepted import/form/direct-C1 tests. No completed-import or direct-C1-only class was returned. |
| Q3 — Applications | 6 approved Applications are verified, reviewed and Club-linked; 1 pending Application is unverified/unreviewed/unlinked; 1 rejected Application is verified, reviewed and linked. |
| Q4 — imports | No scoped Club import job or mapping/audit aggregate was returned. |
| Q5 — primary C2 | 39 Clubs have one authoritative active primary C2; 17 have no primary official; 5 have a primary without an active Club role. |
| Q6 — allocation | 348 `CURRENT` Teams have valid allocation; 7 `CURRENT` Teams are unallocated. All 40 `WAITING_LIST` Teams are unallocated. Of 5 `CANCELLED` Teams, 1 retains a valid allocation and 4 are unallocated. |
| Q7 — Team relations | All 400 Teams have valid Club and age-group relations; no missing, cross-tenant or cross-season relation was returned. |
| Q8 — derived Club aggregate | No Club qualifies as derived Current when retained admission evidence is required. The 6 admitted-evidence Clubs are derived Club Waiting List: 5 have Team Waiting List and 1 has a Current/unallocated Team. Of the evidence-free Clubs, 53 are `APPROVED`, 1 is `WAITING_LIST`, and 1 is an explicit `WITHDRAWN` override. |
| Q9 — direct contradictions | 9 `APPROVED` Clubs have zero qualifying Team. No Waiting List Club has a qualifying Team, and no suspended/withdrawn Club has a qualifying Team. |
| Q10 — non-Current allocation | 1 `CANCELLED` Team retains allocation; 4 `CANCELLED` and all 40 `WAITING_LIST` Teams are unallocated. |
| Q11 — Team Waiting List | All 40 Team Waiting List records have age group, team number, creation timestamp and detected authorised-decision evidence. |
| Q12 — Waiting List access | The single raw `WAITING_LIST` Club has an official but no active Club-role user. |
| Q13 — cohort delta | Raw `APPROVED`: 59; admitted operational under retained evidence: 6; derived Current under retained evidence: 0. |
| Q14 — rollover exposure | 343 validly allocated `CURRENT` Teams are marked continuing; 5 validly allocated and 7 unallocated `CURRENT` Teams have no continuation value. One allocated `CANCELLED` Team is marked continuing; the other 4 are unallocated with no value. All 40 `WAITING_LIST` Teams are unallocated with no value. |
| Q15 — disciplinary overrides | No active disciplinary restoration record was returned. |

### 9.3 Evidence classification

Counts below identify evidence conditions and can overlap; they are not additive totals.

| Classification | Evidence |
| --- | --- |
| Compatible | 400/400 Team-to-Club/age-group relations are valid; 348 `CURRENT` Teams have valid same-scope allocation; all 40 Team Waiting List records have detected decision evidence; 39 Clubs have one authoritative active primary C2; 6 approved Applications retain the complete validation/review/link chain. |
| Deterministic contradiction | 7 `CURRENT` Teams are unallocated; 9 raw `APPROVED` Clubs have zero qualifying Team. |
| Ambiguous | 55/61 Clubs have no accepted-route evidence detectable by the pack; the 59 raw-`APPROVED` cohort therefore cannot safely be translated into an admitted or Current cohort. One `CANCELLED` Team retains allocation, 5 validly allocated `CURRENT` Teams have no continuation value and the meaning of those retained states needs an authorised purpose decision. |
| Explicit override | 1 Club is `WITHDRAWN`; 5 Teams are `CANCELLED`; no active disciplinary restoration record was found. |
| Integrity concern | 17 Clubs have no primary official; 5 have a primary without an active Club role; the sole raw Waiting List Club has no active Club-role user. No cross-tenant, cross-season, missing Club, missing age-group or missing AGG relation was detected. |

### 9.4 Interpretation boundary

The result `derived-current-clubs = 0` does not prove that no Club is operationally Current.
It proves that the present database cannot join accepted admission evidence to the 50
`APPROVED` Clubs that have at least one qualifying Team. Reclassifying those Clubs from
status or Team presence alone would contradict the accepted evidence-first boundary.

The evidence does prove two bounded present-state contradictions: seven Current Teams lack
allocation and nine Approved Clubs have no qualifying Team. It also proves that the
structural same-tenant/same-season Team relations are currently clean in this scope.

### 9.5 Control-owner legacy-import attestation

On 28 July 2026 the control owner provided the following operational provenance:

- every Derby JFL Club established before 1 June 2026 was imported personally by the
  control owner from Derby JFL's legacy Knack system;
- new applicant Clubs were added after 1 June 2026 through the application route;
- this is the first operational SeasonPro season; and
- other SeasonPro STAGING tenants contain sample or test data, while this authorised
  tenant's data is very similar to—but is not asserted to be identical to—live.

The exact alignment between the 55 evidence-free Club rows and the pre-1 June legacy cohort
is a strong inference because the other 6 of 61 Clubs have complete approved-form evidence.
It has not been verified row by row and must be recorded as:

```text
Control-owner-attested legacy import — automated source evidence unavailable
```

This resolves the business explanation for the cohort sufficiently for planning. It does
not create automated import evidence, authorise a synthetic import job, prove production
counts or permit status/data reconciliation.

Wishlist follow-up `LMS-W-IMPORT-01` is registered in the LMSPro roadmap to make future
Club and Team imports retain durable automated provenance evidence.

## 10. Provisional Successor Shapes — Not Accepted

Combined findings indicate that the next control review may need separately bounded shapes
for:

1. a read-only corroboration and durable-attestation treatment boundary for the 55
   control-owner-attested legacy imports, without mutation or fabricated import evidence;
2. additive, route-neutral admission evidence and a shared named-cohort compatibility
   reader;
3. prospective convergence of the three Club admission writers and Team/allocation
   writers;
4. Notification Manager integration for real Club Current/Waiting List transitions,
   preserving the existing CRUD switch where applicable and using the manager's master and
   per-event controls for automated behaviour, with idempotency and delivery/audit evidence;
5. compatibility consumers for counts, directory, communications, access and rollover;
6. controlled aggregate dry-runs and separately authorised deterministic reconciliation
   for Current/unallocated and Approved/no-qualifying-Team contradictions;
7. primary-C2 integrity and Waiting List access treatment coordinated with
   `PLAT-REFINE-02`;
8. UI terminology and removal of unrestricted generic participation-status edits; and
9. only after evidence and convergence, constraint/legacy cleanup.

These are candidate shapes only. Their identifiers, contents, order and release grouping
must not be accepted until the static findings and an authorised live-state evidence record
have been reviewed together.

## 11. Control Decision Required

The combined static evidence, STAGING aggregates and explicit control-owner attestation are
sufficient for the next control decision. They are not sufficient for automatic
classification or repair because the 55 legacy-import histories remain technically
unevidenced at row level.

The next controlled decision is:

```text
review and accept, revise or split the completed R9-A0 evidence
-> decide the first separately bounded successor planning slice
-> preserve the attested-versus-automated distinction for the 55 legacy Clubs
-> do not infer admission, Current participation or repair from raw status alone
```

R9-A0 is evidence-complete but remains open pending that review. No implementation, schema,
migration, reconciliation, deployment, environment, access, role, Club or Team change is
authorised, and no successor slice is accepted by this record.
