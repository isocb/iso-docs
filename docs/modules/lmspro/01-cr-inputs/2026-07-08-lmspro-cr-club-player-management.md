# Key Planning Decisions: Team Manager and Player Management Enhancement

## 1. Team Manager Access Model

Team Managers should be treated as **invited, limited-access contacts/users** within the club organisation, rather than as a full new organisation or tenant tier.

They belong operationally beneath the C2 Club node and should only have access to the team or teams explicitly linked to them.

A Team Manager may manage more than one team where permitted. Some leagues may restrict this by rule, so the data model should support multiple team links while allowing league or club-level configuration to restrict this if required.

## 2. Player Ownership Model

Player records should belong primarily to the **Club**, not directly to the League or a single Team.

A player may be linked to one or more teams at the same time. Therefore, the model should use a relationship between Player and Team, rather than storing only one team directly on the player record.

This supports:

* players moving between teams;
* players being active in more than one team;
* future eligibility checks;
* future transfer or team-membership history.

## 3. Player Movement and History

SeasonPro should be designed so that player movement between teams can be tracked in future.

A full transfer-history UI is not essential in the first release, but the schema should not prevent it. The initial model should capture enough membership information to support future history, such as team assignment dates, removal dates, status, and audit fields.

## 4. Player Status Lifecycle

Player records should support a clear lifecycle:

* **Active**

  * Player is currently available for club/team use.

* **Archived**

  * Player is no longer currently active but may return.
  * The archived record may still contain personal data while it remains operationally useful.

* **Season-Rolled Archive**

  * After season rollover, archived records may be reduced to a minimal record, such as name and date of birth, where there is a legitimate operational reason to retain this.

* **Anonymised / GDPR Delete**

  * Personal identifiers are removed so that the individual can no longer reasonably be identified.
  * This is distinct from archive and should be treated as a controlled data governance process.

## 5. Player Data Fields

The model should permit partial records. Not all player fields should be mandatory.

Initial fields may include:

* player name;
* address;
* email address;
* next of kin name;
* next of kin email address;
* next of kin contact number;
* gender;
* date of birth;
* actual age group;
* permitted age group or groups;
* current team memberships;
* player status.

The first implementation should define the minimum required fields separately from optional fields.

## 6. Data Ownership and Visibility

Player records should be treated as **club-controlled operational data**.

They are not intended to become a league-facing player registration system in the first release. The feature is primarily intended to help clubs manage their own players and augment existing external systems such as FA Full-Time.

League users do not need player visibility through the league dashboard.

Where a League Admin is permitted to “roleplay” or impersonate a club user for support purposes, that access should be:

* explicit;
* permission-controlled;
* audited;
* visually obvious in the UI;
* limited to the permissions of the club role being impersonated.

## 7. Export Requirement

Export of player data is an essential club dashboard requirement.

Club admins should be able to export player data for their own club. Export should be permission-controlled and should generate an audit record showing who exported the data and when.

Export options may include filtering by:

* team;
* age group;
* player status;
* season;
* active/archive state.

A future API may be considered later, but this should not be part of the first implementation unless there is a confirmed integration requirement.

## 8. Minors and Safeguarding

The system should acknowledge that many player records may relate to children or young people.

Technical controls such as encryption, RLS, and secure authentication are important, but the planning process should also consider wider safeguarding and privacy-by-default factors.

The first release should therefore prioritise:

* minimal data collection;
* strict role-scoped access;
* careful handling of next-of-kin data;
* audit trails for exports and impersonation;
* no league-wide player visibility by default;
* clear retention and anonymisation rules.

## 9. Product and Revenue Model

The recommended initial approach is to make this capability available broadly rather than limiting it only to higher product tiers.

The commercial model should be informed by usage data rather than feature restriction alone.

SeasonPro should track:

* number of active players;
* number of player records per club;
* number of invited Team Managers;
* number of active Team Manager users;
* number of clubs using player management;
* number of exports;
* player/team/club volume by league.

This will allow SeasonPro to introduce or revise pricing later based on demonstrated value and real usage patterns.

## 10. Revised Slice Planning Direction

The enhancement should be planned as a club-value extension with staged implementation.

Recommended slice order:

### Slice A: Team Manager Access Model

* Add invited Team Manager user/contact type.
* Link Team Managers to one or more teams.
* Enforce team-scoped access.
* Add audit for invitation and access changes.
* No player management UI unless required for permission testing.

### Slice B: Player Data Model

* Add Club-owned Player entity.
* Add Player-Team membership relationship.
* Add player lifecycle statuses.
* Add minimum and optional player fields.
* Support partial records.
* Avoid full transfer-history UI in this slice.

### Slice C: Club Player Management UI

* Club admin can create, view, edit, archive, reactivate, and anonymise player records where permitted.
* Club admin can assign players to teams.
* Club admin can export player data.
* Team Manager access remains limited to linked teams.

### Slice D: Governance, Retention and Safeguarding

* Season rollover minimisation process.
* GDPR anonymisation workflow.
* Export audit.
* Impersonation audit.
* Retention rules.
* Privacy and safeguarding review.

## Initial Recommendation

Proceed with the CR, but frame it as **Club Operational Value / Player Management**, not as league player registration.

The safest first step is to plan the Team Manager access model and Player data model together, but implement them in separate slices. The role and permission model should be established before exposing player data to Team Managers.
