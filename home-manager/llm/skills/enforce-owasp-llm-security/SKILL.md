---
name: enforce-owasp-llm-security
description: Enforce OWASP generative artificial intelligence security guidance throughout design, development, evaluation, deployment, and operations. Use for large language models, prompts, agents, tools, Model Context Protocol servers, retrieval augmented generation, vector stores, embeddings, training data, model supply chains, output handling, sensitive data, autonomous actions, misinformation, governance, red teaming, monitoring, and incident response.
license: Apache-2.0 OR MIT
---

# Enforce OWASP Large Language Model Security

## Before Starting

Load the `enforce-writing-style` skill before continuing. Its required
chain is `enforce-asd-ste100`, followed by `forbid-llm-slop`. Apply
writing style rules to all output produced by this skill.

## Apply the Standard

1. Identify the model, application, data, tool, and user trust boundaries.
2. Read [the 2025 risk checklist][risk-checklist] for every task.
3. Read [the security lifecycle][security-lifecycle] for design, governance, data, agent, deployment, operations, or testing work.
4. Select every risk and lifecycle control that applies to the task.
5. Inspect the design and implementation for each selected item.
6. Recommend deterministic controls outside the model when a model instruction cannot enforce the control.
7. Verify each correction with a test that exercises the relevant trust boundary.
8. Report all applicable risks, evidence, corrections, and unresolved assumptions.

Treat model input and output as untrusted data. Treat the model as a probabilistic component, not as a security boundary.

## Report Findings

For each finding, give this information:

1. **Risk:** Give the OWASP identifier and name.
2. **Location:** Give the file, component, prompt, data source, or workflow step.
3. **Evidence:** Describe the vulnerable data flow, permission, or trust decision.
4. **Impact:** Describe the realistic security or safety consequence.
5. **Correction:** Specify the smallest effective design or code change.
6. **Verification:** Specify a test that demonstrates the control.
7. **Severity:** Assign Critical, High, Medium, or Low severity.

State when a risk does not apply. Give the evidence for that conclusion. Do not claim complete coverage until every risk has a recorded result.

[risk-checklist]: references/llm-top-10.md
[security-lifecycle]: references/security-lifecycle.md
