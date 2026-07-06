# LMSPro CR Input - Playing Day Configuration And Multi-Day League Architecture

Date: 2026-07-06
Module: LMSPro / SeasonPro
Source: Operator/client discovery conversation with other leagues
Status: Major CR input captured for future architectural triage
Priority: Critical / Architectural

## User Observation

Some leagues do not operate as a single competition structure.

Example:

```text
One league organisation may run Saturday football and Sunday football.
```

The same Club may have teams in both Saturday and Sunday football. Those teams may have the
same or very similar names, but the competitions are operationally separate. They may have
their own Age Groups, Divisions / AGGs, managers, fixtures, communications and rules.

The product needs a way to represent this separation without compromising leagues that only
have one playing day, such as Derby JFL.

## Core Requirement

Introduce a League configuration concept for Playing Day.

Initial configuration model:

```text
Single playing day
Multiple playing days
```

When a league is configured as `Single playing day`, the current UI and workflows should
remain simple and should not force users to think about Playing Day.

When a league is configured as `Multiple playing days`, C1 users should be able to create
and manage multiple Playing Days, for example:

```text
Saturday
Sunday
Midweek
```

Each Playing Day should act as an operational competition stream within the same league
organisation.

## Architectural Concept

Playing Day is not just a display filter.

It is an architectural scope that may sit above, or alongside, Age Groups and Divisions /
AGGs:

```text
League
-> Season
-> Playing Day
-> Age Groups
-> Divisions / AGGs
-> Teams
```

For multi-playing-day leagues, Age Groups and Divisions may need to be scoped to a Playing
Day. Team records may also need to carry Playing Day so that the same Club can have the
same team name in different competition streams without conflict.

## UI Direction

For multi-playing-day leagues, the UI should make the separation visible and manageable.

Likely UI pattern:

- tabbed layout by Playing Day on C1 pages;
- tabbed layout by Playing Day on relevant C2 Club dashboard pages;
- Age Groups managed within a selected Playing Day;
- Divisions / AGGs managed within a selected Playing Day;
- Division Manager / Age Group Manager assignment visible within the selected Playing Day;
- Teams grouped or filtered by Playing Day.

For single-playing-day leagues, this extra layer should be hidden or minimised so the
product remains simple.

## Important Data Rule

Removing a Playing Day must be carefully gated.

A Playing Day should not be removable while records are scoped to it.

At minimum, deletion/removal should be blocked when any of the following exist for that
Playing Day:

- Teams;
- Age Groups;
- Divisions / AGGs;
- fixtures or fixture-like records;
- Free Day Requests;
- Variation Requests;
- applications or registrations;
- communication/history records where Playing Day context matters.

The safe rule is:

```text
A Playing Day can only be removed when no live or historical records depend on it.
```

If deletion is not appropriate, the product may need an archive/deactivate option instead.

## Impact Areas

This CR is expected to affect many parts of LMSPro.

### Configuration

- League settings need a single/multiple Playing Day mode.
- Multiple mode needs C1 CRUD for Playing Days.
- Changing mode must be gated and auditable.

### Age Groups

- Age Groups may need Playing Day scope.
- Age Group manager assignment may need to be Playing Day-aware.
- Roll-forward must know whether Age Group succession is per Playing Day.

### Divisions / AGGs

- Divisions / AGGs may need Playing Day scope.
- Division / AGG manager assignment may need to be Playing Day-aware.
- Division names may repeat across Playing Days.

### Teams

- Teams may need Playing Day scope.
- The same Club may have teams with the same name in different Playing Days.
- Team uniqueness rules may need to include Playing Day.
- C2 Club dashboard team tabs may need Playing Day separation.

### Import / Export

- Import templates may need a Playing Day column.
- Export outputs may need Playing Day filtering and labelling.
- Existing single-day import/export workflows must remain simple.

### Roll-Forward

- Roll-forward may need to preserve Playing Day scope.
- Age Group succession may be different per Playing Day.
- Divisions / AGGs may roll forward separately by Playing Day.
- Dummy staging roll-forward testing should include a multi-playing-day case before live
  use.

### Cloning / Copying

- Season cloning may need to clone Playing Days.
- Age Group and Division structures may need to be copied within each Playing Day.
- Copying a Playing Day may become a future useful operation, but should not be assumed in
  the first implementation.

### Notifications

- Notification routing may need Playing Day context.
- Age Group and Division manager routing should respect Playing Day.
- League Admin fallback may remain global, but scoped manager routing should not cross
  Playing Day boundaries.

### Communications

- Email cohorts may need Playing Day filters.
- Announcement targeting may need Playing Day filters in future.
- Sent history may need enough context to show which Playing Day a communication related
  to, where applicable.

### Fixtures / Key Dates

- Playing Day may affect event windows, key dates, fixture schedules and reminders.
- Future sequencing and reminder logic may need to route by Playing Day as well as Age
  Group / Division.

## Backward Compatibility Policy

Single-playing-day leagues must not be made more complex by this change.

Preferred policy:

- existing leagues default to `Single playing day`;
- no new required UI step appears for single-day leagues;
- existing Age Group / Division / Team screens continue to behave as they do now;
- any default/internal Playing Day record is hidden unless multiple mode is enabled;
- migration must avoid changing current Derby JFL-style workflows.

## Open Questions For Future Triage

- Should single-playing-day leagues have an implicit hidden Playing Day record?
- Should Playing Day be stored at Season level, League configuration level, or both?
- Should Playing Days be constrained to actual days of week, or tenant-defined labels?
- Can a league have more than one competition stream on the same day?
- Should a team be required to have a Playing Day when multiple mode is enabled?
- How should existing teams be migrated if a league changes from single to multiple?
- Should Age Groups be duplicated per Playing Day, or shared with Playing Day-specific
  Divisions?
- What happens if a Club has the same team name in two Playing Days?
- How should communications cohorts expose Playing Day without overwhelming users?
- How should archived/deactivated Playing Days appear in historical reporting?

## Risk

This is a major architectural CR.

Risks include:

- accidentally adding complexity to simple single-day leagues;
- breaking existing team uniqueness assumptions;
- leaking data between operationally separate competition streams;
- under-scoping notifications and emails;
- making import/export ambiguous;
- making roll-forward more fragile if Playing Day is not included consistently.

The change should therefore be approached through discovery, planning and controlled
slicing before implementation.

## Acceptance Direction For A Future Slice

A future planning slice should not be considered ready until it has:

- mapped every entity that needs Playing Day scope;
- identified current uniqueness constraints affected by Playing Day;
- defined single-day migration/backward compatibility behaviour;
- defined multi-day UI patterns for C1 and C2;
- defined safe deletion/archive rules;
- defined roll-forward expectations;
- defined import/export changes;
- defined notification and communications routing impact;
- identified a small test league data set for staging validation.

## Out Of Scope

This CR input does not request immediate implementation.

No planning slice is being created at this point. The purpose of this document is to capture
the architectural requirement clearly so it can be triaged into a careful future planning
route.
