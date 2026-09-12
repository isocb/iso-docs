# FUND CR Inputs

This folder contains raw issue tracker exports, change request evidence and testing observations.

CR inputs are evidence only. They do not decide scope or priority by themselves.

The 2026-07-15 Store/artwork completion input set is registered by the subordinate
strategic overview:

`../00-roadmap-control/2026-07-15-fund-store-artwork-orders-and-production-strategic-completion-roadmap.md`

It comprises three CRs plus the supporting Template Manager source brief. Resolved CR
decisions are mandatory evidence for later bounded planning. Open questions remain decision
gates and must not be silently answered by implementation. The source brief's provisional
`T` labels are not authorised FUND slice identifiers.

Workflow:

```text
Issue / CR export -> triage document -> slice planning -> implementation/review
```

Mandatory registration:

- add every new CR or governed source brief to Section 0 of
  `../00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md` in the same
  documentation change;
- give it an explicit current disposition; and
- do not treat registration as slice selection or implementation authority.

Plain-English addition and delivery guide:

`../../../00-roadmap-control/2026-08-05-human-guide-change-request-to-release.md`

Current B1 business-model finding:

- [Product media, galleries, options and option images](2026-09-12-fund-product-media-gallery-options-and-option-image-refinement-input.md) — captured; awaiting triage and bounded planning. A separately authorised staging tenant-logo placeholder supports current B1 smoke; it does not complete the media refinement.

- [Catalogue-led Product availability and Event/Project workflow authority](CR-Fix-2026-09-08-fund-workflow-authority-and-product-suitability-separation.md) — implemented locally as B1-R1 at `51618485`; human smoke steps 1–4 PASS and remaining acceptance continues through B1-R2. Supersedes the earlier Product suitability flags proposal.
- [Event Catalogue workflow scope and lifecycle integrity](CR-Fix-2026-09-10-fund-event-catalogue-workflow-scope-and-lifecycle-integrity.md) — implemented locally as B1-R2 at `29104b55`; automated/connected proof PASS and human acceptance pending.
