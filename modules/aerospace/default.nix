{ lib, pkgs, ... }:
# nix-darwin only. Optional. A host that imports this module replaces the native macOS window manager
# with AeroSpace and draws a SketchyBar. A host that does not import it keeps the native behavior.
# Do not import this module together with ../yabai, because both enable SketchyBar.
let
  workspaces = map toString (lib.range 1 9);
in
{
  services.aerospace = {
    enable = true; # https://nix-darwin.github.io/nix-darwin/manual/#opt-services.aerospace.enable
    package = pkgs.aerospace; # https://nix-darwin.github.io/nix-darwin/manual/#opt-services.aerospace.package
    settings = {
      config-version = 2;
      # Tell SketchyBar which workspace has the focus.
      exec-on-workspace-change = [
        "/bin/bash"
        "-c"
        "${lib.getExe pkgs.sketchybar} --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];
      mode.main.binding = {
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";
        alt-slash = "layout tiles horizontal vertical";
        alt-tab = "workspace-back-and-forth";
      }
      // lib.listToAttrs (
        lib.concatMap (workspace: [
          {
            name = "alt-${workspace}";
            value = "workspace ${workspace}";
          }
          {
            name = "alt-shift-${workspace}";
            value = "move-node-to-workspace ${workspace}";
          }
        ]) workspaces
      );
    }; # https://nix-darwin.github.io/nix-darwin/manual/#opt-services.aerospace.settings
  };

  services.sketchybar = {
    enable = true; # https://nix-darwin.github.io/nix-darwin/manual/#opt-services.sketchybar.enable
    package = pkgs.sketchybar; # https://nix-darwin.github.io/nix-darwin/manual/#opt-services.sketchybar.package
    config = builtins.readFile ./sketchybarrc; # https://nix-darwin.github.io/nix-darwin/manual/#opt-services.sketchybar.config
  };
}
