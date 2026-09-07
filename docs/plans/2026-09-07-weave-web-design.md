# Weave Web Skill Design

## Purpose

Create a framework-neutral skill that guides agents when they implement web
interface components. The skill must make responsive mobile and desktop
behavior an acceptance condition.

## Scope

The skill will require agents to use the existing project stack and design
system. It will cover semantic markup, accessibility, responsive layout,
motion preferences, progressive enhancement, and visual verification.

The skill will not prescribe a JavaScript framework or copy reference source
code. Agents can use the references for interaction and visual design ideas.

## Structure

Use `SKILL.md` for the workflow and acceptance gate. Put design sources and
standards in `references/design-references.md`. Add `agents/openai.yaml` for
concise interface metadata. Do not add scripts, assets, or placeholder files.

## Acceptance Conditions

The skill must require agents to:

1. Inspect the existing project before they select an implementation pattern.
2. Preserve semantic HTML and keyboard access.
3. Use mobile-first, content-driven responsive rules.
4. Prevent unintended horizontal overflow.
5. Support touch, pointer, keyboard, reduced-motion, and forced-colors use.
6. Keep primary content usable when optional visual effects are unavailable.
7. Verify representative narrow and wide viewports with available project tools.
8. Run the project tests and report unverified conditions.

## References

- [Rare UI][rare-ui]
- [Canvas UI][canvas-ui]
- [Transitions.dev][transitions-dev]
- [Beautiful UI][beautiful-ui]

[beautiful-ui]: https://www.beautifului.dev/
[canvas-ui]: https://github.com/DavidHDev/canvas-ui
[rare-ui]: https://github.com/swamimalode07/rare-ui
[transitions-dev]: https://github.com/Jakubantalik/transitions.dev
