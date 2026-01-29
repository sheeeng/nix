{ pkgs, ... }:
{
  programs.mcp = {
    enable = true;
    servers = {
      github = {
        command = "${pkgs.github-mcp-server}/bin/github-mcp-server";
        args = [ "stdio" ];
        env = {
          GITHUB_PERSONAL_ACCESS_TOKEN = "{env:GITHUB_TOKEN}";
        };
      };
    };
  };
}
