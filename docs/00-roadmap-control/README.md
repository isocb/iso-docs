# IsoStack Root Roadmap Control

This folder governs sequencing and dependencies between sibling platform and module lanes.

It does not replace each lane's own roadmap. It answers which lane may proceed, which lane
owns a shared contract, and which cross-lane dependency is currently blocking work.

Current parent control:

`2026-07-13-isostack-platform-and-module-roadmap-control.md`

First-class Platform child roadmap:

`../platform/00-roadmap-control/2026-07-22-isostack-platform-roadmap-and-slice-control.md`

First-class LMSPro / SeasonPro child roadmap:

`../modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`

First-class FUND child roadmap:

`../modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

Subordinate cross-cutting platform assurance control:

`../platform/00-roadmap-control/2026-07-22-isostack-platform-assurance-security-review-and-refinement-roadmap.md`

The Platform roadmap governs the CR-to-review lifecycle for shared platform work. Its
subordinate assurance roadmap records monthly security/assurance findings and cross-cutting
refinement candidates. Neither independently replaces the root roadmap's single next-slice
decision.

Working method for humans and AI assistants:

`../modules/<module>/work-method.md`

Plain-English CR-to-release guide:

`2026-08-05-human-guide-change-request-to-release.md`

Printable, non-authoritative management snapshots:

`printable-summaries/`

Every new CR must be registered with an explicit disposition in its owning authoritative
child roadmap in the same documentation change. The root control is updated only when the
CR changes cross-lane ownership/dependency, creates an expedite proposal or changes the
single portfolio `Now`/`Next` pair.

Remedial CRs use the `CR-Fix-` prefix and remain inside the same owning child-roadmap
inventory. An accepted expedite temporarily becomes the one portfolio `Now`; the displaced
former `Now` becomes the resumption `Next`. The full rule and worked email example are in
the authoritative working method and plain-English guide linked above.

Whenever a source roadmap is materially reconciled, refresh its printable summary. A
printable summary never overrides the root or child roadmap.
