# Share Codex Resources Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task by task.

**Goal:** Configure Codex to consume shared instructions and skills from `home-manager/llm`, and add concise instructions for manual use in ChatGPT.

**Architecture:** A new Home Manager module imports the existing common LLM settings and renders only Codex compatible resources below `~/.codex`. Codex keeps mutable state in that directory, while ChatGPT receives a separate concise instruction document that the user copies into account settings.

**Tech Stack:** Nix, Home Manager, Markdown, Codex CLI.

---

## Task 1: Add the ChatGPT Instruction Document

**Files:**

- Create: `home-manager/llm/chatgpt-custom-instructions.md`

### Step 1: Write Concise Instructions ✅

Create a short instruction document derived from `home-manager/llm/context.md`. Retain writing style, secure development, concise code quality, and verification rules. Exclude local skill loading, agent dispatch, command permission syntax, repository specific session completion, and features that ChatGPT cannot execute.

### Step 2: Check the Document ✅

Run:

```shell
pre-commit run markdownlint --files home-manager/llm/chatgpt-custom-instructions.md
```

Expected: The Markdown lint check passes.

## Task 2: Add the Codex Home Manager Module

**Files:**

- Create: `home-manager/programs/codex.nix`
- Reference: `home-manager/llm/default.nix`
- Reference: `home-manager/programs/claude-code.nix`

### Step 1: Add a Failing Evaluation Assertion ✅

Evaluate an affected Home Manager configuration before adding the module and confirm that it does not declare `.codex/AGENTS.md` or `.codex/skills`.

Run the applicable configuration query discovered from `flake.nix` with `nix eval`.

Expected: The requested Codex file attribute is absent.

### Step 2: Implement the Module ✅

Import `../llm/default.nix` with `pkgs`, `../llm`, and `inputs.matt-pocock-skills`. Set:

```nix
home.sessionVariables.CODEX_HOME = "${config.home.homeDirectory}/.codex";
home.file.".codex/AGENTS.md".source = commonLlmSettings.context;
```

Map each `commonLlmSettings.skills` entry to `.codex/skills/<name>`. Preserve directory skills recursively and render flat source files as `<name>/SKILL.md`, matching Codex skill discovery requirements. Do not link agents or commands.

### Step 3: Format the Module ✅

Run:

```shell
nix fmt home-manager/programs/codex.nix
```

Expected: The formatter exits successfully.

### Step 4: Evaluate Generated Resources ✅

Run the applicable `nix eval` queries for `.codex/AGENTS.md`, at least one local skill, and at least one fetched skill.

Expected: Each attribute resolves to a Home Manager file declaration with the intended source.

## Task 3: Verify the Complete Change

**Files:**

- Verify: `docs/plans/2026-08-08-share-codex-resources-design.md`
- Verify: `docs/plans/2026-08-08-share-codex-resources.md`
- Verify: `home-manager/llm/chatgpt-custom-instructions.md`
- Verify: `home-manager/programs/codex.nix`

### Step 1: Inspect the Working Tree

Run:

```shell
git status --short
git diff -- docs/plans/2026-08-08-share-codex-resources-design.md docs/plans/2026-08-08-share-codex-resources.md home-manager/llm/chatgpt-custom-instructions.md home-manager/programs/codex.nix
```

Expected: Only intended files appear in this change. Existing modifications to `flake.lock` and `home-manager/programs/vscode.nix` remain untouched.

### Step 2: Run the Flake Check

Run:

```shell
nix flake check
```

Expected: All checks pass.

### Step 3: Run All Repository Hooks

Run:

```shell
pre-commit run --all-files
```

Expected: All hooks pass.

### Step 4: Report Activation Instructions

Report the existing repository rebuild command from `docs/commands.md`. Explain that Codex CLI and the Codex application will use `~/.codex` after activation. Explain that the user must copy `home-manager/llm/chatgpt-custom-instructions.md` into ChatGPT custom instructions manually.
