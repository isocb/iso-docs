# LMSPro CR Input - Club Official Removal And Access Lifecycle

Date: 2026-07-02
Module: LMSPro / SeasonPro
Source: Live remediation observation during R2 club user membership repair
Status: CR input captured for triage and slice planning
Priority: High

## User Observation

During LMSPro R2 live/staging remediation, club users with no linked Club were found in the
active user list. These users were not necessarily corrupt imports. Some appear to be the
expected result of a C1 or C2 using the Club view `Remove` action to remove a user from a
Club.

The user remains in the system but is no longer linked to a Club.

This is not ideal in a youth league context. Club officials can have child-protection and
safeguarding sensitivities. If a Club official is removed from a Club, the system should not
leave that person as an active, unscoped LMSPro user with a possible login route to a
dashboard.

## Current Behaviour Observed In Code

The current Club official remove route:

- clears `User.lmsproClubId`;
- clears `User.lmsproClubRole`;
- keeps `User.lmsproRoleIds`;
- deletes `LMSProClubOfficial` rows for that Club name across seasons;
- keeps `User.status` unchanged.

This can leave a user:

- active;
- holding LMSPro role ids;
- with no authoritative Club membership row;
- with no obvious Club context for C1 review.

## Desired Policy

Removing a Club official from a Club should be treated as an access lifecycle event, not only
as a list cleanup action.

When the removed user has no remaining active Club membership and no League-level access,
the safe default should be:

```text
remove from active Club official list
retain historical association/evidence
deactivate account access
prevent dashboard access
make reactivation deliberate
```

The user should not simply vanish from all Club context. A former or archived Club users
section would help C1 and appropriate C2 club managers understand who used to have access
and allow deliberate reactivation where appropriate.

This matters especially for role-based email addresses. A Club may remove a named person
from a role email account such as `secretary@club.example`, then realise the email account
should continue to be used by the next secretary. The app cannot control whether the
departing person still has mailbox access outside SeasonPro, but it can:

- remove the departing person's SeasonPro access;
- keep a visible historic record that the email/user was previously attached to the Club;
- let C1/C2 deliberately reactivate or re-add the same role email with updated name/contact
  details once the Club has dealt with mailbox access externally.

## Requested Outcome

Create a remediation/refinement slice to:

- prevent active LMSPro club-only users with no Club from retaining normal dashboard access;
- deactivate club-only users when their final Club membership is removed;
- preserve enough historical association to support safeguarding, audit and reactivation;
- add a Club page section for former/archived users visible to C1 and appropriate C2 users
  if the data model supports it;
- ensure re-adding a former user reactivates the account safely;
- support safe reuse of role-based email addresses by reactivating/relinking the historic
  user record where appropriate rather than forcing a hard delete;
- avoid hard deletion as the default remedy.

## Important Distinctions

This CR input does not request normal hard deletion.

Hard deletion may be appropriate for:

- mistaken test users;
- duplicate users that have no useful audit history;
- formal GDPR erasure requests.

Club official removal is different. The safer default is to remove current access, preserve
history, and deactivate the user when no other legitimate access remains.

## Open Questions For Triage

- Should archived Club membership be stored by adding lifecycle fields to
  `LMSProClubOfficial`, or by adding a separate membership history table?
- Should C2 users be allowed to remove/deactivate another C2 user, or should final-access
  removal require C1 approval?
- Which C2 roles should be allowed to see former/archived Club users?
- Should C2 reactivation of a former user require C1 approval, or can trusted Club managers
  re-add/reactivate directly?
- Should role-based email reuse require an explicit checkbox confirming that mailbox access
  has been handled outside SeasonPro?
- Should a removed user see an archived/no-access page if they still have a valid session,
  or should login be blocked completely via `DEACTIVATED` status?
- Should removal require a reason field for safeguarding audit?
- Should C1 be warned when removing the final Club membership for a user?

## Suggested Slice

Suggested planning slice:

```text
LMSPro Remediation Slice R3 - Club Official Removal And Archived Access Lifecycle
```
