# SeasonPro Roadmap — One-Page Summary

Snapshot: 2026-08-05
Status: Printable management summary — **not delivery authority**

## Purpose

SeasonPro / LMSPro owns league, Club, season, participation, module-role and module
communications behaviour.

## Current Position

- **Portfolio NOW:** close F2.2 with Render's exact live-build confirmation, then formalise
  the existing F3 uploaded-file-only acknowledgement triage and bounded plan.
- F1 human staging smoke passes through the maximum available 440-recipient draft, with a
  341 ms broad-case server wait.
- F2 failed because it treated C1/C2/hat-swap access context as independently selectable
  roles. F2.1 replaces it and has passed final staging smoke.
- F2.1 separates access context, functional roles and structural-cohort recipient types.
  Local and final staging human smoke pass; exact commit `9974eed5` is aligned across
  dev/staging/main after both pre-main Security Scans and public staging health passed.
- Production review found that status controls are acting as recipient-producing cohorts
  and Age Group/Division resolvers do not explicitly default Team/Club status to Current.
  The corrected model unions selected Age Group/Division/Club and functional-role audience
  sources, while season/status filters only restrict sources to which they apply.
- F2.2 is implemented at `ec7e0cc4`; automated/build and all 15 staging human-smoke checks
  pass. Dev, staging and main are exact; live deployment is initiated and exact Render
  confirmation remains. F3 follows F2.2 and is not yet implementation-authorised.
- F2.2 also includes two bounded UI fixes: show the complete recipient count in the tab
  badge, and return to an unfiltered Email list after successful Send while retaining the
  status filter.
- `R10-A Responsive C1 Club Management` is complete and closed after a totally-green
  control-owner production smoke.
- **Portfolio NEXT:** FUND `1R-F-A` bounded planning candidate; implementation unauthorised.

## Recently Completed

- `R7`: small UI/count polish, live and closed.
- `R8`: attachment-aware email delivery and bounded corrections, live and closed.
- `R9`: email integrity, Club visibility and remedial programme, production-complete.

## Open Or Parked Inputs

- **Urgent email draft-persistence `CR-Fix`:** expedite accepted. F1 corrects the former
  5.92-second broad-cohort failure and now passes human staging smoke. F2's product model
  failed review; F2.1 is the accepted replacement and is promoted to main.
- **500-recipient email operating envelope:** evidence includes a successful real send to
  414 recipients without attachments. The CR is registered and awaits communications /
  capacity triage; no limit change is authorised. The new `CR-Fix` owns the separate live
  draft-persistence regression.
- **Role-catalogue R5-C:** implementation exists, but its recorded browser-smoke evidence
  still needs reconciliation. It is not `Now`.
- **Club player management:** parked; safeguarding and Team Manager access are
  preconditions.
- **Playing-day architecture:** deferred planning outcome only.
- **Club official removal lifecycle:** historical plan; parked unless a fresh need reopens
  it.

## Immediate Management Rule

Confirm Render live displays exact `ec7e0cc4`, record that evidence, then reconcile the
existing F3 planning refinement into formal triage and bounded slice planning. Do not begin
F3 application work until that plan is explicitly accepted.

## Next Decision

Close F2.2 after exact live confirmation, then accept or amend the formal F3 bounded plan.
FUND `1R-F-A` remains the planning-only portfolio `Next`.

Authoritative source:
[`LMSPro / SeasonPro Roadmap And Slice Control`](../../modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md)

Cross-lane authority:
[`IsoStack Platform And Module Roadmap Control`](../2026-07-13-isostack-platform-and-module-roadmap-control.md)
