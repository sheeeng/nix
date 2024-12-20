{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cacert
    curl
  ];
}
