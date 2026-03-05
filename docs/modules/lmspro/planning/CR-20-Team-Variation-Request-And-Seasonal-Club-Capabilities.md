# CR #20: Team Variation Request & Full Seasonal Club Capabilities

**Status:** Design — Awaiting Approval  
**Raised:** 5 March 2026  
**Raised By:** Chris (Platform Owner)  
**Prepared By:** GitHub Copilot AI  
**Estimated Effort:** ~3–4 sprints (phased)  
**Related Documents:**
- [Season Lifecycle & Team Registration Workflow](../season-lifecycle-and-team-registration-workflow.md) — Stages 3–6
- [Unified Timing Architecture](../unified-timing-architecture.md) — Component key / Key Date gating
- [CR-19 Read-Only Role Flag](./CR-19-Read-Only-Role-Flag.md)
- [IsoStack UX/UI Standard](../../00-overview/ui_ux_components/isostack-ux-ui-standard.md) — Table CRUD pattern, Action Cards

---

## Background & Motivation

The club-facing side of LMSPro currently exposes four pages: Dashboard, My Teams, Club Officials, Club Profile, and Free Days. As the seasonal workflow has been defined (Season Lifecycle doc), several gaps in the club-side capability set have been identified:

1. **No key-date-scoped Action Cards on the club dashboard.** The dashboard shows static navigation links. The system already has the Unified Timing Architecture and component visibility engine — it needs to be wired to visible, actionable dashboard cards that open and close based on Key Dates.

2. **Team records are not editable by clubs once approved.** This is by design (league integrity), but clubs need a governed mechanism to request changes — e.g., a new team manager, a name correction, a withdrawal. Currently there is no such mechanism.

3. **No "Add New Teams" pathway from the club dashboard.** The system supports `PENDING` teams being created by club secretaries during the team registration window (Stage 4 of season lifecycle), but there is no UI component wired to this capability on the club side, and no key-date gating of the action card.

4. **No team continuation workflow from the club side.** Stage 3 of the season lifecycle (1–15 May: clubs confirm which teams are continuing) has no club-facing UI or Action Card defined.

5. **No season roll-forward team registration checkbox.** Related to continuation: there needs to be a UI that lets clubs confirm their teams for the new season, with a per-team checkbox and a bulk confirm capability.

This CR addresses all five gaps in a coherent way, defining the component model, the data model changes needed, and the UX patterns for each capability.

---

## Scope of This CR

### In Scope

| # | Capability | Type |
|---|-----------|------|
| 1 | **Team Variation Request** — club-initiated change request for approved teams | New component + data model |
| 2 | **Add New Teams** — key-date-scoped Action Card to add `PENDING` teams during registration window | New component card |
| 3 | **Team Continuation** — per-team checkbox confirming continuation into next season | New component card + process |
| 4 | **Component card pattern** on Club Dashboard — key-date-controlled capability cards | UX pattern |
| 5 | **Team Variation Approvals** panel (league side) — all variation requests from all clubs, bulk + individual | New admin panel |

### Out of Scope (separate CRs)
- Player registration / squad management
- Season clone UI
- Division roll-forward trigger
- Division formation (U7 allocation)

---

## 1. Design Principle: Component-Scoped Capability Cards

### The Problem with Navigation-Only Dashboards

The current club dashboard has static navigation buttons (`My Teams`, `Club Officials`, `Free Days`, `Club Profile`). These are always visible regardless of season phase. This creates confusion:
- A club might try to "add a team" at any time, not understanding that registration is only open in May
- A club doesn't know when it's time to confirm their continuation
- The dashboard doesn't communicate what the club needs to do *right now*

### The Solution: Action Cards Linked to Component Keys

Each seasonal capability is a **component** defined in `ComponentDefinition`. Each component has a `componentKey` (e.g., `teams.register`, `teams.continuation`). These component keys are linked to Key Dates via `VisibilityRule` records — configurable per season by the League Admin.

The club dashboard **renders Action Cards for each component the user has access to**, with visual state derived from the Unified Timing Architecture:

| State | Visual | User Action |
|-------|--------|-------------|
| **Upcoming** | Grey card, countdown "Opens in X days" | No action |
| **Open** | Coloured card (green border), "Available now" | Click → opens capability |
| **Closing soon** | Amber border, "Closes in X hours" | Urgency signal |
| **Closed** | Grey card, locked icon, "Closed" | No action (card fades/collapses after a few days) |
| **Always on** | No date indicator | Always clickable |

This pattern is defined in the UX/UI standard (see Section 7.5 — Action Cards) and is implemented via the existing `ClubActionCards` component and `evaluateComponentVisibility` engine.

### Component Key Registry (Club-Side)

The following component keys are defined or extended by this CR:

| Component Key | Capability | Key Dates | Stage |
|--------------|-----------|-----------|-------|
| `teams.continuation` | Confirm teams continuing next season | `team-continuation-opens/closes` | Stage 3 |
| `teams.register` | Add new teams during registration window | `team-registration-opens/closes` | Stage 4 |
| `teams.variation-request` | Submit a team change request (always on, within season) | None (always visible) | Any |
| `teams.edit` | Edit team manager details (always on) | None (always visible) | Any |
| `clubs.profile` | View/edit club contact details | None (always visible) | Any |
| `clubs.officials` | Manage club officials | None (always visible) | Any |
| `free-days.request` | Request standard free days | None (always, but quota-gated) | Any |

> **Note:** `teams.edit` and `teams.variation-request` are distinct:
> - `teams.edit` = only team manager name/contact fields (self-service, no approval needed)
> - `teams.variation-request` = everything else (requires league approval)

---

## 2. Team Manager Self-Service (Existing Teams)

### What Clubs Can Edit Without Approval

Once a team is `CURRENT` (approved), the club can update **only** the team manager details without triggering a variation request:

| Field | Self-service? | Notes |
|-------|-------------|-------|
| `managerName` | ✅ Yes | Direct save, no approval |
| `managerEmail` | ✅ Yes | Direct save, no approval |
| `managerPhone` | ✅ Yes | Direct save, no approval (phone field to add to schema) |
| `teamName` | ❌ No | Requires Variation Request |
| `ageGroup` | ❌ No | Requires Variation Request |
| Status (any) | ❌ No | League only |
| Division | ❌ No | League only |

### Implementation Note

The existing `My Teams` page already renders team manager fields as `readOnly`. This needs to be changed to make `managerName`, `managerEmail`, `managerPhone` editable via a direct save — with no variation request workflow involved. The existing `teams.update` tRPC mutation should be scoped to allow these specific fields from the club side (using the club user's context to restrict field access).

---

## 3. Team Variation Request

### Overview

A **Team Variation Request** is a structured change request submitted by a club user for a specific team, targeting fields that cannot be changed without league approval. The request flows into a league-side **Team Variation Approvals** panel (similar in structure to the Club Application Approvals panel and the Free Days Approvals panel).

This is not a free-text request. It is a structured form with predefined request types, ensuring the league can process it efficiently.

### Variation Request Types

| Type | What Changes | League Action Required |
|------|-------------|----------------------|
| `NAME_CHANGE` | `teamName` — new name requested | Approve/Reject |
| `AGE_GROUP_CHANGE` | `ageGroup` — unusual, requires capacity check | Approve/Reject + capacity check |
| `WITHDRAWAL` | Team withdrawal from season | Approve (sets status `CANCELLED`) |
| `REINSTATEMENT` | Re-instate a previously withdrawn team | Approve/Reject (capacity check) |
| `OTHER` | Free-text request for anything not above | League action off-system |

### Data Model

#### New Model: `LMSProTeamVariationRequest`

```prisma
model LMSProTeamVariationRequest {
  id              String                       @id @default(uuid())
  organizationId  String
  seasonId        String
  teamId          String
  requestedBy     String                       // userId
  requestType     TeamVariationRequestType
  currentValue    String?                      // Snapshot of the current field value
  requestedValue  String?                      // What the club wants it changed to
  notes           String?                      // Optional context from the club
  status          TeamVariationRequestStatus   @default(PENDING)
  reviewedBy      String?                      // League Admin userId
  reviewedAt      DateTime?
  reviewNotes     String?                      // League Admin's response
  createdAt       DateTime                     @default(now())
  updatedAt       DateTime                     @updatedAt

  organization Organization              @relation(...)
  season       LMSProSeason              @relation(...)
  team         LMSProTeam                @relation(...)
  requestedByUser User                   @relation("VariationRequestedBy", ...)
  reviewedByUser  User?                  @relation("VariationReviewedBy", ...)

  @@map("lmspro_team_variation_requests")
  @@schema("lmspro")
}

enum TeamVariationRequestType {
  NAME_CHANGE
  AGE_GROUP_CHANGE
  WITHDRAWAL
  REINSTATEMENT
  OTHER

  @@schema("lmspro")
}

enum TeamVariationRequestStatus {
  PENDING       // Submitted, awaiting league review
  APPROVED      // Approved — change applied
  REJECTED      // Rejected — no change made
  CANCELLED     // Club withdrew the request before it was actioned

  @@schema("lmspro")
}
```

#### Changes to `LMSProTeam`

Add `managerPhone` (missing from current schema):

```prisma
model LMSProTeam {
  // ... existing fields ...
  managerPhone    String?   // ← Add this
  // ...
}
```

### UX — Club Side: Submitting a Variation Request

**Entry point:** My Teams page → click a team row → CRUD modal

In the CRUD modal (for club users, for `CURRENT` or `WAITING_LIST` teams):

**Editable fields (self-service — immediate save):**
- Manager Name, Manager Email, Manager Phone

**Variation Request section (below a divider labelled "Request a Change"):**
- A `Select` dropdown: "What would you like to change?"
  - Team Name
  - Request Withdrawal
  - Other / General Query
- A text field showing the current value (read-only preview)
- An input for the requested value (for Name Change)
- A textarea for notes / reason
- A "Submit Request" button

**If a PENDING variation request already exists for this team:**
- Show the pending request status (yellow badge "Awaiting league review")
- Hide the submit form (one pending request at a time per team)
- Show a "Cancel Request" button

**If read-only role (CR-19):** Hide the entire Variation Request section.

### UX — League Side: Team Variation Approvals Panel

**Location:** LMSPro Admin → Approvals → Team Variations tab (alongside Club Applications, Free Days, Special Free Days)

**Pattern:** Mirrors the existing approval panels (accordion by club, bulk action bar):

```
┌─────────────────────────────────────────────────────────────────┐
│ Team Variation Requests                         [ 3 pending ]   │
│                                                                  │
│ Filter: [ All ▼ ]  [ Season ▼ ]  [ Request Type ▼ ]            │
│                                                                  │
│ ▼ AFC Rovers                                      2 pending     │
│   ☐  AFC Rovers U9 Blues → Name Change → "AFC Rovers U9 Red"   │
│   ☐  AFC Rovers U11 → Withdrawal                               │
│                                                                  │
│ ▼ Highfield FC                                    1 pending     │
│   ☐  Highfield U8 → Name Change → "Highfield U8 Lions"        │
│                                                                  │
│ Selected: 2  [ ✓ Approve ] [ ✗ Reject ]                       │
└─────────────────────────────────────────────────────────────────┘
```

**Row click → CRUD modal:**
- Shows full request details: team, type, current value, requested value, notes
- League Admin can add review notes
- Buttons: Approve / Reject / Close
- On Approve: applies the change to the team record automatically (for Name Change and Withdrawal types)
- On Reject: request marked REJECTED; club notified (CR-18 email sequence)

**Bulk actions:**
- Select multiple → Approve All / Reject All
- Follows same pattern as Special Free Days approvals

---

## 4. Add New Teams (Stage 4 Action Card)

### Overview

During the **team registration window** (Key Dates `team-registration-opens / closes`, typically 16–31 May), existing clubs can add new `PENDING` teams for the upcoming season.

The club dashboard shows an **Action Card** for this when the window is open. The card is controlled by the Unified Timing Architecture via component key `teams.register`.

### Action Card Behaviour

| Phase | Card State |
|-------|------------|
| Before `team-registration-opens` | "New Team Registration" — grey, countdown |
| Window open | "New Team Registration" — green, "Available now" |
| After `team-registration-closes` | "New Team Registration" — grey, locked, "Closed" |
| League Admin (exempt role) | Always actionable |

### Club Secretary Action Flow

1. Card is visible and actionable on dashboard
2. Click → opens "Add New Team" modal (not the My Teams page — direct from card)
3. Form fields:
   - Age Group (Select — restricted to groups the club doesn't have 3 teams in already)
   - Team Name
   - Manager Name (optional)
   - Manager Email (optional)
   - Manager Phone (optional)
4. On submit: creates team with `status: PENDING`, assigns `teamNumber`
5. Success toast: "Team submitted for league approval"
6. Card shows a badge: "X teams pending approval" (informational)

### Constraints (enforced server-side)
- Max 3 teams per age group per club (existing + pending combined)
- Window must be open (Key Date checked server-side)
- League Admin is exempt from window check

---

## 5. Team Continuation (Stage 3 Action Card)

### Overview

During the **team continuation window** (Key Dates `team-continuation-opens / closes`, typically 1–15 May), existing clubs confirm which of their current teams are playing in the new season.

This is the first action in the seasonal cycle from the club's perspective, and it is the most critical — if a club doesn't respond, their teams are automatically marked `WITHDRAWN` at the deadline.

### Action Card Behaviour

| Phase | Card State |
|-------|------------|
| Before `team-continuation-opens` | "Team Continuation" — grey, countdown |
| Window open | "Team Continuation" — amber/green, "Action required" |
| Partial completion | "Team Continuation" — amber, "X of Y confirmed" |
| Fully confirmed | "Team Continuation" — green, "All teams confirmed ✓" |
| After `team-continuation-closes` | "Team Continuation" — grey, locked |

### Club Secretary Action Flow

1. Action Card visible on Club Dashboard during window
2. Click → opens dedicated "Team Continuation" page or modal (modal preferred for smaller clubs)
3. Displays a list of all the club's `CURRENT` teams from the **current** season
4. Each row has:
   - Team name, age group (read-only)
   - A checkbox: **"Continuing next season"** (default: unchecked)
   - A note field (optional): "If not continuing, you may add a reason (optional)"
5. A **"Confirm All & Submit"** button at the bottom
6. Bulk action: "Tick All / Untick All"

### Status Transitions on Submission

| Club Action | Team Status (new season record) |
|------------|--------------------------------|
| ✅ Checked "Continuing" | Remains / becomes `CURRENT` in new season |
| ❌ Unchecked (deadline passed) | Automatically → `WITHDRAWN` |

### Deadline Automation (System)

On the `team-continuation-closes` Key Date, a scheduled job (or a triggered check on next admin access):
1. Finds all teams for clubs that have **not submitted continuation** (or submitted but left unchecked)
2. Sets those teams to `WITHDRAWN` status
3. Logs an audit entry per team
4. Triggers email to the club secretary (CR-18 sequence)

### League Admin Visibility

The team continuation status per club is visible in a read-only panel in the League Admin > Teams view:
- Shows how many clubs have responded
- Which clubs are outstanding (highlighted)
- League Admin can manually override `WITHDRAWN` → `CURRENT` after deadline

---

## 6. Component Key Scoping on Club Dashboard

### Current State

The `ClubActionCards` component exists but renders static/always-visible cards. There is no key-date gating or component-key-based visibility.

### Required Change

The club dashboard should query `evaluateComponentVisibility` for each component key listed above, and render the appropriate card state. The existing `ComponentDefinition` + `VisibilityRule` + `LMSProKeyDate` system already handles this.

The `ClubActionCards` component should be refactored to:
1. Accept a list of component evaluations (from `getUserContext` or a dedicated `getComponentVisibility` query)
2. Render each as a card with:
   - Icon
   - Title
   - Description (what this capability does)
   - State badge (Open / Closes in X days / Opens in X days / Closed / Always Available)
   - Coloured left border (green = open, amber = closing soon, grey = not yet / closed)
   - onClick: route to the relevant page or open the relevant modal

### Component Card Layout

```
┌─────────────────────────────────────────────────┐
│ 🟢 ┃  Register New Teams          [Open]        │
│    ┃  Add teams for next season                 │
│    ┃  Closes: 31 May (6 days)      [→ Open]     │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│ 🟡 ┃  Team Continuation           [Closes soon] │
│    ┃  Confirm which teams continue  2 of 4 done │
│    ┃  Closes: 15 May (2 days)      [→ Open]     │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│ ⚫ ┃  Request a Team Change        [Always on]  │
│    ┃  Submit changes for league approval         │
│    ┃                               [→ Open]     │
└─────────────────────────────────────────────────┘
```

### Persistence: Always-On vs Key-Date Cards

The card grid on the club dashboard shows two categories:

**Seasonal (timed):** Only shown when within window proximity (e.g. within 30 days of opening, or while open, or up to 7 days after closing with "Closed" state). Controlled by Key Dates.

**Always-On:** Shown permanently in a separate section below the seasonal cards (or with a distinct section header). These are:
- View/Edit Team Manager
- Request a Team Change
- Club Officials
- Club Profile
- Free Days

---

## 7. Team Variation Approvals — Integration with Existing Approvals Panel

### Location in Admin UI

The existing Approvals panel in LMSPro Admin (currently containing: Club Applications, Free Days, Special Free Days) gains a new **"Team Variations"** tab.

### Tab Content

- Follows the same accordion-by-club structure used in Special Free Days approvals
- Bulk action bar: Approve / Reject selected
- Row click → modal with full request detail and approve/reject controls
- On Approve (NAME_CHANGE): auto-applies `teamName` change to team record
- On Approve (WITHDRAWAL): sets team `status = CANCELLED`
- On Reject: request status → `REJECTED`; reason stored in `reviewNotes`
- CR-18 email triggers: "Request Approved" / "Request Rejected" emails to Club Secretary

### Sorting and Filtering

The table supports:
- Filter by request type (Name Change / Withdrawal / Other)
- Filter by status (Pending / Approved / Rejected / All)
- Sort by club, team, date submitted
- Fuzzy search on team name or club name

---

## 8. Data Model Summary

### New Migration Required

```sql
-- New enum types
CREATE TYPE "lmspro"."TeamVariationRequestType" AS ENUM ('NAME_CHANGE', 'AGE_GROUP_CHANGE', 'WITHDRAWAL', 'REINSTATEMENT', 'OTHER');
CREATE TYPE "lmspro"."TeamVariationRequestStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED');

-- New table
CREATE TABLE "lmspro"."lmspro_team_variation_requests" (
  "id" TEXT NOT NULL,
  "organization_id" TEXT NOT NULL,
  "season_id" TEXT NOT NULL,
  "team_id" TEXT NOT NULL,
  "requested_by" TEXT NOT NULL,
  "request_type" "lmspro"."TeamVariationRequestType" NOT NULL,
  "current_value" TEXT,
  "requested_value" TEXT,
  "notes" TEXT,
  "status" "lmspro"."TeamVariationRequestStatus" NOT NULL DEFAULT 'PENDING',
  "reviewed_by" TEXT,
  "reviewed_at" TIMESTAMPTZ,
  "review_notes" TEXT,
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMPTZ NOT NULL,
  CONSTRAINT "lmspro_team_variation_requests_pkey" PRIMARY KEY ("id")
);

-- Add managerPhone to LMSProTeam
ALTER TABLE "lmspro"."lmspro_teams"
  ADD COLUMN IF NOT EXISTS "manager_phone" TEXT;
```

### New tRPC Routers Required

| Router | Procedures |
|--------|-----------|
| `lmspro.teamVariationRequests` | `list` (admin, by season/status), `listForTeam` (club), `create` (club), `cancel` (club), `approve` (admin), `reject` (admin), `bulkApprove` (admin), `bulkReject` (admin) |

---

## 9. Implementation Phases

### Phase 1 — Schema & Migration (~2 hours)
1. Add `LMSProTeamVariationRequest` model to `schema.prisma`
2. Add `TeamVariationRequestType` and `TeamVariationRequestStatus` enums
3. Add `managerPhone` to `LMSProTeam`
4. Write and apply migration

### Phase 2 — tRPC Router: teamVariationRequests (~2 hours)
1. `create` — club submits a request (enforces one pending per team)
2. `cancel` — club cancels a pending request
3. `list` — admin view (filter by season, status, type)
4. `listForTeam` — club view of requests for a specific team
5. `approve` / `reject` — admin decisions with auto-apply logic for NAME_CHANGE and WITHDRAWAL
6. `bulkApprove` / `bulkReject` — batch processing

### Phase 3 — Club Side: My Teams page update (~2 hours)
1. Make `managerName`, `managerEmail`, `managerPhone` editable directly in the team modal
2. Add "Request a Change" section below a divider in the team modal
3. Wire to `teamVariationRequests.create` and `teamVariationRequests.cancel`
4. Show pending request status inline on the row (badge on team table row)

### Phase 4 — Admin Side: Team Variation Approvals tab (~3 hours)
1. New `TeamVariationsTab` component in the Approvals panel
2. Accordion by club, bulk action bar
3. Row click → CRUD modal with approve/reject controls
4. Auto-apply logic on approval (name update, status update)

### Phase 5 — Add New Teams Action Card (~2 hours)
1. Wire `teams.register` component key to the Action Card
2. "Add New Team" modal from card
3. Key Date gating (server-side + visual state)
4. Pending count badge on card

### Phase 6 — Team Continuation Action Card (~3 hours)
1. Wire `teams.continuation` component key
2. Team continuation page/modal: checkbox list, bulk tick, submit
3. System deadline job to auto-`WITHDRAWN` unchecked teams
4. Progress state on card ("X of Y confirmed")

### Phase 7 — Component Card Refactor on Club Dashboard (~2 hours)
1. Refactor `ClubActionCards` to accept component evaluations
2. Two-section layout: Seasonal (timed) cards + Always-On cards
3. Card state styling: open/closing/upcoming/closed/always-on
4. Route each card to appropriate page/modal

---

## 10. Open Questions

| # | Question | Status |
|---|----------|--------|
| 1 | Should a club be able to have more than one pending variation request per team (e.g., a name change AND a withdrawal)? | **Decision needed** — suggest: one active request per type per team |
| 2 | Should `AGE_GROUP_CHANGE` require a specific capacity check at submission time or only at approval? | Suggest: approval time only (matches the existing team registration policy) |
| 3 | Should `WITHDRAWAL` requests set the team status to `PENDING_WITHDRAWAL` before approval, or only change on league approval? | **Decision needed** — suggest: flag on the team record (`pendingWithdrawal: Boolean`) for visibility without premature status change |
| 4 | For the Team Continuation flow: should this operate against the **current season** (the club ticking off their teams) or against a **new season record**? | **Resolved in season lifecycle doc** — against the new season record (teams are cloned into new season on Stage 1; continuation confirms they should be `CURRENT` in that new season record) |
| 5 | Should the League Admin see a club's pending variation requests inline in the Teams tab, or only in the dedicated Approvals panel? | Suggest: both — a badge on the club's team row in the admin teams table, plus the dedicated panel |
| 6 | Should team continuation submission be atomic (all teams submitted at once) or can it be done team-by-team? | Suggest: save state per-team as the club ticks, with a final "Submit" button that locks the form |

---

## 11. Summary of New Component Keys

| Key | Description | Key Date Gated? | Actor |
|-----|-------------|----------------|-------|
| `teams.continuation` | Team continuation confirmation | Yes — Stage 3 | Club Secretary |
| `teams.register` | Add new teams (existing clubs) | Yes — Stage 4 | Club Secretary |
| `teams.edit` | Edit team manager details | No — always on | Club Secretary |
| `teams.variation-request` | Submit team change request | No — always on | Club Secretary |
| `teams.approval` | Team approval panel | No — admin exempt | League Admin |

---

*Document prepared 5 March 2026. To be updated as decisions are made.*
