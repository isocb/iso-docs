# FUND Phase 1 Slice 1P-G-F - Public Project Initiation Form UI Planning

Date: 2026-06-29

## 1. Slice Goal

Plan the first public/client-facing Project initiation form UI for FUND.

The goal is to instantiate a realistic Project initiation experience for new Clients, existing Client contacts who use a public/initiation link, campaign links and future embedded entry points. The form remains moderation-first: a submitted request does not directly create Client, Client user/member, Project, Event, Store, Order, Commerce, notification or communication records.

The UI should support the proven SeasonPro-style pattern:

```text
multi-step initiation form
-> email confirmation midpoint
-> confirmed submission
-> C1 moderation
-> create/link Client, future Client user/member and Project only after approval
```

This is UI planning only. It does not implement application code, schema, migrations, public endpoints, email sending, Client users/members, Store, Orders, Commerce, production/dispatch or SeasonPro integration.

## 2. Dependencies

Implemented dependencies:

```text
1P-G-C - Project Intake schema foundation
1P-G-C2-A - Project Intake email confirmation schema addendum
1P-G-D1 - C1 Project Intake Form API/Services
1P-G-D2 - C1 Project Intake Submission Review API/Services
1P-G-D3-A - Project Intake Approval API/Services
1P-G-E - C1 Project Intake Moderation And Approval UI
1P-G-E-R1 - C1 Project Intake Moderation And Approval UI Review
```

Important existing boundary:

```text
Project Intake submissions are moderation records.
Operational Client/Project records are created or linked only through explicit C1 approval actions.
```

## 3. Recommended Public Routes

Recommended route shape for the first public-facing UI:

```text
/fund/project-initiation/[formSlug]
/fund/project-initiation/[formSlug]/confirm
/fund/project-initiation/[formSlug]/submitted
/fund/project-initiation/[formSlug]/expired
```

Alternative if the app prefers app-scoped public routes:

```text
/project-intake/[formSlug]
/project-intake/[formSlug]/confirm
/project-intake/[formSlug]/submitted
/project-intake/[formSlug]/expired
```

Route rules:

- public routes must not expose C1 admin routes or tenant internals;
- form identity should come from trusted form slug/token lookup, not editable hidden fields;
- Client scope, if present in future, must come from trusted route/token/authenticated context;
- respondent email must not prove Client ownership;
- public routes must not expose supplier/producer internals unless explicitly planned.

## 3A. General vs Event-Scoped Intake Forms

Project Intake forms are C1-created entry points into C2-owned Projects. The form does not make C1 the Project owner.

Supported form modes:

```text
General Project Intake form
-> respondent submits request
-> C1 moderation may approve a standalone Project or select/link an Event during approval
-> resulting Project is owned by the approved C2 Client/account
```

```text
Event-scoped Project Intake form
-> C1 selects a default Event on the form definition
-> respondent submits request through that Event-scoped form
-> submission records the form's trusted default Event as the requested Event
-> C1 approval creates/links the C2 Client-owned Project to that Event unless explicitly changed by an approved C1 action
```

The existing `FundProjectIntakeForm.defaultEventId` field is the intended first-class mechanism for this. This is not a new ownership model and not a user-editable public hidden field. The Event scope must come from the trusted C1 form definition.

Public users should not choose from internal Events in the first visible form. If a form is Event-scoped, the public UI may show plain contextual copy such as:

```text
This request will be reviewed for the [Event name] fundraising event.
```

Rules:

- C1 creates Events.
- C1 may create Event-scoped Project Intake forms.
- C2 Clients still own/manage the approved Projects through `FundProject.clientId`.
- Event-scoped public submissions should carry `requestedEventId` from the trusted form's `defaultEventId`.
- General public submissions should leave `requestedEventId` empty unless C1 sets or links an Event during approval.
- Respondent input, email address, organiser snapshot fields and hidden public fields must not establish Event or Client ownership.

## 4. First Visible Form Field Set

Use client-facing wording. Do not expose internal terms such as workflow class, Store requirement, Commerce option or product workflow.

### Project Basics

Fields:

- Project name;
- Type of fundraising project;
- Preferred project dates / target date;
- Notes / project description.

Client-facing Project Type question:

```text
What kind of fundraising project would you like to run?
```

Options:

```text
Artwork fundraising project
Group personalised product project
Bulk order / club-funded project
Not sure yet
```

### Organisation Details

Fields:

- Organisation name;
- Organisation type;
- Organisation address.

Organisation type options:

```text
School
Club
PTA / Friends group
Charity / community group
Other
```

### Main Organiser Details

Use the public label:

```text
Main organiser details
```

Fields:

- First name;
- Last name;
- Email address;
- Phone number;
- Role in organisation.

Internal interpretation:

- the main organiser may later become or link to a primary Client user/member after C1 approval;
- no Client user/member is created from this public form in the first UI slice;
- organiser/contact values are moderation evidence and contact snapshots only until approval.

## 5. Multi-Step UX

Recommended first UI steps:

```text
Step 1 - Project basics
Step 2 - Organisation details
Step 3 - Main organiser details
Step 4 - Review request
Step 5 - Email confirmation midpoint
Step 6 - Confirmation received / awaiting review
```

The user-facing flow should feel like a fundraising request, not a database form.

UX principles:

- use plain language;
- keep each step short;
- show progress clearly;
- preserve answers while moving between steps;
- validate required fields inline;
- avoid revealing whether the email matches an existing Client;
- explain that the request will be reviewed by the fundraising team before setup.

## 6. Public Form Branding

The public initiation form should feel like a trusted extension of the fundraising tenant, not an unbranded platform form.

Branding should be resolved from trusted configuration only. Do not use respondent-entered organisation names, uploaded files or hidden public fields to decide the form brand.

Recommended fallback order:

```text
trusted Client/tenant branding and footer
-> FUND module branding and footer
-> IsoStack/platform branding and footer
```

For the first FUND public initiation form, "Client/tenant branding" means the trusted FUND producer/admin tenant brand configured for the form or route, such as AMOW. If a future trusted Client-scoped route supports C2 Client branding, that must be explicitly planned and must still come from trusted Client/account context, not public form input.

Branding should include:

- logo or wordmark where available;
- brand colour accents used sparingly;
- footer text/contact details from trusted configuration;
- accessible contrast and readable type;
- a clear indication of the fundraising organisation or producer administering the request.

Email letterheads for required confirmation/authentication emails should use the same fallback order so the form and email feel connected.

## 7. Email Confirmation Boundary

The form UI should include an email confirmation midpoint.

Decision:

```text
General FUND system email content, trigger behaviour, default recipients and pause/resume controls should be handled through a dedicated communications/notifications UI, following the SeasonPro/LMSPro communications Notifications tab pattern.
```

Transactional exception:

```text
Email that is required to complete authentication or confirmation steps may use bounded hard-coded transactional content until the dedicated notifications UI exists.
```

This exception covers narrow flows such as magic-link authentication and the Project Intake email-confirmation step. It does not permit general notification, marketing, approval-outcome or workflow emails to be hard-coded ad hoc.

Required transactional emails should still use the shared branded letterhead/footer wrapper with this fallback order:

```text
trusted Client/tenant branding and footer
-> FUND module branding and footer
-> IsoStack/platform branding and footer
```


The dedicated communications/notifications system should provide:

- editable default content for every system email;
- per-notification pause/resume controls;
- trigger keys and descriptions;
- default recipient rules;
- audit/preview/test-send support where appropriate;
- central maintenance of email content and behaviour.

This decision means Project Intake UI/services should not hard-code broader workflow email body content or send general notifications inline. Required confirmation/authentication emails may use minimal hard-coded transactional copy, but should be clearly annotated for future migration into the editable notifications registry.

## 8. Email Trigger Placeholder Requirement

Implementation slices for the public initiation form should mark email trigger points with explicit placeholders/annotations.

For the required confirmation email, a bounded hard-coded transactional message is acceptable if needed to complete the confirmation step, provided it uses the branded letterhead/footer wrapper and does not introduce editable workflow-notification behaviour.

Expected placeholder pattern:

```text
TODO(FUND_NOTIFICATIONS): register FUND_PROJECT_INTAKE_CONFIRMATION_EMAIL in the future editable notification registry.
Temporary behaviour may use minimal hard-coded transactional confirmation copy only. Do not hard-code approval, rejection, needs-information or marketing/workflow emails.
```

Likely future trigger keys:

```text
FUND_PROJECT_INTAKE_CONFIRMATION_EMAIL
FUND_PROJECT_INTAKE_CONFIRMED_ACKNOWLEDGEMENT
FUND_PROJECT_INTAKE_APPROVED_CLIENT_PROJECT_CREATED
FUND_PROJECT_INTAKE_REJECTED
FUND_PROJECT_INTAKE_NEEDS_INFORMATION
```

These trigger names are placeholders for planning. Only the confirmation/authentication email may be treated as a narrow transactional exception before the editable notification lane exists.

## 9. Confirmation State Behaviour

The public UI should align with the existing schema addendum:

```text
CONFIRMATION_PENDING -> SUBMITTED
```

Expected behaviour:

- initial public form completion creates or prepares an unconfirmed submission state;
- confirmation token values are never shown to users;
- token hashes only are stored server-side;
- confirmation expiry is handled by the backend;
- confirmed requests enter C1 moderation as `SUBMITTED`;
- unconfirmed requests must not appear in the default C1 moderation queue.

The UI should include:

- a check-your-email screen;
- an expired confirmation screen;
- a submitted/awaiting-review screen after confirmation.

General notification delivery remains deferred to the dedicated notifications slice. Required confirmation/authentication delivery may be implemented as a bounded transactional exception with hard-coded minimal content and branded letterhead/footer.

## 10. Store / Commerce Boundary

Do not ask:

```text
Do you require a Store?
```

For the first visible form, the selected Project Type should help C1 understand the likely operational route.

Store, Orders, Commerce, payment, production, fulfilment and commission remain deferred and must be planned separately before implementation.

## 11. Data Handling

If the current schema does not have dedicated fields for every public form input, early implementation may store additional form values in:

```text
rawPayload
sourceContext
```

These values are moderation evidence only.

Do not add schema fields in the UI slice unless a separate schema addendum is explicitly planned and accepted.

## 12. Security / Privacy Rules

Rules:

- public submission must not reveal whether an email belongs to an existing Client;
- email matching may help C1 moderation but must not auto-approve a request;
- hidden fields must not establish Client ownership;
- form id/source context must come from trusted route/token/server context;
- all public input must be validated and safely displayed in C1 moderation;
- rate limiting, anti-spam and abuse handling should be planned before broad public rollout;
- submission success messaging should avoid operational promises such as Store opening or Project creation.

## 13. Relationship To C1 Moderation UI

After confirmation, the request should appear in the C1 Project Intake UI implemented by 1P-G-E.

C1 users should then be able to:

- review request details;
- match or create Client organisation/account;
- create/link Project through explicit approval actions;
- link Event where appropriate;
- reject, cancel, mark spam or request more information.

No public form path should bypass C1 moderation in this slice.

## 14. Relationship To Client Users / Members

The public initiation form may collect details for the main organiser, but it does not create a login-capable Client user/member.

Future approval/onboarding work may decide how to:

- create or match a Client user/member;
- link the person to the Client organisation/account;
- assign role labels such as Treasurer, Secretary, Project Lead or General Contact;
- invite the person to sign in;
- grant dashboard access.

That work remains deferred.

## 15. UI Implementation Boundary

Allowed for the first implementation slice after this planning:

- public Project initiation form route;
- C1 Default Event selector on Project Intake form create/edit where the form should be Event-scoped;
- C1 copy/open public link affordance for `/fund/project-initiation/[formSlug]`;
- multi-step form UI;
- client-facing form field validation;
- review step;
- confirmation-pending screen;
- submitted/awaiting-review screen;
- expired confirmation screen;
- Event-scoped form context where `FundProjectIntakeForm.defaultEventId` is set;
- email trigger placeholders/annotations;
- bounded transactional confirmation/authentication email delivery if explicitly needed for the confirmation step;
- trusted brand/letterhead/footer wrapper for the public form and required confirmation/authentication email;
- use of existing public submission services only if already planned and available.

Not allowed:

- general notification sending;
- hard-coded approval, rejection, needs-information, marketing or workflow email content;
- notification trigger execution outside the narrow confirmation/authentication exception;
- Client user/member creation;
- invitations;
- Store, Orders or Commerce;
- C2 Client dashboard Project creation;
- SeasonPro integration;
- schema changes or migrations unless separately planned.

## 16. Required Dedicated Communications Slice

Before FUND sends broader Project Intake workflow emails, create a dedicated planning and implementation lane for system notifications. Required confirmation/authentication email remains the narrow transactional exception.

Suggested planning slice:

```text
1P-N0 - FUND System Notifications And Editable Email Defaults Planning
```

Goal:

```text
Plan FUND notification trigger keys, editable default email content, recipient rules, pause/resume controls and audit/test behaviour using the SeasonPro/LMSPro communications Notifications tab as the precedent.
```

This should make Project Intake, Client onboarding, approval outcomes and future Store/Commerce notifications easier to build and maintain in one bounded system.

## 17. Manual Test Checklist For Future UI Implementation

When implemented, test:

- public form loads from active form slug;
- Event-scoped form shows plain Event context and confirmed submissions carry the trusted form default Event into moderation;
- inactive/archived/expired form shows safe not-available state;
- Project basics step validates required fields;
- Organisation details step validates required fields;
- Main organiser details step validates email format and required fields;
- review step shows entered details clearly;
- submission moves to confirmation-pending behaviour;
- check-your-email screen appears without revealing account existence;
- expired confirmation link shows safe expired state;
- confirmed submission appears in C1 moderation queue as `SUBMITTED`;
- only the required confirmation/authentication email is sent, if implemented, using branded hard-coded transactional copy;
- no approval, rejection, needs-information, marketing or workflow email is sent unless the dedicated notification system is implemented and enabled;
- no Client, Client user/member, Project, Store, Order or Commerce record is created directly from public submission.

## 18. Recommended Next Slice

Recommended next implementation slice:

```text
1P-G-F-A - Public Project Initiation Form UI Implementation
```

Implementation goal:

```text
Build the public multi-step Project initiation form UI using the approved field set, trusted branding fallback, confirmation-state screens and email trigger placeholders. Required confirmation/authentication email may use bounded hard-coded transactional copy with branded letterhead/footer.
```

Parallel/follow-up planning lane:

```text
1P-N0 - FUND System Notifications And Editable Email Defaults Planning
```

Do not implement broader workflow email sending until that communications/notifications lane is accepted. Confirmation/authentication email remains the only permitted hard-coded transactional exception.
