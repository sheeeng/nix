{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # Basic utilities
    # keep-sorted start block=no newline_separated=no
    bc # https://search.nixos.org/packages?channel=unstable&type=packages&show=bc
    coreutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=coreutils
    curl # https://search.nixos.org/packages?channel=unstable&type=packages&show=curl
    dos2unix # https://search.nixos.org/packages?channel=unstable&type=packages&show=dos2unix
    fd # https://search.nixos.org/packages?channel=unstable&type=packages&show=fd
    findutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=findutils
    gzip # https://search.nixos.org/packages?channel=unstable&type=packages&show=gzip
    jq # https://search.nixos.org/packages?channel=unstable&type=packages&show=jq
    less # https://search.nixos.org/packages?channel=unstable&type=packages&show=less
    ripgrep # https://search.nixos.org/packages?channel=unstable&type=packages&show=ripgrep
    unzip # https://search.nixos.org/packages?channel=unstable&type=packages&show=unzip
    vim # https://search.nixos.org/packages?channel=unstable&type=packages&show=vim
    wget # https://search.nixos.org/packages?channel=unstable&type=packages&show=wget
    zip # https://search.nixos.org/packages?channel=unstable&type=packages&show=zip
    # keep-sorted end

    # Terminal utilities
    # keep-sorted start block=no newline_separated=no
    bat # https://search.nixos.org/packages?channel=unstable&type=packages&show=bat
    btop # https://search.nixos.org/packages?channel=unstable&type=packages&show=btop
    eza # https://search.nixos.org/packages?channel=unstable&type=packages&show=eza
    htop # https://search.nixos.org/packages?channel=unstable&type=packages&show=htop
    tree # https://search.nixos.org/packages?channel=unstable&type=packages&show=tree
    watch # https://search.nixos.org/packages?channel=unstable&type=packages&show=watch
    # keep-sorted end

    # Git related (managed through packages/git but including core here)
    # keep-sorted start block=no newline_separated=no
    gh # https://search.nixos.org/packages?channel=unstable&type=packages&show=gh
    lazygit # https://search.nixos.org/packages?channel=unstable&type=packages&show=lazygit
    # keep-sorted end

    # Network utilities
    # keep-sorted start block=no newline_separated=no
    bind.dnsutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=dnsutils
    whois # https://search.nixos.org/packages?channel=unstable&type=packages&show=whois
    # keep-sorted end
  ];
}
