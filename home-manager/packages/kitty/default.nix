# https://github.com/RMTT/machines/blob/b9912ad2bba7a9a3aaada1e0c3590b3443938fd4/home/modules/kitty.nix

{ pkgs, ... }:
let
  # pkgs = import <nixpkgs> {};
  # myOverriddenPackage = pkgs.myPackage.overrideAttrs (oldAttrs: {

  # https://github.com/NixOS/nixpkgs/blob/cf99465f46a5ccf4530e4ac23c79c7099b2dc6d7/pkgs/applications/terminal-emulators/kitty/default.nix
  kitty-nightly = pkgs.kitty.overrideAttrs (oldAttrs: rec {
    pname = "kovidgoyal-kitty-nightly"; # https://github.com/NixOS/nixpkgs/blob/a3a67865fbbd5309e4f90d48b68a05da26434e18/pkgs/applications/terminal-emulators/kitty/default.nix#L37
    version = "nightly"; # https://github.com/NixOS/nixpkgs/blob/a3a67865fbbd5309e4f90d48b68a05da26434e18/pkgs/applications/terminal-emulators/kitty/default.nix#L38

    src = pkgs.fetchFromGitHub {
      owner = "kovidgoyal";
      repo = "kitty";
      rev = "refs/tags/${version}";
      # If you don't know the hash for the first time, use `lib.faksHash` to get a fake hash.
      # hash = lib.fakeHash;
      # Then, nix will fail the build with an error message:
      # error: hash mismatch in fixed-output derivation '/nix/store/mh23jmfszqbfpywbsnjzmv0bk3ygp3g0-source.drv':
      #          specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
      #             got:    sha256-IxVyCsR9S/5wHSj5rnee2XEdT8BD/ANReO1pMeiiFRM=
      hash = "sha256-0M4Bvhh3j9vPedE/d+8zaiZdET4mXcrSNUgLllhaPJw=";
    }; # https://github.com/NixOS/nixpkgs/blob/a3a67865fbbd5309e4f90d48b68a05da26434e18/pkgs/applications/terminal-emulators/kitty/default.nix#L41

    goModules =
      (pkgs.buildGo123Module {
        pname = "kitty-go-modules";
        inherit src version;
        vendorHash = "sha256-K12P81jE7oOU7qX2yQ+VtVHX/igKG0nPMSBkZ7wsR0o=";
      }).goModules; # https://github.com/NixOS/nixpkgs/blob/a3a67865fbbd5309e4f90d48b68a05da26434e18/pkgs/applications/terminal-emulators/kitty/default.nix#L48

    buildPhase = (
      oldAttrs.buildPhase
      + ''
        echo "Running extra commands in buildPhase..."
      ''
    );

    # https://github.com/NixOS/nixpkgs/blob/c6ce9eaf37c240495d41d8e3b0cb5427e9f598c8/pkgs/applications/terminal-emulators/kitty/default.nix#L202-L243
    postInstall = ''
      echo "Running extra commands in postInstall..."
      ${
        if pkgs.stdenv.hostPlatform.isDarwin then
          ''
            # cp --recursive --verbose kitty.app "$out/Applications/kitty-nightly.app"
            # ln --symbolic ../Applications/kitty-nightly.app/Contents/MacOS/kitty "$out/bin/kitty-nightly"

            cp --verbose "$out/bin/kitty" "$out/bin/kitty-nightly"
            cp --verbose "$out/bin/kitten" "$out/bin/kitten-nightly"
            cp --verbose "$kitten/bin/kitten" "$kitten/bin/kitten-nightly"
            cp --recursive --verbose "$out/Applications/kitty.app"  "$out/Applications/kitty-nightly.app"

            echo "kitty-nightly is available at $out/bin/kitty-nightly"
            # See https://github.com/kovidgoyal/kitty/pull/7970#issuecomment-2426591892.
          ''
        else
          ''
            # https://github.com/NixOS/nixpkgs/blob/c6ce9eaf37c240495d41d8e3b0cb5427e9f598c8/pkgs/applications/terminal-emulators/kitty/default.nix#L215
          ''
      }
    '';
  });
in
{
  programs.kitty = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.enable
    package = kitty-nightly; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.package

    darwinLaunchOptions = [
      "--single-instance"
      # "--directory=/tmp/my-dir"
      # "--listen-on=unix:/tmp/my-socket"
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.darwinLaunchOptions

    environment = {
      "LS_COLORS" = "1";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.environment

    extraConfig = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.extraConfig

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
      enableBashIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.shellIntegration.enableBashIntegration
      enableFishIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.shellIntegration.enableFishIntegration
      enableZshIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.shellIntegration.enableZshIntegration
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
      disable_ligatures = "never";
      hide_window_decorations = "yes";
      cursor_trail = 3000;
      cursor_trail_decay = "1 2";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.settings

    themeFile = "Catppuccin-Mocha"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.themeFile
  };
}
