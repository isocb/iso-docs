# PLAT-ROLE-02B Club Officials Authority Integrity Local Gate

Date: 2026-08-10

Status: **COMPLETE LOCAL PASS; EXACT ROLE/SECURITY CANDIDATE `60ac76c1` ALIGNED THROUGH
DEV, STAGING AND MAIN; STAGING 8/8, ALL EXACT SECURITY SCANS AND PUBLIC HEALTH PASS;
PRODUCTION RENDER IDENTITY AND NON-MUTATING ROUTE SMOKE REMAIN**

Implementation:

[`PLAT-ROLE-02B implementation`](../04-implementation-confirmations/2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity-implementation.md)

Parent matrix:

[`PLAT-ROLE-02 local human smoke`](2026-08-06-isostack-platform-plat-role-02-review-and-local-human-smoke-gate.md)

## 1. Review Conclusion

The implementation matches the accepted item-3/item-15 boundary:

- Item 3 no longer depends on the deprecated position label for same-Club admission.
- Query refusal is not an empty business result.
- Item 15 no longer replaces the complete role array with one Club role.
- The exact Club role is selected/displayed independently of the League role's array order.
- Actor and target boundaries fail closed on invalid tenant, Club, role, read-only or
  complete-persona state.
- Every multi-record mutation is transactional.
- Removal no longer retains an orphan Club role while clearing the Club.

The review found no schema, migration, Core-authority, invitation or session-revocation
change. The repaired fixture now has the exact pre-failure C1 hat-swap persona required for
human testing.

## 2. Automated Gate Summary

```text
focused tests              34 PASS
full regression            372 PASS / 12 SKIP
TypeScript                 PASS
changed production lint    PASS / zero errors
critical verification      PASS
body backport verification PASS
standalone body regression 22/22 PASS
production build           PASS / 131
diff check                 PASS
```

Skipped tests are the repository's retained pre-existing skip set, not new failures.

## 3. Completed Human Evidence

The control owner completed and accepted the parent item-1-through-item-18 matrix on local
dev. Items 3 and 15 pass after the original `PLAT-ROLE-02B` correction. Item 7's intended
persona assertion also passes: changing the disposable C2 user's exact role and Club
retained Organisation `MEMBER` and reopened correctly.

The additional Officials refusal observed while signed in as `c2b@isodo.co.uk` is an
expected component decision, not a failed C2 boundary. The selected `Club Secretary Club`
role does not grant `clubs.officials.view`; the separate `Club Secretary` role does. This
slice does not weaken that server permission or rewrite the tenant's role catalogue.

## 4. Item-7 Focused Rectification Gate

Read-only audit/data review exposed a separate defect beneath the otherwise passing item:
after changing Derby Spitfires to Nottingham Tigers, both current-season ClubOfficial
junctions remained. The User's exact Club was correct, but the former current Club context
was not retired.

The local correction now reconciles all current-season junctions atomically whenever the
exact Club is edited. It retains only the selected current Club, or removes all current
memberships when Club is cleared, while preserving historical-season records.

Run only this focused local check; the parent matrix does not need repeating:

1. PASS As C1 Owner, edit disposable `c2b@isodo.co.uk` back to C2 `MEMBER`, select exactly one
   active Club role and exactly one current Club, then Save and reopen.
2. PASS Confirm Organisation `MEMBER`, the exact Club role and selected Club are stable and C2
   routing is for that Club only.
3. PASS To test the Officials page positively, select a role which actually grants
   `clubs.officials.view` (currently `Club Secretary`). With `Club Secretary Club`, an
   explicit permission refusal is the expected result.
4. PASS — Derby Spitfires. Read-only verification after the control-owner Save confirms:

   ```text
   Organisation authority       MEMBER
   User exact Club               Derby Spitfires FC
   current-season junction count 1
   junction Club                 Derby Spitfires FC
   former other current Club     absent
   ```

   No historical-season row was changed by the verification.

Any persistence, routing or junction mismatch reopens only this bounded rectification.

## 5. Promotion Decision

Current decision: **PARENT 1–18 HUMAN MATRIX, ITEM-7 FOCUSED RETEST, LOCAL AND STAGING
READ-ONLY EXACT-JUNCTION PROOFS, AND STAGING 8/8 ALL PASS. ROLE CHILD `b1ede26f` IS
FOLLOWED BY SEPARATE DEPENDENCY CHILD/COMBINED RELEASE `60ac76c1`, NOW ALIGNED THROUGH
MAIN WITH ALL THREE EXACT SECURITY SCANS AND PUBLIC HEALTH GREEN**.

The two child commits remain separately reviewable. Production Render identity and the
documented non-mutating C1/C2 route smoke complete the combined deployment record; they do
not require repetition of the mutation-heavy local/staging matrices.
