# https://github.com/jonringer/nixpkgs-config/blob/399724e3c8b1756f636f8d485eed25d03f64aa76/packages.nix

# https://github.com/hardselius/dotfiles/blob/b801fd8aba017a588ce56430d8345449ec396c96/home/packages.nix

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # (nerdfonts.override {
    #   fonts = [
    #     "DejaVuSansMono"
    #     "DroidSansMono"
    #     "FantasqueSansMono"
    #     "FiraCode"
    #     "FiraMono"
    #     "Hack"
    #     "Iosevka"
    #     "IosevkaTerm"
    #     "IosevkaTermSlab"
    #     "NerdFontsSymbolsOnly"
    #     "Ubuntu"
    #     "UbuntuMono"
    #     "UbuntuSans"
    #     "VictorMono"
    #   ];
    # }) # https://nixos.wiki/wiki/fonts#Installing_only_specific_nerdfonts

    # Use the following to install all nerd-fonts on 25.05 release of NixOS.
    # https://github.com/NixOS/nixpkgs/blob/9018c7b154ab3427970dbfe52d8a3150e0cecb7b/nixos/doc/manual/release-notes/rl-2505.section.md#L53-L57
    # nerd-fonts.0xproto # TODO: Avoid nix-fmt formatting.
    # nerd-fonts._3270
    # nerd-fonts.agave
    # nerd-fonts.anonymice
    # nerd-fonts.arimo
    # nerd-fonts.aurulent-sans-mono
    # nerd-fonts.bigblue-terminal
    # nerd-fonts.bitstream-vera-sans-mono
    # nerd-fonts.blex-mono
    # nerd-fonts.caskaydia-cove
    # nerd-fonts.caskaydia-mono
    # nerd-fonts.code-new-roman
    # nerd-fonts.comic-shanns-mono
    # nerd-fonts.commit-mono
    # nerd-fonts.cousine
    # nerd-fonts.d2coding
    # nerd-fonts.daddy-time-mono
    # nerd-fonts.departure-mono

    nerd-fonts.dejavu-sans-mono # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.dejavu-sans-mono
    nerd-fonts.droid-sans-mono # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.droid-sans-mono
    # nerd-fonts.envy-code-r
    nerd-fonts.fantasque-sans-mono # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.fantasque-sans-mono
    nerd-fonts.fira-code # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.fira-code
    nerd-fonts.fira-mono # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.fira-mono
    nerd-fonts.geist-mono # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.geist-mono
    nerd-fonts.go-mono # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.go-mono
    nerd-fonts.gohufont # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.gohufont
    nerd-fonts.hack # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.hack
    # nerd-fonts.hasklug
    # nerd-fonts.heavy-data
    # nerd-fonts.hurmit
    # nerd-fonts.im-writing
    nerd-fonts.inconsolata # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.inconsolata
    # nerd-fonts.inconsolata-go
    # nerd-fonts.inconsolata-lgc
    nerd-fonts.intone-mono # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.intone-mono
    nerd-fonts.iosevka # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.iosevka
    nerd-fonts.iosevka-term # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.iosevka-term
    nerd-fonts.iosevka-term-slab # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.iosevka-term-slab
    nerd-fonts.jetbrains-mono # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.jetbrains-mono
    nerd-fonts.lekton # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.lekton
    nerd-fonts.liberation # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.liberation
    nerd-fonts.lilex # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.lilex
    nerd-fonts.martian-mono # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.martian-mono
    nerd-fonts.meslo-lg # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.meslo
    nerd-fonts.monaspace # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.monaspace
    nerd-fonts.monofur # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.monofur
    nerd-fonts.monoid # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.monoid
    nerd-fonts.mononoki # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.mononoki
    nerd-fonts.noto # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.noto
    # nerd-fonts.open-dyslexic
    # nerd-fonts.overpass
    # nerd-fonts.profont
    # nerd-fonts.proggy-clean-tt
    nerd-fonts.recursive-mono # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.recursive-mono
    nerd-fonts.roboto-mono # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.roboto-mono
    # nerd-fonts.shure-tech-mono
    # nerd-fonts.sauce-code-pro
    # nerd-fonts.space-mono
    nerd-fonts.symbols-only # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.symbols-only
    # nerd-fonts.terminess-ttf
    # nerd-fonts.tinos
    nerd-fonts.ubuntu # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.ubuntu-mono
    nerd-fonts.ubuntu-sans # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.ubuntu-sans
    nerd-fonts.victor-mono # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.victor-mono
    nerd-fonts.zed-mono # https://search.nixos.org/packages?channel=unstable&type=packages&show=nerd-fonts.zed-mono
    vt323 # https://search.nixos.org/packages?channel=unstable&type=packages&show=vt323
  ];
}
