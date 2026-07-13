# LMSPro / SeasonPro Roadmap And Slice Control

Date: 2026-06-29
Last updated: 2026-07-08
Module: LMSPro / SeasonPro
Control status: Active roadmap and delivery-cycle control

## Purpose

This document is the current operational control point for LMSPro / SeasonPro remediation, slice planning and review.

Use it to resume work without reconstructing context from legacy planning notes.

It is now the governing progress document for active LMSPro / SeasonPro work. It should be
updated after every completed delivery cycle and before opening a new substantive lane.

## Current Documentation Structure

Current and new operational work should use:

- `00-roadmap-control/` - master state, current lanes and next slices.
- `01-cr-inputs/` - raw issue/change request evidence.
- `02-triage/` - decision and priority records.
- `03-slice-planning/` - scoped build/review plans.
- `04-implementation-confirmations/` - records of completed implementation.
- `05-review-and-test/` - review and smoke-test evidence.

Existing broad/historical planning remains in `planning/` unless it becomes operationally active.

## Controlled Delivery Cycle

Use this cycle for all non-trivial LMSPro / SeasonPro work:

```text
01-cr-inputs
-> 02-triage
-> 03-slice-planning
-> implementation in app repo
-> 04-implementation-confirmations
-> 05-review-and-test
-> roadmap/control update
```

Gate rules:

- A CR input is evidence and intent. It is not an implementation plan.
- Triage decides whether the CR is accepted, deferred, split, rejected or moved to concept
  control.
- Slice planning defines the exact build boundary, risks, data model implications,
  permissions and review expectations.
- Implementation should not begin until the relevant 03 slice plan is accepted.
- Implementation confirmation records what was actually changed.
- Review/test records browser smoke, scripts, known gaps and promotion confidence.
- This roadmap/control document is updated at cycle close before the next slice begins.

Recommended improvements to the cycle:

- Record branch/environment state in the roadmap before and after promotion.
- Record explicit "Do Not Build" boundaries in each slice.
- Add risk and safeguarding notes whenever minors, personal data, exports or impersonation
  are in scope.
- Keep concept/product strategy documents separate from near-term feature CRs.
- Treat suggested slices in CR inputs as advisory until triage and planning accept them.
- Prefer smaller slices where permission boundaries or sensitive data are involved.

## Current App Branch Context

Current app development baseline:

```text
dev
```

Current work should remain on dev/remediation branches until reviewed and explicitly aligned.

Latest known app alignment from prior cycle:

```text
origin/main = origin/staging = origin/dev = ea4e619
```

This alignment included the completed LMSPro remediation and FUND availability baseline
promotions before returning to LMSPro development planning.

## Current Completed LMSPro Cycle State

Recent LMSPro lanes completed and documented:

- R2 - imported club-user membership and live data repair;
- R3 - club official removal and archived access lifecycle planning;
- R4 - communications, email and announcements remediation;
- R5 - age group/division manager notification routing and role catalogue polish;
- R6 - playing-day mitigation and architecture overview planning;
- R7 - small UI/count polish promoted through staging and live.

Current posture:

```text
No active LMSPro implementation slice is open.
```

## Current Candidate Lane

### Club Operational Player Management / Team Manager Access

CR input:

```text
01-cr-inputs/2026-07-08-lmspro-cr-club-player-management.md
```

Triage:

```text
02-triage/2026-07-08-lmspro-triage-club-player-management.md
```

Status:

```text
PM1-A planning created; not yet accepted for implementation.
```

Working boundary:

- This is a SeasonPro / LMSPro club-value extension.
- It is not a league-wide player registration system.
- It is not the standalone ClubPro product.
- Player records are club-controlled operational data.
- Team Manager access must be designed before exposing player data to delegated users.

Next action:

```text
Review and accept, revise or split PM1-A before any implementation.
```

Current planning document:

```text
03-slice-planning/2026-07-08-lmspro-feature-slice-pm1-a-club-player-management-foundation-planning.md
```

Initial planning should cover Team Manager access and the Player data model together, but
implementation should remain split so sensitive player data is not exposed before scoped
permissions, audit and safeguarding controls are proven.

## Product Concept Boundary

ClubPro is tracked separately as a product concept, not as an LMSPro implementation slice:

```text
docs/modules/clubpro/00-roadmap-control/2026-07-08-clubpro-concept-development-and-product-boundary.md
```

ClubPro may inform long-term platform design, but it must not expand the immediate LMSPro
Club Player Management CR.

## Historical Remediation Lane Notes

### R1 - Playing Season Date Boundaries

Status: R1-A reviewed on staging and approved for live promotion

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

Implementation confirmation:

```text
04-implementation-confirmations/2026-06-29-lmspro-remediation-slice-r1-a-playing-season-date-fields-and-season-admin-display-confirmation.md
```

Review confirmation:

```text
05-review-and-test/2026-06-29-lmspro-remediation-slice-r1-a-r1-playing-season-date-boundaries-review.md
```

Review notes:

- Dev database initially lacked the new migration, causing the Seasons list to appear empty.
- The migration was applied with `npx prisma migrate deploy`.
- Playing-season dates initially displayed one day prior in UK summer time.
- DateInput values are now normalised to UTC midnight immediately on selection and on save.
- Final browser re-test should confirm exact selected dates display after re-saving.

Live promotion:

```text
05-review-and-test/2026-06-29-lmspro-r1-a-and-branding-live-promotion-confirmation.md
```

Promotion target:

```text
main = dev = staging = 682ddb4
```

This promotion also carries the SVG branding upload fix to live.

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
Live smoke test after Render deployment
```

Goal:

Confirm the live deployment at `682ddb4` works as expected, including LMSPro seasons, LMSPro communication fixes, SVG branding upload support and existing FUND admin surfaces.

## Fresh Chat Prompt

```text
Proceed with LMSPro / SeasonPro remediation planning from:
isodocs/docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md

Next step:
Live smoke test after Render deployment.

Goal:
Confirm the live deployment at `682ddb4` works as expected. Check LMSPro seasons, playing-season date display, LMSPro communication changes, SVG branding upload support and existing FUND admin surfaces. Dashboard announcements and offset automation remain deferred.

Do not implement dashboard announcement automation, notification sending, C2 Club dashboard countdown widgets, broader key-date architecture, season rollover changes or FUND logic.
```
