# LMSPro CR Input - Playing Day Configuration And Multi-Day League Architecture

Date: 2026-07-06
Module: LMSPro / SeasonPro
Source: Operator/client discovery conversation with other leagues
Status: Major CR input captured for future architectural triage; near-term mitigation identified
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

## Near-Term Mitigation: Playing Day As Age Group Convention

Before the full Playing Day architecture is implemented, a workable mitigation is to use
Age Groups as the visible playing-day container.

Instead of creating only:

```text
U7
U8
U9
```

a multi-playing-day league can create explicit playing-day Age Groups:

```text
U7 Saturday
U7 Sunday
U8 Saturday
U8 Sunday
U9 Saturday
U9 Sunday
```

Divisions / AGGs then sit under those playing-day-named Age Groups:

```text
U7 Saturday
-> Division Red
-> Division Blue

U7 Sunday
-> Division Red
-> Division Blue
```

This does not give the product a true `Playing Day` entity, but it lets the league create
clean operational separation using structures the app already understands.

### Example: Same Club, Same Age Band, Different Playing Day

```text
Club: Spondon Dynamos

Team: Spondon Dynamos U7
Age Group: U7 Saturday
Division: Division Red

Team: Spondon Dynamos U7
Age Group: U7 Sunday
Division: Division Red
```

The teams are still separate because they are attached to different Age Group / Division
structures. If existing team-name uniqueness rules still prevent identical names, the team
names may need a clear suffix during the mitigation period, for example:

```text
Spondon Dynamos U7 Saturday
Spondon Dynamos U7 Sunday
```

### Example: Manager Routing

The R5 Age Group / Division manager model can support this mitigation naturally.

For example:

```text
U8 Saturday managers:
-> Saturday Mini Soccer Lead

U8 Sunday managers:
-> Sunday Mini Soccer Lead
```

If a Team Variation Request is raised by a team in `U8 Saturday`, notification routing can
derive the context from the team and route to the `U8 Saturday` manager or the relevant
Division manager. The notification setting should not ask the operator to pick a fixed
Age Group value. The team, division and age group on the submitted request provide that
scope at runtime.

### Example: Roll-Forward

The mitigation only remains safe if roll-forward treats each playing-day-named Age Group
as a separate successor chain.

Safe successor examples:

```text
U7 Saturday -> U8 Saturday
U8 Saturday -> U9 Saturday

U7 Sunday -> U8 Sunday
U8 Sunday -> U9 Sunday
```

Unsafe successor examples:

```text
U7 Saturday -> U8
U7 Sunday -> U8
U7 Saturday -> U8 Sunday
```

Before live roll-forward, staging must prove that teams, divisions, manager assignments
and notification routing remain in the correct playing-day-named Age Group stream.

### Benefits

- avoids a large schema and UI change before the next roll-forward;
- keeps single-playing-day leagues unchanged;
- lets multi-playing-day leagues operate with visible separation immediately;
- works with the Age Group / Division manager routing already being introduced;
- makes import/export possible using explicit Age Group names or codes;
- reduces implementation risk while preserving the full architectural CR.

### Limits

This is a mitigation, not the final architecture.

Known limits:

- the database does not enforce Playing Day as its own scope;
- reporting by Playing Day depends on naming discipline;
- imports must use exact Age Group names or stable codes;
- team-name uniqueness may still need careful naming;
- operators must not collapse `U7 Saturday` and `U7 Sunday` into one successor Age Group;
- future migration to true Playing Day architecture will need to map these Age Groups to
  real Playing Day records.

This convention should therefore be treated as an approved bridge: useful, lower-risk and
potentially sufficient for some leagues, but not a replacement for the full architectural
model where stronger separation is needed.

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
- During the mitigation phase, Age Group names/codes may carry the Playing Day, for
  example `U7 Saturday` and `U7 Sunday`.

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
- During the mitigation phase, imports may use exact playing-day-named Age Group values
  instead of a separate Playing Day column.

### Roll-Forward

- Roll-forward may need to preserve Playing Day scope.
- Age Group succession may be different per Playing Day.
- Divisions / AGGs may roll forward separately by Playing Day.
- Dummy staging roll-forward testing should include a multi-playing-day case before live
  use.
- During the mitigation phase, roll-forward must explicitly test successor chains such as
  `U7 Saturday -> U8 Saturday` and `U7 Sunday -> U8 Sunday`.

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
- During the mitigation phase, team-context notifications should derive the Age Group /
  Division context from the team record and route to the managers for that scoped Age Group
  or Division.

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

- separated the near-term Age Group naming mitigation from the full Playing Day
  architecture;
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

This CR input does not request immediate full architectural implementation.

The near-term Age Group naming mitigation may be planned and tested separately from the
full Playing Day architecture. The purpose of this document is to capture both the
long-term requirement and the safer interim route clearly so the work can be triaged into
controlled slices.
