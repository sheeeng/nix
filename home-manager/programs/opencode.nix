{ pkgs, ... }:
{
  programs.opencode = {
    enable = pkgs.stdenv.system != "x86_64-darwin"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.enable # Disabled on x86_64-darwin.
    enableMcpIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.enableMcpIntegration
    package = pkgs.opencode; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.package
    agents = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.agents
    commands = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.commands
    rules = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.rules
    settings = {
      theme = "opencode";
      model = "anthropic/claude-sonnet-4-5";
      small_model = "anthropic/claude-haiku-4-5";
      autoshare = false;
      autoupdate = true;
      instructions = [
        "./github/copilot-instructions.md"
        ".cursor/rules/*.md"
        "AGENTS.md"
      ];

    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.settings
    skills = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.skills
    themes = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.themes
    tools = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.tools
  };
}
