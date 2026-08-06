# SeasonPro Roadmap — One-Page Summary

Snapshot: 2026-08-06
Status: Printable management summary — **not delivery authority**

## Purpose

SeasonPro / LMSPro owns league, Club, season, participation, module-role and module
communications behaviour.

## Current Position

- **Portfolio NOW:** SeasonPro Email F3 uploaded-file-only acknowledgement, through its
  accepted bounded implementation and controlled release cycle.
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
- F2.2 was implemented at `ec7e0cc4`; its corrections are retained by ancestry in current
  branch-aligned application `83356030`. F3 is now implementation-authorised under its
  dedicated 2026-08-06 triage and bounded plan.
- F2.2 also includes two bounded UI fixes: show the complete recipient count in the tab
  badge, and return to an unfiltered Email list after successful Send while retaining the
  status filter.
- `R11-A` refines the recipient picker with closed-by-default accordions, stored-selection
  disclosure, clearer Division/Age Group recipient-type grouping and responsive mobile
  presentation. Automated/build and local human smoke 18/18 PASS; exact `83356030` is
  all green in staging and aligned through main. Live deployment is triggered and public
  health is green; exact Render-build identification and authenticated production smoke
  remain. It does not alter audience resolution, delivery or the portfolio `Now`/`Next`.
- `R10-A Responsive C1 Club Management` is complete and closed after a totally-green
  control-owner production smoke.
- **Portfolio NEXT:** the self-contained Platform/SeasonPro Role Authority project, starting
  with formal triage and read-only authority inventory. Support Ticketing follows; FUND
  remains parked until all three housekeeping outcomes are complete.

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

Complete F3 only inside its accepted file-only acknowledgement boundary. Do not weaken
dedicated-link validation/fingerprinting or uploaded-file acknowledgement safety.

## Next Decision

Complete F3 through staging and the explicit production gate, then open Role Authority as
its own bounded project. Support Ticketing follows before FUND resumes.

Authoritative source:
[`LMSPro / SeasonPro Roadmap And Slice Control`](../../modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md)

Cross-lane authority:
[`IsoStack Platform And Module Roadmap Control`](../2026-07-13-isostack-platform-and-module-roadmap-control.md)
