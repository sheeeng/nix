# AeroSpace and SketchyBar Getting Started

This guide shows how to try [AeroSpace][aerospace] and [SketchyBar][sketchybar]
on a Mac without changing the system. It also shows how to keep them on a host
and how to go back. The native macOS window manager is the default. Nothing
changes until you opt in.

## Before You Start

- Use an Apple silicon Mac. `TP95V9LWWL` is one. nixpkgs provides AeroSpace for
  Apple silicon only, so `C02ZV797MD6R` cannot use it.
- Work in a checkout of this repository, on a branch that has `modules/aerospace`.
- Do not use `modules/yabai` at the same time. Both modules start SketchyBar.

## Try It Without Activating a Host

The trial starts AeroSpace and SketchyBar with the same settings as the module.
It installs nothing and does not change `~/.aerospace.toml`. It writes only logs
and process identifiers to `~/.local/state/aerospace-trial`.

1. Hide the macOS menu bar automatically in System Settings. SketchyBar draws
   its bar at the top of the screen. The menu bar would cover it.

2. Start the trial:

   ```shell
   nix run .#aerospace-trial -- start
   ```

3. Allow AeroSpace in System Settings, under Privacy and Security,
   Accessibility. macOS asks the first time. Run the start command again after
   you allow it.

4. Check the state at any time:

   ```shell
   nix run .#aerospace-trial -- status
   ```

5. Stop the trial. The native macOS window manager is active again:

   ```shell
   nix run .#aerospace-trial -- stop
   ```

The start command stops with a message if AeroSpace or SketchyBar already runs.
This prevents two copies of each. If the running copy is not from this helper,
for example one that nix-darwin started, the helper leaves it unchanged. The
stop command also acts only on processes that this helper started.

If a window stays in a wrong place after you stop, run these commands:

```shell
aerospace enable off
pkill -x AeroSpace
pkill -x sketchybar
```

## Shared Shortcuts

The Sway setup on Linux and AeroSpace on macOS use the same shortcuts, so one
set of habits works on both. Mod is Super on Linux and Option on macOS. The two
keys are in the same place on the keyboard, to the right of Control.

| Action | Linux, Sway | macOS, AeroSpace |
| --- | --- | --- |
| Open a terminal | `Mod+Return` | `alt-enter` |
| Open the launcher | `Mod+d` | `alt-d` |
| Open the file manager | `Mod+Shift+f` | `alt-shift-f` |
| Close the window | `Mod+Shift+q` | `alt-shift-q` |
| Focus a window | `Mod+h`, `Mod+j`, `Mod+k`, `Mod+l` | `alt-h`, `alt-j`, `alt-k`, `alt-l` |
| Move a window | `Mod+Shift+h`, `j`, `k`, `l` | `alt-shift-h`, `j`, `k`, `l` |
| Go to workspace 1 to 9 | `Mod+1` to `Mod+9` | `alt-1` to `alt-9` |
| Move the window to workspace 1 to 9 | `Mod+Shift+1` to `Mod+Shift+9` | `alt-shift-1` to `alt-shift-9` |
| Go to the previous workspace | `Mod+Tab` | `alt-tab` |
| Toggle the split direction | `Mod+e` | `alt-e` |
| Stacking layout | `Mod+s` | `alt-s` |
| Tabbed layout | `Mod+w` | `alt-w` |
| Fullscreen | `Mod+f` | `alt-f` |
| Float or tile the window | `Mod+Shift+space` | `alt-shift-space` |
| Resize mode, then `h`, `j`, `k`, `l`, and `Esc` to leave | `Mod+r` | `alt-r` |

Some actions use another program on each system. The launcher is Rofi on Linux
and Spotlight on macOS. The file manager is Thunar on Linux and Finder on
macOS. The terminal is Ghostty on both. The `alt-enter` shortcut opens the
Ghostty application, so install Ghostty in `/Applications` or `~/Applications`.

Linux has more shortcuts that macOS does not need: `Mod+Shift+v` for the
clipboard history, `Mod+Shift+n` for the notification center, and
`Mod+Shift+d` for the demo apps.

The bar uses the same Catppuccin Macchiato pills as Waybar on Linux. It shows
the workspaces in one pill, with the focused one highlighted, and the front
application on the left. The clock is in the center, and the battery is on the
right. Click a workspace to go to it. The clock shows the local date and time,
followed by the name and offset of the system timezone, for example
`Fri 2026-11-27 09:50:42 (CET/UTC+01:00)`. A small background process updates
the clock at the start of every second. It starts no other process between
updates, and it stops by itself when SketchyBar stops. The battery label has
the same words and icons as Waybar, and it updates when the power source
changes and every two minutes.

## Keep It on a Host

1. Uncomment the import in `hosts/TP95V9LWWL/default.nix`:

   ```nix
   ../../modules/aerospace
   ```

2. Apply the configuration:

   ```shell
   sudo darwin-rebuild switch --flake .
   ```

3. Allow AeroSpace in Accessibility again if macOS asks. A new Nix store path
   counts as a new application.

AeroSpace and SketchyBar then start at login.

## Go Back to the Native Window Manager

Comment the import again, and apply the configuration:

```shell
sudo darwin-rebuild switch --flake .
```

To pause tiling for a short time without a rebuild, run `aerospace enable off`.
Run `aerospace enable on` to resume.

## Troubleshooting

| Symptom | Action |
| --- | --- |
| Nothing happens when you press a key. | Allow AeroSpace in Accessibility. Then stop and start it again. |
| The bar does not appear. | Read `~/.local/state/aerospace-trial/sketchybar.log`. Check that no other SketchyBar runs. |
| Windows overlap the bar. | Hide the macOS menu bar automatically. AeroSpace reserves 32 pixels at the top for the bar. |
| The clock does not change. | Stop and start the trial again. If it still does not change, read `~/.local/state/aerospace-trial/sketchybar.log`. |
| No workspace is highlighted. | Go to another workspace and back. AeroSpace then sends the focused workspace to the bar. |
| You cannot type an Option character, such as in a text field. | AeroSpace uses the `alt` bindings. Change the bindings in `modules/aerospace/configuration.nix`. |
| `alt-enter` does nothing. | Ghostty is not in `/Applications` or `~/Applications`. Install it there. |
| `alt-d` does not open Spotlight. | Open Spotlight with its own shortcut. The `open -a Spotlight` command depends on the macOS version. |
| The start command says an application already runs. | If a trial runs, run the stop command. Otherwise stop the application yourself. The helper never stops an application that it did not start. |
| The start command says AeroSpace did not start. | Read `~/.local/state/aerospace-trial/aerospace.log`. Allow AeroSpace in Accessibility, then try again. |

[aerospace]: https://github.com/nikitabobko/AeroSpace
[sketchybar]: https://github.com/FelixKratz/SketchyBar
