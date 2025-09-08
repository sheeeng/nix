# https://github.com/jonringer/nixpkgs-config/blob/399724e3c8b1756f636f8d485eed25d03f64aa76/packages.nix

# https://github.com/hardselius/dotfiles/blob/b801fd8aba017a588ce56430d8345449ec396c96/home/packages.nix

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (python3.withPackages (
      pkgs: with pkgs; [
        black # https://search.nixos.org/packages?channel=unstable&type=packages&show=black
        flake8 # https://search.nixos.org/packages?channel=unstable&type=packages&show=flake8
        identify # https://search.nixos.org/packages?channel=unstable&type=packages&show=identify
        pip # https://search.nixos.org/packages?channel=unstable&type=packages&show=pip
      ]
    )) # https://github.com/timokau/dotfiles/blob/c2c55834a3b479132ca07794f75a1d887fa29df6/home/configuration.nix#L94-L105

    (python3.withPackages (pythonPackages: [
      pythonPackages.black # https://search.nixos.org/packages?channel=unstable&type=packages&show=python313Packages.black
      pythonPackages.flake8 # https://search.nixos.org/packages?channel=unstable&type=packages&show=python313Packages.flake8
      pythonPackages.identify # https://search.nixos.org/packages?channel=unstable&type=packages&show=python313Packages.identify
      pythonPackages.pip # https://search.nixos.org/packages?channel=unstable&type=packages&show=python313Packages.pip
    ])) # https://discourse.nixos.org/t/how-install-python-packages-globally-with-home-manager/37025/2
  ];
}
