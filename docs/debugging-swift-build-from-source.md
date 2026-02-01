# Debugging Swift Building from Source on Darwin

This document captures the debugging steps and commands used to investigate and fix the issue of Swift 5.10.1 building from source instead of using the binary cache.

## Problem Statement

When running `darwin-rebuild switch --flake .`, Swift 5.10.1 was being built from source, taking 30-60+ minutes. The dependency graph showed:

```text
┏━ Dependency Graph:
┃                                        ┌─ ⏵ swift-5.10.1 ⏱ 1m29s
┃                                     ┌─ ⏸ clang-wrapper-21.1.8
┃                                  ┌─ ⏸ swift-wrapper-5.10.1
┃                               ┌─ ⏸ dotnet-stage0-vmr-8.0.23
┃                            ┌─ ⏸ dotnet-stage0-sdk-8.0.123
┃                         ┌─ ⏸ dotnet-vmr-8.0.23
┃                      ┌─ ⏸ dotnet-runtime-8.0.23
┃                   ┌─ ⏸ dotnet-runtime-wrapped-8.0.23
┃                ┌─ ⏸ dotnet-sdk-8.0.417
┃             ┌─ ⏸ dotnet-sdk-wrapped-8.0.417
┃          ┌─ ⏸ pre-commit-4.5.1
┃       ┌─ ⏸ home-manager-path
┃    ┌─ ⏸ user-environment
┃ ┌─ ⏸ etc
┃ ⏸ darwin-system-26.05.0fc4e7a
```

## Debugging Commands

### 1. Identify What Package Depends on Swift

Use `nix why-depends` to trace the dependency chain:

```bash
# Check why pre-commit depends on Swift
nix why-depends --derivation nixpkgs#pre-commit nixpkgs#swift

# Example output:
# /nix/store/w0nb2ixrrzq6vp0ilkk04c3zidrc3n18-pre-commit-4.5.1.drv
# └───/nix/store/jq31db9iyfcg6nvr66rm1mrc76xmfmlv-dotnet-sdk-wrapped-8.0.417.drv
#     └───/nix/store/f4zrvdh3vdgnmwa8ypnaz4fwmdpdh15i-dotnet-sdk-8.0.417.drv
#         └───/nix/store/bnnwqk69rz03m2zrc57hn905j81ndg82-dotnet-runtime-wrapped-8.0.23.drv
#             └───/nix/store/7qnd5shqbxrcmkz4hwjwzf2z9yglmzd9-dotnet-runtime-8.0.23.drv
#                 └───/nix/store/wz16r6z2435qarwxmhzv497kih32vjzg-dotnet-vmr-8.0.23.drv
#                     └───/nix/store/90gi7sjbxghqcbzjwp4if8rnwkp7h959-swift-wrapper-5.10.1.drv
```

This revealed the dependency chain:

```text
pre-commit → dotnet-sdk-wrapped → dotnet-sdk → dotnet-runtime-wrapped → dotnet-runtime → dotnet-vmr → swift-wrapper → swift
```

### 2. Search for Swift References in Configuration

Use grep to find all references to Swift, pre-commit, and dotnet in your Nix files:

```bash
# Search for swift, pre-commit, or dotnet references
grep -r "swift\|pre-commit\|dotnet" --include="*.nix" .

# Or use ripgrep for better performance
rg "swift|pre-commit|dotnet" --type nix
```

### 3. Check if a Package Is in the Binary Cache

```bash
# Check if a specific derivation is cached
curl -sI "https://cache.nixos.org/<hash>.narinfo" | head -1

# If you get HTTP/2 404, the package is not cached
# If you get HTTP/2 200, the package is cached
```

### 4. Check the Hydra Build Status

Visit the Hydra build job page for the package:

- Swift on darwin: https://hydra.nixos.org/job/nixpkgs/trunk/swift.aarch64-darwin
- Swift on unstable: https://hydra.nixos.org/job/nixpkgs/unstable/swift.aarch64-darwin

Or use the API:

```bash
# Get recent build information
curl -sL "https://hydra.nixos.org/job/nixpkgs/trunk/swift.aarch64-darwin"
```

### 5. Check the Date of a Nixpkgs Commit

Useful for finding when a package broke:

```bash
# Get commit date and message
curl -s "https://api.github.com/repos/NixOS/nixpkgs/commits/<commit-hash>" | jq -r '.commit.committer.date, .commit.message' | head -5
```

### 6. Verify Overlay Syntax

```bash
# Check if an overlay file has valid Nix syntax
nix-instantiate --parse overlays/default.nix > /dev/null && echo "Syntax OK"

# If there's an error, it will show the syntax issue
nix-instantiate --parse overlays/default.nix
```

### 7. Check Flake Evaluation

```bash
# Check if the flake evaluates without building
nix flake check --no-build

# Show flake outputs
nix flake show
```

### 8. Evaluate Specific Package Versions

```bash
# Check Swift version in a specific nixpkgs revision
nix eval --raw "github:NixOS/nixpkgs/<revision>#swift.version"

# Check Swift version in nixos-24.11
nix eval --raw "github:NixOS/nixpkgs/nixos-24.11#swift.version"
```

### 9. Check Path Info for Cached Packages

```bash
# Check if a package is available in a remote store
nix path-info --store https://cache.nixos.org "github:NixOS/nixpkgs/<revision>#swiftPackages.swift"
```

## Root Cause Analysis

### Issue Summary

Swift 5.10.1 was failing to build on darwin due to an incompatibility with clang 21.1.8. This was tracked in [NixOS/nixpkgs#483584](https://github.com/NixOS/nixpkgs/issues/483584).

The error message from the build:

```text
/nix/var/nix/builds/.../swift/include/swift/SIL/SILInstruction.h:1150:17: warning: 'offsetof' on non-standard-layout type 'NonSingleValueInstruction' [-Winvalid-offsetof]
ninja: build stopped: subcommand failed.
```

### Why Overlays Didn't Work Initially

The original overlay had a structural issue:

```nix
# BROKEN: Creates nested structure swiftPackages.swiftPackages
swiftPackages =
  let
    pkgsSwift = import inputs.nixpkgs-swift { inherit (final) system; };
  in
  {
    inherit (pkgsSwift) swiftPackages swift;
  };
```

This created `swiftPackages.swiftPackages` and `swiftPackages.swift` instead of replacing the top-level `swiftPackages`.

Additionally, overlays only replace top-level packages—they don't transitively affect packages that have already been built with their own dependencies. So even with a correct overlay for `swift`, the `pre-commit` package still used the broken Swift through its `dotnet-sdk` dependency.

## Solution

### Fixed Overlay

The corrected overlay in `overlays/default.nix`:

```nix
{ inputs, ... }:
let
  # Import nixpkgs-swift for packages that need a working Swift.
  # @upstream-issue https://github.com/NixOS/nixpkgs/issues/483584
  mkPkgsSwift =
    system: config:
    import inputs.nixpkgs-swift {
      inherit system config;
    };
in
{
  additions = _final: _prev: { };

  modifications = final: prev: {
    unstable = inputs.nixpkgs.legacyPackages.${final.stdenv.hostPlatform.system};

    # Pin swift to working version from a nixpkgs revision where it builds.
    # @upstream-issue https://github.com/NixOS/nixpkgs/issues/483584
    # This properly replaces swiftPackages and swift at the top level.
    inherit (mkPkgsSwift final.system final.config) swiftPackages swift;

    # Also inherit dotnetCorePackages from the pinned nixpkgs to avoid Swift rebuild.
    # The dotnet SDK depends on Swift, so we need the entire package set from the pinned revision.
    inherit (mkPkgsSwift final.system final.config) dotnetCorePackages dotnet-sdk dotnet-runtime;

    # Inherit pre-commit from pinned nixpkgs to ensure it uses the cached dotnet/swift.
    # This is the most reliable way to avoid building Swift from source.
    inherit (mkPkgsSwift final.system final.config) pre-commit;

    # ... rest of overlay
  };
}
```

### Key Fixes

1. **Created a reusable helper function** `mkPkgsSwift` to import the pinned nixpkgs-swift revision with proper config inheritance.

1. **Fixed the swiftPackages/swift inheritance** using `inherit` to properly replace at the top level.

1. **Added dotnet package inheritance** since `pre-commit` → `dotnet-sdk` → `swift`.

1. **Added pre-commit inheritance** to ensure the entire package uses the cached Swift.

### Flake Input for Pinned Swift

In `flake.nix`:

```nix
inputs = {
  # @upstream-issue https://github.com/NixOS/nixpkgs/issues/483584
  nixpkgs-swift.url = "git+ssh://git@github.com/nixos/nixpkgs.git?rev=70801e06d9730c4f1704fbd3bbf5b8e11c03a2a7&shallow=1";
};
```

## Alternative Solutions

### Option 1: Remove pre-commit from Packages

The fastest fix is to comment out `pre-commit` from your packages:

```nix
# In home-manager/packages.nix, shell.nix, etc.
# pre-commit  # Disabled due to Swift build issue
```

You can still use pre-commit via:

- `pipx install pre-commit`
- A separate devShell with pre-commit from an older nixpkgs

### Option 2: Pin to a Stable Nixpkgs

Use nixos-24.11 or another stable channel where Swift was working:

```nix
nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
```

Then inherit `pre-commit` from `nixpkgs-stable`.

### Option 3: Wait for Upstream Fix

Monitor the GitHub issue for a fix:

- [NixOS/nixpkgs#483584](https://github.com/NixOS/nixpkgs/issues/483584)

## Useful Links

- [NixOS Binary Cache](https://cache.nixos.org)
- [Hydra Build Status](https://hydra.nixos.org)
- [Nixpkgs Issue Tracker](https://github.com/NixOS/nixpkgs/issues)
- [nix why-depends documentation](https://nix.dev/manual/nix/stable/command-ref/new-cli/nix3-why-depends)

## Lessons Learned

1. **Overlays don't transitively replace dependencies** - If package A depends on B which depends on C, overriding C in an overlay won't affect A unless you also override A or B.

1. **Always check Hydra build status** before assuming a package is cached.

1. **Use `nix why-depends`** to trace dependency chains when investigating build issues.

1. **Pin problematic packages to known-good revisions** when upstream is broken.

1. **Consider the entire dependency chain** when pinning packages—you may need to pin multiple packages.

1. **Pinned revisions may also be broken** - Just because you pin to a specific revision doesn't mean that revision has working builds. You must verify the pinned revision actually has cached binaries.

## Why the Overlay Approach Was Reverted

### The Problem

The overlay approach attempted to pin Swift and related packages to a specific nixpkgs revision (`70801e06d9730c4f1704fbd3bbf5b8e11c03a2a7` from January 22, 2026). However, this approach failed because:

1. **The pinned revision also had broken Swift** - The Swift build failure existed before the GitHub issue was opened on January 25, 2026. The pinned revision from January 22 was already affected by the clang 21 incompatibility.

1. **No cached binaries available** - Even with a correctly structured overlay, if the pinned nixpkgs revision doesn't have Swift successfully built and cached in Hydra, Nix will still attempt to build from source.

1. **The derivation hash remained the same** - After applying the overlay, the build still used the same derivation (`/nix/store/lghszxcp38ydvdlmcmkk7w1fsszyp7cp-swift-5.10.1.drv`), indicating the overlay wasn't changing the actual Swift being used, or both revisions produced the same broken derivation.

### What Was Reverted

The overlay in `overlays/default.nix` was changed from:

```nix
# ATTEMPTED FIX (reverted)
{ inputs, ... }:
let
  mkPkgsSwift =
    system: config:
    import inputs.nixpkgs-swift {
      inherit system config;
    };
in
{
  modifications = final: prev: {
    inherit (mkPkgsSwift final.system final.config) swiftPackages swift;
    inherit (mkPkgsSwift final.system final.config) dotnetCorePackages dotnet-sdk dotnet-runtime;
    inherit (mkPkgsSwift final.system final.config) pre-commit;
    # ...
  };
}
```

Back to:

```nix
# CURRENT (overlay disabled)
{ inputs, ... }:
{
  modifications = final: prev: {
    # NOTE: Swift/dotnet overlay disabled - the pinned nixpkgs-swift revision also has Swift broken.
    # @upstream-issue https://github.com/NixOS/nixpkgs/issues/483584
    # The workaround is to disable pre-commit until upstream fixes Swift.
    # TODO: Re-enable once Swift builds successfully on darwin.
    # ...
  };
}
```

### Files Modified to Disable pre-commit

The following files were modified to comment out `pre-commit`:

| File                                       | Change                                                       |
| ------------------------------------------ | ------------------------------------------------------------ |
| `home-manager/packages.nix:146`            | Commented out `pre-commit`                                   |
| `home-manager/packages/git/default.nix:39` | Commented out `pre-commit`                                   |
| `shell.nix:48-49`                          | Commented out `pre-commit` and `pre-commit-hook-ensure-sops` |
| `shell.nix:80`                             | Commented out `pre-commit` in minimal-shell                  |

## Alternatives to Nix-Managed pre-commit

Since `pre-commit` cannot be installed via Nix until Swift is fixed upstream, here are alternative approaches:

### Option 1: Use pipx (Recommended)

[pipx](https://pipx.pypa.io/) installs Python applications in isolated environments:

```bash
# Install pipx if not already installed
brew install pipx
pipx ensurepath

# Install pre-commit
pipx install pre-commit

# Verify installation
pre-commit --version

# Set up pre-commit in your repository
cd /path/to/your/repo
pre-commit install
```

**Pros:**

- Isolated from system Python
- Easy to update: `pipx upgrade pre-commit`
- Works immediately

**Cons:**

- Not managed by Nix
- Requires separate installation step

### Option 2: Use nix-shell with Older Nixpkgs

Run pre-commit in a shell using an older nixpkgs where Swift was working:

```bash
# Use nixos-24.11 which has working Swift
nix-shell -p pre-commit -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-24.11.tar.gz

# Or create an alias in your shell config
alias pre-commit='nix-shell -p pre-commit -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-24.11.tar.gz --run "pre-commit $*"'
```

**Pros:**

- Still uses Nix
- Reproducible

**Cons:**

- Slower startup (downloads/builds on first use)
- Uses older package versions

### Option 3: Use Homebrew

```bash
brew install pre-commit
```

**Pros:**

- Simple installation
- Well-maintained on macOS

**Cons:**

- Not managed by Nix
- May conflict with Nix packages

### Option 4: Use Docker

Run pre-commit in a container:

```bash
# Create alias
alias pre-commit='docker run --rm -v $(pwd):/app -w /app python:3.12-slim pip install pre-commit && pre-commit'

# Or use a dedicated pre-commit image
docker run --rm -v $(pwd):/app -w /app ghcr.io/pre-commit/pre-commit run --all-files
```

**Pros:**

- Completely isolated
- Consistent across machines

**Cons:**

- Requires Docker
- Slower than native execution

### Option 5: Add Dedicated Flake Input for pre-commit

Add a separate nixpkgs input specifically for pre-commit:

```nix
# In flake.nix
inputs = {
  # Use nixos-24.11 for pre-commit (has working Swift)
  nixpkgs-precommit.url = "github:nixos/nixpkgs/nixos-24.11";
};

# In your configuration
let
  pkgs-precommit = import inputs.nixpkgs-precommit {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  home.packages = [
    pkgs-precommit.pre-commit
  ];
}
```

**Pros:**

- Managed by Nix
- Explicit version pinning
- Works with flake lock

**Cons:**

- Adds another nixpkgs to evaluate
- May have version mismatches with other packages

### Option 6: Wait for Upstream Fix

Monitor the GitHub issue and re-enable pre-commit once fixed:

- **Issue:** [NixOS/nixpkgs#483584](https://github.com/NixOS/nixpkgs/issues/483584)
- **Check Hydra:** https://hydra.nixos.org/job/nixpkgs/trunk/swift.aarch64-darwin

To check if Swift is fixed:

```bash
# Check if Swift builds on current nixpkgs
nix build nixpkgs#swift --dry-run 2>&1 | grep -q "will be built" && echo "Still broken" || echo "Fixed!"
```

## Re-enabling pre-commit After Upstream Fix

Once Swift is fixed in nixpkgs, follow these steps:

1. **Update flake.lock:**

    ```bash
    nix flake update nixpkgs
    ```

1. **Verify Swift is cached:**

    ```bash
    nix build nixpkgs#swift --dry-run
    # Should show "will be fetched" not "will be built"
    ```

1. **Uncomment pre-commit in all files:**
    - `home-manager/packages.nix`
    - `home-manager/packages/git/default.nix`
    - `shell.nix` (both locations)

1. **Remove the nixpkgs-swift input** from `flake.nix` if no longer needed.

1. **Rebuild:**

    ```bash
    darwin-rebuild switch --flake .
    ```
