# OpenCode Agent Style Guide

Based on [Why I Switched My AI Agent from Opus to Haiku][article], this style guide ensures your agents adopt clear, actionable communication patterns optimized for their tier and purpose.

## Core Philosophy

The article demonstrates that **the right model for the right job beats the expensive model for everything**. Apply this principle to your writing:

- **Be direct**: Stop over-explaining. Most work is execution, not creative reasoning.
- **Avoid overthinking**: When you have a checklist, follow it. Don't suggest alternatives unless asked.
- **Match the tier**: Haiku agents write concisely. Sonnet agents add nuance. Opus agents design.
- **Execution > creativity**: For 95% of tasks, precision beats eloquence.

## Writing Patterns by Agent Tier

### Haiku Agents (Execution Tier)

**When to use**: File operations, data extraction, automation, following scripts, API calls, scheduled tasks.

**Writing style**:

- Imperative voice: "Read the file and extract errors"
- No hedging: avoid "could," "might," "consider"
- Numbered steps for checklists
- Brief explanations (one sentence per action)
- Focus on the "what," not the "why"

**Example** (Good):

```markdown
1. Read the file.
2. Extract lines matching the pattern.
3. Format output as JSON.
4. Write to destination.
```

**Example** (Avoid):

```markdown
You might want to consider reading the file to potentially extract
the matching lines, which could be formatted as JSON if you think
that would be helpful, and then perhaps write it somewhere.
```

**Structure**:

```
---
name: [agent-name]
mode: [primary|subagent]
model: github-copilot/claude-haiku-4.5
temperature: 0.1
tools:
    write: [true|false]
    edit: [true|false]
    bash: [true|false]
permission:
    edit: [allow|ask|deny]
    bash: [allow|ask|deny]
---

# [Agent Title]

[One sentence: what this agent does]

## Task Checklist

- [ ] Step one
- [ ] Step two
- [ ] Step three

## Expected Input

[What the user provides]

## Expected Output

[What the agent produces]
```

### Sonnet Agents (Synthesis Tier)

**When to use**: Code reviews, feature building, content creation, user interaction, complex debugging.

**Writing style**:

- Active voice with context
- Explain reasoning briefly
- Nuance when relevant (edge cases, tradeoffs)
- Examples before and after
- Focus on the "why" matters
- Conversational but professional

**Example** (Good):

```markdown
Code reviews should balance quality with pragmatism. Flag genuine bugs
and security issues immediately. Suggest improvements for readability,
but accept that "good enough" shipped is better than "perfect" delayed.
```

**Example** (Avoid):

```markdown
You should probably review the code, but maybe not too strictly,
because sometimes good is good enough, and also people get frustrated
with too many comments, so perhaps be gentle?
```

**Structure**:

```
---
name: [agent-name]
mode: [subagent]
model: github-copilot/claude-sonnet-4.5
temperature: 0.2
tools:
    write: [true|false]
    edit: [true|false]
    bash: [true|false]
permission:
    edit: [allow|ask|deny]
    bash: [allow|ask|deny]
---

# [Agent Title]

[Two to three sentences: what this agent does and when]

## Context

[Why this agent exists and what problems it solves]

## Approach

[How the agent should think about the task]

### When This Matters

[Edge cases or situations where judgment is needed]

### When It Doesn't

[Things to deprioritize]

## Example

[Concrete example of good output]
```

### Opus Agents (Reasoning Tier)

**When to use**: Architectural decisions, complex planning, debugging cascading failures, coordinating other agents.

**Writing style**:

- Socratic: ask clarifying questions
- Multi-perspective: show tradeoffs
- First-principles reasoning
- Long-form explanations
- Systems thinking (not just code)
- Future-proof recommendations

**Example** (Good):

```markdown
Before redesigning, clarify: Are we optimizing for speed, cost, or
maintainability? Each suggests different architectures. Fast execution
argues for caching. Low cost argues for serverless. Maintainability
argues for modular separation. Often we need all three—this is the
tension worth exploring.
```

**Example** (Avoid):

```markdown
Just refactor it.
```

**Structure**:

```
---
name: [agent-name]
mode: [subagent]
model: github-copilot/claude-opus-4.6
temperature: 0.3
tools:
    write: [true|false]
    edit: [true|false]
    bash: [true|false]
permission:
    edit: [allow|ask|deny]
    bash: [allow|ask|deny]
---

# [Agent Title]

[One sentence: the kind of problem this solves]

## When to Invoke

[Specific signals that you need this agent]

## The Approach

[How this agent reasons about complex problems]

### Questions to Ask First

[Clarifying questions the agent should explore]

### Decision Framework

[How to evaluate different options]

### Red Flags

[Warning signs of common pitfalls]

## Example Scenario

[A realistic complex situation and how to approach it]
```

## Cross-Cutting Guidelines

### For All Agents

1. **Use active voice**: "Identify bugs" not "bugs should be identified."
2. **Be specific**: "Extract error messages from logs" not "process the logs."
3. **Use imperative verbs**: Start lines with action verbs. Example: "Analyze and understand code" not "Code analysis and understanding."
4. **Avoid jargon** unless necessary (and define it if used).
5. **Single task focus**: Each agent specializes in one thing.
6. **Clear boundaries**: "When to use this agent" and "when not to."
7. **One sentence per tool/action**: Do not bundle operations.

### Git Commit Messages

Follow Conventional Commits specification for all commit messages.

**Commit Title Rules**:

- Maximum length: 50 characters, must be under 50 characters.
- Format: `type(scope): description`
- Use imperative mood: "add" not "added".
- Keep description entirely lowercase, including product names.
- Do not capitalize any words in the description.
- Do not end the description with a period.
- Verify character count before committing with `echo --no-newline "title" | wc --chars` command.

**Commit Body Rules**:

- Wrap lines at 72 characters maximum per line.
- Use proper grammar and punctuation following Chicago Manual of Style.
- Write complete sentences ending with periods.
- Explain what changed and why, not how.

**Common Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.

**Example**:

```text
fix(packages): add libnotify for notifications

The zsh-auto-notify plugin requires notify-send (provided by libnotify)
to display desktop notifications on Linux. This adds libnotify to the
Linux-specific package list to satisfy this dependency.
```

### Grammar & Punctuation

Follow Chicago Manual of Style throughout all agent documentation and instructions.

**General Rules**:

- Maintain correct grammar and proper punctuation in all comments and documentation.
- Avoid unnecessary comments. Use correct punctuation for comments that exist.
- Discard all empty trailing whitespace from every file, except Markdown files.

**Sentence Case (Regular Text)**:

Use sentence case (sentence style) for regular comments, descriptions, and explanatory text. Begin sentences with a capital letter and follow standard punctuation rules.

**Title Case (Headings and Section Names)**:

Use title case (headline style) for headings, titles, and section names. Apply these Chicago Manual of Style rules:

- Always capitalize the first and last words.
- Capitalize all nouns, pronouns, verbs, adjectives, and adverbs.
- Lowercase articles such as a, an, the.
- Lowercase coordinating conjunctions such as and, but, or, for, nor, so, yet.
- Lowercase prepositions such as at, by, for, from, in, into, of, on, to, with, between, through.
- Lowercase "to" in infinitives such as to run, to see, to build.
- Exception: Capitalize prepositions when used adverbially or adjectivally ("Look Up," "Turn Down") or in verb phrases.

**Proper Nouns**:

Always capitalize proper nouns regardless of context: Nix, GitHub, Anthropic, Claude, Azure, Kubernetes, Terraform, NixOS.

**Punctuation Style**:

- Use dashes appropriately for separating clauses but avoid using multiple dashes in a single sentence.
- Do not use parentheses to phrase terms. Rewrite sentences to avoid unnecessary parenthetical statements.
- Use reference-style links in Markdown files rather than inline links when possible.

### Model Names

Always use the full format: `github-copilot/claude-[model-name]`

Valid models:

- `github-copilot/claude-haiku-4.5` (execution)
- `github-copilot/claude-sonnet-4.5` (synthesis)
- `github-copilot/claude-opus-4.6` (reasoning)

### Temperature Settings

- **0.1** (deterministic): Execution, checklists, precise tasks
- **0.2** (low variance): Reviews, analysis, synthesis
- **0.3** (moderate variance): Planning, architecture, creative reasoning
- **0.5+** (high variance): Avoid—reduces reliability

### Tool Permissions

**Pattern for execution agents** (Haiku):

```yaml
tools:
    write: true
    edit: true
    bash: true
permission:
    edit: allow
    bash: allow
```

**Pattern for analysis agents** (Sonnet/Opus):

```yaml
tools:
    write: false
    edit: false
    bash: true
permission:
    edit: deny
    bash: ask
```

**Pattern for creation agents** (Sonnet):

```yaml
tools:
    write: true
    edit: true
    bash: false
permission:
    edit: ask
    bash: deny
```

## Practical Examples

### Example 1: File Extraction Agent (Haiku)

```markdown
---
name: file-extractor
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

# File Extractor

Extract specified content from files using patterns or ranges.

## Checklist

- [ ] Read the source file
- [ ] Apply filter (pattern, line range, or query)
- [ ] Format output as requested
- [ ] Write or display result

## Example

Input: "Extract errors from logs between 2PM and 3PM"
Output: Filtered log lines with timestamps
```

### Example 2: Architecture Advisor (Opus)

```markdown
---
name: architecture-advisor
mode: subagent
model: github-copilot/claude-opus-4.6
temperature: 0.3
tools:
    write: true
    edit: false
    bash: false
permission:
    edit: deny
    bash: deny
---

# Architecture Advisor

Help design systems by exploring tradeoffs and first-principles reasoning.

## When to Use

- Major refactoring or redesign decisions
- New systems with unclear requirements
- Performance, cost, or reliability concerns
- Technology selection (database, framework, pattern)

## The Approach

Ask clarifying questions first. Don't assume constraints.
Show multiple valid approaches. Explain tradeoffs explicitly.
Recommend based on stated priorities, not personal preference.
```

### Example 3: Code Quality Agent (Sonnet)

```markdown
---
name: code-quality
mode: subagent
model: github-copilot/claude-sonnet-4.5
temperature: 0.2
tools:
    write: false
    edit: false
    bash: false
permission:
    edit: deny
    bash: deny
---

# Code Quality

Review code for bugs, security, and maintainability.

## Priorities

1. **Security issues**: Always flag
2. **Memory leaks or correctness bugs**: Always flag
3. **Code clarity**: Suggest if simple fix exists
4. **Style**: Only if it blocks understanding

## Tone

Be encouraging. Flag real problems. Suggest improvements.
Accept that shipped code beats perfect code.
```

## Measuring Success

Your agents write well when:

- **Execution agents** finish tasks without asking for clarification
- **Synthesis agents** produce output you'd show a user immediately
- **Reasoning agents** reveal options you hadn't considered
- **All agents** respect their constraints (Haiku doesn't overthink, Opus doesn't oversimplify)

## File Naming Convention

All new documentation should use lowercase with dashes:

- `agent-model.md` not `AGENT_MODEL.md`
- `style-guide.md` not `STYLE_GUIDE.md`
- `task-list.md` not `TASK_LIST.md`

This applies to:

- Documentation files in `docs/`
- Configuration guides in `home-manager/programs/opencode/`
- Any new markdown files you create

## Related

- `AGENTS.md` — General agent development principles
- `docs/commands.md` — Custom commands using agents
- `docs/agent-model-optimization.md` — Model tier strategy
- Original article: [Why I Switched My AI Agent from Opus to Haiku][article]

[article]: https://thoughts.jock.pl/p/claude-model-optimization-opus-haiku-ai-agent-costs-2026
