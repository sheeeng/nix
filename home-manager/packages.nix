# https://github.com/jonringer/nixpkgs-config/blob/399724e3c8b1756f636f8d485eed25d03f64aa76/packages.nix

# https://github.com/hardselius/dotfiles/blob/b801fd8aba017a588ce56430d8345449ec396c96/home/packages.nix

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # (lib.hiPrio bat) # TODO: Collision error with `bat-unstable` override package. # https://search.nixos.org/packages?channel=unstable&type=packages&show=bat
    # (lib.hiPrio go-task) # TODO: Collision error with `taskwarrior-3` package. # https://search.nixos.org/packages?channel=unstable&type=packages&show=go-task
    # (lib.lowPrio sc) # TODO: Collision error with `smartcat` package. # https://search.nixos.org/packages?channel=unstable&type=packages&show=sc
    # alpine # TODO: Unavailable on aarch64-apple-darwin platform. # https://search.nixos.org/packages?channel=unstable&type=packages&show=alpine
    # fuff # TODO: https://github.com/ffuf/ffuf # https://search.nixos.org/packages?channel=unstable&type=packages&show=fuff
    # gomuks # https://search.nixos.org/packages?channel=unstable&type=packages&show=gomuks
    # ii # https://search.nixos.org/packages?channel=unstable&type=packages&show=ii
    # mpc-cli # TODO: https://github.com/NixOS/nixpkgs/issues/355495 # https://search.nixos.org/packages?channel=unstable&type=packages&show=mpc-cli
    # mpd # https://search.nixos.org/packages?channel=unstable&type=packages&show=mpd
    # mutt # https://search.nixos.org/packages?channel=unstable&type=packages&show=mutt
    # ncdu # TODO: https://github.com/NixOS/nixpkgs/issues/290512 # https://search.nixos.org/packages?channel=unstable&type=packages&show=ncdu
    # ncmpcpp # https://search.nixos.org/packages?channel=unstable&type=packages&show=ncmpcpp
    # neomutt # https://search.nixos.org/packages?channel=unstable&type=packages&show=neomutt
    # parallel # (lib.hiPrio parallel) # TODO: https://haseebmajid.dev/posts/2023-10-02-til-how-to-fix-package-binary-collisions-on-nix/ # https://search.nixos.org/packages?channel=unstable&type=packages&show=parallel
    # sct # https://search.nixos.org/packages?channel=unstable&type=packages&show=sct
    # taskctl # TODO: https://github.com/taskctl/taskctl # https://search.nixos.org/packages?channel=unstable&type=packages&show=taskctl
    # uuid7 # TODO: https://github.com/stevesimmons/uuid7 # https://search.nixos.org/packages?channel=unstable&type=packages&show=uuid7
    # weechat # https://search.nixos.org/packages?channel=unstable&type=packages&show=weechat
    # ws # TODO: https://github.com/lewoudar/ws/ # https://search.nixos.org/packages?channel=unstable&type=packages&show=ws
    # x-cmd # TODO: https://github.com/x-cmd/x-cmd # https://search.nixos.org/packages?channel=unstable&type=packages&show=x-cmd
    aerc # https://search.nixos.org/packages?channel=unstable&type=packages&show=aerc
    age # https://search.nixos.org/packages?channel=unstable&type=packages&show=age
    age-plugin-yubikey # https://search.nixos.org/packages?channel=unstable&type=packages&show=age-plugin-yubikey
    asdf-vm # https://search.nixos.org/packages?channel=unstable&type=packages&show=asdf-vm
    autoconf # https://search.nixos.org/packages?channel=unstable&type=packages&show=autoconf
    azure-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=azure-cli
    barcode # https://search.nixos.org/packages?channel=unstable&type=packages&show=barcode
    bc # https://search.nixos.org/packages?channel=unstable&type=packages&show=bc
    binutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=binutils
    bitwise # https://search.nixos.org/packages?channel=unstable&type=packages&show=bitwise
    btop # https://search.nixos.org/packages?channel=unstable&type=packages&show=btop
    calcurse # https://search.nixos.org/packages?channel=unstable&type=packages&show=calcurse
    cbonsai # https://search.nixos.org/packages?channel=unstable&type=packages&show=cbonsai
    chafa # https://search.nixos.org/packages?channel=unstable&type=packages&show=chafa
    cmatrix # https://search.nixos.org/packages?channel=unstable&type=packages&show=cmatrix
    conform # https://search.nixos.org/packages?channel=unstable&type=packages&show=conform
    cowsay # https://search.nixos.org/packages?channel=unstable&type=packages&show=cowsay
    croc # https://search.nixos.org/packages?channel=unstable&type=packages&show=croc
    dasel # https://search.nixos.org/packages?channel=unstable&type=packages&show=dasel
    delta # https://search.nixos.org/packages?channel=unstable&type=packages&show=delta
    devenv # https://search.nixos.org/packages?channel=unstable&type=packages&show=devenv
    dos2unix # https://search.nixos.org/packages?channel=unstable&type=packages&show=dos2unix
    exiftool # https://search.nixos.org/packages?channel=unstable&type=packages&show=exiftool
    eza # https://search.nixos.org/packages?channel=unstable&type=packages&show=eza
    fd # https://search.nixos.org/packages?channel=unstable&type=packages&show=fd
    ffmpeg # https://search.nixos.org/packages?channel=unstable&type=packages&show=ffmpeg
    findutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=findutils
    fq # https://search.nixos.org/packages?channel=unstable&type=packages&show=fq
    gh # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh
    glow # https://search.nixos.org/packages?channel=unstable&type=packages&show=glow
    gomtree # https://search.nixos.org/packages?channel=unstable&type=packages&show=gomtree
    gotop # https://search.nixos.org/packages?channel=unstable&type=packages&show=gotop
    graphviz # https://search.nixos.org/packages?channel=unstable&type=packages&show=graphviz
    gzip # https://search.nixos.org/packages?channel=unstable&type=packages&show=gzip
    helix # https://search.nixos.org/packages?channel=unstable&type=packages&show=helix
    hexedit # https://search.nixos.org/packages?channel=unstable&type=packages&show=hexedit
    htop # https://search.nixos.org/packages?channel=unstable&type=packages&show=htop
    imagemagick # https://search.nixos.org/packages?channel=unstable&type=packages&show=imagemagick
    ipcalc # https://search.nixos.org/packages?channel=unstable&type=packages&show=ipcalc
    jq # https://search.nixos.org/packages?channel=unstable&type=packages&show=jq
    krabby # https://search.nixos.org/packages?channel=unstable&type=packages&show=krabby
    lazygit # https://search.nixos.org/packages?channel=unstable&type=packages&show=lazygit
    lazysql # https://search.nixos.org/packages?channel=unstable&type=packages&show=lazysql
    lego # https://search.nixos.org/packages?channel=unstable&type=packages&show=lego
    lolcat # https://search.nixos.org/packages?channel=unstable&type=packages&show=lolcat
    mc # https://search.nixos.org/packages?channel=unstable&type=packages&show=mc
    minify # https://search.nixos.org/packages?channel=unstable&type=packages&show=minify
    mkdocs # https://search.nixos.org/packages?channel=unstable&type=packages&show=mkdocs
    moreutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=moreutils
    newsboat # https://search.nixos.org/packages?channel=unstable&type=packages&show=newsboat
    nh # https://search.nixos.org/packages?channel=unstable&type=packages&show=nh
    nil # https://search.nixos.org/packages?channel=unstable&type=packages&show=nil
    nix # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix
    nix-output-monitor # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-output-monitor
    nixd # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixd
    nixfmt-rfc-style # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixfmt-rfc-style
    nixpkgs-fmt # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixpkgs-fmt
    nnn # https://search.nixos.org/packages?channel=unstable&type=packages&show=nnn
    obsidian # https://search.nixos.org/packages?channel=unstable&type=packages&show=obsidian
    ollama # TODO: Marked as insecure. # https://search.nixos.org/packages?channel=unstable&type=packages&show=ollama
    pass # https://search.nixos.org/packages?channel=unstable&type=packages&show=pass
    pass-git-helper # https://search.nixos.org/packages?channel=unstable&type=packages&show=pass-git-helper
    passage # https://search.nixos.org/packages?channel=unstable&type=packages&show=passage
    passphrase2pgp # https://search.nixos.org/packages?channel=unstable&type=packages&show=passphrase2pgp
    pipes # https://search.nixos.org/packages?channel=unstable&type=packages&show=pipes
    pipes-rs # https://search.nixos.org/packages?channel=unstable&type=packages&show=pipes-rs
    podman # https://search.nixos.org/packages?channel=unstable&type=packages&show=podman
    podman-compose # https://search.nixos.org/packages?channel=unstable&type=packages&show=podman-compose
    progress # https://search.nixos.org/packages?channel=unstable&type=packages&show=progress
    qrencode # https://search.nixos.org/packages?channel=unstable&type=packages&show=qrencode
    ranger # https://search.nixos.org/packages?channel=unstable&type=packages&show=ranger
    rclone # TODO: See `nixpkgs.overlays` in other file. # https://search.nixos.org/packages?channel=unstable&type=packages&show=rclone
    ripgrep # https://search.nixos.org/packages?channel=unstable&type=packages&show=ripgrep
    sc-im # https://search.nixos.org/packages?channel=unstable&type=packages&show=sc-im
    shfmt # https://search.nixos.org/packages?channel=unstable&type=packages&show=shfmt
    sipcalc # https://search.nixos.org/packages?channel=unstable&type=packages&show=sipcalc
    smartcat # https://search.nixos.org/packages?channel=unstable&type=packages&show=smartcat
    sops # https://search.nixos.org/packages?channel=unstable&type=packages&show=sops
    spruce # https://search.nixos.org/packages?channel=unstable&type=packages&show=spruce
    sqlite # https://search.nixos.org/packages?channel=unstable&type=packages&show=sqlite
    ssss # https://search.nixos.org/packages?channel=unstable&type=packages&show=ssss
    stow # https://search.nixos.org/packages?channel=unstable&type=packages&show=stow
    superfile # https://search.nixos.org/packages?channel=unstable&type=packages&show=superfile
    taskwarrior3 # https://search.nixos.org/packages?channel=unstable&type=packages&show=taskwarrior3
    television # https://search.nixos.org/packages?channel=unstable&type=packages&show=television
    tenki # https://search.nixos.org/packages?channel=unstable&type=packages&show=tenki
    terraform # https://search.nixos.org/packages?channel=unstable&type=packages&show=terraform
    tig # https://search.nixos.org/packages?channel=unstable&type=packages&show=tig
    tldr # https://search.nixos.org/packages?channel=unstable&type=packages&show=tldr
    tmux # https://search.nixos.org/packages?channel=unstable&type=packages&show=tmux
    tree # https://search.nixos.org/packages?channel=unstable&type=packages&show=tree
    treefmt # https://search.nixos.org/packages?channel=unstable&type=packages&show=treefmt
    unzip # https://search.nixos.org/packages?channel=unstable&type=packages&show=unzip
    vhs # https://search.nixos.org/packages?channel=unstable&type=packages&show=vhs
    vifm # https://search.nixos.org/packages?channel=unstable&type=packages&show=vifm
    watch # https://search.nixos.org/packages?channel=unstable&type=packages&show=watch
    websocat # https://search.nixos.org/packages?channel=unstable&type=packages&show=websocat
    wget # https://search.nixos.org/packages?channel=unstable&type=packages&show=wget
    wyrd # https://search.nixos.org/packages?channel=unstable&type=packages&show=wyrd
    yazi # https://search.nixos.org/packages?channel=unstable&type=packages&show=yazi
    yubikey-manager # https://search.nixos.org/packages?channel=unstable&type=packages&show=yubikey-manager
    yubikey-personalization # https://search.nixos.org/packages?channel=unstable&type=packages&show=yubikey-personalization
    zenity # https://search.nixos.org/packages?channel=unstable&type=packages&show=zenity
    zip # https://search.nixos.org/packages?channel=unstable&type=packages&show=zip
    zoxide # https://search.nixos.org/packages?channel=unstable&type=packages&show=zoxide
  ];
}
