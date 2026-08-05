# P50 Plasma Host Design

## Goal

Add an x86_64 Linux NixOS host named `p50` with KDE Plasma 6 and SDDM.

## Structure

Create `hosts/p50/default.nix` from the existing `hosts/nixos/default.nix` host pattern. Preserve the shared Linux packages, services, Home Manager integration, secrets integration, audio, printing, Bluetooth, locale, and user settings.

Register `p50` in `flake.nix` as an `x86_64-linux` NixOS configuration while retaining the existing `nixos` host.

## Desktop Environment

Enable KDE Plasma 6 through `services.desktopManager.plasma6.enable` and SDDM through `services.displayManager.sddm.enable`. Remove GNOME, GDM, GNOME Shell extensions, GNOME keyring assumptions, and GNOME input source settings from the copied host configuration.

## Hardware Configuration

Add `hosts/p50/hardware-configuration.nix` as an intentionally invalid placeholder. Its evaluation error will instruct the operator to replace it with the file generated on the P50 before building or deploying the host.

## Validation

Format the changed Nix files, confirm that `p50` appears in the flake outputs, and verify that evaluation reaches the intentional hardware placeholder error. After replacing the placeholder on the actual machine, run the full flake checks and build the `p50` system closure.
