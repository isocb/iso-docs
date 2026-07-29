# Routine IsoStack Management Handbook

Purpose: give a lay Isoblue partner the information needed to keep IsoStack running safely
while an alternative development resource is identified.

Audience: an authorised Isoblue partner who understands the business but is not expected to
develop software or administer a database.

Status: routine operational guide; it does not authorise development, database work or a
production release.

Owner: Isoblue / IsoStack

Last verified: 2026-07-29

Review cadence: every three months and whenever a critical provider, account owner or service
changes.

Internal use only. Do not add passwords, secret keys, database connection details, recovery
codes or customer data to this document.

## 1. Relationship To The Continuity Handbook

This is the lay operational companion to the
[IsoStack Technical Continuity And Succession Handbook](./technical-continuity-and-succession-handbook.md).

For a complete novice's explanation of GitHub, VS Code, Codex, ChatGPT/Sol–High, Render,
Neon, Resend and Upstash Redis, use the
[IsoStack Tools And AI Support Guide](./isostack-tools-and-ai-support-guide-for-lay-custodians.md).

The recurring review schedule and dated evidence are governed by the
[Continuity And Operational Assurance Cycle](./continuity-and-operational-assurance-cycle.md).

Use this handbook to keep the existing service stable during a temporary period without
development support. Use the technical continuity handbook for:

- formal succession and transfer of technical control;
- the codebase and documentation lifecycle;
- appointment and onboarding of a replacement technical maintainer;
- controlled resumption of development; and
- longer-term recovery, security and release governance.

If the two documents appear to disagree, take the safer action: preserve the running service,
make no technical change, record what happened and seek qualified help.

## 2. Your Job During The Holding Period

Your job is continuity, not improvement.

You are expected to:

- make sure provider accounts remain accessible and paid;
- check that the live application is available;
- check the application's simple health report;
- review Render, Neon and GitHub for warnings or failures;
- keep customer and incident records;
- carry out only already-documented routine business administration;
- protect passwords, customer data and recovery information;
- contact provider support or an emergency technical adviser when necessary; and
- leave the application, database and code unchanged until qualified technical control is
  available.

You are not expected to diagnose code, repair database records, deploy software or understand
technical log messages.

## 3. IsoStack In Plain English

IsoStack is a shared online business platform. Different organisations use different
combinations of features, known as modules. Each customer's information is separated from
other customers' information.

The platform provides shared services such as:

- signing in and account security;
- organisations, users and roles;
- product and module access;
- settings and branding;
- help/tooltips;
- email and file handling;
- support and issue records; and
- security and audit records.

The current application contains or supports these principal areas:

| Area                 | Plain-English purpose                                                 |
| -------------------- | --------------------------------------------------------------------- |
| SeasonPro / LMSPro   | Administration for junior football leagues                            |
| FUND                 | Fundraising, projects, products, events, stores and related workflows |
| Bedrock              | Data import, transformation, relationships and reporting              |
| Pulse                | Enquiries, contacts, quotes, projects and time tracking               |
| IsoCare              | Issue reporting and visual problem indicators                         |
| Billing and Support  | Shared platform services rather than independent destination modules  |
| Commerce foundations | Shared payment/order capabilities used by approved product workflows  |

Not every customer has every module. A missing module is not automatically a fault; access may
depend on the organisation's purchased product, assigned module and user permissions.

## 4. The Four Main Operational Systems

```text
Customers use the IsoStack website
              |
              v
Render runs the web application and scheduled jobs
              |
              v
Neon stores the application data

GitHub stores the code and its history and can trigger approved Render deployments
```

Other services may support email, files, security and payment:

- Cloudflare for domains, DNS, Turnstile and R2 file storage;
- Resend for transactional email;
- Upstash Redis for rate limiting and some session-security functions; and
- Stripe for billing/payment functions where enabled.

An outage in one supporting service may affect only one function. For example, the main site
may remain available while email delivery is delayed.

## 5. The Golden Rules

During a no-developer holding period:

1. Do not deploy anything.
2. Do not merge or edit anything in GitHub.
3. Do not change Render environment variables, branches, commands or environment groups.
4. Do not run a Render shell command, one-off job or manual deploy.
5. Do not run SQL or change, restore, reset, merge or delete anything in Neon.
6. Do not change a database connection string.
7. Do not rotate application, database or encryption secrets without a qualified plan.
8. Do not cancel or downgrade a provider subscription to reduce costs.
9. Do not delete users, organisations, projects, modules, branches, buckets or services.
10. Do not copy passwords, keys, customer records or complete error dumps into email, tickets
    or AI prompts.
11. Do not use a personal account for shared operational ownership.
12. Record what you observed and what you did, including the date, time and result.

If unsure, stop. Waiting for qualified advice is safer than experimenting on the live service.

## 6. Complete The Non-Secret Service Card

Keep this table current. Put passwords and recovery information only in the approved company
password vault.

| Item                              | Confirmed name or location                                    | Last checked |
| --------------------------------- | ------------------------------------------------------------- | ------------ |
| Live website address              | `TO BE COMPLETED`                                             |              |
| Public health address             | `<live website>/api/health`                                   |              |
| Render workspace                  | `TO BE COMPLETED`                                             |              |
| Render live web service           | Expected family: `isostack-bedrock`; confirm actual live name |              |
| Render live scheduled job         | Expected family: `isostack-jobs`; confirm actual live name    |              |
| Neon live project                 | `TO BE COMPLETED`                                             |              |
| Neon live branch/database label   | `TO BE COMPLETED` — never copy its connection string here     |              |
| GitHub organisation               | `isocb` — confirm current ownership                           |              |
| Application repository            | `isocb/isostack-bedrock`                                      |              |
| Documentation repository          | `isocb/iso-docs`                                              |              |
| Domain/DNS provider               | `TO BE COMPLETED`                                             |              |
| Company password vault            | `TO BE COMPLETED`                                             |              |
| Primary operational contact       | `TO BE COMPLETED`                                             |              |
| Deputy operational contact        | `TO BE COMPLETED`                                             |              |
| Emergency technical contact       | `TO BE COMPLETED`                                             |              |
| Cyber/security contact or insurer | `TO BE COMPLETED`                                             |              |

There should be at least two company-authorised administrators for every critical provider.

## 7. What "Healthy" Looks Like

Use three simple states.

| State | Meaning                                                                                                                                        | Response                                                                   |
| ----- | ---------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| Green | Site opens, health check is healthy, no new provider alerts and routine functions work                                                         | Record the check; make no change                                           |
| Amber | Site works but an email, scheduled job, GitHub check, bill, warning or individual function has a problem                                       | Record it, avoid repeated customer actions, seek provider/technical advice |
| Red   | Site is unavailable, health is unhealthy, data appears missing/crossed, suspicious access is reported, or a critical account/payment may lapse | Start the incident checklist immediately                                   |

### 7.1 The Health Page

Open:

```text
<live website address>/api/health
```

A healthy result should show:

- `status` as `healthy`;
- the database as `connected`; and
- RLS enabled on `11/11` listed core tables.

RLS is a database protection used to help keep customer organisations separated. A result
other than `11/11` is a red security warning even if the main page still opens.

The health page is useful but limited. It does not prove that email, file storage, payments or
every module workflow is working.

Do not post the health response publicly. Record the time and the result in the operations
log.

## 8. Routine Check Schedule

### 8.1 Each Working Day

- Review the shared operational inbox for provider, payment, security or customer alerts.
- Look for a report that the site, login, email or a module is unavailable.
- If an alert exists, use the incident checklist. If there is no alert, no dashboard action
  is required.

### 8.2 Once A Week

Allow approximately 20 minutes.

- Open the live website in a private/incognito browser window.
- Confirm the sign-in page loads. Do not test using another person's account.
- Sign in using your own authorised account and open one familiar, non-destructive page.
- Open `/api/health` and record Green/Amber/Red.
- In Render, confirm the live web service is running and note its current deployed date/commit.
- In Render, confirm the scheduled job's recent runs are successful.
- In Render, check for a continuing spike in errors, memory or CPU warnings.
- In Neon, confirm the live project is available and has no billing, storage or restore-window
  warning.
- In GitHub, check the `isostack-bedrock` Actions page for recent failed security scans.
- Check that no domain, provider or card-expiry warning needs action.

Do not change anything merely because a graph moves. Record the observation and seek advice
if the change is sustained or accompanies a customer problem.

### 8.3 Once A Month

- Confirm Render, Neon, GitHub and the domain registrar are paid and have a valid company
  payment method.
- Confirm Resend, Cloudflare/R2, Upstash and Stripe billing/access where active.
- Confirm at least two authorised people retain administrator access and MFA.
- Confirm provider alerts reach the shared operational inbox, not only Chris's personal email.
- In Neon, view and record the configured restore window. Do not perform a restore.
- Check domain renewal dates and automatic renewal.
- Review open incidents and customer promises.
- Confirm that the non-secret service card and emergency contacts remain current.
- Export or preserve any provider invoice needed for company records.

### 8.4 Every Three Months

- Perform the quarterly checklist in the technical continuity handbook with the best qualified
  technical adviser available.
- Review access and remove a former person's access only after replacement access is tested.
- Confirm a documented database recovery and application rollback plan exists. Do not test a
  live restore without technical control.
- Review unresolved security alerts and the search for replacement development support.

## 9. Render: The Application Host

### 9.1 What Render Does

Render runs the application code stored in GitHub.

The checked-in service declaration expects:

- a web service that presents IsoStack to users;
- a health check at `/api/health`; and
- a scheduled job, normally running every minute, for queued background work such as some
  email activity.

The Render dashboard is the final record of the services that actually exist. Names can differ
between live, staging and older environments. Confirm that you are viewing the live service
before recording anything.

### 9.2 Safe Render Actions

You may:

- view service status;
- view the current live deploy and its time/commit;
- view logs, metrics and notifications;
- view recent scheduled-job results;
- check billing and team membership;
- copy a short, non-secret error message and timestamp into the incident log;
- contact Render support; and
- restart the existing live web service only under the narrow conditions in Section 9.4.

### 9.3 Unsafe Render Actions

Without qualified technical control, do not:

- click `Deploy latest commit`, `Clear build cache & deploy` or any similar deploy action;
- roll back to an earlier deploy;
- run a shell, one-off job, migration or scheduled job manually;
- edit environment variables or environment groups;
- change the GitHub branch, build command, start command or health path;
- suspend, delete, duplicate or recreate a service;
- change a database URL, bucket name, sender or secret;
- change custom domains or certificates;
- copy environment values out of Render; or
- change instance size except under explicit Render support guidance to resolve a capacity
  incident.

IsoStack's normal Render build runs database migrations before building the application.
Therefore, a "manual deploy" is not a harmless restart.

A Render code rollback is also not a database rollback. Using the wrong pairing could put
older code against newer data. A lay custodian must not use rollback.

### 9.4 The One Permitted Restart

A restart keeps the existing commit and existing configuration. It may clear a temporary
stalled process, but it will not repair bad code, data or settings.

Restart the live web service once only when all are true:

- the live website and health page have failed for at least five minutes;
- Render's public status page does not report a platform incident;
- no deploy or environment change is currently in progress;
- you have confirmed the correct live web service;
- you have recorded the time and current deploy identifier; and
- the authorised continuity coordinator agrees.

In the Render service:

```text
Deploys -> Manual Deploy -> Restart service
```

Then wait up to ten minutes and check the site and `/api/health` again.

Do not repeatedly restart. If one restart does not restore Green status, stop and contact
Render support and the emergency technical contact.

## 10. Neon: The Database

### 10.1 What Neon Does

Neon stores IsoStack's PostgreSQL database. This includes organisations, users, permissions,
module data, business records, audit information and the structure expected by the application.

Different application environments should use different Neon targets. The live Render web
service and its live scheduled job must use the intended live database. Never try to compare
or replace connection strings yourself.

### 10.2 Safe Neon Actions

You may:

- confirm that the expected live project exists and is available;
- view usage, storage, billing and provider notifications;
- view the branch list without opening or copying connection details;
- view the configured restore window;
- review team membership;
- record the exact time of a suspected data problem; and
- contact Neon support.

### 10.3 Unsafe Neon Actions

Without a qualified database specialist, do not:

- open the SQL editor to run a command;
- run a query suggested by a customer, email, AI tool or support forum;
- create, restore, reset, rename, merge or delete a branch;
- change the primary branch or compute endpoint;
- edit database roles or passwords;
- copy or reveal a connection string;
- increase/decrease the restore window during an incident;
- perform a point-in-time restore; or
- attempt to "fix" a record manually.

A restore can replace correct recent data as well as bad data. If data appears missing or
incorrect, preserve the earliest known time of the problem and escalate. Neon support and a
qualified technical person can use that evidence to assess recovery safely.

## 11. GitHub: Code, History And Security Checks

### 11.1 What GitHub Does

GitHub holds:

- the `isostack-bedrock` application source and migration history;
- the `iso-docs` operational and technical documentation;
- the `main`, `staging` and `dev` protected delivery lines;
- short-lived work branches;
- the history needed to understand and recover changes; and
- automated Actions, including security, dependency, database-schema, TypeScript and secret
  checks.

GitHub does not hold the live customer database or the secret values configured in Render.

### 11.2 Safe GitHub Actions

You may:

- view repositories, branches, commits, pull requests and Actions;
- record the current `main` commit identifier;
- view whether the scheduled Security Scan passed or failed;
- maintain organisation billing;
- invite an authorised replacement through the organisation's normal access process;
- ensure the replacement uses their own account and MFA; and
- contact GitHub support.

A failed GitHub Action does not necessarily mean the live site is down. Record the failed job
and escalate it; do not try random fixes.

### 11.3 Unsafe GitHub Actions

Without development control, do not:

- edit a file in the browser;
- approve or merge a pull request;
- create a release;
- push, delete or rename a branch;
- change the default branch or branch protections;
- enable automatic dependency fixes;
- re-run a workflow with changed inputs;
- add a deploy key, personal token, webhook or GitHub App;
- make a private repository public;
- transfer or delete a repository; or
- accept an unknown collaborator or third-party integration.

## 12. Routine Administration Inside IsoStack

Continue only familiar, documented business tasks that were already part of normal operations.

Examples that may be acceptable with proper business authority:

- view an organisation and its current service position;
- invite a known customer user through the normal application screen;
- suspend access for a confirmed departing or compromised user;
- respond to a support issue;
- view module access and existing product allocation; and
- correct simple non-technical customer information where the ordinary UI provides a clear
  audit trail.

Use two-person confirmation for user access, organisation ownership, product/module allocation
or anything affecting billing.

During the holding period, do not:

- create a new platform module or product/package structure;
- change global feature flags or platform defaults;
- change role templates or permission models;
- enable a customer module outside an approved contract and documented process;
- impersonate a customer except under an existing authorised support procedure;
- bulk import, mass edit or delete data;
- create a new domain or integration;
- change payment, tax, email-routing or storage configuration; or
- attempt to work around a broken screen by editing the database.

If the ordinary UI displays a warning you do not understand, cancel the action and record it.

## 13. Incident Checklist

### 13.1 First Ten Minutes

1. Record the time in both local time and UTC.
2. Record who reported the problem, their organisation, affected module and exact action.
3. Check the live website in a private browser window.
4. Check `<live website>/api/health`.
5. Check the Render and relevant provider public status pages.
6. Open the correct live Render web service and note:
   - whether it is running;
   - the current deploy identifier/time;
   - whether a deploy is in progress; and
   - whether recent logs show repeated errors.
7. Check the scheduled job only if the report concerns delayed email/background work.
8. Do not ask multiple users to repeat an action that might create duplicates.
9. Classify Green, Amber or Red.
10. Start an incident record and notify the continuity coordinator.

### 13.2 Site And Health Are Both Down

- If Render or Neon reports a provider incident, monitor the provider and communicate a
  service interruption. Do not change configuration.
- If no provider incident exists, consider the single permitted Render restart.
- If the restart fails, contact Render support and emergency technical assistance.
- Do not deploy, roll back or restore the database.

### 13.3 Site Works But Login Fails

- Check whether the problem affects one person or everyone.
- Check the health page.
- Confirm the user is using the correct email and website.
- Look for an obvious Resend, Upstash or Render alert.
- Do not change authentication secrets or database records.
- If one account is affected, record its email privately and escalate as an account issue.
- If everyone is affected, treat it as Red.

### 13.4 Emails Or Background Actions Are Delayed

- Check the Render scheduled job's recent run status.
- Check Resend status/dashboard for a broad delivery problem.
- Record the affected message type, intended recipient, approximate creation time and whether
  an attachment was involved.
- Tell the user not to submit repeatedly.
- Do not run the scheduled job manually or resend messages in bulk.
- Escalate as Amber, or Red if it affects time-critical customer operations.

### 13.5 Data Appears Missing, Wrong Or Visible To The Wrong Customer

Treat this as Red.

- Ask users to stop changing the affected records.
- Record the earliest and latest known times when the data was correct/incorrect.
- Record organisation, user, module, page and record identifiers without copying the record's
  sensitive contents.
- Preserve screenshots securely.
- Check health but do not query or restore Neon.
- Notify the security/privacy contact and emergency technical contact.
- If one customer can see another customer's information, follow the company's data-breach
  procedure immediately.

### 13.6 Suspicious Account Or Provider Access

- Preserve the alert, time, account and audit evidence.
- Use a separate known-good device/account to verify the warning.
- Through an authorised provider administrator, suspend the specifically compromised human
  account if the compromise is credible.
- Do not delete the account or its evidence.
- Do not rotate application-wide database/authentication/encryption keys yourself.
- Contact the provider's security support and the company security/insurance contact.
- Treat possible customer-data exposure as Red.

### 13.7 Billing, Card Or Domain-Renewal Warning

- Verify the notice by signing in to the provider directly; do not use links in an unexpected
  email.
- Update the company payment method if authorised.
- Pay an overdue valid invoice.
- Preserve the invoice and confirmation.
- Do not downgrade, cancel or delete the service.
- Escalate any threat of imminent suspension as Red.

## 14. Incident Record Template

Create one record per incident in the approved internal location.

```text
Incident title:
Date:
Time first reported (local and UTC):
Recorded by:
Reporter and contact:
Affected organisation/module:
Affected website/page:
What the user attempted:
Exact visible message:
Green / Amber / Red:

Live website result:
Health result:
Render web-service status:
Current Render deploy identifier/time:
Scheduled-job status (if relevant):
Neon provider/project status:
GitHub Action status (if relevant):
Other provider status:

Actions taken:
Actions deliberately not taken:
People/providers contacted:
Customer message sent:
Next review time:
Resolution:
Follow-up needed:
```

Do not paste passwords, keys, connection strings, full customer records or unredacted
authentication logs into this record.

## 15. Customer Communication

Be factual and brief. Do not speculate about cause, data loss or recovery time.

### Acknowledgement

```text
We are aware of an issue affecting [service/function] from approximately [time].
We are checking the service and its providers. Please avoid repeating the affected action
until we confirm it is safe. We will provide another update by [time].
```

### Provider Outage

```text
The issue is associated with an external service provider. The provider is investigating.
IsoStack configuration has not been changed. We will update you by [time] or sooner if the
service is restored.
```

### Restored

```text
Service was restored at approximately [time]. Initial checks are healthy. If you experienced
an incomplete action between [time range], please contact us before repeating it so we can
avoid duplicates.
```

Only the authorised business/privacy contact should communicate a suspected data breach.

## 16. Handover To Replacement Technical Support

Provide the replacement resource with:

- this handbook;
- the technical continuity and succession handbook;
- access through their own company-authorised accounts;
- the current non-secret service card;
- open incident records;
- provider invoices/plan information;
- the root documentation map and current roadmap;
- known customer commitments and critical dates;
- the last known healthy checks;
- current Render deploy identifiers and GitHub commit boundaries; and
- a list of actions deliberately frozen during the holding period.

The replacement must inspect the real repositories and dashboards before making changes. They
must resume the controlled planning, implementation, review and staging lifecycle described in
the technical continuity handbook. A request to "catch up quickly" is not authority to bypass
staging, migration or tenant-security controls.

## 17. Official Provider References

Interfaces change. Use official provider help, not an unverified blog or an AI-generated
instruction, before navigating an unfamiliar control:

- [Render dashboard](https://render.com/docs/render-dashboard)
- [Render health checks](https://render.com/docs/health-checks)
- [Render logs](https://render.com/docs/logging)
- [Render deploy and restart behaviour](https://render.com/docs/deploys)
- [Render rollbacks — technical reference only](https://render.com/docs/rollbacks)
- [Render service metrics](https://render.com/docs/service-metrics)
- [Neon project management and restore-window settings](https://neon.com/docs/manage/projects)
- [Neon branching and recovery overview](https://neon.com/docs/guides/branching-intro)
- [GitHub organisation invitations](https://docs.github.com/en/organizations/managing-membership-in-your-organization/inviting-users-to-join-your-organization)
- [GitHub organisation security overview](https://docs.github.com/en/code-security/securing-your-organization/managing-the-security-of-your-organization)

Provider status shortcuts:

- [Render status](https://status.render.com/)
- [Neon regional status](https://neonstatus.com/)
- [GitHub status](https://www.githubstatus.com/)
- [Resend status](https://resend-status.com/)
- [Cloudflare status](https://www.cloudflarestatus.com/)
- [Upstash status](https://upstash.instatus.com/)
- [Stripe status](https://status.stripe.com/)

Provider documentation explains available controls. It does not override this handbook's rule
that a lay custodian must not deploy, roll back or restore the live system.
