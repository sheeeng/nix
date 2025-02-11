{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  buffer-language-server = pkgs.rustPlatform.buildRustPackage rec {
    pname = "buffer-language-server";
    version = "main";
    useFetchCargoVendor = true;

    src = pkgs.fetchFromGitHub {
      owner = "metafates";
      repo = "buffer-language-server";
      rev = "main";
      sha256 = "sha256-5q1dEkKRi8SYTvNyEND0S23xPeqV8b5C2Mm+0jLWIpA=";
    };

    cargoHash = "sha256-CERip5AzZvbF8BkEVq27nJraW0fnF3EgA39ot4RV2pA=";
  };
in
{
  home.packages = with pkgs-unstable; [
    # terraform # https://search.nixos.org/packages?channel=unstable&type=packages&show=terraform
    # terraform-ls # https://search.nixos.org/packages?channel=unstable&type=packages&show=terraform-ls
    buffer-language-server
  ];

  # https://github.com/helix-editor/helix/blob/master/languages.toml
  programs.helix = {
    languages = {
      language = [
        {
          name = "hcl";
          auto-format = true;
          language-id = "terraform";
          language-servers = [
            "terraform-ls"
            "buffer-language-server"
          ];
        }
        {
          name = "tfvars";
          auto-format = true;
          language-id = "terraform-vars";
          language-servers = [
            "terraform-ls"
            "buffer-language-server"
          ];
        }
      ];
      language-server = {
        buffer-language-server = {
          command = "${buffer-language-server}/bin/buffer-language-server";
        };
        terraform-ls = {
          command = lib.getExe pkgs-unstable.terraform-ls; # "${pkgs.terraform-ls}/bin/terraform-ls";
          args = [ "serve" ];
          filetypes = [
            "hcl"
            "tf"
            "tfvars"
          ];
        };
      };
    };
  };
}
