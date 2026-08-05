# LMSPro CR-Fix F2.2 — Current-Season Eligibility And Count Integrity Triage

Date: 2026-08-05

Module: LMSPro / SeasonPro communications

Status: **IMPLEMENTED AT `ec7e0cc4`; EXACT ON DEV/STAGING; STAGING HUMAN SMOKE REQUIRED**

Parent CR-Fix:

`docs/modules/lmspro/01-cr-inputs/CR-Fix-2026-08-05-lmspro-cohort-email-draft-persistence-and-audience-selection.md`

Corrected bounded plan:

`docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f2-2-current-season-eligibility-and-count-integrity-planning.md`

Implementation confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-08-05-lmspro-cr-fix-f2-2-current-season-eligibility-and-count-integrity-confirmation.md`

Existing F2.1 plan:

`docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f2-1-cohort-taxonomy-and-picker-correction-planning.md`

Existing F3 attachment-policy refinement:

`docs/modules/lmspro/01-cr-inputs/2026-08-05-lmspro-cr-fix-f3-uploaded-file-only-acknowledgement-planning-refinement.md`

Authoritative LMSPro roadmap:

`docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`

## 1. Control-Owner Objective

The accepted objective is:

```text
Every season-bound cohort is scoped to the current season.

Team status is a restrictive eligibility constraint. It defaults to CURRENT and C1 may
deliberately include one or more additional Team statuses.

Club status is a restrictive eligibility constraint. It defaults to Current and C1 may
deliberately include one or more additional Club statuses.

Age Group and Division recipients come only from Teams and Clubs satisfying those status
constraints.

Age Group "Club Secretaries" continues to mean the primary contact of each qualifying Club.

Club Roles continue to use the exact active Club roles named and configured by C1. The
system must not assume a role is named "Club Secretary".

Age Groups, Divisions, explicit Clubs, League Roles, Club Roles and other recipient-producing
cohorts are additive audience sources. Selecting more than one source adds their eligible
recipients by union.

Current season and Team/Club statuses do not create recipients. They restrict each selected
source wherever that source has the relevant Team or Club relationship. A source without
that relationship is not falsely excluded by an inapplicable status filter.

After source-specific eligibility is applied, all eligible sources are unioned and then
deduplicated globally by normalised email address.

Preview, Save Draft, reopen and Send must use the same audience and produce truthful
provider-recipient and Club-history counts.
```

## 2. Identifier Reconciliation

The source request called this correction `F3`. The existing CR-Fix already uses `F3` for
the uploaded-file-only acknowledgement policy, and that meaning is recorded in the parent
CR, accepted triage and portfolio controls.

This correction is therefore registered as **F2.2**, because it is a direct safety and
correctness continuation of F2.1 cohort taxonomy. Existing F3 retains its meaning and is
sequenced after this more serious audience-authority correction. This prevents two
different outcomes from sharing one identifier.

## 3. Classification And Priority

```text
Type       CR-Fix audience-authority and count-integrity defect
Priority   Urgent remedial follow-on before ordinary cohort Send is relied upon
Severity   High
Owner      LMSPro communications over shared communications persistence/delivery
Exposure   Wrong recipients and wrong Club-dashboard visibility without an obvious error
Now        F2.2 planning/decision under the open email CR-Fix
Next       Existing F3 uploaded-file-only acknowledgement policy
After      FUND 1R-F-A remains registered portfolio Next at root control
```

This is more serious than a misleading label. A successful Save Draft can persist and a
successful Send can deliver an audience broader than the operator intended.

## 4. Confirmed Read-Only Evidence

### 4.1 Age Group And Division Scope

The picker obtains Age Groups and Divisions from the active LMSPro season. Their recipient
resolvers then query Teams by selected `ageGroupId` or `aggId`, but do not explicitly
require:

- `Team.seasonId` to equal the active season;
- an allowed `Team.status`, defaulting to `CURRENT`; or
- an allowed `Club.status`, defaulting to Current/`APPROVED` participation.

The current-season picker IDs provide an indirect season boundary, but not an explicit
server-authoritative status or season contract.

### 4.2 Age Group Club Secretary Meaning

The Age Group/Division recipient type labelled `Club Secretaries` reads
`LMSProClub.primaryContact`. That is the accepted product meaning and should remain.

The primary contact is added for every Club represented by the unfiltered matching Team
rows. It is therefore only as accurate as the structural Team/Club query.

### 4.3 Status Filters Currently Add Recipients

`teamStatus` and `clubStatus` are currently independent cohort types. Each resolves its own
primary-contact recipients. They do not constrain an Age Group, Division, Club or Club Role
selection.

### 4.4 All Selected Filters Are Unioned

The shared Email resolver loops over every selected filter, appends every result and then
deduplicates by normalised email address. This means:

```text
Age Group U8 + Team Status CURRENT
currently means
recipients(U8) UNION recipients(all CURRENT Teams)
```

It does not mean `U8 Teams whose status is CURRENT`.

Likewise:

```text
Club Status Current + Club Role X
currently means
primary contacts(Current Clubs) UNION active users(Role X)
```

It does not mean `Role X users attached to qualifying Current Clubs`.

### 4.5 Club Role Scope

Club Role choices correctly use exact active C1-defined `ModuleRole` records with
`roleScope = CLUB`. Names are tenant terminology and must not be hard-coded.

Role assignment is stored tenant-wide on `User.lmsproRoleIds`. Authoritative Club
membership is separately represented by `LMSProClubOfficial`. A selected Club Role is an
additive audience source, resolved through both facts:

1. the active User has the selected exact Club Role; and
2. the User has an authoritative membership in a Club satisfying the applicable
   current-season and Club-status eligibility rules.

An Age Group, Division or explicit Club source does not narrow the selected Club Role
source. Their eligible recipients are unioned before global address deduplication.

The current schema does not state that one particular ModuleRole applies to one particular
Club membership. If that stronger claim becomes necessary, planning must stop for a fresh
authority/schema decision rather than infer it.

### 4.6 Badge Meaning

The footer's `Club histories` number is the number of distinct
`EmailClubVisibility`/Club-dashboard audience records in the planned Email. It is not a
people count. The separate provider-recipient badge is the deduplicated email-address
count.

The observed `62 Club histories` against 53 known Current Clubs is credible evidence that
non-current Team/Club contexts are entering the audience plan. The exact nine records
remain a production-data evidence question until inspected safely; their identity is not
required to prove the resolver defect.

## 5. Settled Product Rules

1. Current season is mandatory and server-resolved.
2. Team Status defaults to `CURRENT` and at least one Team status must remain selected.
3. Club Status defaults to canonical Current and at least one Club status must remain
   selected.
4. Multiple values within Team Status are OR alternatives.
5. Multiple values within Club Status are OR alternatives.
6. Multiple selections within one audience-source type are OR alternatives.
7. Different recipient-producing sources are additive and combine by UNION.
8. Current season, Team Status and Club Status are eligibility constraints, not audience
   sources, and cannot create recipients when selected alone.
9. Each eligibility constraint applies only to sources with the relevant authoritative
   entity relationship.
10. Team Managers are selected only from eligible Teams.
11. Age Group/Division Club Secretaries are eligible Clubs' primary contacts.
12. Other Club Officials are selected only through authoritative memberships on eligible
    Clubs.
13. Club Role recipients require an active User with the selected exact C1-defined role
    and an authoritative membership on an independently eligible Club; they are not
    narrowed to a simultaneously selected Age Group, Division or explicit Club source.
14. League Role recipients are an additive source and are not restricted by Team or Club
    status where no authoritative Team or Club relationship exists.
15. One normalised email address remains one provider recipient while retaining every
    exact qualifying Club-history context.
16. Preview and persisted resolution must be identical.
17. The Recipients-tab badge must display the complete resolved count, including
    multi-digit and candidate-500 values; it must not use a clipped fixed circle.
18. After a successful Send, the Email list opens with no status filter so the complete
    list is visible. The status-filter control remains available for deliberate filtering.

## 6. Containment

Until F2.2 is implemented and accepted:

- do not rely on an Age Group/Division cohort Send to mean Current-only;
- do not expect Team Status or Club Status to narrow selected sources correctly;
- do not treat the Club-history badge as proof that only Current Clubs are represented;
- use manually verified addresses if an operational communication cannot wait; and
- Save Draft may be used for controlled evidence only, with no provider Send.

## 7. Accepted F2.2 Boundary

F2.2 may:

- introduce a single current-season LMSPro audience-scope contract;
- make Team and Club status controls explicit, multi-select and default Current;
- reinterpret status selections as constraints rather than silently additive cohorts;
- resolve each recipient-producing cohort as an additive source through its applicable
  season/status eligibility constraints;
- union eligible Age Group, Division, explicit Club, League Role, Club Role and other
  selected recipient sources before global deduplication;
- ensure status-only selections produce no audience;
- make picker, preview, Save Draft and Send counts share the same resolver semantics;
- relabel/explain provider-recipient and Club-dashboard-history counts;
- make the Recipients-tab count badge auto-size to the complete count;
- clear the list's status filter after successful Send while retaining status filtering;
  and
- add comprehensive current-season, status-eligibility, additive-source, deduplication and
  parity tests.

F2.2 may not:

- hard-code a Club Role name;
- change C1 role creation or assignment;
- infer a per-Club ModuleRole assignment not represented by the schema;
- change provider delivery, attachment handling, F3 acknowledgement policy or batching;
- weaken tenant, season, Team or Club authority checks;
- add a schema migration without stopping for fresh review;
- silently send or use a real broad audience as a test; or
- revive compatibility work for pre-release drafts already designated for deletion.

## 8. Risk Decision

| Risk | Severity | Triage control |
| --- | --- | --- |
| Non-current Team managers or primary contacts receive an Email | High | Explicit active-season, Team-status and Club-status constraints |
| Club dashboards receive visibility outside the intended audience | High | Build histories only from eligible Club contexts contributed by the selected sources |
| Status checkboxes continue to add recipients | High | Treat statuses only as predicates within source resolvers; status-only selection resolves zero recipients |
| Additive sources are accidentally intersected and valid recipients are dropped | High | Explicit source-union contract and mixed Age Group/League Role/Club Role tests |
| Role terminology is hard-coded | Medium | Exact selected ModuleRole IDs only |
| User role is wrongly attributed to a specific Club | High | Require both tenant role and Club membership; do not claim per-membership role authority |
| Preview differs from Save Draft | High | One shared resolver contract and parity tests |
| Default omission broadens legacy/new requests | High | Server defaults fail safely to Current; delete designated pre-release drafts |
| Fix changes provider or attachment behaviour | Medium | Explicit non-goal and regression gates |
| Recipient count is clipped and misread | Low | Auto-width badge tested at one, two, three and candidate-500 digits |
| Sent Email appears missing behind the Draft filter | Medium | Clear status filter only after successful Send; retain manual filtering |

## 9. Triage Decision

F2.2 is accepted for bounded planning as the active correction under the open email
CR-Fix. It takes precedence over the existing attachment-policy F3 because recipient
authority and unintended delivery risk are more serious than link-acknowledgement friction.

The control owner corrected and accepted the linked F2.2 plan, authorised implementation,
and requested immediate dev/staging promotion absent blockers. Application commit
`ec7e0cc4` is exact on dev and staging with automated/build gates green. Existing F1/F2.1
evidence remains valid; staging human smoke is now the main/live gate.

## 10. Exit From Triage

Planning must provide:

- a canonical additive-source and restrictive-eligibility algebra;
- exact default/current definitions;
- explicit role/membership semantics;
- one preview/persistence resolution contract;
- UI behaviour for one-or-more status selection;
- count definitions and labels;
- automated and human evidence matrices;
- rollback and stop conditions; and
- an explicit source-by-source eligibility applicability matrix.
