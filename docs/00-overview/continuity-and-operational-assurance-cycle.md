# IsoStack Continuity And Operational Assurance Cycle

Purpose: define the recurring review, exercise and evidence cycle that keeps IsoStack's
continuity arrangements current across repositories, providers, people and operational
processes.

Status: active subordinate operational-assurance control

Authority boundary: this document does not select development work, authorise implementation,
approve database or infrastructure changes, or replace the root and owning-lane roadmaps.

Owner: Isoblue / IsoStack

Effective date: 2026-07-29

Next baseline review due: 2026-08-31

Review this control annually and whenever its scope, ownership or evidence structure changes.

Internal use only. Do not record passwords, secret values, recovery codes, complete database
URLs or customer data in this control or its review records.

## 1. Governing Documents

This cycle governs the review of:

- [Routine IsoStack Management Handbook](./routine-isostack-management-handbook.md);
- [Technical Continuity And Succession Handbook](./technical-continuity-and-succession-handbook.md);
- [IsoStack Tools And AI Support Guide](./isostack-tools-and-ai-support-guide-for-lay-custodians.md);
- the non-secret service and contact inventory;
- provider ownership, access, billing and recovery arrangements;
- backup, restoration, rollback and incident readiness;
- customer and stakeholder continuity communications; and
- replacement-maintainer readiness.

Technical and security assurance remains governed by the
[Platform Assurance, Security Review And Refinement Roadmap](../platform/00-roadmap-control/2026-07-22-isostack-platform-assurance-security-review-and-refinement-roadmap.md).

Cross-lane selection and executable work remain governed by the
[IsoStack Platform And Module Roadmap Control](../00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md).

## 2. Why The Cycle Exists

Continuity information becomes unsafe when it is correct only on the day it was written.
People leave, cards expire, domains renew, provider interfaces change, modules are added and
recovery assumptions become stale.

This cycle provides:

- a small monthly operational check;
- a formal quarterly continuity review;
- a practical six-monthly tabletop exercise;
- a full annual continuity audit; and
- event-driven updates after material change.

Annual review alone is insufficient for account, billing, access and provider risks. The
layered cycle keeps routine work proportionate while preserving a dated evidence trail.

## 3. Control Boundary

This is a calendar and evidence control, not a product roadmap.

It may:

- schedule recurring checks;
- record observations and evidence;
- identify Green, Amber or Red findings;
- assign an owner and due date;
- refer a finding to the appropriate business, privacy, provider-support or technical
  control; and
- confirm that a previously assigned continuity action was closed.

It may not:

- nominate the next development slice;
- authorise code, schema, migration or infrastructure implementation;
- authorise staging or live promotion;
- make a product or commercial decision;
- perform a database restore or application rollback; or
- bypass the root roadmap, Platform Assurance roadmap or module controls.

When a review identifies technical remediation:

```text
continuity review finding
-> correct owner/triage lane
-> roadmap selection where required
-> bounded slice plan
-> implementation confirmation
-> independent review/test
-> controlled promotion
-> continuity finding closure evidence
```

An urgent live incident may be contained under the accepted incident authority. The evidence
and normal lifecycle must then be reconciled after containment.

## 4. Roles

| Role                           | Responsibility                                                                                       |
| ------------------------------ | ---------------------------------------------------------------------------------------------------- |
| Continuity owner               | Schedules reviews, ensures evidence is recorded and owns the master register                         |
| Deputy continuity owner        | Can run the cycle if the primary owner is unavailable                                                |
| Lay operational custodian      | Completes routine provider, billing, contact and service checks                                      |
| Technical reviewer             | Validates repository, deployment, database and recovery evidence without silently implementing fixes |
| Product/business owner         | Confirms customer, commercial and module-operating priorities                                        |
| Privacy/security contact       | Owns suspected data exposure, privileged-access and breach-related decisions                         |
| Finance/administration contact | Confirms provider invoices, payment methods, contracts and renewals                                  |

One person may hold several roles, but production, destructive-data and security decisions
should receive a second-person review wherever possible.

The named people and private contact details belong in the approved private company register,
not this repository.

## 5. Cadence

| Frequency        | Scope                                                                                                                                           | Evidence requirement                                                      |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| Each working day | Shared operational inbox and active provider/customer alerts                                                                                    | Incident record only when action or escalation is required                |
| Weekly           | Live site, health page, Render web/cron status, Neon availability, GitHub Actions and renewal warnings                                          | Routine operations log; escalate exceptions                               |
| Monthly          | Provider billing/access, shared alerts, domains, restore-window visibility, open incidents and current Platform Assurance result                | Short dated monthly check or consolidated quarterly evidence              |
| Quarterly        | Formal handbook, people, provider, recovery, repository, communications and successor-readiness review                                          | Dated review record using the template                                    |
| Every six months | Tabletop exercise using a realistic continuity or outage scenario                                                                               | Dated exercise record with observations and corrective actions            |
| Annually         | Full technical, operational, business, legal/privacy and recovery-readiness audit                                                               | Annual review and exercise sign-off                                       |
| Event-driven     | Material change to people, providers, architecture, access, billing, deployment, database, authentication, critical modules or incident lessons | Update affected documents within five working days and record the trigger |

Daily and weekly tasks remain defined in the Routine IsoStack Management Handbook. This
control does not create duplicate logs when no exception occurs.

## 6. Schedule Rules

### 6.1 Monthly

Complete by the last working day of each month.

Minimum checks:

- critical provider invoices and payment methods are current;
- company-controlled administrators and recovery routes remain available;
- shared alert inboxes are receiving provider and security notices;
- domain and certificate renewals are not at risk;
- Render live web and scheduled services are identifiable;
- Neon live project and visible restore window are identifiable;
- GitHub scheduled security/assurance results have an owner when non-green;
- open continuity incidents and actions have a current owner and due date; and
- no new material provider or service has been omitted from the inventory.

The Platform Assurance roadmap owns the underlying technical security review. The continuity
check records its current disposition and evidence link rather than repeating the audit.

### 6.2 Quarterly

Complete within ten working days of 31 March, 30 June, 30 September and 31 December.

Minimum checks:

- all three continuity guides remain accurate and mutually linked;
- the non-secret service card is complete;
- every critical provider has at least two authorised administrators;
- MFA and company-controlled recovery routes are confirmed;
- ownership, billing and renewal responsibilities are current;
- actual Render, Neon and GitHub topology matches the handbooks;
- backup/PITR and application rollback arrangements are understood;
- restoration and rollback have not been confused or assumed equivalent;
- customer/privacy incident contacts and message templates are current;
- open findings have an owner, target date and correct escalation lane;
- replacement-maintainer access and onboarding material remain usable; and
- secrets or credential-bearing URLs are absent from tracked continuity material.

### 6.3 Six-Monthly Tabletop

Run one discussion-based exercise without changing the live service.

Rotate scenarios such as:

- the live site and health page fail while the developer is unreachable;
- email sign-in and queued messages stop while the website remains healthy;
- a customer reports data belonging to another organisation;
- the primary Render, Neon or GitHub administrator is unavailable;
- a payment method is declined shortly before provider suspension;
- the domain or DNS account cannot be accessed;
- the database appears to have lost recent data; or
- a replacement maintainer must take over with no verbal handover.

The exercise must identify:

- who takes authority;
- the first ten-minute checks;
- what must not be changed;
- the escalation and communication route;
- evidence that would be collected;
- unresolved access or knowledge gaps; and
- actions, owners and due dates.

A tabletop is not authority to test a live restart, deploy, rollback or database restore.

### 6.4 Annual

Complete a full review covering:

- this continuity control and all three companion guides;
- company/legal authority and succession arrangements;
- provider, contract, supplier, licence and renewal ownership;
- data-protection, breach, retention and cyber-insurance contacts;
- repository ownership, branch protection and recoverable history;
- Render services, configuration ownership and release/rollback contracts;
- Neon projects, environment isolation, restore window and recovery objectives;
- Resend, Upstash, Cloudflare/R2, Stripe and other active supporting services;
- documented Recovery Time Objective and Recovery Point Objective where agreed;
- one safe, technically controlled recovery exercise on non-production/disposable
  infrastructure;
- replacement-maintainer onboarding and a small end-to-end controlled change exercise; and
- closure or formal acceptance of longstanding continuity risks.

Legal, insurance and contractual review requires the appropriate professional or authorised
company officer. This technical documentation does not provide legal advice.

### 6.5 Event-Driven

Review affected documents within five working days after:

- a critical administrator, employee, contractor or company officer changes;
- a provider account, billing owner, payment method or recovery contact changes;
- a new provider or externally hosted dependency is introduced;
- a live/staging service, worker, cron job, database, branch or domain is added or removed;
- authentication, encryption, storage, email or payment architecture changes;
- the Git/deployment/migration workflow changes;
- a new critical module or customer workflow goes live;
- an incident exposes a missing or incorrect instruction;
- a restoration, rollback or credential-rotation process is exercised; or
- a handbook reader cannot follow the documented process.

An event-driven update resets only the affected evidence. It does not replace the next formal
quarterly or annual review.

## 7. Evidence Structure

The stable control is this file.

Review evidence lives under:

```text
docs/continuity/reviews/
├── CONTINUITY_REVIEW_TEMPLATE.md
└── YYYY/
    ├── YYYY-MM-DD-<period>-continuity-review.md
    └── YYYY-MM-DD-<scenario>-tabletop-exercise.md
```

Use the
[Continuity Review Template](../continuity/reviews/CONTINUITY_REVIEW_TEMPLATE.md) for formal
quarterly, six-monthly and annual records.

Records must:

- use factual evidence and links;
- distinguish observed, confirmed, not checked and not applicable;
- identify who performed each privileged verification;
- state actions deliberately not performed;
- label every finding Green, Amber or Red;
- give every non-Green finding an owner, route and target date;
- avoid secrets and unnecessary customer data; and
- remain immutable evidence after sign-off, with later corrections added as dated addenda.

## 8. Disposition

Use:

| Disposition    | Meaning                                                                                      | Required response                               |
| -------------- | -------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| Green          | Control exists, evidence is current and no material gap is known                             | Record and continue                             |
| Amber          | Service can continue but an access, evidence, ownership or readiness gap exists              | Assign owner and due date; monitor monthly      |
| Red            | Material risk to availability, tenant data, legal authority, recovery or provider continuity | Escalate immediately and pause conflicting work |
| Not assessed   | The review has not yet gathered sufficient evidence                                          | Assign who will assess and by when              |
| Not applicable | The control genuinely does not apply                                                         | Record the reason                               |

An overall Green result requires all mandatory Red items to be absent and all Amber items to
have accepted owners and dates. Do not convert `Not assessed` to Green.

## 9. Corrective-Action Routing

| Finding type                                                    | Route                                                                   |
| --------------------------------------------------------------- | ----------------------------------------------------------------------- |
| Provider billing, renewal or account ownership                  | Continuity owner plus finance/administration                            |
| Missing administrator or recovery access                        | Legal/business authority plus provider support/security contact         |
| Customer communication or contractual commitment                | Product/business owner                                                  |
| Privacy, customer-data exposure or suspicious privileged access | Privacy/security incident process                                       |
| Repository, CI, dependency or technical-security weakness       | Platform Assurance roadmap                                              |
| Module-specific behaviour or workflow defect                    | Owning module CR/triage/roadmap                                         |
| Database, migration, backup or restore weakness                 | Technical reviewer, Safe Database Workflow and correct roadmap lane     |
| Missing handbook instruction                                    | Update this continuity documentation and record the triggering evidence |

The review record may open or reference an action. It must not silently implement the remedy.

## 10. Initial Schedule

| Review                             | Due        | Evidence record                                                                                      | Status                              |
| ---------------------------------- | ---------- | ---------------------------------------------------------------------------------------------------- | ----------------------------------- |
| Initial continuity baseline        | 2026-08-31 | `docs/continuity/reviews/2026/2026-08-31-q3-initial-continuity-baseline-review.md`                   | Planned; no review evidence claimed |
| Q3 2026 formal reconciliation      | 2026-09-30 | To be created from the template or combined with the signed baseline if completed within the quarter | Planned                             |
| First six-monthly tabletop         | 2026-10-31 | Scenario record to be created                                                                        | Planned                             |
| Q4 2026 formal review              | 2026-12-31 | To be created                                                                                        | Planned                             |
| First full annual continuity audit | 2027-07-31 | To be created                                                                                        | Planned                             |

Monthly checks begin in August 2026 and fall due on the last working day of each month.

## 11. Master Review Register

Update this compact register when a formal record is opened or closed. Detailed evidence
belongs in the dated record.

| Period                   | Review owner    | Overall disposition | Evidence                                                                                                  | Open actions      | Last updated |
| ------------------------ | --------------- | ------------------- | --------------------------------------------------------------------------------------------------------- | ----------------- | ------------ |
| Q3 2026 initial baseline | To be appointed | Not assessed        | [Planned baseline record](../continuity/reviews/2026/2026-08-31-q3-initial-continuity-baseline-review.md) | None assessed yet | 2026-07-29   |

Do not use this register to claim completion without a signed evidence record.

## 12. Definition Of A Healthy Cycle

The cycle is healthy when:

- each scheduled review has an owner before its due date;
- the last quarterly and annual evidence records are easy to find;
- non-Green findings have current owners and dates;
- technical findings are visible in the proper assurance/roadmap lane;
- provider, billing and access risks are reviewed more frequently than annually;
- event-driven changes are reflected within five working days;
- no review depends solely on Chris's memory or personal accounts;
- at least one deputy can run the cycle;
- exercises produce learning rather than unverified completion claims; and
- the next successor can understand what was checked, what was not and what remains open.
