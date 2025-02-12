{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Bat, a substitute for cat.
  # https://github.com/sharkdp/bat
  # https://rycee.gitlab.io/home-manager/options.xhtml#opt-programs.bat.enable
  # https://github.com/kpritam/nixpkgs/blob/dbc2a1538b2c6dfd1d11fb97c08203643c723ff0/home/packages.nix#L4-L13
  programs.bat = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.enable
    package = pkgs.bat; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.package
    # TODO: https://github.com/Maka-77x/dotfiles/blob/b66cb03feb5433393197787e2792f870e1ab1e35/home-modules/bat.nix#L26C5-L42C8
    # package = pkgs.bat.overrideAttrs (oldAttrs: rec {
    #   cargoBuildFeatures = (oldAttrs.cargoBuildFeatures or [ ]) ++ [ "lessopen" ];
    #   # TODO: Remove once bat's #2805 is merged and bat has a new release.
    #   # https://github.com/sharkdp/bat/pull/2805
    #   version = "unstable";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "sharkdp";
    #     repo = oldAttrs.pname;
    #     rev = "3e07483f7a5b54ce574485ce38792c70a675e05d";
    #     hash = "sha256-VZUhjD/Uo/YLG4+EwO/t6cT1aHFdmtWox4Kn5ZfuoKg";
    #   };
    #   cargoSha256 = lib.fakeSha256;
    #   cargoDeps = oldAttrs.cargoDeps.overrideAttrs ({
    #     inherit src;
    #     lockFile = "${src}/Cargo.lock";
    #     outputHash = "sha256-/evcZvtygeW8ta1zOr5DNPX3Ej3pYk2AgMRjik1ayLI=";
    #   });
    # });
    config = {
      lessopen = false;
      # pager = "less --tabs=2 --RAW-CONTROL-CHARS --quit-if-one-screen --no-init";
      pager = "${lib.getBin pkgs.moar}/bin/moar";
      style = "plain,numbers,changes,header";
      # theme = "OneHalfDark"; # Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.config
    # Remove once $LESSOPEN support is enabled by default.
    # TODO: https://github.com/Maka-77x/dotfiles/blob/b66cb03feb5433393197787e2792f870e1ab1e35/home-modules/bat.nix
    extraPackages = with pkgs; [
      bat-extras.batdiff
      bat-extras.batgrep
      bat-extras.batman
      bat-extras.batpipe
      bat-extras.batwatch
      glow
      odt2txt
      pdfminer # provides pdf2txt
      python3Packages.docx2txt
      unrar
      unzip # default viewer
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.extraPackages
    syntaxes = {
      gleam = {
        src = pkgs.fetchFromGitHub {
          owner = "molnarmark";
          repo = "sublime-gleam";
          rev = "2e761cdb1a87539d827987f997a20a35efd68aa9";
          hash = "sha256-Zj2DKTcO1t9g18qsNKtpHKElbRSc9nBRE2QBzRn9+qs=";
        };
        file = "syntax/gleam.sublime-syntax";
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.syntaxes
    themes = {
      dracula = {
        src = pkgs.fetchFromGitHub {
          owner = "dracula";
          repo = "sublime"; # Bat uses sublime syntax for its themes
          rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
          sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
        };
        file = "Dracula.tmTheme";
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.themes
  };
}
