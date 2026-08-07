# Add Chinese Writing Skill Design

## Goal

Install the Chinese technical writing skill for Claude Code and OpenCode under the local name `enforce-chinese-writing-style`.

## Source

Fetch `Fenng/Tech-Doc-Style-Chinese` at revision `a6f5b6064b92cac113e1277e5fbd266042e20577` with fixed hash `sha256-4DFY9B5UERlwv883bjRbABYNdyZ12BWyDtGKanFQsEw=`.

## Transformation

Create a Nix derivation that copies these upstream paths:

1. `SKILL.md`
2. `LICENSE`
3. `agents/`
4. `references/`

Replace the front matter name `tech-doc-style-chinese` with `enforce-chinese-writing-style`. Do not copy the Python checker, tests, or repository documents.

## Integration

Expose the transformed skill through the shared LLM skill set. Claude Code consumes the complete shared set. Add the skill to OpenCode's explicit skill set.

Update `enforce-writing-style` to load `enforce-chinese-writing-style` only for Chinese writing and review tasks. Preserve the current loading rules for `enforce-asd-ste100` and `forbid-llm-slop`. Prevent recursive loading among enforcement skills.

## Verification

Build the transformed skill and confirm that its front matter uses the local name. Confirm that `LICENSE`, `agents/`, and `references/` are present. Evaluate the shared and OpenCode skill sets, then run the repository quality gates.

## References

1. [Chinese Technical Documentation Style][chinese-technical-documentation-style]

[chinese-technical-documentation-style]: https://github.com/Fenng/Tech-Doc-Style-Chinese
