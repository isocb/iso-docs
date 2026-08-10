# PLAT-ROLE-02B Club Officials Authority Integrity Planning

Date: 2026-08-10

Status: **BOUNDED URGENT REMEDIAL PLAN IMPLEMENTED AND TECHNICALLY ACCEPTED LOCALLY;
CONTROLLED FIXTURE REPAIR AND PARENT 1–18 HUMAN MATRIX COMPLETE; ITEM-7 CURRENT-CLUB
JUNCTION FOLLOW-THROUGH FOCUSED RETEST AND READ-ONLY DERBY PROOF PASS; LOCAL SLICE GATE
COMPLETE AND COMMITTED IN ROLE CHILD `b1ede26f`**

Source:

[`PLAT-ROLE-02B CR-Fix`](../01-cr-inputs/CR-Fix-2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity.md)

Triage:

[`PLAT-ROLE-02B triage`](../02-triage/2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity-triage.md)

Parent:

[`PLAT-ROLE-02`](2026-08-06-isostack-platform-plat-role-02-core-role-mutation-containment-planning.md)

## 1. Objective

Correct the Club Officials read and mutation authority boundary so a valid same-Club C2
user is listed truthfully and Club-role management cannot discard League roles or persist
an invalid persona. Restore the one damaged disposable local fixture, then enable the
control owner to rerun the complete parent smoke from item 1 through item 18. Reconcile any
stale prior-current ClubOfficial junction exposed by an otherwise valid exact-Club edit.

## 2. Implementation Boundary

### 2.1 Shared server policy

Add a small, testable Club-official authority/persistence policy which:

- loads the authoritative actor, target, selected role and current Club;
- requires one tenant and rejects foreign accounts, roles or Clubs;
- verifies exact `CLUB` scope, active role and current eligible Club;
- derives actor component access and effective read-only state server-side;
- partitions the target's role IDs by exact scope;
- replaces only the Club-scoped selection while preserving League-scoped role IDs;
- forms the proposed final role/Club state;
- validates the complete final SeasonPro persona, allowing an explicit fully-unassigned
  result only for a deliberate remove; and
- returns the complete mutation payload without writing data.

Unknown, `BOTH`, unscoped, inactive or foreign role IDs fail closed. An invalid C1
Owner/Admin without a League role, a Member with a League role, or a Club-role/Club mismatch
must fail before persistence.

### 2.2 Item-3 list correction

- authorise League-wide view through the existing appropriate component boundary;
- authorise same-current-Club view through exact Club membership plus
  `clubs.officials.view`, without `lmsproClubRole`;
- refuse wrong-Club, wrong-tenant, inactive or non-current contexts;
- keep active officials obtained from the authoritative junction/current-club identity;
- remove legacy `BOTH` taxonomy assumptions from filtering; and
- expose query `error` in the page with a retry path, distinct from loading and genuine
  zero officials.

### 2.3 Assign and update correction

- reuse the shared policy for existing-user assign and update;
- preserve unrelated exact League roles and replace only the target's Club role;
- set the exact current Club and maintain the matching ClubOfficial junction;
- make User, junction and audit persistence one database transaction;
- reject unsafe self-edits rather than allowing the actor's runtime persona to become
  `NONE`;
- retain new-official creation as Core `MEMBER` with exact Club role and Club; and
- retain hard refusal for an email belonging to another tenant.

### 2.4 Remove correction

- preserve unrelated League roles;
- remove the exact Club role and active Club affiliation together;
- reconcile the relevant junction without deleting retained historical business records;
- validate the result as C1 or explicitly unassigned before writing; and
- perform User, junction and audit persistence atomically.

### 2.5 UI parity

- show mutation controls only when the current effective role is not read-only and the
  server-recognised management boundary is present;
- keep the server authoritative if UI state is stale; and
- present query refusal/failure explicitly rather than "No officials".

### 2.6 Exact current-Club junction follow-through

- when `lmspro.users.update` explicitly changes or clears the exact Club, load every
  current-season ClubOfficial membership for that tenant user;
- retain only the selected current Club, creating it when absent, or remove every current
  membership when Club is cleared;
- preserve historical-season ClubOfficial records;
- keep User, current junction reconciliation, authority mutation and audit in the existing
  transaction; and
- do not grant `clubs.officials.view` to a role which lacks that configured component.

## 3. Controlled Local Repair

After focused/full automated gates pass:

1. reload `owner@isodo.co.uk` and its relevant audit records read-only;
2. confirm exactly one active Acme account, current Nottingham Tigers Club and intended
   active League Admin and Club Secretary Club roles;
3. record the exact before-state and intended one-account update;
4. restore the two exact roles plus current Club in one validated transaction;
5. retain Core `ADMIN`, `ACTIVE`, tenant link and ClubOfficial membership;
6. verify the final runtime scope is `BOTH`; and
7. record the after-state without exposing credentials or tokens.

Abort rather than infer if any identity, tenant, Club, role or record count differs.

## 4. Automated Gates

Focused tests must prove:

- valid C2 exact-current-Club list access with `clubs.officials.view`;
- wrong Club/tenant, missing component and stale Club refusal;
- list errors remain errors and genuine empty results remain empty;
- read-only view allowed and assign/update/remove refused;
- C1 League-only assign of a Club role becomes valid hat-swap without losing League;
- hat-swap Club-role update preserves League and exact Club;
- C2 Club-role update remains Member plus Club only;
- direct `BOTH`, inactive, foreign and unscoped roles are refused;
- invalid self-edit and cross-tenant target are refused with no writes;
- remove leaves a valid C1 or explicit unassigned state with no role/Club mismatch;
- User/junction/audit failure rolls back the complete transaction; and
- the shared SeasonPro persona and parent authority regression suites remain green.

Then run full tests, type-check, changed-file lint, repository verification, critical-file
verification and production build.

## 5. Human Local Gate

The original focused checks and complete parent 1–18 matrix have passed. The control owner
reported one partial item-7 observation after changing a disposable C2 user's exact Club.
The intended item-7 persona and reopen assertion passed. The Officials refusal was correct
for a role without `clubs.officials.view`; read-only inspection instead identified the stale
prior-current junction defect addressed in section 2.6.

Run one focused retest only:

1. as C1 Owner, save the disposable user as `MEMBER` with one exact active Club role and one
   exact current Club, then reopen it;
2. confirm the Member/role/Club composite and C2 routing remain stable;
3. use a role with `clubs.officials.view` only if a positive Officials-page check is wanted;
   otherwise an explicit refusal is correct; and
4. confirm read-only after Save that exactly one current-season junction exists for the
   selected Club, the former current Club is absent and historic-season rows are unchanged.

Any authority, tenant, partial-write, role-preservation or exact-junction failure blocks
completion. Do not rerun the full matrix. Stop at local dev after the focused gate; staging
requires a later explicit decision and a restored protected-branch Security Scan.

## 6. Non-Goals

- no schema, migration, seed or broad data repair;
- no Core Organisation-role policy change;
- no `PLAT-ROLE-03`, `LMS-ROLE-01` or `LMS-ROLE-02` expansion;
- no Auth.js/session or invitation architecture change;
- no historic Club-lifecycle redesign; and
- no push, staging or production promotion.

## 7. Recovery

Revert the bounded Club Officials code change. If the controlled fixture repair has occurred,
restore only its captured pre-repair local state using the recorded exact identifiers. Do
not delete or recreate the Core account as rollback.
