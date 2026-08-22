---
name: forbid-llm-slop
description: Edit and audit AI generated prose. Preserve facts, voice, uncertainty, and useful imperfections. Use when writing must sound specific, natural, personal, or technical.
license: Apache-2.0 OR MIT
---

<!--
References:
* https://www.skills.sh/hardikpandya/stop-slop/stop-slop
* https://www.skills.sh/petergyang/no-ai-slop/no-ai-slop
* https://www.skills.sh/blader/humanizer
* https://www.skills.sh/cursor/plugins/unslop
* https://www.skills.sh/ehmo/slopkit/slopbeth
* https://www.skills.sh/aboudjem/humanizer-skill/humanizer
* https://www.skills.sh/stephenturner/skills/deslop
* https://www.skills.sh/elithrar/dotfiles/anti-slop
* https://www.skills.sh/aashaexo/soundshuman/humanize
* https://www.skills.sh/jalaalrd/anti-ai-slop-writing/anti-ai-slop-writing
-->

# Forbid AI Slop

Edit for human voice without changing what the source says.

## Choose a Mode

- Use edit mode when the user provides a draft and asks for a rewrite. Return
  the complete revised text followed by a short `What changed` section.
- Use detect mode when the user asks whether text contains AI slop or asks for
  an audit. Report exact spans, name the pattern, and give a short fix. Do not
  rewrite, score, or guess whether a person or model wrote it.
- Use file mode when the user names a file. Change prose only. Preserve code,
  data, frontmatter, link targets, quoted material, and machine readable
  values. Report a short summary instead of repeating the whole file.
- Use repository audit mode when the user names a directory. Rank the files by
  their strongest signals, then rewrite only the files the user selects.
- Use embedded mode when another task asks for a description, commit message,
  pull request, or other artifact. Return only the final text.

If no draft is provided, ask the user to paste it or name a file. If the
audience, medium, or purpose is unclear, ask one focused question.

## Preserve the Source

Read the complete source before editing. Identify its purpose, audience,
register, point of view, cadence, humor, uncertainty, and deliberate roughness.
Preserve the writer's voice rather than replacing it with a generic polished
voice.

Lock these before rewriting:

- Names, dates, numbers, URLs, citations, quotations, and technical claims.
- Scope, uncertainty, causality, risk, legal meaning, and stated limitations.
- The author's opinion, stance, emotional texture, and useful disagreement.
- Concrete details, local references, sensory details, and deliberate
  imperfections that carry identity.

Stay inside the evidence boundary. Do not invent facts, examples, metrics,
studies, anecdotes, quotes, owners, dates, product capabilities, or outcomes.
When a claim needs missing evidence, ask for it, state the gap, or write the
plainest supported version.

## Avoid False Positives

Flag clusters, not isolated signals. A single dash, adjective, list of three,
curly quote, repeated technical term, or polished sentence does not prove that
the prose is artificial.

Preserve exact language in quotations, titles, headings, code, examples, data,
frontmatter, link targets, and technical terminology. Preserve jargon when the
audience needs it. Preserve plain neutral prose in reference, legal, medical,
and technical writing. Short samples do not provide enough evidence for a
reliable style judgment.

Keep human signals: specific memories, real measurements, named places, mixed
feelings, bias, slang, local references, self correction, fragments used with
purpose, and endings that do not perform a lesson.

## Edit in This Order

1. Classify the purpose, audience, medium, and mode.
2. Separate instructions about the draft from text meant for the reader.
3. Preserve facts, constraints, voice, and source uncertainty.
4. Diagnose clusters using [the pattern catalog][pattern-catalog].
5. Cut scaffolding, filler, vague importance, inflated abstractions, and
   unsupported claims.
6. Replace weak verbs with direct verbs, name the actor, and put the point
   where the reader needs it.
7. Use concrete details from the source. Do not manufacture specificity.
8. Restore natural cadence with varied sentence and paragraph lengths.
9. Match the source register. Use personality only when the source calls for
   it. Keep technical, legal, medical, and reference prose measured.
10. Read the revision as a whole. Remove any new formula, tidy triad, forced
    punchline, or generic consultant voice.
11. Run the checks in [evaluation][evaluation] when the task
    includes before and after text or a file.

## Default Writing Rules

- State the point directly. Cut throat clearing, staged honesty, fake insight,
  announcements, and repeated conclusions.
- Prefer specific facts, mechanisms, consequences, examples, and numbers over
  abstract praise or vague importance.
- Use active voice when it makes the actor clearer. Do not let an inanimate
  object decide, promise, explain, want, or fix something.
- Use `is`, `are`, and `has` when longer verbs only decorate a simple fact.
- Repeat the clearest noun when repetition prevents confusion. Do not cycle
  through synonyms to avoid saying the same word twice.
- Use the natural number of items. Do not force a group of three or a balanced
  list when two items or a sentence would be clearer.
- Vary syntax and cadence. Connect related thoughts when their relationship
  matters. Use a short sentence for emphasis, not as a chain of fragments.
- Let structure follow the content. Use lists for parallel items and prose for
  arguments that need flow. Remove decorative headings, bold labels, emojis,
  and stacked caveats when they add no function.
- Remove decorative em dashes and en dashes. Use a period, comma, colon,
  parenthesis, or a new structure. Follow the writer's stated punctuation
  preference when it is clear.
- Remove chatbot residue such as greetings, praise, offers, acknowledgments,
  cutoff disclaimers, reasoning scaffolding, and questions the reader never
  asked.
- Keep one qualifier when it carries real uncertainty. Remove qualifier piles
  that only soften a claim.
- End on the last useful fact, action, image, or unresolved tension. Do not add
  a motivational conclusion.

## Final Response

For edit mode, return the complete revision first. Add `What changed` only
after the revision. For detect mode, return the findings and stop. For file
mode, write only the revised prose to the file and report the change. Never
claim that prose is permanently undetectable or guaranteed to pass a detector.

[evaluation]: references/evaluation.md
[pattern-catalog]: references/pattern-catalog.md
