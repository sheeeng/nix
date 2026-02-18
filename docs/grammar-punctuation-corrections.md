# Grammar and Punctuation Corrections Summary

Date: February 18, 2026

## Changes Made

All agent files in `home-manager/programs/opencode/agents/` have been updated to follow proper grammar, punctuation, and use imperative verbs consistently.

### Key Corrections

#### 1. Added Periods to All Bullet Points

**Before**:

```markdown
- Code analysis and understanding
- Implementation planning
- Task decomposition
```

**After**:

```markdown
- Analyze and understand code.
- Plan implementations.
- Decompose tasks.
```

#### 2. Converted to Imperative Verbs

All list items now start with action verbs for clarity and directness.

**Before**:

```markdown
## When to Use

- Writing new documentation
- Updating guides and READMEs
- Creating user-facing content
```

**After**:

```markdown
## When to Use

- Write new documentation.
- Update guides and READMEs.
- Create user-facing content.
```

#### 3. Updated Style Guide

Added explicit guidance to `home-manager/programs/opencode/style-guide.md`:

```markdown
3. **Use imperative verbs**: Start lines with action verbs. Example: "Analyze and understand code" not "Code analysis and understanding."
```

## Files Updated

### Agent Configuration Files (All in `home-manager/programs/opencode/agents/`)

#### ✅ planner.md

- "When to Use" section now uses imperative verbs
- All bullet points end with periods
- Example: "Analyze and understand code." instead of "Code analysis and understanding"

#### ✅ builder.md

- "When to Use" section uses imperative verbs
- "Philosophy" section has periods on all items
- "When to Hand Off" section properly formatted

#### ✅ explorer.md

- "When to Use" section uses imperative verbs
- "When Not to Use" section properly formatted

#### ✅ code-reviewer.md

- "When to Use" section now uses imperative verbs
- Example: "Review pull requests." instead of "Pull request reviews"
- "Review Priorities" numbered list all end with periods

#### ✅ technical-writer.md

- "When to Use" section now uses imperative verbs
- "Documentation Principles" section all end with periods
- "Style Rules" subsections properly punctuated

#### ✅ security-auditor.md

- "When to Use" section now uses imperative verbs
- "Audit Priorities" numbered list all end with periods
- All descriptive text properly formatted

### Style Guide

#### ✅ home-manager/programs/opencode/style-guide.md

- Updated "For All Agents" section with explicit rule on imperative verbs
- Added periods to all numbered guidelines
- Clarified the pattern with examples

## Compliance Verification

All files now meet these standards:

| Standard                             | Status |
| ------------------------------------ | ------ |
| Periods at end of all bullet points  | ✅     |
| Imperative verbs starting list items | ✅     |
| Chicago Manual of Style titles       | ✅     |
| Active voice usage                   | ✅     |
| Proper grammar throughout            | ✅     |
| No unnecessary parentheses           | ✅     |
| Consistent formatting                | ✅     |

## Examples of Correct Format

### Planner Agent (What This Agent Does)

```markdown
- Explore codebase structure.
- Analyze existing code patterns.
- Create implementation plans.
- Suggest refactorings without applying them.
- Break complex tasks into steps.
```

### Builder Agent (When to Use)

```markdown
Invoke this agent to:

- Implement features.
- Fix and debug bugs.
- Refactor code.
- Create new files and modules.
- Perform work requiring write access.
```

### Code Reviewer Agent (When to Use)

```markdown
- Review pull requests.
- Check code quality before merge.
- Provide learning-oriented feedback.
- Validate architectural patterns.
```

### Security Auditor Agent (When to Use)

```markdown
- Audit before deployment or public release.
- Review when handling sensitive data.
- Inspect code during security-critical path review.
- Scan dependencies for vulnerabilities.
- Validate authentication or encryption features.
```

## Rule Reference

**Imperative Verb Pattern**: Start each line with an action verb in the base form:

- ✅ "Analyze code" (imperative)
- ❌ "Code analysis" (noun phrase)
- ✅ "Write documentation" (imperative)
- ❌ "Documentation writing" (noun phrase)

**Punctuation Pattern**: Each bullet point is a sentence fragment ending with a period:

- ✅ "Implement features." (sentence fragment)
- ✅ "Fix and debug bugs." (sentence fragment)
- ❌ "Feature implementation" (no period)

**When to Use Pattern**: Introduce the list with context, then use imperative verbs:

- ✅ "Invoke this agent to:" + imperative bullets
- ✅ "Use this agent to:" + imperative bullets
- ❌ "When to use:" + noun phrases (old style)

---

**Status**: All corrections completed and verified.
**Next Step**: These files are ready for commit with proper grammar and style compliance.
