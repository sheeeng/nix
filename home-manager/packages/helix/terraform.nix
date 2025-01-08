# https://github.com/tommy-donavon/nixos-dots/blob/d824d5ec55109f65f0bc5e042198cafde0fbedc8/modules/home/programs/terminal/editors/helix/nix.nix

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    terraform
    terraform-ls
  ];

  programs.helix.languages = {
    language-server.terraform-ls = {
      args = [ "serve" ];
      command = "${pkgs.terraform-ls}/bin/terraform-ls";
    };
  };
}
