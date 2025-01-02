# https://github.com/jonringer/nixpkgs-config/blob/399724e3c8b1756f636f8d485eed25d03f64aa76/packages.nix

# https://github.com/hardselius/dotfiles/blob/b801fd8aba017a588ce56430d8345449ec396c96/home/packages.nix

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    age # https://search.nixos.org/packages?channel=unstable&type=packages&show=age
    age-plugin-yubikey # https://search.nixos.org/packages?channel=unstable&type=packages&show=age-plugin-yubikey
    asdf-vm # https://search.nixos.org/packages?channel=unstable&type=packages&show=asdf-vm
    autoconf # https://search.nixos.org/packages?channel=unstable&type=packages&show=autoconf
    azure-cli # https://search.nixos.org/packages?channel=unstable&type=packages&show=azure-cli
    barcode # https://search.nixos.org/packages?channel=unstable&type=packages&show=barcode
    bc # https://search.nixos.org/packages?channel=unstable&type=packages&show=bc
    binutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=binutils
    btop # https://search.nixos.org/packages?channel=unstable&type=packages&show=btop
    cbonsai # https://search.nixos.org/packages?channel=unstable&type=packages&show=cbonsai
    chafa # https://search.nixos.org/packages?channel=unstable&type=packages&show=chafa
    cmatrix # https://search.nixos.org/packages?channel=unstable&type=packages&show=cmatrix
    conform # https://search.nixos.org/packages?channel=unstable&type=packages&show=conform
    cowsay # https://search.nixos.org/packages?channel=unstable&type=packages&show=cowsay
    croc # https://search.nixos.org/packages?channel=unstable&type=packages&show=croc
    dasel # https://search.nixos.org/packages?channel=unstable&type=packages&show=dasel
    devenv # https://search.nixos.org/packages?channel=unstable&type=packages&show=devenv
    dos2unix # https://search.nixos.org/packages?channel=unstable&type=packages&show=dos2unix
    exiftool # https://search.nixos.org/packages?channel=unstable&type=packages&show=exiftool
    ffmpeg # https://search.nixos.org/packages?channel=unstable&type=packages&show=ffmpeg
    findutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=findutils
    fq # https://search.nixos.org/packages?channel=unstable&type=packages&show=fq
    # fuff # TODO: https://github.com/ffuf/ffuf # https://search.nixos.org/packages?channel=unstable&type=packages&show=fuff
    go-task # https://search.nixos.org/packages?channel=unstable&type=packages&show=go-task
    gomtree # https://search.nixos.org/packages?channel=unstable&type=packages&show=gomtree
    gotop # https://search.nixos.org/packages?channel=unstable&type=packages&show=gotop
    graphviz # https://search.nixos.org/packages?channel=unstable&type=packages&show=graphviz
    gzip # https://search.nixos.org/packages?channel=unstable&type=packages&show=gzip
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
    # mpc-cli # TODO: https://github.com/NixOS/nixpkgs/issues/355495 # https://search.nixos.org/packages?channel=unstable&type=packages&show=mpc-cli
    mpd # https://search.nixos.org/packages?channel=unstable&type=packages&show=mpd
    # ncdu # TODO: https://github.com/NixOS/nixpkgs/issues/290512 # https://search.nixos.org/packages?channel=unstable&type=packages&show=ncdu
    ncmpcpp  # https://search.nixos.org/packages?channel=unstable&type=packages&show=ncmpcpp
    newsboat # https://search.nixos.org/packages?channel=unstable&type=packages&show=newsboat
    nh # https://search.nixos.org/packages?channel=unstable&type=packages&show=nh
    nil # https://search.nixos.org/packages?channel=unstable&type=packages&show=nil
    nix # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix
    nix-output-monitor # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-output-monitor
    nixd # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixd
    nixfmt-rfc-style # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixfmt-rfc-style
    nixpkgs-fmt # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixpkgs-fmt
    obsidian # https://search.nixos.org/packages?channel=unstable&type=packages&show=obsidian
    # parallel # (lib.hiPrio parallel) # TODO: https://haseebmajid.dev/posts/2023-10-02-til-how-to-fix-package-binary-collisions-on-nix/ # https://search.nixos.org/packages?channel=unstable&type=packages&show=parallel
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
    rclone # TODO: See `nixpkgs.overlays` in other file. # https://search.nixos.org/packages?channel=unstable&type=packages&show=rclone
    sipcalc # https://search.nixos.org/packages?channel=unstable&type=packages&show=sipcalc
    sops # https://search.nixos.org/packages?channel=unstable&type=packages&show=sops
    spruce # https://search.nixos.org/packages?channel=unstable&type=packages&show=spruce
    sqlite # https://search.nixos.org/packages?channel=unstable&type=packages&show=sqlite
    ssss # https://search.nixos.org/packages?channel=unstable&type=packages&show=ssss
    stow # https://search.nixos.org/packages?channel=unstable&type=packages&show=stow
    # taskctl # TODO: https://github.com/taskctl/taskctl # https://search.nixos.org/packages?channel=unstable&type=packages&show=taskctl
    tenki # https://search.nixos.org/packages?channel=unstable&type=packages&show=tenki
    terraform # https://search.nixos.org/packages?channel=unstable&type=packages&show=terraform
    tldr # https://search.nixos.org/packages?channel=unstable&type=packages&show=tldr
    tree # https://search.nixos.org/packages?channel=unstable&type=packages&show=tree
    treefmt # https://search.nixos.org/packages?channel=unstable&type=packages&show=treefmt
    unzip # https://search.nixos.org/packages?channel=unstable&type=packages&show=unzip
    # uuid7 # TODO: https://github.com/stevesimmons/uuid7 # https://search.nixos.org/packages?channel=unstable&type=packages&show=uuid7
    vhs # https://search.nixos.org/packages?channel=unstable&type=packages&show=vhs
    watch # https://search.nixos.org/packages?channel=unstable&type=packages&show=watch
    websocat # https://search.nixos.org/packages?channel=unstable&type=packages&show=websocat
    wget # https://search.nixos.org/packages?channel=unstable&type=packages&show=wget
    # ws # TODO: https://github.com/lewoudar/ws/ # https://search.nixos.org/packages?channel=unstable&type=packages&show=ws
    yubikey-manager # https://search.nixos.org/packages?channel=unstable&type=packages&show=yubikey-manager
    yubikey-personalization # https://search.nixos.org/packages?channel=unstable&type=packages&show=yubikey-personalization
    zenity # https://search.nixos.org/packages?channel=unstable&type=packages&show=zenity
    zip # https://search.nixos.org/packages?channel=unstable&type=packages&show=zip
  ];
}
