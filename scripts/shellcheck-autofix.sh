#!/usr/bin/env bash

# set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
  local status=$1
  local message=$2
  if [ "$status" = "PASS" ]; then
    echo -e "${GREEN}✓${NC} $message"
  elif [ "$status" = "FAIL" ]; then
    echo -e "${RED}✗${NC} $message"
  elif [ "$status" = "INFO" ]; then
    echo -e "${YELLOW}ℹ${NC} $message"
  fi
}

fix_file() {
  local file=$1

  if [[ ! -f $file ]]; then
    print_status "FAIL" "File does not exist: $file"
    return 1
  fi

  # Check if it's a shell script
  if [[ $file == *.sh ]] || [[ $file == *.bash ]] || [[ "$(head -n1 "$file" 2>/dev/null)" =~ ^#!.*/(ba)?sh ]]; then
    print_status "INFO" "Checking $file..."

    # Get shellcheck diff output
    local diff_output
    if diff_output=$(shellcheck --format=diff "$file" 2>/dev/null); then
      if [[ -n $diff_output ]]; then
        print_status "INFO" "Applying fixes to $file..."
        echo "$diff_output" | patch -p1 -s 2>/dev/null || {
          print_status "FAIL" "Failed to apply patch to $file"
          echo "$diff_output"
          return 1
        }
        print_status "PASS" "Fixed $file"
      else
        print_status "PASS" "No fixes needed for $file"
      fi
    else
      print_status "FAIL" "Shellcheck failed on $file"
      return 1
    fi
  else
    print_status "INFO" "Skipping non-shell file: $file"
  fi
}

main() {
  print_status "INFO" "Starting shellcheck autofix..."

  local files=()
  local failed=0

  if [[ $# -eq 0 ]]; then
    # Find all shell files in the current directory and subdirectories
    mapfile -t files < <(find . -name "*.sh" -o -name "*.bash" -o -type f -executable -exec grep -l '^#!.*sh' {} \; 2>/dev/null | grep -v '/\.' | sort)
  else
    files=("$@")
  fi

  if [[ ${#files[@]} -eq 0 ]]; then
    print_status "INFO" "No shell files found"
    return 0
  fi

  print_status "INFO" "Found ${#files[@]} file(s) to check"

  for file in "${files[@]}"; do
    if ! fix_file "$file"; then
      ((failed++))
    fi
  done

  if [[ $failed -eq 0 ]]; then
    print_status "PASS" "All files processed successfully"
  else
    print_status "FAIL" "$failed file(s) had issues"
    exit 1
  fi
}

main "$@"
