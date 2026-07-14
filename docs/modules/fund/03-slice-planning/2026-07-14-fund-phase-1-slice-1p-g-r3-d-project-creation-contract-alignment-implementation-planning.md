# FUND Phase 1 Slice 1P-G-R3-D - Project Creation Contract Alignment Implementation Planning

Date: 2026-07-14

Status: Accepted for bounded implementation

Parent controls:

`docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`

`docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

Preceding completed lifecycles:

- `1P-G-R3-A` Project Intake Automation Schema And Form Policy Foundation;
- `1P-G-R3-B` Project Intake Automated Provisioning And Protection Services;
- `1P-G-R3-C` Project Intake Form, Confirmation And Exception-Review Alignment;
- `1R-C2` Client Branding, Project Delivery And Event Media schema foundation;
- `1P-K1-F` Client-member login/access policy and `1P-K2` Client dashboard Project management.

## 1. Goal

Replace the two older non-Intake Project writers—the C1 Project dashboard and the C2/K2
Client dashboard—with one current Project-creation contract. A successful creation must
establish one coherent aggregate:

```text
C1 tenant
-> active C2 Client/project-owning body
-> active login-capable Client-member organiser
-> typed draft Project
-> Project-owned delivery profile copied from Client/member defaults
-> transactional audit evidence
```

The work aligns direct dashboard creation with the later Intake and delivery architecture.
It does not change public Intake behaviour, create a Store, or introduce Commerce.

## 2. Accepted Current Contract

The following rules replace the superseded FUND development-only contract:

1. Every newly created Project belongs to exactly one `FundClient`.
2. A standalone Project is a Client-owned Project with no Event. It is never a Project with
   no Client.
3. Every Project identifies one same-tenant member of that Client as organiser. The
   organiser must be active, linked to an active same-tenant User, dashboard-enabled and
   hold `PROJECT_MANAGER` or `ADMIN` access.
4. Project type is typed Project data, not an unvalidated metadata convention.
5. Project opening and closing dates are required. Closing must follow opening; an Event
   Project must remain inside the Event window.
6. Every new Project receives exactly one `FundProjectDeliveryProfile` in the same
   transaction. Missing delivery is a failed creation, not a partially configured result.
7. `FundClient` owns a structured primary organisation address. Project delivery copies
   that address once, with the Client name as recipient and organiser details as attention,
   email and phone defaults. Later changes to either source do not rewrite the Project
   delivery snapshot.
8. C1 may create a Project only after selecting the Client and eligible organiser. C2 may
   create only for the Client resolved from the authenticated member context and uses that
   member as organiser.
9. Project number and slug are server-generated with bounded unique-conflict retry. They
   are identifiers, not required business input.
10. C2 idempotency is transactionally protected; concurrent retries cannot create two
    Projects.
11. Project creation, delivery creation and creation audits commit or roll back together.

The Product/Project-type eligibility contract must read the typed Project value after this
slice. New code must not write or depend on `metadata.projectType`.

## 3. Data Foundation

### 3.1 `FundProjectType`

Add one FUND-prefixed enum:

```text
FundProjectType
- ARTWORK_FUNDRAISING
- GROUP_PERSONALISED_PRODUCTS
- BULK_ORDER_CLUB_FUNDED
- NOT_SURE
```

Add required `FundProject.projectType` mapped to `project_type`.

### 3.2 Structured Client address

Add required structured primary-address fields to `FundClient`:

```text
addressLine1
addressLine2?
addressLine3?
locality
region?
postalCode
countryCode char(2)
```

Required address components must be nonblank after trimming. Country code must contain two
uppercase ASCII letters. This is the Client organisation's current primary address, not a
reusable address book and not historic Order evidence.

### 3.3 Required Client and organiser identity

Make `FundProject.clientId` required and add required `organiserMemberId`. Enforce the
organiser relation through the existing exact composite Client-member key:

```text
(organizationId, organiserMemberId, clientId)
-> FundClientMember(organizationId, id, clientId)
```

Use `Restrict` deletion. A Client member referenced as organiser cannot be deleted out from
under a Project. The existing organiser name/email/phone columns remain immutable-at-create
contact snapshots and are populated from the selected member.

## 4. Migration And Existing Data Rule

The user has confirmed that FUND contains no live operational data; IsoStack is currently
live only for LMSPro. Obsolete FUND development rows do not constrain this design.

Use one bounded 134-to-135 migration. Before adding required columns or changing Client
nullability, the migration must fail clearly if `fund_clients` or `fund_projects` contains
rows. It must never guess addresses, Client ownership, organiser membership or Project type,
and it must not delete rows automatically. The operator may clear non-authoritative FUND
development data deliberately before deployment if the precondition detects it.

The migration then adds the enum/columns/foreign key and address checks. It changes no
LMSPro table, enum, relation or data.

Rollback is application/schema rollback before shared deployment. Once the migration is
applied, rollback requires an explicit forward migration; migration-history files must not
be rewritten.

## 5. Shared Creation Service

Create one internal Project aggregate service used by both direct dashboard paths. It must:

- run in a serializable transaction;
- take tenant, Client, organiser member, Project type, optional Event, required dates,
  Project text and source/idempotency evidence;
- lock C2 idempotency and duplicate keys with deterministic transaction advisory locks;
- re-read and validate active Client, organiser member/User/access and Event authority in
  the transaction;
- reject same-name/same-Client/same-Event/same-date duplicate Projects;
- generate identifiers with bounded retry;
- create the Project and delivery profile;
- write creation, Client-link, Event-link where applicable, organiser and delivery audit
  evidence in the same transaction;
- return an already-created result for an exact C2 retry and reject a reused key with
  changed evidence.

The C1 route may use the same duplicate protection without exposing an idempotency key in
the UI. The C2 route retains its client-generated key.

## 6. C1 And C2 Application Alignment

### 6.1 Client management

C1 Client create/edit must capture the structured primary address. Client list/detail
serializers must expose it only to authenticated tenant-scoped FUND surfaces. Intake
provisioning must populate these fields when it creates a new Client from confirmed typed
evidence.

### 6.2 C1 Project creation

The C1 create modal must require:

- Client;
- eligible organiser from that Client;
- Project name and type;
- optional Event;
- opening and closing dates.

It must explain that delivery will be copied from the selected Client/member defaults.
Project number/slug manual inputs and the clientless option are removed.

### 6.3 C2 Project creation

The C2 modal retains name, Project type, Event and date inputs. Client and organiser come
only from authenticated context. The service copies Client/member defaults into delivery.
If the Client lacks a complete structured address, creation fails safely and instructs C1
to complete the Client details; it never invents or silently omits delivery.

### 6.4 Existing edit surfaces

Project type reads and writes use the typed column. Client/Event/member ownership changes
must continue to obey draft/edit guards and exact tenant constraints. R3-D does not add a
general delivery-address editor: its bounded responsibility is guaranteeing the initial
profile. The existing Project delivery profile remains the authority for the later bounded
C1/C2 delivery-management surface.

## 7. Explicit Exclusions

Do not add or change:

- Project Intake public form, confirmation, exception-review or provisioning decisions
  except the mechanical new-Client address and typed Project write required by the shared
  schema;
- Store readiness, Store creation/publication, public Store routes or Store UI;
- Commerce checkout, Orders, Order lines, payments, refunds or Stripe;
- uploads, production assets/workflow, commission calculation or settlement;
- invitations, onboarding email or generic notification behaviour;
- LMSPro schema, service, route, UI or data;
- a Client address book, Order address snapshot or dispatch workflow.

## 8. Validation

Use only `TEST_DATABASE_URL` after proving it is distinct from `DATABASE_URL`.

Required evidence:

1. Prisma format/validate/generate and exactly 135 migrations.
2. Full fresh migration replay.
3. Representative 134-to-135 migration with empty FUND and unrelated LMSPro/platform rows
   preserved.
4. Explicit failure when a legacy FUND Client or Project row exists.
5. Address nonblank/country constraints.
6. Required Client/type/organiser keys and cross-tenant/cross-Client rejection.
7. C1 aggregate creation and Event/standalone date rules.
8. C2 authenticated authority, exact retry and concurrent retry behavior.
9. Duplicate Project rejection and injected rollback after Project, delivery and audit
   stages.
10. New-Client Intake provisioning writes Client address, typed Project, organiser key and
    delivery atomically; existing Intake/public safety remains unchanged.
11. K1-F/K2, R3-A/R3-B/R3-C and A1/C1/C2/C3/C4/C5 static regressions.
12. Type-check, focused lint, verification scripts, `git diff --check` and zero disposable
    test residue.

## 9. Review And Acceptance

Review completed on 2026-07-14 against the current 134-migration Prisma model, both direct
Project writers, the completed R3-A/B/C Intake path, K1-F/K2 authority, 1R-C2 delivery
semantics and the user's explicit no-live-FUND-data clarification.

Resolved conflicts:

- clientless “standalone” is retired in favour of Client-owned/Event-null;
- metadata Project type is replaced by a typed required column;
- organiser text alone is replaced by an exact Client-member relation plus snapshots;
- delivery-less direct creation is replaced by atomic Project/delivery creation;
- Client primary address is made structured so repeat Projects have a legitimate default;
- manual C1 identifiers and weak C2 idempotency are replaced by shared server authority;
- legacy FUND compatibility is not allowed to weaken the current model, while a migration
  precondition prevents silent data destruction.

No unresolved product or architecture question remains. The plan is accepted for the
bounded implementation above. Completion requires a separate implementation confirmation,
review/test record and recursive FUND/root roadmap and planning README updates.

