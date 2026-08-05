# P50 Plasma Host Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task by task.

**Goal:** Add an x86_64 NixOS host named `p50` that uses KDE Plasma 6 and SDDM.

**Architecture:** Copy the established `nixos` host configuration into a dedicated `p50` host, then replace its GNOME session integration with Plasma 6 and SDDM. Use an intentional hardware configuration evaluation error until the generated configuration from the physical machine replaces it.

**Tech Stack:** Nix, NixOS, Home Manager, KDE Plasma 6, and SDDM.

---

### Task 1: Add the P50 Host Configuration ✅

**Files:**

- Create: `hosts/p50/default.nix`
- Create: `hosts/p50/hardware-configuration.nix`

**Step 1: Copy the existing NixOS host configuration**

Copy `hosts/nixos/default.nix` to `hosts/p50/default.nix`.

**Step 2: Set the host identity**

Change `networking.hostName` to `p50` and retain `x86_64-linux` as the platform.

**Step 3: Replace the desktop environment**

Disable the copied GDM and GNOME declarations. Enable these options:

```nix
services.displayManager.sddm.enable = true;
services.desktopManager.plasma6.enable = true;
```

Remove GNOME Shell extension settings and GNOME SSH agent declarations that do not apply to Plasma.

**Step 4: Add the hardware placeholder**

Create `hosts/p50/hardware-configuration.nix` with an evaluation error that instructs the operator to replace it with the generated file from the physical P50.

**Step 5: Format the host files**

Run `nix fmt hosts/p50/default.nix hosts/p50/hardware-configuration.nix`.

Expected: Both files are formatted without errors.

### Task 2: Register and Evaluate the Host ✅

**Files:**

- Modify: `flake.nix:424`

**Step 1: Register the host**

Add this configuration to `nixosConfigurations`:

```nix
p50 = nixosConfiguration "p50" "x86_64-linux";
```

**Step 2: Format the flake**

Run `nix fmt flake.nix`.

Expected: `flake.nix` is formatted without errors.

**Step 3: Verify flake discovery**

Run `nix flake show --no-write-lock-file`.

Expected: `nixosConfigurations.p50` appears. Evaluation may report the intentional hardware placeholder error when the host is forced.

**Step 4: Verify the placeholder guard**

Run `nix eval --no-write-lock-file .#nixosConfigurations.p50.config.system.build.toplevel.drvPath`.

Expected: Evaluation fails with the instruction to replace `hosts/p50/hardware-configuration.nix`.

### Task 3: Validate and Commit the Change ✅

**Files:**

- Modify: `docs/plans/2026-08-05-p50-plasma-host.md`

**Step 1: Run available formatting checks**

Run `nix flake check --no-build` and `pre-commit run --all-files`.

Expected: Checks unrelated to the intentional P50 hardware placeholder pass. Record any expected placeholder limitation.

Result: `nix flake check --no-build` passed. The user explicitly waived the pre commit run after its environment installation was interrupted.

**Step 2: Mark every plan task complete**

Update each task heading with a completion marker after its verification succeeds.

**Step 3: Inspect the changes**

Run `git status --short`, `git diff`, and `git log --oneline -10`.

Expected: Only the P50 host, flake registration, and plan documents are included, while preexisting untracked files remain untouched.

**Step 4: Commit the implementation**

Create one Conventional Commit containing the implementation and its plan documents.
