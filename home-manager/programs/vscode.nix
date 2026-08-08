{ pkgs, lib, ... }:
let
  # Extensions that require LLVM/compiler-rt (disabled on Intel macOS due to build issues)
  # > ninja: build stopped: subcommand failed.
  #        For full logs, run:
  #          nix log /nix/store/gj40yabysxzjap3fgkw4lq0z0qyi28v5-compiler-rt-libc-20.1.8.drv
  # apple-macos != x86_64-apple-darwin argument to a nix-wrapped compiler may not work correctly - cc-wrapper is currently not designed with multi-target compilers in mind. You may want to use an un-wrapped compiler instead.
  #        > ld: warning: changing Mac Catalyst minOS version from 13.1 to 17.0
  #        > ld: -sdk_version may not be used for zippered binaries
  #        > clang++: error: linker command failed with exit code 1 (use -v to see invocation)
  #        > [746/797] Building CXX object lib/tsan/rtl/CMakeFiles/RTTsan_dynamic.osx.dir/tsan_ignoreset.cpp.o
  #        > Warning: supplying the --target x86_64-apple-macos != x86_64-apple-darwin argument to a nix-wrapped compiler may not work correctly - cc-wrapper is currently not designed with multi-target compilers in mind. You may want to use an un-wrapped compiler instead.
  #        > [747/797] Building CXX object lib/tsan/rtl/CMakeFiles/RTTsan_dynamic.osx.dir/tsan_external.cpp.o
  #        > Warning: supplying the --target x86_64-apple-macos != x86_64-apple-darwin argument to a nix-wrapped compiler may not work correctly - cc-wrapper is currently not designed with multi-target compilers in mind. You may want to use an un-wrapped compiler instead.
  #        > [748/797] Building CXX object lib/tsan/rtl/CMakeFiles/RTTsan_dynamic.osx.dir/tsan_debugging.cpp.o
  #        > Warning: supplying the --target x86_64-apple-macos != x86_64-apple-darwin argument to a nix-wrapped compiler may not work correctly - cc-wrapper is currently not designed with multi-target compilers in mind. You may want to use an un-wrapped compiler instead.
  #        > [749/797] Building CXX object lib/tsan/rtl/CMakeFiles/RTTsan_dynamic.osx.dir/tsan_flags.cpp.o
  #        > Warning: supplying the --target x86_64-apple-macos != x86_64-apple-darwin argument to a nix-wrapped compiler may not work correctly - cc-wrapper is currently not designed with multi-target compilers in mind. You may want to use an un-wrapped compiler instead.
  #        > [750/797] Building CXX object lib/tsan/rtl/CMakeFiles/RTTsan_dynamic.osx.dir/tsan_interface.cpp.o
  #        > Warning: supplying the --target x86_64-apple-macos != x86_64-apple-darwin argument to a nix-wrapped compiler may not work correctly - cc-wrapper is currently not designed with multi-target compilers in mind. You may want to use an un-wrapped compiler instead.
  #        > [751/797] Building CXX object lib/tsan/rtl/CMakeFiles/RTTsan_dynamic.osx.dir/tsan_fd.cpp.o
  #        > Warning: supplying the --target x86_64-apple-macos != x86_64-apple-darwin argument to a nix-wrapped compiler may not work correctly - cc-wrapper is currently not designed with multi-target compilers in mind. You may want to use an un-wrapped compiler instead.
  #        > [752/797] Building CXX object lib/tsan/rtl/CMakeFiles/RTTsan_dynamic.osx.dir/tsan_interceptors_memintrinsics.cpp.o
  #        > Warning: supplying the --target x86_64-apple-macos != x86_64-apple-darwin argument to a nix-wrapped compiler may not work correctly - cc-wrapper is currently not designed with multi-target compilers in mind. You may want to use an un-wrapped compiler instead.
  #        > [753/797] Building CXX object lib/orc/CMakeFiles/RTOrc.osx.dir/macho_platform.cpp.o
  #        > Warning: supplying the --target x86_64-apple-macos != x86_64-apple-darwin argument to a nix-wrapped compiler may not work correctly - cc-wrapper is currently not designed with multi-target compilers in mind. You may want to use an un-wrapped compiler instead.
  #        > [754/797] Building CXX object lib/tsan/rtl/CMakeFiles/RTTsan_dynamic.osx.dir/tsan_interceptors_posix.cpp.o
  #        > Warning: supplying the --target x86_64-apple-macos != x86_64-apple-darwin argument to a nix-wrapped compiler may not work correctly - cc-wrapper is currently not designed with multi-target compilers in mind. You may want to use an un-wrapped compiler instead.
  #        > ninja: build stopped: subcommand failed.
  #        For full logs, run:
  #          nix log /nix/store/gj40yabysxzjap3fgkw4lq0z0qyi28v5-compiler-rt-libc-20.1.8.drv
  # error: Cannot build '/nix/store/kky8b9s3xayvm13g5hgmr2h7ns2ywn8c-clang-wrapper-20.1.8.drv'.
  #        Reason: 1 dependency failed.
  #        Output paths:
  #          /nix/store/gn0p7flixqbx788pa3xyp1yzkw0sxrm0-clang-wrapper-20.1.8
  # error: Cannot build '/nix/store/kky8b9s3xayvm13g5hgmr2h7ns2ywn8c-clang-wrapper-20.1.8.drv'.
  #        Reason: 1 dependency failed.
  #        Output paths:
  #          /nix/store/gn0p7flixqbx788pa3xyp1yzkw0sxrm0-clang-wrapper-20.1.8
  # error: Cannot build '/nix/store/0alc7b1k24y097889mv7v299aa86497c-rust-analyzer-0.3.2593.vsix.drv'.
  #        Reason: 1 dependency failed.
  #        Output paths:
  #          /nix/store/9kj3dg4w4423634wdb2d9kxjyfq9npcg-rust-analyzer-0.3.2593.vsix
  # error: Cannot build '/nix/store/0alc7b1k24y097889mv7v299aa86497c-rust-analyzer-0.3.2593.vsix.drv'.
  #        Reason: 1 dependency failed.
  #        Output paths:
  #          /nix/store/9kj3dg4w4423634wdb2d9kxjyfq9npcg-rust-analyzer-0.3.2593.vsix
  # error: Cannot build '/nix/store/67fbaik9s517cg5sd59bl9zv5fg0g52i-vscode-extension-gemini-cli-vscode-ide-companion-0.22.5.vsix.drv'.
  #        Reason: 1 dependency failed.
  #        Output paths:
  #          /nix/store/a4m0jgqbxmm9wvi7kiga48lxphaijmxv-vscode-extension-gemini-cli-vscode-ide-companion-0.22.5.vsix
  # error: Cannot build '/nix/store/67fbaik9s517cg5sd59bl9zv5fg0g52i-vscode-extension-gemini-cli-vscode-ide-companion-0.22.5.vsix.drv'.
  #        Reason: 1 dependency failed.
  #        Output paths:
  #          /nix/store/a4m0jgqbxmm9wvi7kiga48lxphaijmxv-vscode-extension-gemini-cli-vscode-ide-companion-0.22.5.vsix
  # error: Cannot build '/nix/store/hwhzy08fda7ph57m6yp11wfnp3jg2y6f-vscode-extension-gemini-cli-vscode-ide-companion-0.22.5.drv'.
  #        Reason: 1 dependency failed.
  #        Output paths:
  #          /nix/store/yd47ixndavcsyz7x7m876k58fjcv70zm-vscode-extension-gemini-cli-vscode-ide-companion-0.22.5
  # error: Cannot build '/nix/store/hwhzy08fda7ph57m6yp11wfnp3jg2y6f-vscode-extension-gemini-cli-vscode-ide-companion-0.22.5.drv'.
  #        Reason: 1 dependency failed.
  #        Output paths:
  #          /nix/store/yd47ixndavcsyz7x7m876k58fjcv70zm-vscode-extension-gemini-cli-vscode-ide-companion-0.22.5
  # error: Cannot build '/nix/store/sw90qyp6hprwxcap4diq7nlmi1w08cc9-hm_.vscodeextensions.extensionsimmutable.json.drv'.
  #        Reason: 1 dependency failed.
  #        Output paths:
  #          /nix/store/bhj0fl9ayc71fj600q98fgn1jiicij2a-hm_.vscodeextensions.extensionsimmutable.json
  # error: Cannot build '/nix/store/sw90qyp6hprwxcap4diq7nlmi1w08cc9-hm_.vscodeextensions.extensionsimmutable.json.drv'.
  #        Reason: 1 dependency failed.
  #        Output paths:
  #          /nix/store/bhj0fl9ayc71fj600q98fgn1jiicij2a-hm_.vscodeextensions.extensionsimmutable.json
  # error: Cannot build '/nix/store/jik5vnjxmpbzr8y8n5fhr6vr53r7xjrc-home-manager-files.drv'.
  #        Reason: 1 dependency failed.
  #        Output paths:
  #          /nix/store/hkcy9fsywkz7lgxifw5b4pjylmfkp458-home-manager-files
  # error: Cannot build '/nix/store/jik5vnjxmpbzr8y8n5fhr6vr53r7xjrc-home-manager-files.drv'.
  #        Reason: 1 dependency failed.
  #        Output paths:
  #          /nix/store/hkcy9fsywkz7lgxifw5b4pjylmfkp458-home-manager-files
  # error: Cannot build '/nix/store/gaspv0di2gbbb46qhv2l2b421j9gnygs-home-manager-generation.drv'.
  #        Reason: 1 dependency failed.
  #        Output paths:
  #          /nix/store/n5i37r37wg0p1l5qj7xkshg7f1fzhckk-home-manager-generation
  # error: Cannot build '/nix/store/gaspv0di2gbbb46qhv2l2b421j9gnygs-home-manager-generation.drv'.
  #        Reason: 1 dependency failed.
  #        Output paths:
  #          /nix/store/n5i37r37wg0p1l5qj7xkshg7f1fzhckk-home-manager-generation
  # error: Cannot build '/nix/store/ab08mvgxdmhpf5zyf884ahylcwmsm2kz-activation-lssl.drv'.
  #        Reason: 1 dependency failed.
  #        Output paths:
  #          /nix/store/zfjavf96m92zmf3m4i3b64i2sdlrvpqp-activation-lssl
  # error: Cannot build '/nix/store/ab08mvgxdmhpf5zyf884ahylcwmsm2kz-activation-lssl.drv'.
  #        Reason: 1 dependency failed.
  #        Output paths:
  #          /nix/store/zfjavf96m92zmf3m4i3b64i2sdlrvpqp-activation-lssl
  # error: Cannot build '/nix/store/m6bp11ypg5v3avpyzm72af9f8nkb3yhk-darwin-system-26.05.c31afa6.drv'.
  #        Reason: 1 dependency failed.
  #        Output paths:
  #          /nix/store/z3010bcdflwfljji7phjagsrl0dfmadx-darwin-system-26.05.c31afa6
  # error: Cannot build '/nix/store/m6bp11ypg5v3avpyzm72af9f8nkb3yhk-darwin-system-26.05.c31afa6.drv'.
  #        Reason: 1 dependency failed.
  #        Output paths:
  #          /nix/store/z3010bcdflwfljji7phjagsrl0dfmadx-darwin-system-26.05.c31afa6
  llvmDependentExtensions = with pkgs.vscode-extensions; [
    Google.gemini-cli-vscode-ide-companion # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.Google.gemini-cli-vscode-ide-companion
    rust-lang.rust-analyzer # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.rust-lang.rust-analyzer
  ];
in
{
  programs.vscode = {
    # Workaround https://github.com/NixOS/nixpkgs/issues/476838 issue.
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
            ms-python.python # https://search.nixos.org/packages?channel=unstable&type=packages&show=vscode-extensions.ms-python.python
            # rust-lang.rust-analyzer
            # vscodevim.vim # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.vscodevim.vim
            # yzane.markdown-pdf # FIXME: Package ‘ungoogled-chromium-133.0.6943.53’ not available on "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.yzane.markdown-pdf
            # ms-azuretools.vscode-bicep # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-azuretools.vscode-bicep # FIXME: Temporarily disabled due to Azure CLI Python 3.13 compatibility issue.  the VS Code Bicep extension (ms-azuretools.vscode-bicep) is still enabled, which depends on the Azure CLI. The error is occurring because there's a compatibility issue with Python 3.13 and Azure CLI 2.75.0.

            # keep-sorted start block=no case=no newline_separated=no sticky_comments=no
            # eamodio.gitlens # TODO: Enable after https://github.com/NixOS/nixpkgs/issues/462082 is fixed upstream.
            # Google.gemini-cli-vscode-ide-companion # Moved to llvmDependentExtensions (disabled on Intel macOS)
            # rust-lang.rust-analyzer # Moved to llvmDependentExtensions (disabled on Intel macOS)
            aaron-bond.better-comments # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.aaron-bond.better-comments
            adpyke.codesnap # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.adpyke.codesnap
            arrterian.nix-env-selector # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.arrterian.nix-env-selector
            bbenoist.nix # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.bbenoist.nix
            bierner.github-markdown-preview # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.bierner.github-markdown-preview
            bierner.markdown-checkbox # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.bierner.markdown-checkbox
            bierner.markdown-emoji # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.bierner.markdown-emoji
            bierner.markdown-footnotes # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.bierner.markdown-footnotes
            bierner.markdown-mermaid # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.bierner.markdown-mermaid
            bierner.markdown-preview-github-styles # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.bierner.markdown-preview-github-styles
            brettm12345.nixfmt-vscode # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.brettm12345.nixfmt-vscode
            christian-kohler.path-intellisense # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.christian-kohler.path-intellisense
            dart-code.dart-code # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.dart-code.dart-code
            davidanson.vscode-markdownlint # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.davidanson.vscode-markdownlint
            dbaeumer.vscode-eslint # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.dbaeumer.vscode-eslint
            dracula-theme.theme-dracula # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.dracula-theme.theme-dracula
            ecmel.vscode-html-css # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ecmel.vscode-html-css
            editorconfig.editorconfig # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.editorconfig.editorconfig
            esbenp.prettier-vscode # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.esbenp.prettier-vscode
            formulahendry.auto-close-tag # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.formulahendry.auto-close-tag
            foxundermoon.shell-format # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.foxundermoon.shell-format
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
            kamikillerto.vscode-colorize # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.kamikillerto.vscode-colorize
            marp-team.marp-vscode # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.marp-team.marp-vscode
            mechatroner.rainbow-csv # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.mechatroner.rainbow-csv
            mikestead.dotenv # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.mikestead.dotenv
            mkhl.direnv # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.mkhl.direnv
            ms-azuretools.vscode-docker # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-azuretools.vscode-docker
            ms-dotnettools.vscode-dotnet-runtime # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-dotnettools.vscode-dotnet-runtime
            ms-kubernetes-tools.vscode-kubernetes-tools # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-kubernetes-tools.vscode-kubernetes-tools
            ms-python.debugpy # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-python.debugpy
            ms-python.flake8 # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-python.flake8
            ms-python.isort # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-python.isort
            ms-python.vscode-pylance # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-python.vscode-pylance
            ms-vscode-remote.remote-containers # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-vscode-remote.remote-containers
            ms-vscode-remote.remote-ssh # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-vscode-remote.remote-ssh
            ms-vscode-remote.remote-ssh-edit # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-vscode-remote.remote-ssh-edit
            ms-vscode-remote.vscode-remote-extensionpack # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-vscode-remote.vscode-remote-extensionpack
            ms-vscode.live-server # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-vscode.live-server
            ms-vscode.makefile-tools # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-vscode.makefile-tools
            ms-vscode.powershell # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-vscode.powershell
            ms-vsliveshare.vsliveshare # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.ms-vsliveshare.vsliveshare
            oderwat.indent-rainbow # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.oderwat.indent-rainbow
            pkief.material-icon-theme # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.pkief.material-icon-theme
            redhat.java # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.redhat.java
            redhat.vscode-xml # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.redhat.vscode-xml
            redhat.vscode-yaml # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.redhat.vscode-yaml
            sdras.night-owl # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.sdras.night-owl
            shardulm94.trailing-spaces # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.shardulm94.trailing-spaces
            shopify.ruby-lsp # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.shopify.ruby-lsp
            skellock.just # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.skellock.just
            streetsidesoftware.code-spell-checker # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.streetsidesoftware.code-spell-checker
            sumneko.lua # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.sumneko.lua
            tamasfe.even-better-toml # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.tamasfe.even-better-toml
            thenuprojectcontributors.vscode-nushell-lang # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.thenuprojectcontributors.vscode-nushell-lang
            timonwong.shellcheck # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.timonwong.shellcheck
            tomoki1207.pdf # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.tomoki1207.pdf
            vscjava.vscode-gradle # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.vscjava.vscode-gradle
            vscjava.vscode-java-debug # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.vscjava.vscode-java-debug
            vscjava.vscode-java-dependency # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.vscjava.vscode-java-dependency
            vscjava.vscode-java-pack # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.vscjava.vscode-java-pack
            vscjava.vscode-java-test # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.vscjava.vscode-java-test
            vscjava.vscode-maven # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.vscjava.vscode-maven
            xadillax.viml # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.xadillax.viml
            yzhang.markdown-all-in-one # https://search.nixos.org/packages?channel=unstable&type=packages&query=vscode-extensions.yzhang.markdown-all-in-one
            # keep-sorted end
          ]
          # Conditionally add LLVM-dependent extensions (not on Intel macOS)
          ++ (lib.optionals (pkgs.stdenv.hostPlatform.system != "x86_64-darwin") llvmDependentExtensions)
          ++ [
            # isbecker.treefmt-vscode
            (
              (pkgs.vscode-utils.buildVscodeExtension {
                name = "treefmt-vscode-2.2.1";
                pname = "treefmt-vscode";
                src = pkgs.fetchFromGitHub {
                  owner = "isbecker";
                  repo = "treefmt-vscode";
                  rev = "a789643afb1dfe9c51f7ed2626994bb84d9bb392";
                  sha256 = "0axm5cs7y3m62gxj0r8y01yfzj53rlm0k4lc7ab3v2grbni9q80j";
                };
                version = "unstable-2025-12-23";
                vscodeExtName = "treefmt-vscode";
                vscodeExtPublisher = "isbecker";
                vscodeExtUniqueId = "isbecker.treefmt-vscode";
              }).overrideAttrs
              (_: {
                sourceRoot = null; # Workaround chmod: cannot access 'extension': No such file or directory
              })
            )

            # https://marketplace.visualstudio.com/items?itemname=robbowen.synthwave-vscode
            # https://github.com/robb0wen/synthwave-vscode
            (pkgs.vscode-utils.buildVscodeExtension {
              name = "synthwave-vscode";
              pname = "synthwave-vscode";
              src = pkgs.fetchFromGitHub {
                owner = "robb0wen";
                repo = "synthwave-vscode";
                rev = "ecfa2fe1279f7233663fa3f98a96e6756000567b"; # 0.1.20
                hash = "sha256-c+ANBRI2RnnjNt/13vMLCNzsyif8CPp4T3jz+uk+ILU=";
              };
              version = "unstable-2025-08-26";
              vscodeExtName = "synthwave-vscode";
              vscodeExtPublisher = "robb0wen";
              vscodeExtUniqueId = "robb0wen.synthwave-vscode";
              sourceRoot = ".";
            })

            # https://marketplace.visualstudio.com/items?itemname=ms-kubernetes-tools.vscode-aks-tools
            # https://github.com/azure/vscode-aks-tools
            (pkgs.vscode-utils.buildVscodeExtension {
              name = "vscode-aks-tools";
              pname = "vscode-aks-tools";
              src = pkgs.fetchFromGitHub {
                owner = "azure";
                repo = "vscode-aks-tools";
                rev = "cad0d90765af2919a4f7d987d3e33b2f6189c8c0"; # 2.4.0
                hash = "sha256-UlmvRSj8bhcZDGKgVzcpBcrYUyK7/1egFG2CC2/d0ME=";
              };
              version = "unstable-2025-08-26";
              vscodeExtName = "vscode-aks-tools";
              vscodeExtPublisher = "ms-kubernetes-tools";
              vscodeExtUniqueId = "ms-kubernetes-tools.vscode-aks-tools";
              sourceRoot = ".";
            })

            # ms-vscode.remote-server
            (
              (pkgs.vscode-utils.buildVscodeExtension {
                name = "remote-server";
                pname = "remote-server";
                src = pkgs.fetchFromGitHub {
                  owner = "microsoft";
                  repo = "vscode-remote-release";
                  rev = "1803940623da0ba648084b5ba0b1265b2b854ae4"; # main
                  sha256 = "0k0z3iia3jwv5ap8bq08p7x18i8r79gmk78i93cl9mwl3aprdk3a";
                };
                version = "unstable-2024-12-18";
                vscodeExtName = "remote-server";
                vscodeExtPublisher = "ms-vscode";
                vscodeExtUniqueId = "ms-vscode.remote-server";
              }).overrideAttrs
              (_: {
                sourceRoot = null; # Workaround chmod: cannot access 'extension': No such file or directory
              })
            )

            # redhat.fabric8-analytics
            (
              (pkgs.vscode-utils.buildVscodeExtension {
                name = "fabric8-analytics";
                pname = "fabric8-analytics";
                src = pkgs.fetchFromGitHub {
                  owner = "fabric8-analytics";
                  repo = "fabric8-analytics-vscode-extension";
                  rev = "78853637aae6aa978dbaf19e920a7edede913eb3"; # v0.9.6
                  sha256 = "17m101a03a7fwfn8c9bd5qiijs90hqc9h623vfkw9di82phx64in";
                };
                version = "unstable-2025-06-05";
                vscodeExtName = "fabric8-analytics";
                vscodeExtPublisher = "redhat";
                vscodeExtUniqueId = "redhat.fabric8-analytics";
              }).overrideAttrs
              (_: {
                sourceRoot = null;
              })
            )

            # tintinweb.graphviz-interactive-preview
            (
              (pkgs.vscode-utils.buildVscodeExtension {
                name = "graphviz-interactive-preview";
                pname = "graphviz-interactive-preview";
                src = pkgs.fetchFromGitHub {
                  owner = "tintinweb";
                  repo = "vscode-interactive-graphviz";
                  rev = "1074d8c264b05c9460aeacf1027fc5c61e43ac29"; # v0.3.5
                  sha256 = "0pfkzhxgnbvqc0kjk2vilkzxkfv67v2ss58jqbdadjb6dz44ywps";
                };
                version = "unstable-2022-10-28";
                vscodeExtName = "graphviz-interactive-preview";
                vscodeExtPublisher = "tintinweb";
                vscodeExtUniqueId = "tintinweb.graphviz-interactive-preview";
              }).overrideAttrs
              (_: {
                sourceRoot = null; # Workaround chmod: cannot access 'extension': No such file or directory
              })
            )

            # usernamehw.remove-empty-lines
            (
              (pkgs.vscode-utils.buildVscodeExtension {
                name = "remove-empty-lines";
                pname = "remove-empty-lines";
                src = pkgs.fetchFromGitHub {
                  owner = "usernamehw";
                  repo = "vscode-remove-empty-lines";
                  rev = "ec587c853cfbd48b8250c4b823e47854e3362768"; # v1.0.1
                  sha256 = "1ch2p0s5c75vilxpp3yppi32v69rzav9npk9l0q15h40npphp95c";
                };
                version = "unstable-2023-02-28";
                vscodeExtName = "remove-empty-lines";
                vscodeExtPublisher = "usernamehw";
                vscodeExtUniqueId = "usernamehw.remove-empty-lines";
              }).overrideAttrs
              (_: {
                sourceRoot = null; # Workaround chmod: cannot access 'extension': No such file or directory
              })
            )
          ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.profiles._name_.extensions
        globalSnippets = {
          fixme = {
            body = [ "$LINE_COMMENT FIXME: $0" ];
            description = "Insert a FIXME remark.";
            prefix = [ "fixme" ];
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
              body = [ "$LINE_COMMENT FIXME: $0" ];
              description = "Insert a FIXME remark";
              prefix = [ "fixme" ];
            };
          };
        }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.profiles._name_.languageSnippets

        userSettings = {
          # https://code.visualstudio.com/docs/getstarted/settings#_settings-json-file

          # Editor configurations.
          "[dockercompose]" = {
            "editor.insertSpaces" = true;
            "editor.tabSize" = 2;
            "editor.autoIndent" = "advanced";
            "editor.quickSuggestions" = {
              "other" = true;
              "comments" = false;
              "strings" = true;
            };
            "editor.defaultFormatter" = "redhat.vscode-yaml";
          };
          "[github-actions-workflow]"."editor.defaultFormatter" = "redhat.vscode-yaml";
          "[json]" = {
            "editor.defaultFormatter" = "vscode.json-language-features";
          };
          "[dockerfile]"."editor.defaultFormatter" = "ms-azuretools.vscode-containers";
          "[dockerfile]"."editor.tabSize" = 4;
          "[markdown]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "[markdown]"."editor.trimAutoWhitespace" = false;
          "[nix]"."editor.tabSize" = 2;
          "[terraform]"."editor.codeActionsOnSave"."source.formatAll.terraform" = "explicit";
          "[terraform]"."editor.defaultFormatter" = "hashicorp.terraform";
          "[terraform]"."editor.formatOnSave" = false;
          "[terraform]"."editor.tabSize" = 2;
          "files.associations" = {
            ".tflint.hcl" = "terraform";
            "LICENSE-*" = "plaintext";
            "LICENSE" = "plaintext";
          };
          "files.exclude" = {
            "**/dot-terraform" = true;
            "**/dot-vscode" = true;
          };
          "search.exclude" = {
            "**/.git" = true;
            "**/.direnv" = true;
            "**/node_modules" = true;
            "**/tmp" = true;
          };
          "files.insertFinalNewline" = true;
          "files.trimFinalNewlines" = true;
          "files.trimTrailingWhitespace" = true;
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
          "editor.trimAutoWhitespace" = true;
          "editor.wordWrap" = "off";
          "editor.semanticHighlighting.enabled" = true;
          "editor.smoothScrolling" = true;
          "editor.suggestSelection" = "first";
          "terminal.integrated.cursorBlinking" = true;
          "terminal.integrated.enableVisualBell" = true;
          "terminal.integrated.fontFamily" = "Monaspace Nerd Font Mono";
          "terminal.integrated.fontSize" = 16;
          "terminal.integrated.profiles.linux" = {
            "zsh" = {
              "args" = [ "-l" ];
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
              "args" = [ "-NoProfile" ];
              "source" = "PowerShell";
            };
          };
          "terminal.integrated.env.linux" = {
            # /etc/profiles/per-user/${USER}/bin contains home-manager managed binaries.
            # /nix/var/nix/profiles/default/bin contains user-level nix installation.
            # /run/current-system/sw/bin contains system-level tools from darwin-rebuild.
            # /usr/local/bin contains local or homebrew binaries.
            # ${env:PATH} provides fallback to original PATH.
            "PATH" =
              "/etc/profiles/per-user/\${env:USER}/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/usr/local/bin:\${env:PATH}";
          };
          "terminal.integrated.env.osx" = {
            "PATH" =
              "/etc/profiles/per-user/\${env:USER}/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/usr/local/bin:\${env:PATH}";
          };
          "terminal.integrated.shellIntegration.enabled" = false;
          "terminal.integrated.smoothScrolling" = false;
          "terminal.integrated.suggest.cdPath" = "off";
          "terminal.integrated.suggest.enabled" = false;
          "terminal.integrated.suggest.inlineSuggestion" = "off";
          "terminal.integrated.suggest.insertTrailingSpace" = false;
          "terminal.integrated.suggest.quickSuggestions" = {
            "arguments" = "off";
            "commands" = "off";
            "unknown" = "off";
          };
          "terminal.integrated.suggest.runOnEnter" = "never";
          "terminal.integrated.suggest.selectionMode" = "never";
          "terminal.integrated.suggest.showStatusBar" = false;
          "terminal.integrated.suggest.suggestOnTriggerCharacters" = false;
          "terminal.integrated.suggest.upArrowNavigatesHistory" = false;
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

          "extensions.autoUpdate" = "on";
          # Putting some conveniences.
          "files.autoSave" = "afterDelay";
          "files.autoSaveDelay" = 2000;
          "github.copilot.nextEditSuggestions.enabled" = true;
          "github.copilot.chat.codeGeneration.useInstructionFiles" = true;
          "github.copilot.enable" = {
            "enabled" = true;
          };
          "settingsSync.ignoredSettings" = [ "github.copilot.chat.codeGeneration.instructions" ];
          "telemetry.telemetryLevel" = "off";
          "update.showReleaseNotes" = false;
          "better-comments.highlightPlainText" = false;
          "better-comments.multilineComments" = true;
          "better-comments.tags" = [
            {
              "backgroundColor" = "transparent";
              "bold" = false;
              "color" = "#80D7AB";
              "italic" = false;
              "strikethrough" = false;
              "tag" = "@upstream-issue";
              "underline" = false;
            }
            {
              "backgroundColor" = "transparent";
              "bold" = false;
              "color" = "#80D7AB";
              "italic" = false;
              "strikethrough" = false;
              "tag" = "@upstream-pull-request";
              "underline" = false;
            }
            {
              "backgroundColor" = "transparent";
              "bold" = false;
              "color" = "#6FC896";
              "italic" = false;
              "strikethrough" = false;
              "tag" = "@upstream-review";
              "underline" = false;
            }
            {
              "backgroundColor" = "transparent";
              "bold" = false;
              "color" = "#C792EA";
              "italic" = false;
              "strikethrough" = false;
              "tag" = "@note";
              "underline" = false;
            }
            {
              "backgroundColor" = "transparent";
              "bold" = false;
              "color" = "#FF2D00";
              "italic" = false;
              "strikethrough" = false;
              "tag" = "!";
              "underline" = false;
            }
            {
              "backgroundColor" = "transparent";
              "bold" = false;
              "color" = "#3498DB";
              "italic" = false;
              "strikethrough" = false;
              "tag" = "?";
              "underline" = false;
            }
            {
              "backgroundColor" = "transparent";
              "bold" = false;
              "color" = "#474747";
              "italic" = false;
              "strikethrough" = true;
              "tag" = "//";
              "underline" = false;
            }
            {
              "backgroundColor" = "transparent";
              "bold" = false;
              "color" = "#FF8C00";
              "italic" = false;
              "strikethrough" = false;
              "tag" = "todo";
              "underline" = false;
            }
            {
              "backgroundColor" = "transparent";
              "bold" = false;
              "color" = "#98C379";
              "italic" = false;
              "strikethrough" = false;
              "tag" = "*";
              "underline" = false;
            }
          ];
          "direnv.path.executable" = "direnv";
          "direnv.restart.automatic" = true;
          # "gitlens.plusFeatures.enabled" = false; # TODO: Enable after https://github.com/NixOS/nixpkgs/issues/462082 is fixed upstream.
          "geminicodeassist.displayInlineContextHint" = false;
          "geminicodeassist.project" = "cloud-nine-265718"; # "gen-lang-client-0457835357";
          "hadolint.hadolintPath" = "hadolint";
          "json.schemas" = [
            {
              "fileMatch" = [
                "opencode.json"
                "opencode.jsonc"
              ];
              "url" = "https://opencode.ai/config.json";
            }
            {
              "fileMatch" = [
                "*-theme.json"
                "*-theme.jsonc"
              ];
              "url" = "https://opencode.ai/theme.json";
            }
          ];
          "nix.formatterPath" = "nixfmt";
          "nix.serverPath" = "nil";
          "shellcheck.executablePath" = "shellcheck";
          "vscode-kubernetes.kubectl-path" = "kubectl";
          "yaml.disableSchemaDetection" = [
            "**/.github/workflows/*.yml"
            "**/.github/workflows/*.yaml"
            "**/.gitea/workflows/*.yml"
            "**/.gitea/workflows/*.yaml"
            "**/.forgejo/workflows/*.yml"
            "**/.forgejo/workflows/*.yaml"
          ];
        }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.profiles._name_.userSettings

        userTasks = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.profiles._name_.userTasks
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
    # locale = "ja";
  };
}
