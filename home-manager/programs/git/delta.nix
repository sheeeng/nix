{ pkgs, ... }:
{
  programs.delta = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.delta.enable
    package = pkgs.delta; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.delta.package
    enableGitIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.delta.enableGitIntegration
    options = {
      decorations = {
        commit-decoration-style = "bold yellow box ul";
        file-decoration-style = "none";
        file-style = "bold yellow ul";
      };
      # features = "decorations"; # Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
      whitespace-error-style = "22 reverse";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.delta.options
  };
}
