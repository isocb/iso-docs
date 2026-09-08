# CR-Fix — Local Product Workflow Class Reference Data

Date: 2026-09-08

Disposition: accepted bounded local-data repair within existing B1 smoke preparation;
repair and independent database readback PASS; authenticated Product creation pending. Control depth: High (database reference data).

Chris reports that mandatory Production Workflow Class has no choices in Create Product,
blocking construction of the local test bed. Target: existing Neon DevData, fingerprint
`0970d1fe7a73`; application `57e1454b`. Scope is local development, not staging/live.
The modal queries `fund.workflowClasses.list`, which reads active platform-level reference
rows. Read-only diagnosis found zero rows in `fund.fund_product_workflow_classes` while
migration `20260623130000_add_fund_product_workflow_classes` is completed. That committed
migration defines four protected defaults: A1, A2, B, C. Deletion cause/timing is unknown;
no code regression is established. Last proven source definition is the committed migration.

Impact: all local C1 Product creation is blocked; existing test-bed creation should be
preserved. No safe UI workaround exists while required reference data is absent. This is
contained local B1 preparation under Chris's standing instruction to make smoke testing
possible; no portfolio expedite or displacement of B1 is proposed. Next-slice planning is
not implementation authority for this repair.

Bounded repair: restore only the original migration INSERT, with original IDs/flags and
conflict-safe semantics, in a transaction after rechecking the target and empty table.
No full seed, schema change, migration replay, reset, tenant-row update or production access.
Verify all four active/read-only defaults independently. Abort if the reference table changed
since diagnosis. Transaction failure rolls back the insert; after success retain the required
reference data rather than deleting classes that newly created Products may reference.

The existing B1 plan and 04/05 records own repair authority and evidence. Human follow-up:
reopen Create Product and confirm choices and successful creation. No authenticated UI PASS
is claimed from database readback alone. Safe resumption: continue the current C1/public
Intake test-bed process with existing data intact.

Outcome: restored the four original A1/A2/B/C rows in a guarded transaction. Independent
readback found all four active, system-default and read-only; original migration remains
completed. No application change, tenant-row mutation or server restart. Refresh/reopen
the modal to refetch; use A1 for the Individual Artwork test. Human creation PASS pending.
