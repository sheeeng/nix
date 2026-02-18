{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # Basic utilities
    # keep-sorted start block=no newline_separated=no
    (lib.hiPrio uutils-coreutils-noprefix) # https://search.nixos.org/packages?channel=unstable&type=packages&show=uutils-coreutils-noprefixd
    bc # https://search.nixos.org/packages?channel=unstable&type=packages&show=bc
    curl # https://search.nixos.org/packages?channel=unstable&type=packages&show=curl
    dos2unix # https://search.nixos.org/packages?channel=unstable&type=packages&show=dos2unix
    fd # https://search.nixos.org/packages?channel=unstable&type=packages&show=fd
    findutils # https://search.nixos.org/packages?channel=unstable&type=packages&show=findutils
    fzf # https://search.nixos.org/packages?channel=unstable&type=packages&show=fzf
    gzip # https://search.nixos.org/packages?channel=unstable&type=packages&show=gzip
    jq # https://search.nixos.org/packages?channel=unstable&type=packages&show=jq
    less # https://search.nixos.org/packages?channel=unstable&type=packages&show=less
    ripgrep # https://search.nixos.org/packages?channel=unstable&type=packages&show=ripgrep
    starship # https://search.nixos.org/packages?channel=unstable&type=packages&show=starship
    unzip # https://search.nixos.org/packages?channel=unstable&type=packages&show=unzip
    vim # https://search.nixos.org/packages?channel=unstable&type=packages&show=vim
    wget # https://search.nixos.org/packages?channel=unstable&type=packages&show=wget
    zoxide # https://search.nixos.org/packages?channel=unstable&type=packages&show=zoxide
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

    # Nix related utilities
    # keep-sorted start block=no newline_separated=no
    nh # https://search.nixos.org/packages?channel=unstable&type=packages&show=nh
    nil # https://search.nixos.org/packages?channel=unstable&type=packages&show=nil
    nix-output-monitor # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-output-monitor
    nix-prefetch-git # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-prefetch-git
    nix-prefetch-github # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-prefetch-github
    nix-prefetch-scripts # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix-prefetch-scripts
    nixd # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixd
    nixfmt # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixfmt
    nvd # https://search.nixos.org/packages?channel=unstable&type=packages&show=nvd
    # keep-sorted end
  ];
}
