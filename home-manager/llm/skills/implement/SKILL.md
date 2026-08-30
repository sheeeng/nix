---
name: implement
description: "Implement a piece of work based on a spec or set of tickets, then review it with a parallel team of associate, senior, and penetration test reviewers."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Use /tdd where possible, at pre-agreed seams.

Run type checking regularly, single test files regularly, and the full test
suite once all implementation tasks are complete.

## Parallel Team Review

When all tests pass, dispatch these three agents in a single parallel message:

- **associate-engineer-reviewer**: reads all changed files and reports every
  naming, comprehension, and documentation issue.
- **senior-engineer-reviewer**: reads all changed files and reports every
  YAGNI, DRY, scalability, and OWASP secure coding violation.
- **pentest-reviewer**: reads all changed files and reports every exploitable
  vulnerability with attack vector, impact, and minimum remediation.

Provide each agent the output of `git diff HEAD` and the list of changed
files.

## Synthesize and Fix

Once all three agents report back:

1. Collect every finding into a single list, deduplicating overlapping
   findings.
2. Prioritize by severity: critical security and exploit findings first, then
   high-severity design and readability issues.
3. Apply all fixes that do not change the agreed design.
4. For findings that require a design change, present them to the user before
   acting.
5. Run the full test suite again after applying fixes.

## Commit

Use /commit to commit the work to the current branch.
