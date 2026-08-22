---
name: animate-kinetics
description: Select and implement spring physics motion patterns from the Kinetics library for web interfaces. Use for animated inputs, feedback, state changes, navigation, loading states, text, data displays, gestures, hover effects, CSS transitions, React interactions, or requests that reference kinetics.colorion.co.
license: Apache-2.0 OR MIT
---

# Animate Kinetics

Use the bundled catalog to select and implement a Kinetics motion pattern. The catalog contains the available CSS and React examples, implementation prompt, and motion parameter for each of the 144 effects from the official [Kinetics website][kinetics-website].

## Workflow

1. Identify the interface element, interaction trigger, desired feedback, and target stack.
2. Run `node scripts/find-effect.mjs "<query>"` with terms that describe the element and motion.
3. Read the complete matching record in `assets/catalog.json`.
4. Adapt the selected CSS or React example to the existing component structure and styling.
5. Preserve the motion parameter, transform values, transition timing, and interaction semantics unless the user requests a variation.
6. Add reduced motion behavior with `prefers-reduced-motion` or the target framework equivalent.
7. Test the initial state, active state, interrupted motion, repeated interaction, keyboard operation, and reduced motion behavior.

## Selection Rules

Choose an effect whose interaction purpose matches the request. Treat visual similarity as a secondary criterion.

Prefer transforms and opacity for frequent motion. Use layout properties only when the effect depends on layout change.

Preserve the existing design system. Copy the motion behavior, not the Kinetics page colors, typography, spacing, or card styling.

Treat each available React example as a focused pattern. Integrate its state and event handling into the existing component instead of adding a duplicate component abstraction. When an effect has no React example, translate its CSS and implementation prompt into the target component.

Use the bundled implementation prompt to recover intent when the CSS and React examples differ.

## Bundled Resources

`assets/catalog.json` contains all 144 effects and records the source repository revision.

`scripts/find-effect.mjs` searches names, descriptions, parameters, and implementation prompts. Pass `--json` after the query to print complete matching records.

The catalog is derived from Kinetics revision `114ec510ec8abdd1d535c003d90b921d7dba6c76`.

[kinetics-website]: https://kinetics.colorion.co/
