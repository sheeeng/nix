# OWASP Generative Artificial Intelligence Security Lifecycle

Use this lifecycle with the [OWASP GenAI Security Project][owasp-genai-project]. Select the sections that apply to the task.

## Plan and Govern

- Inventory models, agents, data sources, tools, providers, owners, users, and intended uses.
- Classify data, actions, decisions, and business impacts.
- Define acceptable use, prohibited use, retention, privacy, intellectual property, and human oversight rules.
- Threat model model behavior, memory, identity, tools, data flows, multiagent communication, and external dependencies.
- Define measurable security, safety, reliability, and incident response requirements.

## Acquire and Build

- Verify the provenance, license, integrity, maintenance status, and evaluation evidence for models, datasets, adapters, and packages.
- Protect source, training, tuning, evaluation, and deployment pipelines with least privilege and change approval.
- Separate trusted instructions from untrusted content and enforce authorization outside the model.
- Design narrow tools with typed arguments, explicit scopes, bounded effects, and recoverable operations.
- Keep secrets and security decisions out of prompts and model memory.

## Prepare Data

- Authenticate data sources and record lineage, ownership, classification, consent, and permitted use.
- Detect secrets, personal data, poisoning, hidden instructions, duplicates, stale records, and conflicting sources.
- Partition retrieval data by tenant and authorization domain.
- Enforce deletion and retention requirements across source data, embeddings, caches, prompts, logs, and backups.
- Preserve approved versions for audit, comparison, and rollback.

## Evaluate and Red Team

- Test all OWASP Large Language Model Top Ten risks before deployment and after material changes.
- Test direct, indirect, encoded, multilingual, multimodal, and multi turn attacks.
- Test agent identity, delegated authority, memory poisoning, tool misuse, cascading failures, and human approval controls.
- Measure leakage, harmful action rate, groundedness, refusal behavior, recovery, resource use, and cost.
- Use repeatable evaluation datasets and record model, prompt, tool, data, and parameter versions.
- Include independent human review for high impact uses and unresolved model behavior.

Use the [OWASP GenAI Red Teaming Initiative][owasp-red-teaming] for evaluation methods. Use the [Agentic AI Threats and Mitigations guide][agentic-threats] for agent threat models.

## Deploy and Operate

- Isolate model and tool workloads from sensitive networks and services.
- Apply authentication, authorization, rate limits, quotas, timeouts, output limits, and action limits.
- Monitor prompts, retrieval, model output, tool calls, approvals, denials, costs, and anomalous behavior without recording unnecessary sensitive data.
- Detect model, prompt, tool, data, provider, and dependency drift.
- Provide safe degradation, cancellation, rollback, and emergency disable controls.
- Review external Model Context Protocol servers and other tools before connection and after updates.

Use the [Securing Agentic Applications Guide][securing-agentic-applications] for agent implementation and deployment controls.

## Respond and Improve

- Define incidents for data leakage, prompt injection, poisoning, unsafe actions, compromised dependencies, model extraction, misinformation, and resource abuse.
- Preserve model, prompt, retrieval, tool, identity, approval, and output evidence for investigation.
- Revoke credentials, isolate tools, disable affected workflows, and roll back compromised artifacts.
- Notify affected owners and users according to legal and organizational requirements.
- Add every confirmed failure to regression evaluations and update the threat model.

[agentic-threats]: https://genai.owasp.org/resource/agentic-ai-threats-and-mitigations/
[owasp-genai-project]: https://genai.owasp.org/
[owasp-red-teaming]: https://genai.owasp.org/initiatives/genai-red-teaming-initiative/
[securing-agentic-applications]: https://genai.owasp.org/resource/securing-agentic-applications-guide-1-0/
