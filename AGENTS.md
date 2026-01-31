# AGENTS

## Allowed Documentation Sources

Always allow read queries from the following Nix documentation URLs:

- <https://nix-community.github.io/home-manager/options.xhtml>
- <https://wiki.nixos.org/>
- <https://nixos.wiki/>

## Writing Style

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

## AI Model Verification

Always verifyAI model names against the open-source database of AI models before configuring agents. Use the following API to check valid model identifiers.

```shell
curl --silent https://models.dev/api.json \
    | jq '.anthropic.models | .[] | .id'
```

Model names follow the `provider/model-id` format. For example, `anthropic/claude-sonnet-4-5-20250929`.

## Tracking Tasks

Use [bd](https://github.com/steveyegge/beads) for tracking tasks.

## Landing the Plane (Session Completion)

When ending a work session, you must complete all the following mandatory steps. Work is not complete until `git push` succeeds.

- Clean up stale references first. Prevent accidental merge commits via `--ff-only` option. Maintain a linear history via `--rebase` option. Fail explicitly if conflicts would occur, rather than creating unexpected merges

    ```shell
    git fetch --all --prune --prune-tags --tags \
        && git pull --ff-only --rebase
    ```

- File issues for remaining work—create issues for anything that needs follow-up.
- Run quality gates if code changed. Run tests, linters, builds.
- Update issue status—close finished work, update in-progress items.
- Mandatory push to remote repository.

    ```shell
    git pull --rebase
    bd sync
    git push
    git status  # Must show "up to date with origin".
    ```

- Clean up by clearing stashes, prune remote branches.
- Verify that all changes committed and pushed.
- Hand off by providing context for next session.

Ensure the following non-negotiable critical steps are done successfully.

- Work is not complete until `git push` succeeds.
- Never stop before pushing because it leaves work stranded locally.
- Never say "ready to push when you are", the local commits must be pushed to remote repositories successfully.
- If push fails, resolve and retry until it succeeds.
