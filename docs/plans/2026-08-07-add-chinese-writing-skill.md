# Add Chinese Writing Skill Implementation Plan

> **For Claude:** REQUIRED SUB SKILL: Use `executing-plans` to implement this plan one task at a time.

**Goal:** Install `enforce-chinese-writing-style` for Claude Code and OpenCode and add it to the conditional writing enforcement chain.

**Architecture:** Fetch the upstream repository at a fixed revision and copy only the runtime skill files into a transformed Nix output. Expose that output through shared LLM settings and load it conditionally for Chinese content.

**Technology:** Home Manager, Nix, Claude Code, and OpenCode.

## Task 1: Add the Transformed Skill Source

### Files

1. Modify: `home-manager/llm/default.nix`

### Steps

1. Add the pinned `fetchFromGitHub` source and fixed hash from the design.
2. Create a derivation that copies `SKILL.md`, `LICENSE`, `agents/`, and `references/`.
3. Replace the upstream front matter name with `enforce-chinese-writing-style`.
4. Add the transformed output to the shared skill set in alphanumeric order.
5. Run `nix fmt home-manager/llm/default.nix`.

## Task 2: Expose and Enforce the Skill

### Files

1. Modify: `home-manager/llm/skills/enforce-writing-style/SKILL.md`
2. Modify: `home-manager/programs/opencode/default.nix`

### Steps

1. Add the skill to OpenCode's explicit skill set in alphanumeric order.
2. Require `enforce-writing-style` to load it only for Chinese writing and review tasks.
3. Add a recursion exemption for the new enforcement skill.
4. Run formatting and Markdown linting.

## Task 3: Verify the Result

### Steps

1. Build the transformed skill output.
2. Confirm the front matter name.
3. Confirm that `LICENSE`, `agents/`, and `references/` exist.
4. Confirm that Claude Code and OpenCode expose the skill.
5. Run `nix flake check`.
6. Run `pre-commit run --all-files` unless the user explicitly asks to skip it.

## Task 4: Commit and Push

### Steps

1. Inspect the status, staged diff, and recent commits.
2. Load `upsert-git-commit`.
3. Create a signed Conventional Commit.
4. Push to every configured destination.
5. Confirm that the branch is current with `origin/unstable`.
