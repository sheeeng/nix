# Agent Style Update Reference

This document serves as a quick reference for the agent updates based on [Why I Switched My AI Agent from Opus to Haiku][article].

## What Changed

### Core Philosophy

Your agents now follow these principles:

- **Haiku (execution)**: Direct, imperative, no overthinking
- **Sonnet (synthesis)**: Pragmatic, context-aware, explains tradeoffs
- **Opus (reasoning)**: Socratic, explores multiple approaches, long-form

### File Naming

All new documentation uses **lowercase-with-dash**:

```
✓ agent-model-optimization.md
✓ style-guide.md
✓ agent-updates-summary.md
✗ AGENT_MODEL_OPTIMIZATION.md (old style)
```

## Updated Agents

### 1. Planner (Haiku — Primary)

```yaml
model: github-copilot/claude-haiku-4.5
temperature: 0.1
tools: none (read-only)
```

**Key change**: Clearer boundaries. "When to use" vs "when not to use."

### 2. Builder (Sonnet — Primary)

```yaml
model: github-copilot/claude-sonnet-4.5
temperature: 0.2 # Updated from default
tools: write, edit, bash (all enabled)
```

**Key change**: Added "When to hand off" guidance. Emphasized speed over perfection.

### 3. Explorer (Haiku — Subagent)

```yaml
model: github-copilot/claude-haiku-4.5
temperature: 0.1
tools: bash only
```

**Key change**: Simplified for "quick answers, precise paths, minimal explanation."

### 4. Code Reviewer (Sonnet — Subagent)

```yaml
model: github-copilot/claude-sonnet-4.5
temperature: 0.2 # Updated from 0.1
tools: read-only
```

**Key change**: Pragmatic review priorities. "Good shipped beats perfect unshipped."

### 5. Technical Writer (Sonnet — Subagent)

```yaml
model: github-copilot/claude-sonnet-4.5
temperature: 0.2 # Updated from default
tools: write, edit
```

**Key change**: Clearer style rules integrated. Emphasis on user-focused writing.

### 6. Security Auditor (Sonnet — Subagent)

```yaml
model: github-copilot/claude-sonnet-4.5
temperature: 0.2 # Updated from 0.1
tools: bash (ask)
```

**Key change**: Clear severity ranking. "Flag real risks" philosophy.

## New Documentation Files

### style-guide.md (in home-manager/programs/opencode/)

Comprehensive guide for writing effective agent instructions.

**Sections**:

- Core philosophy (match model to task)
- Writing patterns by tier
- Temperature settings guide
- Tool permission patterns
- Grammar and style rules
- File naming conventions
- Practical examples for each tier

**Use this when**: Creating new agents or updating existing ones

### agent-model-optimization.md (in docs/)

Strategic analysis of the three-tier model approach.

**Sections**:

- Current agent configuration review
- Three-tier strategy (95/4/1 distribution)
- Recommended agent assignments
- Cost-benefit analysis
- Implementation roadmap

**Use this when**: Planning cost optimization or understanding the strategy

### agent-updates-summary.md (in docs/)

Summary of all changes made in this update.

**Sections**:

- Files modified
- Key changes per agent
- File naming convention
- Implementation strategy status

**Use this when**: Understanding what changed and why

## Quick Reference: When to Use Each Agent

| Agent                | Model  | Use When                                      | Don't Use When                               |
| -------------------- | ------ | --------------------------------------------- | -------------------------------------------- |
| **planner**          | haiku  | Need analysis, planning, structure            | Need to write code or modify files           |
| **builder**          | sonnet | Need to implement, fix, or refactor           | Need security audit or high-level review     |
| **explorer**         | haiku  | Finding code patterns, searching codebase     | Need to understand _why_ something exists    |
| **code-reviewer**    | sonnet | Reviewing code quality and correctness        | Need to apply fixes (use builder)            |
| **technical-writer** | sonnet | Writing docs, guides, API documentation       | Need code changes (use builder)              |
| **security-auditor** | sonnet | Auditing for vulnerabilities, security review | Need general code review (use code-reviewer) |

## Temperature Settings Explained

- **0.1** (Deterministic): For execution, checklists, precise tasks
    - Agents: planner, explorer
    - Why: Consistency matters more than creativity

- **0.2** (Low Variance): For synthesis, analysis, user interaction
    - Agents: builder, code-reviewer, technical-writer, security-auditor
    - Why: Balance between quality and consistency

- **0.3+** (Higher Variance): Reserved for complex reasoning
    - For future: Opus agents for architecture/planning
    - Why: Need creative exploration of solution space

## Model Tier Strategy

From the original article. Your agents already implement this:

### Haiku (95% of Work) — Execution Tier

- File operations
- Data extraction
- Following checklists
- Automation and scripts
- **Why it works**: Precise, reliable, cost-effective

### Sonnet (4% of Work) — Synthesis Tier

- User-facing features
- Content creation
- Code review and analysis
- Documentation
- **Why it works**: Quality output, good balance

### Opus (1% of Work) — Reasoning Tier

- Complex architecture
- Novel problem-solving
- Coordinating other agents
- (Not yet implemented—for future use)
- **Why it works**: Deepest reasoning, worth the premium

## Implementation Checklist

- ✅ Updated all 6 existing agents
- ✅ Created comprehensive style guide
- ✅ Created model optimization strategy document
- ✅ Created updates summary
- ✅ Updated temperature settings for consistency
- ✅ Added "When to Use" guidance to all agents
- ⏳ Test agents with actual workloads
- ⏳ Measure token usage per agent
- ⏳ Add agent selection guide to AGENTS.md
- ⏳ Create cost tracking dashboard

## How to Extend This

### Creating a New Agent

1. **Choose the tier**: Haiku (execution), Sonnet (synthesis), or Opus (reasoning)
2. **Set appropriate config**:
    ```yaml
    model: github-copilot/claude-haiku-4.5 # or sonnet/opus
    temperature: 0.1 # or 0.2/0.3
    ```
3. **Follow the pattern** from `style-guide.md`
4. **Use lowercase-dash naming**: `new-agent-name.md`
5. **Include sections**:
    - One-sentence title
    - What this agent does
    - When to use it
    - When NOT to use it

### Example Template

```markdown
---
name: example-agent
description: Brief one-liner description
mode: subagent
model: github-copilot/claude-haiku-4.5
temperature: 0.1
tools:
    write: false
    edit: false
    bash: true
permission:
    edit: deny
    bash: allow
---

# Example Agent

One sentence describing what it does.

## What This Agent Does

- Specific capability one
- Specific capability two
- Specific capability three

## When to Use

- Scenario one
- Scenario two

## When Not to Use

- Don't use for X (use Y instead)
- Don't use for Z (use W instead)
```

## References

- **Original article**: [Why I Switched My AI Agent from Opus to Haiku (And It Got Better)][article]
- **Style guide**: `home-manager/programs/opencode/style-guide.md`
- **Strategy doc**: `docs/agent-model-optimization.md`
- **Project guidelines**: `AGENTS.md`
- **Commands reference**: `docs/commands.md`

## Key Insight from the Article

> "The most powerful model isn't always the best. I started with Opus because it's the flagship. But most of what an AI agent does—especially an autonomous one with automations, cron jobs, and scheduled tasks—is **structured execution**. Haiku excels at that."

**Your agents now reflect this**: Haiku for execution, Sonnet for synthesis, Opus (future) for reasoning.

[article]: https://thoughts.jock.pl/p/claude-model-optimization-opus-haiku-ai-agent-costs-2026
