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
This prevents two copies of each.

If a window stays in a wrong place after you stop, run these commands:

```shell
aerospace enable off
pkill -x AeroSpace
pkill -x sketchybar
```

## Key Bindings

`alt` is the Option key.

| Keys | Action |
| --- | --- |
| `alt-h`, `alt-j`, `alt-k`, `alt-l` | Focus the window on the left, below, above, or on the right. |
| `alt-shift-h`, `alt-shift-j`, `alt-shift-k`, `alt-shift-l` | Move the window in that direction. |
| `alt-1` to `alt-9` | Go to workspace 1 to 9. |
| `alt-shift-1` to `alt-shift-9` | Move the window to workspace 1 to 9. |
| `alt-tab` | Go back to the previous workspace. |
| `alt-slash` | Switch the layout between tiles in a row and tiles in a column. |

The bar shows the workspaces on the left, with the focused one highlighted, and
the clock on the right. Click a workspace to go to it.

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
| No workspace is highlighted. | Go to another workspace and back. AeroSpace then sends the focused workspace to the bar. |
| You cannot type an Option character, such as in a text field. | AeroSpace uses the `alt` bindings. Change the bindings in `modules/aerospace/configuration.nix`. |
| The start command says an application already runs. | Run the stop command, or stop the application yourself. |

[aerospace]: https://github.com/nikitabobko/AeroSpace
[sketchybar]: https://github.com/FelixKratz/SketchyBar
