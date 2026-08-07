# Add Writing and Diagram Skills Design

## Goal

Add two reproducible upstream skills to Claude Code and OpenCode, rename them for clear local intent, and enforce the writing skill chain globally.

## Sources

Use pinned Git revisions and fixed hashes for both repositories:

1. Rename `petergyang/no-ai-slop` to `forbid-llm-slop`.
2. Rename `cathrynlavery/diagram-design` to `design-diagram`.

Preserve each complete skill directory. `forbid-llm-slop` requires `eval.md` during editing. `design-diagram` references its `assets/` and `references/` directories at runtime.

## Skill Transformation

Create one Nix derivation per upstream skill. Copy the required source directory into the Nix store, replace only the front matter `name` value in `SKILL.md`, and retain all supporting files. The local installation name and front matter name will therefore agree without maintaining a copied fork.

Expose both transformed directories through `commonLlmSettings.skills`. Claude Code already consumes that complete attribute set. Add both names to the explicit OpenCode skill selection so both agents receive identical installations.

## Enforcement Chain

Add a global skill invocation rule to `home-manager/llm/context.md`:

1. Rename the local `apply-writing-style` skill to `enforce-writing-style`.
2. Load `enforce-writing-style` before every other skill.
3. When loaded, `enforce-writing-style` loads `forbid-llm-slop` before continuing.
4. When writing technical documentation or instructions, `enforce-writing-style` also loads `enforce-asd-ste100`.
5. Exempt all enforcement skills from loading themselves again.
6. Load the originally requested skill after the enforcement chain.

Add the second rule directly to the renamed local `enforce-writing-style` skill. This keeps writing policy in one place and avoids modifying every imported skill.

## Verification

Evaluate the Home Manager configuration and confirm that both programs expose `forbid-llm-slop` and `design-diagram`. Inspect the transformed `SKILL.md` files to confirm their front matter names. Confirm that `eval.md`, `assets/`, and `references/` remain present.

## References

1. [No AI Slop skill][no-ai-slop]
2. [Diagram Design skill][diagram-design]

[diagram-design]: https://github.com/cathrynlavery/diagram-design/tree/main/skills/diagram-design
[no-ai-slop]: https://github.com/petergyang/no-ai-slop/tree/main/skills/no-ai-slop
