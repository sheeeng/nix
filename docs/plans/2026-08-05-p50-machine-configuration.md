# P50 Machine Configuration Merge Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task by task.

**Goal:** Merge the physical P50 installation settings into its managed NixOS host configuration.

**Architecture:** Keep `default.nix` as the sole managed host module and retain the generated hardware module as a separate machine description. Selectively copy only settings that shared Home Manager does not already provide, then remove the installation configuration.

**Tech Stack:** Nix, NixOS, Home Manager, KDE Plasma 6, and Tailscale.

---

### Task 1: Establish the Evaluation Baseline ✅

**Files:**

- Inspect: `hosts/p50/configuration.nix`
- Inspect: `hosts/p50/default.nix`
- Inspect: `hosts/p50/hardware-configuration.nix`

**Step 1: Stage the copied machine files for flake visibility**

Run `git add hosts/p50/configuration.nix hosts/p50/hardware-configuration.nix`.

**Step 2: Evaluate the current P50 closure**

Run `nix eval --no-write-lock-file .#nixosConfigurations.p50.config.system.build.toplevel.drvPath`.

Expected: Evaluation exposes any conflict or missing dependency before the merge.

Result: Evaluation reached SOPS activation and identified the missing `secrets/hosts/p50.yaml` file in the secrets input.

### Task 2: Merge Unique Machine Settings ✅

**Files:**

- Modify: `hosts/p50/default.nix`
- Delete: `hosts/p50/configuration.nix`

**Step 1: Add missing desktop packages**

Add these packages to the sorted system package list:

```nix
enpass-cli
kdePackages.kate
tailscale-systray
```

Do not add Enpass, Tailscale, or uutils packages that are already provided by services or shared configuration.

**Step 2: Add machine services**

Enable these services:

```nix
services.fprintd.enable = true;
services.tailscale.enable = true;
```

**Step 3: Preserve the initial system version**

Set `system.stateVersion` to `26.05`.

**Step 4: Remove the redundant installation file**

Delete `hosts/p50/configuration.nix` after every unique active setting has been accounted for.

**Step 5: Format the P50 files**

Run `nix fmt hosts/p50/default.nix hosts/p50/hardware-configuration.nix`.

Expected: Both files are formatted without errors.

### Task 3: Verify the Merged Host ✅

**Files:**

- Modify: `docs/plans/2026-08-05-p50-machine-configuration.md`

**Step 1: Evaluate the system closure**

Run `nix eval --no-write-lock-file .#nixosConfigurations.p50.config.system.build.toplevel.drvPath`.

Expected: Evaluation succeeds and prints a derivation path.

Result: Full closure evaluation remains blocked by the missing `secrets/hosts/p50.yaml` file. All merged host values evaluate successfully before SOPS activation.

**Step 2: Verify merged values**

Evaluate the fingerprint service, hostname, Plasma service, state version, and Tailscale service through the P50 flake output.

Expected: Both machine services and Plasma are enabled, the hostname is `p50`, and the state version is `26.05`.

**Step 3: Run repository checks**

Run `nix flake check --no-build`.

Expected: All checks for the current platform pass.

**Step 4: Inspect the final changes**

Run `git status --short`, `git diff`, and `git diff --cached`.

Expected: The P50 merge and plan documents are present, while unrelated untracked files remain untouched.

**Step 5: Mark plan tasks complete**

Add completion markers to each task heading after its verification succeeds.
