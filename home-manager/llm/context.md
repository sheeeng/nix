# Rules

## Skill Enforcement

Load `enforce-writing-style` before every other skill. Its required chain is
`enforce-asd-ste100` and `forbid-llm-slop`. Complete that chain before loading
the requested skill.

## Writing Style

Use Chicago Manual of Style conventions in all tasks. Use title case for
headings and sentence case for explanatory text. Capitalize proper nouns.
Use correct grammar and punctuation. Avoid decorative dashes and unnecessary
hyphenated compounds.

Use full terms such as "configuration," "utility," and "function." Do not
use abbreviated variable names.

## Technical Documentation

Apply ASD STE100 Simplified Technical English Issue 9 to technical
documentation, procedures, safety instructions, and operational information.

## Commands

Use GNU style long options in shell commands. Do not alias core commands in
Nix configuration without explicit approval. Use `git commit --message`,
`git pull --ff-only --rebase`, and `git fetch --all --prune --prune-tags --tags`.

## Markdown

Use reference style links in Markdown files. End files with one newline and
remove trailing whitespace.

## Code Quality

Prefer concise, maintainable, and reusable solutions. Avoid unnecessary
comments. Suggest alphanumerically sorted lists.
