# IsoStack Issues

Generated: 2025-12-06T13:51:45.775Z

Total Issues: 6

---

## In Progress (4)

### Issue Manager - Status issues.

**ID:** `cmiubeu1c000nsm93i8cu3gf8`
**CR#:** cmiubgdh9000qsm93mt3dyrwk
**Perspective:** PLATFORM_OWNER
**Category:** Bug | **Priority:** Medium
**Modules:** CORE
**Created:** 2025-12-06T13:14:05.328Z
**Created By:** Chris - Platform Admin
**Completed:** 2025-12-06T13:24:51.558Z

**Description:**

Saving an issues - it is changed from the user defined status to 'Draft' I manually changed all issues to pending, to create the change request document. The stause on them all was reset to draft, - should be set to in progress!. The output document only has one issue on it. Status filer in the UI is not working - likely issue - multiple satus fields or some implementation issue Critical: There is some sort of clever anticipation of status on the right hand of the issue rows that changes the status: Please remove this.

**Discussion:**

- **Chris - Platform Admin** (12/6/2025, 1:40:36 PM):
  Saving an issue - status from the modal not being saved and the issue is saved as draft.... is this a default from the user defined status to 'Draft' I manually changed all issues to pending, to create the change request document. The stause on them all was reset to draft, - should be set to in progress!.

---

### Tag Creation in issue Manager

**ID:** `cmiub10p20009sm93lrxa8pk2`
**CR#:** cmiubgdh9000qsm93mt3dyrwk
**Perspective:** PLATFORM_OWNER
**Category:** Refinement | **Priority:** High
**Modules:** CORE
**Created:** 2025-12-06T13:03:20.775Z
**Created By:** Chris - Platform Admin

**Description:**

Tags should be offered on the drop down, but as the user types, if the tag does not exist, the tag should be created when the user leaves that field.

---

### Saving an issue

**ID:** `cmiuayumv0005sm93o2mhwowf`
**CR#:** cmiubgdh9000qsm93mt3dyrwk
**Perspective:** PLATFORM_OWNER
**Category:** Bug | **Priority:** High
**Modules:** CORE
**Created:** 2025-12-06T13:01:39.607Z
**Created By:** Chris - Platform Admin

**Description:**

When clicking on 'Create Change Request' if there are no pending issues, the UI gives an error rather than advisory message - can we use this as an opportunity to examine the warning message in Mantine

---

### Client Manager Detail in Platform Dashboard

**ID:** `cmiuara8h0001sm93izg59m02`
**CR#:** cmiub6yao000hsm934luizbaq
**Perspective:** PLATFORM_OWNER
**Category:** Bug | **Priority:** High
**Modules:** CORE
**Created:** 2025-12-06T12:55:46.576Z
**Created By:** Chris - Platform Admin

**Description:**

When opening 'Client tab', there is a list of clients - perfect. Clicking a client there is a brilliant transition now which is an animated transition to a sub set of tabs and a great specific client management screen. Clicking Users tab on this view gives a list of users in a table which does not conform to the UI specification in this document: https://github.com/isocb/docs/blob/8127c423ea7f381c3936e74030f6f3b47e804bd1/docs/00-overview/isostack-ux-ui-standard.md

---

## Pending (2)

### issue Manager

**ID:** `cmiuc5kau000wsm93yoaunro1`
**CR#:** cmiuc84gi000zsm93zkq9mluj
**Perspective:** PLATFORM_OWNER
**Category:** Refinement | **Priority:** High
**Modules:** CORE
**Created:** 2025-12-06T13:34:52.422Z
**Created By:** Chris - Platform Admin

**Description:**

The + next to tags doesn't seem to have added the tag, - it's certainly not on the drop down in the modal. Also: Need to have a bulk method for changing status.... suggest a check box (to the left of the row, so it can be clicked NB whole row clickable to open edit - as per UI, but check box must be clickable: select all, or select individually to create a collection - then select update - eg from Draft to Pending...

---

### Issue Manager status filter

**ID:** `cmiuc09wb000ssm93vovurrvv`
**CR#:** cmiuc84gi000zsm93zkq9mluj
**Perspective:** PLATFORM_OWNER
**Category:** Refinement | **Priority:** High
**Modules:** CORE
**Created:** 2025-12-06T13:30:45.660Z
**Created By:** Chris - Platform Admin

**Description:**

When clicking a filter for status, I would like to be able to (for example) identify all live issues - ie not complete. This can be acheived by having multi select. Default filter should exclude completed. - ie check all of the status options in the multi select. The filter can then be refined by removing some of the default selects.

---

