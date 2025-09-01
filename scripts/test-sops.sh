#!/usr/bin/env bash

# Test script to verify SOPS secrets are working
echo "=== Testing SOPS Secrets ==="

# Check if the secrets directory exists
if [ -d "$HOME/.config/sops-nix/secrets" ]; then
  echo "✓ SOPS secrets directory exists"
  ls -la "$HOME/.config/sops-nix/secrets"
else
  echo "✗ SOPS secrets directory not found"
fi

# Check if example_key secret exists
if [ -f "$HOME/.config/sops-nix/secrets/example_key" ]; then
  echo "✓ example_key secret file exists"
  echo "Secret content: $(cat "$HOME"/.config/sops-nix/secrets/example_key)"
else
  echo "✗ example_key secret file not found"
fi

# Check if the configuration file was created
if [ -f "$HOME/.config/example-app/config.yaml" ]; then
  echo "✓ Example app config file exists"
  echo "Config content:"
  cat "$HOME/.config/example-app/config.yaml"
else
  echo "✗ Example app config file not found"
fi

# Test the helper scripts
echo "=== Testing helper scripts ==="
if command -v show-example-secret &>/dev/null; then
  echo "✓ show-example-secret script is available"
  show-example-secret
else
  echo "✗ show-example-secret script not found"
fi

if command -v example-api-call &>/dev/null; then
  echo "✓ example-api-call script is available"
  example-api-call
else
  echo "✗ example-api-call script not found"
fi
