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

- R8-A1, R8-A2R, R8-A2R-F1, R8-A3 and R8-A3-F1 are complete through staging and live.
- The consolidated remediation CR contains exactly four complete business briefs. The C1 League
  dashboard reorganisation is separate work, not a fifth item.
- Formal triage accepted the programme as `R9` with separately bounded `R9-A` through
  `R9-D` lifecycles in Item 3, Item 1, Item 4, Item 2 order.
- `R9-A0` is the selected read-only writer, consumer and live-state inventory
  planning/evidence boundary.
- Do not implement schema, compatibility code, reconciliation, UI changes or data mutation
  until R9-A0 evidence is reviewed and later bounded slices are explicitly accepted.
