# IsoStack Issue Export

Generated: 2025-12-07T09:01:49.914Z

---

## Tooltip Hover Behaviours

**Issue #17** | **ID:** `cmivgzqtz001p10vms1e74ysd`
**CR #9** | **CR ID:** `cmivhhosv002810vmy7hmb3nj`
**Status:** Pending
**Perspective:** PLATFORM_OWNER
**Category:** Bug | **Priority:** High
**Tags:** Tenant Testing
**Modules:** CORE
**Created:** 2025-12-07T08:38:05.207Z
**Created By:** Chris - Platform Admin

**Description:**

The Tooltip appearance has changed for the worse. The new system has a larger 'question mark' icon the on-hover behaviour opens a centered modal that persists and requires a click on the x close/ icon. clicking outside the modal does not close it. the 'modal tooltip' does not reflect the colour choice of the owner. The old tooltip was coloured according to the selection, and display either on hover - or had this persistent behaviour - but displayed in context, not the centered modal we have now... can you look at the whole tooltip frame work and advise me please 1. Behaviour 2. Appearance and location 3. Modes 4. The trigger and how to add a trigger point to an element on a page - so I know 5. Automation of creation and how to ensure all new screens include these trigger points.

---

## Discussion & Comments

### Chris - Platform Admin

**Email:** chris@isoblue.com
**Date:** 12/7/2025, 9:01:47 AM

There are two tooltip modes available when creating a tooltip Both should have the same icon when 'Help Mode' is operative. MODE 1 Should be the colour set in the tooltip creation modal form, and the mode is the default for tooltips. The Tooltip shold trigger and work like specifically the tooltips on 'Edit Mode' and 'Show Help' in the bottom of the side nav.. these were the very first tooltips and work as I want them to. The method has changed since they were created, but they exhibit the on hover tooltip MODE 1 perfectly. MODE 2 - Fixed after trigger until click This is because some tooltip content requires interaction - eg download file, URL link, image enlarge or video play. This type of tooltip display actually requires the current default or similar - ie on hover trigger, fixed until click (click anywhere...)

---

