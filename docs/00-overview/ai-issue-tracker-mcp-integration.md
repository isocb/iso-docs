# AI Issue Tracker Integration via MCP Server

## Overview

Enable GitHub Copilot to directly interact with IsoStack Issue Tracker through Model Context Protocol (MCP) server, creating a sustainable bidirectional conversation loop for Change Requests.

## Architecture

```
GitHub Copilot (AI Agent)
         ↕️ (MCP Protocol)
   IsoStack MCP Server
         ↕️ (tRPC + Prisma)
   IsoStack Database (Neon)
         ↕️
   Issue Tracker UI (Next.js)
```

## MCP Server Specification

### Installation
```json
// User's Claude Desktop config.json or VS Code settings
{
  "mcpServers": {
    "isostack-issues": {
      "command": "npx",
      "args": ["-y", "@isostack/mcp-server-issues"],
      "env": {
        "ISOSTACK_API_URL": "https://isostack-bedrock-techtest.onrender.com",
        "ISOSTACK_API_KEY": "ai_key_xxxxx"
      }
    }
  }
}
```

### Tools Exposed to AI

#### 1. `isostack_list_issues`
```typescript
{
  name: "isostack_list_issues",
  description: "List issues from a Change Request or with filters",
  inputSchema: {
    type: "object",
    properties: {
      changeRequestId: { type: "string", description: "Filter by CR ID" },
      status: { type: "string", enum: ["BACKLOG", "READY", "IN_PROGRESS", "IN_REVIEW", "DONE", "CANCELLED"] },
      priority: { type: "string", enum: ["LOW", "MEDIUM", "HIGH", "CRITICAL"] },
      module: { type: "string", description: "Filter by module slug" },
      assignedToAI: { type: "boolean", description: "Show only issues assigned to AI" }
    }
  }
}
```

**Example Usage:**
```typescript
// AI calls this tool
const issues = await use_mcp_tool("isostack_list_issues", {
  changeRequestId: "cmkh21vl50000dokk2f75qn3w",
  status: "READY"
});

// Returns:
[
  {
    id: "cmkgzejnf000jw05fok1qcmx7",
    title: "Organisation table CRUD standard - remove action icons, use row click",
    description: "...",
    status: "READY",
    priority: "HIGH",
    module: "core",
    discussion: [...], // Full comment thread
    metadata: {
      affectedFiles: ["ClientsTab.tsx"],
      estimatedComplexity: "medium"
    }
  }
]
```

#### 2. `isostack_get_issue`
```typescript
{
  name: "isostack_get_issue",
  description: "Get full details of a specific issue including discussion thread",
  inputSchema: {
    type: "object",
    properties: {
      issueId: { type: "string", required: true },
      includeRelated: { type: "boolean", description: "Include related issues/dependencies" }
    }
  }
}
```

#### 3. `isostack_add_comment`
```typescript
{
  name: "isostack_add_comment",
  description: "Add a comment to an issue (AI updates, questions, completion notes)",
  inputSchema: {
    type: "object",
    properties: {
      issueId: { type: "string", required: true },
      content: { type: "string", required: true, description: "HTML or markdown content" },
      metadata: {
        type: "object",
        properties: {
          commentType: { 
            type: "string", 
            enum: ["analysis", "implementation_plan", "progress_update", "completion", "question", "blocker"],
            description: "Type of comment for UI rendering"
          },
          completionStatus: { type: "string", enum: ["started", "in_progress", "completed", "blocked"] },
          implementedFiles: { type: "array", items: { type: "string" } },
          questionsForUser: { type: "array", items: { type: "string" } },
          estimatedTime: { type: "string", description: "e.g., '30 minutes', '2 hours'" },
          dependencies: { type: "array", items: { type: "string" }, description: "Other issue IDs" }
        }
      }
    }
  }
}
```

**Example Usage:**
```typescript
// AI adds completion notes
await use_mcp_tool("isostack_add_comment", {
  issueId: "cmkgzejnf000jw05fok1qcmx7",
  content: `
    <h3>✅ Implementation Complete</h3>
    <p>Updated ClientsTab to use row click pattern:</p>
    <ul>
      <li>Removed ActionIcon buttons from table</li>
      <li>Added onRowClick handler to open modal</li>
      <li>Moved delete button to modal footer (red, outline)</li>
    </ul>
    <h4>Questions for Review:</h4>
    <ol>
      <li>Should we apply this pattern to ProductsTab as well?</li>
      <li>Do you want modal width at 70% or keep current size?</li>
    </ol>
  `,
  metadata: {
    commentType: "completion",
    completionStatus: "completed",
    implementedFiles: [
      "src/app/(platform)/platform/_components/ClientsTab.tsx"
    ],
    questionsForUser: [
      "Apply pattern to ProductsTab?",
      "Modal width preference?"
    ]
  }
});
```

#### 4. `isostack_update_issue_status`
```typescript
{
  name: "isostack_update_issue_status",
  description: "Update issue status (typically when AI completes work)",
  inputSchema: {
    type: "object",
    properties: {
      issueId: { type: "string", required: true },
      status: { type: "string", enum: ["IN_PROGRESS", "IN_REVIEW", "DONE"], required: true },
      completionNotes: { type: "string", description: "Summary of what was done" }
    }
  }
}
```

#### 5. `isostack_create_subtask`
```typescript
{
  name: "isostack_create_subtask",
  description: "Break down a complex issue into smaller tasks",
  inputSchema: {
    type: "object",
    properties: {
      parentIssueId: { type: "string", required: true },
      title: { type: "string", required: true },
      description: { type: "string" },
      estimatedTime: { type: "string" }
    }
  }
}
```

#### 6. `isostack_get_discussion_thread`
```typescript
{
  name: "isostack_get_discussion_thread",
  description: "Get full conversation history for an issue",
  inputSchema: {
    type: "object",
    properties: {
      issueId: { type: "string", required: true },
      includeMetadata: { type: "boolean", description: "Include comment metadata" }
    }
  }
}
```

## Conversation Flow Examples

### Example 1: User Assigns Issue to AI
```
User: "Can you implement Issue #4 from CR #1?"

AI: [calls isostack_get_issue("cmkgzejnf000jw05fok1qcmx7")]
AI: "I'll implement the Organisation table CRUD standard. Let me add a comment to track progress."

AI: [calls isostack_add_comment with analysis]
AI: [calls isostack_update_issue_status to IN_PROGRESS]
AI: [makes code changes]
AI: [calls isostack_add_comment with completion notes]
AI: [calls isostack_update_issue_status to IN_REVIEW]

AI: "✅ Issue #4 is ready for review. I've added implementation notes and questions in the issue thread."
```

### Example 2: User Asks for Status Update
```
User: "What's the status of CR #1?"

AI: [calls isostack_list_issues(changeRequestId: "cmkh21vl50000dokk2f75qn3w")]

AI: "Change Request #1 has 4 issues:
- Issue #1 (Modal 70%): ⏳ READY - Not started
- Issue #2 (Nav consolidation): ⏳ READY - Waiting on Issue #4
- Issue #3 (Tasks dashboard): ⏳ READY - Not started  
- Issue #4 (Table CRUD): ✅ IN_REVIEW - Completed, awaiting your review

Should I start on Issue #1 while you review #4?"
```

### Example 3: AI Discovers Blocker
```
AI: [working on Issue #2]
AI: [calls isostack_add_comment with blocker metadata]

Comment content:
"🚧 Blocker Discovered

While implementing organisation page navigation, I found that the tabs system conflicts with the new modal pattern from Issue #4.

**Options:**
1. Refactor tabs to use Mantine Tabs component (2 hours)
2. Keep current implementation but adjust modal z-index (30 minutes)
3. Wait for design decision on tab navigation pattern

**Question:** Which approach do you prefer?"

AI to User: "I've hit a blocker on Issue #2 and added details to the discussion. Need your input before proceeding."
```

## Implementation Plan

### Phase 1: MCP Server Foundation (Week 1)
**Goal:** Create basic MCP server with read-only access

**Deliverables:**
1. New repo: `isostack-mcp-server-issues`
2. Package structure:
   ```
   isostack-mcp-server-issues/
   ├── src/
   │   ├── index.ts           # MCP server entry point
   │   ├── tools/
   │   │   ├── list-issues.ts
   │   │   ├── get-issue.ts
   │   │   └── get-discussion.ts
   │   ├── client/
   │   │   └── isostack-client.ts  # tRPC client wrapper
   │   └── types.ts
   ├── package.json
   └── README.md
   ```

3. Tools implemented:
   - `isostack_list_issues` (read-only)
   - `isostack_get_issue` (read-only)
   - `isostack_get_discussion_thread` (read-only)

**Success Criteria:**
- AI can read issues from TechTest database
- AI can see discussion threads
- AI can filter by CR, status, priority

### Phase 2: Write Operations (Week 2)
**Goal:** Enable AI to add comments and update status

**Deliverables:**
1. Backend API endpoints:
   ```typescript
   // src/server/ai/routers/ai-integration.router.ts
   export const aiIntegrationRouter = router({
     addComment: aiAuthProcedure.mutation(...),
     updateStatus: aiAuthProcedure.mutation(...),
     createSubtask: aiAuthProcedure.mutation(...),
   });
   ```

2. Authentication system:
   - Generate API keys: `AI_API_KEY_xxxxxxx`
   - Store in `AIAPIKey` table with scope restrictions
   - Validate in `aiAuthProcedure` middleware

3. MCP tools:
   - `isostack_add_comment` (write)
   - `isostack_update_issue_status` (write)
   - `isostack_create_subtask` (write)

**Success Criteria:**
- AI can add formatted comments to issues
- AI can update issue status to IN_PROGRESS/IN_REVIEW/DONE
- All changes appear in Issue Tracker UI immediately
- Audit log tracks AI actions with special `aiApiKeyId` field

### Phase 3: Enhanced UI Integration (Week 3)
**Goal:** Display AI comments distinctly in Issue Tracker UI

**Deliverables:**
1. Comment type detection:
   ```typescript
   // Detect AI comments by author or metadata
   const isAIComment = comment.author === 'AI Agent' || comment.metadata?.source === 'ai_mcp';
   ```

2. Special rendering:
   ```tsx
   {isAIComment && (
     <Badge color="violet" size="xs" leftSection={<IconRobot size={12} />}>
       AI Agent
     </Badge>
   )}
   ```

3. Metadata display:
   - Show implementation files as clickable links
   - Highlight questions for user in yellow callout
   - Display completion checklists with checkboxes

**Success Criteria:**
- AI comments visually distinct from user comments
- Questions/blockers highlighted prominently
- Implementation notes formatted nicely

### Phase 4: Advanced Features (Week 4)
**Goal:** Proactive AI assistance and notifications

**Deliverables:**
1. AI notification triggers:
   - User adds comment → AI gets notification
   - Issue status changed → AI checks if action needed
   - New CR created → AI offers to analyze and estimate

2. Proactive suggestions:
   ```typescript
   // AI monitors for patterns
   if (issue.status === 'BACKLOG' && issue.priority === 'CRITICAL') {
     await aiSuggest(issueId, "This critical issue has been in backlog for 3 days. Should I start on it?");
   }
   ```

3. Smart chunking:
   - AI analyzes large issues
   - Automatically suggests subtasks
   - Creates implementation phases

**Success Criteria:**
- AI suggests next actions unprompted
- AI breaks down complex issues automatically
- AI asks clarifying questions proactively

## Security Considerations

### API Key Management
```typescript
// AIAPIKey table schema
model AIAPIKey {
  id           String   @id @default(cuid())
  key          String   @unique // Hashed like passwords
  name         String   // "GitHub Copilot - Chris Workspace"
  scope        Json     // { "read": true, "write": true, "modules": ["core", "bedrock"] }
  organizationId String?
  createdBy    String
  lastUsedAt   DateTime?
  expiresAt    DateTime?
  createdAt    DateTime @default(now())
}
```

### Scope Restrictions
- Read-only keys for initial testing
- Write access only to specific modules
- Cannot delete issues or users
- Cannot modify permissions
- Cannot access sensitive data (passwords, payment info)

### Rate Limiting
```typescript
// Use Upstash Redis from existing implementation
const rateLimiter = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(100, "1 h"), // 100 requests per hour
  analytics: true,
});
```

## Alternative: Lightweight Webhook Approach

If MCP server is too complex initially, consider webhook pattern:

```typescript
// src/server/ai/routers/ai-webhook.router.ts
export const aiWebhookRouter = router({
  // Called by CLI tool with Bearer token
  processRequest: publicProcedure
    .input(z.object({
      action: z.enum(['add_comment', 'update_status', 'get_issue']),
      issueId: z.string(),
      payload: z.any(),
    }))
    .mutation(async ({ ctx, input }) => {
      const apiKey = ctx.req?.headers.authorization?.replace('Bearer ', '');
      // Validate API key, perform action, return result
    }),
});
```

**CLI wrapper for AI:**
```bash
# I run this in terminal
curl -X POST https://techtest.com/api/ai/webhook \
  -H "Authorization: Bearer $ISOSTACK_AI_KEY" \
  -H "Content-Type: application/json" \
  -d '{"action":"add_comment","issueId":"xxx","payload":{...}}'
```

This is simpler but less elegant than MCP.

## Recommendation

**Start with Phase 1 + 2 of MCP Server** (Weeks 1-2)

**Why MCP:**
- ✅ Native GitHub Copilot integration
- ✅ No manual scripts to run
- ✅ Persistent across sessions
- ✅ Standardized protocol (future-proof)
- ✅ Works in VS Code, Claude Desktop, and any MCP client

**Effort:**
- Backend: 2-3 days (API endpoints + auth)
- MCP Server: 2-3 days (tool implementations)
- Testing: 1-2 days
- **Total: ~1 week for MVP**

**ROI:**
- Eliminates one-off scripts
- Creates sustainable conversation loop
- Scales to all future features (not just Issue Tracker)
- Can extend to Bedrock sheets, Pulse forms, etc.

## Next Steps

1. **Decision:** Do you want to proceed with MCP server approach?
2. **If yes:** Should I create the repository structure and basic implementation?
3. **API design:** Review the tool specifications above - any changes needed?
4. **Auth strategy:** Prefer API keys or OAuth tokens for AI access?

---

**Created:** 2026-01-16  
**Author:** AI Agent (Claude Sonnet 4.5)  
**Status:** Proposal - Awaiting approval
