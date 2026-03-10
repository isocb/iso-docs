# CR-4 — LMSPro UX Refinements (March 2026)

**CR ID:** `cmmjeqrtc0000d8suvmpo9540`
**Status:** ✅ Complete
**Deployed to TechTest:** 10 March 2026 (`0c84e7d`)
**Total Issues:** 7
**Migrations required on TechTest:** `npm run db:migrate`

---

## Summary

All 7 issues implemented across 5 commits on `dev`, merged to `techtest` on 10 March 2026.

| Phase | Commit | Issues | Description |
|-------|--------|--------|-------------|
| 1+2 | `c8ac0c9` | #19 | Mobile number field + League/Club user management tabs |
| 3+4+5 | `4cbad87` | #21, #15, #16 | Age group numeric sort + stacked team manager contacts |
| 6 | `456f3f2` | #20 | Drag-and-drop sort order for league roles |
| 7 | `fe62df3` | #14 | Key date confirmation accordion + Send Reminder modal |
| — | `0c84e7d` | #22 | Register New Team card (key-date gated, Issue #22) |

---

## Issues

### ✅ Issue #17 — Email Recipients

**ID:** `cmmjcv2qf000984ei876e6zvc` | **Priority:** Medium | **Commit:** `b4bc47f`

**Request:** The email recipient list was role-based, causing ambiguity with fixed officer positions (Chair, Welfare, Treasurer). Club Secretary is the only likely login user; others are stored as non-login officer contacts.

**Implemented:**
- Email recipient system updated to use officer contacts (Chair, Welfare, Treasurer, Secretary) rather than login roles
- Duplicate role names removed from the recipient picker
- Ambiguity resolved across all email composition flows and key date email chains

---

### ✅ Issue #21 — Age Group Sort Order

**ID:** `cmmjdsl9d0001ilj0yr6mm56p` | **Priority:** High | **Commit:** `4cbad87`

**Request:** Age groups were sorting alphabetically (U10 before U7). All tables needed to use the numeric `ageValue` field.

**Implemented:**
- `teams.router.ts`: all `list`, `listPendingForApproval`, and `getTeamsForClub` queries updated to `orderBy: [{ ageGroupObj: { ageValue: 'asc' } }]`
- Consistent U7 → U8 → U9 → U10 … U21 sort everywhere age groups appear

---

### ✅ Issue #20 — Drag-and-Drop Sort Order for Roles

**ID:** `cmmjdp64d00094wahduq9kyk1` | **Priority:** High | **Commit:** `456f3f2`
**Migration:** `20260309130000_add_module_role_sort_order`

**Request:** The roles admin page needed drag-and-drop sort ordering, propagated to all role dropdowns.

**Implemented:**
- `prisma/schema.prisma`: `sortOrder Int @default(0)` added to `ModuleRole`
- `roles.router.ts`: new `reorder` mutation (bulk-updates `sortOrder` in a transaction); `list` ordered by `[sortOrder asc, name asc]`
- `admin/roles/page.tsx`: full DnD using `@dnd-kit/core` + `@dnd-kit/sortable`; `SortableRoleCard` with grip handle; optimistic local state; persisted via `reorderMutation`

---

### ✅ Issue #19 — User Management Redesign

**ID:** `cmmjdkgyo00054wahvppyeikk` | **Priority:** High | **Commit:** `c8ac0c9`
**Migration:** `20260309120000_add_user_mobile_number`

**Request:** User management needed League/Club tabs, a stacked Name/Email/Mobile column, and mobile number added to the user record.

**Implemented:**
- `prisma/schema.prisma`: `mobileNumber String?` added to `User`
- `users.router.ts`: `mobileNumber` included in queries and update mutation
- `admin/users/page.tsx`: League tab (stacked Name/Email/Mobile as first column) + Club tab (Club Name first, then stacked contact); users with both scopes appear in both tabs; search bar on each tab; mobile field in edit modal

---

### ✅ Issue #16 — All Teams Listing — Stacked Manager Contact

**ID:** `cmmjcdgu2000584ei6ovyr4xi` | **Priority:** Medium | **Commit:** `4cbad87`

**Request:** The all-teams listing needed a stacked Manager column (Name/Email/Mobile) with clickable links, plus an age group filter.

**Implemented:**
- `teams/page.tsx`: Manager column upgraded to stacked Name (bold) / Email (`mailto:`) / Phone (`tel:`) with `stopPropagation` on links
- Age group filter added at top of the teams listing

---

### ✅ Issue #15 — Club Teams Page — Age Group First Column

**ID:** `cmmjc5xc4000184eiiftmwx7o` | **Priority:** High | **Commit:** `4cbad87`

**Request:** Club teams listing needed Age Group as the first column and manager shown as a stacked Name/Mobile/Email group.

**Implemented:**
- `club/teams/page.tsx`: Age Group column moved to first position
- Manager column: stacked Name / Email (`mailto:`) / Phone (`tel:`), matching the Primary Contact pattern on the clubs page
- Sort order uses numeric `ageGroupObj.ageValue`

---

### ✅ Issue #14 — Key Date Confirmation Accordion + Send Reminder

**ID:** `cmmj5wcso0005vxmaz6aqorcx` | **Priority:** Medium | **Commit:** `fe62df3`

**Request:** The compliance table needed an accordion (collapsed, with status counts in header), and the "Email non-compliant clubs" button needed to be functional with a compose modal.

**Implemented:**
- `key-date-confirmations.router.ts`: new `sendReminder` mutation — resolves primary contact email per non-confirmed club, calls `sendBatchEmails` (Resend), creates `Email` + `EmailRecipient` records, creates AuditLog (`KEY_DATE_REMINDER_SENT`), returns `{ sentCount, skippedCount, failedCount }`
- `KeyDatesTab.tsx` — `CompliancePanel` rewritten: status badges at top; **Accordion** containing per-club status table (collapsed by default); "Email non-compliant clubs (N)" button now active; modal pre-fills subject + HTML body; orange alert lists pending clubs; closes on send with success notification

---

### ✅ Issue #22 — Club Components Missing from Key Date Linking Dropdown

**ID:** `cmmjfx0th0002d8sufwce65u9` | **Priority:** Medium | **Commit:** `0c84e7d`

**Request:** New Club card components were not appearing in the key date linking dropdown.

**Root cause:** `teams.register` had no `ComponentDefinition` record in the database; the "Register a New Team" card and modal had not been built.

**Implemented:**
- `teams.router.ts`: new `submitRegistration` mutation for club users — creates team with `status: PENDING`, uses club user's own `lmsproClubId`, no league `teams.manage` permission needed
- `RegisterTeamModal.tsx` (new): Age group Select (numerically sorted), Team Name, optional manager fields; success confirmation state; invalidates teams list
- `ClubActionCards.tsx`: new "Register a New Team" seasonal action card gated on `getCardTiming('team-registration')` key date window
- `ActionCard.tsx`: `IconUserPlus` added to icon map
- `ComponentDefinition` `teams.register` added to `seed.ts` and inserted live into database — now appears in the key date linking dropdown
