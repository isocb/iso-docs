# IsoStack Q3 2026 Initial Continuity Baseline Review

Review period: Q3 2026 initial baseline

Review type: Initial quarterly baseline

Planned review date: on or before 2026-08-31

Status: Planned

Overall disposition: Not assessed

Continuity owner: To be appointed

Deputy: To be appointed

Participants: To be appointed

Evidence cutoff: Not established

## 1. Purpose

Establish the first formal baseline under the
[IsoStack Continuity And Operational Assurance Cycle](../../../00-overview/continuity-and-operational-assurance-cycle.md).

This planned record does not claim that provider access, billing, recovery, repository,
security, restoration or successor-readiness evidence has been checked.

## 2. Required Sources

- [ ] Continuity And Operational Assurance Cycle
- [ ] Routine IsoStack Management Handbook
- [ ] Technical Continuity And Succession Handbook
- [ ] IsoStack Tools And AI Support Guide
- [ ] Current root roadmap
- [ ] Current Platform Assurance disposition
- [ ] Current non-secret service card
- [ ] Private company authority/contact register

## 3. Baseline Scope

The baseline should establish:

- named primary and deputy continuity owners;
- actual live website and health-check address;
- actual Render workspace, live web service and scheduled services;
- actual Neon live project/branch identity without recording a connection string;
- GitHub organisation owners and repository continuity;
- active Resend, Upstash, Cloudflare/R2, Stripe and domain/DNS dependencies;
- provider billing, renewal, MFA and recovery ownership;
- current restore-window and rollback/recovery evidence;
- customer, privacy, security and provider escalation contacts;
- current handbook accuracy and gaps;
- replacement-maintainer onboarding readiness; and
- the first six-monthly tabletop scenario and participants.

## 4. Planned Evidence Table

| Control                                  | Current result | Required evidence                                                   | Proposed owner                                        |
| ---------------------------------------- | -------------- | ------------------------------------------------------------------- | ----------------------------------------------------- |
| Continuity owner and deputy              | Not assessed   | Authorised company appointment                                      | To be appointed                                       |
| Live website and `/api/health`           | Not assessed   | Dated non-secret observation                                        | Lay operational custodian                             |
| Render topology and access               | Not assessed   | Workspace/service names, roles and billing status                   | Authorised Render administrator                       |
| Neon topology and recovery               | Not assessed   | Project/branch names, roles and visible restore window              | Authorised Neon administrator plus technical reviewer |
| GitHub ownership and branches            | Not assessed   | Organisation owners, repository visibility and protected-line state | Authorised GitHub owner                               |
| Resend and Upstash                       | Not assessed   | Active service names, administrators, billing and alert routes      | Provider administrators                               |
| Domain/DNS/storage/payment dependencies  | Not assessed   | Non-secret ownership and renewal inventory                          | Finance/administration plus provider administrators   |
| Recovery and rollback readiness          | Not assessed   | Reviewed runbooks and evidence boundary                             | Technical reviewer                                    |
| Privacy/security/customer communications | Not assessed   | Named private contacts and approved templates                       | Privacy and business owners                           |
| Replacement technical support            | Not assessed   | Access/onboarding checklist and identified gap register             | Continuity owner                                      |

## 5. Findings

No findings are claimed before the baseline review.

The absence of a finding in this planned record is not evidence of Green status.

## 6. Planned Completion

At the review:

1. copy or expand the current
   [Continuity Review Template](../CONTINUITY_REVIEW_TEMPLATE.md);
2. replace `Not assessed` only where factual evidence is available;
3. create identifiers, owners and dates for every non-Green finding;
4. route technical findings to Platform Assurance or the correct module lane;
5. set the overall disposition;
6. sign the evidence record; and
7. update the master register in the cycle control.
