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
          packages = with pkgs; [
            # keep-sorted start block=no newline_separated=no
            bitwarden-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=bitwarden-cli
            bitwarden-desktop # https://search.nixos.org/packages?channel=unstable&type=packages&show=bitwarden-desktop
            keepass # https://search.nixos.org/packages?channel=unstable&type=packages&show=keepass
            nushell # https://search.nixos.org/packages?channel=unstable&type=packages&show=nushell
            pass # https://search.nixos.org/packages?channel=unstable&type=packages&show=pass
            # keep-sorted end
          ];
        };
      }
    ]; # https://nix-community.github.io/home-manager/nixos-options.xhtml#nixos-opt-home-manager.sharedModules
  };

}
