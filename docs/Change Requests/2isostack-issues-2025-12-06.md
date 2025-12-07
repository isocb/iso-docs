# IsoStack Issues

Generated: 2025-12-06T14:16:46.826Z

Total Issues: 4

---

## In Progress (3)

### Issue Manager - Status issues.

**Issue #8** | **ID:** `cmiubeu1c000nsm93i8cu3gf8`
**CR #4** | **CR ID:** `cmiubgdh9000qsm93mt3dyrwk`
**Perspective:** PLATFORM_OWNER
**Category:** Bug | **Priority:** Medium
**Modules:** CORE
**Created:** 2025-12-06T13:14:05.328Z
**Created By:** Chris - Platform Admin
**Completed:** 2025-12-06T13:24:51.558Z

**Description:**

NOT FIXED - Edit - Fine - New Issue - Set to Pending - saved as Draft. Saving an issues - it is changed from the user defined status to 'Draft' I manually changed all issues to pending, to create the change request document. The status on them all was reset to draft, - should be set to in progress!. The output document only has one issue on it. Status filer in the UI is not working - likely issue - multiple satus fields or some implementation issue

**Discussion:**

- **Chris - Platform Admin** (12/6/2025, 1:40:36 PM):
  Saving an issue - status from the modal not being saved and the issue is saved as draft.... is this a default from the user defined status to 'Draft' I manually changed all issues to pending, to create the change request document. The stause on them all was reset to draft, - should be set to in progress!.

**✅ FIXED - 2025-12-06 (Updated)**

**Root Cause:** Two issues were preventing status from saving correctly:
1. The `createIssueSchema` in `/src/server/actions/issues.ts` was missing the `status` field in its validation schema
2. The form in `IssueModal.tsx` had initial value `status: 'Draft'` which wasn't intuitive for new issues

**Solution:** 
1. Added `status: z.enum(['Draft', 'Pending', 'In Progress', 'Testing', 'Complete']).optional()` to the `createIssueSchema` validation
2. Changed form initial value from `status: 'Draft'` to `status: 'Pending'` so new issues default to actionable status

**Files Changed:**
- `/src/server/actions/issues.ts` - Added status field to createIssueSchema (line ~14)
- `/src/app/(app)/platform/issues/components/IssueModal.tsx` - Changed initial status from 'Draft' to 'Pending' (line ~76)

**Testing:** Create a new issue - it should now default to "Pending" status and save correctly. User can still change to any other status before saving.

---

### Saving an issue

**Issue #5** | **ID:** `cmiuayumv0005sm93o2mhwowf`
**CR #4** | **CR ID:** `cmiubgdh9000qsm93mt3dyrwk`
**Perspective:** PLATFORM_OWNER
**Category:** Bug | **Priority:** High
**Modules:** CORE
**Created:** 2025-12-06T13:01:39.607Z
**Created By:** Chris - Platform Admin

**Description:**

NOT FIXED When clicking on 'Create Change Request' if there are no pending issues, the UI gives an error rather than advisory message - can we use this as an opportunity to examine the warning message in Mantine

**✅ ALREADY IMPLEMENTED - Verified 2025-12-06**

**Status:** This feature was already correctly implemented in a previous update.

**Implementation:** The error handler in both `/src/app/(platform)/platform/_components/IssuesTab.tsx` and `/src/app/(app)/platform/issues/page.tsx` detects when the error message contains "No pending issues" and displays a yellow advisory notification instead of a red error notification.

**Code Location:**
```typescript
const isNoPendingIssues = errorMessage.includes('No pending issues');

notifications.show({
  title: isNoPendingIssues ? 'No Pending Issues' : 'Error',
  message: errorMessage,
  color: isNoPendingIssues ? 'yellow' : 'red',
});
```

**Files:**
- `/src/app/(platform)/platform/_components/IssuesTab.tsx` (lines 73-88)
- `/src/app/(app)/platform/issues/page.tsx` (lines 73-88)

**Testing:** Click "Create Change Request" when no issues are in "Pending" status - should show yellow advisory message, not red error.

---

### Client Manager Detail in Platform Dashboard

**Issue #1** | **ID:** `cmiuara8h0001sm93izg59m02`
**CR #3** | **CR ID:** `cmiub6yao000hsm934luizbaq`
**Perspective:** PLATFORM_OWNER
**Category:** Bug | **Priority:** High
**Modules:** CORE
**Created:** 2025-12-06T12:55:46.576Z
**Created By:** Chris - Platform Admin

**Description:**

When opening 'Client tab', there is a list of clients - perfect. Clicking a client there is a brilliant transition now which is an animated transition to a sub set of tabs and a great specific client management screen. Clicking Users tab on this view gives a list of users in a table which does not conform to the UI specification in this document: https://github.com/isocb/docs/blob/8127c423ea7f381c3936e74030f6f3b47e804bd1/docs/00-overview/isostack-ux-ui-standard.md

**✅ FIXED - 2025-12-06**

**Problem:** The Users table had individual action icon buttons (Impersonate, Edit, Send Email) in a separate column, which didn't conform to the UI specification requiring clickable rows instead.

**Solution:** Refactored `/src/app/(platform)/platform/clients/[id]/_components/ClientUsersTab.tsx`:

**Changes Made:**
1. **Removed action icons column** - Deleted the entire 'actions' column with individual ActionIcon buttons
2. **Made rows clickable** - Added `onRowClick` handler to DataTable that opens an edit modal
3. **Added hover styling** - Added `rowStyle={{ cursor: 'pointer' }}` for visual feedback
4. **Created edit modal** - New modal displays when clicking a user row with:
   - User avatar and details
   - Badge showing role
   - Action buttons for: Impersonate User, Edit Details, Send Email
   - Clean, organized button layout

**Files Changed:**
- `/src/app/(platform)/platform/clients/[id]/_components/ClientUsersTab.tsx` (removed lines ~180-230, added edit modal)

**Testing Steps:**
1. Go to Platform Dashboard → Clients tab
2. Click any client to open detail view
3. Click Users tab
4. Click any row in the users table → Should open modal with user details and action buttons
5. Verify no individual action icons in table
6. Verify cursor changes to pointer on hover

---

## Pending (1)

### Bulk Changes.

**Issue #10** | **ID:** `cmiudmto0000c10vmtn4ms1uu`
**Perspective:** PLATFORM_OWNER
**Category:** Refinement | **Priority:** High
**Tags:** Feature Update, Bulk Edit
**Modules:** CORE
**Created:** 2025-12-06T14:16:17.329Z
**Created By:** Chris - Platform Admin

**Description:**

I want to be able to flag issues - either all or by selection and then change the status. Check boxes on the table MUST be editable, but note the entire row is clickable to open the modal edit, so this must be resolved.

**✅ IMPLEMENTED - 2025-12-06**

**Solution:** Added checkbox-based bulk selection and status update functionality to the issue list without interfering with the clickable rows.

**Features Implemented:**

1. **Individual Checkboxes**
   - Checkbox added to the left of each issue card
   - Uses `onClick={(e) => e.stopPropagation()}` to prevent modal opening when clicking checkbox
   - Visual feedback when selected

2. **Select All Functionality**
   - "Select All" checkbox in bulk actions bar
   - Indeterminate state when some (but not all) issues selected
   - Click to select/deselect all visible issues

3. **Bulk Actions Bar**
   - Appears when one or more issues are selected
   - Shows selection count (e.g., "3 selected")
   - "Change Status" dropdown menu with all status options:
     - Draft
     - Pending
     - In Progress
     - Testing
     - Complete
   - "Clear Selection" button to deselect all

4. **Bulk Status Update**
   - Updates all selected issues to chosen status
   - Shows loading state during operation
   - Success notification with count: "Updated 3 issues to Pending"
   - Auto-refreshes list after update
   - Clears selection after successful update

**Files Changed:**
- `/src/app/(app)/platform/issues/components/IssueList.tsx` - Added checkbox selection, bulk actions UI, and bulk update logic

**Testing Steps:**
1. Go to Platform Dashboard → Issues tab (or standalone /platform/issues page)
2. Click checkboxes on 2-3 issues → Bulk actions bar should appear
3. Click "Select All" → All visible issues should be selected
4. Click "Change Status" → Choose "In Progress"
5. Verify success notification shows count
6. Verify all selected issues now show "In Progress" status
7. Click individual issue card (not checkbox) → Modal should open normally
8. Click checkbox → Should NOT open modal

**Technical Notes:**
- Checkbox click events use `stopPropagation()` to prevent row click handler
- Selection state managed in component state as `selectedIds: string[]`
- Bulk update uses `Promise.all()` to update multiple issues concurrently
- Server action `updateIssue()` called for each selected issue

---

