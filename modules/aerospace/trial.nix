{ lib, pkgs }:
# Runs AeroSpace and SketchyBar with the settings of ./default.nix, without activating a nix-darwin host.
# Nothing is installed or changed. The native macOS window manager stays the default after a stop.
let
  configuration = import ./configuration.nix { inherit lib pkgs; };
  aerospaceConfiguration = (pkgs.formats.toml { }).generate "aerospace.toml" configuration.settings;
  sketchybarConfiguration = pkgs.writeScript "sketchybarrc" configuration.sketchybarConfig;
in
pkgs.writeShellApplication {
  name = "aerospace-trial";
  runtimeInputs = with pkgs; [
    aerospace
    coreutils
    sketchybar
  ];
  text = ''
    state="''${XDG_STATE_HOME:-$HOME/.local/state}/aerospace-trial"
    aerospace_app="${pkgs.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace"
    aerospace_marker="${aerospaceConfiguration}"
    sketchybar_marker="${sketchybarConfiguration}"

    # An application belongs to the trial only when its recorded process still runs with the trial
    # configuration. An instance that nix-darwin or the user started never matches.
    owned() {
      pid_file="$state/$1.pid"
      if [ ! -f "$pid_file" ]; then
        return 1
      fi
      if ps -p "$(cat "$pid_file")" -o command= 2> /dev/null | grep --quiet --fixed-strings "$2"; then
        return 0
      fi
      rm --force "$pid_file"
      return 1
    }

    stop_one() {
      if owned "$1" "$2"; then
        kill "$(cat "$state/$1.pid")" 2> /dev/null || true
        rm --force "$state/$1.pid"
      fi
    }

    case "''${1:-}" in
      start)
        if owned aerospace "$aerospace_marker" || owned sketchybar "$sketchybar_marker"; then
          echo "A trial already runs. Stop it with: aerospace-trial stop" >&2
          exit 1
        fi
        for running in AeroSpace sketchybar; do
          if pgrep -x "$running" > /dev/null; then
            echo "$running already runs and does not belong to this helper. Stop it yourself, then try again." >&2
            exit 1
          fi
        done
        mkdir --parents "$state"
        nohup "$aerospace_app" --config-path "$aerospace_marker" > "$state/aerospace.log" 2>&1 &
        echo $! > "$state/aerospace.pid"
        ready=false
        for _ in $(seq 1 20); do
          if aerospace list-workspaces --focused > /dev/null 2>&1; then
            ready=true
            break
          fi
          sleep 0.5
        done
        if [ "$ready" != true ]; then
          stop_one aerospace "$aerospace_marker"
          echo "AeroSpace did not start. Read $state/aerospace.log. Allow it in Accessibility, then try again." >&2
          exit 1
        fi
        nohup sketchybar --config "$sketchybar_marker" > "$state/sketchybar.log" 2>&1 &
        echo $! > "$state/sketchybar.pid"
        sleep 1
        if ! owned sketchybar "$sketchybar_marker"; then
          stop_one aerospace "$aerospace_marker"
          echo "SketchyBar did not start. Read $state/sketchybar.log." >&2
          exit 1
        fi
        echo "Started. Stop with: aerospace-trial stop. Logs are in $state."
        ;;
      stop)
        stopped=false
        # Turn tiling off only in the trial instance, so an activated AeroSpace stays unchanged.
        if owned aerospace "$aerospace_marker"; then
          aerospace enable off 2> /dev/null || true
          stopped=true
        fi
        if owned sketchybar "$sketchybar_marker"; then
          stopped=true
        fi
        stop_one sketchybar "$sketchybar_marker"
        stop_one aerospace "$aerospace_marker"
        if [ "$stopped" = true ]; then
          echo "Stopped. The native macOS window manager is active again."
        else
          echo "No trial runs. Nothing changed."
        fi
        ;;
      status)
        for entry in "AeroSpace:aerospace:$aerospace_marker" "sketchybar:sketchybar:$sketchybar_marker"; do
          name="''${entry%%:*}"
          rest="''${entry#*:}"
          key="''${rest%%:*}"
          marker="''${rest#*:}"
          if owned "$key" "$marker"; then
            echo "$name: running, started by the trial"
          elif pgrep -x "$name" > /dev/null; then
            echo "$name: running, not started by the trial"
          else
            echo "$name: not running"
          fi
        done
        ;;
      *)
        echo "Usage: aerospace-trial start|stop|status" >&2
        exit 2
        ;;
    esac
  '';
}
