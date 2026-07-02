# LMSPro Remediation Slice R3 - Club Official Removal And Archived Access Lifecycle Planning

Date: 2026-07-02
Module: LMSPro / SeasonPro
Status: Planned
Type: Access lifecycle hardening and safeguarding refinement
Related CR input: `docs/modules/lmspro/01-cr-inputs/2026-07-02-lmspro-cr-club-official-removal-access-lifecycle-input.md`

## Purpose

R3 addresses a weakness discovered during R2 manual remediation:

```text
Removing a user from a Club can leave the User active but with no Club membership.
```

In a youth league, this is a safeguarding-sensitive access lifecycle issue. A former Club
official should not be left as an active, unscoped LMSPro user. The system should remove
current access, preserve audit/history, and make any later reactivation deliberate.

## Current Code Behaviour

The current `clubOfficials.remove` route:

- clears `User.lmsproClubId`;
- clears `User.lmsproClubRole`;
- keeps `User.lmsproRoleIds`;
- deletes `LMSProClubOfficial` rows for the Club name across seasons;
- does not change `User.status`.

This makes the person disappear from the Club official list, but it can leave the User row
active with LMSPro role ids and no authoritative Club context.

## Policy To Lock

Club official removal is not a normal delete.

The intended policy is:

- current Club access must be removed immediately;
- the user must not retain dashboard access if they have no remaining Club or League access;
- historical association should be retained where possible;
- C1 and appropriate C2 club managers must be able to review former Club users;
- reactivation must be explicit and auditable;
- role-based email addresses must be reusable without forcing unsafe hard deletion;
- hard deletion must remain a separate, deliberate path for GDPR/test/irrecoverable users.

## Proposed Implementation Shape

### R3-A - Immediate Safety Hardening

Adjust `clubOfficials.remove` so that after removing the selected Club membership it checks
the target user:

- Does the user still have any active `LMSProClubOfficial` rows?
- Does the user have League-level or BOTH-scope role access?
- Is the user a Platform/Admin user who must not be deactivated by Club removal?
- Is the user being removed from only one of several Clubs?

If the removed user has no remaining Club membership and no League-level access:

```text
set User.status = DEACTIVATED
clear legacy club pointer fields
write an audit log explaining final Club membership removal
revoke sessions if the existing session revocation helper is suitable
```

If the user still has another active Club or League access, only remove that Club membership.

### R3-B - Archived Club User Visibility

The preferred product behaviour is not simply to make former users vanish.

Add a Club page section visible to C1 and appropriate C2 club managers, such as:

```text
Former / archived Club users
```

This section should show removed Club users with:

- name;
- email;
- former role;
- removed date/time;
- removed by;
- account status;
- optional removal reason;
- action to reactivate/re-add if permitted.

This should be a Club-context table, not only a global Users admin feature. C2 users need to
see the former users for their own Club so they can understand and remedy removals made in
error.

### R3-B1 - Role-Based Email Reuse

Role-based email addresses create a special recovery case.

Example:

```text
secretary@club.example
```

A Club may remove an official because the named person has left, but the role email should
continue for the new person in that role. SeasonPro cannot remove the departing person's
mailbox access outside the app, but it can make the app-side lifecycle safe:

- removed official loses SeasonPro access;
- historic Club association remains visible;
- C1/C2 can re-add/reactivate the same role email;
- the display name and contact details can be changed for the new holder;
- the action is audited;
- the UI reminds the Club that external mailbox access must be handled outside SeasonPro.

The reactivation flow should avoid hard deletion. Reusing the same email address should
normally update/reactivate the existing user record rather than requiring a new user row.

### R3-C - Membership Lifecycle Data Model

Current `LMSProClubOfficial` rows are deleted on removal. That makes former-user display
harder because the membership evidence disappears apart from audit logs.

Preferred data model direction:

- add lifecycle fields to `LMSProClubOfficial`, or add a dedicated membership history table;
- avoid hard-deleting the membership row during ordinary removal;
- mark the membership archived/inactive instead;
- allow reactivation by updating the archived row back to active, or by creating a new active
  row with clear history.

Likely fields if extending `LMSProClubOfficial`:

```text
status: ACTIVE | ARCHIVED
removedAt
removedById
removalReason
reactivatedAt
reactivatedById
```

The current unique constraint is `clubId, userId, role`. If archived rows remain in the same
table, reactivation should update the existing row rather than creating duplicates.

## Out Of Scope

R3 does not include:

- bulk hard deletion of users;
- GDPR erasure workflow;
- changing R2 manual live remediation method;
- rebuilding all role architecture;
- child protection policy drafting outside the system access controls.

## UI Expectations

Club page:

- Active Club officials remain in the current table.
- Removed users appear in a separate former/archived section, not mixed with active users.
- The former/archived section is visible to C1 and to appropriate C2 users for their own Club.
- Removing the last Club membership warns C1/C2 that the user account will be deactivated.
- Reactivating/re-adding a former user is explicit.
- Reactivating/re-adding a role-based email allows the name/contact details to be refreshed.
- The UI should explain that mailbox access is external to SeasonPro.

Users admin page:

- Users with no active Club and no League access should not appear as normal active club
  users.
- Deactivated former Club users may be visible through a filter or archived section.
- The existing `Delete User` wording should be revisited separately because it currently
  means deactivate, not permanent delete.

Dashboard/login:

- A user with no current Club access should not reach a normal Club dashboard.
- If status remains active for any exceptional reason, route them to a no-active-access or
  archived account page with no Club data access.

## Review And Test Plan

Create staging tests for:

- removing a user who has one Club only deactivates them;
- removing a user from one of two Clubs keeps them active for the remaining Club;
- removing a BOTH/League user from a Club does not remove League access;
- removed user no longer appears in active Club officials;
- removed user appears in former/archived section if lifecycle storage is implemented;
- appropriate C2 users can see former/archived users for their own Club but not other Clubs;
- re-adding a deactivated former user reactivates them and restores Club membership;
- re-adding a role-based email lets name/contact details be updated without hard delete;
- current C2 dashboard access is blocked after final Club removal;
- audit log records removal, deactivation and reactivation.

Run existing LMSPro checks:

```bash
npm test -- run src/modules/lmspro/lib/__tests__/provision-club-user.test.ts src/modules/lmspro/import/handlers/__tests__/club.test.ts
npm run type-check
```

Add targeted tests around `clubOfficials.remove` if the router/service can be tested without
excessive harness work.

## Acceptance Criteria

R3 is complete when:

- final Club membership removal no longer leaves a club-only user active with no Club;
- the user is deactivated or blocked from normal dashboard access;
- historical association is preserved or recoverable;
- C1 and appropriate C2 users can find former Club users for review/reactivation;
- role-based email addresses can be safely reused by reactivation/relinking;
- multi-club and League users are not accidentally deactivated;
- staging evidence confirms the behaviour before live promotion.

## Recommended Implementation Prompt

```text
Please implement LMSPro Remediation Slice R3:
club official removal must deactivate club-only users when their final Club membership is
removed, preserve former membership visibility for C1 and appropriate C2 users, support
safe role-based email reuse by reactivation/relinking, and ensure removed users cannot
access normal Club dashboards. Keep hard deletion out of scope. Follow the planning doc and
add targeted tests.
```
