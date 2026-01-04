#!/usr/bin/env bash

# Wrapper for darwin-rebuild that shows package diff with nvd
# Usage: ./scripts/darwin-rebuild-diff.sh [darwin-rebuild-args...]
#
# This script builds the darwin configuration and then compares the result
# with the current system using nvd (Nix Version Diff).
#
# Based on: https://sr.ht/~khumba/nvd/
# Adapted from: nixos-rebuild build "$@" && nvd diff /run/current-system result

set -o errexit -o nounset -o pipefail

FLAKE_DIRECTORY="${HOME}/github/sheeeng/nix"

echo "🔨 Building darwin configuration..."
darwin-rebuild build --flake "${FLAKE_DIRECTORY}" "$@"

echo ""
if [ -e /run/current-system ]; then
  echo "📊 Comparing package versions..."
  echo "================================"
  nvd --nix-bin-dir="$(dirname "$(command -v nix)")" --color=always diff /run/current-system result
  echo "================================"
  echo ""
  echo "✅ Build complete. To activate: sudo darwin-rebuild switch --flake ${FLAKE_DIRECTORY}"
else
  echo "⚠️  No current system found (initial installation?)"
  echo "✅ Build complete. To activate: sudo darwin-rebuild switch --flake ${FLAKE_DIRECTORY}"
fi
