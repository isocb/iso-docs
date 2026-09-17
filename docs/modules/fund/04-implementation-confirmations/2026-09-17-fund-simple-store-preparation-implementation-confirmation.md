# FUND — Simple Store Preparation Implementation

Date: 2026-09-17

Status: **Implemented locally; bounded automated proof PASS. Local human preparation smoke 1–5 PASS on 17 September. Broader regression, separate review and promotion remain open.**
Control depth: **High** — financial evidence and publication authority.
Exact candidate: `9c09cbe1a9f822ccadde122e1680ab8e513ef9e1` on local `work/fund-b1-r3-platform-vat`, based on `6ebaac46`; not pushed or promoted.
Application behaviour is `3820e304`; `9c09cbe1` only moves the legacy test fixture before finalisation. Its commit hook type check passes.

[Accepted plan](../03-slice-planning/2026-09-16-fund-phase-1-launch-preparation-planning.md)
· [Review and short smoke](../05-review-and-test/2026-09-17-fund-simple-store-preparation-review-and-test.md)

## Delivered Boundary

C1 has **FUND → FUND setup** (`/app/fund/settings`) for one producer commission default and
one-time Seller details. **Event → Commission** optionally replaces that default with a flat
rate or dated ladder. New Projects inherit automatically; refresh updates never-published
Stores. Zero is valid and an unset rate is explicit. There is no per-Project offer editor or
separate acceptance step. Existing Event/Project policy versions are reused internally;
producer defaults use the existing tenant settings JSON. No schema migration is added.

C2 sees all eligible Catalogue Products included initially, gross prices and automatic images.
**Remove Products** exposes optional exclusions; refresh preserves them. Real Product images
win, otherwise a tenant-owned logo or bundled neutral image supplies the placeholder. The
same effective image reference enters Store configuration snapshots; this freezes the reference,
not a new archival copy of remote image bytes. No library visit or
manual per-Product placeholder assignment is necessary. A finalised Individual offer retains
its existing Product/content lock; even older Projects without an initialisation timestamp
cannot acquire new default Products after finalisation. Removed memberships no longer block
Store readiness.

The existing Individual preparation path remains available before the trading opening date
without commission acceptance or live payment setup. Seller identity/currency and valid
Product/template content still apply. The result remains a **labelled development PDF**;
it is not yet the classroom-ready printable template. The offline sequence is explicitly
explained: Project → template → classroom artwork → home → parents visit Store.

One C2 checkbox confirms Store review and displayed commission with first publication.
The server rechecks role, tenant, review contents, current terms, dates and release/payment
readiness in one transaction. It activates a Draft Project as part of a successful launch;
activation on its own does not publish. Failed publication rolls acceptance/activation back.
Stale reviews require refresh, repeat submissions retain one acceptance, and terms remain
fixed after first publication, including through pauses. Project start dates govern opening,
not commission locking. Previously accepted legacy evidence is preserved.

Seller setup reuses the shared Commerce Seller profile and existing Owner authority. It
creates/edits only a DRAFT profile without Orders; active/Order-referenced identity is held.
It uses genuine entered details and platform currency, retains FUND's existing GBP boundary,
and neither activates the Seller nor connects a payment provider. Impersonated writes are
refused. Existing **Settings → Payments** remains the payment setup route.

Readiness now distinguishes C1 setup, C2 preparation, opening dates and unfinished release
work. The Individual development-release restriction remains enforced. Public Store design,
production print output, checkout/Orders, Product gallery/options and earned commission/
statements/settlement remain the existing subsequent work. This is preparation delivery,
not acceptance of a live selling service.

## Evidence, Environment And Recovery

TypeScript, critical-file verification and 601 unit/regression tests (12 skipped) pass.
Changed production/test source lint has zero errors; five existing EventDetailPage warnings
remain. Production build passes in a temporary workspace, leaving Chris's localhost service
running. The old Chromium rendering proof is excluded from the unit command because its
browser launch is sandbox-blocked; no fresh browser/print-layout PASS is claimed.

Connected results at `9c09cbe1`: fresh 157-migration replay/checksums, B1-R3 rate checks,
all new simple-preparation checks, frozen offer/PDF preservation and eight existing Catalogue
concurrency cases PASS. The agent stopped the oversized remaining matrix after Chris challenged
the delay. The runner therefore exits non-zero by deliberate interruption: **no whole-run or
fresh A7 PASS is claimed**. Remaining legacy coverage and A7 are open for the promotion review,
not a reason to block this local preparation demonstration. The parent removed the dedicated
database and verified its absence. See 05 for the exact boundary and earlier fixture failures.

No new schema, migration, application database, environment or provider changes. Chris's
local test bed and archived wf1 are preserved. Nothing is pushed, promoted or deployed.
VAT A0/A/B human PASS stands; Chris records this preparation smoke 1–5 PASS, including finalisation and re-download.
Separate technical review remains pending. Individual publication/purchase smoke remains paused.

Recovery: retain the additive migration 157 already required by B1-R3 and all accepted/
finalised/Order evidence. Correct forward or use a reviewed compatible binary; reverting to
an older separate-acceptance writer is not a safe automatic rollback after combined-launch
writes. Never delete evidence to recover a failed launch. A transaction failure leaves no
false acceptance/publication; refresh the review and retry after the cause is resolved.
