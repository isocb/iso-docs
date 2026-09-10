# CR-Fix — Platform Next.js, Sharp And js-yaml Security Advisories

Date: 2026-09-10

Status: **Reviewed; urgent bounded remediation proposed; selection and implementation pending.**

Source: Chris requested a planning review of the failed security audit while continuing
local FUND smoke. Owner: Platform assurance. This is a new advisory finding after the
closed fast-uri correction; it does not reopen PLAT-ASSURE-04.

## Observed Failure

The [10 September scheduled Security Scan](https://github.com/isocb/isostack-bedrock/actions/runs/34448484097)
failed the High/Critical dependency gate on main, staging and dev. Each downloaded report
contains **1 Critical, 3 High, 30 Moderate and 5 Low affected package entries**. Entries
include propagated dependency findings; these are not 39 independent vulnerabilities.
The repository validator independently refused the downloaded main report as expected.
Secret Detection, Database Schema Security Check and TypeScript Type Safety passed.

The [9 September scan](https://github.com/isocb/isostack-bedrock/actions/runs/34322396057)
also failed; the [8 September scan](https://github.com/isocb/isostack-bedrock/actions/runs/34197883710)
passed at the same commit. GitHub branch readback confirms all three protected branches
remain at `14077382b7d397528e96fb6f7bdea978236a4713`. Local FUND candidate `29104b55`
has identical package.json/package-lock.json to that baseline. This is an advisory-driven
change in audit result, not evidence that the FUND changes introduced the dependencies.

| Blocking package | Locked version | Finding | Proposed patched version |
| --- | --- | --- | --- |
| Next.js | 15.5.21 | Critical Windows-hosted RCE and AVIF image-optimisation RCE advisories | 15.5.25; first patched 15.x release is 15.5.24 |
| Sharp | 0.35.3, exact override | High libheif memory-safety exposure, including possible Linux RCE | 0.35.4, explicit override update |
| js-yaml | 4.3.1, exact override | High excessive CPU use through YAML merge processing | 4.3.2, explicit override update |
| @eslint/eslintrc | 3.3.3 | High propagated from js-yaml | Resolve through its patched dependency |

Primary references:

- [Next.js AVIF advisory](https://github.com/vercel/next.js/security/advisories/GHSA-2xp9-vwfh-vxw4).
- [Next.js Windows advisory](https://github.com/vercel/next.js/security/advisories/GHSA-p293-qw3h-jr36).
- [Sharp advisory](https://github.com/lovell/sharp/security/advisories/GHSA-rgj7-g3m4-5g8c).
- [js-yaml advisory](https://github.com/nodeca/js-yaml/security/advisories/GHSA-2883-xcg3-v3hh).
- [Next.js 15.5.25 release](https://github.com/vercel/next.js/releases/tag/v15.5.25).

## Exposure And Impact

The checked-in Next configuration enables image optimisation and allows remote image
sources. Middleware excludes `/_next/image` from its matcher; authentication therefore
does not establish containment for that route. Source also uses `next/image` on sign-in
surfaces. The Sharp maintainer describes possible RCE on glibc-based Linux processing
untrusted images under certain conditions. Treat this as potentially material to the
Render deployment and all hosted tenants, rather than assuming only Windows is affected.

Actual deployed native-library/binary conditions, effective provider configuration and
attacker-controlled image reachability were not verified in this review. No exploit was
run, no compromise is asserted, and no live logs or database records were inspected.
The separate Windows-only advisory does not apply to the present macOS development host;
Render's documented Linux deployment must still be checked against the image advisory.
js-yaml and its ESLint consumer are marked development dependencies in the lockfile, with
no direct application js-yaml import found.

The existing request-body backport supports only Next.js 15.5.21. The proposed
[15.5.25 upstream source](https://raw.githubusercontent.com/vercel/next.js/v15.5.25/packages/next/src/server/next-server.ts)
still calls body.finalize without awaiting it. A version-only upgrade would fail the
postinstall guard; removing the guard would risk restoring the earlier request-body bug.
Review and preserve the correction as part of the bounded dependency fix.

## Proposed Treatment And Boundary

Expedite proposed, not accepted. Restore the mandatory High/Critical gate with a targeted
dependency/backport correction, isolated from unaccepted FUND code. No broad audit-fix,
auth downgrade, TipTap major migration, schema change or live-data operation is proposed.
Existing Moderate/Low findings remain in PLAT-ASSURE-04-R1; add the newly observed Vitest
finding to that assessment rather than silently declaring the total audit clean.

Containment applied: none to running services during this planning-only review. Continue
local FUND smoke with trusted test assets and private localhost access; avoid processing
untrusted AVIF input. An accepted implementation should patch promptly. If release is
delayed, separately assess maintainer-supported decoder blocking or a temporary optimiser
restriction and its product impact; merely changing output format is not proven containment.

Safe FUND resumption remains its current B1 controlling checkpoint and candidate `29104b55`.
Preserve local dependencies, running server, DevData and human evidence while preparing any
isolated correction. Following integration, repeat relevant request-body/image and FUND
checks against the combined candidate before promotion.

[Triage and proposed delivery boundary](../02-triage/2026-09-10-isostack-platform-next-sharp-js-yaml-security-advisories-triage.md)
owns the recommendation. Root Now/Next remain unchanged pending owner selection.
