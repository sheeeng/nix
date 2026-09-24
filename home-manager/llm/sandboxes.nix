{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nono # https://search.nixos.org/packages?channel=unstable&type=packages&show=nono
    sandbox-runtime # https://search.nixos.org/packages?channel=unstable&type=packages&show=sandbox-runtime
  ];
}
