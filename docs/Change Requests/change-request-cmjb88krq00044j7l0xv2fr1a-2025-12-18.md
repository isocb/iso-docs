# IsoStack Issues

Generated: 2025-12-18T09:17:19.946Z

Total Issues: 2

---

## Pending (2)

### Email. 

**Issue #46** | **ID:** `cmjb86g5900014j7l2guct7dh`
**CR #18** | **CR ID:** `cmjb88krq00044j7l0xv2fr1a`
**Logged In Role:** PLATFORM_OWNER
**Impacts Roles:** PLATFORM_OWNER, CLIENT_ADMIN, SINGLE_MODULE_CLIENT, MULTIPLE_MODULE_CLIENT
**Category:** Feature | **Priority:** High
**Modules:** CORE
**Created:** 2025-12-18T09:15:40.221Z
**Created By:** Chris - Platform Admin

**Description:**

Created: 18/12/2025, 09:07 Modules may send emails. in the settings for any module, I would like a table of emails that the system generate, as an email definition. Triggering of emails will be part of the module design and build, but I would like the module to reference the 'Notifications' table, so platform owner can define the email output avoiding hard coding outputs from IsoStack modules - for example the billing process will have lifecycle emails that are generic by default and created in the notfications table so they can be read, and updated. the input for the email with be html and the notifcation will contain a glossary of short codes to enable the html to contain variables from the data. This issue CR is specifcally to prepare the ground for this. Another specific example is the issue tracking email - this will be different for C1 and C2, and P1 will one suited to the platform remedial work, whereas C1 and C2 will get reassurance, apologies and updates on progress.. Module emails from Issue Tracker will be different again, but use the same trigger method - it's just the content that will vary and by using the notofcation table, this can be adapted to changing needs - and avoid costly coding work for trivial changes.

---

### Support ticket email

**Issue #23** | **ID:** `cmivq7kap00076qulbr9oe4s7`
**CR #18** | **CR ID:** `cmjb88krq00044j7l0xv2fr1a`
**Logged In Role:** PLATFORM_OWNER
**Impacts Roles:** PLATFORM_OWNER
**Category:** Feature | **Priority:** High
**Tags:** Support Centre
**Modules:** CORE
**Created:** 2025-12-07T12:56:06.529Z
**Created By:** Chris - Platform Admin

**Description:**

I would like to be able to set email addresses in the platform settings and in the app settings, there should be n number of emails - in a table with add email record. The email record will have data fields as follows: - name - email address - Category* - Email Signature Categor is the same category as the support ticket category, and the support ticket category will determine the recipient of the ticket notification: The platform will cascade upwards. If an email is required the pattern with be Module Category email address if empty, use platform email for that category, if empty, use the default platform email address.... so tickets are routed if available but if not, they fail safe and will always be directed somewhere. So there may be none, one or more email addresses for the platform - and separately for each module. When an email is required to be sent by for example the creation of a support ticket, In Platform Settings, there is an accordion for 'Email' This is where email addresses will be added to the platform, support in the enum Update: 18/12/2025, 08:58 1. This is great! Can you please improve it by adding the details of the Description - which now includes the datestamp... which is perfect. Can you include the Target Resolution date, and other meta data to make the email a way of me managing without having to open the app. 2. please prepare the email to be role and module dependent. see linked Issue #46 Update: 18/12/2025, 09:16

---

