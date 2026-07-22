# IsoStack Platform Documentation

This is the canonical documentation home for continued development of the shared IsoStack
Platform.

Start with:

`00-roadmap-control/2026-07-22-isostack-platform-roadmap-and-slice-control.md`

Authority is intentionally separated:

- `docs/00-overview/` supplies non-executable principles, architecture summaries and
  orientation;
- `docs/00-roadmap-control/` supplies root cross-lane sequencing authority; and
- `docs/platform/` owns the Platform delivery lifecycle and evidence.

The governed lifecycle is:

```text
01-cr-inputs
-> 02-triage
-> root/Platform roadmap selection
-> 03-slice-planning
-> implementation in isostack-bedrock
-> 04-implementation-confirmations
-> 05-review-and-test
-> roadmap reconciliation and controlled promotion
```

The Platform lane owns reusable platform behaviour. It does not automatically own
everything below `src/app`: routes that compose Commerce or module behaviour remain owned
by their respective Core/module lane.

Long-lived planning and lifecycle evidence belongs here in `isodocs`, not beside runtime
source files.
