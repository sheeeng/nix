# TODO: https://github.com/uesyn/dotfiles/blob/a28964187ab74b880f2e8ae561359451e9a05e29/home-manager/rust/default.nix
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    cargo-criterion
    cargo-cross
    cargo-edit
    cargo-expand
    cargo-sort
    cargo-udeps
    cargo-wipe
    rustup
    taplo
  ];

  home.sessionPath = [ "${config.home.homeDirectory}/.cargo/bin" ];

  home.sessionVariables = {
    # https://github.com/cross-rs/cross/issues/260#issuecomment-1140528221
    NIX_STORE = "/nix/store";
  };
}
