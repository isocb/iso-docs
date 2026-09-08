# FUND B1-R1 — Catalogue Availability And Workflow Authority Triage

Date: 2026-09-08

Disposition: **Accept CR for bounded remedial planning within B1; implementation not authorised.**
Control depth: **High** — schema, tenant scoping, workflow authority and immutable commercial evidence.

Source: [refined CR-Fix](../01-cr-inputs/CR-Fix-2026-09-08-fund-workflow-authority-and-product-suitability-separation.md).
Chris explicitly requested triage and detailed planning after confirming the Catalogue-led
model. [Root control](../../../00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md)
retains B1 Now; [FUND control](../00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md)
registers this treatment. The [B1-R1 plan](../03-slice-planning/2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-planning.md)
is a remediation child of B1, not a second portfolio outcome or a renamed 1R-G.

## Triage Decision And Acceptance Consequence

The issue is a confirmed business-model defect, not merely an empty selector. Restoring the
four missing Workflow Class reference rows solved the earlier local-data blocker but left
Product-owned workflow authority and independent suitability filters intact.

**Resolve B1-R1 and obtain its review/human evidence before closing B1 business acceptance.**
B1's existing automated results remain evidence for the original implementation. They do
not prove the corrected model. No partial acceptance exception is assumed. B1 remains open;
1R-G public presentation remains a downstream planning candidate pending this correction
and its other release dependencies. No emergency expedite or new live incident is declared:
Chris confirms FUND has no users until he explicitly reports otherwise.

## Evidence And Scope

Read-only application inspection at `57e1454b` establishes:

- Products and Project Products carry Workflow Class references; Product creation requires one.
- Eligibility starts from Event/default-standalone Catalogues and deduplicates Products, then
  applies Project-type and organisation-type Product Suitability vetoes.
- Events have optional free-text `eventType`, but no typed workflow authority. Project types
  have Individual, Group, Bulk and NOT_SURE; there is no explicit Standard type.
- Default selection reconciliation can add newly eligible Products during subsequent Store
  preparation, so the C2-subset contract requires correction as well.
- B1, Store configuration/readiness and Order context consume Product workflow information.
- B1 database guards protect confirmed selection and content; Catalogue changes must be
  evaluated without rewriting those locked records.

The bounded outcome is one reusable Product across curated Catalogues and differently
scoped Projects, with correct workflow-dependent evidence and clear availability changes.
Retire both Product suitability dimensions as compatibility vetoes; retain Client type
information for actual Client/Intake purposes and retain tenant/role authorisation.

FUND owns the correction. Commerce generic Orders/payments are not redesigned; only FUND's
workflow context supplied to Commerce requires reconciliation. No separate Platform lane,
provider work or public checkout feature is needed to express this correction.

## Data And Migration Position

No FUND customer-data remedial conversion, legacy mapping campaign or compatibility programme
is required. Chris permits recreating the developing local test bed. Staging still requires
reviewed, versioned migration(s). Confirm target/schema/ledger before applying them; never
reset shared non-FUND data. Immutable-offer/Order protection is tested with synthetic records.
Unexpected operational evidence stops a destructive step for reconciliation, not a speculative
migration programme now. This triage executes no database operation.

## Delivery Shape

Plan one coherent B1-R1 implementation candidate with ordered internal work packages:
workflow schema/resolver; Catalogue/selection semantics; C1/C2/Intake integration and downstream
context; proof/reconciliation. Do not release the Product field removal alone while downstream
consumers still use it. Split into independently deployable children only if implementation
review demonstrates an unresolved boundary that needs separate control.

Chris confirmed four explicit workflows, one per Event/Project, with Standard selling an
unmodified Product. He confirmed Catalogues are made available to Events and separately to
standalone Projects.
The plan uses existing Catalogue availability controls without a new per-Project assignment
gate, and removes default-only suppression of otherwise standalone-available Catalogues.
Other draft transition rules remain clearly labelled for implementation review.

## Gates And Safe Continuation

Next: review the detailed plan, use the confirmed workflow/scope decisions and accept the bounded
implementation contract. Then implementation -> 04 confirmation -> 05 independent review/test
-> C1/C2 human acceptance -> B1 reconciliation -> controlled dev/staging/main promotion.
Only the existing B1 controlling plan holds the restart checkpoint. Local human test work,
server, configuration and data remain untouched by triage/planning.
