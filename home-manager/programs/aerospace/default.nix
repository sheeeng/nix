# https://github.com/alexnabokikh/nix-config/blob/bddec40e097d4227cd95badfc02164aa006a8a4c/modules/home-manager/programs/aerospace/default.nix

# {
#   lib,
#   pkgs,
#   ...
# }:
# {
#   config = lib.mkIf (pkgs.stdenv.isDarwin) {
#     home.packages = with pkgs; [
#       aerospace # https://search.nixos.org/packages?channel=unstable&type=packages&show=aerospace
#     ];

#     home.file.".aerospace.toml".source = ./aerospace.toml;
#   };
# }

{ pkgs, ... }:
{
  programs.aerospace = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aerospace.enable
    package = pkgs.aerospace; # https://nix-community.github.io/home-manager
    settings = {
      gaps = {
        outer.left = 8;
        outer.bottom = 8;
        outer.top = 8;
        outer.right = 8;
      };
      mode.main.binding = {
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";
      };
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      accordion-padding = 30;
      after-login-command = [ ];
      after-startup-command = [ ];
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      exec-on-workspace-change = [ ];
      key-mapping = {
        preset = "qwerty";
      };
      on-focus-changed = [ ];
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
      on-window-detected = [ ];
      start-at-login = false;
      workspace-to-monitor-force-assignment = null;
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aerospace.settings
  };
}
