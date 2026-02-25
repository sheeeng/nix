{ pkgs, ... }:
let
  # obra/superpowers: A complete software development workflow for coding agents.
  # https://github.com/obra/superpowers
  superpowersSrc = pkgs.fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    rev = "v4.3.1"; # 151ac79ccac12d769356da93e6e0513ae736fa13
    hash = "sha256-/3T9haaI5x7wVLAy+z8NzaH5hI1qvIa2nTKq91jNNXA=";
  };

  # anthropics/skills: Skills for Claude.
  # https://github.com/anthropics/skills
  anthropicSkillsSrc = pkgs.fetchFromGitHub {
    owner = "anthropics";
    repo = "skills";
    rev = "3d59511518591fa82e6cfcf0438d68dd5dad3e76";
    hash = "sha256-mZZ0rlj/kju7we1h+MvUjgFAVjcZ/qKkMbNZfhfCSvk=";
  };

  # vercel-labs/skills: Open agent skills ecosystem.
  # https://github.com/vercel-labs/skills
  vercelSkillsSrc = pkgs.fetchFromGitHub {
    owner = "vercel-labs";
    repo = "skills";
    rev = "v1.4.1"; # e00ad19cd60863bebbbd944a7035b42cfebd8bae
    hash = "sha256-6r9qCk96/1Ygrg2QuXUpZy5bPiCAO23GhPRqcg4hUQg=";
  };
in
{
  # Place superpowers plugin so OpenCode discovers it at startup.
  # The plugin injects the using-superpowers skill into the system prompt
  # via the experimental.chat.system.transform hook.
  xdg.configFile."opencode/plugins/superpowers.js" = {
    source = "${superpowersSrc}/.opencode/plugins/superpowers.js";
  };

  programs.opencode = {
    enable = true; # pkgs.stdenv.system != "x86_64-darwin"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.enable # Disabled on x86_64-darwin.
    enableMcpIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.enableMcpIntegration
    package = pkgs.opencode; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.package
    agents = {
      # https://opencode.ai/docs/agents/#markdown
      build = null; # ./agents/builder.md; # @upstream-issue https://github.com/anomalyco/opencode/issues/14094
      builder = ./agents/builder.md;
      chicken = ./agents/chicken.md;
      code-reviewer = ./agents/code-reviewer.md;
      explorer = ./agents/explorer.md;
      plan = null; # ./agents/planner.md; # @upstream-issue https://github.com/anomalyco/opencode/issues/14094
      planner = ./agents/planner.md;
      security-auditor = ./agents/security-auditor.md;
      superpowers-code-reviewer = "${superpowersSrc}/agents/code-reviewer.md";
      technical-writer = ./agents/technical-writer.md;
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.agents
    commands = {
      # https://opencode.ai/docs/commands/#markdown
      brainstorm = "${superpowersSrc}/commands/brainstorm.md";
      changelog = ./commands/changelog.md;
      commit = ./commands/commit.md;
      execute-plan = "${superpowersSrc}/commands/execute-plan.md";
      fix-issue = ./commands/fix-issue.md;
      implement = ./commands/implement.md;
      plan = ./commands/plan.md;
      research = ./commands/research.md;
      write-plan = "${superpowersSrc}/commands/write-plan.md";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.commands
    rules = "./rules.md"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.rules
    settings = {
      agent = {
        build = {
          disable = true; # @upstream-issue https://github.com/anomalyco/opencode/issues/9822
        };
        explore = {
          disable = true; # @upstream-issue https://github.com/anomalyco/opencode/issues/9822
        };
        general = {
          disable = true; # @upstream-issue https://github.com/anomalyco/opencode/issues/9822
        };
        plan = {
          disable = true; # @upstream-issue https://github.com/anomalyco/opencode/issues/9822
        };
      }; # https://opencode.ai/docs/config/#agent
      default_agent = "planner"; # https://opencode.ai/docs/config/#default-agent
      theme = "opencode";
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
      # https://opencode.ai/docs/formatters/
      formatter = {
        css = {
          command = [
            "nix"
            "run"
            "nixpkgs#nodePackages.prettier"
            "--"
            "--parser"
            "css"
            "--write"
            "$FILE"
          ];
          extensions = [ ".css" ];
        };
        html = {
          command = [
            "nix"
            "run"
            "nixpkgs#nodePackages.prettier"
            "--"
            "--parser"
            "html"
            "--write"
            "$FILE"
          ];
          extensions = [ ".html" ];
        };
        javascript = {
          command = [
            "nix"
            "run"
            "nixpkgs#nodePackages.prettier"
            "--"
            "--parser"
            "babel"
            "--write"
            "$FILE"
          ];
          extensions = [
            ".js"
            ".jsx"
          ];
        };
        json = {
          command = [
            "nix"
            "run"
            "nixpkgs#nodePackages.prettier"
            "--"
            "--parser"
            "json"
            "--write"
            "$FILE"
          ];
          extensions = [
            ".json"
            ".jsonc"
          ];
        };
        markdown = {
          command = [
            "nix"
            "run"
            "nixpkgs#nodePackages.prettier"
            "--"
            "--parser"
            "markdown"
            "--write"
            "$FILE"
          ];
          extensions = [ ".md" ];
        };
        nix = {
          command = [
            "nix"
            "run"
            "nixpkgs#nixfmt"
            "--"
            "$FILE"
          ];
          extensions = [ ".nix" ];
        };
        python = {
          command = [
            "nix"
            "run"
            "nixpkgs#ruff"
            "--"
            "format"
            "$FILE"
          ];
          extensions = [
            ".py"
            ".pyi"
          ];
        };
        rust = {
          command = [
            "nix"
            "run"
            "nixpkgs#rustfmt"
            "--"
            "$FILE"
          ];
          extensions = [ ".rs" ];
        };
        shell = {
          command = [
            "nix"
            "run"
            "nixpkgs#shfmt"
            "--"
            "--indent"
            "2"
            "--write"
            "$FILE"
          ];
          extensions = [
            ".sh"
            ".bash"
            ".bats"
          ];
        };
        terraform = {
          command = [
            "nix"
            "run"
            "nixpkgs#opentofu"
            "--"
            "fmt"
            "$FILE"
          ];
          extensions = [
            ".tf"
            ".tfvars"
          ];
        };
        toml = {
          command = [
            "nix"
            "run"
            "nixpkgs#taplo"
            "--"
            "fmt"
            "$FILE"
          ];
          extensions = [ ".toml" ];
        };
        typescript = {
          command = [
            "nix"
            "run"
            "nixpkgs#nodePackages.prettier"
            "--"
            "--parser"
            "typescript"
            "--write"
            "$FILE"
          ];
          extensions = [
            ".ts"
            ".tsx"
          ];
        };
        yaml = {
          command = [
            "nix"
            "run"
            "nixpkgs#yamlfmt"
            "--"
            "$FILE"
          ];
          extensions = [
            ".yaml"
            ".yml"
          ];
        };
      };
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.settings
    skills = {
      # https://opencode.ai/docs/skills/
      beads = "${pkgs.beads.src}/claude-plugin/skills/beads"; # A skill can also be a subdirectory within a Nix package source store path.
      find-skills = "${vercelSkillsSrc}/skills/find-skills";
      frontend-design = "${anthropicSkillsSrc}/skills/frontend-design";
      git-commit = ./skills/git-commit.md;
      git-release = ./skills/git-release.md;
      superpowers-brainstorming = "${superpowersSrc}/skills/brainstorming";
      superpowers-dispatching-parallel-agents = "${superpowersSrc}/skills/dispatching-parallel-agents";
      superpowers-executing-plans = "${superpowersSrc}/skills/executing-plans";
      superpowers-finishing-a-development-branch = "${superpowersSrc}/skills/finishing-a-development-branch";
      superpowers-receiving-code-review = "${superpowersSrc}/skills/receiving-code-review";
      superpowers-requesting-code-review = "${superpowersSrc}/skills/requesting-code-review";
      superpowers-subagent-driven-development = "${superpowersSrc}/skills/subagent-driven-development";
      superpowers-systematic-debugging = "${superpowersSrc}/skills/systematic-debugging";
      superpowers-test-driven-development = "${superpowersSrc}/skills/test-driven-development";
      superpowers-using-git-worktrees = "${superpowersSrc}/skills/using-git-worktrees";
      superpowers-using-superpowers = "${superpowersSrc}/skills/using-superpowers";
      superpowers-verification-before-completion = "${superpowersSrc}/skills/verification-before-completion";
      superpowers-writing-plans = "${superpowersSrc}/skills/writing-plans";
      superpowers-writing-skills = "${superpowersSrc}/skills/writing-skills";
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.skills
    themes = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.themes
    tools = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.tools # Enables or disables specific tools globally.
  };
}
