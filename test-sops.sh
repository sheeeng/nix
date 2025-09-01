#!/bin/bash

# test-sops.sh - Test script to verify SOPS secrets are properly decrypted and accessible

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

# Function to test if a secret file exists and is readable
test_secret() {
    local secret_name=$1
    local secret_path="/run/secrets/$secret_name"

    if [ -f "$secret_path" ]; then
        if [ -r "$secret_path" ]; then
            print_status "PASS" "Secret '$secret_name' exists and is readable"

            # Check if file is not empty
            if [ -s "$secret_path" ]; then
                print_status "PASS" "Secret '$secret_name' is not empty"

                # Show first few characters (for verification, but don't expose full secret)
                local preview=$(head -c 10 "$secret_path" | od -A n -t x1 | tr -d ' \n')
                print_status "INFO" "Secret '$secret_name' preview (hex): ${preview}..."
            else
                print_status "FAIL" "Secret '$secret_name' is empty"
                return 1
            fi
        else
            print_status "FAIL" "Secret '$secret_name' exists but is not readable"
            return 1
        fi
    else
        print_status "FAIL" "Secret '$secret_name' does not exist at $secret_path"
        return 1
    fi
}

# Function to test secret permissions
test_secret_permissions() {
    local secret_name=$1
    local expected_mode=$2
    local expected_owner=$3
    local secret_path="/run/secrets/$secret_name"

    if [ -f "$secret_path" ]; then
        # Check permissions
        local actual_mode=$(stat -f "%Mp%Lp" "$secret_path" 2>/dev/null || stat -c "%a" "$secret_path" 2>/dev/null)
        if [ "$actual_mode" = "$expected_mode" ]; then
            print_status "PASS" "Secret '$secret_name' has correct permissions ($actual_mode)"
        else
            print_status "FAIL" "Secret '$secret_name' has incorrect permissions (expected: $expected_mode, actual: $actual_mode)"
        fi

        # Check owner
        local actual_owner=$(stat -f "%Su" "$secret_path" 2>/dev/null || stat -c "%U" "$secret_path" 2>/dev/null)
        if [ "$actual_owner" = "$expected_owner" ]; then
            print_status "PASS" "Secret '$secret_name' has correct owner ($actual_owner)"
        else
            print_status "FAIL" "Secret '$secret_name' has incorrect owner (expected: $expected_owner, actual: $actual_owner)"
        fi
    fi
}

# Main test execution
main() {
    print_status "INFO" "Starting SOPS secrets test..."
    print_status "INFO" "Testing secrets for host: $(hostname)"

    # Test if SOPS secrets directory exists
    if [ -d "/run/secrets" ]; then
        print_status "PASS" "SOPS secrets directory exists"
        print_status "INFO" "Secrets directory contents:"
        ls -la /run/secrets/ | sed 's/^/    /'
    else
        print_status "FAIL" "SOPS secrets directory does not exist"
        exit 1
    fi

    # Test currently configured secrets based on sops.nix configuration
    local test_failed=0

    # Test example_key (currently the only active secret)
    print_status "INFO" "Testing example_key secret..."
    if test_secret "example_key"; then
        test_secret_permissions "example_key" "400" "$(whoami)"
    else
        test_failed=1
    fi

    # Commented out secrets that are not currently active
    # Uncomment these when they are re-enabled in sops.nix

    # print_status "INFO" "Testing example_number secret..."
    # if test_secret "example_number"; then
    #     test_secret_permissions "example_number" "400" "$(whoami)"
    # else
    #     test_failed=1
    # fi

    # print_status "INFO" "Testing example_boolean secret..."
    # if test_secret "example_boolean"; then
    #     test_secret_permissions "example_boolean" "400" "$(whoami)"
    # else
    #     test_failed=1
    # fi

    # print_status "INFO" "Testing nested secret..."
    # if test_secret "example_services/example_subdirectory/example_password"; then
    #     test_secret_permissions "example_services/example_subdirectory/example_password" "400" "$(whoami)"
    # else
    #     test_failed=1
    # fi

    # Test age directory setup
    local age_dir="/Users/$(whoami)/.config/sops/age"
    if [ -d "$age_dir" ]; then
        print_status "PASS" "Age directory exists at $age_dir"

        if [ -f "$age_dir/keys.txt" ]; then
            print_status "PASS" "Age keys file exists"
        else
            print_status "INFO" "Age keys file not found (this may be expected)"
        fi
    else
        print_status "INFO" "Age directory not found (this may be expected)"
    fi

    # Final status
    if [ $test_failed -eq 0 ]; then
        print_status "PASS" "All SOPS secrets tests passed!"
        exit 0
    else
        print_status "FAIL" "Some SOPS secrets tests failed!"
        exit 1
    fi
}

# Check if running as root or with appropriate permissions
if [ "$EUID" -eq 0 ]; then
    print_status "INFO" "Running as root - all secrets should be accessible"
else
    print_status "INFO" "Running as user $(whoami) - only user-owned secrets will be accessible"
fi

main "$@"
