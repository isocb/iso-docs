# LMSPro: Key Dates — Complete Reference

**Document Type:** Technical Reference  
**Module:** LMSPro  
**Status:** Current  
**Last Updated:** March 2026  
**Related Docs:**
- [Season Lifecycle & Team Registration Workflow](./season-lifecycle-and-team-registration-workflow.md)
- [Unified Timing Architecture](./unified-timing-architecture.md)
- [CR-18 Email Notifications](./planning/CR-18-Email-Notifications-System-Development-Plan.md)

---

## Purpose of This Document

This reference explains:
1. What a Key Date is and every field it contains
2. The three Key Date **types** (Window / Trigger / Reminder) and what each does
3. How Key Dates connect to Action Cards, public forms, dashboard banners, and emails
4. How email automation is attached to Key Dates
5. The standard slug registry (all 23 slugs for the season lifecycle)
6. How to work with an AI agent to configure and build Key Date–driven features

---

## What Is a Key Date?

A **Key Date** (`LMSProKeyDate`) is a configurable date record stored in the database, scoped to a specific season and organisation. It is the single source of truth for **when** anything in LMSPro happens.

There are **no hardcoded calendar dates** in the system. Every form window, Action Card visibility state, email trigger, and dashboard banner countdown is resolved by querying Key Dates at runtime.

> **Analogy:** Think of Key Dates as the league's master calendar. All system behaviour watches this calendar. The League Admin owns it and can adjust any date without a developer.

---

## `LMSProKeyDate` — Field Reference

This is the current database schema for a Key Date record:

```prisma
model LMSProKeyDate {
  id          String   // UUID — primary key
  name        String   // Human-readable name (e.g., "Club Team Registration Window")
  description String?  // Optional explanation shown in admin UI

  // Date range — required on all Key Dates
  activeFrom     DateTime  // The date this Key Date becomes active
  activeFromTime String    // HH:MM (e.g., "09:00") — time of day on activeFrom
  activeTo       DateTime  // The date this Key Date deactivates
  activeToTime   String    // HH:MM (e.g., "23:59") — time of day on activeTo

  // Visibility — who sees this Key Date in the admin list
  visibleTo  KeyDateVisibility  // ALL | LEAGUE_ONLY | CLUB_ONLY

  // Scoping — always set; determines tenant and season
  seasonId       String   // The season this Key Date belongs to
  organizationId String   // The organisation (league) that owns it

  // Relations
  visibilityRules VisibilityRule[]  // Action Cards linked to this Key Date
}
```

### Fields requiring clarification

| Field | Notes |
|-------|-------|
| `name` | Free text, but the system recognises **standard slugs** (see below). Non-standard names work fine but won't auto-link to forms or cards. |
| `activeFrom` + `activeFromTime` | Combined at runtime: `activeFrom` date + `activeFromTime` HH:MM = exact datetime the window opens. **Time of day is critical** for first-come-first-served race conditions (e.g., team registration at 09:00 on 16 May). |
| `activeTo` + `activeToTime` | Same combination. Default `activeToTime` is `23:59` — i.e., end of day. |
| `visibleTo` | Controls which user type sees this Key Date in their **dashboard banner**. Does not affect form gating (public forms are always public). `LEAGUE_ONLY` hides it from club users' banner view. |
| `seasonId` | **All Key Dates are season-scoped.** When a season is cloned, all Key Dates are copied to the new season with dates shifted +12 months as a starting point. League Admin adjusts from there. |
| `visibilityRules` | Zero to many `VisibilityRule` records linking this Key Date to Action Cards/components. See below. |

### Planned additions to schema (not yet built)

| Field | Type | Purpose |
|-------|------|---------|
| `slug` | `String?` | Machine-readable identifier (`team-registration-opens`). Enables auto-linking to forms and cards without UI configuration. |
| `keyDateType` | `KeyDateType` enum | `WINDOW` / `TRIGGER` / `REMINDER` — changes system behaviour. |
| `keyDateSequences` | relation | Links to `EmailSequence` records anchored to this Key Date (see Email Automation section). |

---

## The Three Key Date Types

### Type 1: WINDOW

A **Window** Key Date defines an open/close date range that gates access to something — either a public form (Pattern A) or a dashboard Action Card (Pattern B).

**What it does:**
- Before `activeFrom` + `activeFromTime`: access denied (countdown shown)
- Between `activeFrom` and `activeTo`: access granted
- After `activeTo` + `activeToTime`: access denied ("Closed" shown)

**Pattern A — Public Forms:**
The `TimedFormWrapper` component reads the Key Date via `getFormTiming` (public tRPC endpoint, no auth). The form is replaced with a countdown or "closed" message outside the window.

```
Before window:   [Countdown timer: "Registration opens in 4 days 12:23:05"]
During window:   [Full registration form visible]
After window:    ["Club registration is now closed for this season."]
```

**Pattern B — Dashboard Action Cards:**
The `VisibilityRule` record links this Key Date to a `ComponentDefinition`. The `evaluateComponentTiming()` visibility engine checks the window and returns the card's state.

```
Before window:   Card greyed out, badge: "Opens 16 May 09:00"
During window:   Card fully clickable (green border optional)
Closing soon:    Card amber border, badge: "Closes in 3 days"
After window:    Card greyed out, badge: "Closed"
```

**Who can bypass (Exempt Roles):**
Each `VisibilityRule` has an `exemptRoleIds` array. Users with those Module Roles always see the card as active regardless of the date window. League Admins are typically always exempt.

**Example Window Key Dates:**

| Slug | Opens | Closes | Pattern | Card |
|------|-------|--------|---------|------|
| `team-continuation-opens/closes` | 1 May 00:00 | 15 May 23:59 | B | `teams.continuation` |
| `team-registration-opens/closes` | 16 May 09:00 | 31 May 23:59 | B | `teams.register` |
| `club-registration-opens/closes` | 1 June 09:00 | 1 Aug 23:59 | A | Public form |
| `team-edit-opens/closes` | 1 June 00:00 | 15 Aug 23:59 | B | `teams.edit` |
| `team-approval-opens/closes` | 1 June 00:00 | 15 Aug 23:59 | B | Admin panel |

> **Race condition note:** For windows where clubs compete for limited places (e.g., team registration at 09:00 on 16 May), `activeFromTime` is essential. The system uses the exact combined datetime, not just the date, so a club that submits at 08:59 will be rejected and one at 09:00:01 will be accepted.

---

### Type 2: TRIGGER

A **Trigger** Key Date is a single point in time (not a range) that causes a system action. It fires **once** when `activeFrom` + `activeFromTime` is reached.

**What it does:**
- At the trigger datetime: fires configured system actions (email, notification, status change)
- Shows as a countdown in the dashboard banner before the event
- Shows in banner as "X days ago" or disappears after the event

**Typical uses:**
- Season start announcement email to all clubs
- Playing season start notification
- Season end notification

**Technical implementation:**
A Trigger Key Date fires a `SequenceTrigger.ON_EVENT` EmailSequence (see Email Automation below). A background job polls for Key Dates where `activeFrom` + `activeFromTime` is past and the trigger has not yet fired.

**Example Trigger Key Dates:**

| Slug | Default Date | Who Notified | Action |
|------|-------------|--------------|--------|
| `season-start` | 1 June | All Club Secretaries | Email: "Season open — new registration period starts today" |
| `playing-season-start` | 1st Sunday September | All clubs + teams | Email: "Playing season begins this Sunday" |
| `season-end` | Last Sunday April | All clubs | Email: "Playing season has ended" |

---

### Type 3: REMINDER

A **Reminder** Key Date stores an important date that has **no system gating effect** — it does not open or close a form or card. Its sole purpose is to appear in the **dashboard header banner** as a countdown so club users are aware of an upcoming deadline they need to act on (often outside LMSPro).

**What it does:**
- Shows as a countdown line in the dashboard banner for the configured audience
- Can optionally fire a reminder email (see Email Automation below)
- Can be removed or adjusted by the League Admin without any system consequence

**Why store FA FullTime dates as Key Dates:**
Even though FA FullTime player registration is managed externally, club users check their LMSPro dashboard daily during the season. Storing FA deadlines as Reminder Key Dates means clubs see timely reminders in the one place they already visit — without the league having to send manual emails.

**Example Reminder Key Dates:**

| Slug | Default Date | Banner Label | Audience |
|------|-------------|-------------|----------|
| `player-transfer-deadline` | 1 March | "Player transfer deadline" | CLUB_ONLY |
| `trophies-return` | 1 March | "Trophies return deadline" | CLUB_ONLY |
| `continuation-notice` | 31 March | "Club continuation notice due" | CLUB_ONLY |
| `player-rereg-opens` | 1 April | "Player re-registration opens" | CLUB_ONLY |
| `officer-nominations` | 30 April | "Officer nominations deadline" | LEAGUE_ONLY |
| `rules-submission` | 1 May | "Rule changes submission deadline" | CLUB_ONLY |
| `financial-year-end` | 31 May | "End of financial year" | LEAGUE_ONLY |
| `player-registration-opens` | 1 June | "Online player registration opens" | CLUB_ONLY |
| `agm-deadline` | End of July | "AGM deadline" | LEAGUE_ONLY |
| `player-registration-deadline` | 10 August | "Min. players must be registered" | CLUB_ONLY |

---

## `VisibilityRule` — Field Reference

A `VisibilityRule` is the **link** between a Window Key Date and an Action Card (ComponentDefinition). Without a VisibilityRule, a component has no time gating and is always visible to users with the right role.

```prisma
model VisibilityRule {
  id   String

  // What this rule does
  type String  // Always "KEY_DATE_RANGE" currently

  // Which Key Date controls this rule
  keyDateId String?   // FK → LMSProKeyDate (null = always visible)

  // Offset from the Key Date window (optional)
  offsetDays      Int?    // +/- days. Positive = after window start/end
  offsetFromStart Boolean // true = offset is from activeFrom; false = from activeTo

  // Role exemptions — these Module Role IDs bypass the time gate
  exemptRoleIds String[]  // Array of ModuleRole UUIDs

  // Whether this rule cascades to child components
  cascade Boolean  // true = child components inherit this rule

  // Which component is gated
  componentId    String  // FK → ComponentDefinition
  organizationId String  // FK → Organisation
}
```

### Offset examples

`offsetDays` lets you shift the effective window relative to the Key Date, without creating a separate Key Date record:

| offsetDays | offsetFromStart | Effect |
|-----------|----------------|--------|
| `0` | `true` | Gate starts exactly when Key Date `activeFrom` starts |
| `7` | `false` | Gate closes 7 days **after** Key Date `activeTo` (useful for admin review period) |
| `-2` | `false` | Gate closes 2 days **before** Key Date `activeTo` (early close) |
| `3` | `true` | Gate opens 3 days **after** Key Date `activeFrom` (delayed open) |

**Practical example:** The `team-registration-closes` Key Date is 31 May. The league admin also wants the `teams.approve.view` card to remain visible to League Admins for 7 extra days to review submissions. A VisibilityRule with `offsetDays: 7, offsetFromStart: false` achieves this without creating a new Key Date.

---

## `ComponentDefinition` — Relevant Fields

A `ComponentDefinition` is the Action Card (or any UI component) that gets gated.

```prisma
model ComponentDefinition {
  componentKey  String   // e.g., "teams.register", "teams.edit", "clubs.list.view"
  title         String   // Human-readable label: "Register New Teams"
  pageContext   String   // Where it appears: "LEAGUE_DASHBOARD", "CLUB_DASHBOARD"
  componentType String   // "ACTION" | "WIDGET" | "TABLE" | "CHART"
  capability    ComponentCapability  // VIEW | CREATE | EDIT | DELETE | APPROVE
  grantsActions String[] // Server-side permissions granted when card is actionable

  // RBAC: which Module Roles can access this component at all
  // (separate from time gating — role must grant access before Key Date applies)
  visibilityRules VisibilityRule[]
}
```

### componentKey naming convention

`<domain>.<noun>.<verb>` — left to right, broadest to most specific:

```
clubs.list.view          — View list of clubs
clubs.applications.view  — View club applications list
clubs.applications.approve — Approve/reject club applications
teams.list.view          — View teams
teams.register           — Register new team (Club Secretary)
teams.edit               — Edit/withdraw team
teams.continuation       — Confirm team continuation
teams.approve.action     — Approve/waiting-list/cancel team (League Admin)
```

---

## Email Automation — Key Date Email Sequences (Q10)

### The Design

Key Dates become an email automation scheduler by connecting to the existing `EmailSequence` / `EmailSequenceStep` infrastructure. **No new sequence model is needed** — we use the already-built system with a new `ON_EVENT` trigger convention.

The principle is:

> *"A Key Date can own an `EmailSequence`. Each step in that sequence is one email, with a **signed day offset** relative to the Key Date's open or close anchor. Negative offset = before. Positive offset = after. Zero = on the day."*

#### Example: Team Re-Registration Window (1 May – 15 May)

| Step | Offset | Anchor | Purpose |
|------|--------|--------|---------|
| Email 1 | `-3` days | OPEN (1 May) | Advance warning: "Registration opens in 3 days" |
| Email 2 | `0` days | OPEN (1 May) | Announcement: "Team re-registration is now open" |
| Email 3 | `+7` days | OPEN (1 May) | Mid-window nudge: "One week in — have you confirmed your teams?" |
| Email 4 | `-2` days | CLOSE (15 May) | Final warning: "Registration closes in 2 days" |
| Email 5 | `0` days | CLOSE (15 May) | Close notification: "Re-registration is now closed" |

The system computes the **fire datetime** for each step as:

```
anchorDate + anchorTime + (offsetDays × 24h)
```

Where `anchorDate` + `anchorTime` is either `activeFrom`+`activeFromTime` or `activeTo`+`activeToTime` on the Key Date record.

---

### Integration With Existing `EmailSequence` Infrastructure

The existing schema already supports this with **zero structural changes** to `EmailSequence` or `EmailSequenceStep`. The only additions required are:

1. A foreign key `keyDateId` and `keyDateAnchor` on `EmailSequence` (to know which Key Date and which anchor — OPEN or CLOSE — to compute step fire times from)
2. Allow **negative** `delayDays` values on `EmailSequenceStep` (the DB column is already `Int`, so this is a validation-layer change only)
3. A `keyDateSequences` relation on `LMSProKeyDate`

```prisma
// Addition to EmailSequence model (existing model, new fields only):
keyDateId     String?  @map("key_date_id")  // FK → LMSProKeyDate (null = non-KD sequence)
keyDateAnchor KeyDateSequenceAnchor?  @map("key_date_anchor")  // OPEN | CLOSE

// New enum (public schema):
enum KeyDateSequenceAnchor {
  OPEN   // delayDays is relative to activeFrom + activeFromTime
  CLOSE  // delayDays is relative to activeTo + activeToTime
  @@schema("public")
}
```

> **Important:** A single Key Date can own **multiple** `EmailSequence` records — one anchored to `OPEN` and one anchored to `CLOSE`. This keeps step logic clean (no mixing of OPEN-relative and CLOSE-relative steps in one sequence).

---

### How `EmailSequenceStep.delayDays` works with Key Dates

For Key Date–anchored sequences, the meaning of `delayDays` changes from its normal use (delay from previous step) to **signed offset from the anchor**:

| `delayDays` | `keyDateAnchor` | Fires when |
|-------------|----------------|------------|
| `-7` | `OPEN` | 7 days **before** window opens |
| `-3` | `OPEN` | 3 days **before** window opens |
| `0` | `OPEN` | **On** the day the window opens (at `activeFromTime`) |
| `+3` | `OPEN` | 3 days **after** window opens |
| `-2` | `CLOSE` | 2 days **before** window closes |
| `0` | `CLOSE` | **On** the day the window closes (at `activeToTime`) |
| `+1` | `CLOSE` | 1 day **after** window closes |

> This is a semantic reuse of the existing `delayDays` field. The sequence processor detects that the owning sequence has a `keyDateId` and uses absolute date calculation rather than the normal "delay from previous step" logic.

---

### Recipient Rules Per Step

Each `EmailSequenceStep` targets a recipient group. Rather than a single cohort for the whole sequence, each step can have its own targeting — this is especially useful for mid-window chase-up emails:

```prisma
// Additions to EmailSequenceStep model (new fields only):
recipientGroup     KeyDateRecipientGroup?  // ALL_CLUBS | LEAGUE_ADMINS | CLUBS_NOT_RESPONDED | CUSTOM
customCohortFilter Json?                   @map("custom_cohort_filter")
templateId         String?                 @map("template_id")  // FK → EmailTemplate (optional; if set, overrides bodyHtml)
```

| Step | Recipients |
|------|-----------|
| `-3` from OPEN | `ALL_CLUBS` — advance notice to everyone |
| `0` from OPEN | `ALL_CLUBS` — announcement to everyone |
| `+7` from OPEN | `CLUBS_NOT_RESPONDED` — chase only those who haven't acted |
| `-2` from CLOSE | `CLUBS_NOT_RESPONDED` — final warning only to non-responders |
| `0` from CLOSE | `ALL_CLUBS` — close notification to everyone |

---

### New Enums Required

```prisma
// Already described above:
enum KeyDateSequenceAnchor {
  OPEN    // Relative to activeFrom + activeFromTime
  CLOSE   // Relative to activeTo + activeToTime
  @@schema("public")
}

// Used on EmailSequenceStep (replaces the need for KeyDateRecipientGroup on the old KeyDateEmailTrigger design):
enum KeyDateRecipientGroup {
  ALL_CLUBS            // All Club Secretaries enrolled in this season
  LEAGUE_ADMINS        // All League Admin/Owner users
  CLUBS_NOT_RESPONDED  // Clubs that have not yet acted on the Key Date's process
  CUSTOM               // Ad-hoc filter via customCohortFilter JSON
  @@schema("public")
}
```

---

### How the Sequence Processor Works (Runtime)

The existing `EmailSequence` cron job is extended to handle Key Date–anchored sequences:

1. **At startup / when a Key Date is saved:** For any sequence with a `keyDateId`, pre-compute the fire datetime for each step:
   ```
   if anchor = OPEN:  fireAt = keyDate.activeFrom (date) + keyDate.activeFromTime (HH:MM) + (step.delayDays × 24h)
   if anchor = CLOSE: fireAt = keyDate.activeTo   (date) + keyDate.activeToTime   (HH:MM) + (step.delayDays × 24h)
   ```
   Store as `nextSendAt` on a `SequenceEnrollment` per-step (or as a scheduled job entry).

2. **Cron job (every 5 minutes):** Finds steps where computed `fireAt ≤ now()` and `status = PENDING`.

3. **For each due step:**
   - Resolve recipients using `recipientGroup` (and `customCohortFilter` if `CUSTOM`)
   - For `CLUBS_NOT_RESPONDED`: query the Key Date's linked process (e.g., teams that haven't confirmed continuation) and resolve to those Club Secretaries
   - Use the step's `templateId` (if set) or `bodyHtml`/`subject` directly
   - Create `Email` records and dispatch via existing Resend pipeline
   - Mark step as `SENT` with `firedAt`

4. **Season clone:** When a season is cloned, linked `EmailSequence` records are duplicated (with new `keyDateId` pointing to the cloned season's Key Dates), all steps reset to `PENDING`.

---

### Admin UI for Email Sequences (Key Date detail page)

On the Key Date admin page, an **"Email Schedule"** section appears below the date pickers. It shows both OPEN-anchored and CLOSE-anchored sequences on a unified timeline view:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│ EMAIL SCHEDULE                              [+ Add Email]                   │
│                                                                             │
│  Relative to OPEN (16 May 09:00)                                            │
│  ────────────────────────────────────────────────────────────────────────   │
│  -3d  ✉ "Registration opens in 3 days"   → All clubs        [Edit][Delete] │
│   0   ✉ "Team registration is now open"  → All clubs        [Edit][Delete] │
│  +7d  ✉ "Have you registered your teams?"→ Not responded    [Edit][Delete] │
│                                                                             │
│  Relative to CLOSE (31 May 23:59)                                           │
│  ────────────────────────────────────────────────────────────────────────   │
│  -2d  ✉ "Registration closes in 2 days"  → Not responded    [Edit][Delete] │
│   0   ✉ "Registration has now closed"    → All clubs        [Edit][Delete] │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**"Add Email" modal fields:**

| Field | Input Type | Notes |
|-------|-----------|-------|
| Anchor | Radio | Relative to window OPEN / Relative to window CLOSE |
| Offset (days) | Signed integer | Negative = before anchor, positive = after, 0 = on the day |
| Time | Inherited | Fires at `activeFromTime` or `activeToTime` from the Key Date |
| Recipients | Dropdown | All clubs / League admins / Clubs not responded / Custom filter |
| Content | Toggle | Use saved template / Write custom email |
| Template | Dropdown | Lists all active `EmailTemplate` records |
| Subject / Body | Rich text | Shown if custom content selected |

> For TRIGGER and REMINDER Key Dates (no close date), only OPEN-anchor is offered. `activeTo` is set equal to `activeFrom` for TRIGGER types.

---

## How to Work With an AI Agent on Key Date Features

When you want to build or configure something Key Date–driven, give the agent the following information:

### For a new Window Key Date (form or card gate)

```
I need a new Key Date window that:
  - Slug: <slug>
  - Pattern: A (public form) | B (Action Card)
  - Opens: <date> at <HH:MM>
  - Closes: <date> at <HH:MM>
  - Gates: <form route> | <componentKey>
  - Visible to: ALL | LEAGUE_ONLY | CLUB_ONLY
  - Exempt roles: <list of Module Role names>
  - Email on open: <template name> | none
  - Email N days before close: <template name> | none
```

### For a new Trigger Key Date (one-time event)

```
I need a new Key Date trigger that:
  - Slug: <slug>
  - Fires: <date> at <HH:MM>
  - Visible in banner to: ALL | LEAGUE_ONLY | CLUB_ONLY
  - Banner label: "<text>"
  - Email on fire: <template name> | none
  - Recipients: <group>
```

### For a new Reminder Key Date (banner countdown only)

```
I need a new reminder Key Date that:
  - Slug: <slug>
  - Date: <date>
  - Banner label: "<text>"
  - Visible to: CLUB_ONLY | LEAGUE_ONLY | ALL
  - Email N days before: <template name> | none
  - Recipients: <group>
```

### For a new Action Card linked to a Key Date

```
I need a new Action Card that:
  - componentKey: <key>
  - Title: "<label>"
  - Page: LEAGUE_DASHBOARD | CLUB_DASHBOARD
  - Type: ACTION | WIDGET | TABLE
  - Capability: VIEW | CREATE | EDIT | APPROVE
  - Roles that can see it: <Module Role names>
  - Exempt roles (always see it): <Module Role names>
  - Key Date window: <slug>
  - Offset: <none> | <+/- N days from open/close>
```

### For an email schedule on a Key Date

```
I need an email schedule on Key Date <slug>.
The Key Date window is <open date> to <close date>.

Emails relative to OPEN (<open date> at <HH:MM>):
  - Offset -3d → All clubs    → Template: "<name>" | Custom: subject="<>" body="<>"
  - Offset  0  → All clubs    → Template: "<name>" | Custom: subject="<>" body="<>"
  - Offset +7d → Not responded→ Template: "<name>" | Custom: subject="<>" body="<>"

Emails relative to CLOSE (<close date> at <HH:MM>):
  - Offset -2d → Not responded→ Template: "<name>" | Custom: subject="<>" body="<>"
  - Offset  0  → All clubs    → Template: "<name>" | Custom: subject="<>" body="<>"
```

---

## Complete Slug Registry — All 23 Standard Slugs

### Window Slugs (10) — gate forms and cards

| Slug | Opens | Closes | Pattern | Gates |
|------|-------|--------|---------|-------|
| `team-continuation-opens` | 1 May 00:00 | — | B | `teams.continuation` card opens |
| `team-continuation-closes` | — | 15 May 23:59 | B | `teams.continuation` card closes |
| `team-registration-opens` | 16 May 09:00 | — | B | `teams.register` card opens |
| `team-registration-closes` | — | 31 May 23:59 | B | `teams.register` card closes |
| `club-registration-opens` | 1 June 09:00 | — | A | Public club form opens |
| `club-registration-closes` | — | 1 Aug 23:59 | A | Public club form closes |
| `team-edit-opens` | 1 June 00:00 | — | B | `teams.edit` card opens |
| `team-edit-closes` | — | 15 Aug 23:59 | B | `teams.edit` card closes |
| `team-approval-opens` | 1 June 00:00 | — | B | Admin approval panel open email/banner |
| `team-approval-closes` | — | 15 Aug 23:59 | B | Admin approval panel close email/banner |

> **Note:** Each pair (opens + closes) can be two separate Key Date records, or a single Key Date record where `activeFrom` = open and `activeTo` = close. The system supports both. A single record is simpler to manage.

### Trigger Slugs (3) — fire once at a point in time

| Slug | Default Datetime | Banner Label | Audience |
|------|-----------------|-------------|----------|
| `season-start` | 1 June 00:00 | "Season opens today" | ALL |
| `playing-season-start` | 1st Sunday September | "Playing season begins" | ALL |
| `season-end` | Last Sunday April | "Playing season ends" | ALL |

### Reminder Slugs (10) — banner countdown, no gating

| Slug | Default Date | Banner Label | Audience |
|------|-------------|-------------|----------|
| `player-transfer-deadline` | 1 March | "Player transfer deadline" | CLUB_ONLY |
| `trophies-return` | 1 March | "Trophies return deadline" | CLUB_ONLY |
| `continuation-notice` | 31 March | "Club continuation notice due" | CLUB_ONLY |
| `player-rereg-opens` | 1 April | "Player re-registration opens" | CLUB_ONLY |
| `officer-nominations` | 30 April | "Officer nominations deadline" | LEAGUE_ONLY |
| `rules-submission` | 1 May | "Rule changes submission deadline" | CLUB_ONLY |
| `financial-year-end` | 31 May | "End of financial year" | LEAGUE_ONLY |
| `player-registration-opens` | 1 June | "Online player registration opens" | CLUB_ONLY |
| `agm-deadline` | End of July | "AGM deadline" | LEAGUE_ONLY |
| `player-registration-deadline` | 10 August | "Min. players must be registered by" | CLUB_ONLY |

---

## Schema Changes Required to Build This

The current `LMSProKeyDate` schema needs the following additions. These require a Prisma migration:

### 1. Add `slug` and `keyDateType` to `LMSProKeyDate`

```prisma
// Add to LMSProKeyDate model
slug        String?         // Standard slug e.g. "team-registration-opens"
keyDateType KeyDateType @default(WINDOW) @map("key_date_type")

// New enum
enum KeyDateType {
  WINDOW    // Gates a form or Action Card
  TRIGGER   // Fires once at a point in time
  REMINDER  // Informational banner countdown only

  @@schema("lmspro")
}
```

### 2. Add `keyDateSequences` relation to `LMSProKeyDate`

```prisma
// Add to LMSProKeyDate model
keyDateSequences EmailSequence[]
```

### 3. Extend `EmailSequence` with Key Date anchor fields

```prisma
// Add to existing EmailSequence model (public schema)
keyDateId     String?               @map("key_date_id")   // FK → LMSProKeyDate
keyDateAnchor KeyDateSequenceAnchor? @map("key_date_anchor")

// New enum (public schema)
enum KeyDateSequenceAnchor {
  OPEN   // Steps relative to activeFrom + activeFromTime
  CLOSE  // Steps relative to activeTo + activeToTime
  @@schema("public")
}
```

### 4. Extend `EmailSequenceStep` with recipient and template fields

```prisma
// Add to existing EmailSequenceStep model (public schema)
recipientGroup     KeyDateRecipientGroup? @map("recipient_group")
customCohortFilter Json?                  @map("custom_cohort_filter")
templateId         String?                @map("template_id")  // FK → EmailTemplate

// New enum (public schema)
enum KeyDateRecipientGroup {
  ALL_CLUBS            // All Club Secretaries enrolled in this season
  LEAGUE_ADMINS        // All League Admin/Owner users
  CLUBS_NOT_RESPONDED  // Clubs that have not yet acted on the Key Date's process
  CUSTOM               // Ad-hoc filter via customCohortFilter JSON
  @@schema("public")
}
```

> **Note:** `EmailSequenceStep.delayDays` is already an `Int` column and already supports negative values at the database level. The only change needed is to allow negative input in the admin UI and sequence processor.

### 5. Season clone update

`keyDates.duplicateToSeason` must also duplicate any `EmailSequence` records linked via `keyDateId` (copying their steps and resetting all enrollment/fire state).

---

## Related Design Decisions (from Season Lifecycle doc)

| # | Question | Answer |
|---|----------|--------|
| Q10 | Does the Key Date have an email trigger function? | **Yes** — via `EmailSequence` (existing model). A Key Date owns one or more `EmailSequence` records, each anchored to OPEN or CLOSE. Each sequence has N `EmailSequenceStep` records with **signed `delayDays`** (negative = before anchor, zero = on the day, positive = after anchor). This reuses the existing email sequence processor — no new model required. |
| Q11 | Does the form open at midnight or a specific time on 1 June? | **Specific time** — `activeFromTime` is `HH:MM` and is combined with `activeFrom` at runtime. League Admin sets the time. Suggested: `09:00` for competitive windows. |
| Q12 | Do clubs who apply before 1 August but aren't actioned remain in the approval queue? | **Yes** — the application form closes (`club-registration-closes`) but the admin approval queue is not date-gated. All `EMAIL_VERIFIED` applications remain visible until actioned. |
| Q13 | Does `team-edit-closes` (15 Aug) also close the `teams.register` card? | **Yes** — single `team-edit-closes` date controls both. DJFL uses one date for "add or withdraw". The `teams.register` and `teams.edit` cards both use the same closing Key Date. |

---

*This document is the definitive reference for Key Date configuration, types, and email automation design. Update when schema changes are made or new slug types are added.*
