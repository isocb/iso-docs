# How We Work Addendum

Purpose: record collaboration conventions that keep IsoStack development understandable, safe, and repeatable.

Scope: applies to developers, maintainers, contractors, and AI assistants working with IsoStack repositories.

Last updated: 2026-07-01

---

## Branch Corridor Model

Use this plain-English model when discussing work:

```text
local work branch -> dev -> origin/dev -> staging -> live
```

This is the preferred collaboration language even though Git can represent branches in more complex ways.

- A local work branch is treated as before `dev`.
- Work is consolidated into local `dev` only after review/checks.
- `origin/dev` is the remote copy of accepted development work.
- `staging` is the online test environment.
- `live` is production.

The aim is to keep the workflow legible: work starts locally, is accepted into `dev`, is backed up to `origin/dev`, then is promoted onward.

---

## AI Assistant Rule

When reporting branch or release status, AI assistants should use the corridor language above.

Preferred phrases:

- "still on a local work branch"
- "consolidated into dev"
- "dev and origin/dev match"
- "promoted to staging"
- "ready for live promotion"

Avoid ambiguous shorthand such as "staged" unless referring specifically to the Git index. If a file has been prepared for a commit, say "added to commit" or "queued for commit". If the online test environment is meant, say "promoted to staging".

---

## Related Guidance

- Git workflow: `../guides/git-workflow.md`
- Safe database workflow: `../../SAFE_DATABASE_WORKFLOW.md`
