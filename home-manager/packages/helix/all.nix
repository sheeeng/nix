{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [ ];

  programs.helix = lib.mkIf config.program.helix.enable {
    extra-packages = with pkgs; [
      nixpkgs-fmt
      nixpkgs-rfc-style
      nixd
      nil
    ];
    ignores = [ ".direnv/" ];
    languages = {
      language = [
        {
          name = "nix";
          auto-format = false;
          file-types = [ "nix" ];
          roots = [ "flake.lock" ];
          formatter = {
            command = "${pkgs.nixpkgs-rfc-style}/bin/nixpkgs-fmt";
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          language-server = "nixd";
          expect-features = [ "format" ];
        }
      ];
      language-server = {
        nil = {
          command = lib.getExe pkgs.nil; # https://search.nixos.org/packages?channel=unstable&type=packages&show=nil
          config = {
            format.trimTrailingWhitespace = true;
          };
        };
        nixd = {
          command = lib.getExe pkgs.nixd; # https://search.nixos.org/packages?channel=unstable&type=packages&show=nixd
          config = {
            format = {
              format.trimTrailingWhitespace = true;
            };
          };
        };
      };
    };
  };
}
