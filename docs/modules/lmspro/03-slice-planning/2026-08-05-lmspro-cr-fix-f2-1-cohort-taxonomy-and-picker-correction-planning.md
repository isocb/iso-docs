# LMSPro CR-Fix F2.1 — Cohort Taxonomy And Picker Correction Planning

Date: 2026-08-05

Module: LMSPro / SeasonPro communications

Status: **COMPLETE AND EXACT ON DEV/STAGING/MAIN AT `9974eed5`; LOCAL AND FINAL STAGING
HUMAN SMOKE PASS; SECURITY/HEALTH PASS; SAVED-DRAFT COMPATIBILITY EXCLUDED**

Parent CR-Fix:

`docs/modules/lmspro/01-cr-inputs/CR-Fix-2026-08-05-lmspro-cohort-email-draft-persistence-and-audience-selection.md`

Local implementation confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-08-05-lmspro-cr-fix-f2-1-cohort-taxonomy-and-picker-correction-local-confirmation.md`

Hosted-dev human-smoke schedule:

`docs/modules/lmspro/05-review-and-test/2026-08-05-lmspro-cr-fix-f2-1-dev-human-smoke-schedule.md`

Final staging human-smoke schedule:

`docs/modules/lmspro/05-review-and-test/2026-08-05-lmspro-cr-fix-f2-1-staging-final-human-smoke.md`

Failed staging review:

`docs/modules/lmspro/05-review-and-test/2026-08-05-lmspro-cr-fix-f1-f2-staging-readiness-and-human-smoke-schedule.md`

Superseded F2 plan:

`docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f1-f2-cohort-email-draft-persistence-and-audience-selection-planning.md`

## 1. Planning Decision

Control-owner acceptance:

```text
The revised review is accepted. Implement F2.1.
Do not attend to existing saved drafts; the feature is new, has one user, and that user
will be instructed to delete existing drafts.
```

F2 passed its automated tests but failed human staging review because its accepted product
model was wrong. It treated the same `BOTH`-scope database role as two independently
selectable recipient roles, one under League Roles and one under Club Roles.

The control owner's clarification is authoritative:

```text
C1, C2 and C1+C2 hat-swap describe a user's access/dashboard context.
They are not three SeasonPro recipient roles.
League Roles and Club Roles are separate functional role cohorts.
```

F2.1 replaces F2's independent-checkbox contract. It does not attempt to improve or extend
the rejected behaviour.

Recommended minimum correction:

1. do not expose a C1/C2/hat-swap access state as a League Role or Club Role recipient;
2. show exact League roles only under League Roles and exact Club roles only under Club
   Roles;
3. remove duplicate `BOTH` role presentation instead of synchronising two misleading
   checkboxes;
4. keep access-type audiences out of this slice; if later required, design a separately
   labelled `User access type` cohort rather than representing it as a role; and
5. place the Divisions/Age Groups recipient-type modifier next to the structural cohort
   controls it actually affects.

## 2. Authoritative Vocabulary

| Concept | Meaning | Email-picker treatment |
| --- | --- | --- |
| C1 | League-side access/dashboard context | Not a SeasonPro role cohort |
| C2 | Club-side access/dashboard context | Not a SeasonPro role cohort |
| C1+C2 / hat-swap | A user who may switch between League and Club dashboard contexts | Not duplicated under League Roles and Club Roles |
| League Role | A functional SeasonPro role belonging to the League context | Selectable once under League Roles when email-eligible and assigned |
| Club Role | A functional SeasonPro role belonging to the Club context | Selectable once under Club Roles when email-eligible and assigned |
| Recipient type | Team Manager, Club Secretary or Other Club Official reached through a structural Team/Club cohort | Modifier for Divisions and Age Groups only |
| Cohort category | A visual heading such as Divisions, Age Groups, League Roles or Club Roles | Clearly non-selectable heading, not a row that appears to be missing a checkbox |

The database currently uses `ModuleRole.roleScope` values `LEAGUE`, `CLUB` and `BOTH` both
for role classification and to derive user access context. That implementation vocabulary
must not dictate misleading product vocabulary in the communications picker.

## 3. Confirmed Source Findings

### 3.1 Incorrect BOTH Duplication

The LMSPro cohort provider currently:

- builds League Roles from scopes `LEAGUE` and `BOTH`;
- builds Club Roles from scopes `CLUB` and `BOTH`;
- validates League-role filters against `LEAGUE` and `BOTH`; and
- validates Club-role filters against `CLUB` and `BOTH`.

The same database ID can therefore be displayed twice and accepted through two filter
types. F2 changed selection keys from `role ID` to `<cohort type>:<role ID>`, making those
two presentations independently selectable. The tests proved the implementation matched
that contract; staging proved the contract itself was invalid.

### 3.2 Recipient-Type Scope And Placement

`Include recipient types` is visually presented as a global LMSPro control above the whole
cohort picker. In fact, the compose logic attaches it only to:

- `divisions`; and
- `ageGroups`.

The resolver ignores it for Clubs, League Roles, Club Roles, Club Officer Contacts,
referees, venues, Team status and Club status. Its current placement therefore overstates
its scope and makes role-selection diagnosis harder.

### 3.3 Tree Presentation

Category nodes deliberately have no checkbox, while their child nodes are indented and
selectable. The current visual treatment does not make that distinction sufficiently
clear. A role category can therefore look like a broken selectable row, especially when
its children contain access-mode entries or zero-recipient entries.

### 3.4 Counts

The provider supplies `recipientCount` on role nodes while the picker-local node contract
currently looks for `count`. F2.1 must reconcile the actual shared type/field before using
counts to enable, disable or label role choices. It must not infer usefulness from a
missing displayed count.

## 4. F2.1 Implementation Contract

### 4.1 Role-Cohort Eligibility

For this bounded correction:

```text
League Roles -> exact LEAGUE-scoped, active, tenant-owned, broadly assignable roles
Club Roles   -> exact CLUB-scoped, active, tenant-owned, broadly assignable roles
BOTH         -> excluded from both recipient-role lists and both role resolvers
```

The same rule must be enforced by the server. Hiding `BOTH` only in the browser is
insufficient because saved or crafted filters could still reach the resolver.

Do not add name-based special cases such as `role.name !== "League & Club"`. Eligibility
must use an explicit shared classification rule. If source review proves that a legitimate
functional role also uses `BOTH`, stop and return to product/data-model planning rather
than silently excluding a real recipient responsibility.

### 4.2 Existing Saved Drafts — Explicitly Out Of Scope

Do not inventory, migrate, warn on, rewrite or preserve compatibility for existing saved
draft filters. The sole current user will delete drafts created during pre-release testing.

This exclusion does not weaken the new-selection server rule: a newly submitted League or
Club role filter must still match its exact permitted scope.

### 4.3 Recipient-Type Modifier

Replace the global-looking control with contextual wording and placement, for example:

```text
For selected Divisions and Age Groups, include:
[ ] Team Managers  [ ] Club Secretaries  [ ] Other Club Officials
```

Required behaviour:

- the control is visually adjacent to the Divisions/Age Groups section or its selected
  summary;
- it is shown or enabled only when a Division or Age Group filter is selected;
- one recipient-type choice applies consistently to all selected Division and Age Group
  filters;
- it has no visual or submitted effect on other cohort types;
- saved/reopened drafts retain the selected types; and
- removing the last Division/Age Group selection removes the modifier from the submitted
  filter set without changing any unrelated cohort.

The default remains Team Managers plus Club Secretaries unless a separate product decision
changes it.

### 4.4 Picker Hierarchy

Make headings and selectable rows visually unambiguous:

- category headings use heading/accordion treatment, not an empty checkbox position;
- every eligible child recipient item has one checkbox;
- an item with a proved zero resolved-recipient count is clearly labelled and disabled or
  omitted according to one consistent rule;
- selected-group summaries use human labels, not only internal filter-type names; and
- search preserves the category context of every result.

Do not add a third `Both Club and League Roles` section. If a future business need requires
emailing users by access context, that is a separately triaged cohort with labels such as
`League access`, `Club access` and `League + Club access`.

### 4.5 Selection Identity

The F2 `<cohort type>:<node ID>` helper may remain for legitimate IDs belonging to different
cohort types, but it must no longer be justified by duplicate `BOTH` role presentation.

If a duplicate semantic role is encountered during transition, it represents one
selection, never two independently submitted filters. The accepted end state is to remove
the duplicate presentation entirely.

## 5. Expected Application Boundary

Primary files likely to change:

- `src/modules/lmspro/communications/cohort-resolver.ts`;
- `src/modules/lmspro/communications/provider.ts` if descriptions require correction;
- `src/core/services/communications/components/CohortPicker.tsx`;
- `src/core/services/communications/components/ComposeEmailModal.tsx`;
- `src/core/services/communications/components/cohort-selection.ts` only if the retained
  helper needs correction; and
- focused cohort tree, resolver, compose-state and selection tests.

Possible shared role-classification change:

- `src/modules/lmspro/lib/role-classification.ts` only if a reusable explicit
  email-cohort eligibility predicate is required.

No schema or migration is expected. Any need for a new persistent discriminator such as
`isEmailCohortEligible` stops this slice for explicit schema/product review.

## 6. Automated Acceptance

Prove at minimum:

1. a `LEAGUE` role appears once under League Roles and resolves only through
   `leagueRoles`;
2. a `CLUB` role appears once under Club Roles and resolves only through `clubRoles`;
3. a `BOTH` access-mode role appears under neither list and is rejected by both role
   resolvers;
4. a crafted cross-scope role ID resolves no recipient and returns actionable validation
   rather than silently changing audience;
5. category headings are non-selectable and every eligible child has one selection
   control;
6. a zero-recipient role cannot be mistaken for a working recipient choice;
7. recipient types alter Division and Age Group counts only;
8. recipient types do not alter Club, role, contact, referee, venue or status cohorts;
9. selected recipient types survive Save Draft and reopen;
10. overlapping valid cohorts still produce one normalised provider recipient with every
    authorised Club context; and
11. all existing F1 broad-cohort persistence tests remain green.

## 7. Human Staging Smoke

Use Save Draft only until the selection model passes.

1. Confirm League Roles contains League roles only.
2. Confirm Club Roles contains Club roles only.
3. Confirm no `League & Club`, `BOTH` or hat-swap access entry is duplicated in either
   role list.
4. Confirm every selectable role has one obvious checkbox and a truthful recipient count
   or explicit zero-recipient state.
5. Select one assigned League role; confirm preview, Save Draft and reopen retain the same
   role and stable deduplicated count.
6. Repeat with one assigned Club role.
7. Combine the two valid roles; confirm overlaps deduplicate without losing authorised
   Club context.
8. Select a Division or Age Group and confirm the contextual recipient-type control is
   visible and changes only that structural cohort.
9. Remove every Division/Age Group filter and confirm the recipient-type control no longer
   implies an effect on remaining role/Club cohorts.
10. Confirm Network contains Save Draft create/update only and no provider Send event.

## 8. Risk Assessment

| Risk | Likelihood before correction | Impact | F2.1 control |
| --- | --- | --- | --- |
| Operator selects an access mode believing it is a functional role | High | High | Remove `BOTH` from role cohorts; use authoritative vocabulary |
| Same users are represented by two misleading filters | High | Medium/High | One exact-scope role list; no duplicate `BOTH` presentation |
| UI-only hiding is bypassed by a saved/crafted filter | Medium | High | Exact-scope server validation and Send gate |
| A legitimate functional BOTH role is accidentally removed | Unknown | High | Phase 0 role inventory; stop if the data model carries mixed semantics |
| Recipient-type choices appear to affect unrelated cohorts | High | Medium | Contextual placement and type-specific tests |
| Zero-recipient role appears selectable and trustworthy | Medium | Medium | Truthful count contract and disabled/omitted zero state |
| F1 persistence correction regresses during UI/resolver work | Low | High | Retain F1 test suite and broad Save Draft staging regression |

Overall treatment: **urgent corrective follow-on within the open CR-Fix**. F1 has passed
human staging persistence smoke, but commit `07a71906` must not be promoted live with the
failed F2 behaviour still present.

## 9. Do Not Build

F2.1 does not authorise:

- a new access-type email cohort;
- a redesign of SeasonPro permission assignment or dashboard hat swapping;
- role schema migration or production role mutation;
- automatic rewriting/deletion of saved draft filters;
- a new recipient deduplication algorithm;
- provider Send testing;
- F3 attachment/link acknowledgement work; or
- main/live promotion.

## 10. Control Gate And Recovery

The control owner accepted this F2.1 contract for local implementation, including the
decision that C1/C2/hat-swap access state is excluded from role cohorts and the explicit
saved-draft exclusion above. Implementation, technical verification, local human smoke,
exact dev/staging promotion, both Security Scans, public staging health and all ten final
staging human-smoke checks pass. The control owner authorised main promotion and exact
commit `9974eed5` was fast-forwarded and pushed to main.

The application recovery baseline for the staged F1/F2 commit remains `7154937`. F2.1
should be a bounded follow-up commit on `dev`, then promoted to staging alongside existing
F1 for a replacement human smoke. F1 must not be reverted unless its own regression gates
fail.

F3 remains a separate immediate follow-on under the same CR-Fix and must not be mixed into
F2.1.
