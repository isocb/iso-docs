# IsoStack — Timezone Handling: Status Report & Work Plan

**Author:** AI Audit  
**Date:** 28 May 2026 — Updated 29 May 2026  
**Scope:** IsoStack Core + LMSPro (SeasonPro)  
**Status:** 🟡 Phases 1–3+4+7 complete — Phases 5, 6, 8–10 remaining

---

## 1. Background & Principles

### The Problem

All `DateTime` values in the Neon/PostgreSQL database are stored as UTC (Coordinated Universal Time). This is correct and should not change. The problem is the **display and input layer**: when a league admin in the UK enters "09:00" on a form during British Summer Time (BST), they mean 09:00 local time — but the system currently stores and displays it as if it were UTC, causing a 1-hour discrepancy during BST (late March → late October).

### The Rule

| Layer | Timezone | Notes |
|---|---|---|
| **Database** | UTC always | Never change. Neon stores all `DateTime` as UTC. |
| **Server-side logic** | UTC always | Comparisons, window checks, email scheduling all in UTC. |
| **Display** | `org.displayTimezone` | Convert UTC → local for all human-readable output. |
| **Input** | `org.displayTimezone` | Interpret user input as local time; convert to UTC before saving. |

### UK Daylight Saving Summary

| Period | Timezone | UTC Offset |
|---|---|---|
| Last Sunday in October → Last Sunday in March | GMT (Greenwich Mean Time) | UTC+0 |
| Last Sunday in March → Last Sunday in October | BST (British Summer Time) | UTC+1 |

The IANA timezone identifier `Europe/London` covers both GMT and BST automatically. Any library that uses IANA identifiers (e.g. `date-fns-tz`, `Intl`, Luxon) will handle the transition correctly without manual offset arithmetic.

### Tenant Timezone Field

`Organization.displayTimezone` (`String @default("Europe/London")`) was added in migration `20260528121439_add_display_timezone_to_organization`. It is the single source of truth for how a tenant's dates are displayed and interpreted.

---

## 2. Current Implementation Status

### ✅ Implemented & Correct (Updated 29 May 2026)

| Location | What it does | Status |
|---|---|---|
| `Organization.displayTimezone` | IANA timezone string per tenant | ✅ Schema + migration live |
| `settings/branding/page.tsx` | UI to set `displayTimezone` | ✅ Live |
| `organizations.router.ts` `update` | Accepts `displayTimezone` | ✅ Live |
| `SystemClosedScreen.tsx` | Uses `formatInTimeZone(date, displayTimezone, ...)` | ✅ Correct |
| `embed/register/club/page.tsx` | Key date open/close shown with `formatInTimeZone` | ✅ Correct |
| `key-dates.router.ts` `getSystemClosure` | Returns `displayTimezone` to client | ✅ Correct |
| `key-dates.router.ts` `getFormTiming` | Returns `displayTimezone` to client | ✅ Correct |
| `freeDays.router.ts` | Date-only fields use `Date.UTC` correctly | ✅ Correct |
| `club/free-days/page.tsx` | Uses `getUTCFullYear/Month/Date` for date-only display | ✅ Correct |
| `src/lib/timezone.ts` | **NEW** — shared TZ utilities: `formatTz`, `formatDateOnly`, `tzAbbr`, `convertTimeStringTz`, `convertTimeStringToUtc`, `fromUtc`, `toUtc` | ✅ **Phase 1 complete** |
| `src/lib/timezone-context.tsx` | **NEW** — `TimezoneProvider` + `useOrgTimezone()` hook | ✅ **Phase 1 complete** |
| `AppShell.tsx` | **UPDATED** — mounts `TimezoneProvider` with `org.displayTimezone` for entire app | ✅ **Phase 1 complete** |
| `KeyDatesTab.tsx` — `activeFromTime`/`activeToTime` | **UPDATED** — `convertTimeStringTz` on load, `convertTimeStringToUtc` on save, `tzAbbr` labels on TimeInputs | ✅ **Phase 2 complete** |
| `ClubRegistrationCard.tsx` — open/close `TimeInput` | **UPDATED** — same UTC⟷local TZ round-trip for registration window times | ✅ **Phase 2 complete** |
| `seasons/page.tsx` | **UPDATED** — `formatDateOnly` for `startDate`, `endDate`, lock date tooltip | ✅ **Phase 3 complete** |
| `seasons/[seasonId]/page.tsx` | **UPDATED** — `formatDateOnly` replacing `format(new Date(...))` | ✅ **Phase 3 complete** |
| `clubs/page.tsx` | **UPDATED** — `formatDateOnly` for `noteDate` | ✅ **Phase 3 complete** |
| `clubs/[clubId]/page.tsx` | **UPDATED** — `formatDateOnly` for `requestedDate`, `noteDate`, `startDate`, `endDate`, `createdAt` | ✅ **Phase 3+4 complete** |
| `club-applications/page.tsx` | **UPDATED** — `formatDateOnly` for `submittedAt`, `emailVerifiedAt` | ✅ **Phase 4 complete** |
| `club/free-days/page.tsx` | **UPDATED** — `formatDateOnly` for `createdAt` | ✅ **Phase 4 complete** |
| `WorkflowTemplatesTab.tsx` | **UPDATED** — `formatDateOnly` for `createdAt` + season year label | ✅ **Phase 3 complete** |
| `ComponentGatingDrawer.tsx` | **UPDATED** — `formatDateOnly` in `formatDateWindow()` | ✅ **Phase 3 complete** |
| `KeyDatesTab.tsx` `confirmedAt` | **UPDATED** — `formatDateOnly` | ✅ **Phase 4 complete** |
| `key-dates.router.ts` `isWithinKeyDateWindow` | **UPDATED** — explicit UTC contract comment | ✅ **Phase 7 complete** |

### ⚠️ Partially Implemented / Remaining

| Location | Issue |
|---|---|
| `isWithinKeyDateWindow()` in `key-dates.router.ts` | ✅ Correct (Phase 7 documented) — uses `setUTCHours` with UTC time strings. Contract comment added. |
| `seasons/[seasonId]/_components/SeasonOverviewTab.tsx` | `startDate`, `endDate`, `makeCurrentUnlocksAt`, `rollForwardUnlocksAt` — still using raw date display — Phase 6 remaining |

### ❌ Not Yet Implemented (Phases 5, 6, 8–10)

#### Pulse Module

| File | Fields Affected |
|---|---|
| `pulse/pipeline/page.tsx` | `nextActionAt` |
| `pulse/tasks/page.tsx` | `dueAt` — `DateTimePicker` + display |
| `pulse/leads/page.tsx` | `nextActionAt` — `DateTimePicker` |
| `pulse/projects/page.tsx` | `startDate`, `targetEndDate` — `DateInput` |
| `pulse/time/page.tsx` | `startAt`, `endAt` — `DateTimePicker` x4 + display |
| `pulse/organisations/page.tsx` | `startDate`, `targetEndDate`, `dueAt`, `createdAt` |
| `pulse/organisations/[id]/page.tsx` | Same fields in detail view |

#### Server-side (Routers)

| File | Issue |
|---|---|
| `seasons.router.ts` line 1652 | `new Date(season.rollForwardUnlocksAt).toLocaleDateString()` in error message — uses server Node.js locale, not tenant TZ |
| Audit log entries | `createdAt` displayed with `toLocaleString('en-GB')` — browser TZ, not org TZ |

---

## 3. Date Field Inventory by Model

### LMSPro Models — Date Nature Classification

| Model | Field | Nature | TZ Sensitivity | Notes |
|---|---|---|---|---|
| `LMSProSeason` | `startDate` | Date-only (calendar date) | Low | No specific time, just a date boundary |
| `LMSProSeason` | `endDate` | Date-only | Low | Same |
| `LMSProSeason` | `freeDayWindowOpen` | Date-only | Low | Window opens at start of day |
| `LMSProSeason` | `freeDayWindowClose` | Date-only | Low | Window closes at end of day |
| `LMSProSeason` | `makeCurrentUnlocksAt` | Date-only | **Medium** | Admin sets a date; system unlocks at UTC midnight → 1hr error in BST |
| `LMSProSeason` | `rollForwardUnlocksAt` | Date-only | **Medium** | Same as above |
| `LMSProSeason` | `rollForwardAppliedAt` | Timestamp | Low | System-set, audit only |
| `LMSProKeyDate` | `activeFrom` | Date-only (midnight UTC) | **High** | Combined with `activeFromTime` for window logic |
| `LMSProKeyDate` | `activeFromTime` | HH:MM string | **High** | Currently assumed UTC; ambiguous during BST |
| `LMSProKeyDate` | `activeTo` | Date-only (midnight UTC) | **High** | Combined with `activeToTime` |
| `LMSProKeyDate` | `activeToTime` | HH:MM string | **High** | Same |
| `LMSProTeamFreeDay` | `requestedDate` | Date-only | Low | Calendar date, no time |
| `LMSProSpecialFreeDay` | `specialDate` | Date-only | Low | Calendar date |
| `LMSProSpecialFreeDay` | `applyByDate` | Date-only | **Medium** | Deadline — end-of-day matters |
| `LMSProDisciplinaryRecord` | `startDate` | Date-only | Low | |
| `LMSProDisciplinaryRecord` | `endDate` | Date-only | Low | |
| `LMSProClubNote` | `noteDate` | Date-only | Low | Historical record |
| `LMSProClubNote` | `nextActionDate` | Date-only | **Medium** | Follow-up reminder |
| `LMSProClubApplication` | `submittedAt` | Timestamp | **Medium** | Should show in org TZ |
| `LMSProClubApplication` | `reviewedAt` | Timestamp | Low | Audit |
| `Email` | `scheduledAt` | Timestamp | **High** | Email send time must be in correct TZ |
| `Email` | `sentAt` | Timestamp | Low | Audit, UTC fine |
| `LMSProLeagueRegistration` | `tokenExpiry` | Timestamp | Low | System |

### Pulse Models

| Model | Field | Nature | TZ Sensitivity |
|---|---|---|---|
| `PulseTask` | `dueAt` | Timestamp | **High** — deadline with time |
| `PulseLead` | `nextActionAt` | Timestamp | **High** — reminder with time |
| `PulseProject` | `startDate` | Date-only | Low |
| `PulseProject` | `targetEndDate` | Date-only | **Medium** |
| `PulseTimeEntry` | `startAt` | Timestamp | **High** — time tracking |
| `PulseTimeEntry` | `endAt` | Timestamp | **High** — time tracking |

### Core Models

| Model | Field | Nature | TZ Sensitivity |
|---|---|---|---|
| `Announcement` | `expiresAt` | Timestamp | **Medium** |
| `Email` | `scheduledAt` | Timestamp | **High** |
| `SupportTicket` | `anticipatedResolutionDate` | Date | Low |

---

## 4. The Two Types of Date Field

Understanding the distinction is critical for the implementation strategy:

### Type A — Date-Only Fields
Examples: `season.startDate`, `freeDay.requestedDate`, `keyDate.activeFrom`

- Stored as `DateTime` at UTC midnight (00:00:00 UTC)
- Represent a **calendar date** with no specific time
- The correct display approach is to use the **UTC date components** (`getUTCFullYear()` etc.) — this avoids the "date shifts by one day" bug that occurs when the browser's local time is behind UTC midnight
- ✅ The free days code already does this correctly
- ❌ Most other date-only fields use `new Date(x).toLocaleDateString()` which is wrong if the browser is ahead or behind UTC

### Type B — Timestamp Fields (Date + Time)
Examples: `keyDate.activeFrom` + `keyDate.activeFromTime`, `email.scheduledAt`, `pulseTask.dueAt`

- Represent a specific moment in time
- Must be converted to `org.displayTimezone` for display
- Must be converted **from** `org.displayTimezone` **to UTC** when the user enters a value

---

## 5. The `activeFromTime` / `activeToTime` Problem (Critical)

This is the most functionally impactful timezone issue in LMSPro.

### Current Behaviour

Key dates use a split storage model:
- `activeFrom: DateTime` — stored as UTC midnight (e.g. 2025-09-01T00:00:00Z)
- `activeFromTime: String` — stored as `"09:00"` (plain HH:MM, assumed UTC)

`isWithinKeyDateWindow()` combines them via `setUTCHours(hour, min)` — treating the time string as UTC.

### The Bug During BST

If a league admin opens the key dates form on 15 June (BST = UTC+1) and types "09:00" intending "9am British time", they actually mean 08:00 UTC. But the system stores `"09:00"` and treats it as 09:00 UTC = **10:00 BST**. The registration window opens an hour later than intended.

### Resolution Options

**Option A (Recommended) — Store times as UTC, display adjusted**  
- In the `KeyDatesTab.tsx` UI, when the admin enters a time, convert from `org.displayTimezone` to UTC before saving (e.g. if org is BST and they enter "09:00", store "08:00")
- Display time by converting UTC → org TZ
- `isWithinKeyDateWindow()` continues to use `setUTCHours` unchanged ✅
- Label the time input clearly: "Times are shown in your organisation's timezone (Europe/London / BST)"

**Option B — Store times as-entered, adjust at comparison**  
- Keep storing what the admin types
- In `isWithinKeyDateWindow()`, interpret the time string as being in `org.displayTimezone`, convert to UTC before comparing
- More fragile — requires timezone available in the router function

**Option A is strongly preferred** — it keeps the server logic clean and requires only a UI-level conversion.

---

## 6. Implementation Plan

### Phase 1 — Shared Utilities (Foundation)
**Effort: ~2h | Risk: Low**

Create `src/lib/timezone.ts` with reusable helpers:

```typescript
import { formatInTimeZone, fromZonedTime, toZonedTime } from 'date-fns-tz';
import { format } from 'date-fns';

/**
 * Display a UTC DateTime in the org's timezone.
 * Use for all timestamp fields (email.sentAt, dueAt, etc.)
 */
export function formatTz(date: Date | string, tz: string, fmt = 'dd MMM yyyy') {
  return formatInTimeZone(new Date(date), tz, fmt);
}

/**
 * Display a date-only field (stored as UTC midnight).
 * Avoids day-shift by reading UTC components directly.
 */
export function formatDateOnly(date: Date | string, fmt = 'dd MMM yyyy') {
  const d = new Date(date);
  // Create a local Date from UTC components to avoid TZ-shift
  const local = new Date(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate());
  return format(local, fmt);
}

/**
 * Convert a Date entered in the given timezone to UTC.
 * Use when saving DateTimePicker values from the UI.
 */
export function toUtc(date: Date, tz: string): Date {
  return fromZonedTime(date, tz);
}

/**
 * Convert a UTC Date to a Date object representing the same moment in the given timezone.
 * Use when initialising DateTimePicker values from stored UTC data.
 */
export function fromUtc(date: Date, tz: string): Date {
  return toZonedTime(date, tz);
}

/**
 * Convert a plain HH:MM time string stored as UTC to the display timezone.
 * Use for activeFromTime / activeToTime display in KeyDatesTab.
 */
export function convertTimeStringTz(
  utcTime: string, // "HH:MM" in UTC
  date: Date,      // The associated date (for DST calculation)
  tz: string       // Target timezone
): string {
  const [h, m] = utcTime.split(':').map(Number);
  const utcDate = new Date(date);
  utcDate.setUTCHours(h!, m!, 0, 0);
  return formatInTimeZone(utcDate, tz, 'HH:mm');
}

/**
 * Convert a HH:MM time string entered in the display timezone back to UTC.
 * Use before saving activeFromTime / activeToTime.
 */
export function convertTimeStringToUtc(
  localTime: string, // "HH:MM" in display timezone
  date: Date,        // The associated date (for DST calculation)
  tz: string         // Source timezone
): string {
  const [h, m] = localTime.split(':').map(Number);
  const localDate = toZonedTime(date, tz);
  localDate.setHours(h!, m!, 0, 0);
  const utcDate = fromZonedTime(localDate, tz);
  return `${String(utcDate.getUTCHours()).padStart(2, '0')}:${String(utcDate.getUTCMinutes()).padStart(2, '0')}`;
}
```

**Also needed:** A React context/hook to make `org.displayTimezone` available throughout the app without prop-drilling.

```typescript
// src/lib/timezone-context.tsx
'use client';
import { createContext, useContext } from 'react';

const TimezoneContext = createContext<string>('Europe/London');

export function TimezoneProvider({ tz, children }: { tz: string; children: React.ReactNode }) {
  return <TimezoneContext.Provider value={tz}>{children}</TimezoneContext.Provider>;
}

export function useOrgTimezone() {
  return useContext(TimezoneContext);
}
```

Mount this in the LMSPro app layout (and the main app layout) after the org query resolves.

---

### Phase 2 — Key Dates Tab (Highest Impact)
**Effort: ~3h | Risk: Medium**

Files: `src/app/(app)/app/lmspro/seasons/_components/KeyDatesTab.tsx`

**Changes:**
1. Read `org.displayTimezone` (via hook or prop passed from season page)
2. When loading a key date for edit, convert `activeFromTime` / `activeToTime` from UTC to display TZ using `convertTimeStringTz()`
3. When saving, convert back using `convertTimeStringToUtc()`
4. In the key date table display (currently `formatDateTime()`), show times in display TZ
5. Add label under `TimeInput`: *"Time in {tz abbreviation} (e.g. BST)"*

**Also update:** `ClubRegistrationCard.tsx` — the open/close `DatePickerInput` + `TimeInput` for club registration windows.

---

### Phase 3 — Date-Only Display Fixes (LMSPro Admin)
**Effort: ~4h | Risk: Low**

Replace all `new Date(x).toLocaleDateString()` and `format(new Date(x), ...)` calls for **date-only fields** with `formatDateOnly(x)` from the shared utility.

Files to update:

- `seasons/page.tsx` — `startDate`, `endDate`, lock date tooltips
- `seasons/[seasonId]/_components/SeasonOverviewTab.tsx` — `startDate`, `endDate`, unlock date inputs
- `clubs/page.tsx` — `noteDate`
- `clubs/[clubId]/page.tsx` — `requestedDate`, `noteDate`, `startDate`, `endDate`
- `club-applications/page.tsx` — `submittedAt` (use `formatTz` here — it's a timestamp)
- `teams/page.tsx` — `requestedDate`, `requestedAt`
- `club/discipline/page.tsx` — `startDate`, `endDate`
- `modules/lmspro/components/dashboard/SeasonOverview.tsx` — `startDate`, `endDate`
- `modules/lmspro/components/dashboard/SeasonBanner.tsx` — `startDate`, `endDate`
- `modules/lmspro/components/dashboard/KeyDatesPanel.tsx` — `activeFrom`/`activeTo` + times
- `modules/lmspro/components/dashboard/TeamVariationsTab.tsx` — `createdAt`, `reviewedAt`

---

### Phase 4 — Timestamp Fields (LMSPro Admin)
**Effort: ~2h | Risk: Low**

Replace all `new Date(x).toLocaleString('en-GB')` and `new Date(x).toLocaleDateString()` for **timestamp fields** with `formatTz(x, tz, 'dd MMM yyyy HH:mm')`.

Files to update:

- `communications/page.tsx` — `email.sentAt`, `recipient.sentAt`
- `team-approval/page.tsx` — `reviewedAt`
- `clubs/[clubId]/page.tsx` — `reviewedAt`, `emailVerifiedAt`
- `seasons.router.ts` — the error message string using `toLocaleDateString()`
- `settings/audit-logs/page.tsx` — `createdAt` display (use `formatTz`)

---

### Phase 5 — DateInput / DateTimePicker for Timestamp Fields
**Effort: ~3h | Risk: Medium**

Any `DateInput` or `DateTimePicker` that reads/writes a timestamp (not just a calendar date) must use `fromUtc`/`toUtc` helpers when binding values.

**LMSPro:**
- `clubs/[clubId]/page.tsx` — `DateTimePicker` for disciplinary `startDate`/`endDate`
- `AnnouncementModal.tsx` — `DatePickerInput` for announcement expiry

**Pulse:**
- `tasks/page.tsx` — `DateTimePicker` `dueAt`
- `leads/page.tsx` — `DateTimePicker` `nextActionAt`
- `time/page.tsx` — `DateTimePicker` `startAt`/`endAt` ×4
- `projects/page.tsx` — `DateInput` `startDate`, `targetEndDate`

Pattern for each:
```typescript
// Loading into picker
value={entry.startAt ? fromUtc(new Date(entry.startAt), tz) : null}

// Saving from picker
startAt: value ? toUtc(value, tz) : null
```

---

### Phase 6 — Season Date Inputs (DateInput for date-only)
**Effort: ~1h | Risk: Low**

`SeasonOverviewTab.tsx` `DateInput` fields (`startDate`, `endDate`, `makeCurrentUnlocksAt`, `rollForwardUnlocksAt`) are date-only. The correct save pattern for date-only fields is `Date.UTC(year, month, date)` — which is already used in several places. Audit all `DateInput` save handlers and ensure they all use this pattern.

---

### Phase 7 — Server-side: `isWithinKeyDateWindow()` Audit
**Effort: ~1h | Risk: Low**

After Phase 2 is complete (time strings stored as UTC), add a comment to `isWithinKeyDateWindow()` explicitly stating the contract: *"activeFromTime and activeToTime are always UTC strings."*

Also ensure `visibility-rules.engine.ts` `combineDateAndTime()` uses the same UTC assumption consistently.

---

### Phase 8 — Pulse Module Display
**Effort: ~2h | Risk: Low**

Replace all `toLocaleDateString()` and `toLocaleString()` in Pulse pages with `formatTz(x, tz)` / `formatDateOnly(x)`. Pulse is a CRM module — all timestamps should respect org timezone.

Since Pulse operates at org level (not necessarily LMSPro), the `displayTimezone` from the org record applies equally.

---

### Phase 9 — Email Scheduling
**Effort: ~2h | Risk: Medium**

`Email.scheduledAt` is a timestamp. The `ComposeEmailModal` currently does not expose a scheduled send UI, but the column exists. When this feature is built:
- The date-time picker must convert from org TZ → UTC before saving `scheduledAt`
- The email queue processor must compare `scheduledAt` against `new Date()` (UTC) — this is already correct if stored in UTC

---

### Phase 10 — Documentation & Testing
**Effort: ~1h**

- Add `// TZ: date-only — use formatDateOnly()` comments above date-only fields in schema
- Add `// TZ: timestamp — use formatTz(x, org.displayTimezone)` for timestamp fields
- Write a one-page ADR (Architecture Decision Record) confirming: UTC storage, IANA per-org display TZ, `date-fns-tz` as the canonical library

---

## 7. Dependency & Package Status

| Package | Current | Used for | Notes |
|---|---|---|---|
| `date-fns` | ✅ installed | `format()`, `formatDistanceToNow()` | Already in use |
| `date-fns-tz` | ✅ installed | `formatInTimeZone`, `fromZonedTime`, `toZonedTime` | Used in embed page + SystemClosedScreen |
| `@mantine/dates` | ✅ installed | `DateInput`, `DatePickerInput`, `DateTimePicker`, `TimeInput` | All pickers in use |

No new packages required.

---

## 8. Risk Assessment

| Risk | Severity | Mitigation |
|---|---|---|
| Date-only fields shift by 1 day | **High** | Use `formatDateOnly()` / `Date.UTC()` consistently — no org TZ involved |
| Key date windows open/close 1hr wrong during BST | **High** | Phase 2 — convert time strings on input/output |
| `makeCurrentUnlocksAt` / `rollForwardUnlocksAt` unlock at wrong time | **Medium** | These are date-only; document that they unlock at UTC midnight (which is 1am BST) — acceptable, or shift to noon UTC |
| Pulse task deadlines shown/set in wrong timezone | **Medium** | Phase 5 — `DateTimePicker` `toUtc`/`fromUtc` binding |
| Server-side error messages using `toLocaleDateString()` (Node.js system locale) | **Low** | Phase 4 — use `formatTz` even in thrown errors |
| Existing stored `activeFromTime` values are already UTC | ✅ Safe | `isWithinKeyDateWindow` uses `setUTCHours` — consistent |

---

## 9. Priority Order for Live System

Given that the live league system is actively in use:

| Priority | Phase | Why |
|---|---|---|
| **P0 — Immediate** | 1 (utilities) | Foundation for all other phases |
| **P0 — Immediate** | 2 (key dates time inputs) | Directly affects registration window accuracy during BST |
| **P1 — This sprint** | 3 (date-only display) | Wrong dates shown to admins — confusing |
| **P1 — This sprint** | 4 (timestamp display) | Admin communications log shows wrong times |
| **P2 — Next sprint** | 5 (DateTimePicker inputs) | Affects Pulse + disciplinary records |
| **P2 — Next sprint** | 6 (season date inputs) | Low impact — date-only, 1hr off only at midnight |
| **P3 — Backlog** | 7–10 | Lower urgency |

---

## 10. File Change Summary

### New Files to Create
- `src/lib/timezone.ts` — shared utility functions
- `src/lib/timezone-context.tsx` — React context + `useOrgTimezone` hook

### Files to Modify (ordered by impact)

#### High Impact
- `src/app/(app)/app/lmspro/seasons/_components/KeyDatesTab.tsx`
- `src/app/(app)/app/lmspro/seasons/_components/ClubRegistrationCard.tsx`
- `src/modules/lmspro/components/dashboard/KeyDatesPanel.tsx`

#### Medium Impact
- `src/app/(app)/app/lmspro/seasons/page.tsx`
- `src/app/(app)/app/lmspro/seasons/[seasonId]/_components/SeasonOverviewTab.tsx`
- `src/app/(app)/app/lmspro/clubs/[clubId]/page.tsx`
- `src/app/(app)/app/lmspro/clubs/page.tsx`
- `src/app/(app)/app/lmspro/teams/page.tsx`
- `src/app/(app)/app/lmspro/communications/page.tsx`
- `src/modules/lmspro/components/dashboard/SeasonOverview.tsx`
- `src/modules/lmspro/components/dashboard/SeasonBanner.tsx`
- `src/modules/lmspro/components/dashboard/TeamVariationsTab.tsx`
- `src/modules/lmspro/routers/seasons.router.ts` (error message)

#### Pulse Module
- `src/app/(app)/app/pulse/tasks/page.tsx`
- `src/app/(app)/app/pulse/leads/page.tsx`
- `src/app/(app)/app/pulse/time/page.tsx`
- `src/app/(app)/app/pulse/projects/page.tsx`
- `src/app/(app)/app/pulse/organisations/page.tsx`
- `src/app/(app)/app/pulse/organisations/[id]/page.tsx`
- `src/app/(app)/app/pulse/pipeline/page.tsx`

#### Core / Platform
- `src/app/(app)/settings/audit-logs/page.tsx`
- `src/core/features/components/visibility-rules.engine.ts` (comment/contract only)

---

## 11. Testing Checklist

For each phase, test with the following scenario:

**Setup:**
- Set `org.displayTimezone` to `Europe/London`
- Run the test during BST (or simulate by setting org TZ to `Europe/London` and mocking `new Date()` to a BST date)

**Key Dates:**
- [ ] Create key date with `activeFromTime = "09:00"` and `activeToDate` = today (BST period)
- [ ] Verify the registration embed shows "opens at 9:00 BST" (not 10:00 BST)
- [ ] Verify `isWithinKeyDateWindow()` returns `true` at 09:01 BST
- [ ] Verify stored `activeFromTime` in DB is `"08:00"` (UTC)

**Season Dates:**
- [ ] Create season with `startDate = 1 September 2025`
- [ ] Verify table shows "01 Sep 2025" regardless of browser timezone
- [ ] Verify `DateInput` picker is pre-filled with correct date (no day-shift)

**Timestamps:**
- [ ] Send an email; verify `sentAt` shown as BST in the Sent tab (e.g. "12:00 BST" not "11:00 UTC")
- [ ] Create a Pulse task `dueAt = 2026-06-01T09:00` BST; verify stored as `T08:00Z` in DB
- [ ] Reload task form; verify picker shows `09:00` (not `08:00`)

---

*Document maintained in `/docs/core/timezone-handling.md`*  
*Cross-reference: `Organisation.displayTimezone` migration `20260528121439`, `SystemClosedScreen.tsx`, `embed/register/club/page.tsx`*
