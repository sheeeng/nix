# Agent Updates Summary

This document summarizes the changes made to align agents with the style from [Why I Switched My AI Agent from Opus to Haiku][article] by Paweł Józefiak.

## Files Modified

### Agent Configurations

All agent markdown files have been updated with clearer, more actionable instructions following the article's philosophy:

#### 1. **planner.md** (Haiku — Execution Tier)

- Removed verbose explanations
- Added clear "What This Agent Does" section
- Added "When to Use" and "When Not to Use" sections
- Removed commented-out model verification code
- Temperature: 0.1 (deterministic)

#### 2. **builder.md** (Sonnet — Synthesis Tier)

- Simplified description
- Added "Philosophy" section emphasizing execution speed
- Added "When to Hand Off" guidance
- Removed commented-out code
- Temperature: updated to 0.2 (slightly more variance for design choices)

#### 3. **explorer.md** (Haiku — Execution Tier)

- Clarified as "Fast codebase exploration and search"
- Removed jargon-heavy language
- Added explicit expectations for output
- Added "When Not to Use" guidance
- Temperature: 0.1 (deterministic)

#### 4. **code-reviewer.md** (Sonnet — Synthesis Tier)

- Reframed review priorities pragmatically
- Emphasized "good shipped beats perfect unshipped"
- Added explicit tone guidelines
- Removed bulleted checklist format in favor of narrative
- Temperature: updated to 0.2
- Expanded philosophy section

#### 5. **technical-writer.md** (Sonnet — Synthesis Tier)

- Integrated Chicago Manual of Style guidance more clearly
- Simplified principles section
- Added practical code example guidance
- Made documentation style more approachable
- Temperature: updated to 0.2
- Removed redundant detailed style rules (moved to style-guide.md)

### New Documentation Files

#### 1. **home-manager/programs/opencode/style-guide.md**

Comprehensive guide for writing effective agent instructions:

- Core philosophy section
- Writing patterns by agent tier (Haiku, Sonnet, Opus)
- Cross-cutting guidelines
- Grammar and punctuation standards
- Model naming conventions
- Temperature settings guide
- Tool permission patterns
- Practical examples for each tier
- Success metrics

#### 2. **docs/agent-model-optimization.md**

Strategic analysis document covering:

- Current agent configuration review
- Three-tier model strategy (Haiku 95%, Sonnet 4%, Opus 1%)
- Recommended configuration changes
- Agent model assignments
- New specialized agents to consider
- Implementation strategy (4 phases)
- Cost-benefit analysis
- Key principles

## File Naming Convention

All new documentation follows lowercase-with-dash convention:

- ✓ `style-guide.md`
- ✓ `agent-model-optimization.md`
- ✗ ~~`STYLE_GUIDE.md`~~
- ✗ ~~`AGENT_MODEL_OPTIMIZATION.md`~~

Apply this to any future documentation files you create.

## Key Changes in Agent Philosophy

### Haiku Agents (Execution)

**Before**: Verbose, over-explained
**After**: Imperative, direct, focused

```markdown
# Before

You are a fast, read-only agent for exploring codebases.
You cannot modify files. Use this when you need to quickly
find files by patterns, search code for keywords, or answer
questions about the codebase.

# After

Fast, read-only agent for understanding codebases. Find files,
search patterns, and answer questions about code structure
without modifications.
```

### Sonnet Agents (Synthesis)

**Before**: Generic best-practices lists
**After**: Contextual reasoning with pragmatism

```markdown
# Before

- Review for potential bugs and edge cases.
- Ensure code follows best practices.
- Suggest improvements for readability and performance.

# After

Good shipped beats perfect unshipped. Flag genuine problems.
Accept pragmatism.

**Review Priorities**

1. Security: Flag all vulnerabilities immediately
2. Correctness: Catch memory leaks, edge cases
3. Clarity: Suggest if it unblocks understanding
4. Style: Only if it obscures intent
```

### Temperature Settings

Updated for more appropriate behavior:

- **Haiku agents**: 0.1 (deterministic execution)
- **Sonnet agents**: 0.2 (balanced synthesis)
- **Opus agents**: 0.3 (higher reasoning variance)

## How to Use These Updates

### For Users

Reference `style-guide.md` when:

- Creating new agents
- Writing agent instructions
- Setting model selections
- Configuring tool permissions

Use `agent-model-optimization.md` when:

- Planning cost optimization
- Deciding which agent to invoke
- Understanding model tier tradeoffs
- Reviewing current configuration

### For Developers/Contributors

- Follow the style-guide patterns when adding new agents
- Use lowercase-dash naming for new documentation
- Reference the three-tier strategy (95/4/1 distribution)
- Keep Haiku focused on execution, Sonnet on synthesis, Opus on reasoning

## Implementation Strategy

### Phase 1: ✅ Model Verification

- Verified available models via models.dev/api.json
- Confirmed agent model assignments

### Phase 2: ✅ Agent Configuration

- Updated existing agent configurations
- Created specialized agent templates in style-guide.md
- Documented model selections per agent

### Phase 3: ⏳ Testing & Validation (Next Steps)

- Test agents with designated models
- Measure token usage per agent type
- Validate output quality

### Phase 4: ⏳ Documentation (Next Steps)

- Add agent selection guide to main AGENTS.md
- Create cost tracking metrics
- Document when to invoke which agent

## References

- Original article: [Why I Switched My AI Agent from Opus to Haiku][article]
- Project style guide: `AGENTS.md`
- New agent style guide: `home-manager/programs/opencode/style-guide.md`

[article]: https://thoughts.jock.pl/p/claude-model-optimization-opus-haiku-ai-agent-costs-2026
