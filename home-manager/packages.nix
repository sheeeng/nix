# https://github.com/jonringer/nixpkgs-config/blob/399724e3c8b1756f636f8d485eed25d03f64aa76/packages.nix

# https://github.com/hardselius/dotfiles/blob/b801fd8aba017a588ce56430d8345449ec396c96/home/packages.nix

# nix eval nixpkgs#pinact.name
# nix search nixpkgs#pinact '^' 2>&1 | head --lines 20
# The '^' notation is a regular expression that matches the start of a string. Every package name has a start, so it matches all names and acts as “no filtering.”

{
  pkgs,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      # Audio
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # ffmpeg-full # @upstream-issue https://github.com/NixOS/nixpkgs/issues/511265 # https://search.nixos.org/packages?channel=unstable&type=packages&show=ffmpeg-full
      # mpd # https://search.nixos.org/packages?channel=unstable&type=packages&show=mpd
      # musescore # @upstream-issue https://github.com/NixOS/nixpkgs/pull/450512#issuecomment-3390505837 # https://search.nixos.org/packages?channel=unstable&type=packages&show=musescore
      # ncmpcpp # https://search.nixos.org/packages?channel=unstable&type=packages&show=ncmpcpp
      # sonic-pi # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=sonic-pi
      # supercollider-with-plugins # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=supercollider-with-plugins
      # zrythm # TODO: Marked as broken. # https://search.nixos.org/packages?channel=unstable&type=packages&show=zrythm
      mpc # https://search.nixos.org/packages?channel=unstable&type=packages&show=mpc
      # keep-sorted end

      # Fonts
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      fontconfig # https://search.nixos.org/packages?channel=unstable&type=packages&show=fontconfig
      google-fonts # https://search.nixos.org/packages?channel=unstable&type=packages&show=google-fonts
      noto-fonts # https://search.nixos.org/packages?channel=unstable&type=packages&show=noto-fonts
      noto-fonts-cjk-sans # https://search.nixos.org/packages?channel=unstable&type=packages&show=noto-fonts-cjk-sans
      noto-fonts-cjk-serif # https://search.nixos.org/packages?channel=unstable&type=packages&show=noto-fonts-cjk-serif
      noto-fonts-color-emoji # https://search.nixos.org/packages?channel=unstable&type=packages&show=noto-fonts-color-emoji
      noto-fonts-lgc-plus # https://search.nixos.org/packages?channel=unstable&type=packages&show=noto-fonts-lgc-plus
      noto-fonts-monochrome-emoji # https://search.nixos.org/packages?channel=unstable&type=packages&show=noto-fonts-monochrome-emoji
      # keep-sorted end

      # Graphics
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # aseprite # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=aseprite
      # blender # TODO: Marked as broken. # https://search.nixos.org/packages?channel=unstable&type=packages&show=blender
      # emulsion-palette # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=emulsion-palette
      # eyedropper # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=eyedropper
      # gimp-with-plugins # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=gimp-with-plugins
      # krita # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=krita
      # pureref # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=pureref
      gmic # https://search.nixos.org/packages?channel=unstable&type=packages&show=gmic
      imagemagick # https://search.nixos.org/packages?channel=unstable&type=packages&show=imagemagick
      inkscape-with-extensions # https://search.nixos.org/packages?channel=unstable&type=packages&show=inkscape-with-extensions
      libwebp # https://search.nixos.org/packages?channel=unstable&type=packages&show=libwebp
      # keep-sorted end

      # Network
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # kanidm # FIXME: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=kanidm
      bind.dnsutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=dnsutils
      croc # https://search.nixos.org/packages?channel=unstable&type=packages&show=croc
      geoip # https://search.nixos.org/packages?channel=unstable&type=packages&show=geoip
      ipcalc # https://search.nixos.org/packages?channel=unstable&type=packages&show=ipcalc
      sipcalc # https://search.nixos.org/packages?channel=unstable&type=packages&show=sipcalc
      sshfs # https://search.nixos.org/packages?channel=unstable&type=packages&show=sshfs
      websocat # https://search.nixos.org/packages?channel=unstable&type=packages&show=websocat
      wget # https://search.nixos.org/packages?channel=unstable&type=packages&show=wget
      whois # https://search.nixos.org/packages?channel=unstable&type=packages&show=whois
      # keep-sorted end

      # Fun And Games
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      asciiquarium-transparent # https://search.nixos.org/packages?channel=unstable&type=packages&show=asciiquarium-transparent
      cbonsai # https://search.nixos.org/packages?channel=unstable&type=packages&show=cbonsai
      cmatrix # https://search.nixos.org/packages?channel=unstable&type=packages&show=cmatrix
      cowsay # https://search.nixos.org/packages?channel=unstable&type=packages&show=cowsay
      fastfetch # https://search.nixos.org/packages?channel=unstable&type=packages&show=fastfetch
      krabby # https://search.nixos.org/packages?channel=unstable&type=packages&show=krabby
      lavat # https://search.nixos.org/packages?channel=unstable&type=packages&show=lavat
      lolcat # https://search.nixos.org/packages?channel=unstable&type=packages&show=lolcat
      pipes # https://search.nixos.org/packages?channel=unstable&type=packages&show=pipes
      pipes-rs # https://search.nixos.org/packages?channel=unstable&type=packages&show=pipes-rs
      # keep-sorted end

      # Communication
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # aerc # https://search.nixos.org/packages?channel=unstable&type=packages&show=aerc
      # alpine # TODO: Unavailable on aarch64-apple-darwin platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=alpine
      # gomuks # https://search.nixos.org/packages?channel=unstable&type=packages&show=gomuks
      # ii # https://search.nixos.org/packages?channel=unstable&type=packages&show=ii
      # mutt # https://search.nixos.org/packages?channel=unstable&type=packages&show=mutt
      # neomutt # https://search.nixos.org/packages?channel=unstable&type=packages&show=neomutt
      # weechat # https://search.nixos.org/packages?channel=unstable&type=packages&show=weechat
      # keep-sorted end

      # Development Tools
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # (lib.hiPrio go-task) # TODO: Collision error with `taskwarrior-3` package. # https://search.nixos.org/packages?channel=unstable&type=packages&show=go-task
      # (lib.hiPrio parallel) # TODO: https://haseebmajid.dev/posts/2023-10-02-til-how-to-fix-package-binary-collisions-on-nix/ # https://search.nixos.org/packages?channel=unstable&type=packages&show=parallel
      # devenv # https://search.nixos.org/packages?channel=unstable&type=packages&show=devenv
      # gh # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh
      # gh-actions-cache # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-actions-cache
      # gh-cal # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-cal
      # gh-classroom # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-classroom
      # gh-contribs # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-contribs
      # gh-dash # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-dash
      # gh-eco # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-eco
      # gh-f # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-f
      # gh-gei # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-gei
      # gh-i # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-i
      # gh-markdown-preview # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-markdown-preview
      # gh-notify # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-notify
      # gh-ost # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-ost
      # gh-poi # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-poi
      # gh-s # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-s
      # gh-screensaver # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-screensaver
      # gh-signoff # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-signoff
      # gh-skyline # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-skyline
      # gh-webhook # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh-webhook
      # kubelogin # https://search.nixos.org/packages?channel=unstable&type=packages&show=kubelogin
      # marksman # https://search.nixos.org/packages?channel=unstable&type=packages&show=marksman
      # nixfmt-tree # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixfmt-tree
      # taskctl # TODO: https://github.com/taskctl/taskctl # https://search.nixos.org/packages?channel=unstable&type=packages&show=taskctl
      # x-cmd # TODO: https://github.com/x-cmd/x-cmd # https://search.nixos.org/packages?channel=unstable&type=packages&show=x-cmd
      (lib.hiPrio uutils-coreutils-noprefix) # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-coreutils-noprefix
      (lib.hiPrio uutils-diffutils) # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-diffutils
      (lib.hiPrio uutils-findutils) # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-findutils
      (pkgs.callPackage ./packages/download-nixos-iso.nix { })
      alejandra # https://search.nixos.org/packages?channel=unstable&type=packages&show=alejandra
      antigravity-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=antigravity-cli
      antigravity-ide # renamed from `antigravity`. https://search.nixos.org/packages?channel=unstable&type=packages&show=antigravity-ide
      asdf-vm # https://search.nixos.org/packages?channel=unstable&type=packages&show=asdf-vm
      autoconf # https://search.nixos.org/packages?channel=unstable&type=packages&show=autoconf
      beads # https://search.nixos.org/packages?channel=unstable&type=packages&show=beads
      cilium-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=cilium-cli
      conform # https://search.nixos.org/packages?channel=unstable&type=packages&show=conform
      delta # https://search.nixos.org/packages?channel=unstable&type=packages&show=delta
      dependabot-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=dependabot-cli
      editorconfig-checker # https://search.nixos.org/packages?channel=unstable&type=packages&show=editorconfig-checker
      firebase-tools # https://search.nixos.org/packages?channel=unstable&type=packages&show=firebase-tools
      freerdp # https://search.nixos.org/packages?channel=unstable&type=packages&show=freerdp
      gcc # https://search.nixos.org/packages?channel=unstable&type=packages&show=gcc
      gh # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh
      golangci-lint # https://search.nixos.org/packages?channel=unstable&type=packages&show=golangci-lint
      hadolint # https://search.nixos.org/packages?channel=unstable&type=packages&show=hadolint
      hubble # https://search.nixos.org/packages?channel=unstable&type=packages&show=hubble
      jujutsu # https://search.nixos.org/packages?channel=unstable&type=packages&show=jujutsu
      just # https://search.nixos.org/packages?channel=unstable&type=packages&show=just
      just-lsp # https://search.nixos.org/packages?channel=unstable&type=packages&show=just-lsp
      k9s # https://search.nixos.org/packages?channel=unstable&type=packages&show=k9s
      keep-sorted # https://search.nixos.org/packages?channel=unstable&type=packages&show=keep-sorted
      kubectl # https://search.nixos.org/packages?channel=unstable&type=packages&show=kubectl
      kubectx # https://search.nixos.org/packages?channel=unstable&type=packages&show=kubectx
      kubernetes-helm # https://search.nixos.org/packages?channel=unstable&type=packages&show=kubernetes-helm
      kustomize # https://search.nixos.org/packages?channel=unstable&type=packages&show=kustomize
      lazygit # https://search.nixos.org/packages?channel=unstable&type=packages&show=lazygit
      lazysql # https://search.nixos.org/packages?channel=unstable&type=packages&show=lazysql
      lmstudio # https://search.nixos.org/packages?channel=unstable&type=packages&show=lmstudio
      ltex-ls # https://search.nixos.org/packages?channel=unstable&type=packages&show=ltex-ls
      markdown-oxide # https://search.nixos.org/packages?channel=unstable&type=packages&show=markdown-oxide
      markdownlint-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=markdownlint-cli
      markdownlint-cli2 # https://search.nixos.org/packages?channel=unstable&type=packages&show=markdownlint-cli2
      marp-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=marp-cli
      nh # https://search.nixos.org/packages?channel=unstable&type=packages&show=nh
      nixfmt # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixfmt
      nixos-option # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixos-option
      pinact # https://search.nixos.org/packages?channel=unstable&type=packages&show=pinact
      poppler-utils # https://search.nixos.org/packages?channel=unstable&type=packages&show=poppler-utils
      shfmt # https://search.nixos.org/packages?channel=unstable&type=packages&show=shfmt
      texlab # https://search.nixos.org/packages?channel=unstable&type=packages&show=texlab
      tflint # https://search.nixos.org/packages?channel=unstable&type=packages&show=tflint
      tfsort # https://search.nixos.org/packages?channel=unstable&type=packages&show=tfsort
      tig # https://search.nixos.org/packages?channel=unstable&type=packages&show=tig
      treefmt # https://search.nixos.org/packages?channel=unstable&type=packages&show=treefmt
      typescript-language-server # https://search.nixos.org/packages?channel=unstable&type=packages&show=typescript-language-server
      update-nix-fetchgit # https://search.nixos.org/packages?channel=unstable&type=packages&show=update-nix-fetchgit
      yamlfmt # https://search.nixos.org/packages?channel=unstable&type=packages&show=yamlfmt
      yamllint # https://search.nixos.org/packages?channel=unstable&type=packages&show=yamllint
      # keep-sorted end

      # Security And Privacy
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # yubiswitch # TODO: macOS-only package. # https://search.nixos.org/packages?channel=unstable&type=packages&show=yubiswitch
      _1password-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=1password-cli
      age # https://search.nixos.org/packages?channel=unstable&type=packages&show=age
      age-plugin-1p # https://search.nixos.org/packages?channel=unstable&type=packages&show=age-plugin-1p
      age-plugin-yubikey # https://search.nixos.org/packages?channel=unstable&type=packages&show=age-plugin-yubikey
      bitwarden-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=bitwarden-cli
      bitwarden-desktop # https://search.nixos.org/packages?channel=unstable&type=packages&show=bitwarden-desktop
      nono # https://search.nixos.org/packages?channel=unstable&type=packages&show=nono
      pass # https://search.nixos.org/packages?channel=unstable&type=packages&show=pass
      pass-git-helper # https://search.nixos.org/packages?channel=unstable&type=packages&show=pass-git-helper
      passage # https://search.nixos.org/packages?channel=unstable&type=packages&show=passage
      passphrase2pgp # https://search.nixos.org/packages?channel=unstable&type=packages&show=passphrase2pgp
      sops # https://search.nixos.org/packages?channel=unstable&type=packages&show=sops
      ssss # https://search.nixos.org/packages?channel=unstable&type=packages&show=ssss
      yubikey-manager # https://search.nixos.org/packages?channel=unstable&type=packages&show=yubikey-manager
      yubikey-personalization # https://search.nixos.org/packages?channel=unstable&type=packages&show=yubikey-personalization
      # keep-sorted end

      # Productivity
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # newsboat # https://search.nixos.org/packages?channel=unstable&type=packages&show=newsboat
      # obsidian # https://search.nixos.org/packages?channel=unstable&type=packages&show=obsidian
      # pympress # https://search.nixos.org/packages?channel=unstable&type=packages&show=pympress
      # taskwarrior3 # https://search.nixos.org/packages?channel=unstable&type=packages&show=taskwarrior3
      atuin # https://search.nixos.org/packages?channel=unstable&type=packages&show=atuin
      calcurse # https://search.nixos.org/packages?channel=unstable&type=packages&show=calcurse
      sc-im # https://search.nixos.org/packages?channel=unstable&type=packages&show=sc-im
      stow # https://search.nixos.org/packages?channel=unstable&type=packages&show=stow
      wyrd # https://search.nixos.org/packages?channel=unstable&type=packages&show=wyrd
      # keep-sorted end

      # Cloud And Infrastructure
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      lego # https://search.nixos.org/packages?channel=unstable&type=packages&show=lego
      rclone # TODO: See `nixpkgs.overlays` in other file. # https://search.nixos.org/packages?channel=unstable&type=packages&show=rclone
      # keep-sorted end

      # Core Utilities
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # (lib.lowPrio sc) # TODO: Collision error with `smartcat` package. # https://search.nixos.org/packages?channel=unstable&type=packages&show=sc
      # fuff # TODO: https://github.com/ffuf/ffuf # https://search.nixos.org/packages?channel=unstable&type=packages&show=fuff
      # ltex-ls-plus # https://search.nixos.org/packages?channel=unstable&type=packages&show=ltex-ls-plus
      # ollama # TODO: Marked as insecure. # https://search.nixos.org/packages?channel=unstable&type=packages&show=ollama
      # sct # https://search.nixos.org/packages?channel=unstable&type=packages&show=sct
      # uuid7 # TODO: https://github.com/stevesimmons/uuid7 # https://search.nixos.org/packages?channel=unstable&type=packages&show=uuid7
      # ws # TODO: https://github.com/lewoudar/ws/ # https://search.nixos.org/packages?channel=unstable&type=packages&show=ws
      bc # https://search.nixos.org/packages?channel=unstable&type=packages&show=bc
      dos2unix # https://search.nixos.org/packages?channel=unstable&type=packages&show=dos2unix
      findutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=findutils
      gzip # https://search.nixos.org/packages?channel=unstable&type=packages&show=gzip
      moreutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=moreutils
      progress # https://search.nixos.org/packages?channel=unstable&type=packages&show=progress
      smartcat # https://search.nixos.org/packages?channel=unstable&type=packages&show=smartcat
      xz # https://search.nixos.org/packages?channel=unstable&type=packages&show=xz
      # keep-sorted end

      # Data And Formats
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      bitwise # https://search.nixos.org/packages?channel=unstable&type=packages&show=bitwise
      dasel # https://search.nixos.org/packages?channel=unstable&type=packages&show=dasel
      fq # https://search.nixos.org/packages?channel=unstable&type=packages&show=fq
      hexedit # https://search.nixos.org/packages?channel=unstable&type=packages&show=hexedit
      jq # https://search.nixos.org/packages?channel=unstable&type=packages&show=jq
      minify # https://search.nixos.org/packages?channel=unstable&type=packages&show=minify
      spruce # https://search.nixos.org/packages?channel=unstable&type=packages&show=spruce
      sqlite # https://search.nixos.org/packages?channel=unstable&type=packages&show=sqlite
      tomlq # https://search.nixos.org/packages?channel=unstable&type=packages&show=tomlq
      # keep-sorted end

      # Desktop Utilities
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # zenity # @upstream-issue https://github.com/NixOS/nixpkgs/issues/514566 # https://search.nixos.org/packages?channel=unstable&type=packages&show=zenity
      tenki # https://search.nixos.org/packages?channel=unstable&type=packages&show=tenki
      # keep-sorted end

      # Terminal Emulators
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      warp-terminal # https://search.nixos.org/packages?channel=unstable&type=packages&show=warp-terminal
      # keep-sorted end

      # Documentation And Publishing
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      glow # https://search.nixos.org/packages?channel=unstable&type=packages&show=glow
      graphviz # https://search.nixos.org/packages?channel=unstable&type=packages&show=graphviz
      markdownlint-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=markdownlint-cli
      markdownlint-cli2 # https://search.nixos.org/packages?channel=unstable&type=packages&show=markdownlint-cli2
      mdformat # https://search.nixos.org/packages?channel=unstable&type=packages&show=mdformat
      mkdocs # https://search.nixos.org/packages?channel=unstable&type=packages&show=mkdocs
      pandoc # https://search.nixos.org/packages?channel=unstable&type=packages&show=pandoc
      vhs # https://search.nixos.org/packages?channel=unstable&type=packages&show=vhs
      zensical # https://search.nixos.org/packages?channel=unstable&type=packages&show=zensical
      # keep-sorted end

      # File Managers And Disk Tools
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      dust # https://search.nixos.org/packages?channel=unstable&type=packages&show=dust
      f3 # https://search.nixos.org/packages?channel=unstable&type=packages&show=f3
      gomtree # https://search.nixos.org/packages?channel=unstable&type=packages&show=gomtree
      mc # https://search.nixos.org/packages?channel=unstable&type=packages&show=mc
      ncdu # https://search.nixos.org/packages?channel=unstable&type=packages&show=ncdu
      nnn # https://search.nixos.org/packages?channel=unstable&type=packages&show=nnn
      ranger # https://search.nixos.org/packages?channel=unstable&type=packages&show=ranger
      superfile # https://search.nixos.org/packages?channel=unstable&type=packages&show=superfile
      tree # https://search.nixos.org/packages?channel=unstable&type=packages&show=tree
      unzip # https://search.nixos.org/packages?channel=unstable&type=packages&show=unzip
      vifm # https://search.nixos.org/packages?channel=unstable&type=packages&show=vifm
      zip # https://search.nixos.org/packages?channel=unstable&type=packages&show=zip
      # keep-sorted end

      # Media And Imaging
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      barcode # https://search.nixos.org/packages?channel=unstable&type=packages&show=barcode
      chafa # https://search.nixos.org/packages?channel=unstable&type=packages&show=chafa
      exiftool # https://search.nixos.org/packages?channel=unstable&type=packages&show=exiftool
      qrencode # https://search.nixos.org/packages?channel=unstable&type=packages&show=qrencode
      # keep-sorted end

      # Search And Navigation
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      fd # https://search.nixos.org/packages?channel=unstable&type=packages&show=fd
      ripgrep # https://search.nixos.org/packages?channel=unstable&type=packages&show=ripgrep
      zoxide # https://search.nixos.org/packages?channel=unstable&type=packages&show=zoxide
      # keep-sorted end

      # System Monitoring
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      btop # https://search.nixos.org/packages?channel=unstable&type=packages&show=btop
      gotop # https://search.nixos.org/packages?channel=unstable&type=packages&show=gotop
      htop # https://search.nixos.org/packages?channel=unstable&type=packages&show=htop
      # keep-sorted end

      # Terminal Utilities
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      bat # https://search.nixos.org/packages?channel=unstable&type=packages&show=bat
      byobu # https://search.nixos.org/packages?channel=unstable&type=packages&show=byobu
      cheat # https://search.nixos.org/packages?channel=unstable&type=packages&show=cheat
      eza # https://search.nixos.org/packages?channel=unstable&type=packages&show=eza
      hyperfine # https://search.nixos.org/packages?channel=unstable&type=packages&show=hyperfine
      lsd # https://search.nixos.org/packages?channel=unstable&type=packages&show=lsd
      moor # https://search.nixos.org/packages?channel=unstable&type=packages&show=moor
      television # https://search.nixos.org/packages?channel=unstable&type=packages&show=television
      timer # https://search.nixos.org/packages?channel=unstable&type=packages&show=timer
      tldr # https://search.nixos.org/packages?channel=unstable&type=packages&show=tldr
      tmux # https://search.nixos.org/packages?channel=unstable&type=packages&show=tmux
      watch # https://search.nixos.org/packages?channel=unstable&type=packages&show=watch
      # keep-sorted end
    ]
    ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [
      # Audio
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # sonic-pi # @upstream-issue https://github.com/NixOS/nixpkgs/issues/445447 # https://search.nixos.org/packages?channel=unstable&type=packages&show=sonic-pi
      audacity # https://search.nixos.org/packages?channel=unstable&type=packages&show=audacity
      supercollider-with-plugins # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=supercollider-with-plugins
      # keep-sorted end

      # Development
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # esptool # https://search.nixos.org/packages?channel=unstable&type=packages&show=esptool
      # platformio # https://search.nixos.org/packages?channel=unstable&type=packages&show=platformio
      pre-commit # https://search.nixos.org/packages?channel=unstable&type=packages&show=pre-commit
      # keep-sorted end

      # Graphics
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # aseprite # @upstream-issue https://github.com/NixOS/nixpkgs/issues/445447 # https://search.nixos.org/packages?channel=unstable&type=packages&show=aseprite
      # pureref # @upstream-issue Broken download: pureref.com/download.php no longer returns a download key. # https://search.nixos.org/packages?channel=unstable&type=packages&show=pureref
      emulsion-palette # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=emulsion-palette
      eyedropper # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=eyedropper
      # keep-sorted end

      # Network
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # kanidm # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=kanidm
      brave # https://search.nixos.org/packages?channel=unstable&type=packages&show=brave
      epiphany # https://search.nixos.org/packages?channel=unstable&type=packages&show=epiphany
      microsoft-edge # https://search.nixos.org/packages?channel=unstable&type=packages&show=microsoft-edge
      qbittorrent # https://search.nixos.org/packages?channel=unstable&type=packages&show=qbittorrent
      tor-browser # https://search.nixos.org/packages?channel=unstable&type=packages&show=tor-browser
      vivaldi # https://search.nixos.org/packages?channel=unstable&type=packages&show=vivaldi
      # keep-sorted end

      # Security And Privacy
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      _1password-gui # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=_1password-gui
      # keep-sorted end

      # Terminal Emulators
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      ghostty # https://search.nixos.org/packages?channel=unstable&type=packages&show=ghostty
      # keep-sorted end

      # Shell Utilities
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      libnotify # https://search.nixos.org/packages?channel=unstable&type=packages&show=libnotify
      wl-clipboard # https://search.nixos.org/packages?channel=unstable&type=packages&show=wl-clipboard
      # keep-sorted end
    ])
    ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [
      # Cross-platform Rust Environment
      # https://github.com/rivet-gg/rivet/blob/f879623b871e4acafaffd31817b9386fb84ddce1/shell.nix
      # libiconv # See https://stackoverflow.com/a/69732679
      # darwin.apple_sdk.frameworks.Security
      # darwin.apple_sdk.frameworks.CoreServices
      # darwin.apple_sdk.frameworks.CoreFoundation
      # darwin.apple_sdk.frameworks.Foundation
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      raycast # https://search.nixos.org/packages?channel=unstable&type=packages&show=raycast
      yubiswitch # https://search.nixos.org/packages?channel=unstable&type=packages&show=yubiswitch
      # keep-sorted end
    ])
    ++ (pkgs.lib.optionals (pkgs.stdenv.isDarwin && pkgs.stdenv.hostPlatform.isAarch64) [
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # podman # https://search.nixos.org/packages?channel=unstable&type=packages&show=podman
      # podman-compose # https://search.nixos.org/packages?channel=unstable&type=packages&show=podman-compose
      openlogi # https://search.nixos.org/packages?channel=unstable&type=packages&show=openlogi
      opentofu # https://search.nixos.org/packages?channel=unstable&type=packages&show=opentofu
      # keep-sorted end
    ]);
}
