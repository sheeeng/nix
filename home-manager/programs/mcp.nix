{ pkgs, ... }:
{
  programs.mcp = {
    enable = true;
    servers = {
      github = {
        command = "${pkgs.github-mcp-server}/bin/github-mcp-server"; # https://search.nixos.org/packages?channel=unstable&type=packages&show=github-mcp-server-0.14.0&query=github-mcp-server
        args = [ "stdio" ];
        env = {
          GITHUB_PERSONAL_ACCESS_TOKEN = "{env:GITHUB_TOKEN}";
        };
      };
    };
  };
}
