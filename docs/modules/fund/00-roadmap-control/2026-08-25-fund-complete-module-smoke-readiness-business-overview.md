# FUND — Business Situation And Phase 1 Smoke Readiness

Created: 2026-08-25

Last updated: 2026-09-07

Status: **Plain-English situation report; subordinate to the delivery lifecycle**

This existing overview is the business-facing companion to the developer records. Keep it
current when business scope, delivery progress, a material blocker or the next owner
question changes. It summarises the same work; it does not create a second roadmap,
implementation authority or another restart checkpoint.

## Where We Are

FUND has substantial foundations for administration, Project setup, Product selection,
Store control and payment/Order handling. It cannot yet demonstrate the connected journey
from setting up a fundraiser through a purchase, artwork matching, dispatch and commission.
The Individual Artwork rendering and private-storage assumption test is **complete and
passed**; its temporary resources were removed. It is not a pending test or an operational
production service.

The owner has reconfirmed **FUND as the primary focus**, with LMSPro remedial work
concluded. The repository alignment preflight found no uncommitted code or documentation:
application dev/staging/main match locally and online at `14077382`; documentation was
consolidated and published through `20e1159`. Git alignment is not a new app deployment.

The current FUND work is **development planning for the first Individual offer and
artwork-document journey**, under `1R-F-B1`. The broader B document is now the enduring
business framework. B1 proposes the exact first result and its business choices; no code
has been built. The existing C1/C2 Store staging checks still need their recorded human
acceptance; this report does not mark those checks complete.

## Your Phase 1 Decisions

| Question | Confirmed direction |
| --- | --- |
| Which workflow comes first? | One AMOW **Individual Artwork** journey. Collective, Group/Bulk and Standard workflows follow later. They are not prerequisites for this first smoke test. |
| Where does commission testing stop? | A **calculated and finalised commission statement** is sufficient. Exercising settlement is outside Phase 1. |
| Must external services be real during development? | **Simulation/emulation is satisfactory for Phase 1 development staging before FUND deployment**, including payment, rendering, private storage, scanning and email where needed. |
| What happens after FUND deployment? | Augment staging to reflect the services actually used by live FUND, so testing closely represents the live application. |

These answers define the first connected test's scope. They do not claim that it has
passed or approve application implementation/deployment. A simulated-service pass proves
the application flow exercised, not a real provider connection. Any later deployment plan
must identify and verify the actual services it enables. Existing tenant permissions,
confirmed-offer consistency and safe failure behaviour still apply with simulated services.

“Phase 1 smoke” now means the first Individual journey below. Complete-module coverage of
other workflows and later settlement remains a broader future outcome.

## What Exists And What Remains

| Business area | Current position | Remaining work for the first connected journey |
| --- | --- | --- |
| Administration and Project setup | Client, user, Product, Event, Project, Intake and organiser foundations exist | Choose the test users and Project setup route; prove the selected route and relevant permissions |
| Project and Store control | Draft Store creation, eligible Products, C2 control and C1 oversight are implemented | Complete the existing connected C1/C2 checks and show clear selection/readiness blockers |
| Individual offer and artwork sheet | The renderer/layout/private-storage assumption test passed; Store configuration foundations exist | Connect template assignment, C2 selection and finalisation to a matching document and Store preview |
| Public buying and payment | Shared Order/payment/refund machinery exists; the public FUND buying journey is incomplete | Add released Product display, buyer choices, checkout and purchase/status evidence; simulated payment outcomes are acceptable in development |
| Order and artwork operations | Generic Order evidence and asset foundations exist | Add Order Code, C1 reconciliation, physical artwork/Order matching and limited C2 progress/sales visibility |
| Production and dispatch | Delivery and asset foundations exist | Connect explicit production approval, fulfilment and dispatch for the chosen delivery mode |
| Commission | Policy and acceptance foundations exist | Calculate from reconciled sales/refunds and finalise a statement; settlement is later |

The entitlement-display finding remains parked under its existing Platform/FUND control;
any demonstrated disclosure or authority bypass must be addressed through that control.
This report does not silently select that refinement.

## The First Connected Test

```text
C1 prepares the Client, Event/Project, Products and Individual template
-> C2 reviews eligible Products and an offer preview
-> ready-to-finalise checks pass -> authorised C2 finalises the offer
-> a matching artwork sheet is generated and available through authorised access
-> all publication checks pass -> C2 separately publishes the Store
-> purchaser chooses from the released offer and completes a simulated/test purchase
-> verified real or simulated payment events update durable Order/payment evidence
-> C1 matches artwork, authorises production and records fulfilment/dispatch
-> C2 sees the permitted progress and sales information
-> commission is calculated and its statement finalised
```

The test must also cover wrong-Client access, unready Products, failed document generation,
changed offer details, failed/duplicate payment and unmatched artwork. Payment alone must
never approve production. Test-service outcomes must be labelled simulated or real in the
lifecycle evidence.

This full Phase 1 journey is larger than the selected **B1 development-planning** outcome.
The [B1 draft](../03-slice-planning/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-journey-development-plan.md)
stops at a matching development artwork download and Store preview using emulated services.
Its four decisions are ready for your review: fixed initial template choices, assignment/
organiser finalisation, no ordinary unlock, and a development-preview result. These limits
are proposed, not assumed accepted. The later delivery/Intake/message choices below need
not delay drafting this smaller plan.

## Remaining Scope Choices — Broken Into Options

Your second answer asks for more concrete choices. None of the following is selected yet;
the suggested starting point is a proposal for the first test, not a restriction on FUND's
later capabilities. Choose the option that matches how the actual AMOW pilot will run.

| Choice | Suggested starting point | Alternative / effect |
| --- | --- | --- |
| Delivery | One consolidated delivery to the organiser's Project delivery address | Individual purchaser delivery, or both; this adds purchaser addresses and separate dispatch cases |
| Products and buyer choices | Name a small representative AMOW Product set and include only the size/colour/personalisation choices those Products actually need | Include a broader Product set and more choices now, with a larger test matrix; essential real choices must not be omitted merely to simplify testing |
| Product images | One representative approved image per selected Product | Multiple images/gallery or Product-specific previews where buyers need them to choose correctly |
| Project setup | C1 creates the first test Project with an existing organiser | C2 creates it, or use hosted public Intake; embedded Intake adds a separate embedding path to prove |
| Organiser and purchaser messages | Include the messages needed by the chosen flow: organiser access/setup if needed, document-ready notification and purchaser receipt/payment status; capture delivery in the development simulator | Also include reminders, sales updates or dispatch notifications where the pilot needs them; a general campaign editor is a later capability |

A useful response names the delivery option, actual Products and required buyer choices,
image requirement, setup route and essential messages. If a choice is deferred, the later
plan must say which action cannot yet be tested.

The separate [offer and finalisation proposals](2026-09-07-fund-user-framework-and-individual-artwork-delivery-principles.md#8-proposed-business-decisions-for-control-owner-acceptance)
(template assignment, who may finalise, revision rules and the minimum next outcome) still
await acceptance. Your four smoke-scope answers do not answer those different questions.

## How This Report Stays In Step

Use this page for the current business situation, confirmed scope and remaining choices.
The [enduring framework](2026-09-07-fund-user-framework-and-individual-artwork-delivery-principles.md)
records the detailed workflow and decision consequences. The [active B1 plan](../03-slice-planning/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-journey-development-plan.md)
sets out the proposed first development result and its review decisions. The [FUND roadmap](2026-06-25-fund-roadmap-and-slice-control.md)
and [root portfolio control](../../../00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md)
continue to own selection and status; implementation/review records own proof. Update this
page alongside those existing records when their business meaning changes, using plain
language and preserving the distinction between built, tested and still planned.

The [strategic completion overview](2026-07-15-fund-store-artwork-orders-and-production-strategic-completion-roadmap.md)
retains the wider module destination. The [refinement register](2026-07-20-fund-refinement-wishlist-and-slice-control.md)
and [existing C1/C2 Store smoke schedule](../05-review-and-test/2026-07-23-fund-phase-1-slice-1r-e-b-through-1r-e-d-consolidated-staging-human-smoke-test-schedule.md)
retain their own boundaries. No new status document or lifecycle stage is introduced.

## Owner Answers Retained — 2026-09-07

1. Is the first “complete” smoke one AMOW Individual journey, or must it represent
   Individual, collective Group/Bulk and Standard Products? One journey - individual only.  Other workflows will be addressed later
2. Which fulfilment modes, Products/options/media, Intake route and organiser messages are
   in scope? This question is too vague to answer - can you break this into options?
3. Is a calculated/finalised commission statement sufficient, or must settlement also be
   exercised? - just calculated and finalised statement is sufficient for phase 1
4. Which staging services must be real rather than simulated: Stripe, renderer, private
   storage, malware scanner and email? for phase 1 and prior to deployment of fund, simulation is satisfactory.  Once Fund has been deployed then staging needs to be augmented to reflect the services in use on the live app to make testing as close as possible to main. but for development staging, emulation is perfect.
