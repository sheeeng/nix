{ lib, pkgs, ... }:
let
  # Sandbox Runtime (srt) for sandboxing MCP servers.
  # Package defined in overlays/default.nix.
  # https://github.com/anthropic-experimental/sandbox-runtime#example-use-case-sandboxing-mcp-servers
  srt = lib.getExe pkgs.sandbox-runtime;
in
{
  programs.mcp = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mcp.enable
    servers = {
      aks = {
        # @upstream-issue https://github.com/NixOS/nixpkgs/issues/485105
        # nix eval --raw nixpkgs#aks-mcp-server.meta.mainProgram
        # nix eval --impure --raw --expr 'with import <nixpkgs> {}; lib.getExe aks-mcp-server'
        # $(nix eval --raw nixpkgs#aks-mcp-server.outPath)/bin/aks-mcp --version
        # Sandboxed with srt for filesystem and network restrictions.
        command = srt;
        args = [
          (lib.getExe pkgs.aks-mcp-server)
          "--log-level"
          "error"
        ];
      };
      beads = {
        # https://github.com/steveyegge/beads/blob/main/docs/PLUGIN.md
        # Note: beads-mcp is a Python MCP server that wraps the bd Go CLI.
        # The BEADS_PATH env var tells it where to find the bd binary.
        # Not sandboxed - srt blocks required filesystem/network access.
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
        # Sandboxed with srt for filesystem and network restrictions.
        command = srt;
        args = [
          (lib.getExe pkgs.github-mcp-server)
          "stdio"
        ];
        env = {
          GITHUB_PERSONAL_ACCESS_TOKEN = "{env:GITHUB_MCP_SERVER_GITHUB_TOKEN}";
        };
      };
      nixos = {
        # https://github.com/utensils/mcp-nixos
        # Using uvx for fast startup (no nix build delay).
        # Not sandboxed - srt blocks required filesystem/network access.
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
        # Not sandboxed - srt blocks required filesystem/network access.
        command = lib.getExe pkgs.playwright-mcp;
        args = [ ];
      };
      terraform = {
        # Sandboxed with srt for filesystem and network restrictions.
        command = srt;
        args = [
          (lib.getExe pkgs.terraform-mcp-server)
        ];
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mcp.servers
  };
}
