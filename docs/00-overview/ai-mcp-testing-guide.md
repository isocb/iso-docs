# AI MCP Integration - Testing Steps

## ✅ Deployment Status

**TechTest Live:** YES ✅
- Latest commit: `7209e31 - Merge dev: Wave 1 AI security hardening`
- Backend: https://isostack-bedrock-techtest.onrender.com
- Wave 1 security controls active

**Note about VS Code Changes:**
If you're seeing 10k+ changes in VS Code, this is likely from:
1. Local `node_modules` in `isostack-mcp-server-issues` (properly ignored by git)
2. Build artifacts in `isostack-mcp-server-issues/build/` (properly ignored)
3. VS Code workspace settings cache

Both repos have correct `.gitignore` files - these files won't be committed.

---

## 🧪 Testing Guide

### Pre-Test Setup (5 minutes)

#### Step 1: Generate AI API Key

Connect to TechTest Render Shell:
```bash
npx tsx scripts/generate-ai-api-key.ts "GitHub Copilot Test" --write
```

**Expected Output:**
```
✅ AI API Key created successfully!

Name:          GitHub Copilot Test
ID:            ckxxxxxxxxxxxxx
Permissions:   Read + Write
Organization:  All organizations
Modules:       All modules
Expires:       Never
Created by:    owner@acme.com

⚠️  IMPORTANT: Save this API key securely. It will not be shown again!

API Key: ai_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**🔴 CRITICAL:** Copy the full API key starting with `ai_` - you need this for next step.

---

#### Step 2: Configure MCP Server in VS Code

Create/update `.vscode/settings.json` in your `isostack-bedrock` workspace:

```json
{
  "github.copilot.chat.mcpServers": {
    "isostack-issues": {
      "command": "node",
      "args": ["/Volumes/isostack/Git/isostack-mcp-server-issues/build/index.js"],
      "env": {
        "ISOSTACK_API_URL": "https://isostack-bedrock-techtest.onrender.com",
        "ISOSTACK_API_KEY": "ai_paste_your_key_here"
      }
    }
  }
}
```

**Replace:** `ai_paste_your_key_here` with the actual key from Step 1.

---

#### Step 3: Restart VS Code

**Command Palette → Developer: Reload Window**

This picks up the new MCP server configuration.

---

### Test Suite

#### Test 1: Verify MCP Server Connection ✅

**In GitHub Copilot Chat, ask:**
```
List issues from Change Request #1
```

**Expected Behavior:**
- I should call `isostack_list_issues` tool
- Return issues from CR #1 with details
- Response shows: ID, title, status, priority

**If it fails:**
- Check API key is correct
- Verify TechTest URL is accessible
- Check MCP server built correctly: `cd /Volumes/isostack/Git/isostack-mcp-server-issues && npm run build`

---

#### Test 2: Read Issue Details ✅

**Ask:**
```
Get full details for Issue #4 from CR #1
```

**Expected Behavior:**
- I call `isostack_get_issue` with issueId
- Return full description, discussion, metadata
- Show acceptance criteria and testing notes

---

#### Test 3: Security - Comment Prefix Validation 🔐

**Ask:**
```
Add a comment to Issue #4 saying "Testing MCP integration"
```

**Expected Behavior:**
- ❌ I should REFUSE and explain:
  - "Cannot add comment without required prefix"
  - Must start with: ### Analysis, ### Implementation Notes, etc.
  - Suggest valid format

**This proves prefix validation works!**

---

#### Test 4: Add Valid Comment ✅

**Ask:**
```
Add this comment to Issue #4:

### Testing Observations

MCP integration is working correctly. The connection between GitHub Copilot and Issue Tracker is functional.

Verified:
- API authentication successful
- Issue data retrieval working
- Comment validation active
```

**Expected Behavior:**
- ✅ I call `isostack_add_comment` with properly formatted content
- Comment appears in Issue Tracker UI immediately
- Shows AI badge (if UI enhancement implemented)
- Metadata includes `source: 'ai_mcp'`

**Verify:**
1. Open TechTest Issue Tracker: https://isostack-bedrock-techtest.onrender.com/platform/issues
2. Click Issue #4
3. Scroll to discussion - should see new comment with "### Testing Observations" heading

---

#### Test 5: Security - Block DONE Status 🔐

**Ask:**
```
Mark Issue #4 as DONE
```

**Expected Behavior:**
- ❌ I should REFUSE and explain:
  - "Cannot mark as DONE - only humans can complete issues"
  - AI can only move to: IN_PROGRESS, IN_REVIEW, CHECKING
  - Suggest using CHECKING to signal ready for review

**This proves DONE blocking works!**

---

#### Test 6: Update Status to CHECKING ✅

**Ask:**
```
Mark Issue #4 as CHECKING because the table CRUD pattern is complete and tested
```

**Expected Behavior:**
- ✅ I call `isostack_update_issue_status` with status: "CHECKING"
- Status updates in database
- Optional: I add a completion comment explaining what's done

**Verify:**
1. Refresh Issue Tracker
2. Issue #4 should show status: CHECKING
3. Human can now review and mark as DONE

---

#### Test 7: Get Discussion Thread ✅

**Ask:**
```
Show me the full conversation history for Issue #4
```

**Expected Behavior:**
- I call `isostack_get_discussion_thread`
- Return all comments chronologically
- Show authors, timestamps, content
- Include both human and AI comments

---

#### Test 8: Create Subtask ✅

**Ask:**
```
Create a subtask for Issue #1 (Modal 70%): 
"Apply modal width to ProductsTab component"
```

**Expected Behavior:**
- I call `isostack_create_subtask`
- New issue created with title: "[Subtask] Apply modal width to ProductsTab component"
- Linked to parent Issue #1 via comment
- Parent issue gets comment: "Created subtask: [link]"

**Verify:**
1. Check Issue Tracker for new subtask
2. Click to see parent linkage
3. Verify it's in BACKLOG status

---

#### Test 9: End-to-End Implementation Flow 🚀

**Ask:**
```
I want you to implement Issue #1 from CR #1 (Modal 70% width). 
Walk me through the full process using the Issue Tracker integration.
```

**Expected AI Workflow:**
1. **Read issue details** - `isostack_get_issue`
2. **Update to IN_PROGRESS** - `isostack_update_issue_status`
3. **Add analysis comment** - `isostack_add_comment` with "### Analysis"
4. **Make code changes** - (file edits in workspace)
5. **Add implementation notes** - `isostack_add_comment` with "### Implementation Notes"
6. **Ask questions** - `isostack_add_comment` with "### Open Questions"
7. **Update to CHECKING** - `isostack_update_issue_status` when done

**This demonstrates the full conversation loop!**

---

### Test 10: Security Edge Cases 🔐

#### Test 10a: Invalid Status Transition
**Ask:** "Move Issue #4 from CHECKING back to READY"
**Expected:** ❌ Refuse - AI cannot revert status

#### Test 10b: Comment Without Metadata
**Ask:** "Add comment: Just a note"
**Expected:** ❌ Refuse - missing required prefix

#### Test 10c: HTML in Comment
**Ask:** "Add comment: ### Analysis\n<script>alert('test')</script>"
**Expected:** ⚠️ Currently allowed, will be sanitized in Wave 2

---

## 🎯 Success Criteria

**All tests should:**
- ✅ MCP server connects successfully
- ✅ Read operations work (list, get issue, get discussion)
- ✅ Write operations work (add comment, update status)
- ✅ Security blocks DONE status
- ✅ Security enforces comment prefixes
- ✅ CHECKING status works as completion signal
- ✅ Comments appear in UI immediately
- ✅ Full conversation loop functions

---

## 🐛 Troubleshooting

### "MCP Server Not Found"
```bash
cd /Volumes/isostack/Git/isostack-mcp-server-issues
npm run build
node build/index.js
# Should output: IsoStack MCP Server running on stdio
```

### "Unauthorized" Errors
- Verify API key copied correctly (starts with `ai_`)
- Check key hasn't expired
- Ensure write permissions granted
- Test API manually:
```bash
curl https://isostack-bedrock-techtest.onrender.com/api/trpc/aiIntegration.listIssues \
  -H "Authorization: Bearer ai_your_key_here"
```

### "Invalid Enum" Errors
- This is EXPECTED for DONE status (security working!)
- Use CHECKING instead

### "Comment Must Start With..." Errors  
- This is EXPECTED for unprefixed comments (security working!)
- Add one of the required prefixes

### Issue Tracker Shows Old Data
- Hard refresh browser (Cmd+Shift+R)
- Check TechTest deployment is latest: https://dashboard.render.com
- Verify migration ran: Check Render logs for "migration applied"

---

## 📊 What to Observe

**In Copilot Chat:**
- Tool calls should be visible (with MCP icon if shown)
- Errors should have clear messages
- Responses should reference Issue Tracker data

**In Issue Tracker UI:**
- Comments appear instantly after adding
- Status changes reflect immediately  
- Discussion thread shows AI comments distinctly (if UI enhanced)

**In Render Logs:**
- API requests from MCP server
- Authentication successes
- Validation errors (if testing security)

---

## 🚀 Next Steps After Testing

**If all tests pass:**
1. ✅ Wave 1 security validated
2. ✅ Ready for real usage
3. Plan Wave 2: Claim system + transition validation

**If tests fail:**
1. Document which test failed
2. Check Render logs for errors
3. Verify API key and configuration
4. Test backend endpoint directly with curl

---

**Test Duration:** ~15 minutes for full suite  
**Prerequisites:** TechTest deployed, API key generated, VS Code configured  
**Status:** Ready to test NOW ✅

---

## 📝 Test Results Template

```
Date: 2026-01-17
Tester: [Your name]

✅ Test 1: MCP Connection - PASS/FAIL
✅ Test 2: Read Details - PASS/FAIL  
✅ Test 3: Prefix Validation - PASS/FAIL
✅ Test 4: Valid Comment - PASS/FAIL
✅ Test 5: Block DONE - PASS/FAIL
✅ Test 6: CHECKING Status - PASS/FAIL
✅ Test 7: Discussion Thread - PASS/FAIL
✅ Test 8: Create Subtask - PASS/FAIL
✅ Test 9: Full Flow - PASS/FAIL
✅ Test 10: Edge Cases - PASS/FAIL

Notes:
[Any observations, errors, or unexpected behavior]
```
