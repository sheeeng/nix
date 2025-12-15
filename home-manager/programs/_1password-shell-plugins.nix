{ inputs, pkgs, ... }:
{
  # https://developer.1password.com/docs/cli/shell-plugins/nix
  imports = [ inputs._1password-shell-plugins.hmModules.default ];

  programs._1password-shell-plugins = {
    enable = true;
    plugins = with pkgs; [
      # keep-sorted start
      awscli2 # https://search.nixos.org/packages?channel=unstable&type=packages&show=awscli2
      cachix # https://search.nixos.org/packages?channel=unstable&type=packages&show=cachix
      gh # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh
      # keep-sorted end
    ];
  };
}
