# LMSPro Planning Slice R6 - Playing Day Mitigation And Architecture Overview

Date: 2026-07-07
Module: LMSPro / SeasonPro
Related CR: `docs/modules/lmspro/01-cr-inputs/2026-07-06-lmspro-cr-playing-day-configuration-multi-day-league-architecture-input.md`
Status: Planning overview / future slice control
Priority: High, with roll-forward safety treated as critical

## Purpose

This planning slice converts the Playing Day CR into a staged delivery route.

The key product decision is to separate:

- a near-term mitigation that uses Age Group names/codes as the playing-day container,
  for example `U7 Saturday` and `U7 Sunday`;
- the later full architecture where Playing Day becomes a first-class scope in the data
  model and UI.

The mitigation is deliberately smaller and safer. It may be enough for some leagues and
creates a lower-risk path for testing multi-playing-day behaviour before the larger
architecture is attempted.

## Guiding Principle

Roll-forward safety is the centre of this slice.

The app must not allow a mitigation convention such as `U7 Saturday` and `U7 Sunday` to be
collapsed accidentally during season roll-forward.

Safe examples:

```text
U7 Saturday -> U8 Saturday
U8 Saturday -> U9 Saturday

U7 Sunday -> U8 Sunday
U8 Sunday -> U9 Sunday
```

Unsafe examples:

```text
U7 Saturday -> U8
U7 Sunday -> U8
U7 Saturday -> U8 Sunday
```

No live roll-forward should rely on this mitigation until a staging rehearsal proves that
teams, divisions, manager assignments and scoped notifications remain in the correct
playing-day-named stream.

## R6-A - Mitigation Convention And Operator Guidance

Scope:

- document the convention for multi-playing-day leagues that need an immediate route;
- define stable naming examples such as `U7 Saturday`, `U7 Sunday`, `U8 Saturday`;
- define optional short codes if needed, such as `U7-SAT`, `U7-SUN`;
- clarify that Divisions / AGGs sit below those Age Groups;
- confirm that single-playing-day leagues do not need to change.

Example structure:

```text
U7 Saturday
-> Division Red
-> Division Blue

U7 Sunday
-> Division Red
-> Division Blue
```

Acceptance direction:

- C1 operators can understand how to create separated structures without a new Playing
  Day entity;
- the convention is documented as a mitigation, not the final architecture;
- the convention explicitly supports Age Group / Division manager routing.

## R6-B - Roll-Forward Safety Harness

Scope:

- create or extend staging roll-forward checks for playing-day-named Age Groups;
- verify that successor mappings preserve the playing-day suffix or code;
- verify that Divisions / AGGs remain under the correct successor Age Group;
- verify that teams remain in the correct playing-day stream after roll-forward;
- verify that Age Group managers and Division managers remain correctly scoped;
- verify that notification routing after roll-forward still resolves from the team context
  to the correct Division or Age Group managers.

Example test:

```text
Before roll-forward:
Team A -> U7 Saturday -> Division Red -> Saturday manager
Team B -> U7 Sunday -> Division Red -> Sunday manager

After roll-forward:
Team A -> U8 Saturday -> Division Red -> Saturday manager
Team B -> U8 Sunday -> Division Red -> Sunday manager
```

Acceptance direction:

- staging produces a readable audit before and after roll-forward;
- cross-playing-day successor errors are detectable;
- live roll-forward is blocked operationally until the rehearsal is signed off.

## R6-C - Import / Export Convention Hardening

Scope:

- review import templates and importer validation for Age Group name/code usage;
- ensure imported teams can be assigned to `U7 Saturday` and `U7 Sunday` explicitly;
- reject or warn on unknown Age Group names;
- avoid guessing Playing Day from loose team-name text;
- export Age Group names/codes clearly so operators can inspect playing-day separation.

Example import rows:

```text
Club,Team,Age Group,Division
Spondon Dynamos,Spondon Dynamos U7 Saturday,U7 Saturday,Division Red
Spondon Dynamos,Spondon Dynamos U7 Sunday,U7 Sunday,Division Red
```

Acceptance direction:

- import does not silently collapse Saturday/Sunday streams;
- export gives enough context for audit and manual checking;
- single-playing-day imports remain unchanged.

## R6-D - Notifications And Communications Compatibility

Scope:

- keep notification routing based on the runtime team context;
- do not ask Notification Manager operators to choose a fixed Age Group value for a
  generic event such as Variation Request;
- when a Team Variation Request, Free Day Request or similar team-scoped notification is
  submitted, resolve:

```text
Team -> Division / AGG managers
else Team -> Age Group managers
else League Admin / Owner fallback
```

- allow communications filters to use Age Group and Division filters during the mitigation
  phase;
- defer a separate Playing Day filter until full architecture exists.

Acceptance direction:

- `U8 Saturday` managers receive `U8 Saturday` team-context notifications;
- `U8 Sunday` managers receive `U8 Sunday` team-context notifications;
- routing does not cross between Saturday and Sunday structures;
- manual notification recipient overrides continue to win when configured.

## R6-E - Full Playing Day Architecture Discovery

This is the discovery bridge from mitigation to first-class architecture.

Scope:

- map all entities that may need a `playingDayId`;
- review uniqueness rules for team names, division names and age group names;
- decide whether single-playing-day leagues use a hidden default Playing Day record;
- define mode switching rules from single to multiple Playing Days;
- define deletion/archive rules for Playing Days;
- define how historical records retain Playing Day context;
- decide whether labels must be actual weekdays or tenant-defined competition stream
  names.

Acceptance direction:

- architecture is understood before schema work starts;
- single-playing-day leagues remain simple;
- historical and child-protection-sensitive records are not orphaned or hidden
  accidentally.

## R6-F - Full Architecture Implementation Route

Possible future subslices:

1. Configuration and data model:
   introduce Playing Day mode and Playing Day records with safe defaults.
2. Age Group and Division scoping:
   attach Age Groups and Divisions / AGGs to Playing Day where multiple mode is enabled.
3. Team scoping and uniqueness:
   allow the same Club/team name pattern in separate Playing Days without leakage.
4. C1 and C2 UI:
   add tabbed Playing Day views where appropriate, hidden for single-day leagues.
5. Import/export:
   add a Playing Day column or mapping mode for multi-day leagues.
6. Roll-forward:
   preserve Playing Day and test successor chains in staging before live use.
7. Notifications and communications:
   add Playing Day-aware filters and routing once the model is first-class.
8. Migration:
   map any mitigation Age Groups such as `U7 Saturday` to real Playing Day records if a
   league chooses to adopt the full architecture.

## Current Recommendation

Do not implement the full Playing Day architecture immediately.

Recommended next step is R6-A/R6-B planning and test harness work:

- document the mitigation convention;
- create a staging sample with `U7 Saturday` and `U7 Sunday`;
- prove roll-forward safety;
- prove manager notification routing remains scoped via team context;
- only then decide whether a specific league needs the full R6-E/R6-F architecture.

## Out Of Scope For The First Mitigation Slice

- no new `PlayingDay` table;
- no new Playing Day tabs;
- no global migration of existing leagues;
- no change to Derby JFL-style single-playing-day workflows;
- no attempt to infer Playing Day from free-text team names.

## Future Handoff Prompt

```text
Proceed with LMSPro Planning Slice R6-A/R6-B on local app dev. Keep the work limited to
documenting and testing the playing-day-as-Age-Group mitigation, with roll-forward safety
as the primary acceptance gate. Do not implement a first-class Playing Day entity unless a
separate architecture slice has been approved.
```
