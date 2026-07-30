# LMSPro Remediation Slice R10-A - Responsive C1 Club Management Planning

Date: 2026-07-30

Module: LMSPro / SeasonPro

Status: ACCEPTED FOR IMPLEMENTATION AND STAGING VALIDATION

CR:

`docs/modules/lmspro/01-cr-inputs/2026-07-30-lmspro-responsive-c1-club-management-cr-input.md`

Triage:

`docs/modules/lmspro/02-triage/2026-07-30-lmspro-r10-a-responsive-c1-club-management-triage.md`

Exact recovery baseline:

```text
fbab1862fa8124ae5f1d64df1b2741fdb19761fc
```

## 1. Purpose

Apply the completed and human-tested R9-C responsive presentation pattern to C1 Club
Management while preserving the exact Club data, meanings, filters and authorities already in
use.

## 2. Source Findings

The exact baseline confirms:

- `src/app/(app)/app/lmspro/clubs/page.tsx` owns the C1 list and its existing actions;
- `sortedClubs` is already the shared filtered/sorted result;
- the full table is always rendered, so it carries seven columns into narrow layouts;
- heading controls use fixed widths within one group and need safe wrapping/full-width mobile
  treatment;
- `getClubStatusPresentation` already supplies the accepted key, label and colour;
- `canUseDirectClubApproval` already protects the exceptional legacy direct-approval action;
- the Club name link is the existing route to Club detail; and
- R9-C uses compact `Paper` cards below Mantine `md` and the complete table from `md`.

There is no source evidence requiring server, schema, migration or data work.

## 3. Implementation Contract

### 3.1 Reusable Club card

Add one C1 Club-management card component which receives display data and action callbacks.
It must show:

- full Club name and short name;
- the exact existing friendly status badge;
- season;
- Team count;
- a native `More details` button with `More details for {Club}` as its accessible name; and
- notes, edit, eligible direct approval and eligible delete controls with explicit accessible
  names.

Delete remains disabled when the Club has Teams. Direct approval remains absent unless the
existing helper permits it.

### 3.2 Page integration

Use the same `sortedClubs` array for both presentations:

```text
below md  -> compact cards
md and up -> retained full table
```

Do not duplicate filtering, status derivation, sort state or action rules.

The filter/header area may be rearranged into wrapping groups and use responsive control
widths. Values, defaults and options must remain unchanged.

Add a visible matching result count after data loads. It must distinguish the current filtered
count from the season result total when those values differ.

### 3.3 Accessibility and resilience

- Native buttons provide Enter/Space activation.
- Icon-only controls receive Club-specific `aria-label` values.
- Status text must not be clipped or reduced to colour alone.
- Long Club identity must wrap within the card.
- Card actions may wrap without creating page-wide horizontal scrolling.
- The desktop table remains the complete high-density operator view.

## 4. Likely Files

Application:

- `src/app/(app)/app/lmspro/clubs/page.tsx`;
- `src/modules/lmspro/components/ClubManagementCard.tsx`; and
- one focused component/presentation test.

Documentation:

- one implementation confirmation;
- one combined review-and-test/staging-smoke record; and
- roadmap status reconciliation.

No Prisma, migration, router, environment or job file is expected.

## 5. Automated Evidence

Run:

1. focused Club card and status-presentation tests;
2. changed-file lint;
3. `npm run type-check`;
4. `npm test -- --run`;
5. `npm run verify`;
6. `npm run build`;
7. `git diff --check`; and
8. the repository Security Scan for the exact dev and staging commits.

The focused test should prove that:

- complete Club identity, status, season and Team count render;
- the details action is a named native button;
- eligible actions render with accessible names;
- direct approval is absent when ineligible; and
- deletion is disabled when Teams exist.

## 6. Promotion And Recovery

Promotion sequence:

```text
bounded feature branch from exact fbab1862
-> focused and full local technical gates
-> committed candidate
-> fast-forward dev and pass exact dev Security Scan
-> fast-forward staging to that same exact commit
-> pass exact staging Security Scan and public health
-> stop for focused C1 human smoke
```

There is no migration to apply and no database state to recover. If a gate fails, retain staging
at `fbab1862` or revert the one bounded candidate. Production is outside this lifecycle stage.

## 7. Focused Human STAGING Schedule

Precondition: Render STAGING displays the exact candidate commit.

At mobile, tablet, desktop and 200% zoom:

1. open C1 Club Management;
2. confirm cards appear below the desktop boundary and the full table appears at desktop;
3. confirm long Club names, short names, full friendly statuses, season and Team counts remain
   visible without clipping or page-wide horizontal scrolling;
4. search by Club name and short name and confirm the same correct results;
5. exercise every status filter and the season filter;
6. confirm the matching count agrees with the visible cards/table rows;
7. confirm Club-name sort order remains alphabetical;
8. open `More details` with pointer, Enter and Space and confirm the correct Club;
9. open notes and edit from a compact card and close without changing data;
10. confirm delete remains disabled for a Club with Teams;
11. where an eligible legacy Pending Club exists, confirm approval is offered only there; and
12. confirm the desktop table retains its existing columns and actions.

Human smoke should avoid creating, updating, approving or deleting a Club. It exercises
presentation and modal/navigation opening only.

## 8. Decision

The plan is complete, internally consistent and proportionate. No business decision is open.
The control owner's instruction authorises implementation and staging progression when every
technical gate is green.

