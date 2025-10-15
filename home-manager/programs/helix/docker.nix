{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    docker-compose # https://search.nixos.org/packages?channel=unstable&type=packages&show=docker-compose
    docker-compose-language-service # https://search.nixos.org/packages?channel=unstable&type=packages&show=docker-compose-language-service
    dockerfile-language-server # https://search.nixos.org/packages?channel=unstable&type=packages&show=dockerfile-language-server
  ];

  programs.helix = {
    languages = {
      language = [
        {
          name = "docker";
          scope = "source.dockerfile";
          file-types = [
            "dockerfile"
            "Dockerfile"
          ];
          language-servers = [ "docker-langserver" ];
        }
      ];
      language-server = {
        docker-langserver = {
          command = lib.getExe pkgs.dockerfile-language-server; # https://search.nixos.org/packages?channel=unstable&type=packages&show=dockerfile-language-server
          args = [ "--stdio" ];
        };
      };
    };
  };
}
