# LMSPro: Season Transition & Preparation System

**Status:** Planning / Design  
**Last Updated:** 17 March 2026  
**Author:** IsoStack  

---

## Overview

The Season is the core scoping concept in LMSPro — virtually every data entity (clubs, teams, age groups, divisions, key dates, venues, disciplinary records) is scoped to a season. Transitioning to a new season is therefore the most consequential operational act a league performs.

This document designs an **elegant, modular, opt-out Season Preparation workflow** that:

- Starts with a full clone of the current season (clubs, teams, divisions, age groups, key dates, venues)
- Manages the transition as a series of **independently completable preparation tasks**
- Surfaces relevant tasks to both **league admins** and **club officials** via their respective dashboards
- Integrates with the existing key dates, email, and action card infrastructure

---

## Design Principle: Opt-Out, Not Opt-In

> **Clone everything. Archive what's not continuing.**

The vast majority of clubs, teams, and divisions continue from one season to the next. Starting with a full clone and managing exceptions (withdrawals, retirements, new additions) is far less work — and less error-prone — than building a new season from scratch.

This means the clone produces a **fully-populated PREPARING season** from day one. The preparation tasks then refine it.

---

## Season Status Lifecycle

A new field `status` is added to `LMSProSeason`:

```
DRAFT      → Created but not yet cloned (e.g., manually created empty shell)
PREPARING  → Cloned from current season; preparation tasks in progress
ACTIVE     → The current running season (only one at a time)
ARCHIVED   → Past seasons; read-only
```

A `PREPARING` season runs in parallel with the `ACTIVE` season. The promotion from `PREPARING → ACTIVE` is a deliberate, confirmed act (with a checklist gate). The previous `ACTIVE` season automatically moves to `ARCHIVED`.

---

## The Clone Operation (Task 1 — Foundation of Everything)

### What Gets Cloned (Opt-Out Model)

| Entity | Cloned? | Notes |
|---|---|---|
| `LMSProAgeGroup` | ✅ Yes | Copied with same codes; AGE VALUE rolled forward (+1 year) |
| `LMSProAgeGroupGroup` (AGG/Division) | ✅ Yes | Copied with same names and structure |
| `LMSProClub` | ✅ Yes | Status reset to `PENDING_CONTINUATION` (new status) |
| `LMSProTeam` | ✅ Yes | Status reset to `PENDING_CONTINUATION`; AGG allocation preserved |
| `LMSProKeyDate` | ✅ Yes | Dates offset by +1 year (or nulled for manual setting) |
| `LMSProVenue` (league-scoped) | ✅ Yes | League venues carried forward |
| `feeStructure` JSON | ✅ Yes | Copied from source season as starting point |
| `ageGroupConfig` JSON | ✅ Yes | Copied; adjusted during roll-forward task |
| `LMSProReferee` | ✅ Yes | Referee registry carried forward |
| `LMSProDisciplinaryRecord` | ❌ No | Season-specific; not cloned |
| `LMSProTeamFreeDay` | ❌ No | Season-specific; not cloned |
| `LMSProClubApplication` | ❌ No | Applications are new-season specific |
| Fixtures / results | ❌ No | Not yet built; will follow same pattern |

### Clone Inputs

```
New Season Name    e.g., "2025/26"
Start Date
End Date
Key Date Offset    Options: +1 year (auto-shift) | Blank (set manually)
```

### Clone Outputs

- New `LMSProSeason` record with `status = PREPARING`, `clonedFromId = sourceSeasonId`
- All records above created with new `seasonId`
- A set of `LMSProSeasonPrepTask` records created automatically (one per task)
- Audit log entry

### Idempotency

Clone can be run multiple times during preparation (e.g., if the source season has changed significantly). A re-clone replaces all `PREPARING` season data. The system warns if a `PREPARING` season already exists.

---

## The Seven Preparation Tasks

Each task is a `LMSProSeasonPrepTask` record with:

```
id, seasonId, organizationId
taskKey        (enum — see below)
status         NOT_STARTED | IN_PROGRESS | COMPLETE | SKIPPED
openDate       DateTime? — when clubs/league can start this task
closeDate      DateTime? — deadline
completedAt    DateTime?
completedBy    String? (userId)
notes          String?
emailOnOpen    Boolean  — trigger notification email when task opens
emailOnClose   Boolean  — trigger reminder email before close date
```

### Task Definitions

| # | Task Key | Who Acts | Model | Description |
|---|---|---|---|---|
| 1 | `CLONE_SEASON` | League | System | Clone current season as PREPARING |
| 2 | `CLUB_CONTINUATION` | Clubs | `LMSProClub.status` | Clubs confirm or withdraw; non-responding clubs flagged |
| 3 | `TEAM_RE_REGISTRATION` | Clubs | `LMSProTeam.status` | Teams confirm continuation; withdrawn teams archived |
| 4 | `ROLL_FORWARD_AGE_GROUPS` | League | `LMSProAgeGroup` | U7→U8, U8→U9 etc.; creates new U7; archives top-age group |
| 5 | `NEW_TEAMS_EXISTING_CLUBS` | Clubs | `LMSProTeam` (create) | Window for confirmed clubs to add new teams |
| 6 | `NEW_CLUB_APPLICATIONS` | Public | `LMSProClubApplication` | New club applications with new teams |
| 7 | `FINALISE_AND_PROMOTE` | League | `LMSProSeason.status` | Review, confirm, promote PREPARING → ACTIVE |

Tasks are **independently openable** — no strict sequential dependency enforced (though the UI suggests a logical order). The league sets open/close dates per task.

---

## New Club / Team Statuses Required

To support the opt-out model cleanly, two new status values are needed:

**`LMSProClub.status`** additions:
```
PENDING_CONTINUATION  → Cloned from previous season; awaiting club confirmation
WITHDRAWN             → Club confirmed they are not continuing (was: no equivalent)
```

**`LMSProTeam.status`** additions:
```
PENDING_CONTINUATION  → Cloned; awaiting team confirmation
WITHDRAWN             → Team not continuing this season
RETIRED               → Team/age group permanently retired (e.g., U13 aging out)
```

---

## Task Detail: Roll Forward Age Groups (Task 4)

This is the most complex league-side task. It involves:

1. **Age up all existing age groups** — U7 becomes U8, U8 becomes U9, etc.  
   - Teams reallocated accordingly; AGG (division) structure updated  
   - Division names may update if they include the age code (e.g., "U8 Division 1" → "U9 Division 1")  

2. **Create new U7 (bottom-age) groups and divisions** — the new intake  
   - League chooses how many U7 divisions to create  
   - Divisions start empty; populated via Task 5 and 6  

3. **Retire/archive the top-age group** — e.g., current U13s age out  
   - Age group status set to `RETIRED`  
   - Associated teams set to `RETIRED`  
   - Data retained for historical reference  

This task is **league-only** and can be done in any order relative to Tasks 2 and 3 (club/team confirmation happens on the aged-up structure).

---

## Dashboard Integration

### League Dashboard — Season Preparation Card

Visible when a `PREPARING` season exists:

```
┌──────────────────────────────────────────────────┐
│ 🏗️  Preparing: 2025/26 Season   [5/7 tasks done] │
├──────────────────────────────────────────────────┤
│ ✅  Clone Season                     Complete    │
│ ✅  Club Continuation                Closed      │
│ ✅  Team Re-Registration             Closed      │
│ ✅  Roll Forward Age Groups          Complete    │
│ 🔄  New Teams (Existing Clubs)       Open        │
│ ⏳  New Club Applications            Opens 1 Apr │
│ ⏳  Finalise & Promote               Not Started │
├──────────────────────────────────────────────────┤
│ [View Full Preparation Dashboard →]              │
└──────────────────────────────────────────────────┘
```

### Club Dashboard — Action Cards

When Tasks 2, 3, or 5 are open, club officials see contextual action cards:

```
📋  Action Required
    Confirm your club for the 2025/26 season
    [Confirm Continuing] [Withdraw]

📋  Action Required
    3 of your teams are pending re-registration for 2025/26
    [Manage Teams →]

📋  Window Open
    Register additional teams for 2025/26 (closes 30 Apr)
    [Add New Team →]
```

---

## Database Schema Changes

### 1. Add `status` and `clonedFromId` to `LMSProSeason`

```prisma
status       SeasonStatus  @default(ACTIVE)
clonedFromId String?       @map("cloned_from_id")  // Source season reference
clonedFrom   LMSProSeason? @relation("SeasonClones", fields: [clonedFromId], references: [id])
clones       LMSProSeason[] @relation("SeasonClones")

enum SeasonStatus {
  DRAFT
  PREPARING
  ACTIVE
  ARCHIVED
  @@schema("lmspro")
}
```

### 2. New `LMSProSeasonPrepTask` model

```prisma
model LMSProSeasonPrepTask {
  id             String            @id @default(uuid())
  organizationId String            @map("organization_id")
  seasonId       String            @map("season_id")

  taskKey        SeasonPrepTaskKey
  status         PrepTaskStatus    @default(NOT_STARTED)
  displayOrder   Int               @default(0)  @map("display_order")

  openDate       DateTime?         @map("open_date")
  closeDate      DateTime?         @map("close_date")
  completedAt    DateTime?         @map("completed_at")
  completedBy    String?           @map("completed_by")
  notes          String?           @db.Text

  emailOnOpen    Boolean           @default(false) @map("email_on_open")
  emailOnClose   Boolean           @default(false) @map("email_on_close")

  createdAt      DateTime          @default(now()) @map("created_at")
  updatedAt      DateTime          @updatedAt @map("updated_at")

  organization   Organization      @relation(...)
  season         LMSProSeason      @relation(...)
  completedByUser User?            @relation(...)

  @@unique([seasonId, taskKey])
  @@map("lmspro_season_prep_tasks")
  @@schema("lmspro")
}

enum SeasonPrepTaskKey {
  CLONE_SEASON
  CLUB_CONTINUATION
  TEAM_RE_REGISTRATION
  ROLL_FORWARD_AGE_GROUPS
  NEW_TEAMS_EXISTING_CLUBS
  NEW_CLUB_APPLICATIONS
  FINALISE_AND_PROMOTE
  @@schema("lmspro")
}

enum PrepTaskStatus {
  NOT_STARTED
  IN_PROGRESS
  COMPLETE
  SKIPPED
  @@schema("lmspro")
}
```

### 3. Add `PENDING_CONTINUATION` and `WITHDRAWN` to club/team status enums

```prisma
enum ClubStatus {
  PENDING
  PENDING_CONTINUATION   // ← new: cloned, awaiting confirmation
  APPROVED
  SUSPENDED
  WITHDRAWN              // ← new: confirmed not continuing
  @@schema("lmspro")
}

enum TeamStatus {
  ACTIVE
  INACTIVE
  PENDING_CONTINUATION   // ← new
  WITHDRAWN              // ← new
  RETIRED                // ← new: aged out permanently
  @@schema("lmspro")
}
```

---

## What Already Exists

| Task | Existing Feature to Leverage |
|---|---|
| Club Continuation | `LMSProClub.status` workflow; club dashboard |
| Team Re-Registration | Team Variation Requests (action cards) — adapt or reuse |
| Key Date Actions | `LMSProKeyDate` + `keyDateConfirmations` router |
| Emails | `communications.router` + Resend templates |
| Age Group Management | `age-groups.router` (list, create, update) |
| Division/AGG Management | `ageGroups.agg` router |
| New Club Applications | `LMSProClubApplication` model + `clubApplications.router` |

---

## Implementation Phases

### Phase A — Clone Foundation (2 days)
- Add `status` + `clonedFromId` to `LMSProSeason` (migration)
- Add `PENDING_CONTINUATION`, `WITHDRAWN`, `RETIRED` to enums (migration)
- Build `cloneSeason` tRPC mutation (full deep clone per table above)
- Create `LMSProSeasonPrepTask` model + migration
- Season list UI: show `PREPARING` badge; "Clone for Next Season" button
- Audit log for all clone operations

### Phase B — Preparation Dashboard (1 day)
- New route: `/app/lmspro/seasons/[seasonId]/preparation`
- Task list UI with status indicators, open/close dates, complete/skip actions
- League dashboard: "Season Preparation" summary card
- Wire open/close dates to existing key dates system

### Phase C — Club-Facing Tasks (2 days)
- Task 2: Club continuation confirmation UI (club dashboard action card)
- Task 3: Team re-registration UI (adapts existing variation request cards)
- Task 5: New team registration window (open/close date gated)
- Club dashboard: show relevant action cards based on open task windows

### Phase D — Roll Forward Age Groups (1.5 days)
- Task 4: Roll-forward wizard UI (league side)
  - Step 1: Preview aged-up structure
  - Step 2: Choose top-age group to retire
  - Step 3: Configure new U7 divisions
  - Step 4: Confirm & apply
- `rollForwardAgeGroups` tRPC mutation

### Phase E — Finalise & Promote (0.5 days)
- Task 7: Promotion checklist (e.g., all clubs responded, age groups finalised)
- `promoteSeason` mutation: `PREPARING → ACTIVE`, previous `ACTIVE → ARCHIVED`
- isCurrent flag migration

---

## Key Decisions Made

| Decision | Choice | Rationale |
|---|---|---|
| Clone model | Opt-out (clone all) | Majority of data continues; less work to remove exceptions than rebuild |
| Prep task storage | Relational `LMSProSeasonPrepTask` table | Enables per-task key dates, email triggers, completion tracking, dashboard queries |
| Parallel seasons | Yes — PREPARING runs alongside ACTIVE | League needs to prepare while current season is live |
| Club/team status approach | New `PENDING_CONTINUATION` status post-clone | Clean state machine; clear UI for "who hasn't responded yet" |
| Age group roll-forward | Wizard-based league operation (Task 4) | Complex enough to need guided UI; not automatic |

