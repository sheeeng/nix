---
name: pull-request
description: Create or update pull request titles and descriptions from feature-branch commits, with automatic nixpkgs-convention detection. Use whenever the user wants to open, create, or update a pull request, or asks to "make a PR", "update the PR description", or prepare a branch for review, especially after new local modifications. Previews the title and description and requires explicit confirmation before running gh pr create or gh pr edit.
license: Apache-2.0 OR MIT
---

# Create or Update a GitHub Pull Request

## Repository Validation

1. Run `git rev-parse --is-inside-work-tree` before all other Git commands.
2. Continue only when the command returns `true`.
3. Run `gh repo view --json nameWithOwner,url` to resolve the current repository.
4. Continue only when GitHub resolves the repository.
5. If a check fails, stop and tell the user which repository requirement failed.

## What This Skill Does

- Load the `enforce-writing-style` skill for writing style guidelines before continuing.
- Confirm that the current directory is in a Git work tree.
- Confirm that GitHub resolves the current repository.
- Analyze all existing commit messages in the feature branch.
- If the current branch is the main default branch, skip this skill.
- Create a standard pull request title and description that combine logical commits in the feature branch.
- After new local modifications, analyze updated feature branch commits and either create a pull request or modify the existing pull request.
- Show a preview of the pull request title and description before any pull request command runs.
- Ask for explicit user confirmation before running `gh pr create` or `gh pr edit`.
- Follow the [Conventional Commits specification][conventional-commits] for most repositories.
- For nixpkgs or its forks, follow the [nixpkgs commit conventions][nixpkgs-commit-conventions].
- Suggest an appropriate title type and scope.

## Attribution

Do **NOT** add any AI attribution to the pull request description by default.

Only add attribution when the user explicitly asks (e.g. "add attribution",
"include generated-by footer", "credit the AI"). When asked, append the
appropriate line at the end of the pull request description based on the
tool in use:

- Claude Code: `🤖 Generated with [Claude Code](https://code.claude.com).`
- OpenCode: `🤖 Generated with [OpenCode](https://opencode.ai).`

## Pull Request Update Workflow

1. Validate the Git work tree and GitHub repository.
2. Detect whether the current branch is a feature branch.
3. If the current branch is the default branch, skip this skill.
4. Read current commits in the feature branch and group logical changes.
5. Check for new local modifications and include resulting commit updates.
6. Generate a pull request title and description draft.
7. Show a preview of the draft title and description to the user.
8. Ask for explicit confirmation before running pull request commands.
9. If no pull request exists for the branch, run `gh pr create` only after user confirmation.
10. If a pull request exists, run `gh pr edit` only after user confirmation.

## Confirmation Requirement

- Never run `gh pr create` or `gh pr edit` without explicit user confirmation.
- Always show a preview of the pull request title and description first.
- If the user requests edits to the preview, update the draft and ask again.

## Repository Detection

**CRITICAL**: Always detect the repository type before creating pull request titles and descriptions:

1. Check if the repository is nixpkgs or a nixpkgs fork by examining:
    - Remote URLs containing `NixOS/nixpkgs` or similar
    - Presence of `pkgs/top-level/all-packages.nix` or similar nixpkgs structure
2. If nixpkgs: Use [nixpkgs commit conventions][nixpkgs-commit-conventions]
3. Otherwise: Use [Conventional Commits specification][conventional-commits]

## Pull Request Format

### For Most Repositories (Conventional Commits)

```text
<type>(<scope>): <description>

## Summary

- <high-level change 1>
- <high-level change 2>

## Commit Groups

- <logical group 1 from feature branch commits>
- <logical group 2 from feature branch commits>

## Notes

- <tests, migration notes, or follow-up information>

[optional body]

[optional footer(s)]
```

### For nixpkgs and Its Forks

nixpkgs does **NOT** use Conventional Commits. Follow these conventions instead:

```text
<component>: <description>

[optional body]

[optional footer(s)]
```

**Key differences from Conventional Commits:**

- No type prefix (no `feat:`, `fix:`, etc.)
- Component/scope comes first, followed by colon
- Otherwise follows similar style guidelines

## Types

- `feat`: A new feature.
- `fix`: A bug fix.
- `docs`: Documentation-only changes.
- `style`: Changes that do not affect the meaning of the code.
- `refactor`: A code change that neither fixes a bug nor adds a feature.
- `perf`: A code change that improves performance.
- `test`: Adding missing tests or correcting existing tests.
- `build`: Changes that affect the build system or external dependencies.
- `ci`: Changes to CI configuration files and scripts.
- `chore`: Other changes that do not modify src or test files.
- `revert`: Reverts a previous commit.

## Guidelines

### General Rules for All Repositories

**Critical 50/72 Rule:**

- Title must be 50 characters or fewer, including type, scope, colon, and space.
- Body lines must wrap at 72 characters maximum per line.
- Always verify character count before committing with `echo --no-newline "title" | wc --chars` command.

**Title Formatting:**

- Use imperative mood in the description ("add" not "added").
- Keep the description entirely lowercase, including product names.
- Do not capitalize any words in the description.
- Do not end the description with a period.
- The entire title including `type(scope):` prefix counts toward the 50 character limit.

**Body Formatting:**

- Wrap every line at 72 characters maximum.
- Leave one blank line between title and body.
- Use proper grammar and punctuation following Chicago Manual of Style.
- Start sentences with capital letters.
- End sentences with proper punctuation.
- Each line in the body must not exceed 72 characters.

### nixpkgs-Specific Rules

When working in nixpkgs or its forks:

1. **Create one commit per logical unit** - Keep changes focused and atomic.

2. **Squash "oops" commits** - Use `git rebase -i` to squash commits like "oh, forgot to insert whitespace".

3. **No period at end of summary line** - The first line of the commit message should not end with a period.

4. **Special format for adding maintainers**: When adding yourself to `maintainer-list.nix`, use a separate commit with the message `maintainers: add <handle>`.

5. **Component-based commits**: Common patterns include:
    - `<package-name>: <version> -> <new-version>` - Version updates
    - `<package-name>: init at <version>` - New packages
    - `nixos/<module-name>: <description>` - NixOS module changes
    - `lib/<function>: <description>` - Library function changes
    - `doc: <description>` - Documentation changes

6. **Include relevant information**: For version updates, reference release notes or changelog URLs in the commit body.

7. **Area-specific conventions**: Consult area-specific commit conventions:
    - `doc/README.md` for documentation changes
    - `lib/README.md` for library changes
    - `nixos/README.md` for NixOS changes
    - `pkgs/README.md` for package changes

### Body (Optional Multi-Line Description)

- Use proper grammar and punctuation following Chicago Manual of Style.
- Start sentences with capital letters.
- End sentences with proper punctuation (periods, question marks, exclamation
  points).
- Wrap lines at 72 characters maximum per line.
- Use the body to explain what and why, not how.
- Write in complete sentences with correct grammar and punctuation.
- When using lists, each item must be a complete sentence ending with a period.
- Use proper casing for product names (e.g., "Microsoft.Compute", "Azure"),
  namespaces, technical identifiers, and acronyms in the body.
- Wrap technical identifiers, resource names, and code elements in backticks
  (e.g., `Microsoft.Compute`, `local-exec`, `EncryptionAtHost`).

### Footer

- Add `BREAKING CHANGE:` footer for breaking changes.
- When referencing issues, pull requests, or URLs, use the format:
  `Fix <url>.` (with period at the end).
- Example: `Fix https://github.com/org/repo/actions/runs/12345.`
- Do NOT use `Fixes:` or `Closes:` prefixes without periods.

## Examples

### Conventional Commits (Non-nixpkgs Repositories)

**Good commit titles:**

- `feat: add user authentication`
- `fix: resolve memory leak in parser`
- `docs: update installation guide`
- `refactor: simplify database queries`
- `perf: optimize image loading`
- `ci: add automated security scanning`

**Bad commit titles:**

- `feat: Add user authentication` - Incorrect: capitalized.
- `fix: Resolve memory leak in parser` - Incorrect: capitalized.
- `docs: Update installation guide` - Incorrect: capitalized.
- `docs: update installation guide.` - Incorrect: ends with period.
- `feat: This adds a new feature for user authentication` - Incorrect: too long,
  not imperative.
- `Fix bug` - Incorrect: missing type prefix and colon.

**Good commit with body (proper punctuation and grammar):**

```markdown
feat(api): add rate limiting middleware

Implement `express-rate-limit` middleware to prevent API abuse.
Configure sliding window with 100 requests per 15-minute window per
IP address. Add custom error messages and logging for rate limit
violations.

Rate limiting applies to all `/api/*` endpoints except health checks.
```

**Good commit with footer (referencing external resources):**

```markdown
fix(auth): resolve token expiration edge case

Update token refresh logic to handle race conditions when multiple
requests attempt to refresh an expired token simultaneously. Add
mutex lock to ensure only one refresh operation occurs at a time.

Fix https://github.com/org/repo/issues/456.
```

**Bad commit footers:**

```text
Fix https://github.com/org/repo/issues/123
```

Incorrect: missing period at the end.

```text
Fixes: https://github.com/org/repo/issues/123
```

Incorrect: uses `Fixes:` prefix instead of `Fix` without colon.

### nixpkgs Commit Examples

**Good nixpkgs commit titles:**

- `hello: 2.10 -> 2.12`
- `python311Packages.requests: 2.28.1 -> 2.31.0`
- `firefox: init at 121.0`
- `nixos/postgresql: add option for custom configuration`
- `lib/strings: fix off-by-one error in substring function`
- `doc: add guide for packaging python applications`
- `maintainers: add johndoe`

**Bad nixpkgs commit titles:**

- `feat: add hello package` - Incorrect: uses Conventional Commits format.
- `fix(python): update requests` - Incorrect: uses Conventional Commits format.
- `Hello: 2.10 -> 2.12` - Incorrect: capitalized package name.
- `hello: 2.10 -> 2.12.` - Incorrect: ends with period.
- `Update hello to version 2.12` - Incorrect: not concise, missing old version.

**Good nixpkgs commit with body:**

```markdown
python311Packages.requests: 2.28.1 -> 2.31.0

This release includes several security fixes and bug fixes.
Notable changes include improved handling of redirect loops
and better support for international domain names.

Release notes: https://github.com/psf/requests/releases/tag/v2.31.0
```

**Good nixpkgs maintainer addition:**

```markdown
maintainers: add johndoe
```

**Good nixpkgs new package:**

```markdown
hello: init at 2.12

GNU Hello is a program that prints "Hello, world!" when run.
It serves as an example of standard GNU coding practices.
```

**Good commit with proper casing for product names in body:**

```markdown
fix(storage): configure blob lifecycle management

Enable `Azure Blob Storage` lifecycle policies to automatically
transition blobs between `Hot`, `Cool`, and `Archive` tiers. Configure
rules to move logs older than 30 days to `Cool` tier and delete blobs
older than 90 days. Add `ManagementPolicies` resource with proper
filtering by `blobTypes` and `prefixMatch`.
```

**Good commit with bulleted list:**

Complete sentences with periods.

```markdown
feat(network): configure virtual network peering

Establish `VNet` peering between production and monitoring networks
to enable cross-network communication for observability stack.

Changes:

- Create `VirtualNetworkPeering` resource for prod-to-monitor direction.
- Create reverse peering for monitor-to-prod direction.
- Enable `allowForwardedTraffic` on both peering connections.
- Set `allowGatewayTransit` to false on production side.
- Configure `useRemoteGateways` to false on monitoring side.

Both peerings use `remoteVirtualNetworkId` to reference target networks.
```

**Bad commit body:**

Missing punctuation and code blocks around technical identifiers.

```text
fix(monitoring): resolve container insights data collection

Configure ContainerInsights solution to collect metrics from
kube-state-metrics pod
Update Azure Monitor workspace to use Log Analytics integration
```

Incorrect: missing periods, not complete sentences, missing backticks
around technical identifiers.

**Bad commit body with list:**

Missing periods on list items.

```text
feat(home-manager): configure browsers using programs options

Changes:
- Enable chromium with programs.chromium (Linux-only)
- Enable firefox with programs.firefox (Linux-only)
- Add brave, epiphany, edge, tor-browser, vivaldi as packages
```

Incorrect: list items are not complete sentences and lack periods.

## References

- [Conventional Commits specification][conventional-commits]
- [nixpkgs commit conventions][nixpkgs-commit-conventions]
- [Markdown reference-style links][markdown-reference-links]

[conventional-commits]: https://www.conventionalcommits.org/
[nixpkgs-commit-conventions]: https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#commit-conventions
[markdown-reference-links]: https://www.markdownguide.org/basic-syntax/#reference-style-links
