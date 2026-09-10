# CR-Fix — FUND Event Catalogue Workflow Scope And Lifecycle Integrity

Date: 2026-09-10

Status: **Implemented locally as B1-R2 at `29104b55`; automated/connected proof PASS; human acceptance pending.**

Owning lane: FUND. Source: B1-R1 local human smoke and owner clarification.
Control depth: **High** — workflow eligibility, tenant-scoped availability, Event lifecycle
authority, schema migration and downstream Store/offer safety are affected.

## 1. Human Finding

The B1-R1 human walkthrough proved that the corrected Product model is simpler, but exposed
three related gaps in the Catalogue and Event control surface:

1. `Event only`, `Standalone only`, `Both` and `Internal` describe a Catalogue's channel
   availability. They do not say which of the four Project workflows the Catalogue supports.
   Consequently every active standalone-capable Catalogue is currently offered to every
   standalone workflow.
2. Event-to-Catalogue assignment is available only from Product/Catalogue management. C1 has
   to leave the Event while planning it, despite the Event being the authority for its workflow
   and Catalogue assignment.
3. The Event service permits direct `DRAFT -> ARCHIVED` and `ACTIVE -> ARCHIVED` transitions,
   and permits an active Event to close while it has active linked Projects. Chris confirms
   that all three paths are invalid.

The Catalogue Product editor also labels active membership as `Status`, so a draft Product can
appear to be active. Draft Products may be placed in a Catalogue for preparation, but they are
not eligible for Project selection until C1 activates the Product. The UI must show those two
states separately and explain the consequence.

## 2. Confirmed Business Requirement

- A Product remains workflow-neutral and is maintained once.
- A Catalogue declares one or more supported workflows from Individual Artwork, Group Artwork,
  Logo/Bulk Personalisation and Standard. Existing/new general Catalogues initially support all
  four so C1 removes a workflow only when the range is unsuitable.
- Channel availability and workflow scope are independent. Channel scope answers whether a
  Catalogue can supply Events, standalone Projects, both or neither; workflow scope answers
  which Project workflows it can supply in those channels.
- An Event owns one workflow. Its Products tab offers only active, current Catalogues which are
  Event-capable and support that workflow. C1 selects the Event's Catalogue assignments there.
- A standalone Project owns one workflow. Its source set is the union of active, current,
  standalone-capable Catalogues that support that workflow. There is still no additional
  per-Project Catalogue assignment gate.
- Event-side assignment changes the existing Event-to-Catalogue availability records only. It
  does not edit Catalogue definition, channel/workflow scope or Product membership.
- The existing Product/Catalogue Availability surface remains available for C1 users working
  from the Product/Catalogue context.
- An Event can be archived only after it is closed. An active Event cannot close while any
  linked Project is active. These are server rules; hiding a button is insufficient.
- Product status and Catalogue-membership status are displayed separately. A draft Product can
  be curated into a Catalogue, with a clear warning that it contributes no Project eligibility
  until Product activation.
- Current selections, finalised offers and Order evidence retain the protection established by
  B1-R1 when Catalogue scope or assignment changes.

```text
Product membership
  -> Catalogue channel + workflow scope
  -> Event assignment, or standalone workflow match
  -> C2 Product subset

Event lifecycle
  DRAFT -> ACTIVE -> CLOSED -> ARCHIVED
  ACTIVE -> CLOSED only when no linked Project is ACTIVE
```

## 3. Observed Source Mismatch

Application candidate: `51618485` on `work/fund-b1-r1-catalogue-workflow`.

- `FundCatalogue` has `availabilityScope` but no workflow-scope field.
- standalone eligibility selects all active Catalogues with a standalone-capable channel scope;
  it does not use `FundProject.projectType` to narrow the Catalogue set.
- Event Catalogue assignment validates channel scope but not Event workflow compatibility.
- `AvailabilityManager` provides the only assignment UI and requires choosing the Event from a
  Product/Catalogue page.
- Event detail has Overview and Linked Projects only. The earlier `2R-EVENT-05` wishlist already
  anticipated Event-side Catalogue/Product visibility.
- `events.service.ts` explicitly allows draft and active Events to archive, and status mutation
  does not inspect active linked Projects.
- `CatalogueProductsManager` includes draft Products in its add selector and shows membership
  activity under the ambiguous heading `Status`; the Product's own status is not displayed.

The channel field is not inert: current services use it to filter Event-assignable and
standalone source Catalogues. The defect is that its narrower meaning is not clear and there is
no separate workflow dimension.

## 4. Acceptance Criteria

1. C1 can select several workflows for a Catalogue, with all four initially selected for an
   existing or newly created general Catalogue.
2. A standalone Project receives Products only from Catalogues that are both standalone-capable
   and compatible with its workflow.
3. An Event Products tab lists only compatible Event-capable Catalogues, saves existing
   Event-Catalogue assignments and shows the Products each selected Catalogue contributes.
4. The Product/Catalogue Availability screen continues to manage the same assignments and can
   reflect changes made from Event detail.
5. Event detail cannot change Catalogue definition, Product membership or Project Product
   selection.
6. Catalogue and workflow contraction uses the B1-R1 availability lock and produces the same
   unavailable-selection/finalisation/trading protection as last-source withdrawal.
7. Archive refuses unless Event status is `CLOSED`; close refuses while at least one linked
   Project is `ACTIVE`; refusal is enforced and clearly explained by the server and UI.
8. A concurrent Project activation/link and Event close cannot commit an invalid active-Project/
   closed-Event state.
9. Catalogue Product UI distinguishes Product `DRAFT/ACTIVE/ARCHIVED` from membership
   `Active/Inactive` and explains that draft Products are preparation-only.
10. Same-tenant, cross-tenant, stale-write, migration, immutable-offer and Order boundaries pass
    the High-control review schedule before promotion.

## 5. Lifecycle Position

This is a confirmed model and lifecycle defect, not a live incident; Chris confirms FUND still
has no users requiring remedial conversion. It blocks B1 business acceptance because the current
smoke cannot prove correctly scoped standalone availability or safe Event management.

Required route: **CR -> triage -> roadmap selection -> bounded planning -> implementation ->
04 confirmation -> 05 independent review/test -> resumed human acceptance -> controlled
promotion**. Registration and planning do not themselves authorise code, migration, database
work or promotion. The B1 controlling plan retains the only restart checkpoint.

## 6. Related Records

- [B1-R1 human findings](../05-review-and-test/2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-review-and-test.md)
- [B1-R1 plan](../03-slice-planning/2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-planning.md)
- [B1-R2 triage](../02-triage/2026-09-10-fund-b1-r2-event-catalogue-workflow-scope-and-lifecycle-integrity-triage.md)
- [B1-R2 plan](../03-slice-planning/2026-09-10-fund-b1-r2-event-catalogue-workflow-scope-and-lifecycle-integrity-planning.md)
- [FUND roadmap](../00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md)
