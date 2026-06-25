# IsoStack Issues

Generated: 2026-06-25T07:13:58.197Z

Total Issues: 7

---

## Pending (7)

### Issues not working correctly - filtering by user

**Issue #50** | **ID:** `cmqt5tc0l000112xteuoaqndw`
**CR #11** | **CR ID:** `cmqt61xmf000612xt5ifl1mdn`
**Logged In Role:** PLATFORM_OWNER
**Category:** Bug | **Priority:** Medium
**Created:** 2026-06-25T07:07:16.630Z
**Created By:** Chris - Platform Admin

**Description:**

Created: 25/06/2026, 08:03 As P1 looking at issue management, I can create an issue and add Module to that issue, but the UI filter for Module (A drop down) which seems to contain modules, but when using 'FUND' for example as the module the list is empty. There is an input on the issue form for Module which has all the modules on the drop down, There is a second 'Modules' input which only contains 'Bedrock and LMSPro (user scoped?) - There must be confusion as to which modal drop down is in use, and the role of P1 to see cross user issues.. One way or another I cant filter to find the 'FUND issues. in the issue manager which I need to use to manage ad hoc issues arising during testing. Update: 25/06/2026, 08:10 Error Message - Error An error occurred in the Server Components render. The specific message is omitted in production builds to avoid leaking sensitive details. A digest property is included on this error instance which may provide additional details about the nature of the error.

---

### Product Workflow Class *

**Issue #49** | **ID:** `cmqt5095w000bzd0f14y9svpi`
**CR #11** | **CR ID:** `cmqt61xmf000612xt5ifl1mdn`
**Logged In Role:** PLATFORM_OWNER
**Category:** Refinement | **Priority:** Medium
**Created:** 2026-06-25T06:44:39.908Z
**Created By:** Chris Jones

**Description:**

Created: 25/06/2026, 07:39 Product Workflow Class * needs thought. A product might be suitable for many different workflows... for example a water bottle: It might have individual artwork, group artwork, logo or logo and name or be sold as a standard product..... The workflow it is suitable for is relevant but not deterministic - it is the project that determines what the orgaiser is doing in their desired workflow that determine the workflow branch. Some Events will constrain projects to certain workflows that belong to it, so Events constrain options whilst projects define the process. Different workflows will be contained in separate projects created by the same C2 organiser. C1 can still create project on behalf of C2 users, but projects belong to C2 Users.

---

### Events should link to one or more product catalogues

**Issue #48** | **ID:** `cmqt4sj670009zd0frbt4d830`
**CR #11** | **CR ID:** `cmqt61xmf000612xt5ifl1mdn`
**Logged In Role:** CLIENT_ADMIN
**Impacts Roles:** CLIENT_ADMIN, CLIENT_USER
**Category:** Bug | **Priority:** Medium
**Created:** 2026-06-25T06:38:39.632Z
**Created By:** Chris Jones

**Description:**

Created: 25/06/2026, 07:34 Events should link to one or more product catalogues to create the product offer for projects linked to that Event. Stand alone projects should be offered products from catalogues that are for none event projects.... so we need to introduce the notion of Catalogue Type - For example 'Event Catalogue' named for example 'Christmas' and a Independent Project eg 'Football League Catalogue' That way projects that are scoped to an event can be offer a catalogue sub set of suitable products. Independent Projects for different markets can have suitable product groupings.

---

### Adding product is a gate

**Issue #47** | **ID:** `cmqt4m3rp0007zd0fat6wox41`
**CR #11** | **CR ID:** `cmqt61xmf000612xt5ifl1mdn`
**Logged In Role:** CLIENT_ADMIN
**Impacts Roles:** CLIENT_ADMIN
**Category:** Bug | **Priority:** Medium
**Created:** 2026-06-25T06:33:39.733Z
**Created By:** Chris Jones

**Description:**

Created: 25/06/2026, 07:32 Adding at least one product is essential - however it is not intuitive as product management is on a separate tab.. needs improvement.

---

### Close date for project overrides event close date!

**Issue #46** | **ID:** `cmqt4iked0005zd0f9g047nlm`
**CR #11** | **CR ID:** `cmqt61xmf000612xt5ifl1mdn`
**Logged In Role:** CLIENT_ADMIN
**Category:** Bug | **Priority:** Medium
**Created:** 2026-06-25T06:30:54.662Z
**Created By:** Chris Jones

**Description:**

Created: 25/06/2026, 07:26 The close date for a project is by default the close date of the event but the organiser can make it earlier., Currently the user can create a close date after the event close date and it not only accepts this but updates the advisory text incorrectly. Close date can never be after the close date of a linked event. It can be any date if not linked to an event. This could be a sequence thing. - if the close date is being added at the same time as creating the linked event and so the sequence of checks is incorrect or is taking place on the modal - so the modal doesnt know it is linked to an event becuase the check is out of sequence and not being linked to an event is permitted for stand alone events.

---

### Make sidebar icons appropriate 

**Issue #45** | **ID:** `cmqt48j300003zd0fg6h56mxw`
**CR #11** | **CR ID:** `cmqt61xmf000612xt5ifl1mdn`
**Logged In Role:** PLATFORM_OWNER
**Category:** Bug | **Priority:** Medium
**Created:** 2026-06-25T06:23:06.396Z
**Created By:** Chris Jones

**Description:**

Created: 25/06/2026, 07:21 Make icons appropriate - home in the side bar is used 4 times. Select icons that are page content appropriate. Please also add this to the module UI instructions because this is the third time this has happened - and it would be better to get the icon correct first time.

---

### Navigation

**Issue #44** | **ID:** `cmqt46cz40001zd0fmiix8x67`
**CR #11** | **CR ID:** `cmqt61xmf000612xt5ifl1mdn`
**Logged In Role:** CLIENT_ADMIN
**Impacts Roles:** CLIENT_ADMIN
**Category:** Refinement | **Priority:** Medium
**Created:** 2026-06-25T06:21:25.168Z
**Created By:** Chris Jones

**Description:**

Created: 25/06/2026, 07:20 Add breadcrumb navigation to Products https://staging.seasonpro.co.uk/app/fund/products to enable navigation back

---

