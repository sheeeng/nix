---
name: eli5
description: Explain a topic like I'm a 5 year old. Use when the user types /eli5 <topic> or asks for a dead-simple picture explainer of how something works.
license: Apache-2.0 OR MIT
---

# eli5

## Before Starting

Load the `enforce-writing-style` skill before continuing. Its required
chain is `enforce-asd-ste100`, followed by `forbid-llm-slop`. Apply
writing style rules to all output produced by this skill.

Explain like I'm someone who knows nothing about this topic, using a HTML artifact with big pictures and few words.

Topic: $ARGUMENTS
