{
  programs.mcp = {
    enable = true;
    servers = {
      context7 = {
        url = "https://mcp.context7.com/mcp";
        headers = {
          CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
        };
      };
      github = {
        command = "docker";
        args = [
          "run"
          "-i"
          "--rm"
          "-e"
          "GITHUB_PERSONAL_ACCESS_TOKEN"
          "ghcr.io/github/github-mcp-server"
        ];
        env = {
          GITHUB_PERSONAL_ACCESS_TOKEN = "{env:GITHUB_MCP_SERVER_GITHUB_TOKEN}";
        };
      };
    };
  }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mcp.servers
}
