# ClubPro Concept Development And Product Boundary

Date: 2026-07-08
Module / product concept: ClubPro
Document type: Concept development / product boundary control
Status: Discussion input
Related LMSPro CR:

- `docs/modules/lmspro/01-cr-inputs/2026-07-08-lmspro-cr-club-player-management.md`

## 1. Boundary Decision

ClubPro should be treated as a separate product concept and product-composition question,
not as a direct LMSPro remediation or near-term SeasonPro feature slice.

The related LMSPro Club Player Management CR remains intentionally narrower:

```text
Club-owned player management, Team Manager access and team-scoped club operations inside
the existing SeasonPro/LMSPro product.
```

That LMSPro CR can proceed without requiring a ClubPro platform/product rewrite.

ClubPro should instead remain as a strategic concept-development document until its
tenant model, product boundary, commercial positioning and module composition are accepted.

## 2. Assessment: ClubPro as a module/offshoot of SeasonPro

Yes — **ClubPro is a logical and potentially valuable extension**, but I would be careful not to treat it as “SeasonPro without the league”. It shares a lot of data structures and workflows, but the **centre of gravity changes**.

SeasonPro is fundamentally:

> **League-led governance, approvals, fixtures, clubs, teams and compliance.**

ClubPro would be:

> **Club-led administration, membership, teams, communications, subscriptions and delegated data maintenance.**

That difference matters because it changes the product framing, data model, permissions, pricing and development priorities.

## 3. Working Position

ClubPro should not fork SeasonPro. The better architecture is:

```text
Shared IsoStack/SeasonPro modules, configured around a club-first product boundary.
```

In practical terms:

- SeasonPro remains league-governance-led.
- ClubPro becomes club-operations-led.
- Member becomes a first-class concept.
- Club may be a tenant in its own right, not only a child object under a League.
- Shared modules should be extracted/configured, not copied into a separate codebase.

## 4. Cautions

Key cautions before any implementation:

- Do not let ClubPro expand the LMSPro player-management slice into a broad product rewrite.
- Do not assume `Club -> Team -> Player` is sufficient for all sports or club types.
- Do not expose league-facing player/member visibility by default.
- Do not create a separate codebase unless shared-module composition has genuinely failed.
- Do not start subscriptions/payments before Member, Club tenancy and role boundaries are
  clear.
- Do not build sport-specific assumptions into the core ClubPro model.
- Do not underestimate volunteer-user support, onboarding, help text and data-quality
  workflow needs.

---

## 5. Strategic Fit

ClubPro is a strong fit because it reuses much of the SeasonPro/IsoStack foundation:

| Shared with SeasonPro   | ClubPro-specific emphasis                     |
| ----------------------- | --------------------------------------------- |
| Clubs                   | Members                                       |
| Teams                   | Subscriptions                                 |
| Users and roles         | Team manager self-service                     |
| Communications          | Club-wide, team-level and member-level comms  |
| Safeguarding/compliance | Club policies, consents, emergency contacts   |
| Data quality workflows  | Delegated maintenance by managers/secretaries |
| Dashboards              | Operational club dashboard                    |
| Payments/billing        | Member subs, team fees, event fees            |

The main strategic benefit is that **ClubPro expands SeasonPro from a league product into a broader grassroots sports administration platform**.

That could let you sell into:

* Football clubs that are not ready for full league transformation.
* Clubs within existing SeasonPro leagues.
* Multi-sport community clubs.
* Individual sports clubs, such as table tennis, running, bowls, cricket, badminton or martial arts.
* Organisations where members are individuals, not necessarily attached to teams.

---

## 6. Club As Tenant Vs Club As Child Of League

I think ClubPro needs two operating modes.

### Mode A: ClubPro inside SeasonPro

This is where a club belongs to a league tenant.

Example:

> Derby Junior Football League uses SeasonPro. A club within DJFL gets access to enhanced ClubPro tools to manage its teams, managers, contacts, players, communications and internal club data.

In this mode, the club is still partly governed by league rules. Some data may need to sync upwards to the league, and some changes may still require approval.

### Mode B: Standalone ClubPro

This is where a club exists without a parent league.

Example:

> A table tennis club has members, subscriptions, teams, fixtures, newsletters, club officers and venue details, but no parent league using SeasonPro.

In this mode, the club is the primary tenant. There is no league approval workflow unless the club creates its own internal approval process.

This is the key architectural question:

> Is ClubPro a separate product, or a module that can operate both independently and as part of SeasonPro?

My recommendation: **make ClubPro a module, but expose it as a product in its own right.**

---

## 7. Recommended Architecture

I would model it as:

```text
IsoStack Platform
│
├── SeasonPro Product
│   ├── League module
│   ├── Club module
│   ├── Team module
│   ├── Fixtures module
│   ├── Compliance module
│   └── Communications module
│
└── ClubPro Product
    ├── Club module
    ├── Member module
    ├── Team module
    ├── Subscriptions module
    ├── Communications module
    └── Compliance module
```

So **ClubPro is not a completely separate app**. It is a product configuration made from shared modules, with the **Club module promoted to the top-level organising object**.

That fits the IsoStack philosophy very well.

---

## 8. Core Data Model Implication

SeasonPro probably has this hierarchy:

```text
League
└── Club
    └── Team
        └── Players / Contacts / Managers
```

ClubPro standalone would need this hierarchy:

```text
Club
├── Members
├── Teams
│   └── Team Members / Players
├── Club Officers
├── Subscriptions
├── Communications
├── Events / Sessions
└── Compliance Records
```

The major addition is **Member** as a first-class concept.

In football, the primary operational object may be a **team**. In table tennis or other sports, the primary object may be an **individual member** who may or may not belong to a team.

So the data model should avoid assuming:

```text
Club → Team → Player
```

Instead, I would model:

```text
Club → Member
Club → Team
Team → Member
```

That allows:

* Individual members with no team.
* Team members.
* Members in multiple teams.
* Coaches/managers who are also members.
* Parents/guardians linked to junior members.
* Officers/volunteers who are not players.
* Social members.
* Life members.
* Paid/unpaid/complimentary members.

This is probably the biggest modelling implication.

---

## 9. Permissions And Delegated Management

ClubPro becomes really powerful if club secretaries can delegate data upkeep.

Example roles:

| Role                       | Likely permissions                               |
| -------------------------- | ------------------------------------------------ |
| Club Admin / Secretary     | Full club management                             |
| Treasurer                  | Subscriptions, payments, invoices, reports       |
| Membership Secretary       | Members, renewals, onboarding                    |
| Safeguarding Officer       | Safeguarding records, emergency contacts, checks |
| Team Manager               | Own team members, availability, communications   |
| Coach                      | Team attendance, notes, contact access           |
| Member                     | Own profile, subscriptions, preferences          |
| Parent / Guardian          | Linked junior member details                     |
| Read-only Committee Member | Reports and dashboard access                     |

This makes ClubPro more than a dashboard. It becomes a **distributed club administration system**.

That is valuable because many clubs have the same problem:

> Too much knowledge and admin lives with one overburdened secretary.

ClubPro’s value proposition could be:

> **Share the workload, keep member data current, and reduce admin pressure across the club.**

---

## 10. Communications Implication

Club communications are similar to league communications, but the audience structure is different.

SeasonPro communications might be:

```text
League → Club Secretaries
League → Team Managers
League → Age Groups
League → All Clubs
```

ClubPro communications might be:

```text
Club → All Members
Club → Team Managers
Club → One Team
Club → Parents/Guardians
Club → Overdue Subs Members
Club → Committee
Club → Volunteers
Club → Junior Section
Club → Senior Section
```

This suggests the communications engine should be reusable, but segment logic needs to be more flexible.

Useful ClubPro communication segments:

* All active members.
* Members by membership type.
* Members with unpaid subscriptions.
* Team members.
* Parents of junior members.
* Coaches and volunteers.
* Committee/officers.
* Members missing key data.
* Members with expiring consent/compliance items.

This is a good reason to build communications as a general IsoStack capability, not just a SeasonPro feature.

---

## 11. Billing And Subscriptions

This is where ClubPro may become commercially interesting.

Clubs often need to manage:

* Annual membership subscriptions.
* Monthly subscriptions.
* Match fees.
* Training fees.
* Family memberships.
* Junior/senior/social membership types.
* Discounts and concessions.
* Unpaid member chasing.
* Team fees.
* Event payments.
* Donations or fundraising contributions.

For football clubs, this may overlap with team/parent/player admin.

For table tennis, running clubs or similar, subscriptions may be the central operational challenge.

So ClubPro should probably have a **Subscription / Payments module**, but I would keep it simple at first:

### Phase 1 Billing

* Membership types.
* Subscription amount.
* Renewal date.
* Payment status.
* Manual payment recording.
* Export/reporting.

### Phase 2 Billing

* Stripe Checkout / GoCardless links.
* Automated reminders.
* Payment reconciliation.
* Treasurer dashboard.

### Phase 3 Billing

* Full recurring payments.
* Family groups.
* Multiple subscription plans.
* Club accounting exports.

This also aligns well with your GoCardless thinking for leagues, because clubs often have similar bank-based payment preferences.

---

## 12. Product Positioning

I would not position ClubPro initially as “another sports club management system” because that space can become broad and competitive.

I would position it as:

> **A practical club administration extension for grassroots sports organisations already struggling with member data, team admin, subscriptions and communications.**

Possible framing:

### ClubPro

**Club administration without the spreadsheet chaos.**

Or:

**Shared club management for secretaries, treasurers and team managers.**

Or:

**Keep your club records, teams, members and payments under control.**

The key is not to overclaim. The first version does not need to replace every specialist sports platform. It needs to solve the core pain:

> Members, teams, contacts, payments and communications are scattered across spreadsheets, WhatsApp, email, bank records and individual managers’ heads.

---

## 13. Commercial Model Implications

ClubPro gives you several pricing routes.

### Route 1: Add-on to SeasonPro

For leagues already using SeasonPro:

| Option               | Description                                            |
| -------------------- | ------------------------------------------------------ |
| Basic Club Dashboard | Included with SeasonPro                                |
| ClubPro Lite         | Paid add-on for clubs needing CRUD and team management |
| ClubPro Full         | Membership, subscriptions, comms, compliance, reports  |

The league could optionally receive commission if it helps adoption across its clubs.

### Route 2: Standalone ClubPro

For clubs not attached to a SeasonPro league:

| Tier             | Possible customer                                            |
| ---------------- | ------------------------------------------------------------ |
| ClubPro Starter  | Small single-sport club                                      |
| ClubPro Standard | Club with teams and subscriptions                            |
| ClubPro Plus     | Larger club with sections, managers, payments and compliance |

Pricing could be based on:

* Number of members.
* Number of teams.
* Number of admin users.
* Payment/subscription features.
* Communication volume.
* Support level.

### Route 3: ClubPro as a feeder product

This is strategically interesting.

ClubPro could become a **route into SeasonPro**.

If several clubs in a league use ClubPro, you have a stronger case to approach the parent league later:

> “Several of your clubs are already managing their data in ClubPro. SeasonPro would allow the league to connect with that data rather than collect it manually.”

That could be powerful.

---

## 14. Risks And Cautions

### 1. Scope creep

Club management can become huge very quickly:

* Fixtures.
* Venues.
* Availability.
* Coaching plans.
* Welfare.
* Payments.
* Kit.
* Events.
* Selection.
* Attendance.
* Documents.
* Accreditation.
* Volunteers.
* Website integration.

I would avoid trying to build “everything a club might need”.

Start with the shared pain:

> **People, teams, roles, subscriptions, communications and data quality.**

### 2. Sports-specific rules

Football, table tennis, cricket and running clubs all have different needs. The safest approach is a **generic club/member/team model** with optional sport-specific fields.

Avoid baking in football assumptions.

### 3. Parent/child data ownership

If a club uses ClubPro inside SeasonPro, who owns the data?

For example:

* Can the league see all club members?
* Can the club hide internal member data?
* Can a team manager update player data that affects league registration?
* Which fields need league approval?
* Which fields are club-only?

This needs clear boundaries.

A useful split:

| Data type                    | Ownership                    |
| ---------------------------- | ---------------------------- |
| Club public profile          | Club, visible to league      |
| League registration fields   | League-governed              |
| Internal club member records | Club-owned                   |
| Team manager contact data    | Club-owned, role-restricted  |
| Safeguarding/compliance      | Mixed, permission-controlled |
| Subscription/payment data    | Club-owned                   |

### 4. Support burden

ClubPro may produce more small-user support than SeasonPro. Many club volunteers will not be technical.

So onboarding, help text, templates and guided workflows matter.

This is where IsoStack’s tooltip/help inheritance could become a genuine advantage.

---

## 15. Suggested MVP

I would define ClubPro MVP very tightly.

### ClubPro MVP: “Club records and team management”

### Core objects

* Club
* Members
* Teams
* Roles
* Users
* Membership types
* Subscriptions/payment status
* Communications
* Data quality dashboard

### Core workflows

| Workflow                     | Description                               |
| ---------------------------- | ----------------------------------------- |
| Add/manage members           | Create and maintain member records        |
| Assign members to teams      | Members can belong to one or more teams   |
| Invite team managers         | Managers maintain their own team data     |
| Track missing data           | Dashboard flags incomplete records        |
| Send communications          | Email groups by team, role or member type |
| Track subscriptions manually | Record paid/unpaid/overdue status         |
| Export reports               | Simple CSV/PDF outputs                    |

### Not MVP

* Full fixture management.
* Native accounting.
* Complex recurring payments.
* Website builder.
* Training plans.
* Selection/availability.
* Full club shop.
* Advanced safeguarding workflows.

Those can come later.

---

## 16. Development Implication For IsoStack

I would treat ClubPro as a very useful test of IsoStack’s modularity.

It would require:

| Area           | Implication                                             |
| -------------- | ------------------------------------------------------- |
| Tenancy        | Club can be a tenant, not only a child of league        |
| Modules        | Club module must operate standalone or nested           |
| Permissions    | More granular role-based access                         |
| Data model     | Member must be first-class                              |
| Communications | Segmentation needs to be reusable                       |
| Payments       | Club-level billing/subscriptions needed                 |
| UI             | Club dashboard becomes operational CRUD interface       |
| Help system    | Role-based onboarding/help becomes important            |
| Product gating | ClubPro features need independent gating from SeasonPro |

The biggest technical design principle should be:

> **Do not fork SeasonPro. Extract shared modules and configure them differently.**

---

## 17. Recommended Module Structure

I would think in terms of these reusable modules:

```text
Core Platform
├── Tenant / Organisation
├── Users & Roles
├── Permissions
├── Communications
├── Billing / Payments
├── Documents
├── Help / Tooltips
└── Audit / Activity

Sports Modules
├── Club
├── Member
├── Team
├── Season
├── Fixture / Event
├── Compliance
└── Registration / Approval
```

Then:

```text
SeasonPro = League + Club + Team + Season + Registration + Approval + Communications

ClubPro = Club + Member + Team + Subscriptions + Communications + Compliance
```

This makes ClubPro a **product composition**, not a separate codebase.

---

## 18. Practical Phased Route

### Phase 1: Clarify the model

Document the difference between:

* League tenant.
* Club tenant.
* Club as child of league.
* Member.
* Team.
* Role.
* Subscription.

This is worth doing before development.

### Phase 2: Convert the existing Club Dashboard into CRUD

Take what already exists in SeasonPro and extend it into club-owned CRUD:

* Club profile.
* Teams.
* Managers.
* Contacts.
* Members/players.
* Role assignments.

### Phase 3: Add standalone club tenancy

Allow a club to exist without a parent league.

This is the point where ClubPro becomes a real product.

### Phase 4: Add membership/subscriptions

Add membership types, renewal dates, payment status and reminders.

This is likely the main reason clubs would pay.

### Phase 5: Add payment integration

Stripe Checkout and/or GoCardless.

For clubs, GoCardless may be particularly attractive for recurring subs.

### Phase 6: Broaden beyond football

Add configuration for other club types:

* Football club.
* Table tennis club.
* Running club.
* Multi-sport club.
* Generic membership club.

This should be configuration, not separate builds.

---

## 19. Naming And Product Relationship

I think the naming works:

| Name           | Role                                            |
| -------------- | ----------------------------------------------- |
| SeasonPro      | League and season administration                |
| ClubPro        | Club and membership administration              |
| TeamPro        | Possibly a future lightweight team manager view |
| FundPro / FUND | Fundraising and sales module                    |

However, I would avoid making too many public product names too early. Internally, ClubPro can be a module/product. Externally, it could be presented as:

> **ClubPro — powered by SeasonPro / IsoStack**

or

> **ClubPro — club management from the SeasonPro platform**

This gives confidence that it is not a separate experimental thing.

---

## 20. Overall Recommendation

Proceed, but with a disciplined scope.

ClubPro is a strong extension because:

* It reuses much of SeasonPro.
* It solves real club-level admin pain.
* It broadens the market beyond leagues.
* It can be sold independently.
* It can act as a feeder into SeasonPro.
* It validates IsoStack’s modular product strategy.
* It creates a natural home for communications, subscriptions and delegated data maintenance.

But the key is to build it as:

> **A configurable module/product composition, not a separate fork of SeasonPro.**

The first version should focus on:

1. **Club as tenant**
2. **Members as first-class records**
3. **Teams as optional groupings**
4. **Delegated manager access**
5. **Communications**
6. **Subscription/payment tracking**
7. **Data quality dashboard**

That would give you a coherent MVP with commercial value, without trying to become a complete sports club operating system from day one.

## 21. Control Note

This document should inform future ClubPro product discovery and roadmap control. It should
not expand the immediate LMSPro Club Player Management CR beyond its agreed boundary.

Near-term implementation remains:

```text
LMSPro / SeasonPro club-owned player management and Team Manager access inside existing
league-owned SeasonPro tenancy.
```

Future ClubPro discovery should produce its own roadmap, planning slices and product
boundary decisions before any standalone ClubPro implementation begins.
