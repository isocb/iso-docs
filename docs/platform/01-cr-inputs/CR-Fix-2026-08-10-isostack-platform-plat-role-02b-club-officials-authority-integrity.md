# CR-Fix — PLAT-ROLE-02B Club Officials Authority Integrity

Date: 2026-08-10

Parent CR:

[`IsoStack Core Platform And SeasonPro Role-Authority Clarification And Remediation`](2026-08-04-isostack-core-platform-and-seasonpro-role-authority-clarification-and-remediation-cr.md)

Parent slice: `PLAT-ROLE-02`

Status: **URGENT REMEDIAL EXPEDITE IMPLEMENTED AND TECHNICALLY ACCEPTED LOCALLY; PARENT
ITEM-1-THROUGH-ITEM-18 HUMAN MATRIX ACCEPTED; CONTROLLED FIXTURE REPAIR COMPLETE; ITEM-7
CURRENT-CLUB JUNCTION FOCUSED RETEST AND READ-ONLY DERBY PROOF PASS; LOCAL GATE COMPLETE
AND COMMITTED IN ROLE CHILD `b1ede26f`; NOT PUSHED OR PROMOTED**

## 1. Trigger And Business Objective

The replacement `PLAT-ROLE-02` local human gate proved two connected failures in the
SeasonPro Club Officials consumer:

1. item 3 created and routed a valid C2 Member correctly, but `/app/lmspro/club/officials`
   refused that valid same-Club user and the page presented the refusal as an empty list;
2. during item 15 follow-on testing, editing an existing hat-swap user through Club
   Officials replaced the complete League-and-Club role set with the selected Club role
   alone. The active C1 Admin then had no valid SeasonPro runtime persona and appeared to
   lose module access during the session.

The objective is one bounded correction which fixes **both item 3 and item 15** so the
control owner can restart and complete the uninterrupted parent matrix from item 1 through
item 18. Item 3 is not deferred to a later consumer slice.

## 2. Confirmed Evidence

- `clubOfficials.list` relies on deprecated `lmsproClubRole` in a same-Club access decision;
- the page does not render the list query error and treats missing data as "No officials";
- `clubOfficials.assign` and `clubOfficials.update` write a single-element
  `lmsproRoleIds` array, discarding unrelated exact roles;
- `clubOfficials.remove` can clear Club affiliation without reconciling the retained Club
  role IDs;
- these mutations do not consistently use the shared complete-persona validator or enforce
  the role's read-only status;
- the affected `owner@isodo.co.uk` Core account remains active, `ADMIN` and linked to Acme;
  it was not deleted or detached; and
- audit evidence shows the valid League plus Club set immediately before
  `CLUB_OFFICIAL_UPDATED`, followed by the Club-only set and later sign-out.

## 3. Required Behaviour

### Item 3 — truthful same-Club listing

- A valid active C2 Member with an exact active Club role, exact current Club and
  `clubs.officials.view` grant can view the officials for that Club.
- A C1 Owner/Admin with an exact League role and the relevant component grant retains the
  intended League-wide view.
- Another Club, tenant or inactive/non-current affiliation remains inaccessible.
- Read-only roles may view when granted but cannot mutate.
- A refused or failed query is shown as an error and is never presented as an empty table.

### Item 15 — role-integrity-safe mutation

- Assigning or editing a Club official changes only the exact Club-role/Club portion of the
  target persona and preserves every unrelated exact League role.
- The server reloads actor, target, role and Club authority and validates the complete final
  persona before any User, ClubOfficial or audit persistence.
- Exact tenant, current-Club, active-role, component and read-only boundaries are enforced.
- Self-edit cannot leave the acting user without a valid runtime persona.
- Remove preserves unrelated League roles and produces either a valid remaining C1 persona
  or an explicitly valid unassigned Core account; it must not leave a role/Club mismatch.
- Existing same-tenant accounts are repaired/assigned through their identity rather than
  recreated. Cross-tenant email ownership remains a hard refusal.

## 4. Controlled Fixture Repair

The application correction must pass its focused automated gates before data repair.
Repair is limited to the evidenced disposable local fixture:

```text
owner@isodo.co.uk
restore exact League Admin role
retain exact Club Secretary Club role
retain exact current Nottingham Tigers Club
retain Organisation ADMIN and ACTIVE status
```

The before state, intended after state, affected record count and audit source must be
inspected before mutation. No broad data rewrite, inferred tenant repair or staging/live
repair belongs to this CR-Fix.

## 5. Risk Assessment

| Risk | Severity | Control |
| --- | --- | --- |
| Valid C2 officials remain hidden | High operational/authority impact | Replace legacy admission with exact Club, current-state and component checks; expose query errors |
| Existing hat-swap role set is destructively replaced | Critical | Scope-aware role merge plus complete-persona validation before one transaction |
| C1 Owner/Admin loses effective module access mid-session | Critical | Preserve League role; reject an invalid final persona and any destructive self-edit |
| Remove leaves an orphan Club role or affiliation | High | Reconcile role, Club and junction together and validate the final C1/unassigned state |
| Read-only user gains mutation capability | High | Server-side effective-role/read-only enforcement on every mutation |
| Cross-tenant account or Club is altered | Critical | Reload and compare tenant ownership inside the transaction |
| Error is mistaken for an empty business result | High | Explicit loading, empty and error UI states |
| Repair changes unintended data | Critical | One evidenced disposable user, exact identifiers, inspected before/after and audit evidence |

## 6. Boundaries

This CR-Fix does not redesign role taxonomy, Core Organisation authority, hat-swap routing,
historic Club participation, invitations, Auth.js sessions, P1 user administration or the
later general Unassigned-user product workflow. It introduces no schema, migration, seed or
provider change.

The original Team-settings invitation assertion in parent item 15 was subsequently
completed and passed. The Club Officials failure which initially interrupted that item did
not represent an invitation failure.

The completed parent matrix later exposed a bounded adjacent persistence defect: an exact
Club change updated `User.lmsproClubId` and added the selected current Club junction but did
not retire the former current-season junction. This is included under the same CR-Fix
because it directly compromises the exact-Club authority invariant. The correction must
reconcile current-season memberships atomically and preserve historical-season rows. It
must not reinterpret a role without `clubs.officials.view` as authorised to view Officials.

## 7. Acceptance

The correction is complete only when:

1. item-3 same-Club listing and truthful-error tests pass;
2. assign, update and remove preserve unrelated roles and reject every invalid composite
   without partial persistence;
3. the controlled local fixture is restored only after the code gates pass;
4. focused local human retests for items 3 and 15 pass; and
5. the full parent matrix is rerun from item 1 through item 18 before staging is considered;
   and
6. one focused item-7 retest proves an exact Club edit leaves exactly one selected
   current-season junction and no former current Club junction.

All six items are complete. Item 6 passed with exactly one current-season Derby Spitfires
junction matching the User's exact Club; the full parent matrix did not require repetition.
