# P50 Machine Configuration Merge Design

## Goal

Merge the useful settings from the P50 installation configuration into the managed host configuration and remove the redundant installation file.

## Merge Strategy

Keep `hosts/p50/default.nix` as the authoritative host configuration. Preserve the copied `hardware-configuration.nix` as the machine generated hardware description.

Add the machine features that are absent from the shared Home Manager configuration: fingerprint support, the Tailscale service, Enpass CLI, Kate, and Tailscale Systray. Retain the existing shared Enpass and uutils packages without adding duplicates.

Set `system.stateVersion` to `26.05`, which records the release used for the initial P50 installation.

Delete `hosts/p50/configuration.nix` after its unique settings are merged.

## Validation

Format the P50 Nix files, evaluate the P50 system closure, and run the repository flake checks. Confirm that the generated root file system and hardware declarations satisfy NixOS evaluation.
