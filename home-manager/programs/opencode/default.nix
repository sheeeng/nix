{ pkgs, ... }:
{
  programs.opencode = {
    enable = true; # pkgs.stdenv.system != "x86_64-darwin"; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.enable # Disabled on x86_64-darwin.
    enableMcpIntegration = true; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.enableMcpIntegration
    package = pkgs.opencode; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.package
    agents = {
      # https://opencode.ai/docs/agents/#markdown
      build = ./agents/builder.md; # @upstream-issue https://github.com/anomalyco/opencode/issues/14094
      builder = ./agents/builder.md;
      chicken = ./agents/chicken.md;
      code-reviewer = ./agents/code-reviewer.md;
      explorer = ./agents/explorer.md;
      plan = ./agents/planner.md; # @upstream-issue https://github.com/anomalyco/opencode/issues/14094
      planner = ./agents/planner.md;
      security-auditor = ./agents/security-auditor.md;
      technical-writer = ./agents/technical-writer.md;
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.agents
    commands = {
      # https://opencode.ai/docs/commands/#markdown
      changelog = ./commands/changelog.md;
      commit = ./commands/commit.md;
      fix-issue = ./commands/fix-issue.md;
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.commands
    rules = ""; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.rules
    settings = {
      default_agent = "planner"; # https://opencode.ai/docs/config/#default-agent
      theme = "opencode";
      model = "github-copilot/claude-sonnet-4.5"; # opencode models
      small_model = "github-copilot/claude-haiku-4.5"; # opencode models
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
      git-commit = ./skills/git-commit.md;
      git-release = ./skills/git-release.md;
    }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.skills
    themes = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.themes
    tools = { }; # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.opencode.tools # Enables or disables specific tools globally.
  };
}
