# Agent Usage Examples

Based on the updated agent style, here are practical examples of how each agent should be invoked and what to expect.

## Haiku Agents: Execution Tier

### Planner Agent — Code Analysis & Planning

**Invoke when**: You need to understand code structure before building

**Example prompt**:

```
Analyze the authentication module in src/auth.
Create a plan to add OAuth2 support.
```

**Expected response**:

- Current structure overview
- Numbered implementation steps
- File locations to modify
- No suggestions for improvement (just facts)

**Real-world tasks**:

- "Map the data flow from API request to database"
- "List all places where error handling is missing"
- "Create a refactoring plan for the legacy payment module"

---

### Explorer Agent — Code Search & Navigation

**Invoke when**: You need to find something in the codebase fast

**Example prompts**:

```
Find all files importing the 'auth' module.
Where is the WebSocket connection established?
Search for all error handling of type ValidationError.
```

**Expected response**:

- File paths with line numbers
- Minimal explanation (one line per result)
- Exact locations, no wandering

**Real-world tasks**:

- "Where is this function defined?"
- "Show all uses of the database pool"
- "Find config files by extension"

---

## Sonnet Agents: Synthesis Tier

### Builder Agent — Implementation & Debugging

**Invoke when**: You need to write, modify, or fix code

**Example prompts**:

```
Add OAuth2 authentication following the plan from planner.
Debug why the WebSocket connection times out after 5 minutes.
Refactor the payment module to use the new cache layer.
```

**Expected response**:

- Code changes (write/edit operations)
- Brief explanation of what changed and why
- Tests or validation if relevant
- Ready to commit and deploy

**Philosophy**: Ship fast, iterate later. Don't ask for permission.

**Real-world tasks**:

- Implement new features
- Fix bugs
- Optimize performance
- Refactor code sections
- Update dependencies

---

### Code-Reviewer Agent — Quality & Correctness

**Invoke when**: You want feedback before merging

**Example prompts**:

```
Review this pull request for bugs and security issues.
Check the new authentication code for common vulnerabilities.
Is this error handling approach reasonable?
```

**Expected response**:

```
Security Issues (flag immediately):
- ❌ Password stored in plain text in log file (line 42)

Correctness Issues:
- ⚠️ Missing null check before accessing user.profile

Code Quality:
- Suggest: Use const instead of let for DB_TIMEOUT (line 15)

Verdict: Good to merge once you fix the security issue.
```

**Philosophy**: Flag real problems. Appreciate tradeoffs.

---

### Technical-Writer Agent — Documentation & Guides

**Invoke when**: You need to write docs, READMEs, or user guides

**Example prompts**:

```
Write a README for the new OAuth2 authentication module.
Create API documentation for the WebSocket endpoints.
Write a troubleshooting guide for common errors.
```

**Expected response**:

- Properly structured markdown
- Clear examples showing usage
- Chicago Manual of Style compliant
- Ready to publish

**Real-world tasks**:

- Write API documentation
- Create user guides
- Update README files
- Document deployment process
- Write tutorials

---

### Security-Auditor Agent — Vulnerability Scanning

**Invoke when**: You need security review before deployment

**Example prompts**:

```
Audit the authentication module for vulnerabilities.
Review our dependency list for known CVEs.
Check if user input is properly sanitized.
```

**Expected response**:

```
🔴 Critical: SQL injection vulnerability in query builder (line 87)
  → Impact: Attacker can read entire database
  → Fix: Use parameterized queries

🟡 High: Missing HTTPS enforcement in API
  → Impact: Credentials transmitted in plain text
  → Fix: Add redirect middleware

🟢 Low: Deprecated crypto library (still secure, plan upgrade)
  → Impact: No immediate risk
  → Fix: Update to newer version when available
```

**Philosophy**: Flag real risks. Distinguish between "broken" and "could be better."

---

## Decision Flow: Which Agent to Use?

```
Do you need to understand code first?
├─ YES → planner (Haiku)
│        "Analyze this module and create a plan"
│
└─ NO → Do you need to write/modify code?
         ├─ YES → builder (Sonnet)
         │        "Implement feature X"
         │
         └─ NO → What kind of analysis?
                  ├─ Finding code locations → explorer (Haiku)
                  │  "Find where error handling happens"
                  │
                  ├─ Quality/correctness → code-reviewer (Sonnet)
                  │  "Review this code for bugs"
                  │
                  ├─ Security issues → security-auditor (Sonnet)
                  │  "Audit for vulnerabilities"
                  │
                  └─ Writing docs → technical-writer (Sonnet)
                     "Write API documentation"
```

---

## Real-World Workflow Example

### Scenario: Add Email Notification Feature

**Step 1: Understanding** (planner)

```
Invoke: planner
Prompt: "Create implementation plan for email notifications
         to replace the current webhook system"

Response: Numbered steps, file locations, dependencies
```

**Step 2: Implementation** (builder)

```
Invoke: builder
Prompt: "Implement email notifications following the plan.
         Use SendGrid for delivery, add to job queue."

Response: Code written, tests passing, ready to review
```

**Step 3: Code Review** (code-reviewer)

```
Invoke: code-reviewer
Prompt: "Review the new email notification code for bugs
         and best practices"

Response: Found 1 real bug, 2 style suggestions, approved
```

**Step 4: Security Audit** (security-auditor)

```
Invoke: security-auditor
Prompt: "Audit email notification code for security issues"

Response: No critical issues, flagged API key handling for review
```

**Step 5: Documentation** (technical-writer)

```
Invoke: technical-writer
Prompt: "Write documentation for the email notification feature,
         including setup instructions and configuration"

Response: Complete markdown documentation, ready to merge
```

**Step 6: Finding references** (explorer)

```
Invoke: explorer
Prompt: "Find all places that currently use webhooks
         so we can migrate to the new system"

Response: File locations with line numbers
```

---

## Practical Tips

### For Execution Tasks (Haiku Agents)

- **Be specific**: "Read file X and extract errors between line Y and Z"
- **Give context**: "Using this pattern, find all similar cases"
- **List requirements**: "The output should be JSON with fields: name, location, severity"

**Bad**: "Make sense of this code"
**Good**: "Analyze the authentication flow and list each step with line numbers"

### For Synthesis Tasks (Sonnet Agents)

- **Provide context**: "This is a financial system, performance is critical"
- **Mention constraints**: "We're using Python 3.8, can't use recent features"
- **Ask for reasoning**: "Why would you approach it this way instead of...?"

**Bad**: "Is this good code?"
**Good**: "Review this for security, we handle payment data. Explain your reasoning."

### For Complex Tasks (Future Opus Agents)

- **Ask open questions**: "What's the best way to redesign this for scale?"
- **Explore tradeoffs**: "Compare options for caching strategy"
- **Seek first-principles**: "Why do we approach this way? Could we fundamentally rethink it?"

---

## Cost Optimization Tips

From the article's approach, keep token usage efficient:

### Use Haiku (Cheap) for:

- ✅ Searching files by pattern
- ✅ Extracting data
- ✅ Following checklists
- ✅ File operations
- ✅ Basic transformations

### Use Sonnet (Medium) for:

- ✅ Review and feedback
- ✅ Content creation
- ✅ Debugging
- ✅ Security analysis
- ✅ Architecture decisions

### Avoid Wasting Money:

- ❌ Don't use Sonnet for simple file reads (use Haiku/Explorer)
- ❌ Don't use Haiku for complex reasoning (use Sonnet/Opus)
- ❌ Don't ask an agent to do something not in its wheelhouse

---

## Integration with Your Workflow

### In OpenCode CLI

```bash
# Use planner to analyze before building
opencode --agent planner "Analyze the caching layer and plan improvements"

# Use builder to implement
opencode --agent builder "Implement the caching improvements from the plan"

# Use code-reviewer for quality gates
opencode --agent code-reviewer "Review the new caching code"
```

### In Custom Commands

If you create custom commands in `docs/commands.md`, follow this pattern:

```markdown
## New Feature Command

Automates the workflow: plan → build → review → document

**Implementation**:

1. Invoke planner: "Create plan for feature X"
2. Invoke builder: "Implement from plan"
3. Invoke code-reviewer: "Review implementation"
4. Invoke technical-writer: "Document feature"
```

---

## Success Metrics

You're using agents effectively when:

- **Haiku agents** finish tasks in seconds without asking for clarification
- **Sonnet agents** produce output you'd share with stakeholders
- **Workflow** follows the decision flow (planner → builder → reviewer)
- **Documentation** stays up to date automatically
- **Security** gets audited before every deployment
- **Token usage** trends downward as you optimize task matching

---

## Next Steps

1. **Test these workflows** with your actual codebase
2. **Track which agents** you use most frequently
3. **Measure token usage** per agent type
4. **Refine prompts** based on response quality
5. **Create custom commands** for repeated workflows (in `docs/commands.md`)

---

## References

- Agent style guide: `home-manager/programs/opencode/style-guide.md`
- Quick reference: `docs/agent-style-reference.md`
- Original article: [Why I Switched My AI Agent from Opus to Haiku][article]

[article]: https://thoughts.jock.pl/p/claude-model-optimization-opus-haiku-ai-agent-costs-2026
