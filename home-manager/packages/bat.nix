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
    enable = true;
    # package = pkgs.bat;
    # TODO: https://github.com/Maka-77x/dotfiles/blob/b66cb03feb5433393197787e2792f870e1ab1e35/home-modules/bat.nix#L26C5-L42C8
    package = pkgs.bat.overrideAttrs (oldAttrs: rec {
      cargoBuildFeatures = (oldAttrs.cargoBuildFeatures or [ ]) ++ [ "lessopen" ];
      # TODO: Remove once bat's #2805 is merged and bat has a new release.
      # https://github.com/sharkdp/bat/pull/2805
      version = "unstable";
      src = pkgs.fetchFromGitHub {
        owner = "sharkdp";
        repo = oldAttrs.pname;
        rev = "3e07483f7a5b54ce574485ce38792c70a675e05d";
        hash = "sha256-VZUhjD/Uo/YLG4+EwO/t6cT1aHFdmtWox4Kn5ZfuoKg";
      };
      cargoDeps = oldAttrs.cargoDeps.overrideAttrs ({
        inherit src;
        lockFile = "${src}/Cargo.lock";
        outputHash = "sha256-/evcZvtygeW8ta1zOr5DNPX3Ej3pYk2AgMRjik1ayLI=";
      });
    });
    config = {
      lessopen = false;
      pager = "less --tabs=2 --RAW-CONTROL-CHARS --quit-if-one-screen --no-init";
      style = "numbers,changes,header";
      # theme = "OneHalfDark"; # Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
    };
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
    ];
    syntaxes = { };
    themes = { };
  };

  # https://github.com/krad246/nix-systems/blob/5ca592259bcf44cda525091994aeaf7e85d58694/modules/home/shellenv/bat.nix#L13-L33
  home = {
    shellAliases = rec {
      cat = lib.getExe config.programs.bat.package;
      bag = lib.getExe pkgs.bat-extras.batgrep;
      man = lib.getExe pkgs.bat-extras.batman;
      watch = lib.getExe (pkgs.bat-extras.batwatch.override { withEntr = true; });
      tail = watch;
      diff = lib.getExe (pkgs.bat-extras.batdiff.override { withDelta = true; });
    };

    sessionVariables = {
      BATDIFF_USE_DELTA = lib.trivial.boolToString true;
      LESSOPEN = "|${lib.getExe pkgs.bat-extras.batpipe} %s";
      LESS = "$LESS -R";
      BATPIPE = "color";
    };

    packages = with pkgs; [
      entr
      delta
    ];
  };

  # Designate Unicode Private Use Areas as printable characters
  # Needed for Nerd Fonts icons to display properly
  home.sessionVariables.LESSUTFCHARDEF = "E000-F8FF:p,F0000-FFFFD:p,100000-10FFFD:p";
  # Custom batpipe viewers
  xdg.configFile."batpipe/viewers.d/custom.sh".text =
    let
      makeViewer =
        {
          command,
          filetype,
          header ? "",
        }:
        let
          program = builtins.elemAt (lib.strings.splitString " " command) 0;
        in
        #sh
        ''
          BATPIPE_VIEWERS+=("${program}")

          viewer_${program}_supports() {
            command -v "${program}" $> /dev/null || return 1

            case "$1" in
              ${filetype}) return 0;;
            esac

            return 1
          }

          viewer_${program}_process() {
            ${header}
            ${command}
            return "$?"
          }
        '';
      batpipe_archive_header = # sh
        ''
          batpipe_header    "Viewing contents of archive: %{PATH}%s" "$1"
          batpipe_subheader "To view files within the archive, add the file path after the archive."
        '';
      batpipe_document_header = ''batpipe_header "Viewing text of document: %{PATH}%s" "$1"'';
    in
    lib.strings.concatMapStrings makeViewer [
      {
        command = ''docx2txt "$1"'';
        filetype = "*.docx";
        header = batpipe_document_header;
      }
      {
        # FIXME: Does not work with bat for some reason
        command = ''glow "$1"'';
        filetype = "*.md";
      }
      {
        command = ''odt2txt "$1"'';
        filetype = "*.odt";
        header = batpipe_document_header;
      }
      {
        command = ''pdf2txt "$1"'';
        filetype = "*.pdf";
        header = batpipe_document_header;
      }
      {
        command = ''unrar "$1"'';
        filetype = "*.rar";
        header = batpipe_archive_header;
      }
    ];
}
