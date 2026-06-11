# DOCUMENTATION_RESTRUCTURE_PLAN

## 1) Principles
- `isodocs` is the canonical documentation home.
- `isostack-bedrock` markdown is code-adjacent unless strong canonical need.
- Preserve archive/legacy docs; do not delete in this pass.
- Do not move or mutate files until this inventory is reviewed.

## 2) Current counts
- total: 623
- current: 220
- conflicting: 60
- stale: 1
- duplicate: 204
- archive: 138

## 3) Recommended sequence
1) Resolve conflicting operational guidance in `isodocs` (`db-push`, `db-seed`, `main`, `TechTest`, `AMOW-as-module`, `old stack`, unscoped tenant examples).
2) Confirm duplicate mapping list and establish canonical references in indexes/landing pages.
3) Add archive index metadata on high-risk legacy paths before any relocation.
4) Run link integrity checks for move-sensitive docs.
5) Re-run this audit and produce an updated pass.
