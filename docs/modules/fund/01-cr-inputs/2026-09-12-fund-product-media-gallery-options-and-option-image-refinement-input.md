# FUND — Product Media, Galleries, Options And Option Images

Date: 2026-09-12

Disposition: **Captured; awaiting triage and bounded planning.** Registered in the
[authoritative FUND roadmap](../00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md#product-media-galleries-and-option-images).
This input does not select a slice or authorise gallery implementation. Current B1/B1-R2
acceptance and the existing 1R-G planning proposal retain their positions.

## Problem And Owner Direction

During staging B1 smoke Chris found the Product image control routes him to an unstructured
generic Media library. He reports no image Add button there, although video addition is
visible. That is a reported UI finding, not an independently reproduced browser result.
The present route interrupts Product setup and is not accepted as the final Product-media UX.

Chris requests a Product-centred workflow: images belong visibly with the Product and are
added through its create/edit modal. Shared Media infrastructure may store those files, but
the generic repository must not be the required Product-facing journey. Storage needs
folders or equivalent segmentation so administrators can organise assets.

## Required Refinement

- Add, upload, view and manage images within Product creation/editing, with a clearly visible
  primary image and ordered gallery. Define replacement, removal and empty states there.
- Reuse shared storage where appropriate, while presenting the Product's own images.
  Determine folder/collection organisation and any shared Core dependency during triage;
  do not assume a new storage provider or duplicate media system.
- Define Product options and values, such as Colour → Red / Blue, and associate image(s)
  with the relevant values. Specify the image shown when a purchaser chooses an option,
  including fallback when that value has no dedicated image.
- Carry the same image/option meaning into Project selection, Store presentation and
  immutable offer/Order evidence as appropriate to each stage's accepted contract.
- Keep C1 Product/media administration distinct from C2 selection of eligible Products.
  Catalogue availability and Event/Project workflow authority remain unchanged.

## Planning Assessment And Acceptance Examples

Inspect the existing Product media, input/choice and choice-media relationships before
proposing schema work. Establish which options affect SKU, price, stock, production or
artwork, and which are presentation-only; this input does not decide those contracts.
Assess tenant ownership, file validation, permissions, reference retention, replacement,
deletion, immutable snapshots and the upload-to-unsaved-Product lifecycle. Establish
failure/rollback tests and control depth in the triage/selected plan, including shared Core
ownership if library organisation crosses module boundaries.

The intended human proofs include creating a Product and adding its images without leaving
the editor; identifying/changing the primary image; finding assets in an organised library;
selecting Colour and seeing the corresponding image; and confirming missing-image fallback,
foreign-tenant refusal and preservation of existing finalised evidence after later edits.

Existing roadmap policy makes options needed by the actual pilot part of Store MVP
behaviour. Do not defer those wholesale to Phase 2. Triage must distinguish those essentials
from richer gallery/library refinements and determine whether any item blocks Store MVP.
Coordinate with 1R-G presentation planning without silently extending that slice.

## Immediate B1 Test Bridge

Chris separately authorised the existing tenant logo as a temporary primary Product image.
The [B1 plan](../03-slice-planning/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-journey-development-plan.md)
owns this bounded staging fixture; its 04/05 records hold implementation and readback proof.
It does not accept the generic library UX, deliver a Product gallery, or establish the logo
as permanent Product photography. The existing B1 emulator does not render Product imagery
or a print layout; its PDF test remains evidence of the labelled development journey.

Next permitted planning action: triage this refinement against pilot needs and existing
foundations, then select bounded work through the normal roadmap lifecycle. No new
implementation, data migration, library reorganisation or main/live promotion is authorised
by this captured input.
