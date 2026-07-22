# FUND Refinement Wishlist And Slice Control

Original document: 2026-06-30
Reconciled: 2026-07-20

Current dependency note: 2026-07-21 - corrective `1R-E-D` completed and aligned on
application `dev`/`origin/dev` at `174dc8ac`; staging human acceptance remains pending;
`1R-F-A` is the single next planning candidate

Status: Active subordinate register of genuinely absent refinements; no next-slice authority

Parent controls:

- `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`
- `docs/modules/fund/00-roadmap-control/2026-07-15-fund-store-artwork-orders-and-production-strategic-completion-roadmap.md`

## 1. Purpose

This register contains only desirable FUND refinements that are not already substantially
built, resolved by an accepted decision, or allocated to a current authoritative roadmap
stage or planning lane.

It supersedes the historical 2026-06-30 Phase 2 Wishlist. It is not a third roadmap: the
authoritative FUND roadmap remains the only FUND next-slice selector, and the strategic
completion roadmap remains the capability-level critical path.

It is planning/documentation only. An entry does not authorise implementation. Promotion
still requires a bounded planning slice, implementation confirmation, review/test and the
normal roadmap reconciliation.

## 2. Reconciliation Summary

The original Wishlist contained 34 entries.

| Outcome | Entries | Share of original |
| --- | ---: | ---: |
| Substantially built or resolved | 5 | 15% |
| Incorporated into a current roadmap stage or named planning lane | 13 | 38% |
| Duplicate consolidated into another entry | 1 | 3% |
| Genuinely absent and retained below | 15 | 44% |
| **Total** | **34** | **100%** |

Therefore, **19 of the original 34 entries (56%) no longer belong on an absent-work
Wishlist**. Some of those capabilities still require implementation, but they are now
controlled by the main FUND roadmap rather than this refinement register.

## 3. Removed Or Reclassified Entries

| Original ID | Reconciliation | Current home or outcome |
| --- | --- | --- |
| `2R-INTAKE-01` | Partly built and incorporated | Event media foundation exists in `1R-C2`; public Event/Project branding belongs to Store presentation and related roadmap work. |
| `2R-INTAKE-02` | Duplicate | Consolidated into retained `2R-CLIENT-01`. |
| `2R-EVENT-02` | Partly built and incorporated | Duplicates the Event-media concern in `2R-INTAKE-01`; foundation exists in `1R-C2`, with public use carried by the roadmap. |
| `2R-EVENT-03` | Substantially built | Event-scoped intake constraints and the Project/Event/Store date-envelope rules are implemented through intake remediation and `1R-E`. |
| `2R-EVENT-04` | Incorporated and narrowed | Event/Project date-window authority and commission-policy foundations are in the roadmap. The genuinely absent scheduled-email portion is retained under `2R-COMMS-03`. |
| `2R-EVENT-05` | Built | Event-to-Catalogue availability schema, services and C1 UI were implemented through `1Q-B`, `1Q-C` and `1Q-D`. |
| `2R-CLIENT-02` | Built | Client branding/delivery foundation and atomic Project delivery profiles were implemented through `1R-C2` and `1P-G-R3-D`. |
| `2R-CLIENT-03` | Substantially built | Client member, organiser and C2 dashboard foundations were delivered through `1P-K1`, `1P-K2` and later Store authority work. Notification concerns remain separate. |
| `2R-PRODUCT-02` | Partly built and incorporated | Product input/configuration foundations exist; remaining purchaser options, dependencies and uploads are part of Store presentation and secure asset-intake stages. |
| `2R-CATALOGUE-02` | Incorporated | Store readiness is now controlled by `1R-F` Project Offer And Artwork Readiness and the public Store stage. |
| `2R-CATALOGUE-04` | Resolved decision | Product owns first-pass commercial terms; contextual price differences use independent Product copies rather than Catalogue overrides. |
| `2R-PROD-01` | Incorporated | Production authorisation, batching and operational visibility are explicit strategic completion stages. |
| `2R-PROD-02` | Incorporated | Artwork intake, checking, matching and production authorisation are explicit strategic completion stages. |
| `2R-PROD-03` | Partly built and incorporated | Delivery-profile foundations exist; production batching and dispatch are explicit roadmap stages. |
| `2R-PROD-04` | Partly built and incorporated | Commission policy/assignment foundation exists in `1R-C5`; calculation, statements and settlement are explicit roadmap work. |
| `2R-PROD-05` | Partly built and incorporated | Event/Project commission policy evidence exists in `1R-C5`; aggregate ladder calculation and statements are carried by the commission stage. |
| `2R-COMMS-01` | Incorporated | FUND notification triggers, editable defaults, recipients and pause/resume controls already have the named `1P-N0` planning lane. |
| `2R-SEASONPRO-01` | Incorporated | SeasonPro Club-to-FUND initiation is preserved by the named `1P-J` planning lane. |
| `2R-SEASONPRO-02` | Incorporated | League entitlement, approved producer, Catalogue availability and Club-to-Client mapping are recorded dependencies of `1P-J`. |

## 4. Active Wishlist - Genuinely Absent Refinements

### 4.1 Public Intake And Event Configuration

| Refinement ID | Name | Genuinely absent outcome | Priority |
| --- | --- | --- | --- |
| `2R-INTAKE-03` | Public Form Embed Route And CSP | A dedicated embed-safe intake route or controlled embedding policy for Squarespace, Wix, WordPress and similar sites, without weakening app/admin security. | Medium |
| `2R-INTAKE-04` | Public Form Confirmation Experience Polish | Clearer pending, confirmed and expired states, improved help text and safe retry/recovery affordances around the existing confirmation flow. | Medium |
| `2R-EVENT-01` | Configurable Event Type Option Set | A C1-managed Event type/category option set replacing or supplementing free-text classification while preserving stable stored meaning. | Low |

### 4.2 Client Configuration

| Refinement ID | Name | Genuinely absent outcome | Priority |
| --- | --- | --- | --- |
| `2R-CLIENT-01` | Configurable Client Organisation Types | Tenant-configurable or centrally governed Client organisation-type options, including migration and historical-value policy. The current bounded choices are functional but not configurable. | Low |

### 4.3 Products, Catalogues And Terminology

| Refinement ID | Name | Genuinely absent outcome | Priority |
| --- | --- | --- | --- |
| `2R-PRODUCT-01` | Advanced Product Gallery And Option-Media Mapping | Rich multi-image Product galleries and explicit mapping between option values and displayed Product media. Core media/input foundations and Store requirements remain controlled elsewhere. | Medium |
| `2R-PRODUCT-03` | Product Duplication Service And UI | Safe C1 duplication of a complete Product, including copy, commercial configuration, media references, options, workflow defaults, unique identifiers and idempotency. Copy-provenance foundations alone do not deliver this outcome. | Medium |
| `2R-PRODUCT-04` | Reusable Product Type / Option Templates | Tenant-configurable templates such as Clothing, Printed Mug or Artwork Upload Product that preconfigure repeatable option groups and validation without introducing stock inventory. | Low |
| `2R-CATALOGUE-01` | Catalogue Presentation And Merchandising | Optional Catalogue-level presentation, ordering and merchandising controls beyond the implemented availability and membership model. | Low |
| `2R-CATALOGUE-03` | Catalogue Duplication And Deep-Copy Policy | C1 duplication in reference mode and deep-copy mode, with safe Product naming, slugs, references, media handling, idempotency and audit behaviour. | Low |
| `2R-PROJECT-01` | Tenant-Defined Project And Suitability Labels | Tenant-owned display labels for stable Project type and Product suitability codes without changing eligibility behaviour or historical records. | Low |

### 4.4 Dashboard Refinements

| Refinement ID | Name | Genuinely absent outcome | Priority |
| --- | --- | --- | --- |
| `2R-DASH-01` | C1 Action Widget Standardisation | A consistent action-required card pattern with counts, restrained active-state treatment and row click-through across operational workflows. | Low |
| `2R-DASH-02` | C1 Dashboard Workflow Grouping | Grouping and prioritisation of dashboard cards by operational area once all core FUND workflows are present. | Low |

### 4.5 Communications Beyond The Core Roadmap

| Refinement ID | Name | Genuinely absent outcome | Priority |
| --- | --- | --- | --- |
| `2R-COMMS-02` | Client Dashboard Announcements | C1-to-Client announcements, campaign prompts, special offers and controlled one-to-one dashboard messages. | Medium |
| `2R-COMMS-03` | Event And Project Campaign Editor And Email Sequences | A general C1 campaign editor for the primary sales-promotion workflow: configurable multi-step communications and timely Project-owner nudges using named Event/Project anchors and positive or negative offsets for Store, artwork, production and dispatch milestones. | Medium |
| `2R-COMMS-04` | Email Content Editor UX Alignment | A comfortable rich-text editing, placeholder, preview and review experience aligned with the shared SeasonPro/LMSPro email editor pattern. | Low |

## 5. Pilot Scope And Roadmap Placement Reconciliation

The foundations are sufficiently mature to place the retained refinements without turning
the Wishlist into one large new development phase. Each promoted item must enter the
existing delivery chain as one of:

1. a proven prerequisite to an existing stage;
2. a bounded child slice owned by an existing stage or named planning lane; or
3. an explicitly parked post-pilot refinement.

This reconciliation does not authorise any implementation and does not replace the single
next candidate in the authoritative roadmap. Corrective `1R-E-D` is implemented/reviewed
locally and `1R-F-A` is now the single next planning candidate; this refinement register
must be applied before accepting work beyond `1R-F-A`, so template and public Store contracts
do not harden around avoidable pilot gaps.

### 5.1 Timing Classification

| Timing class | Retained items and exact boundary |
| --- | --- |
| Required before pilot intake | `2R-INTAKE-04` confirmation experience polish and the essential organiser notifications needed to operate confirmed Intake safely. |
| Conditional before pilot intake | `2R-INTAKE-03` only if AMOW confirms embedded Intake; `2R-EVENT-01` and `2R-CLIENT-01` only if a pilot option-fit assessment proves the current bounded values unsuitable. |
| Required before public Store pilot | The purchaser-visible part of `2R-PRODUCT-01`: option-to-media authority and Product configuration needed for correct purchaser choice and immutable Order evidence. Rich gallery merchandising is not automatically included. |
| Operational accelerator before UAT | `2R-PRODUCT-03` only where repeated AMOW Product setup would otherwise be materially slow or error-prone. Duplication improves safe setup efficiency; Store correctness must not depend on it. |
| Required before live pilot communications | A bounded set of transactional and pilot-lifecycle FUND messages using existing IsoStack delivery and sequence infrastructure. This includes Order receipts, confirmation and necessary organiser notifications, but not the general campaign editor. |
| Required before wider rollout | `2R-COMMS-03` general Event/Project campaign editor and promotional nudge sequences, `2R-COMMS-04` editor experience, `2R-COMMS-02` announcements, richer `2R-CATALOGUE-01` merchandising, `2R-CATALOGUE-03` duplication and `2R-PRODUCT-04` reusable Product/option templates. |
| Schedule from pilot evidence | `2R-PROJECT-01`, `2R-DASH-01` and `2R-DASH-02`, plus any rich gallery presentation from `2R-PRODUCT-01` not required by the pilot Product set. |

Catalogue deep-copy must reuse a proven Product-duplication primitive rather than create a
second Product-copy contract. Public Store planning presents released Store Products, not
raw Catalogue membership, so richer Catalogue merchandising is not itself a Store
correctness prerequisite.

### 5.2 Communications Boundary And Reuse Rule

FUND communications are divided into three controlled classes:

1. **Transactional communications** follow a confirmed user or operational action, such
   as Intake confirmation, Order receipt and indispensable organiser notification. These
   are pilot-critical where the owning workflow requires them.
2. **Pilot lifecycle notifications** are a bounded, predetermined set of reminders needed
   to operate the pilot reliably. They do not require a general campaign-authoring UI.
3. **Promotional campaigns** are configurable Event/Project sequences and timely nudges
   used to help Project owners finish setup, promote their Store and improve sales. The
   general campaign editor is a required pre-wider-rollout capability.

Planning must first assess and reuse the existing LMSPro sequence engine, Resend delivery,
scheduling/retry processing, rendering and substitution, tenant sender configuration,
audit/failure visibility and any applicable suppression/consent controls. FUND should add
bounded domain events, recipient authority, templates and management surfaces; it must not
build a parallel delivery or sequence engine.

Potential FUND trigger families include Intake confirmation, Project provision, organiser
action required, incomplete Store setup, Store readiness/publication, Project opening or
closing, Order receipt and promotional sales-progress nudges. The exact inventory belongs
to the later bounded communications planning lifecycle.

### 5.3 Pilot Decision Gate

Before an item is promoted as “required before pilot”, the controlling planning record must
define:

- the pilot tenant, Client, Event and Project scenarios;
- hosted versus embedded Intake;
- the actual Product, option and media requirements;
- mandatory transactional, lifecycle and promotional messages;
- participating C1, C2 and public roles;
- environment, data-reset/retention and human-testing policy; and
- measurable pilot entry and exit criteria.

This prevents conditional or presentational refinements from expanding the pilot critical
path without evidence.

## 6. Priority Interpretation

- **Medium** means the refinement could materially improve onboarding, repeat
  administration, sales promotion or customer confidence. Its timing is controlled by the
  pilot classification above rather than priority alone.
- **Low** means useful configurability or polish that normally follows pilot evidence,
  unless the explicit pilot decision gate proves it necessary earlier.

No retained item is executable directly from this register. Items classified above as
required or conditionally required become blockers only when the pilot decision gate
confirms their applicability and the authoritative roadmap promotes a bounded lifecycle.

## 7. Promotion Rule

Before promoting a retained entry:

1. inspect the latest FUND and Commerce implementation rather than assuming the gap still
   exists;
2. confirm that the outcome is not already covered by a newer accepted roadmap stage;
3. define a bounded planning slice with explicit non-goals;
4. identify schema, migration, tenant, permission, UI and rollback implications;
5. complete implementation confirmation and review/test; and
6. reconcile both the authoritative roadmap and this Wishlist after completion.

This register should be updated in place so completed or roadmap-incorporated work does not
accumulate as misleading future scope.
