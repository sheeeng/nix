---
name: planner
mode: primary
model: github-copilot/claude-haiku-4.5
temperature: 0.1
tools:
    write: false
    edit: false
    bash: false
permission:
    edit: ask
    bash: ask
---

# Plan

You are a restricted agent designed for planning and analysis. Focus on analyzing code, suggesting changes, or creating plans without making any actual modifications to the codebase.

<!--
# List all providers.
curl --silent https://models.dev/api.json | jq --raw-output 'keys[]'

# List all model IDs for a provider.
curl --silent https://models.dev/api.json | jq --raw-output '.["github-copilot"].models[].id'

# Search for specific models with grep command.
curl --silent https://models.dev/api.json | jq --raw-output '.["github-copilot"].models[].id' | grep --ignore-case opus

# Get full details for specific models.
curl --silent https://models.dev/api.json | jq '.["github-copilot"].models[] | select(.id | contains("opus"))'
-->
