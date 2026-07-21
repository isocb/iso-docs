# FUND Default Project Store And Eligible Product Presumption Input

Date: 2026-07-21

Status: Governed business clarification; implementation not yet authorised

## 1. Reason For This Input

Post-promotion review of FUND `1R-E-B` and `1R-E-C` found that their human Store smoke
schedule cannot start from the real empty FUND state:

- C1 Store oversight lists only persisted Stores and intentionally creates none;
- the canonical C1/internal and Project Intake creation paths create a Project and delivery
  profile but no Store;
- the only current Store-instantiation UI requires an already-authorised C2
  `PROJECT_MANAGER` or `ADMIN` to discover the Project Store tab and select `Prepare Store`;
  and
- no live FUND data exists from which a representative Store can already be selected.

The technical E-A/B/C authority split remains correct. The missing contract is the default
Project-to-Store initiation workflow.

## 2. Business Rule

A FUND Project exists in order to operate a Project Store. The Store is therefore mandatory,
not an optional capability that an organiser or C1 operator must remember to add.

Every canonical Project creation/provisioning transaction must create:

1. the Project;
2. its delivery profile;
3. exactly one tenant- and Project-owned `DRAFT` Store; and
4. the default active Project Product and Store Product set derived from every Product the
   canonical eligibility service permits for the Project's type, effective organisation type,
   Event/standalone context, Catalogue availability and suitability rules.

The Store title defaults from the Project name. Creation does not publish the Store, accept
commission terms, bypass readiness or activate public checkout.

## 3. Default Product Presumption

The normal Product selection is:

```text
all currently eligible Products
minus explicit C2 deselections
```

The Project organiser is presumed to have limited time and capacity. No organiser action is
required to obtain the normal Product range. `PROJECT_MANAGER` or `ADMIN` may deselect or
restore Products in the minority of Projects that require a narrower offer. `VIEWER` remains
read-only.

The current durable `FundProjectProduct.isActive = false` membership is suitable evidence of
an explicit deselection:

- eligible Product with no Project membership: add active by default;
- active membership: retain and refresh through existing source authority;
- inactive membership: preserve as an explicit C2 exclusion and never reactivate silently;
- newly eligible Product with no prior membership: add on the next controlled reconciliation;
- active Product that becomes ineligible: prevent Store offering through the existing
  eligibility/readiness gate without erasing its history; and
- re-eligible active Product: permit it again through normal reconciliation.

Browser input never supplies the eligible Product universe, price, tax, media, snapshot,
readiness or configuration authority.

## 4. Default Store Lifecycle

The default operational sequence is:

```text
Project created
-> Store DRAFT with the complete default eligible Product set
-> C2 commission acceptance and Project activation/readiness gates complete
-> Store has default publication intent and is SCHEDULED before Project.opensAt
-> at Project.opensAt, Store is effectively OPEN only if every gate still passes
-> at Project.closesAt, Store is effectively closed by the Project window
```

Project activation may record the existing Store `PUBLISHED` intent, but this is not proof of
trading. Effective state remains server-derived. No timer job needs to mutate a row at the
opening instant.

A separate routine C2 `Publish Store` action must not be required for the default path. C2 may
still voluntarily pause/resume. C1 retains audited exceptional pause/release and
closure/reopen. Date, payment, commission, artwork/release and other accepted readiness gates
remain fail-closed.

## 5. Creation Paths In Scope

The invariant must cover all retained canonical paths:

- C1/internal dashboard Project creation;
- automated aligned Project Intake provisioning;
- C1-reviewed exception/correction provisioning; and
- any retained aligned approval path that is still permitted to create a Project.

Project, delivery, default Products and Store creation are one atomic outcome. Failure at any
stage rolls the transaction back. Idempotent retry and concurrent requests must return the one
existing Project/Store outcome and never create duplicates.

## 6. Existing FUND Data

FUND is not live and current FUND records are disposable test data. Existing Projects may be
reconciled through an explicit, idempotent, audited development/staging operation after a
preflight identifies missing Stores. A schema migration must not infer Product selection or
silently create operational rows.

## 7. Authority Preserved

- C1 owns Product/Catalogue commercial authority, supplier readiness, tenant-wide oversight
  and exceptional intervention.
- C2 owns normal Project/Store copy, Product deselection/restoration and voluntary
  pause/resume within server gates.
- C1 receives no routine Store-create or publish button.
- Store creation alone creates no public route, Order, Payment, upload, production,
  fulfilment or commission calculation behaviour.

## 8. Delivery Control

Create and review one bounded corrective slice:

`1R-E-D - Default Project Store Instantiation And Eligible Product Reconciliation`

Until E-D is implemented and promoted, E-B/E-C automated evidence remains passed but their
human UI acceptance is blocked by the missing real workflow. E-D precedes `1R-F-A`.
