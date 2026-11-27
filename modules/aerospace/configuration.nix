{ lib, pkgs }:
# The AeroSpace and SketchyBar configuration. The module in ./default.nix and the trial helper in ./trial.nix
# both use it, so a trial runs the same settings as an activated host.
let
  sketchybar = lib.getExe pkgs.sketchybar;
  triggerFocusedWorkspace =
    workspace: "${sketchybar} --trigger aerospace_workspace_change FOCUSED_WORKSPACE=${workspace}";
  barHeight = 32;
  # The clock shows the local date and time, followed by the name and the offset of the system timezone, for
  # example "Fri 2026-11-27 09:50:42 (CET/UTC+01:00)". The offset comes from %z, which is +hhmm, and the
  # script adds the colon. A SketchyBar timer would drift from the wall clock and sometimes repeat or skip a
  # second, and each tick would start two shells. This one process sleeps until the start of every second
  # instead. It uses only Bash built-ins, so the single external process per second is sketchybar --set. The
  # shell is the Bash of Nix, which supports %(format)T, $EPOCHREALTIME, and a fractional read timeout.
  clockDaemon = pkgs.writeShellScript "clock-daemon" ''
    # A read from a FIFO that this process also holds open waits for the whole timeout, without a sleep process.
    fifo="$(${pkgs.coreutils}/bin/mktemp --dry-run)"
    ${pkgs.coreutils}/bin/mkfifo "$fifo"
    exec {wait_fd}<> "$fifo"
    ${pkgs.coreutils}/bin/rm --force "$fifo"

    tick=0
    while true; do
      printf -v zone '%(%Z)T' -1
      printf -v offset '%(%z)T' -1
      printf -v label '%(%a %Y-%m-%d %H:%M:%S)T (%s/UTC%s:%s)' -1 "$zone" "''${offset%??}" "''${offset#???}"
      # Stop when SketchyBar is gone, so a reload or a stop leaves no orphan.
      ${sketchybar} --set clock label="$label" || exit 0
      tick=$((tick + 1))
      if [ "$((tick % 30))" -eq 0 ] && ! /usr/bin/pgrep -x sketchybar > /dev/null; then
        exit 0
      fi

      # Wake 2 ms after the next full second. The microseconds are in the part after the dot.
      microseconds=''${EPOCHREALTIME#*.}
      wait_us=$((1000000 - 10#$microseconds + 2000))
      printf -v wait '%d.%06d' "$((wait_us / 1000000))" "$((wait_us % 1000000))"
      read -r -t "$wait" -u "$wait_fd" || true
    done
  '';
  workspaces = map toString (lib.range 1 9);
in
{
  # The workspace list, the bar height, and the clock daemon come from one place, so the bar items match the key bindings and
  # AeroSpace keeps the tiled windows below the bar.
  sketchybarConfig = ''
    bar_height=${toString barHeight}
    clock_daemon=${clockDaemon}
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
