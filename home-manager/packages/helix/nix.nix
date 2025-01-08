# https://github.com/tommy-donavon/nixos-dots/blob/d824d5ec55109f65f0bc5e042198cafde0fbedc8/modules/home/programs/terminal/editors/helix/nix.nix

{ lib, pkgs, ... }:
{
  programs.helix.languages = {
    language = [
      {
        name = "nix";
        auto-format = true;
        formatter = {
          command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
        };
        indent = {
          tab-width = 2;
          unit = "\t";
        };
      }
    ];

    language-server = {
      nil = {
        command = lib.getExe pkgs.nil; # "${pkgs.nil}/bin/nil";
        config.nil = {
          formatting = {
            # command = [ "${lib.getExe pkgs.alejandra}" ];
            command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
          };
          nix = {
            binary = lib.getExe pkgs.nix; # "${pkgs.nix}/bin/nix";
            flake = {
              autoArchive = true;
              autoEvalInputs = true;
              nixpkgsInputName = "nixpkgs";
            };
          };
        };
      };
      nixd = {
        command = lib.getExe pkgs.nixd;
        # config.nixd = {
        #   nixpkgs.expr = "import (builtins.getFlake \"${dotfiles.path}\").inputs.nixpkgs { }";
        #   formatting.command = [ "${lib.getExe pkgs.alejandra}" ];
        #   options.nixos.expr = "(builtins.getFlake \"${dotfiles.path}\").nixosConfigurations.${dotfiles.hostname}.options";
        # }; # https://github.com/MrSom3body/dotfiles/blob/a547503e0d91fc66e4190b6fa4cf04644b5d7db2/home/editors/helix/languages.nix#L122-L126
      };
    };
  };
}
