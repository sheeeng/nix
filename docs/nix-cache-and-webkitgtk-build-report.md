# Nix Cache and WebKitGTK Build Report

## Executive Summary

Your NixOS system was building WebKitGTK from source (~8500 compilation units, 20+ minutes) due to two issues:

1. **Initial issue:** Your `flake.lock` was pinned to a bleeding-edge `nixpkgs-unstable` revision that Hydra had not yet fully cached.
1. **Hidden issue:** Even after switching to `nixos-unstable`, the `nodejs-skip-tests` overlay was modifying nodejs, causing a cascading rebuild of all packages that depend on nodejs in their build process—including WebKitGTK.

## Root Cause Analysis

### Issue 1: Wrong Nixpkgs Channel

| Your Configuration                       | Hydra-Cached Channel                 |
| ---------------------------------------- | ------------------------------------ |
| `nixpkgs-unstable` (rev `13b0f9e...`)    | `nixos-unstable` (rev `c5296fdd...`) |
| Updated: Jan 26, 2026                    | Updated: Jan 23, 2026                |
| **Not fully cached**                     | **Fully cached**                     |

#### Why This Happens

1. **`nixpkgs-unstable`** tracks the latest commits to nixpkgs master branch
1. **`nixos-unstable`** only advances when Hydra has successfully built most packages
1. Large packages like WebKitGTK take hours to build on Hydra
1. If you update your flake before Hydra finishes, you get cache misses

### Issue 2: Overlay Causing Hash Mismatch (The Hidden Culprit)

Even after switching to `nixos-unstable`, WebKitGTK was still building from source. The debugging process revealed:

```bash
# Official nixpkgs webkitgtk path (cached)
$ nix eval --raw 'nixpkgs#webkitgtk_6_0.outPath'
/nix/store/69gsrb94wyfnk56rn34g5g75sk6xz3rb-webkitgtk-2.50.4+abi=6.0

# Your config's webkitgtk path (NOT cached - different hash!)
$ nix eval --raw '.#nixosConfigurations.nixos.pkgs.webkitgtk_6_0.outPath'
/nix/store/zzpima0whqvf7sk76ccx4fvn78dyd91l-webkitgtk-2.50.4+abi=6.0
```

The hashes were different! Further investigation revealed:

```bash
# Official nodejs version
$ nix eval --raw 'nixpkgs#nodejs.outPath'
/nix/store/cikdc61gfwvdma6y0p9b5d5d448aqcv6-nodejs-24.12.0

# Your config's nodejs version (DIFFERENT!)
$ nix eval --raw '.#nixosConfigurations.nixos.pkgs.nodejs.outPath'
/nix/store/mrk5wd4ayfw1k366xd9qhh6660mcavd0-nodejs-24.13.0
```

The `nodejs-skip-tests` overlay was modifying nodejs, which caused a **cascading effect**:

- Modified nodejs → different hash
- Packages that use nodejs in their build → different hash
- WebKitGTK (uses nodejs build tools) → different hash → **cache miss**

### The Build You Experienced

```text
webkitgtk> [2756/8476] Building CXX object ...
```

WebKitGTK is one of the largest packages in nixpkgs:

- ~8500 compilation units
- 20-60 minutes build time depending on hardware
- Required by GNOME desktop (evolution-data-server, sushi, epiphany, etc.)

## Debugging Steps Performed

### Step 1: Check Current Nixpkgs Revision

```bash
# Get your flake's nixpkgs revision
$ grep -A5 '"nixpkgs_7"' flake.lock | grep rev

# Get the official cached nixos-unstable revision
$ curl -sL "https://channels.nixos.org/nixos-unstable/git-revision"
c5296fdd05cfa2c187990dd909864da9658df755

# Alternative: Query Prometheus for cached revision
$ curl -s "https://prometheus.nixos.org/api/v1/query?query=channel_revision" | \
    jq -r '.data.result[] | select(.metric.channel == "nixos-unstable") | .metric.revision'
```

### Step 2: Verify Package Is in Cache

```bash
# Get the official store path
$ nix eval --raw 'nixpkgs#webkitgtk_6_0.outPath'
/nix/store/69gsrb94wyfnk56rn34g5g75sk6xz3rb-webkitgtk-2.50.4+abi=6.0

# Check if it exists in cache.nixos.org (HTTP 200 = cached)
$ curl -sI "https://cache.nixos.org/69gsrb94wyfnk56rn34g5g75sk6xz3rb.narinfo" | head -1
HTTP/2 200
```

### Step 3: Compare Your Config's Path with Official

```bash
# Your config's webkitgtk path
nix eval --raw '.#nixosConfigurations.nixos.pkgs.webkitgtk_6_0.outPath'
/nix/store/zzpima0whqvf7sk76ccx4fvn78dyd91l-webkitgtk-2.50.4+abi=6.0

# If the hash differs from official, something in your config is modifying it!
```

### Step 4: Find the Modifying Overlay

```bash
# Compare nodejs paths (a common culprit)
$ nix eval --raw 'nixpkgs#nodejs.outPath'
$ nix eval --raw '.#nixosConfigurations.nixos.pkgs.nodejs.outPath'

# If different, check for nodejs overlays
$ grep -r "nodejs" overlays/
$ grep -r "nodejs" flake.nix

# Check all overlays and overrides in your config
$ grep -r "overrideAttrs\|override\|overlay" flake.nix overlays/
```

### Step 5: Check Input Derivations (What WebKitGTK Depends On)

```bash
# List all input derivations for webkitgtk
$ nix derivation show '.#nixosConfigurations.nixos.pkgs.webkitgtk_6_0' 2>/dev/null | \
    jq -r 'to_entries[0].value.inputDrvs | keys | .[]' | head -20
```

This shows all the packages webkitgtk depends on. If any of these have been modified by an overlay, webkitgtk will have a different hash.

### Step 6: Verify Fix

```bash
# After removing the overlay, check the new path
$ nix eval --raw '.#nixosConfigurations.nixos.pkgs.webkitgtk_6_0.outPath'
/nix/store/9b70p38p8v521fhf8q4m40gr8c38xdrf-webkitgtk-2.50.4+abi=6.0

# Verify it's cached
$ curl -sI "https://cache.nixos.org/9b70p38p8v521fhf8q4m40gr8c38xdrf.narinfo" | head -1
HTTP/2 200

# Get full cache info to confirm
$ curl -s "https://cache.nixos.org/9b70p38p8v521fhf8q4m40gr8c38xdrf.narinfo" | head -10
```

## Commands That Failed or Timed Out (and Why)

During debugging, some commands did not work as expected. Understanding why helps avoid frustration:

### 1. `nix path-info --store` with Wrong Syntax

```bash
# FAILED: This tries to UPLOAD, not query
$ nix path-info --store https://cache.nixos.org 'nixpkgs#webkitgtk_6_0'
error: while uploading to HTTP binary cache at 'https://cache.nixos.org': 
       HTTP error 404
```

**Why it failed:** The `--store` flag tells nix to use that store for the operation. Since cache.nixos.org is read-only, it fails when nix tries to write. Use `curl` to check cache status instead.

**Correct approach:**

```bash
# Use curl to check if a hash exists in cache
$ curl -sI "https://cache.nixos.org/HASH.narinfo" | head -1
```

### 2. `nix why-depends` Timeout

```bash
# TIMED OUT: Takes too long for large dependency trees
$ nix why-depends --quiet '.#nixosConfigurations.nixos.config.system.build.toplevel' \
    'nixpkgs#webkitgtk_6_0'
# (no output after 2+ minutes)
```

**Why it failed:** The `why-depends` command traces the entire dependency graph, which can be enormous for a full NixOS system. WebKitGTK has thousands of transitive dependencies.

**Workaround:** Use `--derivation` flag and limit output, or just compare store paths directly:

```bash
# Compare paths instead - much faster
$ nix eval --raw 'nixpkgs#webkitgtk_6_0.outPath'
$ nix eval --raw '.#nixosConfigurations.nixos.pkgs.webkitgtk_6_0.outPath'
```

### 3. Accessing Nested Attributes That Don't Exist

```bash
# FAILED: Wrong attribute path
$ nix eval --raw '.#nixosConfigurations.nixos.pkgs.webkitgtk_6_0.src.rev'
error: flake does not provide attribute '...src.rev'
```

**Why it failed:** Not all packages have a `src.rev` attribute. The attribute path structure varies by package.

**Correct approach:** Use `outPath` which always exists:

```bash
nix eval --raw '.#nixosConfigurations.nixos.pkgs.webkitgtk_6_0.outPath'
```

### 4. User-Level nix.conf Not Taking Effect

```bash
# Created ~/.config/nix/nix.conf with access-tokens
# But nix flake update still failed with 401
```

**Why it failed:** The system-level `/etc/nix/nix.conf` includes a bad token via `!include`. System config takes precedence, and the bad token is being used.

**Workaround:** Use `NIX_CONFIG` environment variable which has highest precedence:

```bash
NIX_CONFIG="access-tokens =" nix flake update
```

### 5. Cannot Edit /etc/nix/nix.conf Even as Root

```bash
$ sudo vim /etc/nix/nix.conf
# File is read-only!
```

**Why it failed:** On NixOS, `/etc/nix/nix.conf` is a symlink to the Nix store:

```bash
$ ls -la /etc/nix/nix.conf
lrwxrwxrwx 1 root root 24 /etc/nix/nix.conf -> /etc/static/nix/nix.conf
```

The Nix store is **immutable by design**. Even root cannot modify files there.

**Solution:** Modify the configuration in your Nix files and rebuild:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

### 6. `sops` Editor Crash

```bash
$ sops secrets/hosts/nixos.yaml
thread 'main' panicked at crossterm-0.28.1/src/event/read.rs:39:30:
reader source not set
```

**Why it failed:** The default editor (helix) crashed because it couldn't initialize the terminal properly in this environment.

**Workaround:** Use `sops --decrypt` and `sops --encrypt` separately, or set a different editor:

```bash
$ EDITOR=nano sops secrets/hosts/nixos.yaml
# Or decrypt/encrypt manually:
$ sops --decrypt secrets/hosts/nixos.yaml > /tmp/secrets.yaml
$ vim /tmp/secrets.yaml
$ sops --encrypt /tmp/secrets.yaml > secrets/hosts/nixos.yaml
```

### 7. `sops --encrypt` Without Correct Path

```bash
$ sops --encrypt /tmp/nixos-secrets.yaml > secrets/hosts/nixos.yaml
error loading config: no matching creation rules found
```

**Why it failed:** sops uses `.sops.yaml` to determine which keys to encrypt with, based on the file path. Files outside the expected paths don't match any rules.

**Solution:** The file must be at the path matching `.sops.yaml` rules before encrypting:

```bash
# Copy to correct location first
$ cp /tmp/secrets.yaml secrets/hosts/nixos.yaml
# Then encrypt in-place
$ sops --encrypt --in-place secrets/hosts/nixos.yaml
```

### 8. Checking Hydra Job Status

```bash
$ curl -s "https://hydra.nixos.org/job/nixos/trunk-combined/nixpkgs.webkitgtk_6_0.x86_64-linux/latest"
# Returns 301 redirect
```

**Why:** Hydra redirects to the actual build page. This is normal - the redirect means the job exists.

**Better approach:** Visit the URL in a browser, or check the channel revision:

```bash
curl -sL "https://channels.nixos.org/nixos-unstable/git-revision"
```

## Changes Made

### 1. Changed Nixpkgs Channel (flake.nix)

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

### 2. Removed Nodejs Overlay (flake.nix)

**Before:**

```nix
nixpkgs.overlays = [
  (import ./overlays inputs).nodejs-skip-tests  # THIS BREAKS CACHE!
  (import ./overlays inputs).fix-vscode-operation-not-permitted
  # ...
];

nixpkgs.config = {
  allowUnfree = true;
  doCheck = false;
  doInstallCheck = false;
  packageOverrides = pkgs: {
    nodejs = pkgs.nodejs.overrideAttrs {  # THIS ALSO BREAKS CACHE!
      doCheck = false;
      doInstallCheck = false;
    };
  };
};
```

**After:**

```nix
nixpkgs.overlays = [
  # NOTE: nodejs-skip-tests overlay removed - it causes cache misses
  (import ./overlays inputs).fix-vscode-operation-not-permitted
  # ...
];

nixpkgs.config = {
  allowUnfree = true;
};
```

### 3. Removed Nodejs Override from Darwin Hosts

**Files modified:**

- `hosts/TP95V9LWWL/default.nix`
- `hosts/C02ZV797MD6R/default.nix`

**Before:**

```nix
packageOverrides = pkgs: {
  nodejs = pkgs.nodejs.overrideAttrs {
    doCheck = false;
    doInstallCheck = false;
  };
};
```

**After:**

```nix
# NOTE: nodejs packageOverrides removed - it causes cache misses
```

### 4. Added Extra Binary Caches (hosts/nixos/default.nix)

**Added substituters:**

```nix
substituters = [
  # ... existing caches ...
  "https://numtide.cachix.org"
];
```

**Added trusted public keys:**

```nix
trusted-public-keys = [
  # ... existing keys ...
  "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ber+6DVwQ5REeEhfBc3HIM2+8s="
];
```

## Understanding How Overlays Break Cache

### The Cascading Effect

When you modify a package via overlay, **all packages that depend on it get a new hash**:

```text
nodejs (modified by overlay)
    └── different hash
         └── build tools using nodejs
              └── different hash
                   └── webkitgtk (uses these build tools)
                        └── different hash
                             └── CACHE MISS!
```

### Safe vs. Unsafe Overlays

| Overlay Type            | Cache Impact     | Example                                            |
| ----------------------- | ---------------- | -------------------------------------------------- |
| Adding new packages     | Safe             | `myPackage = pkgs.callPackage ./my-package.nix {}` |
| Modifying leaf packages | Usually safe     | Modifying a package nothing depends on             |
| Modifying core packages | **BREAKS CACHE** | Modifying nodejs, python, gcc, stdenv              |
| Modifying build tools   | **BREAKS CACHE** | Modifying cmake, meson, pkg-config                 |

### Packages You Should Never Overlay

These packages are dependencies of many others. Modifying them causes massive rebuilds:

- `nodejs` - Used by many build systems
- `python` - Used everywhere
- `gcc` / `clang` - Compiler toolchain
- `stdenv` - The standard build environment
- `cmake` / `meson` - Build systems
- `pkg-config` - Dependency resolution
- `openssl` / `curl` - Network libraries

## Understanding Nix Channels

### Channel Comparison

| Channel                | Description                 | Cache Status      |
| ---------------------- | --------------------------- | ----------------- |
| `nixos-unstable`       | Passes Hydra jobset tests   | Always cached     |
| `nixpkgs-unstable`     | Latest commits              | May not be cached |
| `nixos-24.11`          | Stable release              | Always cached     |
| `nixpkgs-24.11-darwin` | Stable for macOS            | Always cached     |

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

| Cache                        | Purpose              | Priority         |
| ---------------------------- | -------------------- | ---------------- |
| `cache.nixos.org`            | Official NixOS cache | 10 (highest)     |
| `nix-community.cachix.org`   | Community packages   | 20               |
| `devenv.cachix.org`          | devenv packages      | default          |
| `nixpkgs-python.cachix.org`  | Python packages      | default          |
| `ryanccn.cachix.org`         | ryanccn's packages   | default          |
| `nix-gaming.cachix.org`      | Gaming packages      | default          |
| `nix-citizen.cachix.org`     | Star Citizen         | default          |
| `cache.nixos-cuda.org`       | CUDA packages        | default          |
| `numtide.cachix.org`         | Numtide packages     | default          |

### How Nix Cache Lookup Works

1. Nix computes the derivation hash for a package
1. Nix queries each substituter in priority order
1. If found, downloads the pre-built binary (NAR)
1. If not found in any cache, builds from source

## Preventing Future Cache Misses

### Best Practices

1. **Use `nixos-unstable` instead of `nixpkgs-unstable`**

   - Only advances when Hydra has built packages
   - Guarantees cache hits for most packages

1. **Avoid overlays that modify core packages**

   - Never overlay nodejs, python, gcc, stdenv
   - The "time saved" by skipping tests is nothing compared to rebuilding webkitgtk

1. **Check before updating**

   ```bash
   # See what will change
   nix flake update --dry-run

   # Check Hydra status before updating
   curl -sL "https://channels.nixos.org/nixos-unstable/git-revision"
   ```

1. **Verify your config matches official hashes**

   ```bash
   # Compare paths - they should match!
   nix eval --raw 'nixpkgs#webkitgtk_6_0.outPath'
   nix eval --raw '.#nixosConfigurations.nixos.pkgs.webkitgtk_6_0.outPath'
   ```

1. **Pin to specific revisions for stability**

   ```nix
   nixpkgs.url = "github:nixos/nixpkgs/c5296fdd05cfa2c187990dd909864da9658df755";
   ```

### Packages That Commonly Cause Long Builds

| Package        | Build Time   | Pulled In By                        |
| -------------- | ------------ | ----------------------------------- |
| `webkitgtk`    | 20-60 min    | GNOME, Evolution, Epiphany          |
| `llvm`         | 15-30 min    | Rust, Mesa, many compilers          |
| `gcc`          | 20-40 min    | Bootstrap, cross-compilation        |
| `firefox`      | 30-60 min    | Direct installation                 |
| `chromium`     | 60-120 min   | Direct installation                 |
| `libreoffice`  | 30-60 min    | Direct installation                 |
| `mesa`         | 10-20 min    | Graphics drivers                    |
| `aseprite`     | 10-15 min    | Direct (always builds - unfree)     |

## Packages That Always Build from Source

Some packages will **always** build from source regardless of cache configuration:

| Package                    | Reason                                          |
| -------------------------- | ----------------------------------------------- |
| `aseprite`                 | Unfree/proprietary - cannot distribute binaries |
| `spotify`                  | Unfree - fetches binary, but wrapper rebuilds   |
| Custom overlayed packages  | Your modifications = unique hash                |

## GitHub API Rate Limiting Issue

### Symptom

```text
error: unable to download 'https://api.github.com/repos/...': HTTP error 401
{
  "message": "Bad credentials",
  "status": "401"
}
```

### Cause

Your GitHub access token (stored in sops secrets at `tokens/github/public_repo_scope`) was expired or invalid.

### Why You Can't Edit /etc/nix/nix.conf

NixOS is declarative - the file is a symlink to the Nix store:

```bash
$ ls -la /etc/nix/nix.conf
lrwxrwxrwx 1 root root 24 Jan 27 13:28 /etc/nix/nix.conf -> /etc/static/nix/nix.conf
```

The Nix store is **immutable** - you cannot edit files there even as root.

### Solution

1. Generate a new GitHub Personal Access Token at https://github.com/settings/tokens

1. Update the token in your `nix-secrets` repository:

   ```bash
   cd ~/github/sheeeng/nix-secrets
   sops secrets/hosts/nixos.yaml
   # Update tokens/github/public_repo_scope
   git add -A && git commit -m "Update GitHub token" && git push
   ```

1. Update flake input and rebuild:

   ```bash
   nix flake update nix-secrets
   sudo nixos-rebuild switch --flake .#nixos
   ```

### Temporary Workaround

```bash
# Override the bad token temporarily
NIX_CONFIG="access-tokens =" nix flake update

# Or set a new token for the session
NIX_CONFIG="access-tokens = github.com=ghp_YOUR_TOKEN" nix flake update
```

## GPG Signing Issues During Git Commit

### Symptom

```text
error: gpg failed to sign the data:
gpg: Note: database_open 134217901 waiting for lock (held by 2472) ...
gpg: Note: database_open 134217901 waiting for lock (held by 2472) ...
gpg: keydb_search failed: Connection timed out
gpg: skipped "F104C3F659438426!": Connection timed out
gpg: signing failed: Connection timed out

fatal: failed to write commit object
```

### Cause

Another process (PID 2472) was holding a lock on the GPG database, and the timeout expired while waiting for it.

### Solutions

1. **Find and kill the blocking process:**

   ```bash
   # Find what's holding the lock
   ps aux | grep gpg
   lsof ~/.gnupg/*.lock

   # Kill the blocking process if safe
   kill 2472
   ```

1. **Remove stale lock files:**

   ```bash
   rm -f ~/.gnupg/*.lock
   rm -f ~/.gnupg/public-keys.d/*.lock
   ```

1. **Restart gpg-agent:**

   ```bash
   gpgconf --kill gpg-agent
   gpg-agent --daemon
   ```

1. **Skip signing temporarily:**

   ```bash
   git commit --no-gpg-sign -m "message"
   ```

1. **During NixOS rebuild:** The rebuild process may use GPG. Wait for the rebuild to complete before making commits.

## File Locations Reference

| File                                     | Purpose                                           |
| ---------------------------------------- | ------------------------------------------------- |
| `flake.nix`                              | Flake inputs including nixpkgs URL and overlays   |
| `flake.lock`                             | Pinned revisions of all inputs                    |
| `overlays/default.nix`                   | Custom package overlays                           |
| `hosts/nixos/default.nix`                | NixOS host configuration including cache settings |
| `hosts/TP95V9LWWL/default.nix`           | Darwin host configuration                         |
| `hosts/C02ZV797MD6R/default.nix`         | Darwin host configuration                         |
| `hosts/linux/sops.nix`                   | sops-nix configuration for secrets                |
| `/etc/nix/nix.conf`                      | Generated nix configuration (read-only symlink)   |
| `/run/secrets/rendered/nix-access-token` | Decrypted GitHub token                            |

## Commands Reference

### Flake Operations

```bash
# Update all flake inputs
nix flake update

# Update specific inputs only
nix flake update nixpkgs nixpkgs-darwin

# See what would change
nix flake update --dry-run
```

### Rebuild Commands

```bash
# Rebuild NixOS
sudo nixos-rebuild switch --flake .#nixos

# Rebuild with verbose output
sudo nixos-rebuild switch --flake .#nixos --show-trace

# Dry run - see what would be built
nix build --dry-run .#nixosConfigurations.nixos.config.system.build.toplevel
```

### Cache Debugging

```bash
# Check current nix settings
nix show-config | grep -E "(substituters|access-tokens)"

# Verify a package is cached (check for HTTP 200)
curl -sI "https://cache.nixos.org/$(nix eval --raw 'nixpkgs#webkitgtk_6_0.outPath' | cut -d/ -f4).narinfo" | head -1

# Compare your config's path with official
nix eval --raw 'nixpkgs#webkitgtk_6_0.outPath'
nix eval --raw '.#nixosConfigurations.nixos.pkgs.webkitgtk_6_0.outPath'

# Get full narinfo for a package
curl -s "https://cache.nixos.org/HASH.narinfo"
```

### Finding What Breaks Cache

```bash
# Compare any package path with official
nix eval --raw 'nixpkgs#PACKAGE.outPath'
nix eval --raw '.#nixosConfigurations.nixos.pkgs.PACKAGE.outPath'

# Check overlay effects
grep -r "overrideAttrs\|override\|overlay" flake.nix overlays/

# Find what depends on a package
nix why-depends .#nixosConfigurations.nixos.config.system.build.toplevel nixpkgs#nodejs
```

## Conclusion

Two issues caused WebKitGTK to build from source:

1. **Using `nixpkgs-unstable`** - Contains commits not yet cached by Hydra
1. **Nodejs overlay** - Modified a core package, causing cascading hash changes

The fixes:

1. Switch to `nixos-unstable` - Only contains cached commits
1. Remove nodejs overlays - Use official cached nodejs
1. Add extra caches - Backup sources for packages

**Key lesson:** Overlays that modify core packages (nodejs, python, gcc) will cause massive rebuilds. The few seconds saved by skipping tests is not worth the 20+ minutes rebuilding webkitgtk!
