# How We Work Addendum

Purpose: give humans and AI assistants a short entry point into the IsoStack collaboration,
portfolio and promotion method.

Scope: developers, maintainers, contractors and AI assistants working with IsoStack
repositories.

Last updated: 2026-08-05

## Authoritative Working Method

The complete working-method protocol is:

`../modules/<module>/work-method.md`

It defines the mandatory authority order, one-`Now`/one-`Next` portfolio limit, CR capture
contract, delivery lifecycle, defect-interruption rule and AI session start/finish checks.

The human-readable CR-to-release guide is:

`../00-roadmap-control/2026-08-05-human-guide-change-request-to-release.md`

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
current disposition and whether child/root controls changed.

## Related Guidance

- Root roadmap control: `../00-roadmap-control/README.md`
- Git workflow: `../guides/git-workflow.md`
- Safe database workflow: `../../SAFE_DATABASE_WORKFLOW.md`
