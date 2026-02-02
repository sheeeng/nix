{ lib, pkgs, ... }:
{
  programs.mcp = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mcp.enable
    servers = {
      aks = {
        # @upstream-issue https://github.com/NixOS/nixpkgs/issues/485105
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
      github = {
        command = lib.getExe pkgs.github-mcp-server;
        args = [
          "stdio"
        ];
        env = {
          GITHUB_PERSONAL_ACCESS_TOKEN = "{env:GITHUB_MCP_SERVER_GITHUB_TOKEN}";
        };
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
