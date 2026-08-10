# Protected-Branch Security Scan Advisory Refresh Triage

Date: 2026-08-09

Status: **HISTORICAL TRIAGE — EXPEDITE COMPLETE AND DELIVERED THROUGH PRODUCTION AS
DEPENDENCY CHILD `60ac76c1`; ALL EXACT SCANS AND COMBINED RELEASE GATES PASS; CLOSED**

Source CR-Fix:

[`CR-Fix — Protected-Branch Security Scan Advisory Refresh`](../01-cr-inputs/CR-Fix-2026-08-09-isostack-platform-protected-branch-security-scan-advisory-refresh.md)

## 1. Triage Decision

```text
Owner      Platform assurance
Class      Remedial dependency/security-gate maintenance
Severity   High dependency findings; Low reviewed live exploitability; High release-gate impact
Urgency    Resolve before the next protected-branch promotion
Data       No schema, migration, database or live-data work
Release    Exact bounded dependency commit with separate gate evidence
```

The result is not a false positive. The packages and affected versions are genuinely present,
and the fail-closed audit validator is behaving correctly. The absence of a reviewed
application exploit path reduces immediate live risk; it does not justify suppression or a
green claim.

## 2. Root Cause

This is advisory-database drift against an unchanged lockfile:

- protected branches remain aligned at `72c02d92`;
- `js-yaml@4.3.1` was published on 2026-07-31 and its advisory entered the GitHub Advisory
  Database on 2026-08-06;
- the nanoid advisory was reviewed/updated on 2026-08-07, while patched `3.3.17` was
  published on 2026-08-03 and `3.3.18` on 2026-08-07; and
- the same lockfile that previously passed now correctly fails with two High findings.

There is no evidence that `PLAT-ROLE-02` introduced either dependency. Its local commits do
not change package manifests, lockfile, Security Scan workflow or audit validator.

## 3. Risk Assessment

| Risk | Likelihood | Impact | Rating and treatment |
| --- | --- | --- | --- |
| Runtime YAML CPU denial of service | Low at reviewed boundary | High availability if an untrusted YAML parser path exists | `js-yaml` is development-only through ESLint and no application import was found; patch promptly and do not infer zero risk beyond reviewed code |
| Runtime nanoid infinite loop | Low at reviewed boundary | High availability if attacker controls a custom generator size of zero | PostCSS makes nanoid a production dependency node, but no app import/custom generator call was found; patch promptly |
| Promotion/release blockage | Certain | High | Every protected branch shares the failing lockfile; no staging promotion should bypass the gate |
| Security false confidence | Medium if failures are dismissed | High | Preserve fail-closed validation and capture exact online reports after GitHub access is restored |
| Broad dependency churn during repair | Medium without toolchain control | Medium/High | Use Node 22/npm 10.9.8, target two packages, reject unrelated optional/transitive changes |
| Combining remediation invisibly with Role Authority | Medium | Medium | Use a separate child commit and separate audit evidence even if both reach staging together |
| Delaying correction during prolonged feature testing | Medium | Medium | If the current smoke does not conclude promptly, cut the dependency fix from `72c02d92` and promote it independently |
| Unknown additional Actions failure | Low/Unknown | Medium | Re-authenticate GitHub CLI and inspect exact job logs/run IDs before implementation closure |

No known confidentiality, tenant-isolation, privilege-escalation or data-integrity exposure is
introduced by these two advisories. The primary security property at risk is availability.

## 4. Bounded Remediation Recommendation

### Dependency resolution

- `js-yaml`: `4.3.0` -> exact patched `4.3.1`;
- `nanoid`: `3.3.16` -> compatible patched `3.3.18` (first patched is `3.3.17`);
- retain the current parent packages unless npm 10 proves an unavoidable incompatibility;
- do not upgrade Next.js, PostCSS, ESLint or unrelated packages as part of this correction;
  and
- do not run a force fix or lower the audit threshold.

Both parent ranges already admit the patched releases: `@eslint/eslintrc@3.3.3` requests
`js-yaml ^4.1.1`, and `postcss@8.5.23` requests `nanoid ^3.3.16`. This supports a narrow
transitive correction. A local npm 11 dry-run also confirms the target upgrades but proposes
large unrelated optional-platform churn; that output must not be committed. Use the accepted
npm 10 lockfile toolchain and inspect the exact diff.

### Verification

1. Clean-install with npm `10.9.8` under Node 22.
2. Confirm `npm ls js-yaml nanoid --all` resolves `4.3.1` and `3.3.18` only.
3. Run `npm audit --audit-level=moderate --json`, retain its real exit code and pass the
   repository audit validator.
4. Run the audit-validator focused tests, full Vitest suite, type-check, `npm run verify`,
   Next.js body-finalisation verification and production build.
5. Review the complete dependency diff; expected durable files are `package.json` and
   `package-lock.json` only if explicit overrides are used, or `package-lock.json` only if
   the npm 10 targeted resolution is demonstrably stable.
6. Push only the accepted exact commit to dev and require every Security Scan job to pass.
7. Record exact run IDs and inspect the retained audit artifact before staging.
8. Follow normal staging/main promotion, health and smoke controls.

Human product smoke is proportionate rather than broad: this correction changes no product
source or schema. If it is promoted as a separate dependency release, use signed-out health,
authentication entry and one representative authenticated route. If it is a separate child
commit accompanying an accepted `PLAT-ROLE-02` release, the Role Authority staging matrix
provides the authenticated product evidence, while dependency gates remain separately
recorded.

## 5. Recommended Sequence

```text
continue current local PLAT-ROLE-02 smoke
-> accept or reject this CR-Fix expedite explicitly
-> create a separate narrow dependency commit
-> local technical gates
-> exact dev Security Scan PASS
-> normal staging and main lifecycle
```

If `PLAT-ROLE-02` human testing finds further defects or cannot conclude promptly, do not
make the dependency fix wait on feature correction. Start it from protected baseline
`72c02d92`, promote it independently, and then rebase or reconstruct the unpromoted Role
Authority work on the new protected baseline through the normal non-destructive process.

## 6. Exact Online Failure Evidence

Authenticated read access is restored. Security Scan history records four consecutive
scheduled failures against exact `72c02d92`:

```text
2026-08-07  31157895565  FAIL
2026-08-08  31245943318  FAIL
2026-08-09  31300958300  FAIL
2026-08-10  31366209496  FAIL
```

In latest run
[`31366209496`](https://github.com/isocb/isostack-bedrock/actions/runs/31366209496),
the dev, staging and main `Check ... for high or critical vulnerabilities` steps fail after
successful install, audit generation and artifact upload. TypeScript Type Safety, Secret
Detection, Database Schema Security Check and Generate Security Report all pass. No second
source, schema or secret failure is hidden behind the dependency result.

The remaining online evidence is future-facing: run IDs and artifacts for the corrected
combined exact dev, staging and main SHAs.

## 7. Delivery Update

The control owner accepted combination with the completed local Role Authority outcome
before the next promotion. The correction remains its own dependency child commit and adds
only exact `js-yaml@4.3.1` and `nanoid@3.3.18` overrides plus their lock records. Isolated
Node 22/npm 10 clean-install, resolved-tree, audit-validator, full regression, TypeScript,
critical verification and production-build gates pass.

The two local child commits are now formed: Role `b1ede26f`, followed by dependency and
combined candidate `60ac76c1`. The next boundary is an explicitly authorised push of exact
`60ac76c1` to dev. Corrected online run IDs and job-level evidence remain unresolved until
that push.
