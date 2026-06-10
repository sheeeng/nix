# Plan

Create a detailed implementation plan in a persistent markdown file. Do not implement anything.

Usage: /plan [feature description or change request]

## What This Command Does

- Read relevant source files before suggesting changes.
- Write a detailed `plan.md` document outlining how to implement the requested change.
- Base the plan on the actual codebase, not assumptions.
- Include code snippets showing the actual changes.
- Include file paths that will be modified.
- Include considerations and trade-offs.
- Do not implement anything. Writing the plan is the only deliverable.

## Why This Matters

The plan is a structured, complete specification you can review holistically. It prevents wasted effort, keeps you in control of architecture decisions, and produces significantly better results than jumping straight to code.

A chat conversation is something you would have to scroll through to reconstruct decisions. The persistent plan document wins every time.

## The Annotation Cycle

After the plan is written, you should review it in your editor and add inline notes directly into the document. Then tell me to address the notes:

- "I added a few notes to the document, address all the notes and update the document accordingly. Do not implement yet."

This cycle repeats one to six times until you are satisfied. Each round transforms a generic implementation plan into one that fits perfectly into the existing system.

## Guidelines

- Always read source files before proposing changes.
- Include a detailed explanation of the approach.
- Show concrete code snippets, not abstract descriptions.
- List every file path that will be modified.
- Document considerations, trade-offs, and alternatives considered.
- If a reference implementation is provided, study it and adapt the approach.
- Never implement during this phase. Guard with "do not implement yet" if needed.
- After the plan is approved, request a granular todo list before implementation.

## Requesting the Todo List

Before implementation starts, always request a granular task breakdown:

- "Add a detailed todo list to the plan, with all the phases and individual tasks necessary to complete the plan. Do not implement yet."

This creates a checklist that serves as a progress tracker during implementation.

## Example Prompts

- "I want to build a new feature that extends the system to perform cursor-based pagination. Write a detailed plan.md for how to achieve this. Read source files before suggesting changes, base the plan on the actual codebase."
- "I added a few notes to the document, address all the notes and update the document accordingly. Do not implement yet."
- "Add a detailed todo list to the plan, with all the phases and individual tasks necessary to complete the plan. Do not implement yet."
