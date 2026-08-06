# LMSPro Slice Planning

This folder contains current and future operational slice plans.

Slice planning documents define:

- exact scope;
- implementation boundaries;
- files likely to change;
- checks to run;
- out-of-scope work;
- recommended prompts.

Historical plans may remain in `planning/` until they are next touched. New active remediation and feature plans should go here.

Current boundary:

- Historical implemented F1/F2 plan:
  `2026-08-05-lmspro-cr-fix-f1-f2-cohort-email-draft-persistence-and-audience-selection-planning.md`.
- F1 human staging smoke passes; F2 fails and its independent-`BOTH` role contract is
  superseded.
- Current replacement planning:
  `2026-08-05-lmspro-cr-fix-f2-1-cohort-taxonomy-and-picker-correction-planning.md`.
- F2.1 local and final staging human smoke pass. Exact commit `9974eed5` is aligned across
  dev, staging and main after both pre-main Security Scans and public staging health passed.
  Render exact live-build and controlled production Save Draft evidence remain to be
  recorded.
- Implemented urgent plan with automated/build and 15/15 staging human PASS, exact through
  main at `ec7e0cc4` and awaiting Render live exact-build confirmation:
  `2026-08-05-lmspro-cr-fix-f2-2-current-season-eligibility-and-count-integrity-planning.md`.
- F2.2 corrects status selectors acting as audience sources, adds source-specific
  current-season/status eligibility and preserves additive structural/role cohorts with
  truthful counts. It precedes the existing F3 uploaded-file-only acknowledgement
  follow-on.
- R11-A standard UI plan, implemented with automated/build and authenticated local UI smoke
  18/18 PASS; exact `83356030` is promoted to staging and awaits deployment/staging smoke:
  `2026-08-06-lmspro-r11-a-recipient-tab-responsive-accordion-ui-planning.md`.
- R11-A defines fresh-blank closed accordions, stored-selection initial disclosure,
  session-only user state, additive-before-eligibility order and responsive/mobile Selected
  Groups presentation. It does not displace the Email `CR-Fix` or FUND `Next`.

Historical programme context retained below does not select current work:

- R8-A1, R8-A2R, R8-A2R-F1, R8-A3 and R8-A3-F1 are complete through staging and live.
- The consolidated remediation CR contains exactly four complete business briefs. The C1 League
  dashboard reorganisation is separate work, not a fifth item.
- Formal triage accepted the programme as `R9` with separately bounded `R9-A` through
  `R9-D` lifecycles in Item 3, Item 1, Item 4, Item 2 order.
- `R9-A0` was the selected read-only writer, consumer and live-state inventory
  planning/evidence boundary at that historical checkpoint.
- Do not implement schema, compatibility code, reconciliation, UI changes or data mutation
  until R9-A0 evidence is reviewed and later bounded slices are explicitly accepted.
