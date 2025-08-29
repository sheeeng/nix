{ pkgs, ... }:
{
  home.packages = with pkgs; [
    age-plugin-yubikey # https://search.nixos.org/packages?channel=unstable&type=packages&show=age-plugin-yubikey
    yubikey-agent # https://search.nixos.org/packages?channel=unstable&type=packages&show=yubikey-agent
    yubikey-manager # https://search.nixos.org/packages?channel=unstable&type=packages&show=yubikey-manager
    yubikey-personalization # https://search.nixos.org/packages?channel=unstable&type=packages&show=yubikey-personalization
  ];
}
