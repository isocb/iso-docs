# IsoStack Issue Export

Generated: 2025-12-07T08:06:05.490Z

---

## Collapse and expand sidebar/navbar

**Issue #14** | **ID:** `cmive0vf4001110vmwuizrnhg`
**CR #7** | **CR ID:** `cmive12ll001610vm9dfnx7l9`
**Status:** Pending
**Perspective:** PLATFORM_OWNER
**Category:** Refinement | **Priority:** Critical
**Tags:** SideBar
**Modules:** CORE
**Created:** 2025-12-07T07:14:58.959Z
**Created By:** Chris - Platform Admin

**Description:**

The side navigation bar displays both icons and words for every link. The size of the icons is static. In certain circumstances, I would like the side navigation/navbar to reduce is size. The most effective way of doing this is to have the bar display icons only. There should be a toggle switch in the Sidebar/side nave to 'open' the sidebar - ie display the words and icons, or 'close' - display icons only. The transition is a quick animation of the draw opening and closing which provides illustates what is happening. The driver for this feature is A: When screen collateral is limited, eg when the navbar is 25% or more of the visible screen, the purpose of the app is the app area, not the sidebar! B: The user is very familiar with the menu choices and only require icons. Other apsects of the sidebar - eg colour are unaffected by this, There is a context flag at the top of the side bar and this will move to the header next to the user dropdown - which is actually the best place for the user cotent flag - next to the user menu top right.

---

## Discussion & Comments

### Chris - Platform Admin

**Email:** chris@isoblue.com
**Date:** 12/7/2025, 7:50:48 AM

## ✅ Implementation Complete **Status:** Complete **Date:** 2025-12-07 ### Implementation Summary Successfully implemented collapsible sidebar with all requirements: 1. **Collapse/Expand Toggle** - Toggle button at top of sidebar with icon indicators - Collapsed: 80px width (icons only) - Expanded: 250px width (icons + labels) - 200ms ease-in-out transitions throughout 2. **State Persistence** - Collapsed state saved to localStorage (`sidebar-collapsed`) - Persists across page reloads and sessions 3. **Responsive Auto-Collapse** - Automatically collapses at 1024px breakpoint - Mobile drawer behavior unchanged (standard practice) 4. **Keyboard Shortcut** - `Cmd+B` (Mac) or `Ctrl+B` (Windows/Linux) to toggle - Tooltip shows shortcut hint 5. **Context Badge Relocated** - Moved from sidebar to header (next to user dropdown) - Shows role icon (building for platform/admin, person for users) - Displays name + role for platform/admin users - Displays name only for regular users (role excluded per spec) 6. **Tooltip Behavior** - All navigation items show tooltips on hover when collapsed - Positioned to the right of icons - Help and Edit Mode switches hidden when collapsed (icons remain visible) 7. **Smooth Animations** - All NavLinks animate with 200ms ease-in-out - Icon sizes adjust (32px → 24px when collapsed) - Badges and labels hide/show smoothly - Main content area reflows with transition ### Files Modified - `src/core/components/layout/AppShell.tsx` - Added collapse state, localStorage, media query, keyboard shortcut - `src/core/components/layout/Navbar.tsx` - Refactored with toggle button, conditional rendering, tooltips - `src/core/components/layout/Header.tsx` - Integrated ContextBadge component - `src/core/components/layout/ContextBadge.tsx` - New component showing user context in header ### Testing Checklist - ✅ Click toggle button - sidebar collapses/expands - ✅ Press `Cmd+B` - keyboard shortcut works - ✅ Hover over icons when collapsed - tooltips appear - ✅ Resize window below 1024px - auto-collapses - ✅ Refresh page - state persists from localStorage - ✅ Context badge in header shows correct role/name - ✅ Settings submenu hides children when collapsed - ✅ Smooth 200ms animations on all transitions

---

### Chris - Platform Admin

**Email:** chris@isoblue.com
**Date:** 12/7/2025, 8:00:03 AM

Critical Issue - Oversight by me. When a tenant has only one module - the entire UX for that tenant is the single module - so a Tenant with only one module eg Bedrock - logs in and sees bedrock like it's the only thing in the world. If a tenant is a multi module tenant - ie have more that one module, the default module is the first one they purchased, (as long as their access is current - more on this later). That user is able to switch between modules - which changes the entire ux to be for the module to which they have switched... colour scheme, logo etc etc. The switch is a drop down in the side bar. I suggest this is moved next to the badge for the user - so the name badge and the module badge are positioned centrally, next to one another - ie adjacent. The App switcher is not visible to all tenant users, only those tenants who have multiple apps.

---

Implementation Complete - Module Switcher Moved to Header
I've successfully relocated the module switcher from the sidebar to the header with the following improvements:

What's Been Implemented
1. New ModuleBadge Component

Created ModuleBadge.tsx
Compact badge design matching the ContextBadge style
Shows module icon + name with color coding
Dropdown menu for switching between modules
Only visible for multi-module tenants (hidden for single-module users)
2. Header Layout Updated

Module badge positioned centrally next to user context badge
Both badges adjacent to each other as requested
Clean grouping with <Group gap="sm"> for proper spacing
Module badge uses the module's assigned color scheme
3. Sidebar Cleaned Up

Removed old ModuleSwitcher from sidebar
Removed associated divider
More streamlined sidebar navigation
4. Module Switcher Features

Dropdown shows all available modules
Color-coded indicators (colored dot) for each module
"Active" label on currently selected module
Clicking switches entire UX (route, branding, colors)
Respects scope context (platform/tenant/user routes)
Visual Design
Header Layout (left to right):

Module Badge Appearance:

Badge with module's color scheme
Apps icon + module name + dropdown chevron
On click: dropdown menu with all modules
Color-coded dots showing each module's theme color
Files Modified
ModuleBadge.tsx (NEW) - Compact badge with dropdown switcher
Header.tsx - Added ModuleBadge, grouped with ContextBadge centrally
AppShell.tsx - Passes userModules and activeModule to Header
Navbar.tsx - Removed old ModuleSwitcher component
User Experience
Single-Module Tenant:

Module badge hidden (not shown)
UX is entirely focused on that one module
Clean, uncluttered header
Multi-Module Tenant:

Module badge visible next to user badge
Click to see dropdown of all modules
Switch instantly changes entire UX (colors, logo, routes)
First purchased module is default (as per your spec)
The module switcher is now positioned exactly where you requested - centrally in the header, adjacent to the user context badge!