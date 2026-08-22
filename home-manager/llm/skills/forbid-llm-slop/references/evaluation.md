# Evaluation

## Audit Report

For detect mode, report each finding with:

* Exact span.
* Pattern name.
* Why it reads as a machine pattern in this context.
* A short repair direction.

Do not report a score as proof that a model wrote the text. Detectors vary by
tool, model, language, and date. A score is a review signal only.

## Rewrite Review

After rewriting, check every claim against the source. Check that names,
numbers, dates, quotes, links, uncertainty, and technical details survived.
Check that the revision did not add a new fact, flatten the voice, or turn
specific prose into generic prose.

Then inspect the whole artifact for:

* Repeated openings, uniform sentence length, uniform paragraphs, and stacked
  transitions.
* Forced contrasts, triads, fragments, aphorisms, and generic conclusions.
* Unsupported importance, vague attribution, promotional language, and actorless
  claims.
* Chatbot greetings, reasoning scaffolding, excess headings, and decorative
  formatting.

## Optional Quantitative Signals

When before and after text exists, compare sentence length variation, repeated
three word sequences, vocabulary diversity, paragraph length variation, and
the density of abstract unsupported claims. Use the numbers to find passages
for human review. Do not optimize the text for a detector or add artificial
mistakes to improve a score.

## Completion Criteria

An edit is complete when the text preserves the source facts and voice, removes
the identified patterns, contains no unsupported claims, and reads naturally
as a whole. A detect report is complete when every reported finding points to
an exact span and stops before rewriting. A file edit is complete when only
the intended prose changed and the file remains valid for its format.
