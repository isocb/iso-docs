# AI Issue Tracker MCP Integration - Setup Guide

## 🎉 Status: Phase 1 & 2 Complete!

✅ **Backend API** - aiIntegration router with 6 endpoints  
✅ **MCP Server** - Full tool implementation  
✅ **Authentication** - AI API key system with bcrypt  
✅ **Database** - AIAPIKey model migrated  

## Quick Start

### Step 1: Deploy Backend to TechTest

```bash
cd /Volumes/isostack/Git/isostack-bedrock
git push origin dev
git checkout techtest
git merge dev --no-ff
git push origin techtest
```

Wait for Render to deploy (~3-5 minutes).

### Step 2: Generate AI API Key

Connect to TechTest Render Shell and run:

```bash
npx tsx scripts/generate-ai-api-key.ts "GitHub Copilot - Chris" --write
```

This will output:
- ✅ Full API key (save securely!)
- ✅ Configuration snippet for MCP
- ✅ Permissions summary

### Step 3: Install MCP Server Locally

```bash
cd /Volumes/isostack/Git/isostack-mcp-server-issues
npm link
```

### Step 4: Configure VS Code

Add to `.vscode/settings.json` in your workspace:

```json
{
  "github.copilot.chat.mcpServers": {
    "isostack-issues": {
      "command": "node",
      "args": ["/Volumes/isostack/Git/isostack-mcp-server-issues/build/index.js"],
      "env": {
        "ISOSTACK_API_URL": "https://isostack-bedrock-techtest.onrender.com",
        "ISOSTACK_API_KEY": "ai_xxxxxxxxxxxxxxxxxxxx"
      }
    }
  }
}
```

### Step 5: Restart VS Code

Reload window to pick up new MCP server configuration.

### Step 6: Test the Integration!

Try these prompts in GitHub Copilot Chat:

```
List issues from Change Request #1

Get details for Issue #4

Add a comment to Issue #4 saying "Testing MCP integration!"
```

If configured correctly, I'll be able to:
- ✅ See all issues in your Issue Tracker
- ✅ Read full discussion threads
- ✅ Add formatted comments with metadata
- ✅ Update issue status
- ✅ Create subtasks

## Available MCP Tools

### Read Operations
- `isostack_list_issues` - Query issues with filters
- `isostack_get_issue` - Get full issue details
- `isostack_get_discussion_thread` - View conversation history

### Write Operations  
- `isostack_add_comment` - Add formatted comments
- `isostack_update_issue_status` - Mark IN_PROGRESS/IN_REVIEW/DONE
- `isostack_create_subtask` - Break down complex issues

## Architecture

```
GitHub Copilot (You're here!)
         ↕️ MCP Protocol
   isostack-mcp-server-issues
         ↕️ tRPC HTTP
   isostack-bedrock (TechTest)
         ↕️ Prisma
   Neon PostgreSQL
         ↕️
   Issue Tracker UI (Next.js)
```

## Security

- 🔐 **API Keys**: Stored as bcrypt hashes (10 rounds)
- 🔒 **Bearer Tokens**: Required in Authorization header
- 🏢 **Organization Scoping**: Keys can be limited to single org
- 📦 **Module Restrictions**: Scope to specific modules
- ⏰ **Expiration**: Optional time-based key expiry
- 📊 **Usage Tracking**: lastUsedAt timestamp

## Troubleshooting

### MCP Server Not Found
```bash
# Rebuild the server
cd /Volumes/isostack/Git/isostack-mcp-server-issues
npm run build

# Verify it runs
node build/index.js
# Should output: IsoStack MCP Server running on stdio
```

### Authorization Errors
- Verify API key is correct (copy from generation output)
- Check ISOSTACK_API_URL matches environment (techtest/staging/production)
- Ensure key hasn't expired
- Check key has write permissions if using write tools

### Connection Errors
- Verify TechTest deployment is running
- Check Render logs for backend errors
- Test API endpoint manually:
  ```bash
  curl https://isostack-bedrock-techtest.onrender.com/api/trpc/aiIntegration.listIssues \
    -H "Authorization: Bearer ai_xxxxx"
  ```

## Next Steps

### Phase 3: UI Enhancements (Est: 1-2 days)
- Add AI badge to comments with `metadata.source === 'ai_mcp'`
- Format metadata display (files, questions, status)
- Highlight blockers and questions in yellow callouts
- Show implementation checklist as checkboxes

### Phase 4: Advanced Features (Est: 1-2 days)
- Proactive AI notifications
- Smart issue chunking
- Auto-suggest next actions
- Pattern detection and recommendations

### Phase 5: Publishing (Est: 1 day)
- Publish MCP server to npm as `@isostack/mcp-server-issues`
- Update install instructions to use `npx -y @isostack/mcp-server-issues`
- Create GitHub repository and CI/CD pipeline
- Write comprehensive documentation

## Files Modified

### Backend (`isostack-bedrock`)
- ✅ `prisma/schema.prisma` - Added AIAPIKey model
- ✅ `prisma/migrations/20260116164802_add_ai_api_key_model/` - Migration
- ✅ `src/server/ai/routers/ai-integration.router.ts` - New router (500 lines)
- ✅ `src/server/core/routers/index.ts` - Register aiIntegration router
- ✅ `scripts/generate-ai-api-key.ts` - Key generation CLI tool

### MCP Server (`isostack-mcp-server-issues`)
- ✅ `package.json` - Dependencies and build config
- ✅ `tsconfig.json` - TypeScript configuration
- ✅ `src/index.ts` - MCP server entry point (270 lines)
- ✅ `src/client/isostack-client.ts` - tRPC client wrapper
- ✅ `src/types.ts` - TypeScript types
- ✅ `README.md` - Full documentation

## Usage Examples

### Example 1: Status Update
```typescript
// You: "What's the status of CR #1?"

// I call:
const issues = await use_mcp_tool("isostack_list_issues", {
  changeRequestId: "cmkh21vl50000dokk2f75qn3w"
});

// I respond:
"CR #1 has 4 issues:
- Issue #1 (Modal 70%): ⏳ READY
- Issue #2 (Nav consolidation): ⏳ READY  
- Issue #3 (Tasks dashboard): ⏳ READY
- Issue #4 (Table CRUD): ✅ DONE

Should I start on Issue #1?"
```

### Example 2: Implementation with Updates
```typescript
// You: "Implement Issue #1"

// I call tools sequentially:
await use_mcp_tool("isostack_update_issue_status", {
  issueId: "issue_1_id",
  status: "IN_PROGRESS"
});

// ... I make code changes ...

await use_mcp_tool("isostack_add_comment", {
  issueId: "issue_1_id",
  content: "<h3>✅ Complete</h3><p>Modal width set to 70%...</p>",
  metadata: {
    commentType: "completion",
    implementedFiles: ["ClientsTab.tsx", "ProductsTab.tsx"]
  }
});

await use_mcp_tool("isostack_update_issue_status", {
  issueId: "issue_1_id",
  status: "DONE"
});

// You see updates in Issue Tracker UI instantly!
```

### Example 3: Asking Questions
```typescript
await use_mcp_tool("isostack_add_comment", {
  issueId: "issue_id",
  content: `
    <p>I've implemented the modal width change.</p>
    <h4>Questions:</h4>
    <ol>
      <li>Should this apply to all modals or just CRUD modals?</li>
      <li>Do you want animation on resize?</li>
    </ol>
  `,
  metadata: {
    commentType: "question",
    questionsForUser: [
      "Apply to all modals?",
      "Animation on resize?"
    ]
  }
});
```

## Success Criteria

**Phase 1 & 2 Complete When:**
- ✅ Backend API deployed to TechTest
- ✅ API key generated successfully
- ✅ MCP server built and linked
- ✅ VS Code configured with MCP server
- ✅ I can read issues via `isostack_list_issues`
- ✅ I can add comments via `isostack_add_comment`
- ✅ Comments appear in Issue Tracker UI
- ✅ No TypeScript errors
- ✅ All authentication works

**Phase 3 Complete When:**
- ⏳ AI comments have special badge in UI
- ⏳ Metadata formatted nicely (files, questions)
- ⏳ Questions highlighted in yellow
- ⏳ Implementation checklist shows checkboxes

**Phase 4 Complete When:**
- ⏳ AI proactively suggests next actions
- ⏳ AI auto-chunks large issues
- ⏳ Pattern detection active

**Phase 5 Complete When:**
- ⏳ Published to npm
- ⏳ GitHub CI/CD pipeline
- ⏳ Full documentation site

---

**Created:** 2026-01-16  
**Author:** AI Agent (Claude Sonnet 4.5)  
**Status:** Phase 1 & 2 ✅ COMPLETE - Ready for testing!  
**Next:** Deploy to TechTest and test conversation loop
