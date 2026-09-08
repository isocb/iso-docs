# FUND — Business Situation And Phase 1 Smoke Readiness

Created: 2026-08-25

Last updated: 2026-09-08

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

The current FUND work is **B1 implementation and validation**. You accepted all four
business decisions and then asked for technical review and implementation. The first
connected development flow has now been built: C1 assigns a fixed template; the organiser
reviews and finalises the offer; authorised users can generate and download a matching
development document and see the same confirmed Store preview.

Automated recovery, migration, type, lint, build and repository checks have passed. B1 is committed and published at `57e1454b` on `work/fund-b1-individual-offer` after your approval and a credential review. The authenticated C1/C2 human
walkthrough remains pending, and this code has not been promoted to staging or live. Public
Store, payment, Order and operational slices remain in Phase 1 after B1; the template editor
is Phase 2. The earlier Store human acceptance schedule is not silently marked complete.

The local test application is now running at `http://localhost:3000` on corrected candidate
`cd72dd78`, using the Neon DevData database you identified. The Catalogue/workflow database
change is applied. Its safety checks confirmed that only the small disposable FUND setup was
removed and that every application table outside FUND retained the same row count. Recreate the FUND
Event, Client, Project, Intake, Product and Catalogue test bed through the ordinary C1/public
processes. Product creation should no longer ask for a workflow: the Event or standalone
Project owns that choice. Finalisation must still be tested through the organiser's own Client
dashboard login. The [B1-R1 review/test record](../05-review-and-test/2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-review-and-test.md)
contains the current smoke schedule. Your human result remains pending.

While you test B1, the proposed next plan is
[1R-G Public Store Presentation](../03-slice-planning/2026-09-07-fund-phase-1-slice-1r-g-public-store-presentation-planning.md):
what a purchaser sees when opening a Project Store link. It covers the released Product
presentation and unavailable-Store states; buying/payment remains a later Phase 1 step.
The current B1 emulator cannot make a real Individual Store trade. The plan therefore
records the release dependency and the choice of development demonstration explicitly.
The reserved slice has not yet been confirmed as Next; no implementation is being started.

Your test-bed work identified an important simplification, now captured in the
[Catalogue/workflow CR-Fix](../01-cr-inputs/CR-Fix-2026-09-08-fund-workflow-authority-and-product-suitability-separation.md). A Product is maintained once; the producer
places it in Catalogues and controls where those Catalogues are available. The Event or
standalone Project determines the workflow, and C2 selects the offered subset. The separate
Product Suitability gate and mandatory Product Workflow Class have been removed from the
intended model. Manufacturing changes should be handled through Catalogue choices without
another Product edit. The implementation protects existing selections and finalised
evidence while removing those duplicate gates. Automated checks and the local database
upgrade pass; B1 acceptance remains pending. Your confirmation
that FUND has no users/data requiring remedial conversion is recorded, alongside the need
for a staging schema migration and permission to recreate development test data when needed.

The Catalogue/workflow correction has now been [triaged](../02-triage/2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-triage.md) and
[planned in detail](../03-slice-planning/2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-planning.md) as B1-R1. It must be corrected and tested
before B1 business acceptance. There will be four workflows, one per Event or standalone
Project; Standard means selling an unmodified Product. C1 makes Catalogues available to
standalone Projects without another per-Project assignment gate. The plan removes the old
default-only restriction so those available ranges are not silently suppressed. It also makes
the four workflows fixed Event/Project definitions in the application, removing the database
Workflow Class records that could independently block Product setup.

The implemented change behaviour is: select the initial range once; later additions are available
for C2 to choose; losing the last Catalogue source shows an unavailable selected Product;
finalised offer/Order evidence never changes. Event workflow changes after Projects exist
are refused. The local FUND test bed was recreated empty under the recorded development-data
authority so the migration could apply without guessing workflows for old Event rows. The
application and database are ready for the human walkthrough; staging and live are unchanged.

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
| Individual offer and artwork sheet | The renderer/layout/private-storage assumption test passed; Store configuration foundations exist | B1 now connects assignment, finalisation, matching development PDF and Store preview; complete the human walkthrough |
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
You have accepted all four B1 decisions: fixed initial templates, the assignment hierarchy
and organiser finalisation, no ordinary unlock, and an emulated development result.
The template editor is Phase 2 development.

Your D4 clarification confirms that **Public Store, payment, Order and operational slices
remain required in Phase 1, after B1**. B1 is the first delivery step, not the whole Phase 1
result. Development simulation proves application behaviour; it does not establish actual
provider operation or print suitability. There is no remaining D1–D4 business question.
The later delivery/Intake/message choices below remain for their relevant Phase 1 slices.

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
are now resolved for B1 by its accepted D1–D4 decisions. Broader revision/refinalisation
workflows and later operating choices remain outside that acceptance.

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
