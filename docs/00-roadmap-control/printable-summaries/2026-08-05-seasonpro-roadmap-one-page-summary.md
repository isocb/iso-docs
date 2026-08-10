# SeasonPro Roadmap — One-Page Summary

Snapshot: 2026-08-10
Status: Printable management summary — **not delivery authority**

## Purpose

SeasonPro / LMSPro owns league, Club, season, participation, module-role and module
communications behaviour.

## Current Position

- Email F3 exact application `72c02d92` passed its automated gates and 13/13 staging smoke,
  is aligned through main, and is closed with public production health green.
- **Portfolio NOW:** indicative staging Role/security smoke on exact `60ac76c1`; dev and
  staging scans plus public health pass.
- **Portfolio NEXT:** separately authorised exact main promotion decision after staging PASS.
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
- Role Authority matrix is accepted with corrected C1/C2 persona wording. First
  `PLAT-ROLE-02` checkpoint `5e551938` failed usefully and was not promoted. Corrective
  `7e453665` contains the four Critical paths, complete persona enforcement and bounded
  Club-access finding; exact `60ac76c1` is on staging with scan/health green and human smoke
  pending; no live/data change.
  Club Officials subsequently proved two consumer defects, both corrected by
  `PLAT-ROLE-02B`. The complete 18-item human matrix now passes. An item-7 Club edit exposed
  one retained former current-season junction; its focused retest and read-only exact
  junction proof pass. Support Ticketing follows the Role project; FUND remains parked.
- The two newly published High dependency advisories are corrected locally with exact
  patched overrides, zero audit findings, full regression and build PASS. The dependency
  correction remains a separate child commit; staging still requires exact dev scan PASS.

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

Do not reopen completed F3 without a new production finding. Keep Role Authority work inside
the selected matrix/containment boundaries; do not combine live repair or the wider service.

## Next Decision

Align exact `60ac76c1` to dev only when authorised; require its exact Security Scan before
any staging lifecycle. Support Ticketing follows the completed Role
project before FUND resumes.

Authoritative source:
[`LMSPro / SeasonPro Roadmap And Slice Control`](../../modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md)

Cross-lane authority:
[`IsoStack Platform And Module Roadmap Control`](../2026-07-13-isostack-platform-and-module-roadmap-control.md)
