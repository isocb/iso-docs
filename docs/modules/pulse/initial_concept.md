---
title: Pulse Module Specification
version: 1.0.0
status: IMPLEMENTATION READY
last_updated: 2026-01-14
module_slug: pulse
description: Lightweight CRM + time tracker for enquiry-to-delivery workflow
priority: URGENT - Internal tool needed ASAP
---

# Pulse Module - Implementation Specification

## Module Registration

```typescript
// src/modules/pulse/module.config.ts
export const pulseConfig = {
  id: 'pulse',
  slug: 'pulse',
  name: 'Pulse',
  description: 'Lightweight CRM + time tracker for enquiries, quotes, and project delivery',
  icon: 'IconActivity',
  primaryColor: '#4DABF7',
  secondaryColor: '#74C0FC',
  typographyColor: '#1971C2',
  platformRoute: null,
  tenantRoute: '/app/pulse',
  userRoute: '/app/pulse',
  schemas: ['pulse'],
  version: '1.0.0',
  category: 'Business',
  enabled: true,
  isPremium: false,
  isTrial: false,
};
```

## Dynamic Navigation

```typescript
// Add to src/core/config/module-navigation.ts
export const pulseNavigation: ModuleNavigation = {
  moduleSlug: 'pulse',
  items: [
    { href: '/app/pulse', label: 'Today', icon: 'IconHome' },
    { href: '/app/pulse/pipeline', label: 'Pipeline', icon: 'IconChartLine' },
    { href: '/app/pulse/leads', label: 'Leads', icon: 'IconUsers' },
    { href: '/app/pulse/quotes', label: 'Quotes', icon: 'IconFileText' },
    { href: '/app/pulse/projects', label: 'Projects', icon: 'IconFolder' },
    { href: '/app/pulse/time', label: 'Time', icon: 'IconClock' },
    { href: '/app/pulse/reports', label: 'Reports', icon: 'IconChartBar', adminOnly: true },
    { href: '/app/pulse/settings', label: 'Settings', icon: 'IconSettings', adminOnly: true },
  ],
};

// Register in MODULE_NAVIGATION_REGISTRY
export const MODULE_NAVIGATION_REGISTRY: Record<string, ModuleNavigation> = {
  // ... existing modules
  pulse: pulseNavigation,
};
```

## Purpose

A lightweight module to manage:

* **Enquiries → Quotes → Won/Lost** (simple sales pipeline)
* **Shared notes & next steps** for Sue + Chris
* **Time logging** on opportunities/projects (start/end, notes, category)

Non-goals:

* No email marketing, sequences, forecasting, complex deal stages, or “accounting-lite”.

---

## Core objects (data model)

### 1) Contact

Represents a person.

```prisma
model PulseContact {
  id              String   @id @default(cuid())
  name            String
  email           String?
  phone           String?
  organizationId  String   // CRITICAL: Multi-tenant scoping
  pulseOrgId      String?  // FK to PulseOrganisation
  roleTitle       String?
  tags            String[]
### 2) Organisation

Represents the client company/charity.

```prisma
model PulseOrganisation {
  id              String   @id @default(cuid())
  organizationId  String   // CRITICAL: Multi-tenant scoping
  name            String
  website         String?
  address         String?
  sector          String?
  status          PulseOrgStatus @default(PROSPECT)
### 3) Lead

The initial enquiry (before it becomes a quote/project).

```prisma
model PulseLead {
  id              String   @id @default(cuid())
  organizationId  String   // CRITICAL: Multi-tenant scoping
  source          PulseLeadSource
  summary         String
  detail          String?
  receivedAt      DateTime @default(now())
  pulseOrgId      String?
  contactId       String?
  ownerUserId     String
  stage           PulseLeadStage @default(NEW)
  priority        PulsePriority @default(MEDIUM)
  nextActionAt    DateTime?
  nextActionNote  String?
  valueEstimate   Decimal? @db.Decimal(10, 2)
  closeReason     String?
  createdAt       DateTime @default(now())
  updatedAt       DateTime @updatedAt
  
  organization     Organization @relation(fields: [organizationId], references: [id])
  pulseOrganisation PulseOrganisation? @relation(fields: [pulseOrgId], references: [id])
  owner            User @relation(fields: [ownerUserId], references: [id])
  quotes           PulseQuote[]
  notes            PulseNote[]
  tasks            PulseTask[]
  timeEntries      PulseTimeEntry[]
  
  @@index([organizationId])
### 4) Quote

A structured quote record (keep it simple).

```prisma
model PulseQuote {
  id              String   @id @default(cuid())
  organizationId  String   // CRITICAL: Multi-tenant scoping
  leadId          String
  quoteRef        String   // e.g., ISO-2026-0012
  status          PulseQuoteStatus @default(DRAFT)
  sentAt          DateTime?
  acceptedAt      DateTime?
  declinedAt      DateTime?
  amountNet       Decimal @db.Decimal(10, 2)
  vatRate         Decimal @default(20) @db.Decimal(5, 2)
### 5) Project (lightweight delivery container)

Created when a quote is accepted (or manually for internal jobs).

```prisma
model PulseProject {
  id              String   @id @default(cuid())
  organizationId  String   // CRITICAL: Multi-tenant scoping
  pulseOrgId      String?
  leadId          String?
  quoteId         String?  @unique
  name            String
  status          PulseProjectStatus @default(ACTIVE)
  startDate       DateTime?
### 6) Note (shared notes + meeting notes + call logs)

One note type used everywhere.

```prisma
model PulseNote {
  id              String   @id @default(cuid())
  organizationId  String   // CRITICAL: Multi-tenant scoping
  entityType      PulseNoteEntity
  leadId          String?
  pulseOrgId      String?
  projectId       String?
  noteType        PulseNoteType @default(GENERAL)
  content         String   // Markdown
  createdByUserId String
  isPinned        Boolean @default(false)
  createdAt       DateTime @default(now())
  updatedAt       DateTime @updatedAt
  
  organization     Organization @relation(fields: [organizationId], references: [id])
  lead             PulseLead? @relation(fields: [leadId], references: [id])
  pulseOrganisation PulseOrganisation? @relation(fields: [pulseOrgId], references: [id])
  project          PulseProject? @relation(fields: [projectId], references: [id])
  createdBy        User @relation(fields: [createdByUserId], references: [id])
  
  @@index([organizationId])
  @@index([leadId])
  @@index([projectId])
  @@map("pulse_notes")
}

enum PulseNoteEntity {
  LEAD
  ORGANISATION
  CONTACT
### 7) Task (next steps)

Simple, not a full task manager.

```prisma
model PulseTask {
  id              String   @id @default(cuid())
  organizationId  String   // CRITICAL: Multi-tenant scoping
  entityType      PulseTaskEntity
  leadId          String?
  projectId       String?
  title           String
  dueAt           DateTime?
  ownerUserId     String
  status          PulseTaskStatus @default(OPEN)
  completedAt     DateTime?
  createdAt       DateTime @default(now())
  updatedAt       DateTime @updatedAt
  
  organization     Organization @relation(fields: [organizationId], references: [id])
  lead             PulseLead? @relation(fields: [leadId], references: [id])
  project          PulseProject? @relation(fields: [projectId], references: [id])
  owner            User @relation(fields: [ownerUserId], references: [id])
  
  @@index([organizationId])
  @@index([ownerUserId])
  @@index([dueAt])
  @@map("pulse_tasks")
}

enum PulseTaskEntity {
  LEAD
  ORGANISATION
  PROJECT
}

enum PulseTaskStatus {
  OPEN
  DONE
  BLOCKED
}
```
}
```
  @@index([organizationId])
  @@index([pulseOrgId])
  @@map("pulse_projects")
}

enum PulseProjectStatus {
  ACTIVE
  ON_HOLD
  COMPLETED
}
```zationId, quoteRef])
  @@index([organizationId])
  @@index([leadId])
  @@map("pulse_quotes")
}

enum PulseQuoteStatus {
  DRAFT
  SENT
  ACCEPTED
  DECLINED
  SUPERSEDED
}
```
  QUALIFIED
  QUOTING
  ON_HOLD
  CLOSED_WON
  CLOSED_LOST
}

enum PulsePriority {
  LOW
  MEDIUM
  HIGH
}
```
}
```
```

### 2) Organisation

Represents the client company/charity.

* `id`
* `name`
* `website`
* `address` (optional)
* `sector` (optional)
* `status` (Active / Prospect / Dormant)
* `primary_contact_id` (optional)
* `tags[]`

### 3) Lead

The initial enquiry (before it becomes a quote/project).

* `id`
* `source` (Referral / Website / Email / Existing / Other)
* `summary` (one-liner)
* `detail` (free text)
* `received_at`
* `organisation_id` (optional)
* `contact_id` (optional)
* `owner_user_id` (Sue or Chris)
* `stage` (New → Qualified → Quoting → On Hold → Closed)
* `priority` (Low/Med/High)
* `next_action_at` (datetime)
* `next_action_note` (short)
* `value_estimate` (optional)
* `close_reason` (if closed)

### 4) Quote

A structured quote record (keep it simple).

* `id`
* `lead_id` (FK)
* `quote_ref` (human readable, e.g. `ISO-2026-0012`)
* `status` (Draft / Sent / Accepted / Declined / Superseded)
* `sent_at`, `accepted_at`
* `amount_net` + `vat_rate` + `amount_gross`
* `scope_summary` (short)
* `assumptions` (optional)
* `delivery_notes` (optional)
* `attachment_links[]` (or R2 files later)
* `probability` (optional, 10–90% slider)

### 5) Project (lightweight delivery container)

Created when a quote is accepted (or manually for internal jobs).

* `id`
* `organisation_id`
* `lead_id` (optional)
* `quote_id` (optional)
* `name`
* `status` (Active / On Hold / Completed)
* `start_date`, `target_end_date`
* `default_rate` (optional)
* `internal_notes`

### 6) Note (shared notes + meeting notes + call logs)
## Configuration tables

```prisma
model PulseTimeCategory {
  id              String   @id @default(cuid())
  organizationId  String   // CRITICAL: Multi-tenant scoping
  name            String
  billableDefault Boolean @default(true)
  color           String?  // Hex color
  sortOrder       Int @default(0)
  isActive        Boolean @default(true)
  createdAt       DateTime @default(now())
  
  organization     Organization @relation(fields: [organizationId], references: [id])
  timeEntries      PulseTimeEntry[]
  timerSessions    PulseTimerSession[]
  
  @@index([organizationId])
  @@map("pulse_time_categories")
}

model PulseSettings {
  id              String   @id @default(cuid())
  organizationId  String   @unique // One per tenant
  vatRate         Decimal @default(20) @db.Decimal(5, 2)
  quotePrefix     String @default("ISO")
  quoteCounter    Int @default(0)
  quoteYearReset  Boolean @default(true)
  defaultCurrency String @default("GBP")
  createdAt       DateTime @default(now())
  updatedAt       DateTime @updatedAt
  
  organization     Organization @relation(fields: [organizationId], references: [id])
  
  @@map("pulse_settings")
}
```Idea / Risk / General)
* `content` (markdown)
* `created_by_user_id`
* `created_at`
* `visibility` (Internal only — default)
* `pinned` (bool)

### 7) Task (next steps)

Simple, not a full task manager.

* `id`
* `entity_type`, `entity_id`
* `title`
* `due_at`
* `owner_user_id`
* `status` (Open / Done / Blocked)
* `created_at`, `completed_at`

### 8) Time Entry (the time tracker)

---

# IMPLEMENTATION PLAN

## Phase 1: Foundation & Scaffolding (Week 1)
**Goal:** Get module skeleton working, see it in sidebar

### Database Setup
- [ ] Create complete Prisma schema (all models above)
- [ ] Add enums to schema
- [ ] Run migration: `npm run db:migrate:dev --name pulse_initial_schema`
- [ ] Seed default time categories (Discovery, Admin, Design, Build, Support, Meeting)

### Module Registration
- [ ] Create `src/modules/pulse/module.config.ts`
- [ ] Register in module catalogue seed data
- [ ] Add to `src/core/config/module-navigation.ts`
- [ ] Import required Tabler icons in Navbar.tsx (`IconActivity`, `IconChartLine`, `IconClock`)
- [ ] Run seed: `npm run db:seed`

### Basic Structure
- [ ] Create folder: `src/modules/pulse/`
- [ ] Create: `src/modules/pulse/routers/index.ts` (empty for now)
- [ ] Register router in `src/server/core/routers/index.ts`
- [ ] Create: `src/app/(app)/app/pulse/page.tsx` (placeholder "Today" page)
- [ ] Test: Navigate to `/app/pulse` - should see "Coming soon" placeholder

**Success Criteria:** Pulse appears in module switcher, clicking it shows placeholder page.

---

## Phase 2: Core Entities CRUD (Week 2)
**Goal:** Create/list organisations, contacts, leads

### Organisations
- [ ] Create router: `src/modules/pulse/routers/organisations.router.ts`
  - [ ] `list` - with search/filter
  - [ ] `get` - by ID
  - [ ] `create` - new org
  - [ ] `update` - edit org
  - [ ] `archive` - soft delete
- [ ] Create page: `src/app/(app)/app/pulse/organisations/page.tsx`
- [ ] Use DataTable with click-to-modal pattern
- [ ] CRUD modal with form (name, website, sector, status)

### Contacts
- [ ] Create router: `src/modules/pulse/routers/contacts.router.ts`
- [ ] Create page: `src/app/(app)/app/pulse/contacts/page.tsx`
- [ ] Link contacts to organisations (select dropdown)

### Leads
- [ ] Create router: `src/modules/pulse/routers/leads.router.ts`
- [ ] Create page: `src/app/(app)/app/pulse/leads/page.tsx`
- [ ] Form fields: summary, detail, source, owner, priority, next action
- [ ] Link to organisation/contact (optional)

**Success Criteria:** Can create and list orgs/contacts/leads. Click row opens edit modal.

---

## Phase 3: Pipeline Board (Week 3)
**Goal:** Visual pipeline with drag-drop

### Pipeline View
- [ ] Create page: `src/app/(app)/app/pulse/pipeline/page.tsx`
- [ ] Use Mantine Grid for columns (NEW, QUALIFIED, QUOTING, SENT, WON, LOST)
- [ ] Card component for each lead (show: org, summary, owner, value, next action)
- [ ] Implement drag-drop (use `@dnd-kit/core` or simple mouse events)
- [ ] Update lead stage on drop
- [ ] Auto-create audit log entry: "Stage changed from X to Y"

### Lead Detail Modal
- [ ] Click card → open detail modal (not separate page)
- [ ] Tabs: Overview | Notes | Tasks | Quotes | Time
- [ ] Overview tab: all lead fields, edit inline

**Success Criteria:** Drag lead cards between columns, stage updates, see it in lead list.

---

## Phase 4: Notes & Tasks (Week 3)
**Goal:** Add notes and tasks to leads/projects

### Notes Component (Reusable)
- [ ] Create router: `src/modules/pulse/routers/notes.router.ts`
- [ ] Create component: `src/modules/pulse/components/NotesSection.tsx`
- [ ] Props: `entityType`, `entityId`
- [ ] List notes (newest first, pinned at top)
- [ ] Add note (markdown editor - use Mantine RichTextEditor or simple textarea)
- [ ] Pin/unpin toggle
- [ ] Note type selector (Call, Meeting, Email, etc.)

### Tasks Component (Reusable)
- [ ] Create router: `src/modules/pulse/routers/tasks.router.ts`
- [ ] Create component: `src/modules/pulse/components/TasksSection.tsx`
- [ ] List tasks (open at top, completed at bottom)
- [ ] Add task (title, due date, owner)
- [ ] Mark complete (checkbox)
- [ ] Overdue tasks highlighted in red

### Integration
- [ ] Add Notes tab to lead detail modal
- [ ] Add Tasks tab to lead detail modal

**Success Criteria:** Can add notes/tasks to leads, see them in tabs, mark tasks complete.

---

## Phase 5: Quotes (Week 4)
**Goal:** Create quotes, send, accept/decline

### Quotes Router & UI
- [ ] Create router: `src/modules/pulse/routers/quotes.router.ts`
  - [ ] `create` - generate quote ref automatically (ISO-2026-0001, etc.)
  - [ ] `list` - all quotes for org
  - [ ] `update` - edit amounts, status
  - [ ] `markSent` - set sentAt timestamp
  - [ ] `markAccepted` - set acceptedAt timestamp
  - [ ] `markDeclined` - set declinedAt timestamp
- [ ] Create page: `src/app/(app)/app/pulse/quotes/page.tsx`
- [ ] Quote modal: Net amount, VAT rate, Gross (auto-calculated), scope, assumptions

### Quote Reference Numbering
- [ ] Create utility: `src/modules/pulse/lib/generateQuoteRef.ts`
- [ ] Logic: `{prefix}-{year}-{counter:04d}` (e.g., ISO-2026-0012)
- [ ] Atomic increment of PulseSettings.quoteCounter
- [ ] Handle year reset if enabled

### Quotes Tab in Lead
- [ ] Add Quotes tab to lead detail modal
- [ ] List all quotes for this lead
- [ ] Button: "Create Quote"
- [ ] Status badges (Draft=gray, Sent=blue, Accepted=green, Declined=red)

**Success Criteria:** Can create quote from lead, see quote ref generated, change status.

---

## Phase 6: Projects & Quote Conversion (Week 4)
**Goal:** Accept quote → create project

### Projects
- [ ] Create router: `src/modules/pulse/routers/projects.router.ts`
- [ ] Create page: `src/app/(app)/app/pulse/projects/page.tsx`
- [ ] Project form: name, org, start date, target end, default rate
- [ ] Project detail page/modal with Notes + Tasks tabs

### Quote → Project Flow
- [ ] When quote status changes to ACCEPTED:
  - [ ] Show modal: "Create Project from Quote?"
  - [ ] Pre-fill: name (from quote scope), org, default rate
  - [ ] Create project with quoteId link
  - [ ] Update lead stage to CLOSED_WON
- [ ] Button in quote detail: "Create Project"

**Success Criteria:** Accept quote, click create project, project appears in projects list.

---

## Phase 7: Time Tracking (Week 5)
**Goal:** Manual time entry + timer

### Time Categories Setup
- [ ] Settings page: `/app/pulse/settings` (create if not exists)
- [ ] Tab: Time Categories
- [ ] CRUD table for categories (name, billable default, color, sort order)
- [ ] Seed defaults: Discovery (billable), Admin (non-billable), Design, Build, Support, Meeting

### Manual Time Entry
- [ ] Create router: `src/modules/pulse/routers/time.router.ts`
- [ ] Create page: `src/app/(app)/app/pulse/time/page.tsx`
- [ ] DataTable: list all time entries (filter by project, user, date range)
- [ ] Add entry modal: project/lead, category, start time, end time, notes, billable toggle
- [ ] Auto-calculate duration from start/end
- [ ] Show duration in hours:minutes (e.g., "2h 30m")

### Timer
- [ ] Create router: `src/modules/pulse/routers/timer.router.ts`
  - [ ] `start` - create TimerSession
  - [ ] `stop` - update stoppedAt, create TimeEntry
  - [ ] `getCurrent` - get running timer for user
- [ ] Create component: `src/modules/pulse/components/Timer.tsx`
  - [ ] Show elapsed time (update every second)
  - [ ] Start button: select project/lead + category
  - [ ] Stop button: add notes, creates time entry
- [ ] Add timer widget to Today page (top of page, always visible if running)

**Success Criteria:** Start timer, see it running, stop it, entry appears in time log.

---

## Phase 8: Today Dashboard (Week 5)
**Goal:** Actionable home page

### Today Page Components
- [ ] Active timer widget (if running - show elapsed, stop button)
- [ ] My tasks widget (due today + overdue, click to mark complete)
- [ ] Next actions widget (leads with next_action_at <= today, click to open lead)
- [ ] Recent activity (last 10 updates - new leads, quotes sent, projects started)
- [ ] Quick actions: Start Timer, New Lead, New Quote

**Success Criteria:** Today page shows relevant info, click items to navigate, start timer quickly.

---

## Phase 9: Reports (Week 6)
**Goal:** Basic sales + time reports

### Sales Reports
- [ ] Create page: `/app/pulse/reports/page.tsx`
- [ ] Tabs: Sales | Time
- [ ] Sales tab:
  - [ ] Leads by stage (pie chart or bar chart)
  - [ ] Quotes sent vs accepted (this month, last month)
  - [ ] Average time from enquiry to quote
  - [ ] Win rate (accepted / total quotes sent)
  - [ ] Value in pipeline (sum of leads in QUOTING stage)

### Time Reports
- [ ] Time tab:
  - [ ] This week: total hours by category (table)
  - [ ] This week: total hours by user (Sue vs Chris)
  - [ ] This month: same as above
  - [ ] Per project: total time logged vs quoted allowance (if set)
  - [ ] Pre-sales time: hours logged against leads (not projects)
  - [ ] Billable vs non-billable split

**Success Criteria:** See reports, numbers look correct, can filter by date range.

---

## Phase 10: Settings & Polish (Week 6-7)
**Goal:** Configure module, final touches

### Settings Page
- [ ] Time Categories (already done in Phase 7)
- [ ] General Settings tab:
  - [ ] VAT rate (editable)
  - [ ] Quote prefix (e.g., "ISO")
  - [ ] Quote counter reset yearly (toggle)
  - [ ] Default currency (GBP for now)

### Polish
- [ ] Tooltips: Add `componentId` to key UI elements (pipeline board, timer, lead form)
  - [ ] `pulse.pipeline.board`
  - [ ] `pulse.timer.widget`
  - [ ] `pulse.lead.form`
  - [ ] `pulse.quote.create`
- [ ] IsoCare: Add `data-ui-tag` to critical areas (later, not urgent)
- [ ] Error handling: Show notifications on save/delete errors
- [ ] Loading states: Skeletons on lists while data fetches
- [ ] Empty states: "No leads yet - create your first one!"
- [ ] Confirm dialogs: "Delete quote?" with undo option

**Success Criteria:** Settings work, tooltips discoverable, UI feels polished.

---

## Timeline Summary

| Phase | Duration | Milestone |
|-------|----------|-----------|
| 1. Foundation | Week 1 | Module visible in nav |
| 2. Core CRUD | Week 2 | Orgs/Contacts/Leads working |
| 3. Pipeline | Week 3 | Drag-drop pipeline board |
| 4. Notes/Tasks | Week 3 | Can add notes and tasks |
| 5. Quotes | Week 4 | Create and manage quotes |
| 6. Projects | Week 4 | Quote → Project conversion |
| 7. Time Tracking | Week 5 | Manual + timer time entry |
| 8. Today Dashboard | Week 5 | Actionable home screen |
| 9. Reports | Week 6 | Sales + time reports |
| 10. Settings/Polish | Week 6-7 | Configured and polished |

**Total: 6-7 weeks to fully functional MVP**

**Critical path items (can't skip):**
- Phase 1-2: Foundation + CRUD (necessary for everything)
- Phase 3: Pipeline (core value prop)

* `id`
* `user_id`
* `entity_type`, `entity_id` (Lead/Project)
* `category`
* `started_at`
* `stopped_at` (nullable while running)
* on stop → creates a Time Entry

---

## Key screens (UI)

### A) “Today” home (Sue + Chris)

* My open tasks (due today/overdue)
* Leads needing next action (sorted by next_action_at)
* Recently updated leads/quotes
* **Start timer** quick button (choose Lead/Project + category)

### B) Pipeline board (simple Kanban)

Columns: New → Qualified → Quoting → Sent → Won → Lost
(Behind the scenes these map to Lead stage and/or Quote status)

* Card shows: organisation, summary, owner, next action date, value estimate
* Drag/drop changes stage + writes an automatic note “Stage changed…”

### C) Lead detail

* Header: organisation/contact, stage, owner, next action
* Tabs:

  * Overview
  * Notes (add quickly, pin important)
  * Tasks
  * Quotes (create draft, mark sent/accepted/declined)
  * Time (log time against this lead)

### D) Quote detail

* Status timeline (Draft → Sent → Accepted/Declined)
* Amounts + scope summary + assumptions
* Links/files
* “Create project from accepted quote” button

### E) Project workspace

* Notes + tasks
* Time entries (filter by category, user, date range)
* Simple totals: this week / this month / lifetime

### F) Time logging screen (fast!)

Two entry options:

1. **Timer**: pick Lead/Project + category → Start → Stop → add notes → save
2. **Manual**: start/end pickers + notes + category

---

## Permissions (IsoStack pattern)

* **Org roles** (tenant-level): Admin, Staff
* **Record roles**:

  * `owner_user_id` controls default access
  * Admin can see all
  * Optional: “Private lead” toggle (only owner + admins)

Given it’s just Sue + Chris initially: keep it permissive, but lay the groundwork.

---

## Configuration tables

* Lead stages (so you can tweak names later)
* Time categories (with defaults: billable yes/no, colour optional)
* Lead sources
* VAT rate default (UK)
* Quote reference numbering pattern (per tenant)

---

## Minimal workflows (business logic)

1. **New enquiry → Lead**

* Create lead, set owner, next action (e.g., “Reply today”)

2. **Lead → Quote**

* Create quote draft, mark Sent (stores `sent_at`, moves pipeline)

3. **Quote accepted → Project**

* Create project, set Active, optionally auto-create initial tasks:

  * Kickoff call
  * Access & assets requested
  * Initial concept / plan

4. **Time logging anywhere**

* Allow time entries against Lead (pre-sales) and Project (delivery)
* Roll-up totals by:

  * Organisation
  * Lead
  * Project
  * Month
  * Category
  * User

---

## Reporting (keep it tiny, but useful)

* **Sales**

  * Leads by stage
  * Quotes sent vs accepted (by month)
  * Average time-to-quote, time-to-close
* **Time**

  * This week: total hours by category and by user
  * Per project: total time vs (optional) quoted allowance
  * Pre-sales time: hours logged against leads

---

## Seed “MVP scope” (what you actually build first)

If you want *really simple* and fast to ship:

**V1 (MVP)**

* Organisations, Contacts, Leads
* Notes + Tasks
* Pipeline board
* Basic Quotes (amount + status + sent/accepted)
* Time Entry (manual + simple timer)
* Create Project from accepted quote
* Time totals + basic reports
* Quote reference numberin
* Attachments (R2)
* Private lead toggle
* Basic templates (quote scope headings / assumptions)

---

## Implementation notes for IsoStack

* Multi-tenant by `organisation_id` (tenant) and standard RBAC.
* tRPC procedures by entity: list, get, create, update, archive.
* Use Mantine components:

  * Kanban board (simple drag/drop)
  * Rich text notes (Markdown editor)
  * Time entry modal (fast capture)
* Audit log: stage/status changes + deletes/archives.

---
