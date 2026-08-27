{
  config,
  inputs,
  pkgs,
  ...
}:
let
  commonLlmSettings = import ../llm/default.nix {
    inherit pkgs;
    basePath = ../llm;
    mattPocockSkillsSource = inputs.matt-pocock-skills;
  };
in
{
  programs.github-copilot-cli = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.enable
    enableMcpIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.enableMcpIntegration
    package = pkgs.github-copilot-cli; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.package # https://search.nixos.org/packages?channel=unstable&type=packages&show=github-copilot-cli
    agents = commonLlmSettings.agents; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.agents
    configDir =
      if config.home.preferXdgDirectories then
        "${config.xdg.configHome}/copilot"
      else
        "${config.home.homeDirectory}/.copilot"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.configDir
    context = commonLlmSettings.context; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.context
    lspServers = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.lspServers
    mcpServers = {
      github = {
        type = "http";
        url = "https://api.githubcopilot.com/mcp/";
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.mcpServers
    settings = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.settings
    skills = commonLlmSettings.skills; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.skills
  };
}
