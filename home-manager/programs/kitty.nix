{ pkgs, ... }:
{
  programs.kitty = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.enable
    enableGitIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.enableGitIntegration
    package = pkgs.kitty; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.package

    darwinLaunchOptions = [
      "--single-instance"
      # "--directory=/tmp/my-dir"
      # "--listen-on=unix:/tmp/my-socket"
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.darwinLaunchOptions

    environment = {
      "LS_COLORS" = "1";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.environment

    extraConfig = ''
      mouse_map left click ungrabbed mouse_handle_click prompt
      mouse_map ctrl+left click ungrabbed mouse_handle_click link
      map cmd+c        copy_to_clipboard
      map cmd+v        paste_from_clipboard
      map shift+insert paste_from_clipboard
    ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.extraConfig
    # extraConfig = builtins.readFile ./kitty.conf; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.extraConfig

    # font = {
    #   # package = (
    #   #   # error: nerdfonts has been separated into individual font packages under the namespace nerd-fonts. To list all fonts use `builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)`.
    #   #   pkgs.nerdfonts.override {
    #   #     fonts = [
    #   #       "FiraCode"
    #   #       "JetBrainsMono"
    #   #       "VictorMono"
    #   #     ];
    #   #   }
    #   # );
    #   # https://github.com/NixOS/nixpkgs/blob/9018c7b154ab3427970dbfe52d8a3150e0cecb7b/nixos/doc/manual/release-notes/rl-2505.section.md#L53-L57
    #   # package = pkgs.nerd-fonts.fira-code; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.font.package
    #   # package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; }); # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.font.package
    #   name = "FiraCode Nerd Font Mono"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.font.name
    #   size = 16; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.font.size
    # }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.font

    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+f>2" = "set_font_size 20";

      # Open new windows and tabs
      "cmd+n" = "launch --type=os-window --cwd=current";
      "cmd+t" = "launch --type=tab --cwd=current";

      # Tab navigation
      "cmd+1" = "goto_tab 1";
      "cmd+2" = "goto_tab 2";
      "cmd+3" = "goto_tab 3";
      "cmd+4" = "goto_tab 4";
      "cmd+5" = "goto_tab 5";
      "cmd+6" = "goto_tab 6";

      # Remove line
      "cmd+backspace" = "send_text all \\x15";
      # Move to beginning
      "cmd+left" = "send_text all \\x01";
      # Move to end
      "cmd+right" = "send_text all \\x05";

      # https://github.com/kovidgoyal/kitty/issues/838#issuecomment-2303988124
      "alt+left" = "send_text all \\x1b\\x62";
      "alt+right" = "send_text all \\x1b\\x66";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.keybindings

    shellIntegration = {
      enableBashIntegration = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.shellIntegration.enableBashIntegration
      enableFishIntegration = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.shellIntegration.enableFishIntegration
      enableZshIntegration = false; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.shellIntegration.enableZshIntegration
    };

    # programs.kitty = {
    #   settings = {
    #     # shell = lib.mkForce (lib.getExe pkgs.zsh);
    #     adjust_line_height = "100%";
    #     background = "#262626";
    #     bold_font = "FiraCode Nerd Font Mono Bold";
    #     bold_italic_font = "VictorMono Nerd Font Mono Bold Italic";
    #     confirm_os_window_close = "100";
    #     cursor = "#8fee96";
    #     cursor_blink_interval = "0.5";
    #     cursor_shape = "block";
    #     cursor_stop_blinking_after = "15.0";
    #     disable_ligatures = "cursor";
    #     font_family = "IosevkaTerm Nerd Font Mono";
    #     font_features = "FiraCode-Retina +zero +onum";
    #     font_size = "16.0";
    #     foreground = "#c0b18b";
    #     hide_window_decorations = "titlebar-only";
    #     italic_font = "Inconsolata Nerd Font Mono Italic";
    #     kitty = "+kitten themes";
    #     paste_actions = "quote-urls-at-prompt";
    #     scrollback_lines = "100000";
    #     selection_background = "#d75f5f";
    #     selection_foreground = "#2f2f2f";
    #     shell_integration = "no-cursor ";
    #     show_hyperlink_targets = "yes";
    #     strip_trailing_spaces = "never";
    #     symbol_map = "U+E5FA-U+E62B,U+E700-U+E7C5,U+F000-U+F2E0,U+E200-U+E2A9,U+E0A3,U+E0B4-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+f500-U+fd46 JetBrainsMono Nerd Font";
    #     themeFile = "Catppuccin-Mocha";
    #   };
    # };

    settings = {
      # Keep zsh as the login shell so nix-darwin's PATH/env setup runs, then
      # `exec` into nushell. kitty splits this string shell-style, so the quoted
      # `-c` argument stays a single command. https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.shell
      shell = "${pkgs.lib.getExe pkgs.zsh} --login -c 'exec ${pkgs.lib.getExe pkgs.nushell}'";

      disable_ligatures = "never";
      background = "#262626";

      cursor = "#8fee96";

      cursor_blink_interval = "0.5"; # https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.cursor_blink_interval
      cursor_shape = "block"; # https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.cursor_shape
      cursor_stop_blinking_after = "15.0"; # https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.cursor_stop_blinking_after

      cursor_trail = 100; # https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.cursor_trail
      cursor_trail_decay = "0.1 0.4"; # https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.cursor_trail_decay
      cursor_trail_start_threshold = "2"; # https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.cursor_trail_start_threshold

      font_family = "IosevkaTerm Nerd Font Mono"; # https://sw.kovidgoyal.net/kitty/conf/#fonts
      bold_font = "FiraCode Nerd Font Mono Bold"; # https://sw.kovidgoyal.net/kitty/conf/#fonts
      italic_font = "Inconsolata Nerd Font Mono Italic"; # https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.italic_font
      bold_italic_font = "VictorMono Nerd Font Mono Bold Italic"; # https://sw.kovidgoyal.net/kitty/conf/#fonts

      font_size = "16.0"; # https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.font_size

      force_ltr = "no"; # https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.force_ltr

      font_features = "FiraCode-Retina +zero +onum";
      foreground = "#c0b18b";
      hide_window_decorations = "no"; # https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.hide_window_decorations
      kitty = "+kitten themes";
      paste_actions = "quote-urls-at-prompt";
      scrollback_lines = "100000";
      selection_background = "#d75f5f";
      selection_foreground = "#2f2f2f";

      shell_integration = "no-cursor"; # https://github.com/koekeishiya/dotfiles/blob/094e8cb38a330694d8ed9bd9f74a8dca70a77b46/kitty/kitty.conf#L35
      show_hyperlink_targets = "yes";
      strip_trailing_spaces = "never";
      symbol_map = "U+E5FA-U+E62B,U+E700-U+E7C5,U+F000-U+F2E0,U+E200-U+E2A9,U+E0A3,U+E0B4-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+f500-U+fd46 JetBrainsMono Nerd Font";

      text_composition_strategy = "legacy";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.settings

    themeFile = "Catppuccin-Mocha"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.themeFile
  };
}

# # TODO: https://github.com/nix-community/home-manager/issues/6071#issuecomment-2494688917
# # kitty +list-fonts --psnames | grep "Nerd Font"
# # https://github.com/NixOS/nixpkgs/issues/86349
# # https://github.com/NixOS/nixpkgs/pull/225051/files
# # https://discourse.nixos.org/t/inconsistent-vendoring-in-buildgomodule-when-overriding-source/9225/6

# { pkgs, ... }:
# let
#   # pkgs = import <nixpkgs> {};
#   # myOverriddenPackage = pkgs.myPackage.overrideAttrs (oldAttrs: {

#   # https://github.com/NixOS/nixpkgs/blob/cf99465f46a5ccf4530e4ac23c79c7099b2dc6d7/pkgs/applications/terminal-emulators/kitty/default.nix
#   kitty-nightly = pkgs.kitty.overrideAttrs (oldAttrs: rec {
#     pname = "kitty-nightly"; # https://github.com/NixOS/nixpkgs/blob/a3a67865fbbd5309e4f90d48b68a05da26434e18/pkgs/applications/terminal-emulators/kitty/default.nix#L37
#     version = "nightly"; # https://github.com/NixOS/nixpkgs/blob/a3a67865fbbd5309e4f90d48b68a05da26434e18/pkgs/applications/terminal-emulators/kitty/default.nix#L38

#     src = pkgs.fetchFromGitHub {
#       owner = "kovidgoyal";
#       repo = "kitty";
#       rev = "refs/tags/${version}";
#       # If you don't know the hash for the first time, use `lib.faksHash` to get a fake hash.
#       # hash = lib.fakeHash;
#       # Then, nix will fail the build with an error message:
#       # error: hash mismatch in fixed-output derivation '/nix/store/mh23jmfszqbfpywbsnjzmv0bk3ygp3g0-source.drv':
#       #          specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
#       #             got:    sha256-ZglFhbRSCtTuh6mR4+cUMegagfSv9NzNty0zfU5x7Q8=
#       hash = "sha256-ZglFhbRSCtTuh6mR4+cUMegagfSv9NzNty0zfU5x7Q8=";
#     }; # https://github.com/NixOS/nixpkgs/blob/a3a67865fbbd5309e4f90d48b68a05da26434e18/pkgs/applications/terminal-emulators/kitty/default.nix#L41

#     goModules =
#       (pkgs.buildGo123Module {
#         pname = "kitty-go-modules";
#         inherit src version;
#         vendorHash = "sha256-XWJuCfSYIP7zH1B0sUIvko7wp06s7pTc1gOuPJuwE6Q=";
#       }).goModules; # https://github.com/NixOS/nixpkgs/blob/a3a67865fbbd5309e4f90d48b68a05da26434e18/pkgs/applications/terminal-emulators/kitty/default.nix#L48

#     buildPhase = (
#       oldAttrs.buildPhase
#       + ''
#         echo "Running extra commands in buildPhase..."
#       ''
#     );

#     # https://github.com/NixOS/nixpkgs/blob/c6ce9eaf37c240495d41d8e3b0cb5427e9f598c8/pkgs/applications/terminal-emulators/kitty/default.nix#L202-L243
#     postInstall = ''
#       echo "Running extra commands in postInstall..."
#       ${
#         if pkgs.stdenv.hostPlatform.isDarwin then
#           ''
#             # cp --recursive --verbose kitty.app "$out/Applications/kitty-nightly.app"
#             # ln --symbolic ../Applications/kitty-nightly.app/Contents/MacOS/kitty "$out/bin/kitty-nightly"

#             mv --verbose "$out/bin/kitty" "$out/bin/kitty-nightly"
#             mv --verbose "$out/bin/kitten" "$out/bin/kitten-nightly"
#             mv --verbose "$kitten/bin/kitten" "$kitten/bin/kitten-nightly"
#             mv --verbose "$out/Applications/kitty.app"  "$out/Applications/kitty-nightly.app"

#             echo "kitty-nightly is available at $out/bin/kitty-nightly"
#             # See https://github.com/kovidgoyal/kitty/pull/7970#issuecomment-2426591892.
#           ''
#         else
#           ''
#             # https://github.com/NixOS/nixpkgs/blob/c6ce9eaf37c240495d41d8e3b0cb5427e9f598c8/pkgs/applications/terminal-emulators/kitty/default.nix#L215
#           ''
#       }
#     '';
#   });
# in
# {
#   # If the derivation available in nixpkgs is out-of-date, use `overrideAttrs` to update the source locally.
#   # Install to either `environment.systemPackages` or `home.packages` depending on whether you want it available system-wide or to only a single user using home-manager.
#   # https://github.com/kovidgoyal/kitty/pull/7970
#   home.packages = [ kitty-nightly ];
# }

# # { pkgs, ... }:
# # let
# # in
# # version = "nightly";
# # kittyNightly = pkgs.kitty.overrideAttrs (oldAttrs: {
# #   src = pkgs.fetchFromGitHub {
# #     owner = "kovidgoyal";
# #     repo = "kitty";
# #     rev = "refs/tags/${version}";
# #     hash = "sha256-NvAwsGNmqVIMDmlMAnabh20e6pAXOaOxWuFfTpcSu/s=";
# #     # hash = "sha256-xxM5nqEr7avtJUlcsrA/KXOTxSajIg7kDQM6Q4V+6WM=";
# #     # rev = "4f6ca36bc202c64ed1730aa263d852b2b5a6ac3f";
# #     # hash = "sha256-NvAwsGNmqVIMDmlMAnabh20e6pAXOaOxWuFfTpcSu/s=";
# #     # TODO: GO MODULE DOES NOT WORK
# #     # >        golang.org/x/sys@v0.27.0: is explicitly required in go.mod, but not marked as explicit in vendor/modules.txt
# #     # >        golang.org/x/image@v0.21.0: is marked as explicit in vendor/modules.txt, but not explicitly required in go.mod
# #     # >        golang.org/x/sys@v0.26.0: is marked as explicit in vendor/modules.txt, but not explicitly required in go.mod
# #     # >
# #     # >        To ignore the vendor directory, use -mod=readonly or -mod=mod.
# #     # >        To sync the vendor directory, run:
# #     # >                go mod vendor
# #     # > Traceback (most recent call last):
# #   };
# # });
# # {
# # programs.kitty.package = kittyNightly;
# # }
