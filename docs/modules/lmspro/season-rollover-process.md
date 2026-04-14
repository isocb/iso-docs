# LMSPro: Season Rollover & Team Continuation Process

**Document Type:** Architecture & Developer Reference  
**Module:** LMSPro  
**Status:** Work In Progress — threads identified, partial implementation  
**Created:** April 2026  
**Authors:** IsoStack  
**Related Docs:**
- [Season Lifecycle & Team Registration Workflow](./season-lifecycle-and-team-registration-workflow.md) — authoritative functional spec
- [Unified Timing Architecture](./unified-timing-architecture.md) — Key Dates and Action Card gating

---

## Purpose

This document captures the **intended end-to-end season rollover sequence**, identifies what is implemented, what is partially built, and what work remains to be done when this thread is resumed.

The season rollover process serves two distinct scenarios that converge at the same outcome:

| Scenario | Description |
|----------|-------------|
| **A — Steady-State Rollover** | League is already running in LMSPro. Season N ends; Season N+1 is prepared by cloning. |
| **B — First-Time Bootstrap** | League is new to LMSPro. Current season data is imported to create a baseline, then the rollover process begins from that point. |

Both scenarios share the same steps from **Step 3 onwards** (club intentions → team continuation → roll forward → new registrations). They differ only in how the initial season data arrives.

---

## The Canonical Sequence

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  SCENARIO A: Steady State             SCENARIO B: First-Time Bootstrap       │
│                                                                               │
│  Step 1A: Clone current season   OR   Step 1B: Create blank season           │
│           (admin trigger)                      (admin trigger)               │
│                                                                               │
│                      Step 2 (Bootstrap only): Import existing data           │
│                               Clubs, teams, age groups, divisions            │
│                               (CSV import into the blank or cloned season)   │
│                                                                               │
│  After Step 1A or 1B+2, both paths converge:                                 │
│  The new season is IN_PREPARATION with a full dataset ready to roll forward  │
└──────────────────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│  Step 3: Clubs Confirm Continuation Intention                                │
│          Via Key Date Action Card (team-continuation-opens/closes)           │
│          Clubs say: "we are / are not continuing next season"                │
│          → Existing mechanism (fully implemented)                            │
└──────────────────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│  Step 4: Teams Indicate Continuation                                         │
│          Clubs specify which individual teams are continuing or withdrawing  │
│          → TeamContinuationModal on club dashboard                           │
│          → Existing mechanism (implemented — see notes below)                │
└──────────────────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│  Step 5: Roll Forward — Age Groups, Teams, Divisions                         │
│          ⚠️  PARTIALLY IMPLEMENTED — see detail below                        │
│          League Admin triggers from Season Detail page                       │
│          All teams promoted one age group; oldest group teams set INACTIVE   │
│          Divisions (AGGs) re-pointed to the next age group                   │
│          Teams RETAIN their AGG assignment (they travel with their division) │
└──────────────────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│  Step 6: Post-Roll-Forward — Clubs Edit Teams                                │
│          During the Team Edit window (Key Date: team-edit-opens/closes)      │
│          Clubs update manager details, review age group assignments          │
│          → Existing mechanism (Action Card: teams.edit)                      │
└──────────────────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│  Step 7: New Teams Added                                                     │
│          Clubs register additional teams for the new season                  │
│          New teams are added directly to the ROLLED FORWARD age groups       │
│          i.e., if it's the new U8 group, new teams enter U8 — not U7        │
│          → Existing mechanism (Action Card: teams.register)                  │
│          ⚠️  Risk: if a club adds a team to the "wrong" (pre-roll) age group │
│              before roll-forward runs, it will be incorrectly promoted.      │
│              Roll-forward should ideally run BEFORE the new-team window.     │
└──────────────────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│  Step 8: League Reviews and Approves                                         │
│          Pending teams reviewed (approve / waiting list / cancel)            │
│          → Existing mechanism                                                │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## What Is Implemented

### ✅ Step 1A — Clone Season (`cloneSeason`)
**Router:** `src/modules/lmspro/routers/seasons.router.ts`  
**UI:** `src/app/(app)/app/lmspro/seasons/page.tsx` — "Clone Season" button on ACTIVE season  
**Behaviour:**
- Creates `LMSProSeason` with `status: IN_PREPARATION`, `isCurrent: false`
- Copies: age groups, divisions (AGGs), venues, referees, key dates (date-shifted +1 year), clubs, club officials, teams
- All cloned teams start with `status: CURRENT`, `continuingNextSeason: null`
- Guard: blocks clone if a season is already `IN_PREPARATION`, or if there are pending applications/teams

**⚠️ Important gap:** The clone copies **all teams regardless of `continuingNextSeason`**. At clone time, clubs haven't had the chance to indicate their intentions yet (continuation window is a post-clone step). This is correct by design — clubs respond about the cloned season's teams. However:

> The `continuingNextSeason` flag on the **source** (current) season's teams is NOT consulted during clone. The clone starts fresh. Continuation is then done on the cloned season, NOT the source season.

This is currently slightly inconsistent with the `TeamContinuationModal` which queries teams by `status IN [CURRENT, WITHDRAWN]` on whatever season it is pointed at. See the "Weirdness" section below.

---

### ✅ Step 3 — Club Continuation Confirmation (Intention Level)
**Key Date slugs:** `team-continuation-opens` / `team-continuation-closes`  
**Action Card:** `teams.continuation` (club dashboard, gated by key date window)  
**Status:** Fully implemented. Club-level intention is recorded.

---

### ✅ Step 4 — Team Continuation (Team Level)
**Component:** `src/modules/lmspro/components/dashboard/TeamContinuationModal.tsx`  
**Router procedure:** `teams.setContinuation`  
**Schema fields affected:**

| Field | Values | Meaning |
|-------|--------|---------|
| `LMSProTeam.continuingNextSeason` | `null` | No response yet |
| | `true` | Team is continuing |
| | `false` | Team is withdrawing |
| `LMSProTeam.status` | `CURRENT` | Active / no response / reset |
| | `WITHDRAWN` | Set when `continuingNextSeason = false` |

**`setContinuation` logic:**
```
continuing = true   → continuingNextSeason = true,  status unchanged (stays CURRENT)
continuing = false  → continuingNextSeason = false,  status = WITHDRAWN
continuing = null   → continuingNextSeason = null,   status = CURRENT  (reversal)
```

**Known UI bug — "Confirm All" disabled when all teams are withdrawn:**  
`allResponded = (confirmed + withdrawn) === total` — this is `true` even when all teams are withdrawn.  
The "Confirm All" button is `disabled={stats.allResponded}`, meaning if a club has accidentally withdrawn all teams (or data was imported with all `WITHDRAWN`), the "Confirm All" button is greyed out and the club cannot reverse it in bulk.

**Fix needed:**
```typescript
// Current (wrong — disables even when all teams are withdrawn)
disabled={stats.allResponded || bulkSaving}

// Correct — only disable when all teams are confirmed as CONTINUING
disabled={stats.confirmed === stats.total || bulkSaving}
```

Individual checkboxes still work (club can tick each team one by one), but bulk reversal is blocked.

---

### ✅ Step 5 — Roll Forward (Partial)
**Router procedure:** `seasons.rollForwardAgeGroups`  
**Preview procedure:** `seasons.getRollForwardPreview`  
**UI:** `src/app/(app)/app/lmspro/seasons/[seasonId]/page.tsx` — banner on `IN_PREPARATION` season  

**What it does:**
1. Loads all age groups for the `IN_PREPARATION` season, sorted by `ageValue` ASC
2. Oldest group: all teams set to `status: INACTIVE`, `ageGroupId: null`, `aggId: null`
3. Mid groups: each team's `ageGroupId` and `ageGroup` string advanced to the next age group; **`aggId` is retained** (team stays in its division)
4. Youngest group: no teams to process (new youngest-age teams come through club applications)
5. Divisions (AGGs): each division's `ageGroupId` is re-pointed to the next age group

**Guards:**
- Season must be `IN_PREPARATION`
- Season must not be `isCurrent`
- Idempotent: refuses if `INACTIVE` teams already exist on this season

**⚠️ What the roll-forward does NOT do (gaps):**
- Does not consult `continuingNextSeason` — promotes ALL teams regardless of continuation flag
- Does not remove or archive teams that have `continuingNextSeason = false` (WITHDRAWN)
- No mechanism to only promote `continuingNextSeason = true` teams while leaving WITHDRAWN teams as-is

**Design question to resolve:** Should roll-forward only promote teams with `continuingNextSeason = true`, skip `null` teams, and leave `WITHDRAWN` teams alone? Or should the roll-forward be separate from continuation — i.e., promote everything, then let continuation act as a later filter at league approval time?

---

### ✅ Steps 6, 7, 8 — Edit, Register, Approve
Fully implemented via existing Action Cards, team registration flow, and league approval workflow. Refer to [Season Lifecycle & Team Registration Workflow](./season-lifecycle-and-team-registration-workflow.md) for detail.

---

## What Is NOT Implemented (Work Remaining)

### ❌ Step 1B — Create Blank Season
**Status:** Not built  
**What's needed:** A UI path to create a new season without a source to clone from. This is needed for:
1. First-time league onboarding (no previous LMSPro season to clone)
2. Edge cases where the league wants to start fresh for a season  

The router already supports creating a `LMSProSeason` directly — the gap is the UI affordance (currently only the "Clone" button exists on the seasons page, and it requires an existing `ACTIVE` season).

**Suggested approach:** On the seasons list page, when no `ACTIVE` season exists, show "Create New Season" as the primary CTA rather than "Clone Season".

---

### ❌ Step 2 — Import Into Prepared Season (Bootstrap Path)
**Status:** Import infrastructure exists but the workflow is not tied to the season rollover process  
**What exists:**
- `src/modules/lmspro/import/` — CSV import handlers for clubs, teams, AGGs
- `src/modules/lmspro/import/templates.ts` — defines `teamImportTemplate`, `clubImportTemplate`
- `src/modules/lmspro/import/handlers/team.ts`, `club.ts`, `agg.ts`

**What's missing:**
- A UI flow that places import as a step in the season setup process
- A clear indication that import is the intended path when no previous season exists
- Guidance to the admin: "Import your existing clubs and teams into this season, then proceed to Roll Forward"
- A guard on import that prevents importing into an `ACTIVE` season (should only be allowed on `IN_PREPARATION`)

**Intended behaviour for bootstrap import:**
1. Admin creates blank season (Step 1B above)
2. Admin imports clubs (CSV)
3. Admin imports teams linked to clubs and age groups (CSV)
4. Season is now in the same state as a cloned season — ready for Step 3 onwards

---

### ❌ Continuation → Roll-Forward Integration
**Status:** The two steps are currently independent and the link between them is implicit  

The `rollForwardAgeGroups` procedure promotes **all** teams regardless of `continuingNextSeason`. This means:
- A team that was marked WITHDRAWN (club said it's not continuing) still gets promoted to the next age group
- A team that was not responded to (`null`) still gets promoted
- The `continuingNextSeason` flag only affects `status` (via `setContinuation`) — it does not gate the roll-forward

**Design decision needed (pick one):**

| Option | Description | Pros | Cons |
|--------|-------------|------|------|
| **Option A — Roll-forward is continuation-aware** | Only promote teams with `continuingNextSeason = true`. Skip `null`, leave `WITHDRAWN` in place. | Clean data after roll-forward | Requires clubs to have completed continuation before roll-forward; more complex |
| **Option B — Roll-forward is independent** | Promote all teams regardless. Continuation data is advisory only and used by the league for reference. WITHDRAWN teams are cleaned up separately. | Simple; league controls the process | WITHDRAWN teams end up promoted to wrong age groups unless manually removed |
| **Option C — Current behaviour** | Roll-forward promotes all. `WITHDRAWN` teams remain in the system at their old age group status. League cleans up manually. | No code changes | Confusing data state; team shows as WITHDRAWN in a rolled-forward season |

**Recommended:** Option A — promote only `continuingNextSeason = true` teams, and add a pre-roll-forward warning/confirmation that shows how many `null` and `false` teams will be skipped.

---

### ❌ Post-Roll-Forward AGG Re-allocation UI
**Status:** Divisions advance with their age group (implemented), but there is no UI to:
- Review which divisions now contain which teams after roll-forward
- Reassign the newly-inactive oldest-age-group's divisions to a new purpose
- Create new youngest-age-group divisions for the incoming U7 cohort

This is a league admin task that currently requires direct data editing.

---

## The "Weirdness" Explained

The user-identified "weirdness" in the process comes from the following tension:

**Current design:** Clone → then clubs do continuation on the cloned season's teams.  
**Intended design:** Clone → clubs do continuation → THEN roll forward (only continuing teams get promoted).

In the current implementation:
1. Clone copies all teams as `CURRENT` with `continuingNextSeason: null`
2. Clubs use the continuation modal to mark teams as continuing (`true`) or withdrawing (`false`)
3. `false` → `status: WITHDRAWN` is set immediately on the cloned team record
4. Roll-forward then promotes **everything** including WITHDRAWN teams — which is wrong

Additionally, the `TeamContinuationModal` is supposed to operate on the **cloned (IN_PREPARATION) season**, but there is no explicit enforcement of this. If a club opens the modal on the **current (ACTIVE) season**, they are marking continuation on the live season records, which then get ignored when the clone is made (because the clone always resets `continuingNextSeason: null`).

**Clear ordering that should be enforced in the UI:**

```
IN_PREPARATION season created
       ↓
[Import if needed]
       ↓
Key Date window opens: club continuation (step 3 + 4)
       ↓
League runs Roll Forward (only after continuation window closes)
       ↓
Key Date window opens: team edit + new teams
       ↓
Key Date window opens: new club applications
       ↓
League approves teams → season goes ACTIVE
```

---

## Key Dates Mapping

| Step | Key Date Slug(s) | Action Card Component Key | Who Sees It |
|------|-----------------|--------------------------|-------------|
| Club intention | `team-continuation-opens` / `team-continuation-closes` | `teams.continuation` | Club Secretaries |
| Team edit | `team-edit-opens` / `team-edit-closes` | `teams.edit` | Club Secretaries |
| New team registration | `team-registration-opens` / `team-registration-closes` | `teams.register` | Club Secretaries |
| New club application | `club-registration-opens` / `club-registration-closes` | N/A (public form) | Public |
| Roll forward | Admin-triggered (no key date) | N/A (league admin only) | League Admin |

---

## Files Reference

| File | Purpose |
|------|---------|
| `src/modules/lmspro/routers/seasons.router.ts` | `cloneSeason`, `getRollForwardPreview`, `rollForwardAgeGroups` |
| `src/modules/lmspro/routers/teams.router.ts` | `setContinuation`, `getContinuationStatus` |
| `src/modules/lmspro/components/dashboard/TeamContinuationModal.tsx` | Club-facing continuation UI |
| `src/modules/lmspro/import/` | CSV import infrastructure (teams, clubs, AGGs) |
| `src/app/(app)/app/lmspro/seasons/page.tsx` | Season list + clone UI |
| `src/app/(app)/app/lmspro/seasons/[seasonId]/page.tsx` | Season detail + roll-forward trigger |
| `prisma/schema.prisma` | `LMSProTeam` model — `continuingNextSeason`, `status`, `TeamStatus` enum |

---

## Work To Be Picked Up

When returning to this work area, the priority order is:

1. **Fix `TeamContinuationModal` "Confirm All" bug** (small, immediate)  
   Change `disabled={stats.allResponded}` → `disabled={stats.confirmed === stats.total}`

2. **Decide on Option A/B/C for continuation → roll-forward integration**  
   Recommend Option A. Update `rollForwardAgeGroups` to only promote `continuingNextSeason = true` teams and add a pre-flight warning about unresponded/withdrawn teams.

3. **Create blank season UI (Step 1B)**  
   Add "Create New Season" CTA when no `ACTIVE` season exists, to support first-time bootstrap.

4. **Wire import into the season setup flow (Step 2)**  
   Gate import to `IN_PREPARATION` seasons only. Add import as an explicit step in the preparation banner on the season detail page.

5. **Post-roll-forward AGG management UI**  
   UI to review and reassign divisions after roll-forward; create new youngest-group divisions.

6. **Enforce continuation → roll-forward ordering in UI**  
   Disable the "Roll Forward" button if the continuation window has not yet closed, or add a warning that continuation data will not be respected.
