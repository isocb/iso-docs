# How We Work Addendum

Purpose: give humans and AI assistants a short entry point into the IsoStack collaboration,
portfolio and promotion method.

Scope: developers, maintainers, contractors and AI assistants working with IsoStack
repositories.

Last updated: 2026-08-26

## Authoritative Working Method

The complete working-method protocol is:

`../modules/<module>/work-method.md`

It defines the mandatory authority order, one-`Now`/one-`Next` portfolio limit, CR capture
contract, delivery lifecycle, defect-interruption rule and AI session start/finish checks.

The human-readable CR-to-release guide is:

`../00-roadmap-control/2026-08-05-human-guide-change-request-to-release.md`

## Automatic Agent Bootstrap

The root `AGENTS.md` files in `isostack-bedrock` and `isodocs` are concise automatic entry
points for AI work. They require the assistant to start from this addendum, apply the
`Low`/`Standard`/`High` risk model and read only the authoritative roadmap and lifecycle
material needed for the requested stage.

Those files do not replace or duplicate the working method, create implementation authority
or add another governance layer. Keep them short. Amend the authoritative method first when
the working agreement changes, then align the bootstrap wording only where necessary. A new
AI run should be started after changing an `AGENTS.md` file because instruction discovery
occurs when the run begins.

## Portfolio In One Minute

IsoStack has three definitive product/Platform child roadmaps: Platform, LMSPro/SeasonPro
and FUND. Commerce Core is a separately controlled dependency lane.

The root roadmap chooses one active portfolio outcome and one next candidate:

```text
captured work -> child roadmap disposition -> root NOW/NEXT -> bounded delivery lifecycle
```

A CR records a need; it does not authorise implementation. Every new CR must be linked
from its authoritative child roadmap and given an explicit disposition in the same
documentation change.

The root control changes only when cross-lane ownership/dependency, expedite status or the
single `Now`/`Next` pair changes.

## Proportionate Control In One Minute

The lifecycle does not grow for small work. Record one control depth in the existing triage
or slice plan:

- `Low` for a tightly bounded non-sensitive presentation or local-interaction correction;
- `Standard` for ordinary product work and whenever classification is uncertain; or
- `High` for authority, tenancy, privacy/security, schema/live data, finance, bulk
  communication, destructive work, credentials/configuration or material integrations.

The depth changes evidence detail, not priority, authority, lifecycle stages or document
count. Confirmations and reviews lead with exact commit, change boundary, automated and
human evidence, proven environment, residual risk and next authorised action.

The active controlling record also carries one in-place restart checkpoint: current state,
last proven commit, current environment, next human decision/test and safe resumption point.
Do not create a separate status document for it.

## Assumption Tests Versus Production Builds

Plans must say in ordinary language whether the selected work is:

- an **assumption test**, which temporarily proves whether an approach or security model can
  work; or
- a **production build**, which creates or changes the persistent model the application will
  operate and recover.

When a slice uses temporary credentials, provider settings, services, data or other
resources to answer an uncertainty, put this distinction near the top of its existing plan.
State what is temporary, what will be removed at the end, what evidence will remain and
whether success authorises any production design. An assumption-test PASS supports a later
decision; it does not silently approve production infrastructure, credential storage,
retention, backup, recovery or operating ownership.

Do not rely on development shorthand alone. Pair terms such as `proof`, `spike`, `sandbox`,
`ephemeral` or `teardown` with plain language such as “test an assumption”, “temporary”,
“remove and revoke”, and “prove nothing remains”. This is a communication requirement
inside the existing lifecycle, not another lane, status, document or approval.

## Branch Corridor Model

Use this plain-English model when discussing work:

```text
local work branch -> dev -> origin/dev -> staging -> live
```

- A local work branch is before `dev`.
- Work is consolidated into local `dev` only after its required review/checks.
- `origin/dev` is the remote copy of accepted development work.
- `staging` is the online test environment.
- `live` is production.

Preferred phrases include:

- "still on a local work branch";
- "consolidated into dev";
- "dev and origin/dev match";
- "promoted to staging"; and
- "ready for live promotion".

Avoid ambiguous shorthand such as `staged` unless referring to the Git index. If a file is
prepared for a commit, say `added to commit`. If the online test environment is meant, say
`promoted to staging`.

## AI Continuity Rule

At the start of a substantive session, an AI assistant reads the root roadmap, the owning
child roadmap, the exact selected lifecycle records and the current worktree. It must not
select work from an old chat, CR, plan or printable summary.

At handoff, it states the achieved boundary, checks, pending human/environment gates,
current disposition and whether child/root controls changed. Detailed functional and
negative proof belongs locally; staging concentrates on environment-specific proof and a
representative critical path; live uses minimum safe non-destructive verification.

No Scrum ceremony, artificial sprint, story point, velocity measure, additional ticket
system, remedial roadmap, approval status, minor-decision document or persistent branch is
introduced by this method.

## Related Guidance

- Root roadmap control: `../00-roadmap-control/README.md`
- Git workflow: `../guides/git-workflow.md`
- Safe database workflow: `../../SAFE_DATABASE_WORKFLOW.md`
