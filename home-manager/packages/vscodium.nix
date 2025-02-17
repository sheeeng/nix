{ pkgs, ... }:

{
  programs.vscode = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.enable
    enableExtensionUpdateCheck = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.enableExtensionUpdateCheck
    enableUpdateCheck = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.enableUpdateCheck
    package = pkgs.vscodium; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.package

    extensions = with pkgs.vscode-extensions; [
      aaron-bond.better-comments # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.aaron-bond.better-comments
      adpyke.codesnap # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.adpyke.codesnap
      arrterian.nix-env-selector # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.arrterian.nix-env-selector
      bbenoist.nix
      bierner.github-markdown-preview
      bierner.markdown-checkbox
      bierner.markdown-emoji
      bierner.markdown-footnotes
      bierner.markdown-mermaid
      bierner.markdown-preview-github-styles
      brettm12345.nixfmt-vscode
      catppuccin.catppuccin-vsc # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.catppuccin.catppuccin-vsc-icons
      christian-kohler.path-intellisense
      dart-code.dart-code
      davidanson.vscode-markdownlint
      dbaeumer.vscode-eslint
      dracula-theme.theme-dracula
      eamodio.gitlens
      ecmel.vscode-html-css
      editorconfig.editorconfig
      equinusocio.vsc-material-theme
      equinusocio.vsc-material-theme-icons
      esbenp.prettier-vscode
      formulahendry.auto-close-tag
      foxundermoon.shell-format
      github.codespaces # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.github.codespaces
      github.copilot # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.github.copilot
      github.copilot-chat # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.github.copilot-chat
      github.github-vscode-theme
      github.vscode-github-actions
      github.vscode-pull-request-github
      golang.go
      grapecity.gc-excelviewer # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.grapecity.gc-excelviewer
      hashicorp.terraform
      hediet.vscode-drawio
      james-yu.latex-workshop
      jebbs.plantuml
      jnoortheen.nix-ide # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.jnoortheen.nix-ide
      kamikillerto.vscode-colorize
      marp-team.marp-vscode
      mechatroner.rainbow-csv
      mikestead.dotenv
      mkhl.direnv
      ms-azuretools.vscode-docker
      ms-dotnettools.vscode-dotnet-runtime
      ms-kubernetes-tools.vscode-kubernetes-tools
      ms-python.debugpy
      ms-python.flake8
      ms-python.isort
      ms-python.python
      ms-python.vscode-pylance
      ms-vscode-remote.remote-containers
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit
      ms-vscode-remote.vscode-remote-extensionpack
      ms-vscode.live-server
      ms-vscode.makefile-tools
      ms-vscode.powershell
      ms-vscode.theme-tomorrowkit
      ms-vsliveshare.vsliveshare
      oderwat.indent-rainbow
      pkief.material-icon-theme
      redhat.java
      redhat.vscode-xml
      redhat.vscode-yaml
      rust-lang.rust-analyzer
      sdras.night-owl
      shardulm94.trailing-spaces
      shopify.ruby-lsp
      streetsidesoftware.code-spell-checker
      sumneko.lua
      tamasfe.even-better-toml
      timonwong.shellcheck
      tomoki1207.pdf
      visualstudioexptteam.intellicode-api-usage-examples
      visualstudioexptteam.vscodeintellicode
      vscjava.vscode-gradle
      vscjava.vscode-java-debug
      vscjava.vscode-java-dependency
      vscjava.vscode-java-pack
      vscjava.vscode-java-test
      vscjava.vscode-maven
      vscodevim.vim # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.vscodevim.vim
      xadillax.viml # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.xadillax.viml
      # yzane.markdown-pdf # FIXME: Package ‘ungoogled-chromium-133.0.6943.53’ not available on "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.yzane.markdown-pdf
      yzhang.markdown-all-in-one
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.extensions

    globalSnippets = {
      fixme = {
        body = [
          "$LINE_COMMENT FIXME: $0"
        ];
        description = "Insert a FIXME remark.";
        prefix = [
          "fixme"
        ];
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.globalSnippets

    keybindings = [
      # https://code.visualstudio.com/docs/getstarted/keybindings#_advanced-customization

      {
        key = "ctrl+c";
        command = "editor.action.clipboardCopyAction";
        when = "textInputFocus";
      }
    ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.keybindings

    languageSnippets = {
      haskell = {
        fixme = {
          body = [
            "$LINE_COMMENT FIXME: $0"
          ];
          description = "Insert a FIXME remark";
          prefix = [
            "fixme"
          ];
        };
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.languageSnippets

    mutableExtensionsDir = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.mutableExtensionsDir

    userSettings = {
      # https://code.visualstudio.com/docs/getstarted/settings#_settings-json-file

      # Editor configurations.
      "[nix]"."editor.tabSize" = 2;
      "accessibility.dimUnfocused.enable" = true;
      "accessibility.dimUnfocused.opacity" = 0.35;
      "editor.accessibilitySupport" = "off";
      "editor.bracketPairColorization.enabled" = true;
      "editor.codeActionsOnSave.source.fixAll.eslint" = "never";
      "editor.cursorBlinking" = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.cursorStyle" = "block";
      "editor.detectIndentation" = true;
      "editor.fontFamily" = "FiraCode Nerd Font Mono";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 16;
      "editor.formatOnSave" = true;
      "editor.guides.bracketPairs" = true;
      "editor.guides.bracketPairsHorizontal" = true;
      "editor.guides.highlightActiveBracketPair" = true;
      "editor.insertSpaces" = true;
      "editor.minimap.enabled" = false;
      "editor.minimap.renderCharacters" = false;
      "editor.renderWhitespace" = "all";
      "editor.rulers" = [
        72
        80
        120
      ];
      "editor.semanticHighlighting.enabled" = true;
      "editor.smoothScrolling" = true;
      "editor.suggestSelection" = "first";
      "terminal.integrated.cursorBlinking" = true;
      "terminal.integrated.smoothScrolling" = true;
      "window.autoDetectColorScheme" = true;
      "workbench.iconTheme" = "vscode-icons";
      "workbench.list.smoothScrolling" = true;

      # Putting some conveniences.
      "extensions.autoUpdate" = "onlyEnabledExtensions";
      "files.autoSave" = "on";
      "github.copilot.enable"."*" = false;
      "update.showReleaseNotes" = false;

      # Extensions settings.
      "direnv.restart.automatic" = true;
      "gitlens.plusFeatures.enabled" = false;
      "gitlens.showWelcomeOnInstall" = false;
      "gitlens.showWhatsNewAfterUpgrade" = false;
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.userSettings

    userTasks = {
      version = "2.0.0";
      tasks = [
        {
          type = "shell";
          label = "Hello task";
          command = "hello";
        }
      ];
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.userTasks

    # xdg.mimeApps.defaultApplications = {
    #   "application/json" = [ "code.desktop" ];
    #   "text/plain" = [ "code.desktop" ];
    # }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.xdg.mimeApps.defaultApplications
  };

  home.file.".vscode/argv.json".text = builtins.toJSON {
    disable-hardware-acceleration = true;
    enable-crash-reporter = false;
    locale = "ja";
  };
}
