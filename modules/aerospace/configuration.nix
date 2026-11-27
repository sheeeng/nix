{ lib, pkgs }:
# The AeroSpace and SketchyBar configuration. The module in ./default.nix and the trial helper in ./trial.nix
# both use it, so a trial runs the same settings as an activated host.
let
  sketchybar = lib.getExe pkgs.sketchybar;
  triggerFocusedWorkspace =
    workspace: "${sketchybar} --trigger aerospace_workspace_change FOCUSED_WORKSPACE=${workspace}";
  barHeight = 32;
  # Catppuccin Macchiato, the same palette as the Sway and Waybar setup on Linux.
  macchiato = {
    base = "#24273a";
    lavender = "#b7bdf8";
    mauve = "#c6a0f6";
    text = "#cad3f5";
  };
  # SketchyBar colors are 0xAARRGGBB.
  argb = alpha: color: "0x${alpha}${lib.removePrefix "#" color}";
  # The front application comes from LaunchServices, so it also works when no window has the focus.
  frontApp = pkgs.writeShellScript "front-app" ''
    name="$(/usr/bin/lsappinfo info -only name "$(/usr/bin/lsappinfo front)" | /usr/bin/sed -n 's/^"LSDisplayName"="\(.*\)"$/\1/p')"
    ${sketchybar} --set front_app label="$name"
  '';
  # The same labels as the Waybar battery module. The icons come from the system battery state.
  batteryUpdate = pkgs.writeShellScript "battery-update" ''
    status="$(/usr/bin/pmset -g batt)"
    if [[ $status =~ ([0-9]+)% ]]; then
      percent="''${BASH_REMATCH[1]}"
    else
      ${sketchybar} --set battery drawing=off
      exit 0
    fi
    case "$status" in
      *discharging*)
        if [ "$percent" -le 30 ]; then
          label="Low $percent% 🪫"
        else
          label="$percent% 🔋"
        fi
        ;;
      *"not charging"* | *charged*) label="Full $percent% ⚡️" ;;
      *) label="Charging $percent% ⚡️" ;;
    esac
    ${sketchybar} --set battery drawing=on label="$label"
  '';
  # The clock shows the local date and time, followed by the name and the offset of the system timezone, for
  # example "Fri 2026-11-27 09:50:42 (CET/UTC+01:00)". The offset comes from %z, which is +hhmm, and the
  # script adds the colon. A SketchyBar timer would drift from the wall clock and sometimes repeat or skip a
  # second, and each tick would start two shells. This one process sleeps until the start of every second
  # instead. It uses only Bash built-ins, so the single external process per second is sketchybar --set. The
  # shell is the Bash of Nix, which supports %(format)T, $EPOCHREALTIME, and a fractional read timeout.
  clockDaemon = pkgs.writeShellScript "clock-daemon" ''
    # Only one daemon may run. A daemon from an older build has another store path, so a search by path would
    # miss it. The recorded process identifier finds it, and the script name stays the same in every build.
    state="''${XDG_STATE_HOME:-$HOME/.local/state}/sketchybar-clock"
    ${pkgs.coreutils}/bin/mkdir --parents "$state"
    pid_file="$state/daemon.pid"
    if read -r previous < "$pid_file" 2> /dev/null && [ "$previous" != "$$" ]; then
      if [[ "$(/bin/ps -p "$previous" -o command= 2> /dev/null)" == *-clock-daemon* ]]; then
        kill "$previous" 2> /dev/null || true
      fi
    fi
    echo "$$" > "$pid_file"

    # A read from a FIFO that this process also holds open waits for the whole timeout, without a sleep process.
    fifo="$(${pkgs.coreutils}/bin/mktemp --dry-run)"
    ${pkgs.coreutils}/bin/mkfifo "$fifo"
    exec {wait_fd}<> "$fifo"
    ${pkgs.coreutils}/bin/rm --force "$fifo"

    tick=0
    while true; do
      # Stop when a newer daemon took over, even if the kill above did not reach this one.
      read -r current < "$pid_file" 2> /dev/null || exit 0
      [ "$current" = "$$" ] || exit 0
      printf -v zone '%(%Z)T' -1
      printf -v offset '%(%z)T' -1
      printf -v label '%(%a %Y-%m-%d %H:%M:%S)T (%s/UTC%s:%s)' -1 "$zone" "''${offset%??}" "''${offset#???}"
      # Stop when SketchyBar is gone, so a stop leaves no orphan.
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
    battery_update=${batteryUpdate}
    clock_daemon=${clockDaemon}
    front_app_update=${frontApp}
    color_base=${argb "d9" macchiato.base}
    color_border=${argb "59" macchiato.lavender}
    color_focus=${argb "ff" macchiato.mauve}
    color_focus_text=${argb "ff" macchiato.base}
    color_text=${argb "ff" macchiato.text}
    workspaces="${lib.concatStringsSep " " workspaces}"
    ${builtins.readFile ./sketchybarrc}
  '';

  settings = {
    # SketchyBar may start before AeroSpace, so mark the focused workspace again when AeroSpace starts.
    after-startup-command = [
      "exec-and-forget ${triggerFocusedWorkspace "$(${lib.getExe pkgs.aerospace} list-workspaces --focused)"}"
      # The same for the front application, which SketchyBar otherwise shows only after the next switch.
      "exec-and-forget ${frontApp}"
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
      # The shortcuts follow the Sway setup on Linux, where Mod is Super. Option sits in the same place on a Mac.
      alt-d = "exec-and-forget open -a Spotlight"; # The launcher. Rofi on Linux.
      alt-e = "layout tiles horizontal vertical"; # Toggle the split.
      alt-enter = "exec-and-forget open -na Ghostty"; # The terminal.
      alt-f = "fullscreen";
      alt-r = "mode resize";
      alt-s = "layout v_accordion"; # Stacking.
      alt-shift-f = "exec-and-forget open -a Finder"; # The file manager. Thunar on Linux.
      alt-shift-q = "close";
      alt-shift-space = "layout floating tiling";
      alt-tab = "workspace-back-and-forth";
      alt-w = "layout h_accordion"; # Tabbed.
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
    # The same keys as the Sway resize mode.
    mode.resize.binding = {
      enter = "mode main";
      esc = "mode main";
      h = "resize width -50";
      j = "resize height +50";
      k = "resize height -50";
      l = "resize width +50";
    };
  };
}
