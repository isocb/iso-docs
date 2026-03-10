# Issue #22 — Club Components Missing from Key Date Linking Dropdown

**Issue #22** | **ID:** `cmmjfx0th0002d8sufwce65u9`  
**Status:** ✅ Fixed  
**Logged In Role:** CLIENT_ADMIN  
**Impacts Roles:** CLIENT_ADMIN, PLATFORM_OWNER  
**Category:** Bug | **Priority:** Medium  
**Modules:** SeasonPro  
**Created:** 2026-03-09T17:13:33.797Z  
**Created By:** Chris as League Admin  
**Fixed:** 10 March 2026 | **Commit:** `0c84e7d`

---

## Original Report

> I can't see how to link the new Club card components that were created today for the various English language linked components to key dates... there are none on the draw down when linking key dates to display - like they don't exist. This could be because they have not been added to the drop down, or more seriously not completed?

---

## Root Cause

Two issues were identified:

1. **Missing `ComponentDefinition` record** — The `teams.register` Club Dashboard action card had no corresponding `ComponentDefinition` row in the database. The key date linking dropdown (`LinkedItemCrudModal`) queries `ComponentDefinition` records, so components not seeded there simply don't appear.

2. **Missing action card entirely** — The "Register a New Team" card (for clubs to submit new teams during the team registration window) had not been built. The `team-registration` form slug existed in the registry and key dates picker, but there was no club dashboard card or modal wired to it.

---

## Fix Implemented

### `teams.submitRegistration` endpoint (`teams.router.ts`)
- New tRPC mutation for club users — no `teams.manage` league permission needed
- Reads the club user's own `lmsproClubId` from session
- Validates club is `APPROVED` in the season and the selected age group exists
- Creates team with `status: PENDING` → appears on the league's Pending Approvals screen
- Full audit log: `LMSPRO_TEAM_REGISTERED_BY_CLUB`

### `RegisterTeamModal.tsx` (new component)
- Age group `Select` populated from the current season, sorted numerically (U7 → U21)
- Team Name (required), Manager name / email / phone (optional)
- Success confirmation state (checkmark) displayed after submission before close
- Invalidates `teams.list` query on success

### `ClubActionCards.tsx`
- New **"Register a New Team"** seasonal action card added as the first card in the Seasonal Actions section
- Gated on `getCardTiming('team-registration')` key date window:
  - **Before/closed:** card shown greyed with reason tooltip ("Not open yet" / "Closed")
  - **Open:** card active, green border badge, opens `RegisterTeamModal` on click
  - **No key date configured:** card fully open (league hasn't set the window yet)

### `ActionCard.tsx`
- `IconUserPlus` added to icon imports and `iconMap`

### `ComponentDefinition` — `teams.register`
- Added to `prisma/seed.ts` for future environments
- Inserted live into the database immediately (no seed required)
- `pageContext: CLUB_DASHBOARD` / `componentType: ACTION` / `sortOrder: 5`
- **Now appears in the key date linking dropdown** — go to Seasons → Key Dates → Team Registration Window → Link Component
