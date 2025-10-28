# https://github.com/jonringer/nixpkgs-config/blob/399724e3c8b1756f636f8d485eed25d03f64aa76/packages.nix

# https://github.com/hardselius/dotfiles/blob/b801fd8aba017a588ce56430d8345449ec396c96/home/packages.nix

{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      # Audio
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # mpc-cli # TODO: https://github.com/NixOS/nixpkgs/issues/355495 # https://search.nixos.org/packages?channel=unstable&type=packages&show=mpc-cli
      # mpd # https://search.nixos.org/packages?channel=unstable&type=packages&show=mpd
      # musescore # TODO: https://github.com/NixOS/nixpkgs/pull/450512#issuecomment-3390505837 # https://search.nixos.org/packages?channel=unstable&type=packages&show=musescore
      # ncmpcpp # https://search.nixos.org/packages?channel=unstable&type=packages&show=ncmpcpp
      # sonic-pi # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=sonic-pi
      # supercollider-with-plugins # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=supercollider-with-plugins
      # zrythm # TODO: Marked as broken. # https://search.nixos.org/packages?channel=unstable&type=packages&show=zrythm
      audacity # https://search.nixos.org/packages?channel=unstable&type=packages&show=audacity
      ffmpeg-full # https://search.nixos.org/packages?channel=unstable&type=packages&show=ffmpeg-full
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
      inkscape-with-extensions # https://search.nixos.org/packages?channel=unstable&type=packages&show=inkscape-with-extensions
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

      # Funsies
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
      # alpine # TODO: Unavailable on aarch64-apple-darwin platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=alpine
      # gomuks # https://search.nixos.org/packages?channel=unstable&type=packages&show=gomuks
      # ii # https://search.nixos.org/packages?channel=unstable&type=packages&show=ii
      # mutt # https://search.nixos.org/packages?channel=unstable&type=packages&show=mutt
      # neomutt # https://search.nixos.org/packages?channel=unstable&type=packages&show=neomutt
      # weechat # https://search.nixos.org/packages?channel=unstable&type=packages&show=weechat
      aerc # https://search.nixos.org/packages?channel=unstable&type=packages&show=aerc
      # keep-sorted end

      # Development Tools
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # (lib.hiPrio go-task) # TODO: Collision error with `taskwarrior-3` package. # https://search.nixos.org/packages?channel=unstable&type=packages&show=go-task
      # (lib.hiPrio parallel) # TODO: https://haseebmajid.dev/posts/2023-10-02-til-how-to-fix-package-binary-collisions-on-nix/ # https://search.nixos.org/packages?channel=unstable&type=packages&show=parallel
      # delta # https://search.nixos.org/packages?channel=unstable&type=packages&show=delta
      # nh # https://search.nixos.org/packages?channel=unstable&type=packages&show=nh
      # nixfmt-tree # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixfmt-tree
      # taskctl # TODO: https://github.com/taskctl/taskctl # https://search.nixos.org/packages?channel=unstable&type=packages&show=taskctl
      # x-cmd # TODO: https://github.com/x-cmd/x-cmd # https://search.nixos.org/packages?channel=unstable&type=packages&show=x-cmd
      (lib.hiPrio uutils-coreutils-noprefix) # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-coreutils-noprefix
      (lib.hiPrio uutils-diffutils) # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-diffutils
      (lib.hiPrio uutils-findutils) # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-findutils
      alejandra # https://search.nixos.org/packages?channel=unstable&type=packages&show=alejandra
      asdf-vm # https://search.nixos.org/packages?channel=unstable&type=packages&show=asdf-vm
      autoconf # https://search.nixos.org/packages?channel=unstable&type=packages&show=autoconf
      binutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=binutils
      conform # https://search.nixos.org/packages?channel=unstable&type=packages&show=conform
      dependabot-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=dependabot-cli
      devenv # https://search.nixos.org/packages?channel=unstable&type=packages&show=devenv
      gh # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh
      hadolint # https://search.nixos.org/packages?channel=unstable&type=packages&show=hadolint
      just # https://search.nixos.org/packages?channel=unstable&type=packages&show=just
      just-lsp # https://search.nixos.org/packages?channel=unstable&type=packages&show=just-lsp
      k9s # https://search.nixos.org/packages?channel=unstable&type=packages&show=k9s
      kubectl # https://search.nixos.org/packages?channel=unstable&type=packages&show=kubectl
      kubectx # https://search.nixos.org/packages?channel=unstable&type=packages&show=kubectx
      kustomize # https://search.nixos.org/packages?channel=unstable&type=packages&show=kustomize
      lazygit # https://search.nixos.org/packages?channel=unstable&type=packages&show=lazygit
      lazysql # https://search.nixos.org/packages?channel=unstable&type=packages&show=lazysql
      ltex-ls # https://search.nixos.org/packages?channel=unstable&type=packages&show=ltex-ls
      markdown-oxide # https://search.nixos.org/packages?channel=unstable&type=packages&show=markdown-oxide
      marksman # https://search.nixos.org/packages?channel=unstable&type=packages&show=marksman
      nixfmt # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixfmt
      nixos-option # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixos-option
      # pre-commit # https://search.nixos.org/packages?channel=unstable&type=packages&show=pre-commit
      shfmt # https://search.nixos.org/packages?channel=unstable&type=packages&show=shfmt
      # terraform # https://search.nixos.org/packages?channel=unstable&type=packages&show=terraform
      texlab # https://search.nixos.org/packages?channel=unstable&type=packages&show=texlab
      tflint # https://search.nixos.org/packages?channel=unstable&type=packages&show=tflint
      tfsort # https://search.nixos.org/packages?channel=unstable&type=packages&show=tfsort
      tig # https://search.nixos.org/packages?channel=unstable&type=packages&show=tig
      treefmt # https://search.nixos.org/packages?channel=unstable&type=packages&show=treefmt
      update-nix-fetchgit # https://search.nixos.org/packages?channel=unstable&type=packages&show=update-nix-fetchgit
      # keep-sorted end

      # Security & Privacy
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      _1password-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=1password-cli
      age # https://search.nixos.org/packages?channel=unstable&type=packages&show=age
      age-plugin-yubikey # https://search.nixos.org/packages?channel=unstable&type=packages&show=age-plugin-yubikey
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
      raycast # https://search.nixos.org/packages?channel=unstable&type=packages&show=raycast
      stow # https://search.nixos.org/packages?channel=unstable&type=packages&show=stow
      wyrd # https://search.nixos.org/packages?channel=unstable&type=packages&show=wyrd
      # keep-sorted end

      # Utilities
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # (lib.lowPrio sc) # TODO: Collision error with `smartcat` package. # https://search.nixos.org/packages?channel=unstable&type=packages&show=sc
      # fuff # TODO: https://github.com/ffuf/ffuf # https://search.nixos.org/packages?channel=unstable&type=packages&show=fuff
      # ltex-ls-plus # https://search.nixos.org/packages?channel=unstable&type=packages&show=ltex-ls-plus
      # ollama # TODO: Marked as insecure. # https://search.nixos.org/packages?channel=unstable&type=packages&show=ollama
      # sct # https://search.nixos.org/packages?channel=unstable&type=packages&show=sct
      # uuid7 # TODO: https://github.com/stevesimmons/uuid7 # https://search.nixos.org/packages?channel=unstable&type=packages&show=uuid7
      # ws # TODO: https://github.com/lewoudar/ws/ # https://search.nixos.org/packages?channel=unstable&type=packages&show=ws
      barcode # https://search.nixos.org/packages?channel=unstable&type=packages&show=barcode
      bc # https://search.nixos.org/packages?channel=unstable&type=packages&show=bc
      bitwise # https://search.nixos.org/packages?channel=unstable&type=packages&show=bitwise
      chafa # https://search.nixos.org/packages?channel=unstable&type=packages&show=chafa
      dasel # https://search.nixos.org/packages?channel=unstable&type=packages&show=dasel
      dos2unix # https://search.nixos.org/packages?channel=unstable&type=packages&show=dos2unix
      exiftool # https://search.nixos.org/packages?channel=unstable&type=packages&show=exiftool
      f3 # https://search.nixos.org/packages?channel=unstable&type=packages&show=f3
      fq # https://search.nixos.org/packages?channel=unstable&type=packages&show=fq
      glow # https://search.nixos.org/packages?channel=unstable&type=packages&show=glow
      gomtree # https://search.nixos.org/packages?channel=unstable&type=packages&show=gomtree
      graphviz # https://search.nixos.org/packages?channel=unstable&type=packages&show=graphviz
      hexedit # https://search.nixos.org/packages?channel=unstable&type=packages&show=hexedit
      jq # https://search.nixos.org/packages?channel=unstable&type=packages&show=jq
      lego # https://search.nixos.org/packages?channel=unstable&type=packages&show=lego
      mdformat # https://search.nixos.org/packages?channel=unstable&type=packages&show=mdformat
      minify # https://search.nixos.org/packages?channel=unstable&type=packages&show=minify
      mkdocs # https://search.nixos.org/packages?channel=unstable&type=packages&show=mkdocs
      moreutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=moreutils
      pandoc # https://search.nixos.org/packages?channel=unstable&type=packages&show=pandoc
      progress # https://search.nixos.org/packages?channel=unstable&type=packages&show=progress
      qrencode # https://search.nixos.org/packages?channel=unstable&type=packages&show=qrencode
      rclone # TODO: See `nixpkgs.overlays` in other file. # https://search.nixos.org/packages?channel=unstable&type=packages&show=rclone
      sc-im # https://search.nixos.org/packages?channel=unstable&type=packages&show=sc-im
      smartcat # https://search.nixos.org/packages?channel=unstable&type=packages&show=smartcat
      spruce # https://search.nixos.org/packages?channel=unstable&type=packages&show=spruce
      sqlite # https://search.nixos.org/packages?channel=unstable&type=packages&show=sqlite
      tenki # https://search.nixos.org/packages?channel=unstable&type=packages&show=tenki
      tomlq # https://search.nixos.org/packages?channel=unstable&type=packages&show=tomlq
      vhs # https://search.nixos.org/packages?channel=unstable&type=packages&show=vhs
      zenity # https://search.nixos.org/packages?channel=unstable&type=packages&show=zenity
      zoxide # https://search.nixos.org/packages?channel=unstable&type=packages&show=zoxide
      # keep-sorted end

      # Miscellaneous
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # keep-sorted end

      # Terminal
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      # bat # https://search.nixos.org/packages?channel=unstable&type=packages&show=bat
      # ncdu # TODO: https://github.com/NixOS/nixpkgs/issues/290512 # https://search.nixos.org/packages?channel=unstable&type=packages&show=ncdu
      # superfile # https://search.nixos.org/packages?channel=unstable&type=packages&show=superfile
      btop # https://search.nixos.org/packages?channel=unstable&type=packages&show=btop
      byobu # https://search.nixos.org/packages?channel=unstable&type=packages&show=byobu
      cheat # https://search.nixos.org/packages?channel=unstable&type=packages&show=cheat
      dust # https://search.nixos.org/packages?channel=unstable&type=packages&show=dust
      eza # https://search.nixos.org/packages?channel=unstable&type=packages&show=eza
      fd # https://search.nixos.org/packages?channel=unstable&type=packages&show=fd
      findutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=findutils
      gotop # https://search.nixos.org/packages?channel=unstable&type=packages&show=gotop
      gzip # https://search.nixos.org/packages?channel=unstable&type=packages&show=gzip
      htop # https://search.nixos.org/packages?channel=unstable&type=packages&show=htop
      hyperfine # https://search.nixos.org/packages?channel=unstable&type=packages&show=hyperfine
      mc # https://search.nixos.org/packages?channel=unstable&type=packages&show=mc
      nnn # https://search.nixos.org/packages?channel=unstable&type=packages&show=nnn
      ranger # https://search.nixos.org/packages?channel=unstable&type=packages&show=ranger
      ripgrep # https://search.nixos.org/packages?channel=unstable&type=packages&show=ripgrep
      television # https://search.nixos.org/packages?channel=unstable&type=packages&show=television
      tldr # https://search.nixos.org/packages?channel=unstable&type=packages&show=tldr
      tmux # https://search.nixos.org/packages?channel=unstable&type=packages&show=tmux
      tree # https://search.nixos.org/packages?channel=unstable&type=packages&show=tree
      unzip # https://search.nixos.org/packages?channel=unstable&type=packages&show=unzip
      vifm # https://search.nixos.org/packages?channel=unstable&type=packages&show=vifm
      watch # https://search.nixos.org/packages?channel=unstable&type=packages&show=watch
      yazi # https://search.nixos.org/packages?channel=unstable&type=packages&show=yazi
      zip # https://search.nixos.org/packages?channel=unstable&type=packages&show=zip
      # keep-sorted end
    ]
    ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [
      # Audio
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      sonic-pi # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=sonic-pi
      supercollider-with-plugins # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=supercollider-with-plugins
      # keep-sorted end

      # Graphics
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      aseprite # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=aseprite
      emulsion-palette # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=emulsion-palette
      eyedropper # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=eyedropper
      krita # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=krita
      pureref # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=pureref
      # keep-sorted end

      # Network
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      kanidm # TODO: Missing "aarch64-apple-darwin" platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=kanidm
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
    ])
    ++ (pkgs.lib.optionals (pkgs.stdenv.isDarwin && pkgs.stdenv.hostPlatform.isAarch64) [
      # keep-sorted start block=no newline_separated=no sticky_comments=no
      podman # https://search.nixos.org/packages?channel=unstable&type=packages&show=podman
      podman-compose # https://search.nixos.org/packages?channel=unstable&type=packages&show=podman-compose
      # keep-sorted end
    ]);
}
