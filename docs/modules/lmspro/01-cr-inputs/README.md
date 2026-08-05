# LMSPro CR Inputs

This folder contains raw issue tracker exports, change request evidence and user observations.

CR inputs are evidence only. They should not be treated as direct implementation instructions until they have been triaged and assigned to a slice.

Mandatory registration:

- add every new CR to
  `../00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md` in the same
  documentation change;
- record an explicit disposition, initially `captured; awaiting triage` where appropriate;
  and
- do not treat registration as acceptance, implementation authority or a change to the
  root portfolio `Now`/`Next`.

The authoritative roadmap, rather than this README, records the current LMSPro CR inventory
and active disposition.

Remedial naming and control:

- prefix a fault/regression correction with `CR-Fix-`, for example
  `CR-Fix-YYYY-MM-DD-lmspro-<bounded-outcome>.md`;
- keep it in this folder and register it in the same authoritative LMSPro roadmap table;
- record environment, regression status, containment, workaround safety, risk assessment,
  expedite proposal/decision and displaced-work resumption point;
- do not treat `CR-Fix` as automatic `Now` or implementation authority; and
- cross-link rather than overwrite an older feature/capacity CR when the remedial fault is
  a distinct live problem.

Plain-English addition and delivery guide:

`../../../00-roadmap-control/2026-08-05-human-guide-change-request-to-release.md`
