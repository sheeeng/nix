# https://github.com/jonringer/nixpkgs-config/blob/399724e3c8b1756f636f8d485eed25d03f64aa76/packages.nix

# https://github.com/hardselius/dotfiles/blob/b801fd8aba017a588ce56430d8345449ec396c96/home/packages.nix

# _: { }

{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      oneko # https://search.nixos.org/packages?channel=unstable&type=packages&show=oneko
    ]
    ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [
      ghostty-bin # https://search.nixos.org/packages?channel=unstable&query=ghostty#show=ghostty-bin
      vscodium # https://search.nixos.org/packages?channel=unstable&type=packages&show=vscodium
    ])
    ++ (pkgs.lib.optionals (pkgs.stdenv.isDarwin && pkgs.stdenv.hostPlatform.isAarch64) [
      hidden-bar # https://search.nixos.org/packages?channel=unstable&type=packages&show=hidden-bar
    ]);
}
