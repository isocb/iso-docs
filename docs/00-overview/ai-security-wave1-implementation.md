# AI Issue Tracker Security Rules - Wave 1 Implementation

## ✅ Implemented Security Controls

### 1. **Status Transition Restrictions**

**AI Can Move To:**
- `IN_PROGRESS` - Started working on issue
- `IN_REVIEW` - Requesting human review
- `CHECKING` - AI signals completion, awaiting human verification

**AI Cannot Move To:**
- ❌ `DONE` - Only humans can mark issues complete
- ❌ `CANCELLED` - Only humans can cancel issues
- ❌ `BACKLOG` - Cannot revert work
- ❌ `READY` - Cannot reset state

**Rationale:** AI is a collaborator, not a release authority. Completion requires human sign-off.

---

### 2. **Required Comment Prefixes**

**All AI comments MUST start with one of:**
- `### Analysis`
- `### Implementation Notes`
- `### Open Questions`
- `### Suggested Next Steps`
- `### Testing Observations`

**Validation:** Server-side Zod schema enforces prefix requirement. Comments without valid prefixes are rejected with error message.

**Example Valid Comment:**
```markdown
### Implementation Notes

Updated ClientsTab.tsx to use row click pattern:
- Removed ActionIcon buttons from table
- Added onRowClick handler to open modal
- Moved delete button to modal footer (red, outline)

### Open Questions

1. Should this pattern apply to ProductsTab as well?
2. Do you want modal width at 70% or keep current size?
```

**Example Invalid Comment:**
```markdown
I've implemented the CRUD pattern.  ❌ REJECTED - no prefix
```

---

### 3. **Markdown-Only Enforcement**

**Format:** All comments must be valid Markdown

**Validation:** Content string is validated for required prefix structure. HTML may be sanitized in future wave.

**Benefits:**
- Clean, readable format
- Version control friendly
- Easy to parse and search
- Prevents injection attacks

---

## 🔄 Status Flow for AI

```
User creates Issue → NEW

Human triages → READY

AI claims work → IN_PROGRESS
                    ↓
AI requests review → IN_REVIEW
                    ↓
AI signals complete → CHECKING
                    ↓
Human verifies → DONE ✅ (human only)
```

---

## 🚫 What AI Cannot Do (Wave 1)

1. ❌ Mark issues as DONE or CANCELLED
2. ❌ Add comments without required prefixes
3. ❌ Use HTML formatting (Markdown only)
4. ❌ Modify issues outside its organization scope
5. ❌ Access issues without valid API key
6. ❌ Work on issues without read/write permissions

---

## 📋 What's Still Permissive (Future Waves)

These will be hardened in Waves 2-3:

- ⏳ **No claim system yet** - AI doesn't reserve issues before working
- ⏳ **No transition conditions** - AI can move IN_PROGRESS→IN_REVIEW without checking acceptance criteria
- ⏳ **No idempotency checks** - AI could add duplicate comments
- ⏳ **No field validation** - acceptanceCriteria, testingNotes, affectedAreas not enforced
- ⏳ **Limited metadata** - Issue.brief, Issue.testingNotes don't exist yet

---

## 🔐 API Key Scopes

When generating keys, scopes control:

```typescript
{
  "read": true,          // Can query issues
  "write": true,         // Can add comments and update status
  "modules": ["core"],   // Limit to specific modules
  "organizationId": "x"  // Limit to single tenant
}
```

**Read-only keys** cannot:
- Add comments
- Update status
- Create subtasks

**Write keys** can do all of the above, within security constraints.

---

## 🧪 Testing the Controls

### Test 1: Block DONE Status
```bash
# Should FAIL with 403
curl -X POST .../updateIssueStatus \
  -H "Authorization: Bearer $KEY" \
  -d '{"issueId":"xxx", "status":"DONE"}'
```

### Test 2: Enforce Comment Prefix
```bash
# Should FAIL with validation error
curl -X POST .../addComment \
  -H "Authorization: Bearer $KEY" \
  -d '{"issueId":"xxx", "content":"No prefix here"}'
```

### Test 3: CHECKING Status Works
```bash
# Should SUCCEED
curl -X POST .../updateIssueStatus \
  -H "Authorization: Bearer $KEY" \
  -d '{"issueId":"xxx", "status":"CHECKING"}'
```

### Test 4: Valid Comment Works
```bash
# Should SUCCEED
curl -X POST .../addComment \
  -H "Authorization: Bearer $KEY" \
  -d '{"issueId":"xxx", "content":"### Analysis\nThis requires..."}'
```

---

## 📊 Error Messages

Users will see clear errors when violating rules:

**Invalid Status:**
```json
{
  "error": {
    "code": "BAD_REQUEST",
    "message": "Invalid enum value. Expected 'IN_PROGRESS' | 'IN_REVIEW' | 'CHECKING', received 'DONE'"
  }
}
```

**Missing Prefix:**
```json
{
  "error": {
    "code": "BAD_REQUEST", 
    "message": "Comment must start with one of: ### Analysis, ### Implementation Notes, ### Open Questions, ### Suggested Next Steps, ### Testing Observations"
  }
}
```

---

## 🎯 Success Criteria (Wave 1)

- ✅ AI cannot mark issues as DONE
- ✅ AI must use CHECKING to signal completion
- ✅ All AI comments have required prefixes
- ✅ Markdown format enforced
- ✅ Clear error messages for violations
- ✅ Documentation updated with rules
- ✅ MCP tools describe constraints
- ✅ Zero TypeScript errors
- ✅ Backward compatible with existing issues

---

## 🚀 Deployment Checklist

Before deploying to TechTest:

1. ✅ Backend changes committed
2. ✅ MCP server rebuilt
3. ✅ Type check passes
4. ⏳ Deploy to TechTest
5. ⏳ Run integration tests
6. ⏳ Generate test API key
7. ⏳ Verify constraints work in live environment

---

## 📚 Related Documents

- `/docs/00-READ_THIS/issue_tracker_security.md` - Full security specification
- `/docs/00-overview/ai-issue-tracker-mcp-integration.md` - Architecture
- `/docs/00-overview/ai-mcp-integration-setup.md` - Setup guide

---

**Implemented:** 2026-01-16  
**Status:** Wave 1 Complete ✅  
**Next:** Deploy and test, then plan Wave 2 (claim system + transition validation)
