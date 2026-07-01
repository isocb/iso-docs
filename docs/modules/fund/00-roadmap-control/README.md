# FUND Roadmap Control

This folder contains the current master roadmap and slice-control documents.

Read this folder first when resuming FUND work.

Roadmap/control documents answer:

- what has been released;
- what branches are active;
- what lanes are currently open;
- what should happen next;
- what must not be built yet.

They also carry the live issue-status register.

For every new planning slice:

1. Read the active roadmap/control document first.
2. Check the live issue-status register for outstanding remediation, polish, architecture-planning and deferred items.
3. Open detailed triage documents only for issues that need background evidence.
4. After implementation or review, update the control document so the register remains current.

## Required Slice Lifecycle

FUND work is managed as a slice trail. Do not rely on chat memory alone.

Every accepted slice should move through this documentation sequence:

1. Planning:
   - create or update a planning document in `03-slice-planning`;
   - define goal, boundaries, non-goals, implementation split and next step;
   - confirm what must not be built yet.
2. Implementation:
   - make the app/docs changes for the bounded slice only;
   - do not add adjacent Store, Orders, Commerce, C2, notification or production behaviour unless the slice explicitly includes it.
3. Implementation confirmation:
   - add a suitably labelled confirmation document in `04-implementation-confirmations`;
   - include slice label, status, files changed, checks run, explicit non-goals, risks/follow-ups and the recommended next slice prompt.
4. Review and test:
   - add a suitably labelled review/test document in `05-review-and-test`;
   - include review scope, checks run, smoke-test result or pending smoke-test expectations, boundary confirmation, outcome and next step.
5. Roadmap/control update:
   - update the active roadmap/control document after every planning, implementation confirmation or review/test document;
   - update the live issue-status register and current slice status where relevant;
   - update the fresh-chat prompt when the immediate next slice changes.

This roadmap/control update is recursive: every documentation update should trigger a quick check of whether the roadmap/control file and this README still describe the current state and process accurately.

## Naming Guidance

Use clear labels in filenames and headings so future work can be resumed without reconstructing chat context.

Recommended patterns:

```text
03-slice-planning/YYYY-MM-DD-fund-phase-1-slice-<slice>-<short-name>-planning.md
04-implementation-confirmations/YYYY-MM-DD-phase-1-slice-<slice>-<short-name>-confirmation.md
05-review-and-test/YYYY-MM-DD-phase-1-slice-<slice>-r1-<short-name>-review-and-smoke-test.md
```

Promotion confirmations may use:

```text
05-review-and-test/YYYY-MM-DD-phase-1-slice-<slice>-live-promotion-confirmation.md
```

Where a review is static-only or local-route-only, say so directly and list authenticated browser smoke expectations as pending.
