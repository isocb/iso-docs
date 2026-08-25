# CR-Feature Planning Intake — SeasonPro Club Subscription, Payments And Accounting Integration

Date: 2026-08-25

Owning product lane: LMSPro / SeasonPro

Linked capability lanes: IsoStack Platform and Commerce Core

Planning status: **REGISTERED PLANNING INPUT; BUSINESS QUESTIONS REMAIN OPEN; AWAITING
FORMAL TRIAGE WHEN SEASONPRO WORK RESUMES; NOT SELECTED AND DOES NOT DISPLACE FUND
`1R-F-A` STAGE C**

Source request: the control owner asked to preserve Club subscription management, ad-hoc
payment invoicing, Stripe and GoCardless payment-gateway integration and Xero integration
as a likely high-priority SeasonPro feature for later consideration. The control owner's
working principle is that each tenant should configure and own its payment-provider and
accounting connections, while modules consume shared Core capability and apply their own
commerce rules.

## 1. Authority And Planning Boundary

This document is a planning-only, non-authorising CR input prepared under the Parallel
Planning Persona. It preserves the researched proposal and its unresolved business
questions so that the work is not lost while FUND remains the active portfolio outcome.

It does not:

- register or select an executable slice;
- complete formal triage or accept the feature for delivery;
- alter the root portfolio `Now` or `Next`;
- change any authoritative roadmap beyond its companion non-selecting registration in the
  SeasonPro CR inventory;
- authorise application, schema, migration, provider, credential or environment changes;
- create a development branch or reserve an executable slice identifier;
- claim implementation, testing, deployment or live operation; or
- make FUND dependent on untriaged SeasonPro billing work.

The controlling documents remain:

- [root portfolio control](../../../00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md);
- [LMSPro / SeasonPro child roadmap](../00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md);
- [Platform child roadmap](../../../platform/00-roadmap-control/2026-07-22-isostack-platform-roadmap-and-slice-control.md);
- [Commerce Core roadmap](../../../core/commerce/00-roadmap-control/2026-07-13-commerce-core-roadmap-and-slice-control.md); and
- [authoritative human/AI working method](../../%3Cmodule%3E/work-method.md).

The separate authoritative control window registered this input with the explicit
disposition `captured; awaiting formal triage` in the SeasonPro child roadmap on
2026-08-25. That companion registration preserves traceability only; it does not select
the work, accept implementation or displace FUND. This PPP input itself remains
non-authorising and does not acquire roadmap authority from registration.

## 2. Purpose And Strategic Decision

Preserve a linked feature proposal for a reusable tenant commerce capability supporting:

- Club subscription management;
- routine, event-based and ad-hoc invoicing;
- Stripe payment collection;
- GoCardless payment collection and Direct Debit mandates;
- manual or offline payment recording;
- Xero accounting integration; and
- module-specific commerce rules in SeasonPro and, where appropriate later, FUND.

The settled strategic direction for later triage is:

```text
Tenant configures and owns its provider/accounting connections
-> Platform supplies the secure tenant configuration and authority surface
-> Commerce Core owns generic billing, payment and reconciliation capability
-> SeasonPro applies Club subscription, fee, fine and eligibility rules
-> FUND may consume the same generic capability for its own bounded commerce workflows
```

This is a linked Platform–Commerce Core–SeasonPro capability. It must not be implemented as
an isolated payment subsystem inside SeasonPro or as a side effect of FUND work.

## 3. Controlling Terminology And Commercial Relationships

The source request calls this the **Feature Payment Module**. That remains the business
feature label for this CR. Architecturally, the likely reusable capability is **Commerce
Core Billing And Receivables**, consumed by modules rather than exposed as an independent
destination module without later triage evidence.

Three commercial relationships must remain separate:

1. **IsoStack subscription billing** — the tenant pays IsoStack for its platform products
   and modules. This is an existing Platform Stripe subscription flow.
2. **Tenant commerce payments** — a Club, purchaser or other customer pays the tenant.
   Commerce Core already provides the first tenant-owned Stripe Connect foundation for
   this relationship.
3. **SeasonPro Club billing** — Clubs pay the League/tenant for annual fees, additional
   Teams, late entries, fines and other charges. SeasonPro owns why the money is owed while
   Commerce Core should own the generic invoice and payment evidence.

In this document, **Club subscription** means the third relationship unless the control
owner later decides otherwise. It must not reuse or conflate the existing
`OrganizationProduct` records used for the first relationship.

Xero is an accounting integration, not a payment gateway. Stripe and GoCardless are payment
providers. Their connection, event and reconciliation contracts must therefore remain
distinct even when presented together in tenant settings.

## 4. Existing Accepted Foundation

### 4.1 Commerce Core

The accepted Commerce Core architecture already establishes:

- a dedicated `commerce` namespace;
- the tenant `Organization` as the seller identity;
- opaque module source references with typed module extensions;
- separate checkout, Order, Payment, Refund and pro-forma states;
- provider-neutral Core services and validation;
- tenant-owned Stripe connected accounts;
- Stripe-hosted tenant onboarding;
- Stripe connected-account Checkout;
- webhook, refund and reconciliation handling; and
- a typed but currently dormant FUND consumer transaction boundary.

The accepted Stripe plan fixes the C1 tenant as merchant of record for tenant commerce,
uses direct charges on the tenant's connected account and requires no tenant-supplied
Stripe secret. It also explicitly isolates Commerce seller payments from IsoStack's own
Stripe subscription billing.

Relevant records:

- [Commerce Core roadmap](../../../core/commerce/00-roadmap-control/2026-07-13-commerce-core-roadmap-and-slice-control.md);
- [Stripe Connect tenant-payments parent plan](../../../core/commerce/03-slice-planning/2026-07-14-isostack-commerce-core-slice-commerce-a6-stripe-connect-tenant-payments-planning.md); and
- [existing cross-module Commerce boundary note](../../fund/05-fund-open-questions.md#35-isostack-commerce-core-boundary).

The implemented foundation includes Commerce Orders, Order lines, Payments, Refunds,
Pro-forma Invoices, audit/idempotency records and Stripe-specific connection/event
evidence. It does not currently establish a general accounts-receivable invoice,
subscription, mandate, allocation, GoCardless or Xero domain.

### 4.2 SeasonPro

SeasonPro currently retains Club billing-contact information and presents financial
management as future functionality. Earlier functional requirements also identify:

- annual fees;
- event-based charges such as new Teams and late entries;
- ad-hoc charges such as fines;
- manual invoice creation, categorisation and status tracking;
- Treasurer and Secretary dashboards; and
- Xero API integration.

These are requirements/provenance, not evidence that the feature exists. No current
SeasonPro invoice, subscription, mandate, GoCardless or Xero implementation was identified
during this intake review.

Relevant requirement provenance:

- [SeasonPro functional specification](../planning/dcfl_functional_specification_v1.2.md#48-billing-and-finance).

### 4.3 FUND

FUND already depends on the generic Commerce Order and payment foundation and has a typed
FUND consumer boundary. FUND retains ownership of Projects, Events, Products/Catalogues,
Stores, production and fulfilment rules. It must not become the owner of generic billing,
subscriptions, provider connections or SeasonPro Club rules.

The existing FUND analysis already records the working principle:

```text
Commerce should be core IsoStack infrastructure;
Stores, subscriptions, fines and fundraising are module-specific uses of that infrastructure.
```

This future feature may reuse work proven through FUND and may later provide additional
Core facilities that FUND can adopt. It does not reopen completed FUND/Commerce foundations
or authorise a retroactive FUND rewrite.

## 5. External Provider Research

The following official provider material supports the proposed separation. It is research
evidence only; pinned SDK/API versions, commercial terms, regional eligibility and exact
provider contracts require fresh confirmation during formal triage and planning.

### 5.1 Stripe

Stripe Connect direct charges place the payment on the connected account. Stripe describes
the connected account as merchant of record for direct charges, with refunds and
chargebacks reducing that account's balance. This is consistent with the existing IsoStack
tenant-as-seller design:

- [Stripe Connect charge types](https://docs.stripe.com/connect/charges?locale=en-GB);
- [Stripe merchant-of-record guidance](https://docs.stripe.com/connect/merchant-of-record?locale=en-GB); and
- [Stripe direct charges](https://docs.stripe.com/connect/direct-charges).

Stripe also supports one-off invoices, subscription-generated invoices, connected-account
invoicing and UK Bacs Direct Debit. Provider capability does not itself decide whether
IsoStack should use Stripe or GoCardless for Club Direct Debit:

- [Stripe invoicing lifecycle](https://docs.stripe.com/invoicing/overview);
- [Stripe invoicing with Connect](https://docs.stripe.com/invoicing/connect);
- [Stripe Connect subscriptions](https://docs.stripe.com/connect/subscriptions); and
- [Stripe UK Bacs Direct Debit](https://docs.stripe.com/payments/payment-methods/bacs-debit?locale=en-GB).

### 5.2 GoCardless

GoCardless provides a partner OAuth flow through which a merchant securely grants a
platform access to act on its account without supplying its password. Its Billing Requests
support one-off payments, recurring bank payments, mandate creation and a first payment
combined with mandate setup:

- [GoCardless partner account connection](https://developer.gocardless.com/partners/connecting-your-users);
- [GoCardless Billing Requests overview](https://developer.gocardless.com/billing-requests/overview);
- [GoCardless payment types](https://developer.gocardless.com/getting-started/create-a-payment/); and
- [GoCardless API reference](https://developer.gocardless.com/api-reference).

Direct Debit is asynchronous. Mandate and payment state changes must be treated as
provider events, not as an immediate success response. The Core design will therefore need
durable webhook receipt, idempotency, retry and reconciliation equivalent in assurance to
the existing Stripe foundation.

### 5.3 Xero

Xero uses OAuth 2.0 to connect an application to one or more Xero organisations. Its
Accounting API exposes Contacts, Invoices, Credit Notes and Payments, and its webhooks can
report Contact, Invoice and Credit Note changes:

- [Xero OAuth 2.0 overview](https://developer.xero.com/documentation/guides/oauth2/overview);
- [Xero Accounting API](https://developer.xero.com/documentation/api/accounting/overview);
- [Xero Contacts](https://developer.xero.com/documentation/api/accounting/contacts);
- [Xero Payments](https://developer.xero.com/documentation/api/accounting/payments);
- [Xero Credit Notes](https://developer.xero.com/documentation/api/accounting/creditnotes); and
- [Xero webhooks](https://developer.xero.com/documentation/guides/webhooks/overview/).

Xero recommends retaining its immutable `ContactID` rather than repeatedly matching a
Contact by name. A future design should therefore retain explicit tenant-scoped mappings
between SeasonPro Clubs/Core billing accounts and Xero Contacts.

## 6. Recommended Ownership Boundary

| Capability | Recommended owner |
| --- | --- |
| Tenant integration settings, permissions, connection health and administration surface | Platform |
| Generic billing accounts, invoices, credits, payments, allocations, subscriptions, mandates and reconciliation | Commerce Core |
| Stripe, GoCardless and Xero adapters, safe provider references, events and synchronisation | Commerce Core |
| Club subscription terms, seasonal fee calculations, fines, additional-Team charges and who owes what | SeasonPro |
| Projects, Stores, fundraising Orders and other FUND commerce rules | FUND |
| IsoStack's own SaaS subscription charges to tenants | Existing Platform billing, kept separate |

Tenant ownership means that the tenant deliberately connects its own merchant/accounting
account and remains the business owner of that relationship. IsoStack may still own the
registered partner application, secure OAuth-token storage, shared webhook endpoints and
provider adapter. Tenants should not paste provider secret keys into module settings.

The exact persistence owner for generic connection records is a later Commerce/Platform
planning decision. A Platform settings route does not by itself transfer the underlying
payment domain from Commerce Core to Platform.

## 7. Candidate Included Scope

### 7.1 Commerce Core Billing And Receivables

- tenant-scoped billing accounts representing Clubs or other organisations;
- invoice and invoice-line lifecycle, due dates, tax evidence and immutable issue evidence;
- credit notes, adjustments, write-offs and cancellation/void rules;
- part-payment, overpayment where accepted and payment allocation;
- recurring or seasonal billing schedules;
- payment-method and Direct Debit mandate references without storing card or bank details;
- Stripe, GoCardless, manual/offline and invoice-only routes;
- provider connection, readiness and safe disconnection lifecycle;
- durable event inboxes, idempotency, failure/retry and reconciliation;
- Xero Contact, Invoice, Credit Note and Payment synchronisation;
- generic reminder-event and finance audit evidence; and
- module source references and typed consumer contexts.

### 7.2 SeasonPro Consumer Capability

- a Club subscription arrangement for a specific Season;
- annual affiliation or membership fees;
- base and variable charges where later business decisions require them;
- additional-Team, new-entry and late-entry charges;
- fines and other ad-hoc Club charges;
- Club Treasurer/billing-contact visibility and permitted action;
- League Treasurer and Secretary control surfaces;
- reminders and overdue visibility; and
- any explicitly accepted relationship between debt status and SeasonPro operations.

### 7.3 Potential Later FUND Adoption

- use of the same tenant provider connections where the FUND selling tenant is the merchant;
- optional invoice or offline-payment routes for qualifying FUND Orders;
- optional Xero posting/reconciliation for FUND commerce; and
- reuse of generic payment/finance audit and provider health evidence.

FUND adoption requires its own later triage and bounded consumer plan. It is not an
automatic part of the SeasonPro feature.

## 8. Explicitly Excluded Until Later Decision

- changing the portfolio `Now`/`Next` pair;
- implementing or configuring a real Stripe, GoCardless or Xero account;
- combining Platform SaaS subscriptions with tenant Club billing;
- storing raw card details, bank details, provider passwords or tenant-entered secret keys;
- making SeasonPro or FUND the owner of generic provider infrastructure;
- a general-purpose double-entry accounting ledger or replacement for Xero;
- unrestricted two-way editing between IsoStack and Xero;
- automated debt enforcement, Club suspension or competition exclusion without an
  explicit business and authority decision;
- automatic transfer, split-payment or commission changes to the accepted FUND/Stripe
  model;
- retrospective replacement of current Commerce Orders or provider evidence;
- multi-seller marketplace settlement unless separately justified; and
- implementation work before formal High-control triage and bounded planning.

## 9. Candidate Workstreams For Later Triage

These are planning candidates only. They are not executable slice identifiers and do not
authorise delivery.

1. **Business and financial-policy definition** — creditor, debtor, fees, tax, invoice
   authority, season lifecycle, overdue policy and roles.
2. **Core billing-domain foundation** — billing accounts, invoices, credits, allocations,
   schedules and typed module references.
3. **Tenant integration configuration contract** — Platform settings, authority, secure
   connection lifecycle, environment separation and provider health.
4. **GoCardless provider adapter** — partner connection, mandate/payment flow, events,
   retries, disconnection and reconciliation.
5. **Stripe billing extension** — decide whether current Checkout/direct-charge facilities
   are extended for invoices, subscriptions and/or Bacs without weakening A6 isolation.
6. **Xero accounting adapter** — Contact mapping, invoice/credit/payment sync, error
   handling, reconciliation and source-of-truth rules.
7. **SeasonPro Club subscription consumer** — seasonal arrangements, fee calculation,
   billing contacts, Club/League surfaces and reporting.
8. **SeasonPro ad-hoc charging consumer** — fines, new Teams, late entries and controlled
   manual charges.
9. **Optional FUND consumer appraisal** — identify valuable reuse without changing FUND's
   current work or accepted merchant/payment boundary.
10. **Staging and operational assurance** — provider sandboxes, tenant/role isolation,
    webhook replay, failure recovery, accounting reconciliation and non-destructive human
    proof.

The likely sequencing is policy first, then generic Core and tenant-connection foundations,
then one bounded module consumer. Formal triage must decide whether SeasonPro or an already
bounded Commerce/FUND use case should be the first end-to-end proof.

## 10. Dependencies And Roadmap Implications

### 10.1 Platform

The Platform roadmap may need a linked candidate for:

- tenant integration settings;
- connection authority and roles;
- OAuth return/state handling contracts;
- secure token/credential custody;
- test/live environment separation;
- provider health, disconnect and recovery UX; and
- shared integration audit/support behaviour.

### 10.2 Commerce Core

The Commerce Core roadmap is the likely primary owner of the new generic billing,
subscription, mandate and accounting contracts. Existing A1–A7 evidence should be reused
and protected. Formal triage must decide whether this is an extension of the current Core
roadmap or a separately named Core parent candidate subordinate to it.

### 10.3 SeasonPro

The SeasonPro roadmap now registers the Club subscription, routine fee and ad-hoc charge
consumer requirements as a captured candidate. It should later record formal triage. The
SeasonPro feature must consume Core contracts and retain ownership of League/Club/Season
rules.

### 10.4 FUND

FUND `1R-F-A` Stage C remains the root portfolio `Now` at its preserved safe checkpoint.
This CR does not change that position. Later control-window reconciliation may cross-link
FUND as a consumer or dependency, but must not make the current Stage C work wait for an
unselected payment feature.

### 10.5 Control Depth

Any later accepted lifecycle is expected to require **High** control depth because it
involves payments, financial records, tenancy, external provider contracts, OAuth tokens,
webhooks, schema/live data and runtime configuration. Formal triage must confirm the depth
and define failure, rollback, negative-test, tenant/role, migration, environment and human
evidence boundaries.

## 11. Acceptance Principles

Subject to the unresolved questions below, later planning should preserve these principles:

1. A tenant never sees or supplies an IsoStack platform provider secret.
2. Provider connections and all commercial records are tenant-isolated.
3. Modules state why money is owed; Commerce Core records how it is invoiced, paid,
   credited and reconciled.
4. Provider callbacks are treated as untrusted, asynchronous inputs and processed
   idempotently.
5. Provider references never replace IsoStack's tenant and business-ownership checks.
6. Stripe, GoCardless, manual payment and invoice-only routes do not force module-specific
   data into one provider's shape.
7. Xero synchronisation has one explicit source-of-truth and conflict policy.
8. Issued invoices and completed financial events retain immutable evidence and audit
   history.
9. Failed or disconnected providers fail safely without losing the underlying obligation
   or corrupting payment status.
10. No automated Club restriction follows from debt unless the business rule, authority,
    override and recovery path are explicitly accepted and proven.
11. Existing Commerce Stripe Connect and Platform Stripe subscription billing remain
    isolated and regression-protected.
12. FUND may reuse Core capability but does not acquire or surrender module ownership by
    implication.

## 12. Settled Planning Decisions

The following points are settled for the purpose of preserving this intake unless the
control owner later reopens them:

1. Club subscription management, ad-hoc invoicing, Stripe, GoCardless and Xero integration
   should be preserved as one strategically linked feature area.
2. The capability is likely to be a priority when the control owner returns to SeasonPro,
   but it is not presently selected.
3. FUND work remains the immediate focus and must not be displaced by this capture.
4. Tenants should configure and own their merchant/payment and accounting connections.
5. Modules should harness shared Core facilities and retain their own commerce/business
   rules.
6. The likely architecture spans Platform settings, Commerce Core infrastructure and
   bounded module consumers rather than a SeasonPro-only integration.
7. Xero must be treated as accounting integration, separately from Stripe and GoCardless
   payment processing.
8. Existing Platform subscription billing, tenant Commerce payments and SeasonPro Club
   billing must remain distinct.
9. Business questions remain deliberately unresolved for later discussion and formal
   triage.

## 13. Open Business And Planning Questions

### 13.1 Meaning Of Club Subscription

Does **Club subscription** mean a Club paying its League/tenant for participation in each
Season, rather than the tenant paying IsoStack for SeasonPro?

Planning assumption pending confirmation: **yes**.

### 13.2 Legal Creditor And Merchant Of Record

Is the League operating the tenant always the legal organisation issuing the invoice and
receiving payment from the Club?

Planning recommendation pending confirmation: **yes**, consistent with the existing
tenant-as-merchant Stripe Connect design.

### 13.3 Subscription Calculation

Is the charge:

- one fixed annual amount per Club;
- based on the number of registered Teams;
- based on Age Groups or players;
- based on different Team types or competition entries; or
- a base Club fee plus variable charges?

Which facts are fixed at invoice issue, and which later changes should produce a new
charge, credit or adjustment?

### 13.4 Seasonal Or Automatically Recurring

Should a Club subscription be created and approved afresh for every Season, automatically
renew, or support both models by tenant configuration?

Planning recommendation pending confirmation: begin with Season-specific billing because
League fees, Team counts and participation can change between Seasons.

### 13.5 Payment Schedule

Must each Club pay in full, or may the League offer instalments with configurable dates and
amounts? Can a Club choose its schedule, or does C1 assign it? What happens if a Team or
charge is added after the schedule begins?

### 13.6 Ad-hoc Charge Scope And Approval

Should the first release cover:

- fines;
- new Teams;
- late entries;
- event or competition charges;
- referee or venue costs;
- replacement documents or other services;
- credits and goodwill adjustments; and
- a manually described charge?

Which charges require approval before an invoice is issued, and may the creator also be
the approver?

### 13.7 Payment-Method Policy

May each tenant enable both Stripe and GoCardless and choose the permitted methods by
charge type? May the Club choose between enabled methods?

Planning recommendation pending confirmation: permit both providers, with tenant policy
able to favour GoCardless for annual fees/instalments and Stripe for immediate or
exceptional payments, while retaining controlled manual/offline settlement.

Stripe also supports UK Bacs Direct Debit. Is GoCardless required because it is the desired
specialist provider, or should a later commercial/operational comparison select one Direct
Debit route?

### 13.8 Direct Debit Mandate Authority

Which Club role may establish or cancel a Direct Debit mandate: Treasurer, Secretary or
another authorised payer? Does one Club mandate cover every Team and approved charge, or
must the mandate be restricted by subscription, amount or payment schedule?

What evidence of authority and payer consent must SeasonPro display and retain?

### 13.9 Manual And Offline Payments

Must C1 be able to record bank transfer, cheque, cash or another offline payment? Who may
record it, what evidence/reference is mandatory, and does another user need to approve it?

How are part-payments, overpayments, misallocated payments and reversals handled?

### 13.10 Xero Source Of Truth

Should IsoStack create and control invoices and then synchronise them to Xero, or should
Xero create the final accounting invoice and invoice number from an IsoStack billing
instruction?

Planning recommendation pending confirmation: SeasonPro owns the reason/calculation,
Commerce Core owns the billing workflow and Xero is the downstream accounting ledger.
Avoid unrestricted two-way invoice editing in the first release. Formal planning must
still decide where the legal invoice number and final issued document originate.

### 13.11 Club-To-Xero Contact Mapping

Should every SeasonPro Club map to exactly one Xero Contact? Can more than one SeasonPro
Club share a legal billing entity? Who resolves duplicates, archived Contacts or Contact
merges?

Which SeasonPro fields may update Xero, which Xero fields may update SeasonPro, and what
happens when both have changed?

### 13.12 Tax And Accounting Configuration

Are Club subscriptions, fines and other charges subject to VAT? Can treatments vary by
charge type or Club? Who configures Xero revenue-account codes, tax codes, branding themes
and tracking categories?

Must invoice numbering be tenant-configurable, Xero-controlled or Core-controlled?

### 13.13 Consequences Of Non-payment

Should overdue balances initially create warnings and reports only, or may they eventually
block Team entry, Season participation or Club administration?

Planning recommendation pending confirmation: first delivery should provide visibility,
reminders and controlled human intervention, not automatic suspension.

If restrictions are later required, which role imposes/overrides them, what grace period
applies and how is access restored after payment or an agreed arrangement?

### 13.14 Finance Authority

Which roles may:

- create or edit a draft charge;
- approve and issue an invoice;
- send or resend it;
- record an offline payment;
- create a credit note;
- write off debt;
- retry or reallocate a payment;
- connect/disconnect Stripe, GoCardless or Xero; and
- view provider errors and financial exports?

Should Treasurer and Secretary rights be fixed SeasonPro roles or configurable tenant
permissions?

### 13.15 Reminder And Communication Policy

Which reminders are automatic, which are manual, and which recipients receive them? Should
Club Secretary and Treasurer both receive invoices and overdue notices? What templates,
delivery evidence and escalation sequence are required?

Should reminders use SeasonPro communication infrastructure while retaining generic
Commerce invoice-event evidence?

### 13.16 FUND Overlap

Should FUND Orders eventually post to the tenant's Xero account, or is Xero initially
required only for SeasonPro Club billing? Are pro-forma/offline invoice routes required for
FUND customers?

Would any FUND transaction involve a different merchant of record, commission settlement
or multi-party payment that cannot use the current one-tenant direct-charge boundary?

### 13.17 Initial End-to-End Proof

After Core foundations exist, what should be the first bounded end-to-end consumer:

- annual SeasonPro Club subscription;
- one SeasonPro ad-hoc invoice;
- a GoCardless mandate and scheduled Club payment;
- Xero invoice/contact synchronisation; or
- an existing FUND Store Order using an additional payment route?

Formal triage should select one narrow proof rather than implementing every provider and
business workflow together.

## 14. Later Control-Window Handoff

When the control owner returns to SeasonPro, the authoritative control window should:

1. confirm the root `Now`/`Next` pair and avoid relying on this old intake as current
   authority;
2. confirm this CR's registered disposition against current authority;
3. decide whether linked Platform and Commerce Core CR inputs or one coordinated parent
   triage are required;
4. answer or deliberately defer the material business questions in Section 13;
5. perform formal cross-lane High-control triage;
6. preserve the three distinct commercial relationships in Section 3;
7. assess current provider terms, API versions and the then-current implementation before
   accepting a provider contract; and
8. create bounded, serial implementation plans only after ownership and sequencing are
   accepted.

Until that reconciliation occurs, this document is durable planning evidence only.
