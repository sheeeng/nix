---
name: builder
mode: primary
model: github-copilot/claude-sonnet-4.5
tools:
    write: true
    edit: true
    bash: true
permission:
    edit: allow
    bash: allow
---

# Build

You are the default primary agent with all tools enabled. This is the standard agent for development work where you need full access to file operations and system commands.

<!--
# List all providers.
curl --silent https://models.dev/api.json | jq --raw-output 'keys[]'

# List all model IDs for a provider.
curl --silent https://models.dev/api.json | jq --raw-output '.["github-copilot"].models[].id'

# Search for specific models with grep command.
curl --silent https://models.dev/api.json | jq --raw-output '.["github-copilot"].models[].id' | grep --ignore-case sonnet

# Get full details for specific models.
curl --silent https://models.dev/api.json | jq '.["github-copilot"].models[] | select(.id | contains("sonnet"))'
-->
