# LMSPro / SeasonPro Roadmap And Slice Control

Date: 2026-06-29  
Module: LMSPro / SeasonPro  
Control status: Active remediation structure established

## Purpose

This document is the current operational control point for LMSPro / SeasonPro remediation, slice planning and review.

Use it to resume work without reconstructing context from legacy planning notes.

## Current Documentation Structure

Current and new operational work should use:

- `00-roadmap-control/` - master state, current lanes and next slices.
- `01-cr-inputs/` - raw issue/change request evidence.
- `02-triage/` - decision and priority records.
- `03-slice-planning/` - scoped build/review plans.
- `04-implementation-confirmations/` - records of completed implementation.
- `05-review-and-test/` - review and smoke-test evidence.

Existing broad/historical planning remains in `planning/` unless it becomes operationally active.

## Current App Branch Context

Active remediation branch:

```text
feature/seasonpro-remediation
```

Current work should remain on dev/remediation branches until reviewed and explicitly aligned.

## Current Remediation Lane

### R1 - Playing Season Date Boundaries

Status: Planning tightened; ready for R1-A implementation when approved

Goal:

Separate the technical/admin season boundary from the effective playing-season boundary.

Current distinction:

- Season Start Date / End Date = technical/admin season container.
- Playing Season Start / Playing Season End = effective playing period used for countdowns and season-progress calculations.

Recommended first planning document:

```text
03-slice-planning/2026-06-29-lmspro-remediation-slice-r1-playing-season-date-boundaries-planning.md
```

Accepted first implementation slice:

```text
LMSPro R1-A - Playing Season Date Fields And Season Admin Display
```

Scope:

- Add nullable `playingSeasonStartsAt` and `playingSeasonEndsAt` fields.
- Keep existing seasons blank until manually set.
- Add fields to Season CRUD modal.
- Display technical/admin and playing-season ranges on the Season admin page.
- Update `% season remaining` to use playing-season dates only when both are set and the playing season has started.
- Keep announcement/countdown automation deferred.

## Deferred Items

- Dashboard announcement automation from playing-season offsets.
- C2 Club dashboard countdown display.
- C1 dashboard countdown display beyond basic season-admin visibility.
- General key-date automation changes unless explicitly scoped.
- Notification sending or communication automation.

## Do Not Build Yet

Do not implement these until slice planning accepts them:

- automatic dashboard announcements;
- countdown timers on Club dashboards;
- offset-triggered communications;
- season automation rules beyond date storage/display/progress calculation;
- broad key-date architecture changes.

## Recommended Next Slice

```text
LMSPro R1-A - Playing Season Date Fields And Season Admin Display
```

Planning goal:

Implement the accepted nullable playing-season date fields, Season CRUD/admin display updates and playing-season progress calculation.

## Fresh Chat Prompt

```text
Proceed with LMSPro / SeasonPro remediation planning from:
isodocs/docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md

Next slice:
LMSPro R1-A - Playing Season Date Fields And Season Admin Display.

Goal:
Implement the distinction between technical/admin Season Start/End and effective Playing Season Start/End. Playing-season dates should be optional and blank until manually set. They should appear in the Season CRUD modal and on the Season admin page. Season-progress behaviour should use playing-season dates only when both are set and the playing season has started. Dashboard announcements and offset automation remain deferred.

Do not implement dashboard announcement automation, notification sending, C2 Club dashboard countdown widgets, broader key-date architecture, season rollover changes or FUND logic.
```
