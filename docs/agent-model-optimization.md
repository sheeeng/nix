# Agent Model Optimization Strategy

Based on the "Claude Model Optimization" article by Paweł Józefiak, this document outlines a strategy for optimizing model selection across agents in your `home-manager/programs/opencode/` configuration.

## Current State

Your opencode configuration currently has:

- **Default agent**: planner (using `claude-haiku-4.5`)
- **Model configurations**:
    - `model`: claude-sonnet-4.5 (default)
    - `small_model`: claude-haiku-4.5

### Existing Agent Models

| Agent            | Type     | Model      | Tools Enabled     | Use Case              |
| ---------------- | -------- | ---------- | ----------------- | --------------------- |
| planner          | primary  | haiku-4.5  | None (read-only)  | Planning and analysis |
| builder          | primary  | sonnet-4.5 | write, edit, bash | Development work      |
| explorer         | subagent | (inherits) | Unknown           | Codebase exploration  |
| code-reviewer    | subagent | (inherits) | Unknown           | Code review           |
| technical-writer | subagent | (inherits) | Unknown           | Documentation         |
| security-auditor | subagent | sonnet-4.5 | bash (ask)        | Security audits       |

## The Three-Tier Model Strategy

The article recommends this approach:

### Tier 1: Haiku (95% of Tasks) — Execution & Automation

**Use for:**

- File operations and data extraction
- Following structured checklists
- Running scripts with specific parameters
- Formatting and sending messages
- Scheduled automation tasks
- Data processing and transformation
- API calls with predefined patterns

**Why it works:**

- Cost-effective for high-volume work
- Doesn't overthink instructions
- Excellent at precision execution
- Reliable for deterministic tasks

### Tier 2: Sonnet (4% of Tasks) — Synthesis & User Interaction

**Use for:**

- User-facing interactions
- Content creation from scratch
- Research synthesis
- Feature building
- Complex debugging
- Report generation with analysis

**Why it works:**

- Balances quality and cost
- Handles nuance and context
- Good for creative/interactive work
- Suitable for end-user deliverables

### Tier 3: Opus (1% of Tasks) — Complex Reasoning

**Use for:**

- Architectural decisions
- Complex project planning
- Debugging cascading failures
- Coordinating multiple agents
- Heavy coding sessions with design choices

**Why it works:**

- Deepest reasoning capability
- Handles novel problems
- Best for first-principles thinking
- Worth the premium cost for truly complex work

## Recommended Configuration Changes

### 1. Update Default Model Priority

**Current state:**

```nix
model = "github-copilot/claude-sonnet-4.5";
small_model = "github-copilot/claude-haiku-4.5";
```

**Recommended:**

```nix
model = "github-copilot/claude-opus-4.6";      # Complex only
medium_model = "github-copilot/claude-sonnet-4.5";  # Synthesis
default_model = "github-copilot/claude-haiku-4.5";  # Execution (if supported)
```

### 2. Reassign Agent Models

#### Planner Agent (Primary)

- **Current**: haiku-4.5 ✓ (Correct)
- **Recommendation**: Keep haiku for analysis-only scenarios
- **Alternative**: Add variant using sonnet for interactive planning

#### Builder Agent (Primary)

- **Current**: sonnet-4.5 ✓ (Good)
- **Recommendation**: Keep sonnet for development
- **Alternative**: Add execution-focused variant that uses haiku for file operations

#### Explorer Agent (Subagent)

- **Current**: Inherits default
- **Recommendation**: Use haiku-4.5 for codebase exploration (high-volume file reads)
- **Model**: `github-copilot/claude-haiku-4.5`

#### Code-Reviewer Agent (Subagent)

- **Current**: Inherits default
- **Recommendation**: Use sonnet-4.5 (requires nuanced analysis)
- **Model**: `github-copilot/claude-sonnet-4.5`

#### Technical-Writer Agent (Subagent)

- **Current**: Inherits default
- **Recommendation**: Use sonnet-4.5 (content creation requires quality)
- **Model**: `github-copilot/claude-sonnet-4.5`

#### Security-Auditor Agent (Subagent)

- **Current**: sonnet-4.5 ✓ (Good)
- **Recommendation**: Keep sonnet (security requires careful analysis)
- **Model**: `github-copilot/claude-sonnet-4.5`

### 3. Consider New Specialized Agents

Based on the article's approach, consider creating:

#### Executor Agent (New Subagent)

- **Purpose**: High-volume structured automation
- **Model**: haiku-4.5
- **Tools**: write, edit, bash (all allowed)
- **Use case**: Automation scripts, data processing, file bulk operations
- **Temperature**: 0.1 (deterministic)

#### Architect Agent (New Subagent)

- **Purpose**: Complex system design and planning
- **Model**: opus-4.6
- **Tools**: write, edit (allow), bash (ask)
- **Use case**: Major refactoring, system redesign, complex debugging
- **Temperature**: 0.3 (reasoning-focused)

#### Debugger Agent (New Subagent)

- **Purpose**: Issue investigation and resolution
- **Model**: sonnet-4.5 (could use opus for complex cases)
- **Tools**: write, edit, bash (all allowed)
- **Use case**: Bug fixes, error analysis, optimization

## Implementation Strategy

### Phase 1: Model Verification

1. Verify available models via models.dev/api.json
2. Confirm `opus-4.6` availability in GitHub Copilot
3. Document pricing tiers for cost tracking

### Phase 2: Agent Configuration

1. Update existing agent configurations with explicit models
2. Create markdown files for new specialized agents
3. Update `default.nix` to reference all agents

### Phase 3: Testing & Validation

1. Test each agent with its designated model
2. Measure token usage per agent type
3. Compare costs before/after optimization
4. Verify quality doesn't degrade for execution tasks

### Phase 4: Documentation

1. Create context-selection guide for users
2. Document when to invoke which agent
3. Add examples in each agent's markdown
4. Track cost savings metrics

## Cost-Benefit Analysis

### Expected Token Usage Distribution

- **Haiku (95% of work)**: Exploration, execution, file operations
    - Cost: ~$0.80/million tokens (input)
    - High volume compensated by low unit cost

- **Sonnet (4% of work)**: Feature work, reviews, content
    - Cost: ~$3/million tokens (input)
    - Medium volume, quality-focused

- **Opus (1% of work)**: Architecture, complex planning
    - Cost: ~$15/million tokens (input)
    - Low volume, premium quality

### Estimated Monthly Savings

If currently running 70-80% weekly usage on Sonnet default:

- **Current**: Mostly Sonnet across all tasks
- **Optimized**: 95% Haiku, 4% Sonnet, 1% Opus
- **Potential savings**: 40-50% token cost while maintaining/improving quality

## Key Principles to Follow

1. **Model matching**: Use the right model for the task type, not the "best" model
2. **Execution priority**: Most agent work is deterministic execution, not creative reasoning
3. **Cost awareness**: Track which agents consume the most tokens
4. **Quality gates**: Ensure execution-tier tasks still meet quality standards
5. **Gradual adoption**: Test new agents in subagent mode first
6. **Context clarity**: Document which agent to invoke for specific scenarios

## Related Files to Update

- `home-manager/programs/opencode/default.nix`: Agent model assignments
- `home-manager/programs/opencode/agents/*.md`: Individual agent configurations
- `AGENTS.md`: Add model selection guidance
- `docs/commands.md`: Document context-aware agent invocation

## Reference

Original article: https://thoughts.jock.pl/p/claude-model-optimization-opus-haiku-ai-agent-costs-2026

Key insights:

- Haiku "doesn't overthink" — perfect for automation
- Sonnet balances quality and cost for user-facing work
- Opus reserved for true complexity
- Volume of execution tasks often exceeds creative tasks by 95:5 ratio
- Testing revealed no perceived quality loss for appropriate tasks
