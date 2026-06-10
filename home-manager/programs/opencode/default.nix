{ pkgs, ... }:
let
  commonLlmSettings = import ../../llm/default.nix {
    inherit pkgs;
    basePath = ../../llm;
  };

  opencodeSuperpowersPlugin = "${commonLlmSettings.superpowersSrc}/.opencode/plugins/superpowers.js";
in
{
  # Place superpowers plugin so OpenCode discovers it at startup.
  # The plugin injects the using-superpowers skill into the system prompt
  # via the experimental.chat.system.transform hook.
  xdg.configFile."opencode/plugins/superpowers.js" = {
    source = opencodeSuperpowersPlugin;
  };

  programs.opencode = {
    enable = pkgs.stdenv.system != "x86_64-darwin"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.enable # Disabled on x86_64-darwin.
    enableMcpIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.enableMcpIntegration
    package = pkgs.opencode; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.package
    agents = commonLlmSettings.agents; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.agents # https://opencode.ai/docs/agents/#markdown
    commands = commonLlmSettings.commands; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.commands # https://opencode.ai/docs/commands/#markdown
    context = ./context.md; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.context
    tui = {
      theme = "opencode";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.tui
    settings = {
      agent = {
        build = {
          disable = true;
        };
        explore = {
          disable = true;
        };
        general = {
          disable = true;
        };
        plan = {
          disable = true;
        };
      }; # https://opencode.ai/docs/config/#agent
      default_agent = "planner"; # https://opencode.ai/docs/config/#default-agent
      model = "github-copilot/claude-opus-4.6"; # https://models.dev/?search=github-copilot
      small_model = "github-copilot/claude-haiku-4.5"; # https://models.dev/?search=github-copilot
      autoshare = false;
      autoupdate = true;
      permission = {
        bash = {
          "curl *man7.org/linux/man-pages/*" = "allow";
          "curl *nix-community.github.io*" = "allow";
          "curl *nix.dev*" = "allow";
          "curl *nixos.wiki*" = "allow";
          "curl *wiki.nixos.org*" = "allow";
        };
      };
      instructions = [
        "AGENTS.md"
      ];
      formatter = import ./formatter.nix; # # https://opencode.ai/docs/formatters/
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.settings
    skills = {
      # https://opencode.ai/docs/skills/
      beads = "${pkgs.beads.src}/claude-plugin/skills/beads"; # A skill can also be a subdirectory within a Nix package source store path.
      find-skills = "${commonLlmSettings.vercelSkillsSrc}/skills/find-skills";
      frontend-design = "${commonLlmSettings.anthropicSkillsSrc}/skills/frontend-design";
      apply-owasp-security = commonLlmSettings.skills.apply-owasp-security;
      upsert-git-commit = commonLlmSettings.skills.upsert-git-commit;
      upsert-github-pull-request = commonLlmSettings.skills.upsert-github-pull-request;
      upsert-github-release = commonLlmSettings.skills.upsert-github-release;
      superpowers-brainstorming = "${commonLlmSettings.superpowersSrc}/skills/brainstorming";
      superpowers-dispatching-parallel-agents = "${commonLlmSettings.superpowersSrc}/skills/dispatching-parallel-agents";
      superpowers-executing-plans = "${commonLlmSettings.superpowersSrc}/skills/executing-plans";
      superpowers-finishing-a-development-branch = "${commonLlmSettings.superpowersSrc}/skills/finishing-a-development-branch";
      superpowers-receiving-code-review = "${commonLlmSettings.superpowersSrc}/skills/receiving-code-review";
      superpowers-requesting-code-review = "${commonLlmSettings.superpowersSrc}/skills/requesting-code-review";
      superpowers-subagent-driven-development = "${commonLlmSettings.superpowersSrc}/skills/subagent-driven-development";
      superpowers-systematic-debugging = "${commonLlmSettings.superpowersSrc}/skills/systematic-debugging";
      superpowers-test-driven-development = "${commonLlmSettings.superpowersSrc}/skills/test-driven-development";
      superpowers-using-git-worktrees = "${commonLlmSettings.superpowersSrc}/skills/using-git-worktrees";
      superpowers-using-superpowers = "${commonLlmSettings.superpowersSrc}/skills/using-superpowers";
      superpowers-verification-before-completion = "${commonLlmSettings.superpowersSrc}/skills/verification-before-completion";
      superpowers-writing-plans = "${commonLlmSettings.superpowersSrc}/skills/writing-plans";
      superpowers-writing-skills = "${commonLlmSettings.superpowersSrc}/skills/writing-skills";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.skills
    themes = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.themes
    tools = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.tools # Enables or disables specific tools globally.
  };
}
