# FUND Phase 1 Slice 1P-G-F-A-R2 - Public Project Initiation Security, Event Scope And Form UX Remediation Planning

Date: 2026-06-30

## 1. Slice Goal

Plan the remediation required before the public Project initiation form is considered live-ready.

This is a planning slice. It does not implement application code, schema changes, migrations, public endpoint changes, email sending, Client users/members, Store, Orders, Commerce, production/dispatch or SeasonPro integration.

The goal is to correct and document foundational behaviour for:

- public route access security;
- Event-scoped intake forms;
- Event constraints and date defaults;
- public form page chrome;
- form field/date picker consistency;
- C1 configured option sets for Event categories and allowed Client/organisation types;
- future Event imagery/branding context;
- pre-live review boundaries.

This is not a change request away from the original model. It reinforces the foundation specification:

```text
C1 creates Events and intake forms.
C2 Clients own approved Projects.
Event-scoped forms carry trusted Event context into moderated Project creation.
```

## 2. Context

1P-G-F-A implemented:

- public Project initiation routes under `/fund/project-initiation/[formSlug]`;
- public form rendering;
- confirmation-pending submission flow;
- C1 Default Event selection on Project Intake form create/edit;
- copy/open public link affordance.

1P-G-F-A-R1 staging security/pre-live review found:

- staging is healthy;
- C1 Project Intake admin route is protected;
- security headers are generally present;
- the intended public Project initiation route currently redirects unauthenticated users to sign-in.

That route gating is secure but functionally wrong for public intake.

## 3. Correct System Model

Projects are always owned by a C2 Client/account:

```text
FundProject.clientId -> FundClient
```

C1 is the producer/supplier/fulfilment tenant. C1 creates and manages:

- Events;
- Products and Catalogues;
- Project Intake forms;
- moderation/approval;
- production, fulfilment, dispatch and commission later.

Project Intake forms may be:

```text
General
```

or:

```text
Event-scoped
```

For Event-scoped forms, the form knows the Event from trusted C1 configuration:

```text
FundProjectIntakeForm.defaultEventId
```

The public respondent must not choose or spoof Event linkage through hidden fields, query params or free-text input.

## 4. Public Route Security Requirement

The public form route must be accessible without authentication:

```text
/fund/project-initiation/[formSlug]
/fund/project-initiation/[formSlug]/confirm
/fund/project-initiation/[formSlug]/submitted
/fund/project-initiation/[formSlug]/expired
```

Security rules:

- allow public access only for the public initiation route family;
- keep all `/app/fund/project-intake/*` C1 admin routes authenticated and C1-admin gated;
- never expose C1 tenant internals, hidden IDs, confirmation token hashes or private submission state;
- missing/inactive/paused/archived/expired form slugs should show a safe unavailable state;
- public unavailable states must not reveal whether a Client, respondent email or internal Event exists;
- public submissions remain moderation records only.

Implementation implication:

```text
Review and adjust middleware/public-route allowlisting before live promotion.
```

## 5. Vanilla Public Page Requirement

The public Project initiation form should render on a vanilla public page.

It must not show the generic IsoStack marketing/navigation header:

```text
Features
About
Pricing
Contact
Sign in
IsoStack logo
```

Expected public page chrome:

- trusted form/tenant/Event/module branding only;
- no app sidebar;
- no platform marketing navigation;
- no C1 admin navigation;
- no C2 dashboard navigation;
- minimal footer using trusted branding fallback.

Branding fallback:

```text
trusted Event/form/tenant context where available
-> FUND module branding
-> IsoStack/platform fallback
```

## 5A. Embed-Ready Public Form Requirement

The public Project initiation form may be used as:

- a standalone public link;
- a linked campaign page;
- an embedded form on third-party websites such as Squarespace, Wix or WordPress;
- a future embedded widget on Client, Event or SeasonPro-linked pages.

This remediation must not make third-party embedding impossible by accident.

Planning rules:

- the public form UI should be self-contained and not depend on app shell, sidebar, marketing navigation or authenticated layout context;
- the public form should work at a narrow embedded width as well as full page width;
- the public form should avoid interactions that require parent-page navigation state;
- the form should not assume it owns the entire browser viewport when embedded;
- confirmation and submitted/expired states must still work when the original form is embedded;
- any copy/open public link affordance remains C1 admin-only and is not part of the embedded public UI.

Security and CSP rules:

- do not weaken frame or CSP protections for C1 admin routes;
- do not globally relax `frame-ancestors` for the whole app;
- if iframe embedding is supported, use a deliberately scoped public embed route or route-specific header policy;
- consider an allowlist of permitted embedding origins per tenant/form before broad third-party iframe embedding is enabled;
- if a script/embed-code approach is used later, it must be separately planned for XSS, origin, rate-limit and data-leakage risk;
- public unavailable states must remain safe when embedded and must not reveal tenant internals.

Recommended future/embed route shape to evaluate:

```text
/fund/project-initiation/[formSlug]
/fund/project-initiation/[formSlug]/embed
```

The standalone route may remain full-page public chrome, while an `/embed` route can be explicitly designed for iframe/code-embed constraints if needed.

## 6. Event-Scoped Form Behaviour

When a Project Intake form has `defaultEventId`, it is Event-scoped.

Event-scoped public forms should:

- show plain Event context to the respondent;
- use the linked Event as trusted context;
- carry `requestedEventId` into the submission;
- default public Project date fields from the linked Event;
- constrain public Project date fields to the Event boundaries;
- prevent public users from selecting a different internal Event.

Public wording should be tenant-facing, for example:

```text
This request is for the [Event name] fundraising event.
```

The resulting approved Project remains owned by the C2 Client/account through `FundProject.clientId`.

## 7. Event Date Constraints And Project Dates

The public Project initiation form should collect Project start and Project closing dates.

The current single target date is not sufficient for operational Project creation because ecommerce/distribution occurs after the Project closing date. A Project without an end/closing date cannot safely drive later Store, Orders, production or fulfilment workflows.

### Event-Scoped Form Defaults

If the form is Event-scoped:

```text
Project start date default = linked Event opensAt
Project closing date default = linked Event closesAt
```

Validation rules:

- Project start date is required;
- Project closing date is required;
- Project start date must be on or after Event opensAt;
- Project closing date must be on or before Event closesAt;
- Project closing date must be after Project start date;
- Project closing date may be earlier than the linked Event closesAt.

### General Form Defaults

If the form is not Event-scoped:

- Project start date is required;
- Project closing date is required;
- Project closing date must be after Project start date;
- no Event min/max constraints apply unless C1 later links an Event during approval.

### Approval Boundary

C1 approval should preserve or correct date values before creating a Project.

If C1 changes the linked Event during approval, the approval UI/services must revalidate the Project dates against the selected Event.

## 8. Event Imagery And Form Branding

Event imagery and Event-specific branding are vital for contextual public forms.

Current observation:

```text
The current Event model appears to have eventType but no first-class Event image/hero/branding fields.
```

Planning direction:

- Event-scoped public forms should eventually be able to use Event image/hero artwork.
- Event imagery must come from trusted C1 Event configuration, not respondent input.
- The public form should use Event imagery when present, then fall back to trusted tenant/module/platform branding.
- Do not add ad hoc metadata-only Event image behaviour without a schema/UI decision.

Recommended follow-up if schema support is missing:

```text
1P-G-F-A-R2B - Event Media And Branding Schema/UI Planning
```

Candidate Event fields to evaluate:

- hero image / banner image;
- thumbnail image;
- public display title/subtitle;
- public branding override;
- alt text;
- media ownership/source rules.

## 9. Event Type / Category Options

Current observation:

```text
Event Type / Category is currently free text.
```

This should become a C1-configurable option set, not uncontrolled free text.

Desired model:

- C1 can define Event types/categories;
- Event create/edit uses a dropdown/select;
- C1 can add/manage options in a controlled place;
- options may include examples such as Christmas, Mother's Day, Leavers and seasonal/campaign categories;
- option labels are tenant-facing;
- underlying values remain stable for filtering/reporting.

Recommended follow-up if not already supported:

```text
1P-G-F-A-R2C - Event Type Option Set Planning
```

Do not block the route-access fix on this unless the implementation slice needs Event category for public form display.

## 10. Allowed Client / Organisation Types

Current observation:

```text
Allowed Client Types on Project Intake form create/edit appears as free text.
```

This is confusing and should be replaced with a bounded selection control.

Desired behaviour:

- use a multi-select/checkbox group for allowed Client or organisation types;
- values should come from the accepted Client organisation type set or a future tenant-configurable type registry;
- public form organisation-type options should be filtered by the form's allowed types;
- labels should remain public/client-facing.

Initial public organisation labels:

```text
School
Club
PTA / Friends group
Charity / community group
Other
```

Do not allow public respondents to define new organisation type options in this slice.

## 11. Date Picker And Form Field UI Standard

The public Project initiation form should align with the app's operational date input pattern.

Requirements:

- use the same date/time picker pattern used elsewhere for operational Project/Event dates unless a date-only value is explicitly planned;
- do not mix plain date inputs with `DateTimePicker` for the same concept;
- start/closing dates should use aligned date/time controls;
- helper text/subtitle rows should reserve space consistently across sibling fields;
- if one input in a grid row has explanatory copy, sibling inputs should reserve equivalent helper-text height so the input boxes align;
- avoid visual misalignment that causes subconscious UI tension.

This is now captured in the IsoStack UX/UI Standard:

```text
8.2A Form Field Alignment And Date Inputs
```

Implementation should either use a shared field wrapper or consistent Mantine `description` spacing to achieve alignment.

## 12. Immediate Remediation Scope

Recommended implementation scope for the next app slice:

```text
1P-G-F-A-R2-A - Public Project Initiation Route And Event-Scoped Form Remediation
```

Implement:

- public route allowlist for `/fund/project-initiation/*`;
- preserve C1 auth protection for `/app/fund/project-intake/*`;
- vanilla public page without IsoStack marketing nav;
- ensure the public form architecture remains embed-ready and does not depend on app shell/navigation;
- Event-scoped form context display;
- Project start and closing date fields;
- Event-scoped date defaults and constraints;
- general-form required start and closing dates;
- use app-aligned date/time picker controls;
- replace allowed Client Types free text with bounded selection where current schema/API permits;
- keep submissions as moderation records only;
- update confirmation/review docs.

Do not implement:

- Client users/members;
- invitations;
- broader notification workflows;
- Store;
- Orders;
- Commerce;
- production/dispatch;
- SeasonPro integration;
- Event media schema unless separately approved;
- Event type option-set schema unless separately approved.

## 13. Security And Live Promotion Gate

This remediation is a live-promotion gate for the public form.

Do not promote the public initiation form to live until:

- public routes are intentionally unauthenticated;
- C1 admin routes remain protected;
- missing/inactive/expired slugs show safe unavailable state;
- active Event-scoped form loads without C1/admin navigation;
- public form rendering remains suitable for standalone links and future third-party embeds;
- Event date constraints work;
- public submissions do not create operational records;
- no unexpected workflow emails are sent;
- staging smoke test passes.

## 14. Recommended Next Slices

Immediate implementation:

```text
1P-G-F-A-R2-A - Public Project Initiation Route And Event-Scoped Form Remediation
```

Review:

```text
1P-G-F-A-R2-R1 - Public Project Initiation Remediation Review And Staging Smoke Test
```

Possible follow-up planning:

```text
1P-G-F-A-R2B - Event Media And Branding Schema/UI Planning
1P-G-F-A-R2C - Event Type Option Set Planning
1P-G-F-A-R2D - Client Organisation Type Option Set Planning
```
