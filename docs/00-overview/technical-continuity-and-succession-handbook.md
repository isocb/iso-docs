# IsoStack Technical Continuity And Succession Handbook

Purpose: preserve Chris's working method, the documentation and delivery lifecycle, the
technical shape of IsoStack, and the order in which another person should assume control
if Chris dies, becomes permanently incapacitated, or is otherwise unavailable for an
extended period.

Status: controlled orientation and handover guide; not executable roadmap authority

Owner: Isoblue / IsoStack

Last verified against the repositories: 2026-07-29

Review cadence: quarterly, and after any material change to ownership, hosting, deployment,
identity, payment, storage or documentation control

Internal use only.

## 1. What This Document Is For

This handbook gives a successor enough context to preserve the service, find the current
truth, avoid destructive mistakes and resume controlled development.

For a lay partner keeping the existing service stable while technical support is unavailable,
use the companion
[Routine IsoStack Management Handbook](./routine-isostack-management-handbook.md).

For a complete novice's explanation of the principal software, hosting, data, email and AI
tools, use the
[IsoStack Tools And AI Support Guide](./isostack-tools-and-ai-support-guide-for-lay-custodians.md).

The recurring review schedule and evidence structure are governed by the
[Continuity And Operational Assurance Cycle](./continuity-and-operational-assurance-cycle.md).

It is deliberately not:

- a password or secret store;
- a substitute for a will, shareholder agreement, intellectual-property assignment,
  power of attorney or other legal instrument;
- authority to deploy, spend money, access customer data or change ownership;
- a snapshot of whichever development slice happens to be active when this file is read.

Legal authority should be established by the executor, company officers or other properly
authorised representative before account ownership or privileged access is transferred.
Technical access should then be provided through organisation membership, recovery
procedures or a managed password vault. Nobody should copy or circulate Chris's personal
credentials.

## 2. Continuity Summary

If there is no time to read the whole document:

1. Keep the live service running; do not start a release, migration, dependency upgrade or
   broad refactor.
2. Establish who has legal/business authority and appoint one continuity coordinator.
3. Preserve GitHub, Render, Neon, DNS/domain, email, storage, payment and password-vault
   access. Add authorised replacement administrators before removing any existing access.
4. Read the canonical [Documentation Map](../../DOCUMENTATION_MAP.md), then the active
   [root roadmap](../00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md).
5. Treat `isodocs` as the documentation source of truth and `isostack-bedrock` as the
   application source of truth.
6. Confirm the live commit, deployed migrations, service health, backups and billing
   before changing anything.
7. Never run `db:push`, `db:seed`, a database reset or an unreviewed migration.
8. Never promote to live without staging evidence and explicit authorised approval.
9. Never put credentials, complete URLs containing credentials, signed URLs or customer
   data into Git, tickets, prompts or documentation.
10. Resume work from the next action authorised by the root and owning-lane roadmaps, not
    from a random issue, old plan or unfinished local branch.

## 3. Chris's Working Method

### 3.1 The Human Role

Chris combines product ownership, business-domain knowledge, architecture direction,
implementation judgement and hands-on acceptance testing. The characteristic method is:

- describe the user or business outcome in plain language;
- use existing product knowledge to identify what matters and what is merely technical
  detail;
- work in small, concrete increments;
- inspect the real code and data rather than relying on memory;
- use AI as an implementation and review partner;
- test working behaviour quickly in the browser;
- refine from evidence;
- prefer a practical, maintainable result over speculative abstraction;
- retain explicit human control over product meaning, commercial rules, destructive data
  actions and production promotion.

The successor does not need to imitate Chris's technical style exactly. They do need to
preserve the separation between product authority, implementation evidence and release
authority.

### 3.2 The AI-Assisted Engineering Role

AI agents are used as controlled senior-development partners. Their expected sequence is:

```text
inspect current files and controls
-> explain the current behaviour
-> create or follow a bounded plan
-> implement focused changes
-> run proportionate checks
-> record factual evidence
-> stop at the next authority boundary
```

An agent may resolve ordinary technical details that are already constrained by accepted
architecture and existing patterns. It must stop when:

- a genuine product, commercial or user-facing choice remains;
- tenant isolation, permissions or data ownership are unclear;
- existing data may be destructively transformed;
- shared environment or production access is required without authority;
- the proposed work expands beyond the accepted slice;
- verification fails in a way that is not understood.

### 3.3 Fast Feedback Within Strong Boundaries

The day-to-day style is direct: make the accepted change, run checks, let Chris or the
appointed product tester exercise the real workflow, and iterate. The surrounding control
system prevents speed from turning into hidden risk:

- current files are read before editing;
- work is isolated on a short-lived work branch;
- changes are bounded by an accepted slice;
- significant mutations have validation, error handling and audit implications considered;
- database changes use reviewed migrations;
- implementation and review evidence are separate;
- staging and live promotion remain explicit gates.

### 3.4 Current Versus Historical Working Guidance

The code repository's
[Working Method Specification](../../../isostack-bedrock/docs/00-READ_THIS/Work_Method.md)
is useful evidence of Chris's collaboration preferences: direct communication, real-file
inspection, practical iteration and hands-on testing.

It is dated December 2025. Its `dev -> techtest -> main` and `db:push` instructions are
historical and must not be followed. They are superseded by:

- the current [Git workflow](../guides/git-workflow.md);
- the [Safe Database Workflow](../../SAFE_DATABASE_WORKFLOW.md);
- the [deployment guide](../guides/deployment/deployment-guide.md); and
- the active root and owning-lane roadmap controls.

The [Codex Operating Charter](../../../isostack-bedrock/docs/00-READ_THIS/CODEX_OPERATING_CHARTER.md)
remains the code-adjacent safety summary, with `isodocs` taking precedence for canonical
roadmap, migration and deployment control.

## 4. Documentation Authority And Lifecycle

### 4.1 Which Repository Owns What

| Source                                 | Authority                                                                                                                     |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `isodocs`                              | Canonical product, architecture, roadmap, planning, implementation, review, deployment-evidence and operational documentation |
| `isostack-bedrock`                     | Primary runtime code, migrations, tests, scripts and short code-adjacent notes                                                |
| Source code and committed migrations   | Final evidence of what the application can actually do; use when narrative documentation and implementation disagree          |
| Live environment configuration         | Final evidence of what a deployed service is configured to use; inspect securely and never copy secret values into docs       |
| Archive folders and dated legacy files | Historical context only unless an active control explicitly reactivates them                                                  |

When two documents disagree, use this order:

1. current root roadmap for cross-lane selection and shared gates;
2. current owning-lane roadmap for scope, sequence and status;
3. accepted bounded slice plan for intended change;
4. implementation confirmation for what was changed;
5. independent review/test and promotion records for what was proved;
6. current source, migration history and deployed configuration for technical reality;
7. overview and archive material for background only.

Record and reconcile a conflict rather than silently choosing a convenient version.

### 4.2 The Delivery Evidence Chain

All first-class Platform, Core and module work should follow:

```text
01-cr-inputs
-> 02-triage
-> root and owning-lane roadmap selection
-> 03-slice-planning
-> implementation in the owning repository
-> 04-implementation-confirmations
-> 05-review-and-test
-> child roadmap reconciliation
-> root roadmap reconciliation
-> controlled environment promotion
```

The folders mean:

| Stage                       | Purpose                                                                                                                           | What it does not prove                                               |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| CR input                    | Captures an issue, request, observation, brief or evidence                                                                        | Priority, acceptance or authority to implement                       |
| Triage                      | Assigns ownership, severity, disposition, dependencies and next action                                                            | That the work has been selected or completed                         |
| Roadmap selection           | Authorises one bounded next action in the appropriate lane and reconciles cross-lane dependencies                                 | Detailed implementation scope                                        |
| Slice plan                  | Defines goal, scope, non-goals, contracts, tenancy, permissions, data effects, failure behaviour, tests, gates and stop condition | That any code was changed                                            |
| Implementation confirmation | Records exact branch/commit, changed files/contracts, migrations, checks, deviations and actions not performed                    | Independent quality or deployment acceptance                         |
| Review and test             | Records independent code review, automated checks, human tests, environment evidence, defects and disposition                     | A production release unless the release gate is explicitly completed |
| Roadmap reconciliation      | Updates the operational source of truth and identifies the next permitted boundary                                                | Permission to skip remaining human or production gates               |
| Promotion record            | Reconciles the exact code, migration and environment bundle promoted through `dev`, staging and live                              | Future work beyond the recorded boundary                             |

### 4.3 What "Complete" Means

Do not use a single vague `done` state. State the exact boundary:

- planned and accepted;
- implemented on a local work branch;
- implementation confirmed;
- independently reviewed and automated checks passed;
- consolidated into `dev`;
- `dev` and `origin/dev` match;
- promoted to staging;
- human staging acceptance passed;
- approved and promoted to live;
- live smoke passed; or
- blocked/pending, with the named gate.

A slice is not deployment-complete while any recorded human, configuration, migration,
external-service or production gate remains pending.

### 4.4 Documentation Hygiene

- Start from [DOCUMENTATION_MAP.md](../../DOCUMENTATION_MAP.md).
- Keep long-lived lifecycle evidence in `isodocs`, not beside runtime source.
- Use one topic per Markdown file and relative links.
- Update the owning-lane roadmap first, then the root roadmap.
- Keep CR observations separate from accepted decisions.
- Keep plans separate from factual implementation confirmation.
- Distinguish automated, human, external-service and environment evidence.
- Move superseded material to the appropriate archive or leave a pointer when moving a
  known path.
- Never rewrite historical evidence to imply that an unperformed action occurred.
- Avoid embedding a volatile "current task" summary in orientation documents; link to the
  active roadmap instead.

## 5. Repository And Codebase Map

### 5.1 Repository Portfolio

| Repository                   | Role                                                           | Default starting point                                         |
| ---------------------------- | -------------------------------------------------------------- | -------------------------------------------------------------- |
| `isocb/isostack-bedrock`     | Primary multi-tenant application, platform and module runtime  | `README.md`, then current branch/status and relevant source    |
| `isocb/iso-docs` (`isodocs`) | Canonical internal documentation and lifecycle evidence        | `DOCUMENTATION_MAP.md`, then root roadmap                      |
| `isocb/Website-LMSPro`       | Separate LMSPro marketing website built with Astro/Tailwind    | Its `README.md`                                                |
| `isocb/Floot-Bedrock`        | Older/related Bedrock development and migration-history source | Treat as legacy until its current role is explicitly confirmed |

Do not assume that all local clones are current, clean or on their default branches. Run
`git status`, `git branch --show-current`, `git remote -v` and `git fetch` before drawing
conclusions. Do not discard unknown worktree changes.

### 5.2 Primary Application Stack

As verified from `isostack-bedrock/package.json` on 2026-07-29:

| Layer                 | Current implementation                                                      |
| --------------------- | --------------------------------------------------------------------------- |
| Runtime               | Node.js 22                                                                  |
| Web application       | Next.js 15 App Router, React 18, TypeScript                                 |
| UI                    | Mantine 7, Tabler Icons, Mantine DataTable                                  |
| API                   | tRPC 11 with SuperJSON                                                      |
| Validation            | Zod                                                                         |
| Authentication        | NextAuth v5, magic-link/passkey and security extensions                     |
| Database              | Prisma 5 with Neon PostgreSQL                                               |
| Email                 | Resend and React Email                                                      |
| Storage               | Cloudflare R2/S3-compatible client where configured                         |
| Rate limiting/caching | Upstash Redis where configured                                              |
| Payments              | Stripe and Stripe Connect foundations where enabled                         |
| Test/build            | Vitest, TypeScript checking, Next build and repository verification scripts |
| Hosting               | Render, with GitHub-driven application deployment                           |

Versions drift. The current `package.json`, lockfile and deployed runtime are authoritative.

### 5.3 Runtime Shape

```text
browser / public client
        |
        v
Next.js App Router and middleware
        |
        +--> authenticated/public route handlers
        |
        v
tRPC context and procedure middleware
        |
        +--> session, organisation, role and entitlement checks
        +--> row-level-security request context
        |
        v
core or module routers -> services/domain helpers
        |
        v
Prisma Client -> Neon PostgreSQL
        |
        +--> public, bedrock, lmspro, pulse, fund and commerce schemas

External boundaries: Render, Resend, Cloudflare R2/DNS, Upstash and Stripe
```

### 5.4 Important Paths In `isostack-bedrock`

| Path                                        | Responsibility                                                                                                                   |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| `src/app/`                                  | Next.js routes, layouts, API route handlers and route groups for public, authentication, tenant, platform and module experiences |
| `src/core/`                                 | Reusable platform UI, providers, configuration, permissions, branding, tooltips, media and shared communication features         |
| `src/server/core/`                          | tRPC context, procedure middleware, shared platform routers and server-side enforcement                                          |
| `src/server/routers/`                       | Additional composed router families, including Bedrock                                                                           |
| `src/modules/`                              | Module-owned UI, routers, services, helpers, registration and configuration                                                      |
| `src/lib/`                                  | Shared infrastructure helpers: Prisma, RLS, security, encryption, email, R2, Stripe, rate limiting, sessions and time zones      |
| `src/components/`                           | Reusable application components outside the core feature tree                                                                    |
| `src/tests/` and colocated `*.test.*` files | Automated verification, including tenant/RLS and domain tests                                                                    |
| `prisma/schema.prisma`                      | Current ORM model across all PostgreSQL schemas                                                                                  |
| `prisma/migrations/`                        | Immutable, ordered deployment history                                                                                            |
| `scripts/`                                  | Verification, migration-support, diagnostics, jobs and narrowly scoped operational utilities; inspect before running             |
| `infra/`                                    | Supporting infrastructure configuration                                                                                          |
| `.github/workflows/`                        | CI/security automation                                                                                                           |
| `render.yaml`                               | Render service/deployment declaration; reconcile with the Render dashboard                                                       |
| `docs/`                                     | Secondary, code-adjacent guidance and historical notes                                                                           |

### 5.5 Platform And Module Boundaries

The reusable platform owns organisation tenancy, identity, authentication, administration,
product/module allocation, shared permissions, settings, branding, tooltips, audit/security
and common services.

Registered application modules include Bedrock, LMSPro, FUND and IsoCare, with billing and
support acting as core-enhancing features. Pulse is also composed into the root API router.
Commerce provides shared commerce/payment foundations and is consumed through platform and
module boundaries; not every internal domain is a routable module.

Module-specific code should remain under `src/modules/<module>/` where practical. Generic
platform behaviour should remain in `src/core/` or `src/server/core/`. Ownership is based
on the capability, not merely the route or filename where it is composed.

### 5.6 Database And Tenancy

The Prisma datasource currently spans these PostgreSQL schemas:

- `public` for shared IsoStack platform records;
- `bedrock`;
- `lmspro`;
- `pulse`;
- `fund`; and
- `commerce`.

The non-negotiable security invariant is organisation isolation. Normal tenant data access
must be scoped by the authenticated/effective organisation, with backend enforcement as
the source of truth. UI visibility is not authorisation.

Protected tRPC procedures establish session and RLS context. Routers must also use the
appropriate role, feature/entitlement and domain-specific checks. Platform-admin and
impersonation paths are exceptional privileged flows and must be audited and reviewed
carefully.

Schema changes must:

1. update `prisma/schema.prisma`;
2. generate a named migration on safe local/development infrastructure;
3. review the SQL and its data effect;
4. commit the migration;
5. validate using the slice's required disposable/local checks;
6. deploy with `prisma migrate deploy` through the controlled environment sequence; and
7. record migration status and smoke evidence.

Never edit an already-deployed migration to change history.

## 6. Branch, Environment And Release Model

The human working model is:

```text
local work branch -> dev -> origin/dev -> staging -> live (`main`)
```

- A local work branch isolates one feature, fix, review or remediation.
- Local `dev` is the accepted integration line.
- `origin/dev` is the shared/backed-up development line.
- `staging` is the online pre-live environment.
- `main` is the live application branch.

Before any promotion, reconcile:

- exact commits and ancestry;
- every included migration, including migrations from other lanes;
- automated evidence;
- required environment-variable names across web/worker/cron services;
- staging database and storage targets;
- pending human, external-provider and security gates;
- rollback/revert options.

Git carries code and migrations. It does not copy Render environment values, environment
groups, database targets, bucket configuration, provider credentials or DNS state. Those
are a separate release gate.

Live promotion requires explicit approval from the authorised human decision-maker. Use a
revert or the platform's controlled rollback facilities; never force-push `main`.

## 7. Logical Handover Process

### 7.1 Appoint Roles

The authorised business representative should name:

| Role                      | Responsibility                                                                             |
| ------------------------- | ------------------------------------------------------------------------------------------ |
| Legal/business authority  | Confirms who may control company assets, accounts, contracts, customer data and spending   |
| Continuity coordinator    | Owns the checklist, decision log, communications and assignment of work                    |
| Technical maintainer      | Preserves service health, repositories, infrastructure, backups and controlled engineering |
| Product/domain owner      | Interprets customer needs and approves product/commercial decisions                        |
| Security/release approver | Reviews privileged access, credential changes and production promotion                     |
| Finance/customer contact  | Maintains provider billing, customer communication and contractual commitments             |

One person may hold several roles in a small organisation, but a second reviewer should be
used for production, security and destructive-data decisions wherever possible.

### 7.2 First 24 Hours: Preserve

- Confirm legal/business authority and create a dated continuity decision log.
- Do not announce technical conclusions until account and service facts are checked.
- Confirm GitHub organisation access and protect `main`, `staging` and `dev`.
- Record the currently deployed application commit and Render service health.
- Confirm Neon project access, environment/database identity, migration status, backup/PITR
  availability and storage/billing state without changing schema.
- Confirm domain registrar/DNS, Render, Resend, R2, Upstash and Stripe billing will not
  lapse.
- Preserve logs, audit history, recovery codes and support correspondence.
- Add authorised replacement administrators through organisation controls or provider
  recovery; do not share personal login sessions.
- Check for open security incidents or provider alerts.
- Freeze non-essential deployment, migration, key rotation and dependency work.
- Inform only the people who need operational or customer-continuity information, using an
  approved business message.

### 7.3 Days 2-7: Establish Controlled Access

Create a private access inventory in the approved password-management system. For each
service record:

- legal owner and billing owner;
- two current administrators;
- recovery email/phone controlled by the company;
- MFA method and sealed recovery path;
- service/project/account identifiers;
- renewal date and payment method owner;
- linked environments and purpose;
- support route and contractual plan;
- last successful access check.

Transfer ownership before removing old access. Rotate credentials only after mapping every
consumer and planning rollback. Special cautions:

- changing an authentication secret may invalidate all sessions;
- changing a database credential before every service is updated causes an outage;
- changing field-level encryption keys incorrectly can make stored data unreadable;
- changing a Stripe webhook secret requires coordinated endpoint configuration;
- changing R2 or email credentials can break workers/background delivery as well as the web
  service;
- environment groups may affect several Render services at once.

Use one controlled change at a time, verify it, record only the credential name/version and
result, then continue. Never put the value itself in the handover record.

### 7.4 First Two Weeks: Understand Before Resuming

The technical maintainer should:

1. Clone or update `isodocs` and `isostack-bedrock` using their own authorised account.
2. Read this handbook, `DOCUMENTATION_MAP.md`, the root roadmap, the relevant child roadmap,
   the Git workflow and safe database workflow.
3. Identify the exact live, staging, `origin/dev` and active local-work boundaries.
4. Review pending human, security, environment, migration and customer gates.
5. Set up local development from `.env.example`, obtaining values through the private
   vault. Do not copy a production database URL into local development.
6. Run non-mutating checks first: install, type-check, focused tests and build as
   appropriate.
7. Walk through authentication, organisation isolation, platform administration and each
   currently active customer/module workflow in staging.
8. Meet the product/domain owner and convert undocumented assumptions into CR inputs or
   open questions, not immediate code.
9. Confirm incident contacts, support expectations, backups, billing and renewal dates.
10. Produce a dated takeover status record with known facts, risks, gaps and the next
    authorised boundary.

### 7.5 Resuming Development

Do not resume from the most recent timestamp alone. Use this sequence:

```text
root roadmap
-> owning-lane roadmap
-> accepted slice plan
-> application commit and migration evidence
-> implementation confirmation
-> review/test record
-> promotion record
```

Then:

1. reconcile whether the selected slice is already implemented, reviewed or promoted;
2. inspect all associated worktrees and remote branches before deleting or reusing them;
3. verify that no pending gate is being mistaken for a new implementation task;
4. create a fresh bounded work branch from the correct `dev` baseline;
5. perform only the authorised next action;
6. complete the same evidence lifecycle and stop at the next boundary.

If the roadmaps are stale or contradictory, pause executable work and create a reconciliation
record. Do not infer product authority from code comments, an AI transcript or an old plan.

## 8. Service And Access Register

Keep actual usernames, recovery details, keys and account numbers in the approved private
vault. This table is only the non-secret checklist.

| Service/capability                  | Purpose                                                                  | Continuity check                                                                                |
| ----------------------------------- | ------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------- |
| Company email and password manager  | Root recovery and privileged identity                                    | Two company-controlled admins, MFA/recovery tested, emergency record sealed                     |
| GitHub organisation/repositories    | Source, history, CI and branch protection                                | Two owners, billing current, deploy integrations understood, branch rules preserved             |
| Render                              | Web, worker/cron services, environment configuration and deployment      | Two admins, each service/environment mapped, billing current, live commit recorded              |
| Neon                                | PostgreSQL environments, branches, backups/PITR                          | Two admins, projects/databases mapped, retention and restore test understood                    |
| Domain registrar and DNS/Cloudflare | Domains, DNS, certificates, Turnstile and possibly R2                    | Registrant and billing controlled by company, renewal locked, recovery tested                   |
| Cloudflare R2                       | Private/public object and email-attachment storage where configured      | Buckets, access policies, CORS, lifecycle and backups mapped                                    |
| Resend                              | Transactional email, sender domains and delivery evidence                | Domain ownership, API consumers, suppression/delivery access and billing mapped                 |
| Upstash                             | Redis-backed rate limiting/session-security support where configured     | Database purpose, environment consumers and fallback impact mapped                              |
| Stripe                              | Platform billing and connected-account/payment foundations where enabled | Account ownership, bank/finance authority, webhooks, restricted keys and live/test modes mapped |
| Google/provider integrations        | OAuth or API integrations where configured                               | Consent screen/project ownership and credential consumers mapped                                |
| Monitoring/support channels         | Logs, alerts, customer issue intake and incident communication           | Alerts reach more than one person; retention and escalation path documented                     |
| Marketing repositories/hosting      | LMSPro and other public sites                                            | Repository, DNS, deployment provider and form/analytics ownership mapped                        |

If a listed integration is not active, record `not active` with the verification date rather
than deleting it from the checklist.

## 9. Safe Operational Priorities

Use this order during an incident or uncertain takeover:

1. protect people, customer data and legal authority;
2. preserve access and evidence;
3. keep the existing live service stable;
4. stop active compromise or billing/domain expiry;
5. restore from a known-good service/deployment state if necessary;
6. verify database integrity and tenant isolation;
7. communicate known impact without speculation;
8. document decisions and commands;
9. only then resume planned product work.

Do not use a general diagnostic or legacy script merely because its filename sounds
relevant. Read it, identify its database/environment target and understand its mutation
behaviour first. Many scripts are intentionally narrow and some can alter customer or test
data.

## 10. Non-Negotiable Guardrails

A successor or agent must never:

- perform ordinary work directly on `main`;
- force-push a shared branch;
- treat `techtest` as part of the current standard pipeline;
- run `db:push`, `db:seed`, reset or destructive SQL in a deployed environment;
- point local tools at live without a separately authorised, read-only operational need;
- make an unscoped tenant query or rely on UI visibility as permission enforcement;
- bypass accepted module, entitlement, role or audit boundaries;
- rotate encryption/database/authentication secrets without a consumer and rollback plan;
- copy staging configuration blindly into live;
- expose secrets or customer data in Git, documentation, logs, issue exports or AI prompts;
- claim review, human acceptance, deployment or migration evidence that was not performed;
- select work directly from a CR, archive document or abandoned branch;
- silently turn an unresolved business question into implementation;
- delete unknown branches, worktrees, databases, buckets or provider projects during
  housekeeping.

## 11. Known Continuity Gaps To Close

The following should be completed and maintained outside this public-to-collaborators
Markdown file where the information is sensitive:

- named legal/business successor and deputy;
- named technical maintainer and emergency provider contacts;
- company-controlled password vault and sealed recovery procedure;
- two administrators for every critical service;
- exact Render service/environment inventory;
- exact Neon project/database/backup inventory;
- domain registrar, renewal and DNS ownership register;
- customer, supplier, contract, billing and insurance register;
- data-processing, privacy, breach and retention contacts;
- tested backup restoration and service rollback record;
- an approved customer/stakeholder continuity communication template;
- a quarterly access and key-person-risk review.

Security note found during the 2026-07-29 verification: `.env.example` in
`isostack-bedrock` contains a commented credential-like database URL. Treat it as exposed:
remove it from the example, determine whether the credential is valid or has ever been
valid, rotate/revoke it as appropriate, and assess Git history. Do not reproduce the value
in documentation or discussion.

## 12. Quarterly Continuity Review

Record the review date and reviewer in a separate dated continuity record. Confirm:

- [ ] Legal/business authority and deputies are current.
- [ ] At least two authorised administrators can access each critical provider.
- [ ] MFA and recovery paths are valid and company controlled.
- [ ] Repository and branch protections match the current release model.
- [ ] Root and child roadmaps identify the real current boundary.
- [ ] Live/staging commits, migrations and environment ownership are reconcilable.
- [ ] Backups/PITR and one safe restoration exercise are current.
- [ ] Domain, provider, licence and payment renewals are funded.
- [ ] Encryption, authentication and provider-key rotation plans are documented privately.
- [ ] Customer support and incident alerts reach more than one person.
- [ ] No secrets or credential-bearing URLs are present in tracked files.
- [ ] This handbook still matches the actual repository and service structure.

## 13. Definition Of A Successful Handover

The handover is successful when an authorised successor can:

- identify the current source of product and delivery authority;
- explain the live architecture and tenant-safety model;
- access every critical system through their own audited identity;
- keep the current service operating without Chris's personal accounts;
- restore or roll back the service using a tested procedure;
- reproduce the application locally without using live customer data;
- distinguish planned, implemented, reviewed, staged and live work;
- complete one small bounded change through planning, implementation, independent review,
  staging acceptance and authorised live promotion;
- maintain customer, provider, security and billing continuity; and
- continue recording evidence so the next handover is easier than this one.
