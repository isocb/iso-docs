# CR-21: Age Group Registration Decoupling

**Status:** For Discussion — No Implementation Authorised  
**Date:** 13 May 2026  
**Author:** AI Planning Assistant (GitHub Copilot)  
**Requested by:** Product Owner  

---

## 1. Problem Statement

### 1.1 Context

Football leagues operate on an annual cycle. The current LMSPro season is `ACTIVE` while preparation for the next season begins concurrently. This is not a system design choice — it is a real-world operational constraint. League administrators must:

- Accept new club applications for the upcoming season **while the current season is still running**
- Allow existing clubs to register new teams for planning purposes **before the next season is formally set up**
- Roll teams forward (age groups increment by one year) **at the point of season transition**

### 1.2 The Core Conflict

`LMSProAgeGroup` records are currently the single source of truth for age group data. They serve two distinct purposes:

| Purpose | Description |
|---|---|
| **Operational** | Drive team allocation, AGG (division) assignment, fixtures, roll-forward logic |
| **Planning/Registration** | Populate the age group picker on registration forms |

These two purposes have **conflicting requirements**:

- Operational records must be **stable and correct** — changing them affects live teams, fixtures, and roll-forward succession chains
- Planning/registration lists must be **flexible and forward-looking** — the league needs to say "we are not running U7 next season" without touching live data

### 1.3 Why `IN_PREPARATION` Season Doesn't Solve It

The `SeasonStatus.IN_PREPARATION` state exists and technically creates isolated `LMSProAgeGroup` records per season. However:

1. **Users must be routed to the live (ACTIVE) system.** Both `ACTIVE` and `IN_PREPARATION` seasons coexist. The current season is still operational; club secretaries and managers are interacting with it daily.
2. **`IN_PREPARATION` is a closed, admin-only phase.** It is the window during which the league allocates incoming team requests to appropriate AGGs *before* rolling age groups forward. It is not a public-facing state.
3. **The timing is outside the system's control.** The overlap between seasons is determined by the football calendar, not by any configuration choice.

Therefore, registration forms (new team requests and new club applications) run against the **ACTIVE season**, and there is no safe way to alter that season's `LMSProAgeGroup` records without impacting live operational data.

### 1.4 The Specific Scenario

> A league decides that U7 will not be offered next season.
>
> They want to remove U7 from the registration form so clubs cannot request U7 teams.
>
> But U7 teams are still active in the current season and must not be affected.

Currently there is no way to express this intent without modifying the live `LMSProAgeGroup` record — which risks corrupting team allocations, succession chains, and roll-forward logic.

---

## 2. Scope of Impact

Two separate registration surfaces are affected, with different degrees of coupling to `LMSProAgeGroup`:

### 2.1 Register New Team (Club Dashboard) — `RegisterTeamModal`

- **Where:** Club dashboard → "Register a New Team" button
- **What it stores:** `LMSProTeam.requestedAgeGroup` — a **plain string** (e.g., `"U9"`)
- **Coupling:** **Loose.** The string is informational guidance for the league admin; it does not need to resolve to a UUID. The league assigns the actual age group separately when approving the team.
- **Current source of options:** Dynamically queries live `LMSProAgeGroup.code` values for the current season.
- **Fix complexity:** Low — can be decoupled immediately with a hardcoded or configurable list.

### 2.2 New Club Application — Multi-Step Public Form

- **Where:** Public registration form (`/embed/register/club` or `/register/club`)
- **What it stores:** `LMSProClubApplication.teamRequests` — a JSON array of `{ageGroupId: UUID, teamCount: number}`
- **Coupling:** **Tight.** The `ageGroupId` UUID must resolve to a real `LMSProAgeGroup` record. This UUID is consumed in the `name-teams` step (Step 5 of the flow) to expand individual team name fields (e.g., "3 × U9" → 3 separate name input fields, each labelled with the age group name from the database record).
- **Current source of options:** Dynamically queries live `LMSProAgeGroup` records, presenting `code` as the label and `id` as the value.
- **Fix complexity:** Medium — requires a structural change to decouple the requested age group from the `ageGroupId` FK.

---

## 3. Proposed Solutions

### 3.1 RegisterTeamModal — Immediate Fix (Authorised)

Replace the dynamic `LMSProAgeGroup` query with a hardcoded list of age group codes. Since `requestedAgeGroup` is a free string, this is safe and backward-compatible.

**Hardcoded list (interim):** `U8, U9, U10, U11, U12, U13`

**Future automation:** Once the `registrationEnabled` flag (see §3.3) is implemented, this hardcoded list would be replaced by a filtered query.

> **Status: Implemented** — See commit history.

---

### 3.2 Club Application — Structural Decoupling (Proposed, Not Yet Authorised)

The club application `teamRequests` JSON currently stores `ageGroupId` (UUID) because that UUID is needed downstream in the name-teams step. The proposal is to **decouple the requested age group from the operational age group record**.

#### Proposed Change

Modify the club application flow so that:

1. The applicant selects from a **planning list** of age group codes (strings), not from live `LMSProAgeGroup` UUIDs.
2. The `teamRequests` JSON stores `{ageGroupCode: "U9", teamCount: 2}` instead of `{ageGroupId: "uuid", teamCount: 2}`.
3. The `name-teams` step uses `ageGroupCode` purely as a display label (it already is — the label is the code string). The UUID resolution is only needed at the point the league **approves** the application and converts team requests into actual `LMSProTeam` records (at which point the admin assigns the real `LMSProAgeGroup`).

#### Impact Analysis

| Component | Change Required |
|---|---|
| `LMSProClubApplication.teamRequests` JSON schema | Change `ageGroupId` → `ageGroupCode` (string) |
| `club-applications.router.ts` — `getAgeGroups` | Return list of codes, not UUID records (or use planning list) |
| `club-applications.router.ts` — `submit` | Validate `ageGroupCode` against planning list, not FK |
| `club-applications.router.ts` — `getNameTeamsData` | Return `ageGroupCode` as label — no UUID needed |
| `name-teams/page.tsx` | Use `ageGroupCode` as display label (already string-based in practice) |
| Application approval flow | League admin assigns actual `LMSProAgeGroup` when converting application to club/teams |
| Embed registration page | Replace UUID picker with code picker |
| Public registration page | Replace UUID picker with code picker |
| `Zod` input schema on `submit` | Change `teamRequestSchema` from UUID to string code |
| Existing data migration | Any existing `teamRequests` with UUID format must be considered (PENDING applications only) |

#### Risk

- **Existing PENDING applications** at the time of deployment will have `ageGroupId` UUIDs in their `teamRequests` JSON. A migration or graceful fallback handler is needed.
- **Breaking change** to the `teamRequests` JSON shape — must be versioned or migrated carefully.

---

### 3.3 `registrationEnabled` Flag on `LMSProAgeGroup` (Future Automation)

Once the club application decoupling is in place, the planning list of age group codes can be driven by a `registrationEnabled` boolean on `LMSProAgeGroup`:

```prisma
model LMSProAgeGroup {
  // ... existing fields ...
  registrationEnabled Boolean @default(true) @map("registration_enabled")
}
```

**Behaviour:**
- Default `true` — no change to existing data or queries.
- Setting `false` hides the age group from all registration/application forms for that season.
- The operational record is **not deleted** — live teams remain unaffected.
- Displayed in the Seasons → Age Groups admin UI as a toggle: "Open for New Registrations".
- The `getAgeGroups` tRPC procedure filters by `registrationEnabled = true` when called from public-facing registration forms.

**This replaces the hardcoded list** in both `RegisterTeamModal` and the club application flow once implemented.

---

## 4. Recommended Phased Approach

| Phase | Scope | Status |
|---|---|---|
| **Phase 1** | Hardcode `RegisterTeamModal` age group list to `U8–U13` | ✅ Complete |
| **Phase 2** | Decouple Club Application `teamRequests` from `LMSProAgeGroup` UUIDs — store `ageGroupCode` string instead | 🔴 Proposed — not yet authorised |
| **Phase 3** | Add `registrationEnabled` flag to `LMSProAgeGroup`; replace hardcoded lists with filtered DB queries | 🔴 Proposed — not yet authorised |

---

## 5. Key Dates / Urgency

This work is flagged as **post-launch**. For the current launch season:
- Phase 1 is in place (RegisterTeamModal hardcoded)
- The Club Application form will continue to use live `LMSProAgeGroup` records — which means the league must ensure the live age group records are correct for the season in which registration is open
- If U7 needs to be removed from club applications, the league should contact the support admin to remove or disable the U7 `LMSProAgeGroup` record **only after confirming no live U7 teams exist in that season**

---

## 6. Open Questions for Discussion

1. Should the planning list (Phase 2) be a new dedicated model (`LMSProRegistrationAgeGroup`) or simply a JSON array on the `LMSProSeason`? A simple JSON array on the season avoids a new migration and model.
2. How should existing PENDING club applications with UUID-based `teamRequests` be handled at migration time? Auto-resolve codes from UUIDs, or flag for manual review?
3. Should the `registrationEnabled` flag be season-specific (on `LMSProAgeGroup`, which is already per-season) or organisation-wide? Per-season is the correct scope.
4. When a league admin approves a club application, should the system auto-match `ageGroupCode` to the nearest `LMSProAgeGroup.code` in the target season, or always require manual assignment?

---

*Document prepared for discussion. No implementation action should be taken without explicit authorisation.*
