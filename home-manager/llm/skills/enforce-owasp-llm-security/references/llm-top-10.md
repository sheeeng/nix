# OWASP Top 10 for Large Language Model Applications 2025

Use the [OWASP 2025 Top 10 risks and mitigations][owasp-llm-top-ten] as an awareness document for generative artificial intelligence applications.

## Risk Index

| ID | Risk | Review Focus |
| ---- | ---- | ------------ |
| LLM01 | Prompt Injection | Direct, indirect, encoded, multilingual, and multimodal instructions alter model behavior |
| LLM02 | Sensitive Information Disclosure | Prompts, training data, retrieval data, model output, or logs expose protected information |
| LLM03 | Supply Chain | Models, data, adapters, packages, repositories, and deployment platforms lack integrity or provenance |
| LLM04 | Data and Model Poisoning | Modified training, tuning, or embedding data introduces bias, backdoors, or vulnerable behavior |
| LLM05 | Improper Output Handling | Downstream systems trust model output as code, commands, queries, markup, paths, or control data |
| LLM06 | Excessive Agency | The model has unnecessary functions, permissions, identities, or autonomy |
| LLM07 | System Prompt Leakage | System prompts contain secrets or controls that fail when disclosed or changed |
| LLM08 | Vector and Embedding Weaknesses | Retrieval systems leak, mix, invert, or accept poisoned data |
| LLM09 | Misinformation | Users or systems rely on false, unsupported, biased, or unsafe output |
| LLM10 | Unbounded Consumption | Requests exhaust compute, memory, context, queues, service capacity, or budget |

## Verification Checklist

### LLM01:2025 Prompt Injection

- Separate instructions from untrusted user, file, website, retrieval, image, audio, and tool content.
- Constrain model tasks, tool parameters, output formats, and accessible data.
- Validate model output with deterministic code before another component uses it.
- Enforce authorization and least privilege outside the model.
- Require human approval before privileged, destructive, financial, or externally visible actions.
- Test direct, indirect, encoded, multilingual, split payload, adversarial suffix, and multimodal injection.

### LLM02:2025 Sensitive Information Disclosure

- Classify sensitive prompts, training data, retrieval data, outputs, telemetry, and logs.
- Exclude secrets and unnecessary personal or confidential data from model context.
- Redact or tokenize sensitive data before processing, training, or logging.
- Apply access control to data sources and retrieval results for the requesting user.
- Define retention, deletion, training use, and user consent rules.
- Test cross user disclosure, training data extraction, model inversion, and error leakage.

### LLM03:2025 Supply Chain

- Inventory models, datasets, adapters, packages, extensions, repositories, and deployment services.
- Record source, owner, license, version, checksum, signature, and evaluation status for each artifact.
- Use trusted repositories and verify artifact integrity before loading or deployment.
- Scan packages and model formats for vulnerable code and unsafe serialization.
- Pin reviewed versions and control updates through approval and rollback processes.
- Evaluate third party models, datasets, and adapters for backdoors, bias, and unsafe behavior.

### LLM04:2025 Data and Model Poisoning

- Accept training, tuning, and retrieval data only from authenticated sources.
- Track data lineage, ownership, transformations, and approval status.
- Validate data quality, integrity, labels, duplication, and unexpected instructions.
- Isolate untrusted data and review changes before ingestion.
- Detect anomalous model behavior with baseline and adversarial evaluations.
- Preserve clean data and model versions for comparison and rollback.

### LLM05:2025 Improper Output Handling

- Treat all model output as untrusted input to downstream components.
- Validate output against a strict schema and allowlisted values.
- Apply context specific encoding before rendering HTML, Markdown, JavaScript, or other active content.
- Use parameterized queries and structured tool arguments.
- Keep model output away from shell execution, dynamic evaluation, and unrestricted file paths.
- Monitor rejected output and test injection into every downstream interpreter.

### LLM06:2025 Excessive Agency

- Give the model only the functions required for its task.
- Prefer narrow functions over open command, code execution, network access, or file access tools.
- Give every tool and service identity the minimum permissions for the current user and action.
- Enforce authorization in downstream systems for every request.
- Require user approval for actions with material impact.
- Limit action count, duration, scope, and reversibility.

### LLM07:2025 System Prompt Leakage

- Keep secrets, credentials, personal data, authorization rules, and sensitive architecture out of system prompts.
- Enforce security controls with deterministic application and service code.
- Assume that users can discover system prompt content.
- Filter output for sensitive information without relying on model compliance.
- Separate agents or tool identities when tasks require different privilege levels.
- Test prompt extraction and verify that disclosure does not bypass a control.

### LLM08:2025 Vector and Embedding Weaknesses

- Apply document and field level authorization before retrieval and after ranking.
- Partition tenants and security classes in vector and embedding stores.
- Authenticate, validate, classify, and approve knowledge sources before indexing.
- Detect hidden instructions, poisoning, stale content, and conflicting sources.
- Protect embeddings and source content according to their sensitivity.
- Log retrieval activity in tamper resistant storage and test cross tenant queries.

### LLM09:2025 Misinformation

- Ground high impact output in current, trusted, and attributable sources.
- Verify factual claims, generated code, package names, citations, and calculations.
- Require qualified human review for legal, medical, financial, safety, or other high stakes decisions.
- Communicate model limitations and uncertainty without presenting confidence as proof.
- Design interfaces that distinguish generated content from verified facts.
- Test known false premises, missing evidence, conflicting sources, and hallucinated dependencies.

### LLM10:2025 Unbounded Consumption

- Limit input size, output size, context size, request rate, concurrency, tool calls, and queued actions.
- Apply quotas and budgets by authenticated user, tenant, model, and operation.
- Set timeouts and cancellation for model, retrieval, and tool operations.
- Monitor tokens, compute, memory, latency, errors, and financial cost.
- Restrict detailed probability output and other interfaces that aid model extraction.
- Degrade service safely under load and test quota, timeout, and resource exhaustion behavior.

[owasp-llm-top-ten]: https://genai.owasp.org/llm-top-10/
