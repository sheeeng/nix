{ lib, pkgs, ... }:
# nix-darwin only. Optional. A host that imports this module replaces the native macOS window manager
# with AeroSpace and draws a SketchyBar. A host that does not import it keeps the native behavior.
# Do not import this module together with ../yabai, because both enable SketchyBar.
# Try it first without activating it: nix run .#aerospace-trial -- start. See docs/aerospace.md.
let
  configuration = import ./configuration.nix { inherit lib pkgs; };
in
{
  assertions = [
    {
      assertion = pkgs.stdenv.hostPlatform.isAarch64;
      message = "nixpkgs provides AeroSpace for Apple silicon only.";
    }
  ];

  services.aerospace = {
    enable = true; # https://nix-darwin.github.io/nix-darwin/manual/#opt-services.aerospace.enable
    package = pkgs.aerospace; # https://nix-darwin.github.io/nix-darwin/manual/#opt-services.aerospace.package
    inherit (configuration) settings; # https://nix-darwin.github.io/nix-darwin/manual/#opt-services.aerospace.settings
  };

  services.sketchybar = {
    enable = true; # https://nix-darwin.github.io/nix-darwin/manual/#opt-services.sketchybar.enable
    package = pkgs.sketchybar; # https://nix-darwin.github.io/nix-darwin/manual/#opt-services.sketchybar.package
    config = configuration.sketchybarConfig; # https://nix-darwin.github.io/nix-darwin/manual/#opt-services.sketchybar.config
  };
}
