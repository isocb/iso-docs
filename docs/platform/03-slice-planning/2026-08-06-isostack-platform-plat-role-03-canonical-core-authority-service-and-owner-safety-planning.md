# PLAT-ROLE-03 Canonical Core Authority Service And Owner Safety Planning

Date: 2026-08-06

Status: **SUPERSEDED AS AN AUTOMATIC DELIVERY SLICE; REQUIRED BOUNDED AUTHORITY SERVICE
AND OWNER SAFETY DELIVERED BY PLAT-ROLE-02; RETAINED AS HISTORICAL PLANNING ONLY; EXACT
RESIDUAL REVIEW MOVED TO DEFERRED TRIGGER-BASED `PLAT-ROLE-R1`; NOT EXECUTABLE**

Final disposition:

[`Role Authority project closure and residual disposition`](../05-review-and-test/2026-08-10-isostack-platform-role-authority-project-closure-and-residual-disposition.md)

Do not use this maximum-scope plan to reopen the closed project. The remaining legacy
writer question is limited by `PLAT-ROLE-R1`; all other content below is provenance.

Accepted triage:

`docs/platform/02-triage/2026-08-06-isostack-core-platform-seasonpro-role-authority-triage.md`

Dependencies: `PLAT-ROLE-01` accepted matrix and `PLAT-ROLE-02` containment. The multiple-
Owner model and the C1 Owner's authority to create C1 Admins/additional C1 Owners are
accepted; the exact direct/invitation workflow and last-Owner rules remain to be selected.

## 1. Objective

Replace duplicated Core-role mutation rules with one Platform-owned, tenant-scoped,
audited service used by ordinary Core and authorised P1 procedures.

## 2. Service Contract To Finalise

The service must receive and validate separately:

- real actor and any authorised effective subject;
- target tenant and target user;
- current and requested Core role/status;
- reason/source surface;
- expected current version/state for concurrency safety; and
- associated audit/session-revocation requirements.

It must enforce the accepted matrix for:

- Owner/P1 authority to elevate or demote;
- Admin inability to grant Core elevation;
- self-change refusal;
- last-active-Owner protection;
- ownership appointment/transfer;
- suspended/deactivated Owner protection;
- exact same-tenant targeting;
- platform-admin separation; and
- fail-closed conflict/retry behaviour.

Role change and durable audit evidence must be transactional. Session revocation occurs
after successful commit and failures must be observable/retryable without rolling back a
committed authority change invisibly.

## 3. Consumer Migration Boundary

Route through the service only the inventoried Core writers, including ordinary Core role
change and authorised P1 tenant-user management. Invitations/provisioning must validate the
same actor-to-requested-role matrix before creating a pending account.

SeasonPro remains unable to decide or write Core role directly. Its C1 Owner user-management
workflow may request Organisation Admin or additional Owner through this Platform-owned
service after that combined surface passes its own review. SeasonPro provisioning must form
a complete valid persona: C1 Owner/Admin plus League role, or C2 Member plus Club role and
exact Club. A generic unassigned Platform account remains a separate no-context outcome.

## 4. Acceptance Direction

Automated and human tests must cover:

- Owner, Admin, Member and P1 actors;
- self, same-tenant and cross-tenant targets;
- zero/one/multiple Owner states;
- concurrent attempts affecting the last active Owner;
- invitation, direct change, suspension/deactivation and recovery decisions;
- exact before/after audit evidence without sensitive payload leakage;
- session revocation/reauthentication;
- other enabled-module access remaining correct; and
- direct API refusal even when a browser control is hidden.

## 5. Non-Goals And Stop

No module-role inference, SeasonPro card redesign, live bulk repair, cross-tenant relinking or
impersonation architecture redesign belongs here. Schema or distributed-lock requirements
discovered by `PLAT-ROLE-01` require a plan amendment before implementation authority.
