# hosts level sops. see home/[user]/common/optional/sops.nix for home/user level

{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
let
  sopsFolder = builtins.toString inputs.nix-secrets + "/sops";
in
{

}
