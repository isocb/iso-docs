# P1 Tenant Module Persona Recovery Triage

Date: 2026-08-17

Identifier: `CR-Fix-PLAT-ROLE-04`

Status: **TRIAGE ACCEPTED — EXACT `250baf12` PROMOTED AND LIVE ON STAGING WITH GREEN
TECHNICAL GATES; STAGING HUMAN ACCEPTANCE PENDING**

Source:

[`CR-Fix-PLAT-ROLE-04`](../01-cr-inputs/CR-Fix-2026-08-17-isostack-platform-p1-tenant-module-persona-recovery.md)

## 1. Decision

```text
Owner      Platform shared tenant/P1 administration, with SeasonPro policy reuse
Class      Urgent remedial recovery and authority-integrity correction
Severity   Critical operational availability; high authority integrity
Data       No bulk repair or migration
Release    Local dev -> focused human gate -> exact staging -> indicative human gate -> main
Expedite   Accepted; local implementation/human smoke and exact dev/staging scans pass
```

Create one bounded `PLAT-ROLE-04` implementation slice. It must make the current P1 Client
Users surface SeasonPro-aware for both edit recovery and new-user creation. Do not reopen
the completed broad Role Authority project or revive superseded `PLAT-ROLE-03`/
`LMS-ROLE-01/02` plans.

## 2. Root Cause Classification

This is a P1 administration contract gap, not a faulty runtime permission grant.

The Role Authority work correctly established that C1 is a composite of Core Owner/Admin
plus an exact League role. The current P1 client editor manages only the Core half. An
older P1 organisation editor manages both halves, and the update endpoint accepts both,
but the current authoritative route does not use that capability. The P1 create endpoint
also persists the Core half alone.

The observed locked state is therefore:

1. structurally valid as a Core account;
2. intentionally invalid as a SeasonPro C1 persona; and
3. not recoverable through the normal current P1 operating surface.

## 3. Scope Decision

### Include

- authoritative `/platform?tab=clients` and `/platform/clients/[id]` user create/edit;
- module-aware detection through the tenant's active product/module assignment;
- active exact tenant League/Club role and current Club selectors;
- active-SeasonPro role-catalogue health and a P1-only audited bootstrap when an exact
  League or Club default is genuinely absent;
- explicit effective-persona/incomplete-state presentation;
- server validation and transactional persistence for P1 edit and create;
- exact current-Club junction reconciliation where a Club context changes;
- audit evidence and target-session revocation; and
- automated and human recovery evidence using disposable or controlled non-production
  accounts.

### Exclude

- last-valid-C1 prevention inside C1-owned workflows;
- tenant transfer of existing identities;
- live data inspection or repair during implementation;
- legacy role conversion or bulk cleanup;
- global Platform Administrator user management; and
- unrelated Fund, support, email or module work.

## 4. Architecture Direction

Reuse the accepted SeasonPro persona policy and the exact-role separation already proved
in the older P1 organisation user editor. Do not maintain two independent copies.

The preferred correction is a small shared P1 SeasonPro persona form/policy adapter used by
the authoritative Client Users UI and, where retained, the older organisation route. The
server remains authoritative. UI filtering is usability, never the security boundary.

The existing `platformUpdateUser` mutation is the natural update boundary, but it needs
transactional audit/junction handling and session revocation. The existing
`createForOrganization` mutation should accept the complete optional module composite and
create it atomically when SeasonPro is active.

No schema or migration is expected.

## 5. Key Policy Decisions

- Core `OWNER`/`ADMIN` is not synonymous with SeasonPro C1.
- An incomplete Owner/Admin is displayed as incomplete, not silently relabelled C2.
- Exact League and Club roles remain additive parts of one persona; `BOTH` is never a role.
- A Club-only C2 is `MEMBER` plus exact Club role and current Club; it does not require a
  League role.
- A hat-swap C1 is Owner/Admin plus separate exact League and Club roles and current Club;
  the legacy `League & Club`/`BOTH` catalogue row is neither displayed nor assigned.
- P1 may repair an existing user or create a replacement within the selected tenant.
- P1 may not move an existing account between tenants in this slice.
- A lost-email scenario is handled by creating a complete replacement identity and then
  separately suspending the inaccessible account, not by silently transferring identity.
- Non-SeasonPro organisations keep the current Core-only flow.
- Bare P1 tenant creation remains product-neutral. SeasonPro product assignment is the
  normal point that seeds exact default roles and assigns the Owner's League role.
- An active SeasonPro tenant with a missing/partial exact role catalogue is an explicit
  recovery condition; P1 must be able to run an audited idempotent exact-default bootstrap
  before user repair rather than needing a C1 user who does not yet exist.
- The runtime resolver remains unchanged and fail-closed.

## 6. Data And Session Decision

No automatic repair is safe because the intended tenant-specific League role cannot be
inferred. P1 must select it explicitly.

For every authority/persona mutation:

1. resolve target tenant and complete final composite;
2. validate exact roles/current Club before writes;
3. persist User, current Club junction and audit together;
4. revoke the target's session after successful commit; and
5. make the UI tell P1 that the user must sign in again.

The current revocation service is fail-open when Redis is unavailable. Local tests must
prove the revocation call contract; staging must prove the configured operational result.
The implementation must not falsely claim session revocation if its delivery cannot be
observed.

## 7. Promotion Decision

Accepted delivery sequence:

1. implement only from exact `328aadf0`, preserving unrelated workspace/FUND work;
2. stop for focused local human smoke;
3. commit only the bounded code and authoritative documents;
4. align exact accepted commit to `origin/dev` and require its Security Scan;
5. promote that exact commit to staging and run an indicative recovery smoke;
6. promote to main only after explicit control-owner staging acceptance; and
7. resume FUND Stage C from its captured suspended checkpoint.

No stage may absorb unrelated local workspace changes.
