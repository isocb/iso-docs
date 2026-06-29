# FUND Phase 1 Slice 1P-J - SeasonPro Club To FUND Project Initiation Planning

Date: 2026-06-29

Status: Future planning placeholder

## 1. Slice Goal

Plan the future pathway where a SeasonPro Club can initiate a FUND fundraising Project from within the SeasonPro Club interface.

This note protects the product direction only. It does not implement SeasonPro integration, Store, Orders, Commerce, Client users, public forms, notifications or Project creation automation.

## 2. Product Context

SeasonPro Clubs are C2 client organisations in the SeasonPro domain.

In an integrated SeasonPro + FUND flow, a Club may also become, map to or create/link to a FUND Client/account.

The future flow should support:

```text
SeasonPro Club dashboard
-> Start fundraising Project
-> choose available fundraising catalogue / product options
-> choose sale method
-> submit Project request / create Project according to configured policy
```

Until trusted direct Project creation is explicitly planned, the flow should create or route through a moderated Project Intake submission.

## 3. League Module Entitlement

SeasonPro Club-originated FUND initiation depends on the SeasonPro League tenant having the FUND / Fundraising module enabled through subscription.

Without module entitlement, the League and Club interfaces should not expose fundraising setup or Project initiation.

## 4. League Configuration Of FUND Producer Tenants

The SeasonPro League tenant may later configure which approved FUND producer tenant(s) can provide fundraising products to its Clubs.

Example:

```text
SeasonPro League
-> approved FUND producer tenant: AMOW
-> available fundraising catalogues/products
-> Clubs may initiate requests from approved availability only
```

This is a future integration/configuration lane. Do not expose supplier-management records or producer internals to Clubs unless explicitly planned.

## 5. Catalogue Availability To Clubs

Clubs should see fundraising products available through the League/SeasonPro context.

The Club-facing surface should not reveal:

- supplier administration records;
- producer tenant internals;
- C1 catalogue management controls;
- wholesale/internal product setup unless intentionally exposed.

Future catalogue availability planning must decide:

- which FUND catalogues a League can make available;
- whether availability is League-wide, Club-specific or campaign-specific;
- whether Event constraints apply;
- whether Product/Catalogue suitability rules are required before Store/Commerce.

## 6. Club To FUND Client/Account Mapping

The SeasonPro Club should map to, create or link to a FUND Client/account.

The resulting FUND Project must use explicit Client linkage:

```text
FundProject.clientId
```

Do not infer Client ownership from:

- organiser snapshot fields;
- respondent email;
- contact name;
- SeasonPro display labels without an explicit mapping.

## 7. Project Intake Source

Future SeasonPro Club-originated requests should use:

```text
FundProjectIntakeSubmissionSource.SEASONPRO_CLUB
```

The intake submission should capture enough source context to support moderation, audit and later mapping.

Potential source context:

- SeasonPro League id/reference;
- SeasonPro Club id/reference;
- selected producer tenant reference;
- selected catalogue/product option references;
- selected sale method;
- requesting user/contact snapshot;
- originating URL/context.

Exact fields remain for the Project Intake schema implementation and later SeasonPro integration planning.

## 8. Sale Method Options

Possible sale methods to preserve for later planning:

- direct purchase, for example parent/customer pays through a public Store;
- club-funded purchase, for example the Club is invoiced;
- bulk purchase via Store or campaign order workflow.

These options depend on Store, Orders, Commerce, invoicing and fulfilment planning. They must not be implemented inside the Project Intake schema slice.

## 9. Moderation Rule

Until trusted direct creation is explicitly accepted, SeasonPro Club-originated initiation should create or route through a moderated Project Intake submission.

Moderation may later:

- link or create the FUND Client/account;
- link or create the Project;
- link the Project to an Event where appropriate;
- preserve standalone Project creation where policy allows;
- record selected catalogue/product/sale-method intent for future action.

## 10. Notification And Communication Boundary

Do not send notifications, invitations, dashboard messages or announcements from this planning slice.

Future communications should follow a controlled SeasonPro-style communications pattern, with clear boundaries between:

- intake submission acknowledgement;
- C1 moderation requests for more information;
- dashboard-visible announcements;
- 1:1 Client/Club communication;
- order/sale/fulfilment notifications.

## 11. Dependencies

This future lane depends on separate planning for:

- SeasonPro module entitlement/subscription;
- League-to-FUND producer tenant availability;
- catalogue/product availability to Clubs;
- Client/account mapping;
- Project Intake schema/services/UI;
- Store, Orders and Commerce;
- sale method workflows;
- notification and communication policy;
- C1 moderation UI.

## 12. Explicit Non-Goals

Do not implement:

- SeasonPro integration;
- League configuration UI;
- producer tenant sharing controls;
- catalogue availability controls;
- Store;
- Orders;
- Commerce;
- public forms;
- Project creation automation;
- notification sending;
- Client users;
- C2 dashboard expansion.

Do not edit Prisma schema or create migrations from this placeholder.

## 13. Recommended Future Split

Recommended later slices:

1. SeasonPro/FUND entitlement and producer availability planning.
2. SeasonPro Club to FUND Client/account mapping planning.
3. Club-originated Project Intake source fields and moderation behaviour.
4. Sale method and Store/Commerce dependency planning.
5. Authenticated SeasonPro Club UI implementation only after the above is accepted.
