# PLAT-ROLE-04A Incomplete-User Discoverability And Activation Triage

Date: 2026-08-17

Status: **TRIAGE DELIVERED THROUGH EXACT MAIN `fcd162db`; ALL TECHNICAL GATES PASS —
MINIMUM PRODUCTION HUMAN SMOKE PENDING**

Source:

[`CR-Fix-PLAT-ROLE-04A`](../01-cr-inputs/CR-Fix-2026-08-17-isostack-platform-plat-role-04a-seasonpro-incomplete-user-discoverability-and-activation.md)

## Decision

```text
Owner       Platform authority contract with SeasonPro C1 UI consumer
Class       Remedial discoverability and activation-integrity follow-on
Severity    Medium operational; high if activation bypass grants scope
Current     Runtime remains fail-closed; duplicate creation remains blocked
Release     Separate later commit; never amend the accepted PLAT-ROLE-04 candidate
Portfolio   PLAT-ROLE-04A local human gate is Now; FUND Stage C remains controlled Next
```

The defect is the C1 presentation and activation contract, not the P1 recovery mutation.
Incomplete Users are already returned by the server and receive no effective module scope.
They disappear only when the client divides the result into valid League/Club tabs.

Do not persist Core `DEACTIVATED` automatically. A tenant can hold multiple modules, so
Core lifecycle state cannot safely stand in for SeasonPro persona validity. Use a derived
module-access state and validate activation server-side.

One bounded slice is sufficient; no schema or data migration is expected.
