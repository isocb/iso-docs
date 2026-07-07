# LMSPro CR Input - Small Remedial UI And Count Polish

Date: 2026-07-07
Module: LMSPro / SeasonPro
Source: Dev/staging smoke testing follow-up
Status: CR input captured for planning
Priority: Medium / operator polish and test unblockers

## User Observation

Several small remedial issues have surfaced during LMSPro testing. Each item is modest on
its own, but together they affect C1 confidence when testing communications, change
requests and club dashboard status counts.

The changes should be made on local app `dev`.

## Requested Changes

### 1. Compose Email Template Deletion

On the LMSPro compose email page, the template list/dropdown should include a clear remove
control so a template can be deleted from the list.

Desired behaviour:

- show a delete/remove icon alongside removable templates;
- require confirmation before deleting;
- remove only tenant/user-created templates unless platform/system templates are already
  safely mutable by design;
- refresh the template list after deletion;
- do not affect sent emails or historical email records.

### 2. Change Request Management Age Group Filter

On Change Request Management, including:

```text
/app/lmspro/free-days?tab=variations&status=PENDING
```

add an Age Group filter dropdown.

The filter should help C1 users review requests by age group, especially now Age Group and
Division managers are part of notification routing and operational workload ownership.

### 3. Request Type Dropdown Completeness

The Change Request Management request type dropdown should include all request types that
can actually be submitted from the Variation Request flow.

Example problem:

```text
Change Division
```

is available as a Variation Request option but is not visible in the management filter
dropdown.

The management dropdown should use the same source of truth as the submission workflow, or
otherwise be kept in strict parity with it.

### 4. Club Dashboard Waiting List Count

On the club dashboard, under the Season section, there are widgets for:

```text
Active Teams
Waiting List
Officials
```

The Waiting List widget currently reports zero regardless of the number of teams that are
actually on the waiting list.

The count should be checked and fixed so it reflects the club's current-season waiting-list
teams.

## Scope

### Included

- compose email template delete affordance;
- safe delete/confirm behaviour for removable templates;
- Change Request Management Age Group filter;
- Request Type filter parity with Variation Request options;
- Club Dashboard Waiting List count fix;
- implementation confirmation and review/test notes.

### Excluded

- redesigning the communications module;
- changing notification routing semantics from R5-B;
- changing Age Group / Division manager assignment storage;
- changing team registration or waiting-list workflows beyond the dashboard count;
- deleting platform/system templates unless already explicitly safe.

## Acceptance Direction

This CR is complete when:

- C1 can remove a removable compose email template via a clear icon/control;
- deletion has a confirmation step and refreshes the dropdown/list;
- Change Request Management can be filtered by Age Group;
- Request Type filter includes every Variation Request type currently available to clubs;
- Waiting List count on the club dashboard matches the underlying current-season team data;
- all changes are implemented on app `dev`;
- documentation is updated through planning, implementation confirmation and review/test.

