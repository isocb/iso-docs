# LMSPro Triage - Club Player Management And Team Manager Access

Date: 2026-07-08
Module: LMSPro / SeasonPro
Source CR: `docs/modules/lmspro/01-cr-inputs/2026-07-08-lmspro-cr-club-player-management.md`
Status: Accepted for planning; not accepted for implementation yet

## Triage Decision

Proceed to slice planning.

The CR is accepted as a club-value extension for SeasonPro / LMSPro, with a deliberately
bounded scope:

```text
Club-owned player management and Team Manager access inside existing SeasonPro club tenancy.
```

It is not accepted as:

- a league-wide player registration system;
- a standalone ClubPro product build;
- a broad rewrite of club tenancy;
- a full transfer-history system;
- a payment/subscription feature.

## Priority

Priority: High planning value, controlled implementation priority.

Reason:

- It adds practical value to C2 clubs.
- It supports a likely future ClubPro product direction without requiring ClubPro now.
- It touches sensitive personal data, potentially including minors, so it must be planned
  carefully before implementation.
- It introduces delegated Team Manager access, which must be permission-safe before player
  data is exposed.

## Category

- Feature / club operational value extension.
- Sensitive data / safeguarding.
- Permission and delegated access design.
- Future product discovery input for ClubPro, but not a ClubPro implementation.

## Main Risks

- Exposing player/minor data to the wrong club, team or league user.
- Treating Team Manager access as a simple role flag rather than a team-scoped access
  relationship.
- Confusing existing Team Manager contact CRUD data with future access-bearing login or
  magic-link grants.
- Accidentally granting access when a club admin is only updating team manager contact
  details.
- Building a league-visible registration system by accident.
- Making too many player fields mandatory and damaging usability/data capture.
- Allowing exports without clear permissions and audit.
- Treating archive, season-roll archive and GDPR anonymisation as the same action.
- Letting the standalone ClubPro concept expand this near-term LMSPro slice.

## Boundary Notes

Accepted boundaries:

- Player records are club-controlled operational data.
- A Player can belong to multiple Teams through a membership relationship.
- Team Managers are invited limited-access users/contacts under the C2 Club.
- Team Manager access must be scoped to linked Team or Teams.
- League users do not get league-wide player visibility by default.
- C1 support/roleplay access must be explicit, audited and visibly signposted.
- Export is in scope as a requirement, but should be permissioned and audited.

Deferred boundaries:

- Full transfer-history UI.
- League registration workflows.
- API integrations.
- Club subscriptions/payments.
- Standalone ClubPro tenancy.
- Broad ClubPro product composition.

## Planning Advice

The suggested slices in the CR are useful as a discovery map, but they should not be treated
as fixed implementation slices.

Recommended planning approach:

1. Plan Team Manager access and Player data model together so the permission model and
   sensitive data model are coherent.
2. Implement them separately where possible, with access/audit foundations before broad
   player UI exposure.
3. Keep the first UI slice club-admin oriented before opening Team Manager editing of
   player records.
4. Treat export, impersonation, archive and anonymisation as first-class governance
   controls, not as late polish.

## Recommended First Slice

Create a 03 planning document for:

```text
LMSPro Feature Slice PM1-A - Club Player Management Foundation Planning
```

Suggested PM1-A planning scope:

- current club/team/user/role data model review;
- Team Manager invited-user/access relationship options;
- Player and Player-Team membership schema options;
- player lifecycle/status model;
- minimum vs optional fields;
- permission and audit boundaries;
- export/anonymisation/retention decisions;
- no implementation until the foundation plan is accepted.

## Do Not Build Yet

Do not implement until the first 03 slice plan is accepted:

- new Prisma models;
- Team Manager invitation UI;
- player CRUD UI;
- export endpoints;
- anonymisation workflow;
- Team Manager dashboard access;
- league dashboard player visibility.

## Next Action

Create the PM1-A planning slice in `03-slice-planning/`.
