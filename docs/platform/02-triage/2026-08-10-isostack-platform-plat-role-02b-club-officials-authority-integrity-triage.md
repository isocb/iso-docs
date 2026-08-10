# PLAT-ROLE-02B Club Officials Authority Integrity Triage

Date: 2026-08-10

Status: **TRIAGE COMPLETE; URGENT REMEDIAL EXPEDITE IMPLEMENTED AND TECHNICALLY ACCEPTED
LOCALLY; ITEMS 3 AND 15 CORRECTED; CONTROLLED FIXTURE REPAIRED; PARENT 1–18 MATRIX
ACCEPTED; ITEM-7 FOCUSED RETEST AND READ-ONLY DERBY EXACT-JUNCTION PROOF PASS; LOCAL GATE
COMPLETE**

Source:

[`PLAT-ROLE-02B CR-Fix`](../01-cr-inputs/CR-Fix-2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity.md)

## 1. Decision

```text
Owner      Platform Role Authority parent with bounded SeasonPro consumer correction
Class      Urgent remedial authority-integrity correction
Severity   Critical
Urgency    Before any further PLAT-ROLE-02 human testing
Data       One controlled disposable local-fixture repair after technical acceptance
Release    Stop at local dev for the complete 1–18 human gate; no staging authority
```

Item 3 and item 15 share the same obsolete/incomplete Club Officials authority boundary and
must be corrected together. Splitting item 3 into a later consumer project would prevent a
continuous 1–18 smoke and leave the page misleading even if mutation integrity were fixed.

## 2. Root Cause Classification

This is not Core-account deletion or an Auth.js revocation defect. It is a SeasonPro
consumer defect with four connected parts:

1. admission still depends on a deprecated display/legacy position field;
2. the UI collapses transport/authority failure into a valid empty state;
3. assign/update treat a selected Club role as the target's complete role set rather than
   one scoped part of the persona; and
4. remove and mutation guards do not share one final-persona/component/read-only contract.

The runtime resolver correctly denies a C1 Admin that no longer has its mandatory League
role. The defect is that Club Officials was allowed to persist that invalid state.

## 3. Priority And Containment

This correction displaces the remaining parent smoke. Until it passes locally:

- do not edit, assign or remove officials through Club Officials;
- do not recreate or delete the affected account;
- preserve the disposable fixture and its audit evidence;
- do not run parent items 16–18; and
- do not push or promote the uncommitted Role Authority work.

Staging and production remain unchanged. The separate protected-branch dependency CR-Fix
continues to block the next remote promotion and is not absorbed here.

## 4. Required Workstreams

### A. Item-3 read boundary

Use exact active module roles, current Club context, tenant ownership and
`clubs.officials.view`. Remove legacy-position admission. Return a truthful error state to
the page and retain a distinct valid-empty state.

### B. Item-15 mutation integrity

Create a shared Club-official mutation policy which resolves actor/target/role/Club,
preserves unrelated exact roles, derives the proposed final persona and rejects it before
persistence if invalid. Commit User, junction and audit changes atomically. Enforce
component and read-only state on assign, update and remove.

### C. Controlled recovery and matrix restart

After automated acceptance, restore only the evidenced local fixture to the last known
valid League-plus-Club persona. Retest items 3 and 15, then restart the parent 1–18 matrix
from item 1 so earlier passes are confirmed against the corrected code.

## 5. Do Not Build

- no general role-service redesign or `PLAT-ROLE-03` work;
- no broad live-data repair or migration;
- no new component-key taxonomy;
- no invitation/session redesign;
- no widening of C2 authority beyond exact Club and existing component grants; and
- no staging/main promotion in this cycle.

## 6. Triage Outcome

Proceed to one `PLAT-ROLE-02B` bounded implementation plan containing A, B and C. Item 3 is
a mandatory acceptance gate, not optional polish. Human testing must be possible from item
1 through item 18 after the correction.

Delivery update: the bounded code, automated gates, one exact local-fixture repair and the
complete parent 1–18 human matrix are complete. An item-7 exact Club edit proved its stated
persona/reopen behaviour but retained a former current-season ClubOfficial junction. The
same CR-Fix now reconciles only current-season memberships, preserves history and leaves
component-based Officials authority unchanged. The focused edit/reopen and read-only
exact-junction proof now pass; it has no independent staging disposition.
