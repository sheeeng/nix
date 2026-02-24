# Implement

Execute an approved plan from `plan.md`, marking tasks complete as you go.

Usage: /implement

## What I Do

- Read the `plan.md` document and execute every task in it.
- Mark each task or phase as completed in the plan document as I finish it.
- Do not stop until all tasks and phases are completed.
- Do not pause for confirmation mid-flow.
- Continuously run type checks and linters to catch problems early.
- Keep the code clean without unnecessary comments.

## Prerequisites

- A reviewed and approved `plan.md` must exist in the project.
- The plan should contain a granular todo list with phases and individual tasks.
- All architectural decisions should already be finalized in the plan.

## Why This Matters

By the time this command runs, every decision has been made and validated during the planning and annotation phases. Implementation becomes mechanical, not creative. The creative work happened in the annotation cycles. Once the plan is right, execution should be straightforward.

Without the planning phase, what typically happens is a reasonable-but-wrong assumption early on, building on top of it, and then having to unwind a chain of changes. The plan eliminates this entirely.

## Guidelines

- Implement everything in the plan. Do not cherry-pick.
- The plan is the source of truth for progress.
- Mark completed items in the plan document immediately after finishing each one.
- Do not add unnecessary comments or documentation strings unless required.
- Maintain strict typing. Do not use escape-hatch types.
- Run type checks and linters continuously, not just at the end.
- If something goes wrong, revert and re-scope rather than patching a bad approach.

## Handling Feedback During Implementation

After implementation begins, expect terse corrections:

- Short, direct corrections are sufficient because the full context exists in the plan and the ongoing session.
- For visual work, screenshots communicate problems faster than descriptions.
- Reference existing code patterns: "This table should look exactly like the users table."
- If direction goes wrong, revert and narrow scope rather than incrementally fixing a bad approach.
