# LMSPro Roadmap Control

This folder contains current master roadmap and slice-control documents.

Read this folder first when resuming LMSPro / SeasonPro work.

Roadmap/control documents answer:

- what has been released;
- what branches are active;
- what lanes are currently open;
- what should happen next;
- what must not be built yet.

For every new planning slice:

1. Read the active roadmap/control document first.
2. Check active remediation, polish, architecture-planning and deferred items.
3. Confirm there is a CR input and, for non-trivial work, a triage decision.
4. Open detailed triage documents before creating or resuming a planning slice.
5. Keep implementation blocked until the relevant `03-slice-planning` document is accepted.
6. After implementation and review/test, update the control document so it remains current.

The current cycle is:

```text
01-cr-inputs -> 02-triage -> 03-slice-planning -> implementation
-> 04-implementation-confirmations -> 05-review-and-test -> roadmap/control update
```

CR inputs may contain suggested slices, but those suggestions are advisory until triage and
slice planning accept or reshape them.
