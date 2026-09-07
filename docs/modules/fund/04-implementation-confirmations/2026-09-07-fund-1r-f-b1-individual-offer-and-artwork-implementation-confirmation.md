# FUND 1R-F-B1 — Individual Offer And Artwork Implementation

Date: 2026-09-07

```text
Exact commit: 57e1454b530ae19dc586768fd996ff230d84421c
Files/change boundary: B1 four-model additive migration, offer/template/document services, C1/C2 routers and UI, existing-write guards, readiness blockers and tests; example/legacy credential sanitation only outside that runtime boundary
Automated checks: PASS; detailed checks and qualifications in the review/test record
Human evidence: authenticated C1/C2 smoke pending; synthetic component checks do not replace it
Environment proven: local runtime/component checks and dedicated disposable TEST database upgrade/replay; resources removed; application work branch published, no shared environment promotion
Known residual risk: independent review and human acceptance pending; emulated PDF/private temporary storage do not prove production or physical-print suitability
Next authorised action: independent review of the exact candidate, then authenticated local C1/C2 smoke and recorded disposition before promotion
```

Status: Implemented; automated validation passed. Independent review, human local acceptance
and any environment promotion remain pending.

Control depth: **High**. Owner authority: Chris explicitly requested technical review and
implementation after accepting D1–D4. The [B1 plan](../03-slice-planning/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-journey-development-plan.md)
owns the boundary and sole restart checkpoint.

Application baseline: `14077382`. Candidate commit: `57e1454b530ae19dc586768fd996ff230d84421c` (published to the approved work branch).
Work branch: `work/fund-b1-individual-offer`. No dev/staging/main promotion or deployed
configuration change is claimed.

## Delivered Behaviour

- C1 assigns either fixed template to an Event, standalone Project or standalone default.
  Event Projects cannot override or fall back to the standalone default.
- C2 sees capacity and readiness feedback and an exact offer preview. Only the active
  organiser, through their own session, can finalise. The confirmation explains the lock.
- Finalisation atomically stores the offer, ordered Product/commercial evidence and pending
  document. Identical concurrent submissions converge; stale or conflicting ones refuse.
- C1 or authorised C2 managers can generate/retry a deterministic development PDF. Current
  Client viewers can download through authenticated tRPC, without a public object locator.
  The matching Store preview uses the immutable confirmed snapshot.
- Lost or changed files require same-offer recovery. Regeneration must reproduce the original
  output hash. Failed deletion retains cleanup locators and reports `CLEANUP_REQUIRED`;
  retry also performs cleanup when the current document is already available.
- Database guards protect confirmed Project content, Product selection/order, Store copy and
  Store ordering/visibility across old write paths. Offer and price evidence are immutable.
- Canonical Individual Store readiness remains blocked for real trading. Public Store,
  payment, Order and operational slices remain required later in Phase 1; the editor is Phase 2.

## Schema And Technical Boundary

One additive Prisma migration, `20260907120000_fund_b1_individual_offer`, adds four records:
`FundIndividualTemplateAssignment`, `FundIndividualOffer`, `FundIndividualOfferProduct` and
`FundIndividualArtworkDocument`. Composite foreign keys retain exact tenant/Project/Store/
Product/version lineage. Scope, uniqueness, row matching, immutable-evidence and complete-
aggregate checks accompany the schema. No existing Project is backfilled or finalised.

Technical review found that Prisma 5 can return without surfacing a deferred trigger failure
at COMMIT although PostgreSQL rolls back the incomplete aggregate. Finalisation therefore
forces `SET CONSTRAINTS fund.b1_offer_complete IMMEDIATE` inside the transaction before
returning success. Negative tests also independently read back the absence of partial offers.

`FUND_INDIVIDUAL_ARTWORK_MODE` defaults to `disabled`. Emulation requires explicit target
`local`, `test` or `staging`; `production`, unknown targets and known production provider
signals refuse it. Only `.env.example` documents these settings; no deployed settings changed.
Files use private temporary storage, restricted permissions, opaque validated names and
bounded payloads. No provider credential, external worker, email grant or production asset
service was added. The fixed PDF emulator refuses unsupported font text and labels every
output as a development preview; it does not prove print layout, logo imagery or QR fitness.

## Validation And Remaining Gate

Detailed outcomes and residual limits are in the [review/test record](../05-review-and-test/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-review-and-test.md).
The authenticated C1/C2 human journey is still pending. Component visual checks use synthetic
transport and cannot replace that gate. No staging/live or physical-print PASS is claimed.

Disablement preserves confirmed evidence. Before shared deployment, reconcile existing
Individual Stores against the new readiness blockers and prove the chosen environment's
private storage/recovery contract. No evidence-table deletion is an ordinary production rollback.
