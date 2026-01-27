# Nix Cache and WebKitGTK Build Report

## Executive Summary

Your NixOS system was building WebKitGTK from source (~8500 compilation units, 20+ minutes) because your `flake.lock` was pinned to a bleeding-edge nixpkgs revision that Hydra had not yet fully cached.

## Root Cause Analysis

### The Problem

| Your Configuration | Hydra-Cached Channel |
|--------------------|----------------------|
| `nixpkgs-unstable` (rev `13b0f9e...`) | `nixos-unstable` (rev `c5296fdd...`) |
| Updated: Jan 26, 2026 | Updated: Jan 23, 2026 |
| **Not fully cached** | **Fully cached** |

### Why This Happens

1. **`nixpkgs-unstable`** tracks the latest commits to nixpkgs master branch
2. **`nixos-unstable`** only advances when Hydra has successfully built most packages
3. Large packages like WebKitGTK take hours to build on Hydra
4. If you update your flake before Hydra finishes, you get cache misses

### The Build You Experienced

```
webkitgtk> [2756/8476] Building CXX object ...
```

WebKitGTK is one of the largest packages in nixpkgs:
- ~8500 compilation units
- 20-60 minutes build time depending on hardware
- Required by GNOME desktop (evolution-data-server, sushi, epiphany, etc.)

## Changes Made

### 1. Changed nixpkgs Channel (flake.nix)

**Before:**
```nix
nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
```

**After:**
```nix
nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
nixpkgs-darwin.url = "github:nixos/nixpkgs/nixos-unstable";
```

### 2. Added Extra Binary Caches (hosts/nixos/default.nix)

**Added substituters:**
```nix
substituters = [
  # ... existing caches ...
  "https://numtide.cachix.org"
  "https://cache.garnix.io"
];
```

**Added trusted public keys:**
```nix
trusted-public-keys = [
  # ... existing keys ...
  "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ber+6DVwQ5REeEhfBc3HIM2+8s="
  "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
];
```

## Understanding Nix Channels

### Channel Comparison

| Channel | Description | Cache Status |
|---------|-------------|--------------|
| `nixos-unstable` | Passes Hydra jobset tests | Always cached |
| `nixpkgs-unstable` | Latest commits | May not be cached |
| `nixos-24.11` | Stable release | Always cached |
| `nixpkgs-24.11-darwin` | Stable for macOS | Always cached |

### How to Check Cache Status

```bash
# Check if a package is cached
nix path-info --store https://cache.nixos.org nixpkgs#webkitgtk_6_0

# Check the current nixos-unstable channel revision
curl -sL "https://channels.nixos.org/nixos-unstable/git-revision"

# Check Hydra build status
# Visit: https://hydra.nixos.org/jobset/nixos/trunk-combined
```

## Your Current Cache Configuration

### Substituters (Binary Caches)

| Cache | Purpose | Priority |
|-------|---------|----------|
| `cache.nixos.org` | Official NixOS cache | 10 (highest) |
| `nix-community.cachix.org` | Community packages | 20 |
| `devenv.cachix.org` | devenv packages | default |
| `nixpkgs-python.cachix.org` | Python packages | default |
| `ryanccn.cachix.org` | ryanccn's packages | default |
| `nix-gaming.cachix.org` | Gaming packages | default |
| `nix-citizen.cachix.org` | Star Citizen | default |
| `cache.nixos-cuda.org` | CUDA packages | default |
| `numtide.cachix.org` | Numtide packages | default |
| `cache.garnix.io` | Garnix CI builds | default |

### How Nix Cache Lookup Works

1. Nix computes the derivation hash for a package
2. Nix queries each substituter in priority order
3. If found, downloads the pre-built binary (NAR)
4. If not found in any cache, builds from source

## Preventing Future Cache Misses

### Best Practices

1. **Use `nixos-unstable` instead of `nixpkgs-unstable`**
   - Only advances when Hydra has built packages
   - Guarantees cache hits for most packages

2. **Check before updating**
   ```bash
   # See what will change
   nix flake update --dry-run
   
   # Check Hydra status before updating
   curl -sL "https://channels.nixos.org/nixos-unstable/git-revision"
   ```

3. **Pin to specific revisions for stability**
   ```nix
   nixpkgs.url = "github:nixos/nixpkgs/c5296fdd05cfa2c187990dd909864da9658df755";
   ```

4. **Use `--accept-flake-config` for flake-provided caches**
   ```bash
   nix build --accept-flake-config
   ```

### Packages That Commonly Cause Long Builds

| Package | Build Time | Pulled In By |
|---------|------------|--------------|
| `webkitgtk` | 20-60 min | GNOME, Evolution, Epiphany |
| `llvm` | 15-30 min | Rust, Mesa, many compilers |
| `gcc` | 20-40 min | Bootstrap, cross-compilation |
| `firefox` | 30-60 min | Direct installation |
| `chromium` | 60-120 min | Direct installation |
| `libreoffice` | 30-60 min | Direct installation |
| `mesa` | 10-20 min | Graphics drivers |

## GitHub API Rate Limiting Issue

### Symptom

```
error: unable to download 'https://api.github.com/repos/...': HTTP error 401
{
  "message": "Bad credentials",
  "status": "401"
}
```

### Cause

Your GitHub access token (stored in sops secrets at `tokens/github/public_repo_scope`) was expired or invalid.

### Solution

1. Generate a new GitHub Personal Access Token at https://github.com/settings/tokens
2. Update the token in your `nix-secrets` repository
3. Rebuild: `sudo nixos-rebuild switch --flake .#nixos`

### Temporary Workaround

```bash
# Override the bad token temporarily
NIX_CONFIG="access-tokens =" nix flake update

# Or set a new token for the session
NIX_CONFIG="access-tokens = github.com=ghp_YOUR_TOKEN" nix flake update
```

## File Locations Reference

| File | Purpose |
|------|---------|
| `flake.nix` | Flake inputs including nixpkgs URL |
| `flake.lock` | Pinned revisions of all inputs |
| `hosts/nixos/default.nix` | NixOS host configuration including cache settings |
| `hosts/linux/sops.nix` | sops-nix configuration for secrets |
| `/etc/nix/nix.conf` | Generated nix configuration (read-only) |
| `/run/secrets/rendered/nix-access-token` | Decrypted GitHub token |

## Commands Reference

```bash
# Update flake inputs
nix flake update

# Update specific inputs only
nix flake update nixpkgs nixpkgs-darwin

# Rebuild NixOS
sudo nixos-rebuild switch --flake .#nixos

# Check current nix settings
nix show-config | grep -E "(substituters|access-tokens)"

# Verify a package is cached
nix path-info --store https://cache.nixos.org nixpkgs#webkitgtk_6_0

# See what would be built vs fetched
nix build --dry-run .#nixosConfigurations.nixos.config.system.build.toplevel
```

## Conclusion

By switching from `nixpkgs-unstable` to `nixos-unstable`, your future `nix flake update` operations will only pull in nixpkgs revisions that Hydra has fully built. This ensures WebKitGTK and other large packages are always fetched from the binary cache instead of being built locally.
