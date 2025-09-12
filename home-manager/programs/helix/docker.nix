{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    docker-compose # https://search.nixos.org/packages?channel=unstable&type=packages&show=docker-compose
    docker-compose-language-service # https://search.nixos.org/packages?channel=unstable&type=packages&show=docker-compose-language-service
    dockerfile-language-server-nodejs # https://search.nixos.org/packages?channel=unstable&type=packages&show=dockerfile-language-server-nodejs
  ];

  programs.helix = {
    languages = {
      language = [
        {
          name = "docker";
          language-servers = [ "docker-langserver" ];
        }
      ];
      language-server = {
        docker-langserver = {
          command = lib.getExe pkgs.dockerfile-language-server-nodejs; # https://search.nixos.org/packages?channel=unstable&type=packages&show=dockerfile-language-server-nodejs
          args = [ "--stdio" ];
        };
      };
    };
  };
}
