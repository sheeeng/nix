# https://github.com/jonringer/nixpkgs-config/blob/399724e3c8b1756f636f8d485eed25d03f64aa76/packages.nix

# https://github.com/hardselius/dotfiles/blob/b801fd8aba017a588ce56430d8345449ec396c96/home/packages.nix

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    age
    age-plugin-yubikey
    asdf-vm
    autoconf
    azure-cli
    barcode
    bc
    binutils
    btop
    cbonsai
    chafa
    cmatrix
    conform
    cowsay
    devenv
    dos2unix
    exiftool
    ffmpeg
    findutils
    ipcalc
    graphviz
    gzip
    # htop
    imagemagick
    jq
    krabby
    lolcat
    moreutils
    # mpc-cli
    # mpd
    # mkdocs
    # ncdu # TODO: https://github.com/NixOS/nixpkgs/issues/290512
    # ncmpcpp
    # https://nixos.wiki/wiki/fonts#Installing_only_specific_nerdfonts
    (nerdfonts.override {
      fonts = [
        "DejaVuSansMono"
        "DroidSansMono"
        "FantasqueSansMono"
        "FiraCode"
        "FiraMono"
        "Hack"
        "Iosevka"
        "IosevkaTerm"
        "IosevkaTermSlab"
        "NerdFontsSymbolsOnly"
        "Ubuntu"
        "UbuntuMono"
        "UbuntuSans"
        "VictorMono"
      ];
    })
    # # https://github.com/NixOS/nixpkgs/blob/9018c7b154ab3427970dbfe52d8a3150e0cecb7b/nixos/doc/manual/release-notes/rl-2505.section.md#L53-L57
    # # nerd-fonts.0xproto # TODO: Avoid nix-fmt formatting.
    # # nerd-fonts._3270
    # # nerd-fonts.agave
    # # nerd-fonts.anonymice
    # # nerd-fonts.arimo
    # # nerd-fonts.aurulent-sans-mono
    # # nerd-fonts.bigblue-terminal
    # # nerd-fonts.bitstream-vera-sans-mono
    # # nerd-fonts.blex-mono
    # # nerd-fonts.caskaydia-cove
    # # nerd-fonts.caskaydia-mono
    # # nerd-fonts.code-new-roman
    # # nerd-fonts.comic-shanns-mono
    # # nerd-fonts.commit-mono
    # # nerd-fonts.cousine
    # # nerd-fonts.d2coding
    # # nerd-fonts.daddy-time-mono
    # # nerd-fonts.departure-mono
    # nerd-fonts.dejavu-sans-mono
    # nerd-fonts.droid-sans-mono
    # # nerd-fonts.envy-code-r
    # nerd-fonts.fantasque-sans-mono
    # nerd-fonts.fira-code
    # nerd-fonts.fira-mono
    # # nerd-fonts.geist-mono
    # # nerd-fonts.go-mono
    # # nerd-fonts.gohufont
    # nerd-fonts.hack
    # # nerd-fonts.hasklug
    # # nerd-fonts.heavy-data
    # # nerd-fonts.hurmit
    # # nerd-fonts.im-writing
    # # nerd-fonts.inconsolata
    # # nerd-fonts.inconsolata-go
    # # nerd-fonts.inconsolata-lgc
    # # nerd-fonts.intone-mono
    # nerd-fonts.iosevka
    # nerd-fonts.iosevka-term
    # nerd-fonts.iosevka-term-slab
    # nerd-fonts.jetbrains-mono
    # # nerd-fonts.lekton
    # # nerd-fonts.liberation
    # # nerd-fonts.lilex
    # # nerd-fonts.martian-mono
    # # nerd-fonts.meslo-lg
    # # nerd-fonts.monaspace
    # # nerd-fonts.monofur
    # # nerd-fonts.monoid
    # # nerd-fonts.mononoki
    # # nerd-fonts.mplus
    # nerd-fonts.noto
    # # nerd-fonts.open-dyslexic
    # # nerd-fonts.overpass
    # # nerd-fonts.profont
    # # nerd-fonts.proggy-clean-tt
    # # nerd-fonts.recursive-mono
    # # nerd-fonts.roboto-mono
    # # nerd-fonts.shure-tech-mono
    # # nerd-fonts.sauce-code-pro
    # # nerd-fonts.space-mono
    # nerd-fonts.symbols-only
    # # nerd-fonts.terminess-ttf
    # # nerd-fonts.tinos
    # nerd-fonts.ubuntu
    # nerd-fonts.ubuntu-mono
    # nerd-fonts.ubuntu-sans
    # nerd-fonts.victor-mono
    # # nerd-fonts.zed-mono
    newsboat
    nil
    nixd
    nixfmt-rfc-style
    nixpkgs-fmt
    nix-output-monitor
    obsidian
    (lib.hiPrio parallel) # https://haseebmajid.dev/posts/2023-10-02-til-how-to-fix-package-binary-collisions-on-nix/
    pass
    pass-git-helper
    passage
    passphrase2pgp
    pipes
    pipes-rs
    podman
    podman-compose
    progress
    #
    # (python3.withPackages (
    #   pkgs: with pkgs; [
    #     black # python formatting
    #     flake8 # python linting
    #   ]
    # )) # https://github.com/timokau/dotfiles/blob/c2c55834a3b479132ca07794f75a1d887fa29df6/home/configuration.nix#L94-L105
    #
    # (python3.withPackages (pythonPackages: [
    #   pythonPackages.black
    #   pythonPackages.flake8
    # ])) # https://discourse.nixos.org/t/how-install-python-packages-globally-with-home-manager/37025/2
    #
    rclone # nixpkgs.overlays
    sipcalc
    sops
    stow
    tenki
    terraform
    tldr
    tree
    treefmt
    unzip
    watch
    yubikey-manager
    yubikey-personalization
    zip
    wget
  ];
}
