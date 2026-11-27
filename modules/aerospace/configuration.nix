{ lib, pkgs }:
# The AeroSpace and SketchyBar configuration. The module in ./default.nix and the trial helper in ./trial.nix
# both use it, so a trial runs the same settings as an activated host.
let
  sketchybar = lib.getExe pkgs.sketchybar;
  triggerFocusedWorkspace =
    workspace: "${sketchybar} --trigger aerospace_workspace_change FOCUSED_WORKSPACE=${workspace}";
  barHeight = 32;
  # The clock shows the local date and time, followed by the name and the offset of the system timezone, for
  # example "Fri 2026-11-27 09:50:42 (CET/UTC+01:00)". The macOS date command has no %:z, so the script splits %z.
  clockLabel = pkgs.writeShellScript "clock-label" ''
    zone="$(date '+%Z')"
    offset="$(date '+%z')"
    printf '%s (%s/UTC%s:%s)\n' "$(date '+%a %Y-%m-%d %H:%M:%S')" "$zone" "''${offset%??}" "''${offset#???}"
  '';
  workspaces = map toString (lib.range 1 9);
in
{
  # The workspace list, the bar height, and the clock label come from one place, so the bar items match the key bindings and
  # AeroSpace keeps the tiled windows below the bar.
  sketchybarConfig = ''
    bar_height=${toString barHeight}
    clock_label=${clockLabel}
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
