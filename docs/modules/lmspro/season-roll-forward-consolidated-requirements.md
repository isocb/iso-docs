# Season Roll-Forward — Consolidated Requirements

**Status:** Decisions agreed — ready for Phase 0 build  
**Date:** 24 April 2026  
**Source documents:**
- `CS-02-Age-Group-Roll-Forward.md`
- `Implementation-Plans/SeasonPropression.md`
- `isodocs/modules/lmspro/season-rollover-process.md`

### Key Decisions Made (24 April 2026)

| # | Decision |
|---|----------|
| D1 | WITHDRAWN teams are **retained** in the season with WITHDRAWN status — not removed. Valuable for FA reporting (no FA API exists). League removes manually. Filtered from club view by default. |
| D2 | Roll-forward **retains aggId** — teams stay in their division; division's `ageGroupId` re-pointed to next age group. |
| D3 | Non-responding teams (null) bulk-set to a new **'No Response'** status — neither confirmed nor withdrawn. League deals with manually. |
| D4 | Roll-forward: **warn only** if continuation window is still open — no hard block. |
| D5 | **Banded age groups deferred** — solve for annual ladder (current client) now; polish banding for future clients. |
| D6 | AGG/Division display name = **concatenation of age group code + division name** (e.g. "U13 Division 1"). Auto-updates on roll-forward because it's derived. No separate age group column needed in division views. |

---

## 1. What We Agree On — The Settled Model

Before raising the open questions, the following is well-established across all documents and confirmed by user discussion:

### The Opt-Out Principle

> Clone everything first. Archive what is not continuing.

The new season starts as a full copy of the current season. Clubs, teams, age groups, and divisions are all cloned. The preparation process then removes or changes what needs to change. This is far less work than building from scratch and reflects the real-world reality that most data carries forward.

### The Canonical Sequence

```
1.  Season cloned (IN_PREPARATION) from current ACTIVE season
         ↓
2.  [Bootstrap only] Import data into blank season (if no previous LMSPro season)
         ↓
3.  Club Continuation Window opens
    → Clubs indicate: "we are / are not continuing next season"
         ↓
4.  Team Continuation Window (within the club continuation period)
    → Clubs specify which individual teams are continuing or withdrawing
    → Teams not explicitly confirmed: status = WITHDRAWN
         ↓
5.  Continuation window closes
    → League bulk-sets non-responders to NO_RESPONSE status
    → WITHDRAWN and NO_RESPONSE teams are RETAINED in the season (FA admin requires manual process)
    → Roll-forward will skip them; league removes them manually at its own pace
         ↓
6.  League triggers Roll Forward (admin action, after continuation closes)
    → Only CONFIRMED teams promoted to next age group
    → Oldest age group's teams: status = RETIRED (aged out)
    → Youngest age group: emptied and awaiting new intake via applications
    → Divisions travel with teams (aggId retained for continuing teams)
         ↓
7.  Team Edit window opens
    → Clubs update manager details, contacts, review age group assignments
         ↓
8.  New Team Registration window opens
    → Clubs register additional new teams for the new season
    → New teams enter the rolled-forward (current) age groups
         ↓
9.  New Club Applications window opens (public form)
         ↓
10. League reviews and approves pending teams → season goes ACTIVE
```

### What Is Already Built

| Step | Status |
|------|--------|
| Step 1 — Clone season | ✅ Implemented |
| Step 3 — Club continuation (intention) | ✅ Implemented (key date gated action card) |
| Step 4 — Team continuation modal | ✅ Implemented (TeamContinuationModal) |
| Step 6 — Roll forward (partial) | ⚠️ Built but continuation-unaware — promotes ALL teams |
| Steps 7–10 — Edit, register, approve | ✅ Implemented |
| Step 1B — Create blank season (bootstrap) | ❌ Not built |
| Step 2 — Import into prepared season | ❌ Not wired into the flow |
| Continuation → Roll-forward gate | ❌ Not enforced |
| Post-roll-forward division management UI | ❌ Not built |

---

## 2. Withdrawn Teams — Intentionally Retained ✅ DECIDED

WITHDRAWN teams are **kept in the season with WITHDRAWN status**. They are NOT removed automatically by roll-forward.

**Rationale:** The Football Association (FA) and their systems require manual updates when clubs or teams withdraw from a league. There is no FA API — this is a human process. The league needs to see WITHDRAWN teams to know which notifications and FA admin tasks are outstanding. Removing them automatically would hide this work.

**Behaviour:**
- Club view: WITHDRAWN teams filtered out by default (clubs don't need to see their withdrawn teams cluttering the UI)
- League view: WITHDRAWN teams visible, filterable, and retained until the league admin manually removes them
- Roll-forward: WITHDRAWN teams are **skipped** — they do not get promoted to the next age group. They remain on the season with WITHDRAWN status and their existing ageGroupId. The league removes them at its own pace.

**Non-responding teams (null `continuingNextSeason`):**
After the continuation window closes, any team with no response is bulk-set to a new status: **`NO_RESPONSE`**. This is a distinct, visible status that tells the league: "this team has not indicated their intentions — check with the club." The league can then either:
- Manually mark them as WITHDRAWN or CONTINUING
- Leave them as NO_RESPONSE and deal with them after roll-forward

Roll-forward skips NO_RESPONSE teams (same as WITHDRAWN) — only `continuingNextSeason = true` teams are promoted.

**Pre-flight summary shown before roll-forward runs:**
```
✅  N teams confirmed continuing  → will be promoted to next age group
⚠️  N teams WITHDRAWN             → will remain in season (skipped)
❓  N teams NO_RESPONSE           → will remain in season (skipped)
🏁  N teams in terminal age group → will be set to RETIRED
```

---

## 3. Succession Map — Agreed Approach ✅ DECIDED (Banding Deferred)

The `ageValue + 1` algorithm is replaced with an explicit **succession map** — each age group points to its successor. This is **implemented now for the current annual league** and designed to support banded leagues in a future release without schema changes.

### Current Client (Annual Ladder)

For the current league (U7–U13), the succession map is a simple chain auto-populated from `ageValue`:

```
U7 → U8 → U9 → U10 → U11 → U12 → U13 (terminal)
```

The migration adds `nextAgeGroupId` to all existing `LMSProAgeGroup` records and populates it by finding the age group with `ageValue + 1` in the same season. U13 (max ageValue) gets `isTerminal = true`. U7 (min ageValue) gets `isEntryPoint = true`.

### Future Clients (Banded Leagues — Deferred)

When banded leagues are onboarded, the league admin configures the succession map manually via the Division Manager UI (e.g., U11/U12 → U14 instead of U11/U12 → U12/U13). No schema changes are required at that point — the `nextAgeGroupId` field already supports arbitrary succession.

Multi-year band dwell logic ("stay in band for another year") is also deferred. The schema additions (`rollForwardIntent` on team) are included in Phase 0 as a nullable field but the UI for setting it is not built until the banding feature is formally scoped.

---

## 4. Schema Changes Required ✅ DECIDED

### `LMSProAgeGroup` — new fields

```prisma
model LMSProAgeGroup {
  // ... existing fields ...
  nextAgeGroupId  String?              @map("next_age_group_id")   // explicit succession (replaces ageValue+1)
  nextAgeGroup    LMSProAgeGroup?      @relation("AgeGroupSuccession", fields: [nextAgeGroupId], references: [id])
  prevAgeGroups   LMSProAgeGroup[]     @relation("AgeGroupSuccession")
  isTerminal      Boolean              @default(false) @map("is_terminal")    // true = teams RETIRED on roll-forward
  isEntryPoint    Boolean              @default(false) @map("is_entry_point") // true = new applications enter here
}
```

### `LMSProTeam` — new fields

```prisma
model LMSProTeam {
  // ... existing fields ...
  rollForwardIntent  RollForwardIntent?  @map("roll_forward_intent")  // future use for banded leagues
}

enum RollForwardIntent {
  MOVE_UP   // team will promote to nextAgeGroupId
  STAY      // team stays in band (multi-year band — deferred feature)
}
```

### `TeamStatus` enum — new values

```prisma
enum TeamStatus {
  // ... existing values ...
  RETIRED      // ← new: team aged out (terminal age group); kept for historical reference
  NO_RESPONSE  // ← new: continuation window closed; club did not respond
}
```

### `LMSProAgeGroupGroup` (AGG/Division) — display name

See Section 5A below — the `displayName` is a derived field (computed at query time), not stored.

### Updated Roll-Forward Algorithm

```
For each team where continuingNextSeason = true:

  if (ageGroup.isTerminal OR ageGroup.nextAgeGroupId is null):
    → team.status = RETIRED
    → team.ageGroupId = null, team.aggId = null

  else:
    → team.ageGroupId = ageGroup.nextAgeGroupId
    → team.ageGroup   = nextAgeGroup.code
    → team.aggId      = RETAINED (team stays in its division)

For each AGG/Division:
  → agg.ageGroupId re-pointed to nextAgeGroupId of current age group
    (so the division now belongs to the promoted age group)

Teams with continuingNextSeason != true (WITHDRAWN, NO_RESPONSE, null):
  → skipped entirely — not promoted, not retired, not moved
```

---

## 5. Division (AGG) Behaviour on Roll-Forward ✅ DECIDED

**Decision: Retain aggId.** Teams stay in their division. The division's `ageGroupId` is re-pointed to the next age group.

Example for an annual league:
- Pre roll-forward: Division "Division 1" → `ageGroupId → U12`; teams in Division 1 are U12 teams
- Post roll-forward: Division "Division 1" → `ageGroupId → U13`; those same teams are now U13 teams in the same division

This correctly reflects the real-world behaviour — the division travels up the age ladder with its teams.

---

## 5A. AGG/Division Display Name — New: Concatenated Display Name ✅ DECIDED

Currently divisions have a `name` field (e.g., "Division 1") and a separate `ageGroupId` relation. The age group is displayed as a separate column.

**Agreed approach:** The **display name** for a division is computed as:

```
displayName = ageGroup.code + " " + division.name

Examples:
  "U13 Division 1"
  "U13 Division 2"
  "U12 Premier"
```

**Why this is better:**
- When roll-forward re-points `ageGroupId` to U13, the display name automatically becomes "U13 Division 1" — no manual name update needed
- Removes the need for a separate age group column in division views/tables
- Consistent, predictable display across the app
- The `name` field stays as the "base" name (e.g., "Division 1", "Premier") and the age group prefix is always derived

**Implementation:**
- `displayName` is computed at query time (not stored) — in the tRPC router via a `map()` on the result
- All UI components that display division names switch to `displayName` instead of `name`
- The Division Manager (Aggs page) shows `displayName` in the table but edits only the base `name`
- New divisions created with base name only; the age group prefix is always derived from the relation

**Migration:** No schema change — `name` field is retained as the base; `displayName` is a derived value.

---

## 6. The Youngest Group on Roll-Forward ✅ DECIDED

For the current annual league:
- Roll-forward processes all age groups **except the youngest** (`isEntryPoint = true`, e.g. U7)
- The youngest group has no teams to promote — they were the entry cohort last season; there are no teams below them to roll up
- The U7 group's divisions remain in place, empty, ready for the new intake
- New U7 teams enter via the new club application process (existing mechanism)
- The `isEntryPoint` flag identifies this group — no hardcoding of "U7" anywhere

For banded leagues (deferred): the same `isEntryPoint` flag identifies the entry band. Nothing extra to build.

---

## 7. Decisions Log — All Questions Answered

| # | Question | Decision |
|---|----------|----------|
| Q1 | Annual or banded age groups? | **Annual for current client.** Schema supports banded via `nextAgeGroupId`; banding UI deferred. |
| Q2 | Roll-forward + continuation integration? | **Only promote `continuingNextSeason = true` teams.** WITHDRAWN and NO_RESPONSE teams are skipped — not promoted, not removed. |
| Q3 | Banded dwell years? | **Deferred.** `rollForwardIntent` field added to schema as nullable placeholder only. |
| Q4 | Division aggId on roll-forward: retain or clear? | **Retain.** Teams stay in their division. Division's `ageGroupId` re-pointed to next age group. |
| Q5 | Non-responders (null) after continuation window? | **Bulk set to `NO_RESPONSE` status.** League handles manually. Roll-forward skips them. |
| Q6 | Hard block roll-forward if continuation window open? | **No hard block.** Show a warning banner: "Team Continuation component is still open." League can proceed at their discretion. |
| Q7 | Who sets `rollForwardIntent` (move up vs stay in band)? | **Deferred** with banding. Will be club-set during continuation when implemented. |
| Q8 | Division display names — auto-update on roll-forward? | **Yes, via concatenation.** Display name = `ageGroup.code + " " + division.name`. Computed at query time. See Section 5A. |

---

## 8. Implementation Phases

### Phase 0 — Schema Foundation (~1 hour)
**Goal:** Add new fields; auto-populate succession map for existing data. Non-destructive.

- Add `nextAgeGroupId`, `isTerminal`, `isEntryPoint` to `LMSProAgeGroup`
- Add `rollForwardIntent` (nullable, unused for now) to `LMSProTeam`
- Add `RETIRED` and `NO_RESPONSE` to `TeamStatus` enum
- Migration: `add_age_group_succession_and_team_status_values`
- Migration data step: auto-populate `nextAgeGroupId` from `ageValue + 1` for all existing seasons; set `isTerminal = true` on max ageValue groups; set `isEntryPoint = true` on min ageValue groups
- TypeScript type-check passes

**Test:** Prisma Studio → verify succession chain is populated on all seasons

---

### Phase 1 — AGG Display Name Concatenation (~1 hour)
**Goal:** All division views show `ageGroup.code + " " + name` as the display name.

- Update `LMSProAgeGroupGroup` queries to include joined `LMSProAgeGroup.code`
- Add `displayName` virtual field in all router responses: `\`${ageGroup.code} ${agg.name}\``
- Update all UI components that display division names to use `displayName`:
  - Division Manager (Aggs page) — table + modal
  - Season Summary Panel
  - Team cards/badges that show division name
- Division Manager edit modal: edit only the base `name`; show `displayName` preview live
- No schema change — `name` field unchanged

**Test:** Aggs page shows "U13 Division 1" etc.; editing base name updates preview in real time

---

### Phase 2 — Continuation-Aware Roll-Forward (~2 hours)
**Goal:** Roll-forward only promotes confirmed teams; non-responders bulk-set to NO_RESPONSE.

- Add `bulkSetNoResponse` mutation: sets `NO_RESPONSE` on all teams with `continuingNextSeason = null` for a given season
- Update `rollForwardAgeGroups` algorithm:
  - Only process teams where `continuingNextSeason = true`
  - Skip WITHDRAWN and NO_RESPONSE teams (leave in place with existing ageGroupId)
  - Replace `ageValue + 1` lookup with `nextAgeGroupId` lookup
  - Handle `isTerminal` — set RETIRED instead of promoting
  - Re-point each AGG's `ageGroupId` to the next age group
  - Skip AGGs belonging to `isEntryPoint` groups
- Update `getRollForwardPreview` to show the pre-flight summary (continuing / withdrawn / no-response / retiring counts)
- Add warning banner to roll-forward UI if continuation key date window is still open
- Update Season detail page roll-forward section with new preview counts

**Test:**
- Mark some teams continuing, some withdrawn, leave some null → run bulk NO_RESPONSE
- Verify preview shows correct counts
- Run roll-forward; verify: confirmed teams promoted; WITHDRAWN/NO_RESPONSE untouched; terminal-group teams RETIRED; AGG ageGroupIds re-pointed; display names auto-updated

---

### Phase 3 — Post-Roll-Forward Division Review UI (~1.5 hours)
**Goal:** League can review division state after roll-forward and create new entry-point divisions.

- Post-roll-forward summary screen: each division with team counts; any unallocated teams flagged
- Ability to create new divisions for the entry-point age group (new U7 intake)
- Bulk re-allocation tools (assign unallocated teams to divisions)

---

### Phase 4 — Season Preparation Dashboard (Future)
- Full `LMSProSeasonPrepTask` orchestration (from SeasonProgression doc)
- Task list with open/close dates, email triggers, completion tracking
- Deferred until the above phases are stable and tested

---

## 9. What This Means for the Current Season's Data

The existing `LMSProAgeGroup` records have `ageValue` (integer) and `code` (string). For the current annual league (U7–U13), the succession map is straightforward:

```
U7  → U8  → U9  → U10 → U11 → U12 → U13 (terminal)
```

The migration to add `nextAgeGroupId` should auto-populate this map based on `ageValue + 1` for all existing seasons, with U13 (or whatever the max `ageValue` is) set as `isTerminal = true` and U7 set as `isEntryPoint = true`.

**This means Phase 0 is non-destructive for the current league** — it simply formalises what the algorithm was computing implicitly, and enables banded configuration for future leagues without changing the current league's behaviour.

---

## 10. Summary — All New Concepts

| Concept | Description | Build phase |
|---------|-------------|-------------|
| `nextAgeGroupId` on `LMSProAgeGroup` | Explicit succession — replaces `ageValue + 1` | Phase 0 |
| `isTerminal` on `LMSProAgeGroup` | Terminal groups retire their teams on roll-forward | Phase 0 |
| `isEntryPoint` on `LMSProAgeGroup` | Marks the youngest group — skipped by roll-forward; receives new applications | Phase 0 |
| `RETIRED` in `TeamStatus` | Team aged out of the league permanently | Phase 0 |
| `NO_RESPONSE` in `TeamStatus` | Club did not respond during continuation window | Phase 0 |
| `rollForwardIntent` on `LMSProTeam` | MOVE_UP or STAY — schema placeholder only; banding UI deferred | Phase 0 (schema only) |
| AGG `displayName` concatenation | `ageGroup.code + " " + name` computed at query time; auto-updates on roll-forward | Phase 1 |
| Continuation-aware roll-forward | Only promotes `continuingNextSeason = true` teams; others skipped | Phase 2 |
| `bulkSetNoResponse` mutation | Bulk-sets null continuation teams to NO_RESPONSE after window closes | Phase 2 |
| Roll-forward continuation warning | Banner warning if continuation window still open — no hard block | Phase 2 |
| Post-roll-forward division review UI | Review, re-allocate, create new entry-point divisions | Phase 3 |
| Banded age groups (multi-year dwell) | `nextAgeGroupId` supports arbitrary jumps; club-set STAY intent | **Deferred** |
