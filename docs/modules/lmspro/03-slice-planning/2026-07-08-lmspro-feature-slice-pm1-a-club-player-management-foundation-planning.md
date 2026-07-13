# LMSPro Feature Slice PM1-A - Club Player Management Foundation Planning

Date: 2026-07-08
Module: LMSPro / SeasonPro
Related CR: `docs/modules/lmspro/01-cr-inputs/2026-07-08-lmspro-cr-club-player-management.md`
Related triage: `docs/modules/lmspro/02-triage/2026-07-08-lmspro-triage-club-player-management.md`
Status: Planning
Priority: High planning value / controlled implementation priority

## Purpose

PM1-A defines the safe foundation for club-owned player management and Team Manager access
inside existing SeasonPro / LMSPro club tenancy.

This is a planning slice only. It should decide the data model, permission model,
safeguarding boundaries and implementation split before any Prisma models, API routes or UI
are built.

## Product Boundary

Accepted framing:

```text
Club-owned player management and Team Manager access inside existing SeasonPro club tenancy.
```

This slice must preserve these boundaries:

- not a league-wide player registration system;
- not a standalone ClubPro product build;
- not a broad club-tenancy rewrite;
- not a subscriptions/payments feature;
- not a full transfer-history UI.

ClubPro concept work remains separate:

```text
docs/modules/clubpro/00-roadmap-control/2026-07-08-clubpro-concept-development-and-product-boundary.md
```

## Core Principle

Player data is sensitive club-controlled operational data.

Because many records may relate to children or young people, the permission and audit model
must be accepted before any delegated Team Manager access or player CRUD UI is exposed.

## PM1-A Scope

### Included

- review current club, team, user, role, hat-swap and club-official models;
- define Team Manager access model, including whether magic-link access is appropriate;
- define Player ownership and Player-Team membership model options;
- define player lifecycle/status model;
- define minimum vs optional player fields;
- define permission boundaries for Club Admin, Team Manager and C1 support access;
- define export, audit, archive, anonymisation and retention expectations;
- define staged implementation slices after PM1-A;
- create a planning decision record suitable for implementation.

### Excluded

- adding Prisma models;
- creating migrations;
- creating API/services;
- creating player CRUD UI;
- creating Team Manager invitation UI;
- adding export endpoints;
- adding anonymisation workflow;
- adding Team Manager dashboard access;
- exposing player data in the C1 league dashboard;
- building standalone ClubPro tenancy.

## Existing Model Review Needed

Before implementation planning is accepted, inspect and document how the current app models:

- `LMSProClub`;
- `LMSProTeam`;
- club officials / club-user membership;
- `User`;
- tenant/organisation scoping;
- roles and role assignments;
- C1 roleplay / hat-swap access;
- team-season scoping;
- audit/event logging patterns;
- export/download patterns, if any;
- existing Team Manager contact data as team-linked CRUD data, not currently a login user.

PM1-A must distinguish the current status quo from the future access model.

Current status quo:

- Team Manager details already exist as team-linked data in the Team management CRUD flow.
- Clubs are already encouraged to keep Team Manager name, email address and contact number
  up to date.
- Current Team Manager data is operational contact data, not a login account and not a
  permission grant.
- The Club already has a UI for maintaining this manager data.

Future access discussion:

- The planning question is not whether Team Manager data should exist. It already does.
- The planning question is whether, and how, existing Team Manager contact records can
  safely become access-bearing records for the linked Team or Teams.
- If the same verified email address is listed against several Teams, the future Team
  Manager dashboard could aggregate those Team scopes for that person.
- This may require creating or linking a `User`, or it may use controlled magic-link access.
  That decision must be made explicitly.

## Team Manager Access Model

Planning decision required:

```text
Can existing Team Manager contact data be safely promoted into team-scoped access, and if
so, what verification, user-linking and audit controls are required?
```

Recommended starting position:

- Team Managers currently exist in the system as non-user contact records linked to the Team
  they manage.
- Team Manager contact maintenance should remain in the existing Team management flow unless
  a better UI is deliberately planned.
- Access should be layered on top of those existing records, not modelled as a brand-new
  unrelated manager list.
- A Team Manager with access should only see the Team or Teams attached to their verified
  email/user identity.
- A Team Manager can manage multiple Teams where league/club rules permit.
- The data model should support multiple Team links even if UI policy initially limits this.
- Access is a scoped relationship, not just a broad role flag.

## Known Transition Risk: Contact Data Versus Access Grant

There is a high-risk confusion point:

```text
Team Manager contact data is currently editable operational data. Future Team Manager
access would turn some of that data into an access pathway.
```

This transition must be designed carefully because a Club Admin changing a Team Manager
email address in ordinary Team CRUD could accidentally:

- grant access to the wrong person;
- remove access from the existing manager unexpectedly;
- merge two managers into one dashboard if a shared email is reused;
- expose multiple Teams to one email address where that was not intended;
- create ambiguity around role-based/shared email accounts;
- leave stale contact data with active access.

PM1-A must decide whether access is:

- automatically derived from current Team Manager email fields;
- explicitly enabled per Team Manager contact;
- invitation-based from the Team Manager contact record;
- magic-link only;
- full user-account based;
- or a hybrid of verified email plus user account once accepted.

Recommended safety position:

- Maintaining Team Manager contact details and granting Team Manager access should be
  visually and conceptually distinct, even if they live in the same Team management UI.
- A contact email should not silently become an active access grant without verification.
- Any access-bearing Team Manager email should be verified before the Team dashboard is
  exposed.
- Changes to an access-bearing Team Manager email should create an audit event and may need
  re-verification.
- If the same verified email is deliberately linked to multiple Teams, the Team Manager UI
  can show all linked Teams.
- The UI should make it clear when a Team Manager is "contact only" versus "access enabled".

Team Manager relationship should be able to capture:

- `organizationId`;
- `clubId`;
- `teamId`;
- `userId` or invited contact reference;
- source Team Manager contact record reference if distinct from access grant;
- invitation/status state;
- verification state;
- role/capability scope;
- created/updated audit fields;
- revoked/removed state;
- optional effective dates if needed later.

Open questions:

- Can a Team Manager exist before accepting an invitation?
- Does a Team Manager always need a full login user, or can they begin as an invited
  contact?
- Can current Team Manager contact data be used as the invitation source without granting
  access automatically?
- Does a magic-link access model satisfy audit, identity and revocation requirements?
- What happens when a Club Admin edits the email address on an access-enabled Team Manager
  contact?
- Should "same email across Teams" automatically aggregate Team access after verification,
  or require explicit confirmation?
- Can a club admin invite/remove Team Managers without C1 approval?
- Can C1 set policy limiting one manager per Team or one Team per manager?
- Is Team Manager access season-scoped, team-scoped, or both?

## Player Ownership Model

Planning decision required:

```text
Does Player belong to Club as the primary owner, with Team membership represented through
a relationship table?
```

Recommended starting position:

- Player records belong primarily to the Club.
- Player records are not league-visible by default.
- A Player can be linked to one or more Teams through Player-Team membership.
- Player-Team membership is likely season/team scoped.
- Team movement should be possible without rewriting the Player record.

Player identity model should consider:

- `organizationId`;
- `clubId`;
- stable `playerId`;
- status/lifecycle;
- minimum identifying fields;
- optional operational fields;
- anonymisation markers;
- created/updated audit fields.

Player-Team membership should consider:

- `organizationId`;
- `clubId`;
- `playerId`;
- `teamId`;
- `seasonId`;
- membership status;
- joined/assigned date;
- removed date;
- reason/status notes where appropriate;
- created/updated audit fields.

## Player Lifecycle

Required lifecycle states to plan:

- `ACTIVE`: currently available for club/team use.
- `ARCHIVED`: not currently active but may return.
- `SEASON_ROLLED_ARCHIVE`: reduced record after season rollover where legitimate
  operational retention exists.
- `ANONYMISED`: personal identifiers removed under controlled GDPR/delete process.

Planning must keep archive and anonymisation separate.

Open questions:

- Can anonymised records remain linked to historic team membership counts?
- Which fields survive season-roll archive?
- Which fields are removed during anonymisation?
- Who can archive, reactivate or anonymise a Player?
- Does anonymisation require C1 support approval, club admin authority, or both?

## Player Fields

The first implementation should permit partial records.

Potential fields from the CR:

- player name;
- address;
- email address;
- next of kin name;
- next of kin email address;
- next of kin contact number;
- gender;
- date of birth;
- actual age group;
- permitted age group or groups;
- current Team memberships;
- player status.

PM1-A must decide:

- absolute minimum required fields;
- optional fields;
- fields that should be avoided or deferred for data-minimisation reasons;
- fields visible to Club Admins;
- fields visible to Team Managers;
- fields visible only through explicit support/roleplay access;
- fields included in export by default vs optional export columns.

Recommended first position:

- keep mandatory fields minimal;
- do not require address, email or next-of-kin fields unless a specific operational need is
  accepted;
- treat date of birth and next-of-kin data as sensitive;
- avoid collecting data simply because it might be useful later.

## Permissions And Visibility

Planning decision required:

```text
Who can see and edit player data, and under what club/team scope?
```

Required permission boundaries:

- Club Admin / Secretary: full player management for own Club, subject to retained
  governance controls.
- Team Manager: only linked Team or Teams, and only the allowed subset of player fields.
- C1 League Admin: no league-wide player visibility by default.
- C1 support/roleplay: explicit, permission-controlled, audited and visually obvious.

Team Manager access should never be inferred from email address, team name, or broad C2
role alone. It should come from explicit team-scoped grants.

## Export, Audit And Governance

Export is accepted as a club dashboard requirement, but it is sensitive.

Planning decisions required:

- who can export;
- which fields are exportable;
- whether sensitive fields require an elevated export permission;
- which filters are required;
- what audit record is written;
- where export files are generated/stored, if stored at all;
- whether export files expire.

Export filters may include:

- Team;
- age group;
- player status;
- season;
- active/archive state.

Audit should capture:

- actor;
- club;
- timestamp;
- filters used;
- export type;
- whether sensitive fields were included.

## Safeguarding And Privacy

Safeguarding/privacy requirements are first-order architecture, not later polish.

PM1-A must decide how the first implementation will handle:

- minimal data collection;
- minor/child player data;
- next-of-kin data;
- role-scoped access;
- export audit;
- C1 roleplay audit;
- retention;
- anonymisation;
- no league-wide player visibility by default.

If any of these cannot be planned confidently, implementation should be split smaller.

## Suggested Implementation Split After PM1-A

The CR suggested slices are useful but advisory. PM1-A should confirm or reshape the final
implementation split.

Recommended split after PM1-A:

### PM1-B - Team Manager Access Foundation

Potential scope:

- schema/API foundation for Team Manager grants;
- invitation/access status model;
- permission guards;
- audit for assignment/removal;
- no player CRUD UI unless required for permission testing.

### PM1-C - Player And Player-Team Membership Schema Foundation

Potential scope:

- Club-owned Player model;
- Player-Team membership relationship;
- lifecycle/status enum;
- minimum and optional fields;
- tenant/club/team scoping;
- no broad UI.

### PM1-D - Club Admin Player Management UI

Potential scope:

- C2 Club Admin create/view/edit/archive/reactivate players;
- assign/remove Team memberships;
- keep Team Manager editing deferred unless PM1-B/PM1-C permissions are proven.

### PM1-E - Export, Retention And Anonymisation

Potential scope:

- permission-controlled export;
- export audit;
- anonymisation flow;
- retention/season-roll archive behaviour.

### PM1-F - Team Manager Player View / Limited Maintenance

Potential scope:

- Team Manager dashboard access;
- linked-Team-only player view;
- limited edit permissions where accepted;
- field-level restrictions.

## Risks

- over-collecting sensitive player/minor data;
- exposing one Club's player data to another Club;
- exposing player data to C1 by default;
- Team Manager grants accidentally becoming broad club access;
- export becoming a data leak path;
- anonymisation damaging legitimate audit/history unexpectedly;
- modelling Player as single-Team and blocking future movement/multiple Teams;
- letting ClubPro product discovery expand this LMSPro slice.

## Mitigations

- plan Team Manager access before player UI exposure;
- use explicit team-scoped relationships;
- keep mandatory player fields minimal;
- add same-tenant, same-club and linked-Team permission checks in every future service;
- audit roleplay, export, invitation, assignment, archive and anonymisation events;
- split implementation smaller if permission or data-governance decisions remain unclear;
- keep ClubPro in separate concept control.

## Review And Test Expectations For PM1-A

Planning review should confirm:

- the slice remains planning-only;
- the CR scope is not expanded into ClubPro;
- the Team Manager access model is coherent enough for a foundation implementation slice;
- the Player ownership and Player-Team membership model is coherent enough for a foundation
  implementation slice;
- player lifecycle states are separated clearly;
- minimum vs optional fields are explicitly identified;
- export/audit/governance requirements are accepted or split into a later slice;
- safeguarding and privacy requirements are treated as blockers, not refinements;
- the next implementation slice can be created without unresolved sensitive-data ambiguity.

## Do Not Build Yet

Do not implement until PM1-A is reviewed and accepted:

- Prisma models;
- migrations;
- service/router methods;
- Team Manager invitation UI;
- player CRUD UI;
- export endpoints;
- anonymisation workflow;
- Team Manager player dashboard;
- C1 player dashboard visibility.

## Suggested Handoff Prompt After Acceptance

```text
Proceed with LMSPro Feature Slice PM1-B on local app dev only after PM1-A planning is
accepted. Keep PM1-B limited to Team Manager access foundation: team-scoped grants,
permission guards and audit. Do not expose player CRUD or Team Manager player data until
the Player schema and safeguarding boundaries are separately accepted.
```
