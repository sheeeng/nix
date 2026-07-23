---
name: apply-writing-style
description: Apply consistent writing style to comments, documentation, commit messages, and prose, covering Chicago Manual of Style capitalization, grammar, punctuation, and GNU-style command formatting. Use whenever writing or editing comments, documentation, README files, or any user-facing text, and whenever another skill asks to load writing-style guidelines before generating prose.
license: Apache-2.0 OR MIT
---

# Writing Style

## What This Skill Does

- Apply Chicago Manual of Style conventions to all comments and documentation.
- Enforce correct grammar and proper punctuation throughout code documentation.
- Use title case for headings and sentence case for regular text.
- Use imperative verbs for instructions and indicative verbs for explanatory comments.
- Prefer GNU-style explicit long options in shell commands.

### Writing Style

- Ensure adherence to Chicago Manual of Style by maintaining correct grammar and using proper punctuation in all comments and documentation.
- Follow Chicago Manual of Style capitalization conventions.
    - Use title case, or headline style, for headings, titles, and section names.
    - Use sentence case, or sentence style, for regular comments, descriptions, and explanatory text.
    - Always capitalize proper nouns regardless of context.
- Apply accurate grammar and proper punctuation throughout code documentation.
- For title case, apply these Chicago Manual of Style rules.
    - Always capitalize the first and last words.
    - Capitalize all nouns, pronouns, verbs, adjectives, and adverbs.
    - Lowercase articles such as a, an, the.
    - Lowercase coordinating conjunctions such as and, but, or, for, nor, so, yet.
    - Lowercase prepositions such as at, by, for, from, in, into, of, on, to, with, between, through.
    - Lowercase "to" in infinitives such as to run, to see, to build.
    - Exception: Capitalize prepositions when used adverbially or adjectivally, such as "Look Up" and "Turn Down," or in verb phrases.
    - Do not use normal dashes `-` or em dashes `—`.
    - Do not use parentheses `()` to phrase terms.
    - Do not use abbreviated or slang terms; use full terms. Example:
        - Do not use `can't`; use `cannot`.
        - Do not use `config`; use `configuration`.
        - Do not use `docs`; use `documents`.
        - Do not use `info`; use `information`.
- Use indicative or imperative verbs. Example:
    - Indicative: "This function installs the package.", "The script configures the settings.", "The process runs the command."
    - Imperative: "Install the package.", "Configure the settings.", "Run the command."
    - Prefer imperative for instructions and documentation.
    - Prefer indicative for comments that explain what code does.

### Writing Commands

- Use GNU-style explicit long options over abbreviated ones. Examples:
    - Use `date --universal +"%Y-%m-%dT%H:%M:%SZ"` over `date -u +"%Y-%m-%dT%H:%M:%SZ"`.
    - Use `ls --all --list --numeric-uid-gid` over `ls -sln`.
    - Use `set --option errexit` over `set -e` in shell scripts.
    - Use `git commit --message` over `git commit -m`.
