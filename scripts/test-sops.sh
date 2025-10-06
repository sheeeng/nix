#!/usr/bin/env bash

# Test script to verify SOPS secrets are working
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
  local status=$1
  local message=$2
  if [ "$status" = "PASS" ]; then
    echo -e "${GREEN}✓ PASS${NC}: $message"
  elif [ "$status" = "FAIL" ]; then
    echo -e "${RED}✗ FAIL${NC}: $message"
  elif [ "$status" = "INFO" ]; then
    echo -e "${YELLOW}ℹ INFO${NC}: $message"
  fi
}

echo "=== Testing SOPS Secrets ==="
print_status "INFO" "Testing secrets for host: $(hostname)"

# Function to test if a secret file exists and is readable
test_secret() {
  local secret_name=$1
  local secret_path=$2
  local level=$3 # "host" or "home"

  if [ -f "$secret_path" ]; then
    if [ -r "$secret_path" ]; then
      print_status "PASS" "$level secret '$secret_name' exists and is readable"

      # Check if file is not empty
      if [ -s "$secret_path" ]; then
        print_status "PASS" "$level secret '$secret_name' is not empty"

        # Show first few characters (for verification, but don't expose full secret)
        local preview
        preview=$(head -c 10 "$secret_path" | od -A n -t x1 | tr -d ' \n' 2>/dev/null || echo "cannot preview")
        print_status "INFO" "$level secret '$secret_name' preview (hex): ${preview}..."
      else
        print_status "FAIL" "$level secret '$secret_name' is empty"
        return 1
      fi
    else
      print_status "FAIL" "$level secret '$secret_name' exists but is not readable"
      return 1
    fi
  else
    print_status "FAIL" "$level secret '$secret_name' does not exist at $secret_path"
    return 1
  fi
}

# Test host-level secrets (/run/secrets/)
print_status "INFO" "=== Testing Host-Level Secrets ==="

# Check if the host secrets directory exists
if [ -d "/run/secrets" ]; then
  print_status "PASS" "Host secrets directory exists at /run/secrets"
  print_status "INFO" "Host secrets directory contents:"
  find /run/secrets -maxdepth 1 -exec ls -ld {} \; 2>/dev/null | sed 's/^/    /' || print_status "INFO" "Cannot list /run/secrets (permission denied - this may be normal)"
else
  print_status "FAIL" "Host secrets directory not found at /run/secrets"
fi

# Test host-level secrets based on actual secrets.txt structure
# Host-level (tp95v9lwwl.yaml) only contains keys
host_secrets=(
  "keys/age"
  tokens/github/public_repo_scope
)

for secret in "${host_secrets[@]}"; do
  test_secret "$secret" "/run/secrets/$secret" "Host"
done

# Test home-level secrets (~/.config/sops-nix/secrets/)
print_status "INFO" "=== Testing Home-Level Secrets ==="

home_secrets_dir="$HOME/.config/sops-nix/secrets"
if [ -d "$home_secrets_dir" ]; then
  print_status "PASS" "Home secrets directory exists at $home_secrets_dir"
  print_status "INFO" "Home secrets directory contents:"
  find "$home_secrets_dir" -maxdepth 1 -exec ls -ld {} \; 2>/dev/null | sed 's/^/    /' || print_status "INFO" "Cannot list home secrets directory"
else
  print_status "FAIL" "Home secrets directory not found at $home_secrets_dir"
fi

# Test home-level secrets based on actual secrets.txt structure
# Home-level (common.yaml) contains shared application secrets
home_secrets=(
  "hello"
  "passwords/cia_terminal"
  "passwords/citypower_grid"
  "passwords/door_of_durin"
  "passwords/x_files"
  "tokens/atuin"
  "tokens/github"
)

for secret in "${home_secrets[@]}"; do
  # Home secrets maintain their directory structure (no flattening)
  test_secret "$secret" "$home_secrets_dir/$secret" "Home"
done

# Test age directory setup
print_status "INFO" "=== Testing Age Key Setup ==="

age_dir="$HOME/.config/sops/age"
if [ -d "$age_dir" ]; then
  print_status "PASS" "Age directory exists at $age_dir"

  if [ -f "$age_dir/keys.txt" ]; then
    print_status "PASS" "Age keys file exists"
    # Check if the age key file is readable and not empty
    if [ -s "$age_dir/keys.txt" ]; then
      print_status "PASS" "Age keys file is not empty"
    else
      print_status "FAIL" "Age keys file is empty"
    fi
  else
    print_status "FAIL" "Age keys file not found at $age_dir/keys.txt"
  fi
else
  print_status "FAIL" "Age directory not found at $age_dir"
fi

# Test SSH host key (used for age encryption)
print_status "INFO" "=== Testing SSH Host Key ==="
if [ -f "/etc/ssh/ssh_host_ed25519_key" ]; then
  print_status "PASS" "SSH host key exists for age encryption"
else
  print_status "FAIL" "SSH host key not found - needed for SOPS decryption"
fi

# Test helper scripts and aliases
print_status "INFO" "=== Testing Helper Scripts ==="

helper_scripts=(
  "get-hello"
  "get-cia-terminal-password"
  "get-atuin-token"
  "get-github-token"
)

for script in "${helper_scripts[@]}"; do
  if command -v "$script" &>/dev/null; then
    print_status "PASS" "Helper script '$script' is available"
    # Test running the script
    if "$script" &>/dev/null; then
      print_status "PASS" "Helper script '$script' executes successfully"
    else
      print_status "INFO" "Helper script '$script' executed but may not have found secret (this is expected if secrets aren't deployed yet)"
    fi
  else
    print_status "FAIL" "Helper script '$script' not found in PATH"
  fi
done

# Test sops-helper utility
if [ -f "$HOME/.local/bin/sops-helper" ]; then
  print_status "PASS" "SOPS helper utility exists"
  if [ -x "$HOME/.local/bin/sops-helper" ]; then
    print_status "PASS" "SOPS helper utility is executable"
  else
    print_status "FAIL" "SOPS helper utility is not executable"
  fi
else
  print_status "FAIL" "SOPS helper utility not found at ~/.local/bin/sops-helper"
fi

print_status "INFO" "=== SOPS Secrets Test Summary ==="
print_status "INFO" "Test completed. If secrets are not found, you may need to:"
print_status "INFO" "1. Rebuild your NixOS/nix-darwin configuration"
print_status "INFO" "2. Ensure your secrets files (tp95v9lwwl.yaml and common.yaml) are properly encrypted"
print_status "INFO" "3. Verify that the SSH host key exists and is accessible"
print_status "INFO" "4. Check that the age key has been properly extracted to ~/.config/sops/age/keys.txt"
