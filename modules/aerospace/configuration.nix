{ lib, pkgs }:
# The AeroSpace and SketchyBar configuration. The module in ./default.nix and the trial helper in ./trial.nix
# both use it, so a trial runs the same settings as an activated host.
let
  sketchybar = lib.getExe pkgs.sketchybar;
  triggerFocusedWorkspace =
    workspace: "${sketchybar} --trigger aerospace_workspace_change FOCUSED_WORKSPACE=${workspace}";
  barHeight = 32;
  workspaces = map toString (lib.range 1 9);
in
{
  # The workspace list and the bar height come from one place, so the bar items match the key bindings and
  # AeroSpace keeps the tiled windows below the bar.
  sketchybarConfig = ''
    bar_height=${toString barHeight}
    workspaces="${lib.concatStringsSep " " workspaces}"
    ${builtins.readFile ./sketchybarrc}
  '';

  settings = {
    # SketchyBar may start before AeroSpace, so mark the focused workspace again when AeroSpace starts.
    after-startup-command = [
      "exec-and-forget ${triggerFocusedWorkspace "$(${lib.getExe pkgs.aerospace} list-workspaces --focused)"}"
    ];
    config-version = 2;
    gaps.outer.top = barHeight; # Reserve the space of the bar.
    # Tell SketchyBar which workspace has the focus.
    exec-on-workspace-change = [
      "/bin/bash"
      "-c"
      (triggerFocusedWorkspace "$AEROSPACE_FOCUSED_WORKSPACE")
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
  };
}
