{ pkgs, ... }:

{
  programs.vscode = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.enable
    package = pkgs.vscode; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.package

    mutableExtensionsDir = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.mutableExtensionsDir

    profiles = {
      default = {
        enableExtensionUpdateCheck = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.profiles._name_.enableExtensionUpdateCheck
        enableUpdateCheck = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.profiles._name_.enableUpdateCheck
        extensions =
          with pkgs.vscode-extensions;
          [
            # 4ops.terraform
            # ahmadawais.shades-of-purple

            # error: The option `home-manager.users.leonardlee.home.file.".vscode-oss/extensions/catppuccin.catppuccin-vsc".source' has conflicting definition values:
            # - In `/nix/store/38rarqrxl7yzjdy9xfz862wsywjhy2zv-source/modules/programs/vscode.nix': "/nix/store/11dhknilapbda5kvg36xi9vqjlqsd50d-vscode-extension-catppuccin-catppuccin-vsc-3.16.1/share/vscode/extensions/catppuccin.catppuccin-vsc"
            # - In `/nix/store/38rarqrxl7yzjdy9xfz862wsywjhy2zv-source/modules/programs/vscode.nix': "/nix/store/31ahmpal1lbf0rj4dc1g2c030b0b35m1-vscode-extension-catppuccin-catppuccin-vsc-3.16.1/share/vscode/extensions/catppuccin.catppuccin-vsc"
            # Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
            # (lib.mkForce catppuccin.catppuccin-vsc) # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.catppuccin.catppuccin-vsc
            # (lib.mkForce catppuccin.catppuccin-vsc-icons) # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.catppuccin.catppuccin-vsc-icons
            # ms-python.python # TODO: https://github.com/NixOS/nixpkgs/issues/387828
            # rust-lang.rust-analyzer
            # vscodevim.vim # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.vscodevim.vim
            # yzane.markdown-pdf # FIXME: Package ‘ungoogled-chromium-133.0.6943.53’ not available on "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.yzane.markdown-pdf
            # ms-azuretools.vscode-bicep # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-azuretools.vscode-bicep # FIXME: Temporarily disabled due to Azure CLI Python 3.13 compatibility issue.  the VS Code Bicep extension (ms-azuretools.vscode-bicep) is still enabled, which depends on the Azure CLI. The error is occurring because there's a compatibility issue with Python 3.13 and Azure CLI 2.75.0.
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
            christian-kohler.path-intellisense
            dart-code.dart-code
            davidanson.vscode-markdownlint
            dbaeumer.vscode-eslint
            dracula-theme.theme-dracula # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.dracula-theme.theme-dracula
            eamodio.gitlens
            ecmel.vscode-html-css
            editorconfig.editorconfig
            esbenp.prettier-vscode
            formulahendry.auto-close-tag
            foxundermoon.shell-format
            github.codespaces # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.github.codespaces
            github.copilot # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.github.copilot
            github.copilot-chat # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.github.copilot-chat
            github.github-vscode-theme # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.github.github-vscode-theme
            github.vscode-github-actions # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.github.vscode-github-actions
            github.vscode-pull-request-github # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.github.vscode-pull-request-github
            golang.go # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.golang.go
            grapecity.gc-excelviewer # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.grapecity.gc-excelviewer
            hashicorp.terraform # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.hashicorp.terraform
            haskell.haskell # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.haskell.haskell
            hediet.vscode-drawio # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.hediet.vscode-drawio
            james-yu.latex-workshop # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.james-yu.latex-workshop
            jebbs.plantuml # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.jebbs.plantuml
            jnoortheen.nix-ide # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.jnoortheen.nix-ide
            justusadam.language-haskell # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.justusadam.language-haskell
            kamikillerto.vscode-colorize
            marp-team.marp-vscode
            mechatroner.rainbow-csv
            mikestead.dotenv
            mkhl.direnv
            ms-azuretools.vscode-docker
            ms-dotnettools.vscode-dotnet-runtime
            ms-kubernetes-tools.vscode-kubernetes-tools # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-kubernetes-tools.vscode-kubernetes-tools
            ms-python.debugpy
            ms-python.flake8 # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-python.flake8
            ms-python.isort # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-python.isort
            ms-python.vscode-pylance
            ms-vscode-remote.remote-containers
            ms-vscode-remote.remote-ssh
            ms-vscode-remote.remote-ssh-edit
            ms-vscode-remote.vscode-remote-extensionpack
            ms-vscode.live-server
            ms-vscode.makefile-tools
            ms-vscode.powershell # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-vscode.powershell
            ms-vscode.theme-tomorrowkit
            ms-vsliveshare.vsliveshare
            oderwat.indent-rainbow
            pkief.material-icon-theme
            redhat.java
            redhat.vscode-xml
            redhat.vscode-yaml
            rust-lang.rust-analyzer # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.rust-lang.rust-analyzer
            sdras.night-owl
            shardulm94.trailing-spaces
            shopify.ruby-lsp
            skellock.just # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.skellock.just
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
            vscjava.vscode-maven # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.vscjava.vscode-maven
            xadillax.viml # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.xadillax.viml
            yzhang.markdown-all-in-one # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.yzhang.markdown-all-in-one
          ]
          ++ [
            # isbecker.treefmt-vscode
            (
              (pkgs.vscode-utils.buildVscodeExtension {
                name = "treefmt-vscode-2.2.1";
                pname = "treefmt-vscode";
                src = pkgs.fetchFromGitHub {
                  owner = "isbecker";
                  repo = "treefmt-vscode";
                  rev = "e91d2246e1a1a684ac2065f329ed09fd6cc9dd08";
                  sha256 = "sha256-8NTkPbTfAJkKqhG25vE5WlAFuJ+kldXLQDeEFdQYP5M=";
                };
                version = "2.2.1";
                vscodeExtName = "treefmt-vscode";
                vscodeExtPublisher = "isbecker";
                vscodeExtUniqueId = "isbecker.treefmt-vscode";
              }).overrideAttrs
              (_: {
                sourceRoot = null;
              })
            )

            # ms-kubernetes-tools.vscode-aks-tools
            (pkgs.vscode-utils.buildVscodeExtension {
              name = "vscode-aks-tools";
              pname = "vscode-aks-tools";
              src = pkgs.fetchFromGitHub {
                owner = "Azure";
                repo = "vscode-aks-tools";
                rev = "4de0348be590ab1bdbe88641208fd3a7ea4b3b38"; # 1.6.13
                sha256 = "sha256-PfqZpZfV0deOvAlQuBl+3HC9+zlWvY7UHs/KsVHidZE=";
              };
              version = "1.6.13";
              vscodeExtName = "vscode-aks-tools";
              vscodeExtPublisher = "ms-kubernetes-tools";
              vscodeExtUniqueId = "ms-kubernetes-tools.vscode-aks-tools";
              sourceRoot = ".";
            })

            # ms-vscode.remote-server
            # (pkgs.vscode-utils.buildVscodeExtension {
            #   name = "remote-server";
            #   pname = "remote-server";
            #   src = pkgs.fetchFromGitHub {
            #     owner = "microsoft";
            #     repo = "vscode-remote-release";
            #     rev = "1803940623da0ba648084b5ba0b1265b2b854ae4"; # main
            #     sha256 = "sha256-asyWrxqU10TZSBGdWV86GUUU+rkI4IWuKpvLoWIcH0w=";
            #   };
            #   version = "1.5.1";
            #   vscodeExtName = "remote-server";
            #   vscodeExtPublisher = "ms-vscode";
            #   vscodeExtUniqueId = "ms-vscode.remote-server";
            # })

            # redhat.fabric8-analytics
            (
              (pkgs.vscode-utils.buildVscodeExtension {
                name = "fabric8-analytics";
                pname = "fabric8-analytics";
                src = pkgs.fetchFromGitHub {
                  owner = "fabric8-analytics";
                  repo = "fabric8-analytics-vscode-extension";
                  rev = "78853637aae6aa978dbaf19e920a7edede913eb3"; # v0.9.6
                  sha256 = "sha256-NhLT4RUotsSn20MYmBiGIGkZIy5tJYas4+6oAVQAoZ4=";
                };
                version = "0.9.6";
                vscodeExtName = "fabric8-analytics";
                vscodeExtPublisher = "redhat";
                vscodeExtUniqueId = "redhat.fabric8-analytics";
              }).overrideAttrs
              (_: {
                sourceRoot = null;
              })
            )

            # tintinweb.graphviz-interactive-preview
            # (pkgs.vscode-utils.buildVscodeExtension {
            #   name = "graphviz-interactive-preview";
            #   pname = "graphviz-interactive-preview";
            #   src = pkgs.fetchFromGitHub {
            #     owner = "tintinweb";
            #     repo = "vscode-graphviz-interactive-preview";
            #     rev = "1074d8c264b05c9460aeacf1027fc5c61e43ac29"; # v0.3.5
            #     sha256 = "sha256-asyWrxqU10TZSBGdWV86GUUU+rkI4IWuKpvLoWIcH04=";
            #   };
            #   version = "0.3.5";
            #   vscodeExtName = "graphviz-interactive-preview";
            #   vscodeExtPublisher = "tintinweb";
            #   vscodeExtUniqueId = "tintinweb.graphviz-interactive-preview";
            #   sourceRoot = ".";
            # })

            # # usernamehw.remove-empty-lines
            # (pkgs.vscode-utils.buildVscodeExtension {
            #   name = "remove-empty-lines";
            #   pname = "remove-empty-lines";
            #   src = pkgs.fetchFromGitHub {
            #     owner = "usernamehw";
            #     repo = "vscode-remove-empty-lines";
            #     rev = "v0.5.0";
            #     sha256 = "sha256-asyWrxqU10TZSBGdWV86GUUU+rkI4IWuKpvLoWIcH05=";
            #   };
            #   version = "0.5.0";
            #   vscodeExtName = "remove-empty-lines";
            #   vscodeExtPublisher = "usernamehw";
            #   vscodeExtUniqueId = "usernamehw.remove-empty-lines";
            # })
          ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.profiles._name_.extensions
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
        }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.profiles._name_.globalSnippets

        keybindings = [
          # https://code.visualstudio.com/docs/getstarted/keybindings#_advanced-customization

          {
            args = null; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.profiles._name_.keybindings._.args
            command = "editor.action.clipboardCopyAction"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.profiles._name_.keybindings._.command
            key = "ctrl+c"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.profiles._name_.keybindings._.key
            when = "textInputFocus"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.profiles._name_.keybindings._.when
          }
        ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.profiles._name_.keybindings

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
        }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.profiles._name_.languageSnippets

        userSettings = {
          # https://code.visualstudio.com/docs/getstarted/settings#_settings-json-file

          # Editor configurations.
          "[nix]"."editor.tabSize" = 2;
          "accessibility.dimUnfocused.opacity" = 0.35;
          "editor.accessibilitySupport" = "off";
          "editor.bracketPairColorization.enabled" = true;
          "editor.cursorBlinking" = "smooth";
          "editor.cursorSmoothCaretAnimation" = "on";
          "editor.cursorStyle" = "block";
          "editor.detectIndentation" = true;
          "editor.fontFamily" = "Roboto Nerd Font Mono";
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
          "terminal.integrated.enableVisualBell" = true;
          "terminal.integrated.fontFamily" = "Monaspace Nerd Font Mono";
          "terminal.integrated.fontSize" = 16;
          "terminal.integrated.profiles.linux" = {
            "zsh" = {
              "args" = [
                "-l"
              ];
              "path" = "/usr/bin/zsh -l";
            };
          };
          "terminal.integrated.profiles.osx" = {
            "zsh" = {
              "args" = [
                "-l"
                "-i"
              ];
              "path" = "/bin/zsh -l";
            };
          }; # https://github.com/microsoft/vscode/issues/143061#issuecomment-1042785423
          "terminal.integrated.profiles.windows" = {
            "PowerShell -NoProfile" = {
              "args" = [
                "-NoProfile"
              ];
              "source" = "PowerShell";
            };
          };
          "terminal.integrated.shellIntegration.enabled" = false;
          "terminal.integrated.smoothScrolling" = true;
          "window.autoDetectColorScheme" = true;
          # error: hash mismatch in fixed-output derivation '/nix/store/k11s2vdibpp3xj2dhrbfl3c1lw0nq6gx-vscode-extension-catppuccin-vscode-pnpm-deps.drv':
          #   specified: sha256-ksxzTirYEzgaQOJ+43K6SUAD/UA1b3Mtyc3HDGtMXeM=
          #   got:    sha256-Do6MtqcmqxJNFEX1ECJ9Xa1M2Uhza/BIkJjBlWoZow8=
          # "workbench.colorTheme" = "Catppuccin Mocha";
          # error: The option `home-manager.users.leonardlee.programs.vscode.profiles.default.userSettings."workbench.iconTheme"' has conflicting definition values:
          # - In `/nix/store/kvcll90kcmx02xhjzw8l65gf197wz6y8-source/home-manager/packages/vscodium.nix': "vscode-icons"
          # - In `/nix/store/yasgkycrfdmc9y38qksp357vdvkbnhz0-source/modules/home-manager/vscode.nix': "catppuccin-mocha"
          # Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
          # "workbench.iconTheme" = "vscode-icons";
          # "workbench.preferredLightColorTheme" = "Catppuccin Mocha";
          "workbench.colorTheme" = "Dracula Theme";
          "workbench.iconTheme" = "material-icon-theme";
          "workbench.list.smoothScrolling" = true;
          "workbench.preferredLightColorTheme" = "Dracula Theme";

          "extensions.autoUpdate" = "onlyEnabledExtensions";
          # Putting some conveniences.
          "files.autoSave" = "afterDelay";
          "files.autoSaveDelay" = 2000;
          "github.copilot.chat.codeGeneration.instructions" = [ ];
          "github.copilot.chat.codeGeneration.useInstructionFiles" = true;
          "github.copilot.enable" = {
            "enabled" = true;
          };
          "update.showReleaseNotes" = false;

          # Extensions settings.
          "direnv.restart.automatic" = true;
          "gitlens.plusFeatures.enabled" = false;
        }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.profiles._name_.userSettings

        userTasks = {
          version = "2.0.0";
          tasks = [
            {
              type = "shell";
              label = "Hello task";
              command = "hello";
            }
          ];
        }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.profiles._name_.userTasks
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.profiles

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
