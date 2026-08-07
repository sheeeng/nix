---
name: enforce-asd-ste100
description: Use when writing or editing technical documentation, procedures, instructions, warnings, descriptions, or user guidance that must use clear and controlled English.
---

# Enforce ASD STE100

## Scope

Apply these rules to technical documentation and instructions. Do not apply them to conversation, quotations, source code, identifiers, or creative writing.

These rules are inspired by ASD STE100 and [agent-simple-english][agent-simple-english]. They do not reproduce the ASD STE100 specification or its controlled dictionary.

## Mandatory Rules

1. Use approved project terms consistently. Do not use different words for the same item or action.
2. Use one word for one meaning when context permits.
3. Use active voice. Name the person, system, or component that does the action.
4. Use imperative verbs for procedural steps.
5. Write one action in each procedural step.
6. Put conditions before actions.
7. Use short sentences. Aim for no more than 25 words.
8. Use short paragraphs. Aim for no more than six sentences.
9. Do not use contractions.
10. Do not use semicolons.
11. Avoid phrasal verbs when a precise single verb is available.
12. Avoid progressive and perfect verb forms when a simple tense is clear.
13. Define abbreviations at first use unless the audience already knows them.
14. Keep warnings and cautions direct. State the hazard, required action, and consequence.

## Advisory Rules

1. Prefer concrete nouns and direct verbs.
2. Remove hedging unless uncertainty is technically necessary.
3. Remove marketing language from technical content.
4. Use lists only when they make steps, conditions, or alternatives easier to scan.
5. Keep modifiers close to the words that they modify.

## Review Procedure

Before returning technical documentation or instructions:

1. Check each mandatory rule.
2. Correct each violation that does not change technical meaning.
3. Ask for clarification when a correction could change technical meaning.
4. Report any unresolved mandatory violation.

## Examples

| Avoid                                                                            | Use                                                           |
| -------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| The service is being restarted by the controller.                                | The controller restarts the service.                          |
| If the light is red, you should turn off the unit and then disconnect the cable. | If the light is red, turn off the unit. Disconnect the cable. |
| The system has completed the validation.                                         | The system completed the validation.                          |
| Do not utilize the damaged connector.                                            | Do not use the damaged connector.                             |

[agent-simple-english]: https://github.com/jyooi/agent-simple-english
