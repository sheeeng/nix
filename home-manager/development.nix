# https://github.com/jonringer/nixpkgs-config/blob/399724e3c8b1756f636f8d485eed25d03f64aa76/packages.nix

# https://github.com/hardselius/dotfiles/blob/b801fd8aba017a588ce56430d8345449ec396c96/home/packages.nix

{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      code-cursor # https://search.nixos.org/packages?channel=unstable&type=packages&show=code-cursor
      vscodium # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.enable # https://search.nixos.org/packages?channel=unstable&type=packages&show=vscodium
      # claude-code # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.claude-code.enable # https://search.nixos.org/packages?channel=unstable&type=packages&show=claude-code
    ]
    ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [ ])
    ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [ ])
    ++ (pkgs.lib.optionals (pkgs.stdenv.isDarwin && pkgs.stdenv.hostPlatform.isAarch64) [ ]);
}
