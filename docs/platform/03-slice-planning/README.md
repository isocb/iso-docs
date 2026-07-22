# IsoStack Platform Slice Planning

Every executable Platform change begins with a bounded plan in this folder after CR
capture, triage and roadmap selection.

Suggested name:

```text
YYYY-MM-DD-isostack-core-platform-slice-<id>-<name>-planning.md
```

Each plan must define scope, non-goals, ownership, current-state evidence, affected
contracts, permissions/tenancy, data/migration implications, failure behaviour, tests,
human gates and its stop condition.

A plan is not implementation evidence. Cross-cutting plans must identify affected module
consumers without absorbing their unrelated business work.
