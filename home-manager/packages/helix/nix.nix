# https://github.com/tommy-donavon/nixos-dots/blob/d824d5ec55109f65f0bc5e042198cafde0fbedc8/modules/home/programs/terminal/editors/helix/nix.nix

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nil
    nixpkgs-fmt
  ];

  programs.helix.languages = {
    language-server.nil = {
      command = "${pkgs.nil}/bin/nil";

      config.nil = {
        formatting.command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
        auto-format = true;
        nix = {
          binary = "${pkgs.nix}/bin/nix";
          flake = {
            autoEvalInputs = true;
            nixpkgsInputName = "unstable";
          };
        };
      };
    };
  };
}
