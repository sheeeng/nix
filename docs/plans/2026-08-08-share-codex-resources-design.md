# Share Codex Resources Design

## Goal

Use `home-manager/llm` as the source for Codex instructions and skills while keeping mutable Codex state outside the repository. Maintain concise instructions for the separate ChatGPT desktop application as a manual account setting.

## Codex Integration

Add a Home Manager module for Codex. The module imports the common LLM settings, sets `CODEX_HOME` to `~/.codex`, renders the shared context as `~/.codex/AGENTS.md`, and renders each shared skill below `~/.codex/skills`.

Codex authentication, history, logs, and other mutable state remain in `~/.codex`. The repository supplies only declarative resources.

Import the Codex module from each applicable Home Manager profile. Keep package installation in the common LLM settings to avoid duplicate package declarations.

## ChatGPT Instructions

Add `home-manager/llm/chatgpt-custom-instructions.md` with a concise subset of the shared rules. Exclude tool specific behavior, skill loading rules, agent definitions, and command permissions that the ChatGPT desktop application cannot use.

ChatGPT does not read local instruction files. Copy this file into the ChatGPT custom instructions account setting when its content changes.

## Alternatives

Do not set `CODEX_HOME` to the repository directory. Codex writes private and mutable state under `CODEX_HOME`.

Do not link the complete shared directory into `~/.codex`. Shared agents and commands use formats that Codex does not consume directly.

Link only the resources that Codex supports. This keeps one declarative source without mixing incompatible formats or mutable state.

## Verification

Format the changed Nix and Markdown files. Evaluate the affected Home Manager configurations and run the repository quality gates. Confirm that evaluation produces the Codex instruction and skill files without changing the active system generation.
