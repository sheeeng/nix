# home level sops. see hosts/common/optional/sops.nix for hosts level
{
  inputs,
  config,
  ...
}:
let
  sopsFolder = (builtins.toString inputs.nix-secrets) + "/sops";
  homeDirectory = config.home.homeDirectory;
in
{
}
