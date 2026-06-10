# Research

Perform a deep-read investigation of a codebase area and write findings to a persistent markdown file.

Usage: /research [target folder, system, or topic]

## What This Command Does

- Read the specified area of the codebase thoroughly, not at a surface level.
- Understand how the system works deeply, including all specificities and intricacies.
- Write a detailed report of findings in `research.md` in the project root.
- Never summarize findings verbally in chat alone; always produce the written artifact.

## Why This Matters

The written `research.md` is the review surface. It lets you verify understanding and correct misunderstandings before any planning happens. If the research is wrong, the plan will be wrong, and the implementation will be wrong.

This phase prevents the most expensive failure mode: implementations that work in isolation but break the surrounding system. A function that ignores an existing caching layer. A migration that does not account for conventions. An endpoint that duplicates logic already existing elsewhere.

## Guidelines

- Read deeply. Surface-level skimming is not acceptable.
- Go through everything: understand intricacies, edge cases, and specificities.
- Look for existing patterns, conventions, caching layers, and shared utilities.
- Identify potential bugs if asked to investigate issues.
- Do not stop early. Keep researching until you have a comprehensive understanding.
- Write the artifact in `research.md` with structured sections and concrete details.
- Include file paths, function names, and code snippets in the report.
- Do not plan or implement anything during this phase.

## Example Prompts

- "Read this folder in depth, understand how it works deeply, what it does and all its specificities. When done, write a detailed report of your learnings and findings in research.md."
- "Study the notification system in great detail, understand the intricacies of it and write a detailed research.md document with everything there is to know about how notifications work."
- "Go through the task scheduling flow, understand it deeply and look for potential bugs. Keep researching the flow until you find all the bugs. When done, write a detailed report of your findings in research.md."
