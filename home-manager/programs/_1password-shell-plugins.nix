{ inputs, pkgs, ... }:
{
  # https://developer.1password.com/docs/cli/shell-plugins/nix
  imports = [ inputs._1password-shell-plugins.hmModules.default ];

  programs._1password-shell-plugins = {
    enable = true; # https://github.com/1Password/shell-plugins/blob/49810df8fe11221250a890191185c6e59aea8d1e/nix/shell-plugins.nix#L29
    plugins = with pkgs; [
      # keep-sorted start
      awscli2 # https://search.nixos.org/packages?channel=unstable&type=packages&show=awscli2
      cachix # https://search.nixos.org/packages?channel=unstable&type=packages&show=cachix
      gh # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh
      # keep-sorted end
    ]; # https://github.com/1Password/shell-plugins/blob/49810df8fe11221250a890191185c6e59aea8d1e/nix/shell-plugins.nix#L31
  };
}
