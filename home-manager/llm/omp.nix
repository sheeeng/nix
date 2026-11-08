{ inputs, pkgs, ... }:
let
  commonLlmSettings = import ./default.nix {
    inherit pkgs;
    basePath = ./.;
    mattPocockSkillsSource = inputs.matt-pocock-skills;
  };
  ompEnabled = pkgs ? omp && pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.omp;
in
{
  home.file = pkgs.lib.mkIf ompEnabled (
    pkgs.lib.mapAttrs' (
      name: source: pkgs.lib.nameValuePair ".omp/agent/skills/${name}" { inherit source; }
    ) commonLlmSettings.elephantGoldfishSkills
  ); # https://nix-community.github.io/home-manager/options.xhtml#opt-home.file
  home.packages = pkgs.lib.optionals ompEnabled [ pkgs.omp ]; # https://nix-community.github.io/home-manager/options.xhtml#opt-home.packages
}
