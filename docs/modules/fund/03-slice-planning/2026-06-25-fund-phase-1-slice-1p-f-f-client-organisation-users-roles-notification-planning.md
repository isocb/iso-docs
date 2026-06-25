# FUND Phase 1 Slice 1P-F-F - Client Organisation Details, Users, Roles And Notification Planning

Date: 2026-06-25

Status: Future planning note - do not implement yet

## 1. Purpose

Clarify the future FUND Client organisation and user/member model before Client users, roles, invitations, notification boundaries, C2 dashboard expansion or Project Intake approval workflows are implemented.

This note does not change the current 1P-F-E C1 Client Management UI scope.

## 2. Core Model Clarification

Recommended conceptual model:

```text
FundClient = organisation/account
FundClientUser / ClientMember = person linked to Client
User = authenticated platform identity
Client role = role label or access role within the Client/account
```

`FundClient` should be treated as the C2 organisation/account record, similar in concept to a SeasonPro Club.

Examples:

- school;
- club;
- PTA;
- charity branch;
- fundraising organisation;
- customer account.

## 3. Organisation-Level Client Details

Future Client organisation/account details may include:

- organisation/client name;
- trading or public display name where needed;
- address;
- main contact number;
- main email address;
- client type;
- status;
- C1 internal notes;
- external reference codes;
- SeasonPro Club mapping reference where applicable;
- communication preferences only after notification planning is accepted.

Current `FundClient.primaryContactName`, `primaryContactEmail` and `primaryContactPhone` remain operational snapshots only.

## 4. Client User / Member Relationship

A Client user/member is a person linked to a Client organisation/account.

Future Client user/member records may need to capture:

- Client id;
- platform User id when authenticated/invited;
- name;
- email;
- phone;
- role label;
- status;
- invitation state;
- access permission level;
- notification consent/preferences after communications planning;
- audit metadata.

Open design question:

```text
Should Client user/member be FUND-specific first, reusable IsoStack core, or mapped to an existing organisation/user membership pattern?
```

## 5. Primary User / Member Concept

Future design may need a primary contact/member concept for a Client.

Possible options:

1. Keep primary contact snapshots on `FundClient` only.
2. Add a primary Client member relation later.
3. Support both: snapshot fields for operational C1 display plus an optional primary member relation for account/user workflows.

Recommendation for now:

```text
Keep current primary contact snapshots.
Do not infer user membership from them.
Plan primary member relation only when Client users are designed.
```

## 6. Role Label Options

Client user/member role labels may include:

- Treasurer;
- Secretary;
- Club Secretary;
- PTA Chair;
- Headteacher;
- Project Lead;
- Finance Contact;
- General Contact.

These labels may be operational/contact labels, not necessarily access permissions.

## 7. Role Label Vs Access Permission

Distinguish:

```text
Role label = human/organisation role, such as Treasurer or Headteacher.
Access permission = what the authenticated user may do in IsoStack/FUND.
```

Example:

- A Treasurer may be a finance contact but have read-only dashboard access.
- A Project Lead may manage Projects but not billing.
- A General Contact may receive communications but have no dashboard login.

Do not collapse role labels and access permissions into one enum without a planning decision.

## 8. Invitation And Notification Boundary

No automatic notification should be sent when:

- a Client is created;
- a primary contact email is entered;
- a Client user/member record is drafted;
- a Project Intake submission is received;
- a Project is approved.

Invitation and notification sending must be explicitly planned.

Future notification design should follow the SeasonPro-style controlled communications pattern:

- explicit templates;
- explicit C1 send/queue rules;
- audit trail;
- no accidental side effects;
- separation between invitation state and notification consent.

## 9. SeasonPro Club/User Precedent

SeasonPro pattern:

```text
SeasonPro Club = C2 organisation/account
Club users = people linked to Club
```

FUND parallel:

```text
FUND Client = C2 organisation/account
Client users/members = people linked to Client
```

Integrated SeasonPro + FUND:

```text
SeasonPro Club may map to FUND Client.
Club users may later be linked or invited as FUND Client users/members.
```

Do not implement this mapping until explicitly planned.

## 10. Effect On Project Intake

Project Intake approval may eventually create or link:

- Client organisation/account;
- Client user/member;
- platform User identity where appropriate;
- Project;
- Event linkage.

Unknown respondents should become Client users/members only after C1 moderation/approval.

Existing respondents should be linked to the correct Client/account only after same-tenant and identity checks.

## 11. Effect On C2 Dashboard

The future C2 dashboard should be Client/account scoped, not merely participant scoped.

Future Client users/members may define:

- which Client dashboard a person can access;
- whether they can see all Projects for that Client;
- whether they can create/request Projects;
- whether they can approve artwork/data;
- whether they can see Orders/Sales/Reporting later.

These permissions are not part of 1P-F-E.

## 12. Out Of Scope

Do not implement in this planning note:

- Client user/member schema;
- Client roles schema;
- invitation schema;
- notification preferences schema;
- Client dashboard mutations;
- Project Intake implementation;
- SeasonPro Club mapping;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- Communications;
- key-date automation.

## 13. Recommended Future Split

Recommended future sequence:

1. Project Client linkage.
2. Project Intake schema/moderation planning.
3. Client user/member model planning.
4. Invitation/notification boundary planning.
5. C2 Client dashboard expansion planning.

## 14. Recommended Future Prompt

```text
Proceed with FUND Phase 1 Slice 1P-F-F-A planning only: Client user/member model.

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-f-client-organisation-users-roles-notification-planning.md
- current Client, Project Client linkage and Project Intake planning documents

Planning only.

Do not implement application code.
Do not edit Prisma schema.
Do not create migrations.
Do not send notifications.
Do not create invitations.

Plan how Client users/members relate to FUND Clients, platform Users, role labels, access permissions and future notification boundaries.
```
