# Role Authority And Security Staging Promotion And Indicative Smoke

Date: 2026-08-10

Status: **EXACT DEV AND STAGING PROMOTION COMPLETE AT `60ac76c1`; BOTH EXACT SECURITY
SCANS PASS; PUBLIC STAGING HEALTH PASS; RENDER EXACT-BUILD CONFIRMATION AND INDICATIVE
HUMAN SMOKE PENDING; MAIN NOT AUTHORISED**

Role gate:

[`PLAT-ROLE-02B local gate`](2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity-local-gate.md)

Security gate:

[`Protected-Branch Security Scan local gate`](2026-08-10-isostack-platform-protected-branch-security-scan-advisory-refresh-local-gate.md)

## 1. Promotion Summary

The release candidate retains two separately reviewable application children:

```text
b1ede26f  Role Authority UI, Club Officials authority integrity and exact-Club junction fix
60ac76c1  exact js-yaml 4.3.1 and nanoid 3.3.18 dependency correction
```

Promotion evidence:

| Gate | Result |
| --- | --- |
| Local combined tests | PASS — 372 passed, 12 retained skips |
| Local Node 22/npm 10 clean install and audit | PASS — zero vulnerabilities |
| `origin/dev` | exact `60ac76c1` |
| Exact dev Security Scan | PASS — [`31384553388`](https://github.com/isocb/isostack-bedrock/actions/runs/31384553388) |
| Dev dependency, secret, TypeScript and schema jobs | PASS |
| `origin/staging` | exact `60ac76c1` |
| Exact staging Security Scan | PASS — [`31384766945`](https://github.com/isocb/isostack-bedrock/actions/runs/31384766945) |
| Staging dependency, secret, TypeScript and schema jobs | PASS |
| Public staging `/api/health` | PASS — HTTP 200, database connected, RLS 11/11 |
| Schema/migration/environment-contract change | NONE |
| `main` | unchanged `72c02d92` |

The public health response proves a healthy staging service but does not expose its Git SHA.
Render must display **Live at `60ac76c1`** before authenticated human testing begins.

## 2. Why An Indicative Smoke Is Proportionate

A complete replay of the 18-item local matrix is not required for this unchanged exact SHA:

- all 18 parent items, the focused item-7 correction and read-only Derby junction proof
  passed locally;
- dev and staging point to the identical commit;
- both exact branch Security Scans pass;
- no schema, migration, seed, environment contract or provider integration changed; and
- the dependency child changes resolution records, not product behaviour.

Staging therefore needs to prove the environment-sensitive seams: deployed identity,
authentication, C1/C2 routing, the corrected Owner control, Club Officials permission and
role preservation, and exact-Club persistence against staging data.

Escalate to the complete 18-item matrix if any indicative step fails, the Render SHA differs,
staging data reveals a new authority/persona combination, a migration/configuration change is
introduced, or a fix is made after this promotion.

## 3. Indicative Staging Human Smoke

Use disposable staging users only. Record each item `PASS`, `FAIL` or `NOT RUN`. Do not edit
a sole Owner or a real client-equivalent account.

1. Confirm Render staging displays **Live at `60ac76c1`** and
   `https://staging.seasonpro.co.uk/api/health` returns healthy/database connected/RLS 11/11.
2. Sign in as a C1 Owner. Open SeasonPro Users and confirm **SeasonPro User Type** is an
   editable input offering C1 Owner, C1 Admin and C2 Member; do not save an authority change
   to a real user.
3. Open or create one disposable C1 Admin with one exact League role. Save/reopen and
   confirm Organisation `ADMIN`, League role and C1 dashboard routing remain stable.
4. As that C1 Admin, open user creation and confirm the target is fixed to C2 Member and
   requires one exact Club role plus one exact current Club; no C1 Owner/Admin option is
   offered.
5. Create or edit one disposable C2 Member with the `Club Secretary` role and one current
   Club. Save/reopen, sign in as that user and confirm C2 Club routing and the Officials page
   load for that exact Club. Another Club/direct context must be refused with an explicit
   error, not an empty table.
6. On one disposable hat-swap C1 user, retain an exact League role, exact Club role and exact
   Club. Edit/reselect the Club role through Club Officials, save/reopen and confirm the
   League role survives, runtime remains dual-context and module access is not lost.
7. Change the disposable C2 user's exact Club to a different current Club, save/reopen and
   confirm only the newly selected Club route is available. Report the selected user/Club
   to the control window for one read-only current-junction verification; then restore or
   retire the disposable fixture according to staging test-data policy.
8. Sign out and sign back in once, then open one representative C1 route and one permitted C2
   route. Confirm there is no Auth.js fetch error, permission masquerading as empty data or
   unexpected session loss.

## 4. Stop And Promotion Rule

Any failure stops the release and blocks main. Do not broaden or repair staging data ad hoc;
record the exact actor, target, role, Club, route and time, then return to bounded triage.

If all eight checks pass, record the results here and reconcile the authoritative roadmaps.
Main still requires a separate explicit promotion instruction, exact main Security Scan,
public production health and a proportionate post-deploy smoke.
