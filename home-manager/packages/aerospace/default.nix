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
    userSettings = {
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
      enable-normalization-flatten-containers = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aerospace.userSettings.enable-normalization-flatten-containers
      enable-normalization-opposite-orientation-for-nested-containers = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aerospace.userSettings.enable-normalization-opposite-orientation-for-nested-containers
      accordion-padding = 30; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aerospace.userSettings.accordion-padding
      after-login-command = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aerospace.userSettings.after-login-command
      after-startup-command = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aerospace.userSettings.after-startup-command
      default-root-container-layout = "tiles"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aerospace.userSettings.default-root-container-layout
      default-root-container-orientation = "auto"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aerospace.userSettings.default-root-container-orientation
      exec-on-workspace-change = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aerospace.userSettings.exec-on-workspace-change
      key-mapping = {
        preset = "qwerty"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aerospace.userSettings.key-mapping.preset
      };
      on-focus-changed = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aerospace.userSettings.on-focus-changed
      on-focused-monitor-changed = [
        "move-mouse monitor-lazy-center"
      ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aerospace.userSettings.on-focused-monitor-changed
      on-window-detected = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aerospace.userSettings.on-window-detected
      start-at-login = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aerospace.userSettings.start-at-login
      workspace-to-monitor-force-assignment = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aerospace.userSettings.workspace-to-monitor-force-assignment
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.aerospace.userSettings
  };
}
