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
    ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [
      apple-cursor # https://search.nixos.org/packages?channel=unstable&type=packages&show=apple-cursor
      banana-cursor # https://search.nixos.org/packages?channel=unstable&type=packages&show=banana-cursor
      pokemon-cursor # https://search.nixos.org/packages?channel=unstable&type=packages&show=pokemon-cursor
    ])
    ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [
      vscodium # https://search.nixos.org/packages?channel=unstable&type=packages&show=vscodium
    ])
    ++ (pkgs.lib.optionals (pkgs.stdenv.isDarwin && pkgs.stdenv.hostPlatform.isAarch64) [
      hidden-bar # https://search.nixos.org/packages?channel=unstable&type=packages&show=hidden-bar
    ]);
}
