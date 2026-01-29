{ lib, pkgs, ... }:
{
  programs.mcp = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mcp.enable
    servers = {
      aks = {
        # TODO: See https://github.com/NixOS/nixpkgs/issues/485105 upstream issue.
        # nix eval --raw nixpkgs#aks-mcp-server.meta.mainProgram
        # nix eval --impure --raw --expr 'with import <nixpkgs> {}; lib.getExe aks-mcp-server'
        # $(nix eval --raw nixpkgs#aks-mcp-server.outPath)/bin/aks-mcp --version
        command = "${pkgs.aks-mcp-server}/bin/aks-mcp"; # https://search.nixos.org/packages?channel=unstable&type=packages&show=aks-mcp-server
        args = [
          "--log-level"
          "error"
        ];
      };
      context7 = {
        url = "https://mcp.context7.com/mcp";
        headers = {
          CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
        };
      };
      github = {
        command = lib.getExe pkgs.github-mcp-server; # https://search.nixos.org/packages?channel=unstable&type=packages&show=github-mcp-server
        args = [ "stdio" ];
        env = {
          GITHUB_PERSONAL_ACCESS_TOKEN = "{env:GITHUB_MCP_SERVER_GITHUB_TOKEN}";
        };
      };
      nixos = {
        command = "nix";
        args = [
          "run"
          "github:utensils/mcp-nixos"
          "--"
        ];
      };
      playwright = {
        command = "npx";
        args = [
          "@playwright/mcp@latest"
        ];
      };
      terraform = {
        command = lib.getExe pkgs.terraform-mcp-server; # https://search.nixos.org/packages?channel=unstable&type=packages&show=terraform-mcp-server
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mcp.servers
  };
}
