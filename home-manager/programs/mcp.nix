{ lib, pkgs, ... }:
{
  programs.mcp = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mcp.enable
    servers = {
      aks = {
        # nix eval --raw nixpkgs#aks-mcp-server.meta.mainProgram
        # nix eval --impure --raw --expr 'with import <nixpkgs> {}; lib.getExe aks-mcp-server'
        # $(nix eval --raw nixpkgs#aks-mcp-server.outPath)/bin/aks-mcp --version
        command = lib.getExe pkgs.aks-mcp-server;
        args = [
          "--log-level"
          "error"
          "--enabled-components"
          "az_cli,monitor,fleet,network,compute,detectors,advisor,inspektorgadget,kubectl,helm,cilium,hubble"
        ];
      };
      beads = {
        # https://github.com/steveyegge/beads/blob/main/docs/PLUGIN.md
        # Note: beads-mcp is a Python MCP server that wraps the bd Go CLI.
        # The BEADS_PATH env var tells it where to find the bd binary.
        # @upstream-issue https://github.com/anthropic-experimental/sandbox-runtime/issues/104
        # Cannot sandbox with srt on macOS: uv panics when SCDynamicStore is blocked.
        command = lib.getExe pkgs.uv;
        args = [
          "tool"
          "run"
          "--from"
          "beads-mcp"
          "beads-mcp"
        ];
        env = {
          BEADS_PATH = lib.getExe pkgs.beads;
        };
      };
      context7 = {
        url = "https://mcp.context7.com/mcp";
        headers = {
          CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
        };
      };
      # https://github.com/excalidraw/excalidraw-mcp
      excalidraw = {
        url = "https://mcp.excalidraw.com/mcp";
      };
      github = {
        command = lib.getExe pkgs.github-mcp-server;
        # https://github.com/github/github-mcp-server?tab=readme-ov-file#specifying-toolsets
        args = [
          "--toolsets"
          "default,stargazers"
          "stdio"
        ];
        env = {
          GITHUB_PERSONAL_ACCESS_TOKEN = "{env:GITHUB_MCP_SERVER_GITHUB_TOKEN}";
          # The GITHUB_TOOLSETS environment variable takes precedence over the command line argument if both are provided.
          GITHUB_TOOLSETS = "context,repos,issues,pull_requests,users,stargazers,actions,code_security";
        };
      };
      headroom = {
        # https://github.com/chopratejas/headroom
        # Context compression layer: 60–95% fewer tokens, same answers.
        # Compresses tool outputs, logs, files, and RAG chunks before they reach the LLM.
        #
        # MCP tools exposed:
        #   headroom_compress  — compress content on demand
        #   headroom_retrieve  — retrieve original (requires proxy; see below)
        #   headroom_stats     — show token savings stats
        #
        # Full CCR (Compress-Cache-Retrieve) requires the proxy running in a separate terminal:
        #   uvx --from headroom-ai headroom proxy --port 8787
        #
        # To wrap claude-code so all traffic is compressed automatically:
        #   uvx --from headroom-ai headroom wrap claude
        #
        # First-run install (downloads model + deps via uv, cached after):
        #   uvx --from "headroom-ai[mcp]" headroom mcp status
        command = lib.getExe pkgs.uv;
        args = [
          "tool"
          "run"
          "--python"
          "3.12"
          "--from"
          "headroom-ai[mcp]"
          "headroom"
          "mcp"
          "serve"
        ];
      };
      nixos = {
        # https://github.com/utensils/mcp-nixos
        # Using uvx for fast startup (no nix build delay).
        # @upstream-issue https://github.com/anthropic-experimental/sandbox-runtime/issues/104
        # Cannot sandbox with srt on macOS: uv panics when SCDynamicStore is blocked.
        command = lib.getExe pkgs.uv;
        args = [
          "tool"
          "run"
          "mcp-nixos"
        ];
      };
      playwright = {
        # https://github.com/microsoft/playwright-mcp
        # Using Nix package for fast startup (~0.02s vs 1.4s with npx).
        command = lib.getExe pkgs.playwright-mcp;
      };
      terraform = {
        command = lib.getExe pkgs.terraform-mcp-server;
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mcp.servers
  };
}
