{ pkgs, ... }:
{
  home-manager = {
    backupCommand = ''
      mv "$1" "$1.before-nix-switch-$(date --universal +%Y-%m-%dT%H:%M:%SZ)"
    ''; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.backupCommand
    overwriteBackup = false; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.overwriteBackup
    sharedModules = [
      {
        home = {
          packages =
            with pkgs;
            [
              # keep-sorted start block=no newline_separated=no
              nushell # https://search.nixos.org/packages?channel=unstable&type=packages&show=nushell
              pass # https://search.nixos.org/packages?channel=unstable&type=packages&show=pass
              # keep-sorted end
            ]
            # Nixpkgs dropped x86_64-darwin support, so these packages no longer
            # evaluate on Intel Macs. Bitwarden Desktop pulls the insecure
            # electron-39.8.10, and KeePass depends on xdotool, which builds on
            # Linux only. The Bitwarden command line client is excluded here too,
            # so no Bitwarden tooling is installed on x86_64-darwin.
            ++ lib.optionals (stdenv.hostPlatform.system != "x86_64-darwin") [
              # keep-sorted start block=no newline_separated=no
              bitwarden-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=bitwarden-cli
              bitwarden-desktop # https://search.nixos.org/packages?channel=unstable&type=packages&show=bitwarden-desktop
              keepass # https://search.nixos.org/packages?channel=unstable&type=packages&show=keepass
              # keep-sorted end
            ];
        };
      }
    ]; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.sharedModules
  };

}
