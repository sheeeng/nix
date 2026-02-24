# Agent Documentation Index

Complete guide to all agent-related documentation in this project.

## Overview

This project uses OpenCode agents organized into three tiers based on model capability and cost. Each agent is optimized for specific task categories.

**Reference article**: [Why I Switched My AI Agent from Opus to Haiku (And It Got Better)][article]

## Documentation Files

### For Agent Users

#### 📖 Quick Start: Agent Style Reference

**File**: `docs/agent-style-reference.md`

Quick lookup for:

- Which agent to use for which task (decision matrix)
- Agent tier comparison table
- Model names and temperatures
- How to extend with new agents

**Read this first** if you just want to know which agent does what.

---

#### 📚 Practical Guide: Agent Usage Examples

**File**: `docs/agent-usage-examples.md`

Real-world examples including:

- How to invoke each agent
- What to expect in response
- Practical workflow examples
- Tips for each agent tier
- Decision flow diagrams
- Integration with OpenCode CLI

**Read this** when you want concrete examples of agent usage.

---

### For Agent Developers

#### ✍️ Agent Writing Guide: Style Guide

**File**: `home-manager/programs/opencode/style-guide.md`

Comprehensive guide for creating and updating agents:

- Writing patterns for Haiku, Sonnet, and Opus tiers
- Temperature settings and their meanings
- Tool permission patterns
- Grammar and style rules (Chicago Manual of Style)
- File naming conventions
- Practical examples for each tier
- Success metrics

**Read this** when creating new agents or updating existing ones.

---

#### 🗂️ Strategic Document: Agent Model Optimization

**File**: `docs/agent-model-optimization.md`

Strategic analysis covering:

- Three-tier model strategy (95/4/1 distribution)
- Current agent configuration review
- Recommended model assignments
- Cost-benefit analysis
- Implementation phases
- Key principles

**Read this** to understand the strategic approach and cost implications.

---

### For Project Maintainers

#### 📋 Change Log: Agent Updates Summary

**File**: `docs/agent-updates-summary.md`

Summary of changes made to align with the article:

- Files modified and created
- Agent-by-agent changes
- Key shifts in philosophy
- Implementation status

**Read this** to understand what changed and why.

---

## Agent Architecture

### Three-Tier System

```text
Tier 1: HAIKU (95% of work)
├─ Use for: Execution, automation, file operations
├─ Model: github-copilot/claude-haiku-4.5
├─ Temperature: 0.1 (deterministic)
├─ Agents: planner, explorer
└─ Philosophy: Direct, imperative, no overthinking

Tier 2: SONNET (4% of work)
├─ Use for: Synthesis, quality, user interaction
├─ Model: github-copilot/claude-sonnet-4.5
├─ Temperature: 0.2 (balanced)
├─ Agents: builder, code-reviewer, technical-writer, security-auditor
└─ Philosophy: Pragmatic, context-aware, explains tradeoffs

Tier 3: OPUS (1% of work) [Reserved]
├─ Use for: Complex reasoning, architecture
├─ Model: github-copilot/claude-opus-4.6
├─ Temperature: 0.3 (reasoning-focused)
├─ Agents: [Future specialized agents]
└─ Philosophy: Socratic, multi-perspective, systems thinking
```

## Agent Descriptions

### Primary Agents

#### 1. Planner

- **Model**: Haiku
- **Type**: Primary
- **Purpose**: Analyze code, create plans, understand structure
- **Invoke when**: You need to understand before building
- **Example**: "Create implementation plan for feature X"

#### 2. Builder

- **Model**: Sonnet
- **Type**: Primary
- **Purpose**: Write code, modify files, debug
- **Invoke when**: You need to implement or fix
- **Example**: "Implement feature X following the plan"

### Subagent Specialists

#### 3. Explorer

- **Model**: Haiku
- **Type**: Subagent
- **Purpose**: Fast codebase search and navigation
- **Invoke when**: Finding code patterns or locations
- **Example**: "Find all places that use the auth module"

#### 4. Code Reviewer

- **Model**: Sonnet
- **Type**: Subagent
- **Purpose**: Quality and correctness review
- **Invoke when**: Reviewing code before merge
- **Example**: "Review this code for bugs and security"

#### 5. Technical Writer

- **Model**: Sonnet
- **Type**: Subagent
- **Purpose**: Documentation and guides
- **Invoke when**: Writing documentation or guides
- **Example**: "Write API documentation for this module"

#### 6. Security Auditor

- **Model**: Sonnet
- **Type**: Subagent
- **Purpose**: Vulnerability scanning and security review
- **Invoke when**: Auditing for security before deployment
- **Example**: "Audit this code for security vulnerabilities"

## Decision Matrix

| Task Type              | Agent            | Time   | Cost | Quality |
| ---------------------- | ---------------- | ------ | ---- | ------- |
| Analyze code structure | planner          | <10s   | $    | High    |
| Find code patterns     | explorer         | <5s    | $    | High    |
| Implement features     | builder          | 5-60s  | $$   | High    |
| Review code quality    | code-reviewer    | 10-30s | $$   | High    |
| Security audit         | security-auditor | 10-30s | $$   | High    |
| Write documentation    | technical-writer | 10-60s | $$   | High    |

## File Organization

```text
home-manager/programs/opencode/
├── agents/
│   ├── planner.md ..................... Primary: Planning & analysis
│   ├── builder.md ..................... Primary: Implementation
│   ├── explorer.md .................... Subagent: Code search
│   ├── code-reviewer.md ............... Subagent: Quality review
│   ├── technical-writer.md ............ Subagent: Documentation
│   └── security-auditor.md ............ Subagent: Security audit
├── skills/
│   ├── git-commit.md .................. Conventional commits
│   └── git-release.md ................. Release management
├── commands/
│   └── [custom commands]
├── default.nix ........................ Main config
└── style-guide.md ..................... Agent writing guide

docs/
├── agent-model-optimization.md ........ Strategic analysis
├── agent-style-reference.md .......... Quick reference
├── agent-updates-summary.md .......... Change summary
└── agent-usage-examples.md ........... Practical examples
```

## Naming Convention

All new documentation files use **lowercase-with-dash** format:

- ✅ `agent-model-optimization.md`
- ✅ `style-guide.md`
- ❌ ~~`AGENT_MODEL_OPTIMIZATION.md`~~ (old style)

Apply this to:

- Files in `docs/` directory
- Files in `home-manager/programs/opencode/`
- Any future documentation

## Quick Reference Table

| Need                        | Document                    | Location                        |
| --------------------------- | --------------------------- | ------------------------------- |
| Which agent to use?         | agent-style-reference.md    | docs/                           |
| Real-world examples?        | agent-usage-examples.md     | docs/                           |
| How to write agents?        | style-guide.md              | home-manager/programs/opencode/ |
| Cost optimization strategy? | agent-model-optimization.md | docs/                           |
| What changed?               | agent-updates-summary.md    | docs/                           |
| Project standards?          | AGENTS.md                   | root/                           |

## Implementation Status

### Completed ✅

- Agent configuration updates (6 files)
- Documentation creation (5 files)
- Model tier implementation
- Temperature setting optimization
- Style guide completion

### In Progress ⏳

- Testing with actual workloads
- Token usage measurement
- Cost tracking setup

### Future 📅

- Opus agent implementation
- Cost dashboard creation
- Integration with CI/CD
- Team training materials

## Key Principles

1. **Right model for right job** — Don't use Opus for everything
2. **Execution is 95% of work** — Haiku is cost-effective at scale
3. **Synthesis requires nuance** — Sonnet worth the extra cost
4. **Clear scope prevents confusion** — Each agent has "When to Use"
5. **Pragmatism over perfection** — "Shipped beats perfect"
6. **Cost awareness matters** — Track token usage per agent

## Integration Points

### With OpenCode CLI

```bash
opencode --agent planner "Analyze module structure"
opencode --agent builder "Implement feature"
opencode --agent code-reviewer "Review code"
```

### With Custom Commands

Commands defined in `docs/commands.md` can chain multiple agents:

```text
1. planner: create plan
2. builder: implement
3. code-reviewer: review
4. technical-writer: document
```

### With Skills

Related skills in `home-manager/programs/opencode/skills/`:

- `git-commit.md` — Conventional commit format
- `git-release.md` — Release management

## Further Reading

- **Original Article**: [Why I Switched My AI Agent from Opus to Haiku (And It Got Better)][article]
- **Project Standards**: `AGENTS.md` (root directory)
- **Commands Reference**: `docs/commands.md`

## Contributing

When adding new agents:

1. Reference `style-guide.md` for patterns
2. Use lowercase-dash naming
3. Include "When to Use" section
4. Set appropriate model and temperature
5. Define tool permissions clearly
6. Add to this index

---

**Last Updated**: February 18, 2026

[article]: https://thoughts.jock.pl/p/claude-model-optimization-opus-haiku-ai-agent-costs-2026
