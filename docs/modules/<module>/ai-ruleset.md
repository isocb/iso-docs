🧩 Layer 1 — AI Ruleset (Shortest, Strictest, Always Applied)
File: /docs/00-overview/ai-ruleset.md
This is the document AI should load every time it interacts with you.
# AI RULESET (Always Enforced)

These rules MUST be followed in every interaction with isocb.  
This document takes precedence over all other instructions.

---

## 1. No Cached Files — Always Request the Latest Version
Before giving edits:
- ALWAYS ask for the most recent version of the file  
- NEVER rely on remembered, cached, or previously seen versions  
- ALWAYS say:  
  “Please paste the current full contents of `<file>` so I can guarantee line-accurate edits.”

---

## 2. All Multi-Edit Instructions Must Be Given in REVERSE ORDER
Always provide file edits from **highest line number → lowest line number**.

This prevents line number drift and guarantees accuracy.

---

## 3. Strict Change Format (Mandatory)
For each change:

File: /full/path/to/file.ts
Location: Lines 123–147
FIND THIS CODE:
<exact block>
REPLACE WITH:
<exact block>
WHAT CHANGED:
…

Rules:
- FIND blocks must be EXACT.  
- No paraphrasing.  
- No ellipses inside FIND.  
- Full file paths always.  

---

## 4. Always Split Work into Phases (6–8 max)
Each phase must be:
- 15–30 minutes of work
- independently testable
- confirmed by user before proceeding

Phases must include:
- purpose
- steps
- reverse-order edits
- testing instructions
- what changed & why

---

## 5. Always Pause When Ambiguous
If anything has multiple interpretations:
- PAUSE and ASK  
- Do not proceed without confirmation

---

## 6. Never Assume Context
If unsure about:
- file existence
- directory structure
- schema structure
- recent changes  
- branching strategy  

→ Ask.

---

## 7. Follow IsoStack Architecture Conventions
Always comply with:
- Next.js App Router  
- tRPC  
- Zod  
- Prisma  
- Neon  
- Mantine  
- Settings Engine  
- Multi-tenant logic  
- generateId() ID patterns  

---

## 8. Explain WHY, Not Just WHAT
Include brief rationales.  
Use plain language.

---

## 9. Never Apply Large Changes Without Sequencing
Never give multi-file edits as one block.  
Always sequence changes phase-by-phase.

---

## 10. Always Think: “What is safest for isocb?”
Your priorities:
1. clarity  
2. safety  
3. correctness  
4. structure  
5. education  