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
    procps
    sketchybar
  ];
  text = ''
    state="''${XDG_STATE_HOME:-$HOME/.local/state}/aerospace-trial"
    aerospace_app="${pkgs.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace"

    stop_one() {
      if [ -f "$state/$1.pid" ]; then
        kill "$(cat "$state/$1.pid")" 2> /dev/null || true
        rm --force "$state/$1.pid"
      fi
    }

    case "''${1:-}" in
      start)
        for running in AeroSpace sketchybar; do
          if pgrep -x "$running" > /dev/null; then
            echo "$running already runs. Stop it first, or run: aerospace-trial stop" >&2
            exit 1
          fi
        done
        mkdir --parents "$state"
        nohup "$aerospace_app" --config-path ${aerospaceConfiguration} > "$state/aerospace.log" 2>&1 &
        echo $! > "$state/aerospace.pid"
        for _ in $(seq 1 20); do
          if aerospace list-workspaces --focused > /dev/null 2>&1; then
            break
          fi
          sleep 0.5
        done
        nohup sketchybar --config ${sketchybarConfiguration} > "$state/sketchybar.log" 2>&1 &
        echo $! > "$state/sketchybar.pid"
        echo "Started. Stop with: aerospace-trial stop. Logs are in $state."
        ;;
      stop)
        aerospace enable off 2> /dev/null || true
        stop_one sketchybar
        stop_one aerospace
        echo "Stopped. The native macOS window manager is active again."
        ;;
      status)
        for running in AeroSpace sketchybar; do
          if pgrep -x "$running" > /dev/null; then
            echo "$running: running"
          else
            echo "$running: not running"
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
