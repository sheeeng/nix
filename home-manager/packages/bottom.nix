{ pkgs, ... }:
{
  programs.bottom =
    let
      themes =
        let
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bottom";
            rev = "eadd75acd0ecad4a58ade9a1d6daa3b97ccec07c";
            sha256 = "sha256-dfukdk70ug1lRGADKBnvMhkl+3tsY7F+UAwTS2Qyapk=";
          };
        in
        builtins.path { path = "${src}/themes/mocha.toml"; };
    in
    {
      enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bottom.enable
      package = pkgs.bottom; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bottom.package
      settings = builtins.fromTOML (builtins.readFile themes);
    };
}
