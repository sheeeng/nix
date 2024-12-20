# _: { }

{
  config,
  pkgs,
  lib,
  ...
}:
let
  folderFiles = dir: (map (fname: dir + "/${fname}") (builtins.attrNames (builtins.readDir dir)));
in
{
  imports = [
    ./packages.nix
    ./programs.nix
    ./scripts.nix
    # ./secrets/age/age.nix
    # ./theme.nix
  ] ++ (folderFiles ./packages);

  fonts.fontconfig.enable = true;
  # home.stateVersion = "24.11"; # Please read the comment before changing.
  nixpkgs.config.allowUnfree = true;
}

# {
#   config,
#   inputs,
#   lib,
#   pkgs,
#   ...
# }:
# let
#   isLinux = pkgs.stdenv.hostPlatform.isLinux;
#   isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

#   # https://github.com/crasm/dead-simple-home-manager/blob/25bb8e0f43177fbddf3fb9f93c2296613a08e6c7/home.nix
#   isAarch64 = pkgs.stdenv.hostPlatform.isAarch64;
#   isx86_64 = pkgs.stdenv.hostPlatform.isx86_64;
#   # is64Bit = pkgs.stdenv.hostPlatform.is64Bit;

#   # https://www.reddit.com/r/NixOS/comments/16cv3hq/separating_configuration_into_multiple_files_my/
#   # Returns a list of "directory/filename" for all files in a directory.
#   # filesIn = dir: (map (fname: dir + "/${fname}") (builtins.attrNames (builtins.readDir dir)));

#   unsupported = builtins.abort "Unsupported platform";

#   # background = pkgs.fetchurl {
#   #   url = "https://raw.githubusercontent.com/arut0ria/nixos-desktop-config/main/images/672183.jpg";
#   #   sha256 = "0g0z89miryai32w51q2is7p18pwg1mx6jcagjxbaiaamf35hx4wa";
#   # }; # https://github.com/Arut0ria/nixos-desktop-config/blob/901d4f95f615794d278a1ed0cc6e3b4fa9316816/nixosModules/programs/stylix.nix#L3-L6

#   # TODO(x10an14): Add an empty default.nix to inactive directories to ignore it.
#   # TODO(x10an14): folderFiles = dir: (map (fname: dir + "/${fname}") (builtins.attrNames (builtins.readDir dir)));

#   # https://github.com/anomalocaridid/dotfiles/blob/86847ef668e190a2dfd32b66f4367962d9cc31c6/home-modules/default.nix
#   # # Import all nix files in directory
#   # # Should ignore this file and all non-nix files
#   # # Currently, all non-nix files and dirs here are hidden dotfiles
#   # imports = map (file: ./. + "/${file}") (
#   #   lib.strings.filter (file: !lib.strings.hasPrefix "." file && file != "default.nix") (
#   #     builtins.attrNames (builtins.readDir ./.)
#   #   )
#   # );

#   # CREDITS(x10an14)
#   folderFiles = dir: (map (fname: dir + "/${fname}") (builtins.attrNames (builtins.readDir dir)));
# in
# # packagesFiles = builtins.filter (
# #   path: !lib.hasSuffix "inactive" "${builtins.toString path}"
# # ) (folderFiles ./packages);
# # assert lib.assertMsg (builtins.any (p: p == "/Users/leonardlee/.config/home-manager/packages/inactive")) "WTF";
# {
#   imports = [
#     # TODO: Import single directory of files!
#     # Modularize your home.nix by moving statements into other files.
#     # https://discourse.nixos.org/t/how-to-import-into-main-home-nix/55289/2
#     # (filesIn ./packages)
#     ./packages.nix
#     ./programs.nix
#     # ./scripts.nix
#     # ./secrets/age/age.nix
#     # ./theme.nix
#     # ./secrets/age/secrets.nix
#     # ./packages/git/git.nix # TODO: Only read default.nix as the filename.
#     # ./packages/neovide.nix # TODO: Enable on aarch64-darwin host platform only.
#     inputs.mic92-sops-nix.homeManagerModules.sops
#     inputs.nix-community-nixvim.homeManagerModules.nixvim
#     inputs.nix-community-nur.modules.homeManager.default
#     inputs.ryantm-agenix.homeManagerModules.age
#     inputs.yaxitech-ragenix.homeManagerModules.age # https://github.com/tedski999/dots/blob/ab2b24dd76920a449ea6e5527c9aaefe89359454/homes/pkgs/ragenix.nix#L3
#   ] ++ (folderFiles ./packages);

#   # https://github.com/crasm/dead-simple-home-manager/blob/25bb8e0f43177fbddf3fb9f93c2296613a08e6c7/home.nix
#   home.username =
#     if isLinux then
#       "llee"
#     else if isDarwin && isAarch64 then
#       "leonardlee"
#     else if isDarwin && isx86_64 then
#       "lssl"
#     else
#       unsupported; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.username
#   home.homeDirectory =
#     if isLinux then
#       "/home/llee"
#     else if isDarwin && isAarch64 then
#       "/Users/leonardlee"
#     else if isDarwin && isx86_64 then
#       "/Users/lssl"
#     else
#       unsupported; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.homeDirectory

#   # Home Manager needs a bit of information about you and the paths it should
#   # manage.
#   # home.username = "leonardlee";
#   # home.homeDirectory = "/Users/leonardlee";
#   #
#   # https://stackoverflow.com/a/77538532
#   # https://stackoverflow.com/questions/77397833/why-cant-home-manager-read-environment-variables-using-function-builtins-getenv/77538532#77538532
#   # nix run home-manager/master -- init --switch --impure
#   # home.username = builtins.getEnv("USER");
#   # https://github.com/nix-community/home-manager/issues/4407#issuecomment-1717091153
#   # home.homeDirectory = /. + builtins.getEnv("HOME");

#   # This value determines the Home Manager release that your configuration is
#   # compatible with. This helps avoid breakage when a new Home Manager release
#   # introduces backwards incompatible changes.
#   #
#   # You should not change this value, even if you update Home Manager. If you do
#   # want to update the value, then make sure to first check the Home Manager
#   # release notes.
#   home.stateVersion = "24.05"; # Please read the comment before changing.

#   fonts.fontconfig.enable = true;

#   nixpkgs.config.allowUnfree = true;

#   nixpkgs.overlays = [
#     (_final: prev: {
#       rclone = prev.rclone.overrideAttrs (_old: {
#         src = pkgs.fetchFromGitHub {
#           owner = "rclone";
#           repo = "rclone";
#           rev = "a78bc093de82358143719e63e771e099db91d242";
#           hash = "sha256-fPeZFKsommmF98pD18fUFgh8FEq9PGNSrBbR54oAHT8=";
#         };
#         vendorHash = "sha256-Mdh6/4B/B/JsdMwO/1aopuJHE4020nYtBC4GdvdKJvg=";
#       });
#     })

#     # https://github.com/NixOS/nixpkgs/blob/cf99465f46a5ccf4530e4ac23c79c7099b2dc6d7/pkgs/applications/terminal-emulators/kitty/default.nix
#     # (final: prev: {
#     #   kitty-nightly = prev.kitty.overrideAttrs (rec {
#     #     pname = "kitty-nightly"; # https://github.com/NixOS/nixpkgs/blob/a3a67865fbbd5309e4f90d48b68a05da26434e18/pkgs/applications/terminal-emulators/kitty/default.nix#L37
#     #     version = "nightly"; # https://github.com/NixOS/nixpkgs/blob/a3a67865fbbd5309e4f90d48b68a05da26434e18/pkgs/applications/terminal-emulators/kitty/default.nix#L38
#     #     src = pkgs.fetchFromGitHub {
#     #       owner = "kovidgoyal";
#     #       repo = "kitty";
#     #       rev = "refs/tags/${version}";
#     #       # If you don't know the hash for the first time, use `lib.faksHash` to get a fake hash.
#     #       # hash = lib.fakeHash;
#     #       # Then, nix will fail the build with an error message:
#     #       # error: hash mismatch in fixed-output derivation '/nix/store/mh23jmfszqbfpywbsnjzmv0bk3ygp3g0-source.drv':
#     #       #           specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
#     #       #             got:    sha256-aOXVT/w9SVvoHdy10w5I1GpmS7oQ+o1PvHMdvPsq+Dc=
#     #       hash = "sha256-rAO/B2bYF+RsHiBndPSHPbKiluDWwtkiGBNBIzMn1oY=";
#     #     }; # https://github.com/NixOS/nixpkgs/blob/a3a67865fbbd5309e4f90d48b68a05da26434e18/pkgs/applications/terminal-emulators/kitty/default.nix#L41
#     #     goModules =
#     #       (pkgs.buildGo123Module {
#     #         pname = "kitty-go-modules";
#     #         inherit src version;
#     #         vendorHash = "sha256-XWJuCfSYIP7zH1B0sUIvko7wp06s7pTc1gOuPJuwE6Q=";
#     #       }).goModules; # https://github.com/NixOS/nixpkgs/blob/a3a67865fbbd5309e4f90d48b68a05da26434e18/pkgs/applications/terminal-emulators/kitty/default.nix#L48
#     #     meta = with lib; {
#     #       homepage = "https://github.com/kovidgoyal/kitty/releases/tag/nightly"; # https://github.com/NixOS/nixpkgs/blob/cf99465f46a5ccf4530e4ac23c79c7099b2dc6d7/pkgs/applications/terminal-emulators/kitty/default.nix#L253
#     #       changelog = [
#     #         "https://github.com/kovidgoyal/kitty/releases/tag/nightly"
#     #       ];
#     #       mainProgram = "kitty-nightly";
#     #     };
#     #   });
#     # })

#     # https://github.com/wochap/nix-config/blob/main/modules/shared/programs/cli/zsh/default.nix#L33-L43
#     # https://github.com/NixOS/nixpkgs/blob/e405f30513169feedb64b5c25e7b00242010af58/pkgs/by-name/zs/zsh-abbr/package.nix#L21-L31
#     # (final: prev: {
#     #   zsh-abbr = prev.zsh-abbr.overrideAttrs (oldAttrs: rec {
#     #     # Install completions and man page
#     #     installPhase = ''
#     #       mkdir -p $out/share/zsh-abbr
#     #       cp zsh-abbr.zsh zsh-abbr.plugin.zsh $out/share/zsh-abbr
#     #       install -D completions/_abbr $out/share/zsh/site-functions/_abbr
#     #       install -D man/man1/abbr.1 $out/share/man/man1/abbr.1
#     #     '';
#     #   });
#     # })
#   ];

#   home.packages =
#     with pkgs;
#     (
#       [
#         # Common packages
#         # Adds the 'hello' command to your environment. It prints a friendly
#         # "Hello, world!" when run.
#         # hello

#         # It is sometimes useful to fine-tune packages, for example, by applying
#         # overrides. You can do that directly here, just don't forget the
#         # parentheses. Maybe you want to install Nerd Fonts with a limited number of
#         # fonts?
#         #
#         # error: nerdfonts has been separated into individual font packages under the namespace nerd-fonts. To list all fonts use `builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)`.
#         # (nerdfonts.override {
#         #   fonts = [
#         #     "DejaVuSansMono"
#         #     "DroidSansMono"
#         #     "FantasqueSansMono"
#         #     "FiraCode"
#         #     "FiraMono"
#         #     "Inconsolata"
#         #     "JetBrainsMono"
#         #     "Iosevka"
#         #     "IosevkaTerm"
#         #     "IosevkaTermSlab"
#         #     "VictorMono"
#         #   ];
#         # })
#       ]
#       ++ lib.optionals isLinux [
#         # GNU/Linux Packages
#         bitwarden-desktop
#         firejail
#         fluffychat
#         iproute2
#         mpv
#         pinentry-all
#         util-linux
#       ]
#       ++ lib.optionals isDarwin [
#         iproute2mac
#         pinentry_mac
#       ]
#       ++ lib.optionals (isDarwin && stdenv.isx86_64) [
#         # macOS packages on Intel Chip
#         hexdump
#       ]
#       ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
#         # neovide # TODO: https://github.com/nix-community/home-manager/issues/6087
#         # macOS packages on Apple "M" Series System on a Chip
#       ]
#     );

#   # # The home.packages option allows you to install Nix packages into your
#   # # environment.
#   # home.packages = [
#   #   # Adds the 'hello' command to your environment. It prints a friendly
#   #   # "Hello, world!" when run.
#   #   pkgs.hello

#   #   # It is sometimes useful to fine-tune packages, for example, by applying
#   #   # overrides. You can do that directly here, just don't forget the
#   #   # parentheses. Maybe you want to install Nerd Fonts with a limited number of
#   #   # fonts?
#   #   (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

#   #   # You can also create simple shell scripts directly inside your
#   #   # configuration. For example, this adds a command 'my-hello' to your
#   #   # environment:
#   #   (pkgs.writeShellScriptBin "my-hello" ''
#   #     echo "Hello, ${config.home.username}!"
#   #   '')
#   # ];

#   # Home Manager is pretty good at managing dotfiles. The primary way to manage
#   # plain files is through 'home.file'.
#   # home.file = {
#   #   # Building this configuration will create a copy of 'dotfiles/screenrc' in
#   #   # the Nix store. Activating the configuration will then make '~/.screenrc' a
#   #   # symlink to the Nix store copy.
#   #   ".screenrc".source = packages/screen/screenrc;

#   #   # You can also set the file content immediately.
#   #   ".gradle/gradle.properties".text = ''
#   #     org.gradle.console=verbose
#   #     org.gradle.daemon.idletimeout=3600000
#   #   '';

#   #   # # https://github.com/yrashk/nix-home/blob/55fc51e1954184e0f5d9a00916963e2ce8b56d21/home.nix#L284-L291
#   #   # ".tmux.conf" = {
#   #   #   text = ''
#   #   #     set-option -g default-shell /run/current-system/sw/bin/fish
#   #   #     set-window-option -g mode-keys vi
#   #   #     set -g default-terminal "screen-256color"
#   #   #     set -ga terminal-overrides ',screen-256color:Tc'
#   #   #   '';
#   #   # };
#   # };

#   # Home Manager can also manage your environment variables through
#   # 'home.sessionVariables'. These will be explicitly sourced when using a
#   # shell provided by Home Manager. If you don't want to manage your shell
#   # through Home Manager then you have to manually source 'hm-session-vars.sh'
#   # located at either
#   #
#   #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
#   #
#   # or
#   #
#   #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
#   #
#   # or
#   #
#   #  /etc/profiles/per-user/leonardlee/etc/profile.d/hm-session-vars.sh

#   home.sessionVariables = {
#     # EDITOR = "vim";
#     LANG = "en_US.UTF-8";
#     # VISUAL = "vim";
#     # https://github.com/d12frosted/environment/blob/85c1daa00c793e60f71f5e3259d29ecbb69db0c9/nix/home.nix#L22-L36
#     ASPELL_CONF = "dict-dir ${config.home.homeDirectory}/.nix-profile/lib/aspell";
#     NIX_CONF = "${config.xdg.configHome}/nix"; # ${HOME}/.config/nix
#     XDG_CACHE_HOME = config.xdg.cacheHome; # ${HOME}/.cache
#     XDG_CONFIG_HOME = config.xdg.configHome; # ${HOME}/.config
#     XDG_DATA_HOME = config.xdg.dataHome; # ${HOME}/.local/share
#   };

#   nix = {
#     package = pkgs.nix; # https://nix-community.github.io/home-manager/options.xhtml#opt-nix.package
#     channels = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-nix.channels
#     checkConfig = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-nix.checkConfig
#     # extraOptions = ''
#     #   keep-derivations = true
#     #   keep-outputs = true
#     # ''; # https://nix-community.github.io/home-manager/options.xhtml#opt-nix.extraOptions
#     gc = {
#       automatic = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-nix.gc.automatic
#       frequency = "weekly"; # https://nix-community.github.io/home-manager/options.xhtml#opt-nix.gc.frequency
#       options = "--delete-older-than 7d"; # https://nix-community.github.io/home-manager/options.xhtml#opt-nix.gc.options
#       persistent = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-nix.gc.persistent
#       randomizedDelaySec = 0; # https://nix-community.github.io/home-manager/options.xhtml#opt-nix.gc.randomizedDelaySec
#     };
#     keepOldNixPath = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-nix.keepOldNixPath
#     nixPath = [ ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-nix.nixPath
#     registry = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-nix.registry
#     settings = rec {
#       # https://github.com/spikespaz/dotfiles/blob/c424772e21ff7751402e28f222543e74201a0ea1/hosts/intrepid/misc.nix#L35-L78
#       # abort-on-warn = false; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-abort-on-warn
#       # extra-experimental-features = "auto-allocate-uids flakes nix-command"; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-accept-flake-config
#       # accept-flake-config = false; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-accept-flake-config
#       # allow-dirty = true; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-allow-dirty
#       # access-tokens = "github.com=${config.age.secrets."nix-configuration-github-token".path}"; # TODO # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-access-tokens
#       # allow-import-from-derivation = true; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-allow-import-from-derivation
#       # # allow-new-privileges = false; # FIXME: Linux-specific. # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-allow-new-privileges
#       # allow-symlinked-store = false; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-allow-symlinked-store
#       # allow-unsafe-native-code-during-evaluation = false; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-allow-unsafe-native-code-during-evaluation
#       # allowed-impure-host-deps = null; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-allowed-impure-host-deps
#       # allowed-users = [
#       #   config.home.username
#       #   "root"
#       # ]; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-allowed-users
#       # always-allow-substitutes = false; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-always-allow-substitutes
#       # auto-allocate-uids = false; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-auto-allocate-uids
#       # auto-optimise-store = false; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-auto-optimise-store
#       # bash-prompt = null; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-bash-prompt
#       # bash-prompt-prefix = null; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-bash-prompt-prefix
#       # bash-prompt-suffix = null; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-bash-prompt-suffix
#       # # build-dir = null; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-build-dir
#       # # build-hook = null; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-build-hook
#       # # build-poll-interval= 5; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-build-poll-interval
#       # # build-users-group = null; # https://nix.dev/manual/nix/2.25/command-ref/conf-file.html#conf-build-users-group
#       # cores = 4;
#       # keep-going = false;
#       # log-lines = 20;
#       # extra-substituters = [ "https://devenv.cachix.org" ];
#       # extra-trusted-public-keys = [ "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];
#       # trusted-users = [
#       #   config.home.username
#       #   "root"
#       # ]; # https://nix.dev/manual/nix/2.25/command-ref/conf-file#conf-trusted-users
#     }; # https://nix-community.github.io/home-manager/options.xhtml#opt-nix.settings
#   };

#   # age.secrets."wakatime.cfg".path = "${config.xdg.homeDirectory}/.wakatime.cfg";

#   # age.secrets.nix-access-tokens-github.file = "${self}/secrets/root.nix-access-tokens-github.age";
#   # nix.extraOptions = ''
#   #   !include ${config.age.secrets.nix-access-tokens-github.path}
#   # ''; # https://github.com/spikespaz/dotfiles/blob/c424772e21ff7751402e28f222543e74201a0ea1/hosts/intrepid/misc.nix#L81-L85
# }
