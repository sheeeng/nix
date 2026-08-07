# Add Writing and Diagram Skills Implementation Plan

> **For Claude:** REQUIRED SUB SKILL: Use `executing-plans` to implement this plan one task at a time.

**Goal:** Install `forbid-llm-slop` and `design-diagram` for Claude Code and OpenCode with a globally enforced writing skill chain.

**Architecture:** Fetch each upstream repository at a fixed revision, transform the selected skill directory in a Nix derivation, and expose the result through the shared LLM settings. Enforce skill loading order through the global context and the renamed local `enforce-writing-style` skill.

**Technology:** Home Manager, Nix, Claude Code, and OpenCode.

## Task 1: Add the Pinned Skill Sources, Completed

### Files

1. Modify: `home-manager/llm/default.nix`

### Steps

1. Add a pinned `fetchFromGitHub` source for `petergyang/no-ai-slop` at revision `d30eddb9e04562234f2070b5ee63ca4649d9a05e` with hash `sha256-qpxftQLQAKDnyzPVtidgKACGyCaX2HEW4I/NQuZFOIE=`.
2. Add a pinned `fetchFromGitHub` source for `cathrynlavery/diagram-design` at revision `a157f7616473d966d6f433cf0b4d4f1880603504` with hash `sha256-tJVDM9Ujeu4mXLB6SHk62zxIJ0m+VqJu6xX7fJ8IwAo=`.
3. Add derivations that copy the selected skill directories and replace only their front matter names.
4. Add `design-diagram` and `forbid-llm-slop` to the shared `skills` attribute set in alphanumeric order.
5. Run `nix fmt home-manager/llm/default.nix`.

Expected: the shared settings expose both transformed skill directories.

## Task 2: Expose Both Skills to OpenCode, Completed

### Files

1. Modify: `home-manager/programs/opencode/default.nix`

### Steps

1. Add `design-diagram = commonLlmSettings.skills.design-diagram;` to the explicit OpenCode skill set.
2. Add `forbid-llm-slop = commonLlmSettings.skills.forbid-llm-slop;` to the explicit OpenCode skill set.
3. Keep the skill list alphanumerically sorted.
4. Run `nix fmt home-manager/programs/opencode/default.nix`.

Expected: OpenCode installs both skills, while Claude Code receives them through `commonLlmSettings.skills` without another program specific change.

## Task 3: Enforce the Skill Loading Chain, Completed

### Files

1. Modify: `home-manager/llm/context.md`
2. Move: `home-manager/llm/skills/apply-writing-style/` to `home-manager/llm/skills/enforce-writing-style/`

### Steps

1. Rename the local skill directory and change its front matter name to `enforce-writing-style`.
2. Update its description to use the new name and enforcement role.
3. Add a global rule requiring `enforce-writing-style` before every other skill except `enforce-writing-style` itself.
4. State that the originally requested skill loads only after the writing enforcement chain completes.
5. Add a rule to `enforce-writing-style` requiring `forbid-llm-slop` before continuing, except when `forbid-llm-slop` is already active.
6. State that `forbid-llm-slop` must not load itself or reload `enforce-writing-style`.
7. Create `enforce-asd-ste100` with controlled English rules for technical documentation and instructions.
8. Require `enforce-writing-style` to load `enforce-asd-ste100` for applicable writing.
9. Update every repository reference from `apply-writing-style` to `enforce-writing-style`.
10. Run Markdown linting on both files.

Expected: the instructions define a finite loading chain with no recursion.

## Task 4: Verify the Home Manager Result, Completed

### Files

1. Read: transformed skill outputs.
2. Read: evaluated Home Manager program settings.

### Steps

1. Evaluate the shared skill attribute names.
2. Confirm the transformed No AI Slop `SKILL.md` contains `name: forbid-llm-slop` and retains `eval.md`.
3. Confirm the transformed Diagram Design `SKILL.md` contains `name: design-diagram` and retains `assets/` and `references/`.
4. Confirm Claude Code and OpenCode each expose both skills.
5. Run `nix flake check`.
6. Run `pre-commit run --all-files`.

Expected: all evaluations and quality gates succeed.

## Task 5: Commit and Push, Completed

### Files

1. Stage only the files changed by this plan.

### Steps

1. Inspect `git status`, `git diff`, and recent commits.
2. Load the `upsert-git-commit` skill.
3. Create a signed Conventional Commit.
4. Push to every configured destination.
5. Confirm `git status` reports that `unstable` is current with `origin/unstable`.

Expected: the implementation is committed and available from every repository host.
