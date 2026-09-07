---
name: weave-web
description: Use when implementing or revising web interface components that must work across mobile and desktop layouts.
---

# Weave Web

## Before Starting

Load `enforce-writing-style` before continuing. Its required chain is
`enforce-asd-ste100`, followed by `forbid-llm-slop`.

Also, load `animate-kinetics` and `animate-text` before continuing.

## Core Principle

Use the project's existing stack and design system. Treat mobile and desktop
behavior as equal acceptance conditions.

Do not reduce mobile work to a smoke check because the supplied design, review
focus, or schedule favors desktop systems.

## Workflow

- Inspect project patterns, tokens, dependencies, tests, and browser support.
- Define responsive behavior and states.
- Use semantic HTML and native controls. Add ARIA only when necessary.
- Start narrow. Add breakpoints when content needs more space, not for named
  devices.
- Use fluid, intrinsic CSS. Preserve long text and media.
- Implement each applicable state.
- Keep primary content usable without optional effects or JavaScript.
- Run project checks and verify every required viewport and input mode.

## Responsive Acceptance Gate

Do not report the component complete until all applicable checks pass:

| Area          | Required Check                                                                                          |
| ------------- | ------------------------------------------------------------------------------------------------------- |
| Narrow        | Test at 320 and 390 CSS pixels. Preserve content and functions without page-level horizontal scrolling. |
| Intermediate  | Test at 768 CSS pixels and each breakpoint.                                                             |
| Wide          | Test at 1,280 and 1,440 CSS pixels. Prevent excessive line lengths and unintended empty space.          |
| Resize        | Resize continuously. Check wrapping, overlap, clipping, and layout shifts.                              |
| Input         | Test keyboard, touch, and pointer input. Do not depend on hover.                                        |
| Accessibility | Check structure, names, focus, contrast, zoom, reduced motion, and forced colors.                       |
| Content       | Test long text, missing media, and realistic data limits.                                               |
| Rendering     | Check supported browsers and optional-effect fallbacks.                                                 |

Save narrow and wide screenshots when possible. Report checks that cannot run.

## Motion and Visual Effects

- Load `animate-kinetics` when the component uses animated feedback, state
  changes, navigation, loading, gestures, hover effects, or transitions.
- Load `animate-text` when headings, labels, counters, or text changes animate.
- Load both skills when both conditions apply. Use their bundled catalogs to
  select motion that fits the interaction purpose.
- Honor `prefers-reduced-motion` and avoid automatic nonessential motion.
- Make decorative canvas elements ignore pointer input and accessibility APIs.
- Preserve readable content, clear actions, and stable layout while data loads.

## Reference Use

Read [Web Component Design References][design-references] before selecting a
visual pattern, animation, canvas effect, or AI-native interface pattern.

## Common Mistakes

- Do not implement a desktop screenshot and add one narrow-width smoke check.
- Do not remove content or functions at narrow widths.
- Do not require optional effects for primary interactions.
- Do not claim responsive behavior from source inspection alone.

[design-references]: references/design-references.md
