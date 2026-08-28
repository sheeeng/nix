{ pkgs, ... }:
let
  buffer-language-server = pkgs.rustPlatform.buildRustPackage rec {
    pname = "buffer-language-server";
    version = "unstable-2023-07-24";

    src = pkgs.fetchFromGitHub {
      owner = "metafates";
      repo = "buffer-language-server";
      rev = "9419175abe59acec129d61c8cbe47a3ebfbce5b0";
      sha256 = "1412sqrd5gn9v11bxwcmx8yz2vabyk810wpk9scc92wi8895vbg6";
    };

    cargoHash = "sha256-CERip5AzZvbF8BkEVq27nJraW0fnF3EgA39ot4RV2pA=";
  };
in
{
  home.packages = [
    buffer-language-server
    pkgs.terraform
    pkgs.terraform-ls
  ];

  # https://github.com/helix-editor/helix/blob/master/languages.toml
  programs.helix = {
    languages = {
      language = [
        {
          name = "hcl";
          scope = "source.hcl";
          file-types = [
            "hcl"
            "tf"
          ];
          auto-format = true;
          language-id = "terraform";
          language-servers = [
            "terraform-ls"
            "buffer-language-server"
          ];
        }
        {
          name = "tfvars";
          scope = "source.hcl";
          file-types = [ "tfvars" ];
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
          command = "${pkgs.terraform-ls}/bin/terraform-ls";
          args = [ "serve" ];
        };
      };
    };
  };
}
