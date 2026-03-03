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
| `emailTriggers` | relation | Links to `KeyDateEmailTrigger` records (see Email Automation section). |

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

## Email Automation — Attaching Emails to Key Dates (Q10)

### The Design

Key Dates become the email automation engine by connecting to the existing `Email` / `EmailSequence` infrastructure via a new `KeyDateEmailTrigger` join table. This requires **minimal new code** — it uses existing models virtually unchanged.

The principle is:

> *"When Key Date X fires (or opens, or is N days away), send email Y to recipient group Z."*

League Admins configure this on the Key Date admin page by attaching one or more email triggers. Each trigger specifies:
1. **When** it fires relative to the Key Date
2. **What** to send (ad-hoc body, or use an existing `EmailTemplate`)
3. **Who** receives it (a recipient picker using existing cohort/role groups)

---

### New: `KeyDateEmailTrigger` — Proposed Schema

```prisma
model KeyDateEmailTrigger {
  id           String  @id @default(uuid())
  keyDateId    String  @map("key_date_id")
  organizationId String @map("organization_id")

  // WHEN to fire (relative to the Key Date)
  timing     KeyDateEmailTiming  // ON_OPEN | ON_CLOSE | BEFORE_OPEN | BEFORE_CLOSE | AFTER_OPEN | AFTER_CLOSE
  offsetDays  Int    @default(0)   // Days before/after the timing anchor
  offsetHours Int    @default(0)   // Hours before/after (combined with days)

  // WHAT to send
  mode        KeyDateEmailMode   // USE_TEMPLATE | CUSTOM_BODY
  templateId  String?            // FK → EmailTemplate (if mode = USE_TEMPLATE)
  subject     String?            // Used if mode = CUSTOM_BODY
  bodyHtml    String?  @db.Text  // Used if mode = CUSTOM_BODY

  // WHO receives it
  recipientGroup  KeyDateRecipientGroup  // ALL_CLUBS | ALL_SECRETARIES | LEAGUE_ADMINS | CLUBS_NOT_RESPONDED | CUSTOM
  customCohortFilter Json?               // For CUSTOM — same structure as Email.cohortFilter

  // State tracking
  status      KeyDateEmailTriggerStatus @default(PENDING)  // PENDING | SENT | SKIPPED | FAILED
  firedAt     DateTime?  @map("fired_at")
  emailId     String?    // FK → Email (the Email record created when fired)

  // Audit
  createdAt   DateTime @default(now())
  createdBy   String?

  // Relations
  keyDate      LMSProKeyDate  @relation(fields: [keyDateId], references: [id], onDelete: Cascade)
  template     EmailTemplate? @relation(fields: [templateId], references: [id], onDelete: SetNull)
  email        Email?         @relation(fields: [emailId], references: [id], onDelete: SetNull)
  organization Organization   @relation(fields: [organizationId], references: [id], onDelete: Cascade)

  @@index([keyDateId])
  @@index([status])
  @@map("key_date_email_triggers")
  @@schema("lmspro")
}
```

### Enums for email triggers

```prisma
enum KeyDateEmailTiming {
  ON_OPEN         // Fires at activeFrom + activeFromTime (the window opens)
  ON_CLOSE        // Fires at activeTo + activeToTime (the window closes)
  BEFORE_OPEN     // Fires N days/hours before window opens
  BEFORE_CLOSE    // Fires N days/hours before window closes
  AFTER_OPEN      // Fires N days/hours after window opens (e.g., reminder to those who haven't acted)
  AFTER_CLOSE     // Fires N days/hours after window closes

  @@schema("lmspro")
}

enum KeyDateEmailMode {
  USE_TEMPLATE    // Pick from EmailTemplate library
  CUSTOM_BODY     // Enter subject + body directly on the Key Date

  @@schema("lmspro")
}

enum KeyDateRecipientGroup {
  ALL_CLUBS           // All Club Secretaries for this season
  LEAGUE_ADMINS       // All League Admin/Owner users
  ALL_SECRETARIES     // All Club Secretaries (alias of ALL_CLUBS for clarity)
  CLUBS_NOT_RESPONDED // Clubs that have not yet acted on this Key Date's process
  CUSTOM              // Ad-hoc filter via cohortFilter JSON

  @@schema("lmspro")
}

enum KeyDateEmailTriggerStatus {
  PENDING   // Not yet fired
  SENT      // Email created and dispatched
  SKIPPED   // Condition not met (e.g., all clubs responded, nothing to send)
  FAILED    // Error during dispatch

  @@schema("lmspro")
}
```

### How it works at runtime

1. A background job (cron every 5 minutes) queries `KeyDateEmailTrigger` records where:
   - `status = PENDING`
   - The computed fire datetime (Key Date anchor ± offsetDays/offsetHours) ≤ `now()`
2. For each due trigger, it:
   - Resolves the recipient list using `recipientGroup` + `cohortFilter`
   - Creates an `Email` record (using template body or custom body)
   - Creates `EmailRecipient` records for each resolved recipient
   - Sets `Email.status = SCHEDULED` (immediate) or `SENDING`
   - Updates `KeyDateEmailTrigger.status = SENT`, stores `firedAt` and `emailId`
3. The existing email dispatch pipeline handles actual sending via Resend

### Admin UI for email triggers (Key Date detail page)

On the Key Date admin page, a new **"Email Triggers"** section appears below the date pickers:

```
┌─────────────────────────────────────────────────────────────────────────┐
│ EMAIL TRIGGERS                                                          │
│                                                                         │
│ ┌─────────────────────────────────────────────────────────────────────┐ │
│ │ ✉ When window opens → All Club Secretaries                         │ │
│ │   Template: "Team Registration Now Open"        [Edit] [Remove]    │ │
│ ├─────────────────────────────────────────────────────────────────────┤ │
│ │ ✉ 2 days before window closes → Clubs not yet responded            │ │
│ │   Subject: "Reminder: Team registration closes in 2 days"          │ │
│ │   [Custom body]                                 [Edit] [Remove]    │ │
│ └─────────────────────────────────────────────────────────────────────┘ │
│                                                   [+ Add Email Trigger] │
└─────────────────────────────────────────────────────────────────────────┘
```

**"+ Add Email Trigger" modal fields:**

| Field | Input Type | Options |
|-------|-----------|---------|
| When | Dropdown | On window open / On window close / N days before open / N days before close / N days after open / N days after close |
| N days/hours | Number inputs | Only shown if timing is relative |
| Content | Toggle | Use email template / Write custom email |
| Template | Dropdown | Lists all active `EmailTemplate` records |
| Recipients | Dropdown | All clubs / All league admins / Clubs not yet responded / Custom filter |

> **Custom filter** uses the same `cohortFilter` JSON structure already implemented in `Email.cohortFilter`, so the recipient picker is existing code reused.

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

### For email trigger configuration on an existing Key Date

```
I need an email trigger on Key Date <slug>:
  - Timing: ON_OPEN | ON_CLOSE | BEFORE_OPEN <N days> | BEFORE_CLOSE <N days>
  - Content: USE_TEMPLATE <template name> | CUSTOM: subject="<>" body="<>"
  - Recipients: ALL_CLUBS | LEAGUE_ADMINS | CLUBS_NOT_RESPONDED | CUSTOM <filter>
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

### 2. Add `KeyDateEmailTrigger` model

See full schema definition in the Email Automation section above.

### 3. Season clone update

`keyDates.duplicateToSeason` must also copy `KeyDateEmailTrigger` records (resetting `status` to `PENDING`, clearing `firedAt` and `emailId`).

---

## Related Design Decisions (from Season Lifecycle doc)

| # | Question | Answer |
|---|----------|--------|
| Q10 | Does the Key Date have an email trigger function? | **Yes** — via `KeyDateEmailTrigger`. Attach template or custom body + recipient group directly to the Key Date. The Key Date becomes the email automation tool. |
| Q11 | Does the form open at midnight or a specific time on 1 June? | **Specific time** — `activeFromTime` is `HH:MM` and is combined with `activeFrom` at runtime. League Admin sets the time. Suggested: `09:00` for competitive windows. |
| Q12 | Do clubs who apply before 1 August but aren't actioned remain in the approval queue? | **Yes** — the application form closes (`club-registration-closes`) but the admin approval queue is not date-gated. All `EMAIL_VERIFIED` applications remain visible until actioned. |
| Q13 | Does `team-edit-closes` (15 Aug) also close the `teams.register` card? | **Yes** — single `team-edit-closes` date controls both. DJFL uses one date for "add or withdraw". The `teams.register` and `teams.edit` cards both use the same closing Key Date. |

---

*This document is the definitive reference for Key Date configuration, types, and email automation design. Update when schema changes are made or new slug types are added.*
