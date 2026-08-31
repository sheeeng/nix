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

  # Derive Copilot-compatible agent files by stripping OpenCode-only frontmatter
  # fields (mode, model, temperature) and preserving tool and permission
  # restrictions (tools, permission) so read-only reviewer agents retain their
  # access boundary in GitHub Copilot CLI. The prompt body is preserved exactly.
  # YAML block scalars (description: |) are preserved by continuing to emit
  # indented continuation lines until a non-indented key is encountered.
  toCopilotAgent =
    name: path:
    pkgs.runCommand "${name}.md" { } ''
      awk '
        BEGIN { in_front = 0; done = 0; in_desc = 0; in_block = 0 }
        /^---$/ {
          if (!in_front) { in_front = 1; print; next }
          if (!done) { done = 1; in_front = 0; in_desc = 0; in_block = 0; print; next }
        }
        in_front && !done {
          if (in_desc) {
            if (/^[[:space:]]/) { print; next }
            in_desc = 0
          }
          if (in_block) {
            if (/^[[:space:]]/) { print; next }
            in_block = 0
          }
          if (/^name: /) { print "name: ${name}"; next }
          if (/^description:/) { in_desc = 1; print; next }
          if (/^tools:/ || /^permission:/) { in_block = 1; print; next }
          if (/^mode: / || /^model: / || /^temperature: /) { next }
          next
        }
        { print }
      ' ${path} > $out
    '';

  copilotAgents = pkgs.lib.mapAttrs toCopilotAgent commonLlmSettings.agents;
in
{
  programs.github-copilot-cli = {
    enable = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.enable
    enableMcpIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.enableMcpIntegration
    package = pkgs.github-copilot-cli; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.package # https://search.nixos.org/packages?channel=unstable&type=packages&show=github-copilot-cli
    agents = copilotAgents; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.agents
    configDir =
      if config.home.preferXdgDirectories then
        "${config.xdg.configHome}/copilot"
      else
        "${config.home.homeDirectory}/.copilot"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.configDir
    context = commonLlmSettings.context; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.context
    lspServers = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.lspServers
    mcpServers = {
      github-copilot = {
        type = "http";
        url = "https://api.githubcopilot.com/mcp/";
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.mcpServers
    settings = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.settings
    skills = commonLlmSettings.skills; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.github-copilot-cli.skills
  };
}
