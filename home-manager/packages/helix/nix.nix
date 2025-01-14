{ lib, pkgs, ... }:
{
  programs.helix = {
    languages = {
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
          command = lib.getExe pkgs.nil; # https://search.nixos.org/packages?channel=unstable&type=packages&show=nil
          config.nil = {
            formatting = {
              # command = [ "${lib.getExe pkgs.alejandra}" ];
              command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
            };
            nix = {
              binary = lib.getExe pkgs.nix; # https://search.nixos.org/packages?channel=unstable&type=packages&show=nix
              flake = {
                autoArchive = true;
                autoEvalInputs = true;
                nixpkgsInputName = "nixpkgs";
              };
            };
          };
        };
        nixd = {
          command = lib.getExe pkgs.nixd; # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixd
          # config.nixd = {
          #   nixpkgs.expr = "import (builtins.getFlake \"${dotfiles.path}\").inputs.nixpkgs { }";
          #   formatting.command = [ "${lib.getExe pkgs.alejandra}" ];
          #   options.nixos.expr = "(builtins.getFlake \"${dotfiles.path}\").nixosConfigurations.${dotfiles.hostname}.options";
          # }; # https://github.com/MrSom3body/dotfiles/blob/a547503e0d91fc66e4190b6fa4cf04644b5d7db2/home/editors/helix/languages.nix#L122-L126
        };
      };
    };
  };
}
