{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    terraform # https://search.nixos.org/packages?channel=unstable&type=packages&show=terraform
    terraform-ls # https://search.nixos.org/packages?channel=unstable&type=packages&show=terraform-ls
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
        # buffer-language-server = {
        #   command = "buffer-language-server";
        # };
        terraform-ls = {
          command = lib.getExe pkgs.terraform-ls; # "${pkgs.terraform-ls}/bin/terraform-ls";
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
