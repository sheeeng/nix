# Rules

## Writing Style

MANDATORY: Adhere to Chicago Manual of Style in all tasks.

- Ensure adherence to Chicago Manual of Style by maintaining correct grammar and using proper punctuation in all comments and documentation.
- Follow Chicago Manual of Style capitalization conventions.
    - Use title case (headline style) for headings, titles, and section names.
    - Use sentence case (sentence style) for regular comments, descriptions, and explanatory text.
    - Always capitalize proper nouns regardless of context.
- Apply accurate grammar and proper punctuation throughout code documentation.
- For title case, apply these Chicago Manual of Style rules.
    - Always capitalize the first and last words.
    - Capitalize all nouns, pronouns, verbs, adjectives, and adverbs.
    - Lowercase articles such as a, an, the.
    - Lowercase coordinating conjunctions such as and, but, or, for, nor, so, yet.
    - Lowercase prepositions such as at, by, for, from, in, into, of, on, to, with, between, through.
    - Lowercase "to" in infinitives such as to run, to see, to build.
    - Exception: Capitalize prepositions when used adverbially or adjectivally ("Look Up," "Turn Down") or in verb phrases.
    - Don't use parenthesis `()` to phrase terms.
    - Don't use config term, use configuration.

### Dashes and Hyphens

- Never use em dashes `—` or en dashes `–` anywhere, in any output.
- Do not use a hyphen as a decorative connector to set off a phrase or clause the way a dash would. For example, do not write "it works fine - most of the time".
- Do not invent ad hoc hyphenated compounds. Prefer separate words or a rephrase. For example, write "module level logger" over "module-level logger", and write "control flow" over "control-flow".
- Allow hyphens only in these two cases.
    - Use standard hyphenated words as they appear in a dictionary, such as well-being, e-commerce, self-esteem, and long-term.
    - Use proper names, identifiers, and technical tokens that are literally spelled with a hyphen, such as open source project or package names, command line flags, and file names. Examples include scikit-learn, create-react-app, styled-components, ruff-pre-commit, and --output-format.
- To replace a dash used for emphasis or an aside, use a comma, a colon, or a separate sentence instead.
- Apply this rule to everything: prose, code comments, commit messages, pull request titles and descriptions, and documentation.

## Commands

MANDATORY: Use GNU-style explicit long options over abbreviated ones in all commands.

- Use `date --universal +"%Y-%m-%dT%H:%M:%SZ"` over `date -u +"%Y-%m-%dT%H:%M:%SZ"`.
- Use `ls --all --list --numeric-uid-gid` over `ls -sln`.
- Use `set --option errexit` over `set -e` in shell scripts.
- Use `git commit --message` over `git commit -m`.
- Use `echo --no-newline` over `echo -n`.
- Use `wc --chars` over `wc -c`.
- Use `git fetch --all --prune --prune-tags --tags` over `git fetch -apt`.
- Use `git pull --ff-only --rebase` over `git pull -r`.
- Do not alias core commands in Nix configuration without explicit user approval.
- Examples: do not alias `ls` to `eza` or `cat` to `bat` unless the user asks for it.

## Terminology

Do not use slang shorthand words.

- Avoid "config", use "configuration".
- Avoid "util", use "utility".
- Avoid "func", use "function".
- Avoid abbreviated variable names like `CONFIG_DIR`, use `CONFIGURATION_DIRECTORY`.
- Avoid abbreviated names like `customConfigContent`, use `customConfigurationContent`.

## Markdown

Use reference-style links in all Markdown files.

## Code Quality

- Suggest concise, "Don't Repeat Yourself" solutions.
- Avoid unnecessary comments whenever possible.
- Use correct punctuation for comments.
- Keep comments if links are provided.
- Discard all empty trailing whitespace from every file.
- Makes sure files end in a newline and only a newline.
- Suggest modifications to lists that are alphanumerically sorted in ascending order.
